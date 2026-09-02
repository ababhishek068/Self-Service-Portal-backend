import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import {
  callSoapMethod,
  fetchOData,
  fetchODataFirstBase,
  odataString,
  type ODataRecord,
} from './bcClient.js'
import { approvalTableFilter, type ApprovalTableKey } from './approvalTableIds.js'
import { requireAuth } from './auth.js'
import type { AuthUser } from './auth.js'
import { fetchEmployeeCustomerAccountNo, ensureEmployeeDepartmentCodeForFinance, resolveFinanceDepartmentCodeForSoap, resolveRequestingDepartmentCode } from './employeeProfile.js'
import { formatBcSoapDate, isErpWorkingDate } from './staff.js'
import { documentSentForApproval, resolveModuleRequestStatus, type PortalModuleKey } from './erpMappings.js'
import { sortNewestFirst } from './sortNewestFirst.js'
import {
  canRequestApprovalForSpec,
  requestApprovalBlockedMessage,
} from './requestWorkflow.js'

/* -------------------------------------------------------------------------- */
/* Module spec                                                                */
/* -------------------------------------------------------------------------- */

interface SoapResult {
  returnValue: string | null
  raw: string
}

const MAX_ATTACHMENT_BYTES = 10_000_000
const ALLOWED_ATTACHMENT_EXTENSIONS = new Set(['pdf', 'doc', 'docx', 'jpg', 'png'])

type ParamBuilder = (input: { req: Request; user: AuthUser; no: string }) =>
  | Record<string, unknown>
  | Promise<Record<string, unknown>>

/**
 * Declarative description of a Self-Service request module so we don't
 * duplicate identical-looking routers eleven times.
 *
 * Mirrors the controllers in `/Users/abhishekbehera/ess/app/Http/Controllers/Staff/`.
 */
export interface ModuleSpec {
  /** URL segment under `/api/staff/`. */
  module: string
  /** OData service for the header rows. */
  headerService: string
  /** Business Central header table ID (used for attachment & approval lookups). */
  headerTableId: number
  /** OData field used to filter the list by current user (e.g. `EmployeeNo`). */
  ownerField:
    | 'EmployeeNo'
    | 'UserID'
    | 'AssignedUserID'
    | 'Requested_By'
    | 'RequesterID'
    | 'Employee_No'
    | 'CustomerNo'
  /** Which session field feeds `ownerField` — defaults match Laravel. */
  ownerSource: 'employeeNo' | 'userID' | 'imprestNo'
  /** ESS intentionally lists these rows without an employee filter. */
  unscopedList?: boolean
  /** Primary key field on the header row (defaults to `No`). */
  headerKey?: string
  /** Optional extra clause appended to the list filter (e.g. doc-type filter). */
  extraListFilter?: string
  /** ESS often cannot filter shared OData pages by type; apply after fetch. */
  postListFilter?: (row: ODataRecord) => boolean
  /** OData service holding line rows (omit if module has no lines). */
  lineService?: string
  lineFallbackServices?: string[]
  /** OData field linking lines to the header (e.g. `No`, `RequistionNo`, …). */
  lineHeaderField?: string

  /** SOAP methods used to mutate the document. */
  soap: {
    saveHeader?: string
    saveLine?: string
    deleteLine?: string
    /** Permanently delete an Open/Pending/New draft header (DeletePortalDraftDocument). */
    deleteDocument?: string
    submit?: string
    cancel?: string
  }

  /** Per-module SOAP parameter builders. */
  params?: {
    saveHeader?: ParamBuilder
    saveLine?: ParamBuilder
    deleteLine?: ParamBuilder
    deleteDocument?: ParamBuilder
    submit?: ParamBuilder
    cancel?: ParamBuilder
  }

  /** Some modules (Transfer Order) reuse one SOAP for both submit and cancel. */
  decideMode?: 'submitCancelOnSameMethod'
  /** Default `myAction` value used by `decideMode` SOAP methods. */
  decideMethodKey?: string
  /** Some legacy ESS header methods return only true/false; resolve the generated number through OData. */
  headerReturnsBoolean?: boolean
  /** ESS exposes UploadDocumentAttachment only for a subset of modules (imprest, claim, petty cash, …). */
  supportsAttachments?: boolean
}

const SCHEMAS = {
  saveHeader: z.object({}).passthrough(),
  saveLine: z.object({}).passthrough(),
  deleteLine: z.object({}).passthrough(),
}

function draftDeleteParams(moduleCode: string): ParamBuilder {
  return ({ user, no }) => ({
    employeeNo: user.employeeNo,
    requisitionNo: no,
    moduleCode,
  })
}

function ok(result: SoapResult) {
  if (result.returnValue == null) return false
  const v = String(result.returnValue).trim().toLowerCase()
  return !!v && v !== 'false' && v !== '0'
}

/** ESS controllers treat approval actions as successful only when `return_value == true`. */
function approvalOk(result: SoapResult) {
  const v = String(result.returnValue ?? '').trim().toLowerCase()
  return v === 'true' || v === '1'
}

function soapActionOk(spec: ModuleSpec, result: SoapResult) {
  if (
    spec.decideMode === 'submitCancelOnSameMethod' ||
    spec.module === 'salary-advance' ||
    spec.module === 'fuel' ||
    spec.module === 'maintenance' ||
    spec.module === 'store-requisition' ||
    spec.module === 'purchase-requisition' ||
    spec.module === 'claim' ||
    spec.module === 'petty-cash' ||
    spec.module === 'imprest' ||
    spec.module === 'imprest-surrender'
  ) {
    return approvalOk(result)
  }
  return ok(result)
}

const REC_ID_HEADER_MODULES = new Set(['fuel', 'maintenance', 'salary-advance'])

async function resolveRecIdHeaderEditBody(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  body: Record<string, unknown>,
) {
  if (!no || !REC_ID_HEADER_MODULES.has(spec.module)) return body
  const document = await getPortalModuleDocument(spec, user, no)
  const recId = document?.SystemId ?? document?.SystemID
  if (!recId) {
    throw Object.assign(new Error(`Business Central SystemId was not found for ${no}`), {
      status: 502,
    })
  }
  return { ...body, recId: String(recId) }
}

function safe(handler: (req: Request, res: Response) => Promise<unknown>) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await handler(req, res)
    } catch (error) {
      next(error)
    }
  }
}

function authUser(req: Request) {
  const user = req.session.authUser
  if (!user) throw Object.assign(new Error('Unauthenticated'), { status: 401 })
  return user
}

function numericCode(
  value: unknown,
  labels: Record<string, number>,
  fallback = 0,
) {
  const raw = String(value ?? '').trim()
  if (/^\d+$/.test(raw)) return Number(raw)
  return labels[raw.toLowerCase()] ?? fallback
}

function fieldText(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

export type GatePassSourceKey = 'storeIssue' | 'transferOrder' | 'assetTransfer'

export const GATE_PASS_SOURCE_SPECS: Record<
  GatePassSourceKey,
  {
    label: string
    linkTo: string
    lineService: string
    lineHeaderField: string
    scopeToEmployee: boolean
  }
> = {
  storeIssue: {
    label: 'Gate Pass Store Requisitions',
    linkTo: 'Store Issue',
    lineService: 'QyStoreRequisitionLines',
    lineHeaderField: 'RequistionNo',
    scopeToEmployee: true,
  },
  transferOrder: {
    label: 'Transfer Order Requisitions',
    linkTo: 'Transfer Order',
    lineService: 'QyTransferShipmentLine',
    lineHeaderField: 'DocumentNo',
    scopeToEmployee: false,
  },
  assetTransfer: {
    label: 'Asset Transfer Requisitions',
    linkTo: 'Asset Transfer',
    lineService: 'QyTransferShipmentLine',
    lineHeaderField: 'DocumentNo',
    scopeToEmployee: false,
  },
}

function normalizedGatePassSource(value: unknown): GatePassSourceKey {
  const raw = String(value ?? '').trim().toLowerCase()
  const compact = raw.replace(/[^a-z]/g, '')
  if (compact === 'transferorder' || compact === 'transferorders') return 'transferOrder'
  if (compact === 'assettransfer' || compact === 'assettransfers') return 'assetTransfer'
  return 'storeIssue'
}

export function gatePassSourceFromQuery(value: unknown): GatePassSourceKey {
  return normalizedGatePassSource(value)
}

export function gatePassSourceFromRow(row: ODataRecord): GatePassSourceKey {
  return normalizedGatePassSource(fieldText(row, ['Linkto', 'LinkTo', 'Link_To']))
}

export function gatePassListFilterParts(source: GatePassSourceKey, user: AuthUser) {
  const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
  const filters = [`Linkto eq '${odataString(sourceSpec.linkTo)}'`]
  if (sourceSpec.scopeToEmployee) {
    filters.unshift(`EmployeeNo eq '${odataString(user.employeeNo)}'`)
  }
  return filters
}

export function gatePassLineBinding(row: ODataRecord, fallbackNo: string) {
  const source = gatePassSourceFromRow(row)
  const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
  return {
    source,
    lineService: sourceSpec.lineService,
    lineHeaderField: sourceSpec.lineHeaderField,
    documentNo: fieldText(row, ['TransferNo', 'Transfer_No'], fallbackNo),
  }
}

function normalizeBcTime(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw) return ''
  if (/^\d{2}:\d{2}:\d{2}$/.test(raw)) return raw
  if (/^\d{2}:\d{2}$/.test(raw)) return `${raw}:00`
  return raw
}

/**
 * `RequestGatePassApproval`/`CancelGatePassApproval` key on both Gate Pass No.
 * and Transfer No — but submit/cancel calls from the portal only carry the
 * request id, never the source document number. Look it up from BC instead of
 * relying on a request body field that is never populated.
 */
async function gatePassTransferNo(no: string): Promise<string> {
  try {
    const rows = (await fetchOData('QyGatePass', {
      $filter: `GatePassNo eq '${odataString(no)}'`,
      $top: 1,
    })) as ODataRecord[] | null
    if (Array.isArray(rows) && rows[0]) {
      return fieldText(rows[0], ['TransferNo', 'Transfer_No'])
    }
  } catch {
    // fall through to blank — the SOAP call will surface a clear BC error
  }
  return ''
}

function storeLineTypeCode(value: unknown) {
  return numericCode(value, { item: 1, asset: 2 })
}

function storePriorityCode(value: unknown) {
  return numericCode(value, { low: 0, normal: 1, high: 2, urgent: 3 })
}

/**
 * Purchase requests use the latest ABH three-level scale. Keep this separate
 * from Store Requisition's legacy Low/Normal/High/Urgent option mapping.
 */
export function purchasePriorityCode(value: unknown) {
  const raw = String(value ?? '').trim().toLowerCase()
  if (/^\d+$/.test(raw)) {
    const numeric = Number(raw)
    if (numeric >= 0 && numeric <= 3) return numeric
  }
  const mapped: Record<string, number> = {
    normal: 1,
    critical: 2,
    urgent: 3,
    // Accept old saved drafts without making these legacy labels visible in
    // the new form.
    low: 0,
    high: 2,
  }
  if (raw in mapped) return mapped[raw]!
  throw Object.assign(new Error('Priority must be Normal, Urgent, or Critical.'), {
    status: 422,
    code: 'INVALID_PURCHASE_PRIORITY',
  })
}

function storeHeaderRequestTypeCode(value: unknown) {
  return numericCode(value, { item: 0, asset: 1, 'minor asset': 1 })
}

function purchaseLineTypeCode(value: unknown) {
  return numericCode(value, { service: 1, item: 2, asset: 4, goods: 2 })
}

/** Return a master number only when the supplied name has one unambiguous exact match. */
export function uniqueExactMasterNoByName(rows: ODataRecord[], name: string) {
  const wanted = name.trim().toLocaleLowerCase()
  if (!wanted) return ''
  const matchingNumbers = new Set(
    rows
      .filter((row) => fieldText(row, ['Description', 'Name']).trim().toLocaleLowerCase() === wanted)
      .map((row) => fieldText(row, ['No', 'No_']).trim())
      .filter(Boolean),
  )
  return matchingNumbers.size === 1 ? [...matchingNumbers][0]! : ''
}

async function resolvePurchaseMasterNoByName(typeCode: number, itemName: string) {
  const service = typeCode === 2 ? 'QyItem' : typeCode === 4 ? 'QyFixedAssets' : ''
  if (!service || !itemName.trim()) return ''
  const rows = (await fetchOData(service, {
    $select: 'No,Description',
    $top: 1000,
  }).catch(() => [])) as ODataRecord[] | null
  return uniqueExactMasterNoByName(Array.isArray(rows) ? rows : [], itemName)
}

function purchaseRequestTypeCode(value: unknown) {
  const raw = String(value ?? '').trim().toLowerCase()
  if (/^\d+$/.test(raw)) {
    const numeric = Number(raw)
    if (numeric >= 0 && numeric <= 4) return numeric
  }
  const mapped: Record<string, number> = {
    goods: 0,
    service: 1,
    services: 1,
    asset: 2,
    consultancy: 3,
    other: 4,
    item: 0,
  }
  if (raw in mapped) return mapped[raw]!
  throw Object.assign(
    new Error('Purchase Type must be Goods, Services, Consultancy, or Other.'),
    { status: 422, code: 'INVALID_PURCHASE_TYPE' },
  )
}

export function parsePurchaseOtherRequirements(value: unknown) {
  const raw = String(value ?? '').trim()
  const match = /^Purchase type:\s*([^|\r\n]+?)(?:\s*\|\s*([\s\S]*))?$/i.exec(raw)
  return {
    otherPurchaseType: match?.[1]?.trim() ?? '',
    otherRequirements: match ? String(match[2] ?? '').trim() : raw,
  }
}

function purchaseOtherRequirementsForSoap(
  purchaseRequestType: string,
  otherPurchaseTypeValue: unknown,
  otherRequirementsValue: unknown,
) {
  const existing = parsePurchaseOtherRequirements(otherRequirementsValue)
  if (purchaseRequestType !== 'other') return existing.otherRequirements.slice(0, 250)
  const otherPurchaseType = String(otherPurchaseTypeValue ?? '').trim()
  if (!otherPurchaseType) {
    throw Object.assign(new Error('Describe the purchase type when Purchase Type is Other.'), {
      status: 422,
      code: 'OTHER_PURCHASE_TYPE_REQUIRED',
    })
  }
  return [
    `Purchase type: ${otherPurchaseType.slice(0, 100)}`,
    existing.otherRequirements,
  ]
    .filter(Boolean)
    .join(' | ')
    .slice(0, 250)
}

function transportRequestTypeCode(value: unknown) {
  return numericCode(value, { city: 0, 'field trip': 1, field: 1 })
}

export function hospitalCategoryCode(value: unknown) {
  // BC OptionMembers on Staff Claim Lines: Government=0, Private=1, Outline=2.
  const raw = String(value ?? '').trim().toLowerCase()
  const byLabel: Record<string, number> = {
    government: 0,
    govt: 0,
    private: 1,
    'non-government': 1,
    'non govt': 1,
    outline: 2,
    online: 2,
  }
  if (raw in byLabel) return byLabel[raw]!
  if (/^\d+$/.test(raw)) {
    const n = Number(raw)
    if (n >= 0 && n <= 2) return n
    // Legacy 1-based portal values (1=Govt, 2=Private, 3=Outline).
    if (n === 1) return 0
    if (n === 2) return 1
    if (n === 3) return 2
  }
  return 0
}

async function lookupClaimTypeGlAccount(claimType: string) {
  const code = claimTypeCode(claimType)
  if (!code) return ''
  try {
    const rows = (await fetchOData('QyReceiptsPayments', {
      $filter: `Code eq '${odataString(code)}' and Type eq 'Claim'`,
      $top: 1,
    })) as ODataRecord[] | null
    const row = Array.isArray(rows) ? rows[0] : undefined
    if (!row) return ''
    for (const key of [
      'GLAccount',
      'GL_Account',
      'G_L_Account',
      'GLAccountNo',
      'GL_Account_No',
      'G_L_Account_No',
      'AccountNo',
      'Account_No',
    ]) {
      const value = String(row[key] ?? '').trim()
      if (value) return value
    }
  } catch {
    // BC lookup unavailable — frontend should have sent accountNo
  }
  return ''
}

export function isOtherClaimType(value: unknown) {
  return claimTypeCode(value).toUpperCase() === 'OTHER'
}

export function passengerTypeCode(value: unknown) {
  const raw = String(value ?? '').trim()
  const compact = raw.toLowerCase()
  if (compact === 'internal' || compact === 'staff') return 'Staff'
  if (compact === 'external') return 'External'
  return raw
}

function claimTypeCode(value: unknown) {
  const raw = String(value ?? '').trim()
  return raw.toLowerCase().includes('medical') ? 'MEDICAL' : raw
}

export function isMedicalClaimType(value: unknown) {
  return claimTypeCode(value) === 'MEDICAL'
}

/* -------------------------------------------------------------------------- */
/* Module specs                                                               */
/* -------------------------------------------------------------------------- */

/**
 * Imprest Requisition — `App\Http\Controllers\Staff\ImprestsController`.
 *
 * SOAP: ImprestRequisitionHeader / ImprestRequisitionLine /
 *       DeleteImprestLine / RequestImprestApproval / CancelImprestRequisition
 */
const imprest: ModuleSpec = {
  module: 'imprest',
  headerService: 'QyImprestHeader',
  headerTableId: 50891,
  supportsAttachments: true,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  lineService: 'QyImprestLines',
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'ImprestRequisitionHeader',
    saveLine: 'ImprestRequisitionLine',
    deleteLine: 'DeleteImprestLine',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestImprestApproval',
    cancel: 'CancelImprestRequisition',
  },
  params: {
    deleteDocument: draftDeleteParams('imprest'),
    saveHeader: ({ req, user, no }) => {
      const travelDate = formatBcSoapDate(
        String(req.body?.travelDate ?? req.body?.startDate ?? ''),
      )
      let returnDate = formatBcSoapDate(String(req.body?.returnDate ?? ''))
      if (travelDate && (!returnDate || returnDate <= travelDate)) {
        const next = new Date(`${travelDate}T12:00:00`)
        next.setDate(next.getDate() + 1)
        returnDate = `${next.getFullYear()}-${String(next.getMonth() + 1).padStart(2, '0')}-${String(next.getDate()).padStart(2, '0')}`
      }
      return {
        action: no ? 'edit' : 'create',
        docNo: no,
        employeeNo: user.employeeNo,
        dateRequired: formatBcSoapDate(
          String(req.body?.dateRequired ?? req.body?.startDate ?? ''),
        ),
        purpose: req.body?.purpose ?? '',
        myUserId: user.userID,
        travelDestination: req.body?.travelDestination ?? req.body?.placeOfDuty ?? '',
        travelDate,
        returnDate,
      }
    },
    saveLine: async ({ req, user, no }) => {
      const advanceType = String(req.body?.advanceType ?? req.body?.expenseType ?? '').trim()
      const destination = String(req.body?.destination ?? req.body?.description ?? '').trim()
      const noOfDays = Number(req.body?.noOfDays ?? 0)
      let amount = Number(req.body?.amount ?? 0)

      if (amount <= 0 && advanceType && destination && noOfDays > 0) {
        try {
          const result = await callSoapMethod('FetchImprestLineAmount', {
            headerNo: no,
            noOfDays,
            advanceType,
            destinationCode: destination,
          })
          amount = Number(result.returnValue ?? 0)
        } catch {
          // Fall through — BC will reject with a clearer message if still zero.
        }
      }

      if (amount <= 0) {
        throw Object.assign(
          new Error(
            'Amount is required. Select advance type, travel destination and days so ERP can calculate the daily rate — or enter amount manually.',
          ),
          { status: 422 },
        )
      }

      const dailyRateInput = Number(req.body?.dailyRate ?? 0)
      const dailyRate =
        dailyRateInput > 0
          ? dailyRateInput
          : noOfDays > 0 && amount > 0
            ? Math.round((amount / noOfDays) * 100) / 100
            : 0

      return {
        action: req.body?.action ?? 'create',
        docNo: no,
        lineNo: Number(req.body?.lineNo ?? 0),
        destination,
        noOfDays,
        employeeNo: user.employeeNo,
        advanceType,
        dutyArea: req.body?.dutyArea ?? '',
        amount,
        dailyRate,
      }
    },
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
      tableID: 50891,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 50891,
    }),
  },
}

/**
 * Imprest Surrender — `App\Http\Controllers\Staff\ImprestsSurrenderController`.
 *
 * SOAP: ImprestSurrenderHeader / ImprestSurrenderLine /
 *       RequestImprestSurrenderApproval / CancelImprestSurrender
 */
const imprestSurrender: ModuleSpec = {
  module: 'imprest-surrender',
  headerService: 'QyImprestSurrenderHeader',
  headerTableId: 50884,
  supportsAttachments: true,
  ownerField: 'UserID',
  ownerSource: 'userID',
  lineService: 'QyImprestSurrenderLines',
  lineHeaderField: 'SurrenderDocNo',
  soap: {
    saveHeader: 'ImprestSurrenderHeader',
    saveLine: 'ImprestSurrenderLine',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestImprestSurrenderApproval',
    cancel: 'CancelImprestSurrender',
  },
  params: {
    deleteDocument: draftDeleteParams('imprest-surrender'),
    saveHeader: ({ req, user, no }) => ({
      docNo: no,
      imprestIssueDocNo: req.body?.imprestIssueDocNo ?? req.body?.imprest ?? '',
      myUserID: user.userID,
      employeeNo: user.employeeNo,
      imprestNo: user.imprestNo ?? '',
      myAction: no ? 'update' : 'create',
      receivedFrom: user.userID,
      pVNo: '',
    }),
    saveLine: ({ req, no }) => ({
      lineNo: Number(req.body?.lineNo ?? 0),
      accountNo: req.body?.accountNo ?? '',
      docNo: no,
      actualSpent: Number(req.body?.actualSpent ?? 0),
      cashReceiptNo: req.body?.cashReceiptNo ?? '',
      cashReceiptAmount: Number(req.body?.cashReceiptAmount ?? 0),
    }),
    submit: ({ no }) => ({ docNo: no }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 50884,
    }),
  },
}

/**
 * Staff Claim — `App\Http\Controllers\Staff\ClaimsController`.
 *
 * SOAP: ClaimRequisitionHeader / ClaimRequisitionLine / DeleteClaimLine /
 *       RequestClaimApproval / CancelClaimRequisition
 */
const staffClaim: ModuleSpec = {
  module: 'claim',
  headerService: 'QyStaffClaimHeader',
  headerTableId: 50885,
  supportsAttachments: true,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  lineService: 'QyStaffClaimLines',
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'ClaimRequisitionHeader',
    saveLine: 'ClaimRequisitionLine',
    deleteLine: 'DeleteClaimLine',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestClaimApproval',
    cancel: 'CancelClaimRequisition',
  },
  params: {
    deleteDocument: draftDeleteParams('claim'),
    saveHeader: async ({ req, user, no }) => {
      await ensureEmployeeDepartmentCodeForFinance(user.employeeNo, {
        department: user.department,
        departmentName: user.departmentName,
        branchCode: user.branchCode,
      })
      const claimDescription = String(
        req.body?.purpose ?? req.body?.claimDescription ?? req.body?.description ?? '',
      ).trim()
      const claimDateRaw = String(req.body?.claimDate ?? '')
      if (!isErpWorkingDate(claimDateRaw)) {
        throw Object.assign(new Error('Claim date must be the current working date'), { status: 400 })
      }
      const departmentCode = await resolveFinanceDepartmentCodeForSoap(user.employeeNo, {
        department: user.department,
        departmentName: user.departmentName,
        branchCode: user.branchCode,
      })
      if (!departmentCode) {
        throw Object.assign(
          new Error(
            'Your Business Central employee record has no department dimension. Ask HR to set Global Dimension 2 (department) on your employee card, then log out and sign in again.',
          ),
          { status: 422, code: 'EMPLOYEE_DEPARTMENT_MISSING' },
        )
      }
      const payload: Record<string, unknown> = {
        action: no ? 'edit' : 'create',
        reqNo: no,
        staffNo: user.employeeNo,
        claimDescription,
        claimDate: formatBcSoapDate(claimDateRaw),
        myUserID: user.userID,
        department: departmentCode,
      }
      return payload
    },
    saveLine: async ({ req, no }) => {
      const claimType = claimTypeCode(req.body?.claimType)
      const medical = isMedicalClaimType(claimType)
      const other = isOtherClaimType(claimType)
      let accountNo = String(req.body?.accountNo ?? '').trim()
      if (!accountNo) accountNo = await lookupClaimTypeGlAccount(claimType)
      if (!accountNo) {
        throw Object.assign(
          new Error(
            `No G/L account is mapped to claim type "${claimType}" in Business Central. Ask finance to set the G/L account on Receipts & Payment Types.`,
          ),
          { status: 422 },
        )
      }
      const amount = other
        ? Number(req.body?.amount ?? req.body?.amountToRefund ?? req.body?.grossAmount ?? 0)
        : medical
          ? Number(
              req.body?.amountToRefund ??
                req.body?.amount ??
                req.body?.grossAmount ??
                0,
            )
          : Number(req.body?.amount ?? req.body?.grossAmount ?? 0)
      const patientRaw = String(req.body?.patient ?? '').trim().toLowerCase()
      const relationshipRaw = String(req.body?.relationship ?? '').trim()
      const dependantPatient =
        medical &&
        (patientRaw === 'dependant' || patientRaw === 'dependent' || patientRaw === '2')
      const relationshipMap: Record<string, number> = {
        spouse: 1,
        child: 2,
        father: 3,
        mother: 4,
        other: 5,
      }
      const payload: Record<string, unknown> = {
        action: req.body?.action ?? 'create',
        amount,
        reqNo: no,
        claimType,
        accountNo,
        medicalAmount: medical ? Number(req.body?.medicalAmount ?? 0) : 0,
        claimReceiptNo: req.body?.claimReceiptNo ?? '',
        expenditureDescription:
          req.body?.expenditureDescription ?? req.body?.description ?? '',
        lineNo: Number(req.body?.lineNo ?? 0),
        expenditureDate: formatBcSoapDate(String(req.body?.expenditureDate ?? '')),
        hospitalCategory: medical
          ? hospitalCategoryCode(req.body?.hospitalCategory)
          : 0,
        patient: medical ? (dependantPatient ? 2 : 1) : 0,
        relationship: dependantPatient
          ? (relationshipMap[relationshipRaw.toLowerCase()] ?? (Number(relationshipRaw || 0) || 0))
          : 0,
        dependant: dependantPatient ? String(req.body?.dependant ?? '').trim() : '',
      }
      if (medical && payload.patient === 2 && payload.relationship === 2) {
        const dob = String(req.body?.dependantDateOfBirth ?? '').trim()
        if (dob) {
          const born = new Date(dob)
          if (!Number.isNaN(born.getTime())) {
            const age =
              new Date().getFullYear() -
              born.getFullYear() -
              (new Date().getMonth() < born.getMonth() ||
              (new Date().getMonth() === born.getMonth() && new Date().getDate() < born.getDate())
                ? 1
                : 0)
            if (age > 18) {
              throw Object.assign(
                new Error(
                  `Child dependants above 18 years are not eligible for medical claims (age ${age}).`,
                ),
                { status: 422 },
              )
            }
          }
        }
      }
      return payload
    },
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 50885,
    }),
  },
}

/**
 * Petty Cash — `App\Http\Controllers\Staff\PettyCashController`.
 *
 * SOAP: FnPettyCashHeader / FnPettyCashLine / RequestPettyCashApproval /
 *       CancelPettyCashRequest
 */
const pettyCash: ModuleSpec = {
  module: 'petty-cash',
  headerService: 'QyPaymentsHeader',
  headerTableId: 50887,
  supportsAttachments: true,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  extraListFilter: `PaymentType eq 'Petty Cash'`,
  lineService: 'QyPaymentLine',
  lineFallbackServices: ['QyPaymentLines', 'PaymentLines'],
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'FnPettyCashHeader',
    saveLine: 'FnPettyCashLine',
    deleteLine: 'FnPettyCashLine',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestPettyCashApproval',
    cancel: 'CancelPettyCashRequest',
  },
  params: {
    deleteDocument: draftDeleteParams('petty-cash'),
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      requiredDate:
        req.body?.dateNeeded ?? req.body?.requiredDate ?? req.body?.requestDate ?? '',
      staffNo: user.employeeNo,
      myUserId: user.userID,
      narration:
        req.body?.description ?? req.body?.narration ?? req.body?.purpose ?? '',
      recId: no,
    }),
    saveLine: ({ req, user, no }) => ({
      myAction: req.body?.action ?? 'create',
      parentId: no,
      staffNo: user.employeeNo,
      myUserId: user.userID,
      lineNo: Number(req.body?.lineNo ?? 0),
      recId: Number(req.body?.recId ?? req.body?.lineNo ?? 0),
      amount: Number(req.body?.amount ?? 0),
      type: req.body?.type ?? req.body?.activity ?? '',
    }),
    deleteLine: ({ req, no }) => ({
      myAction: 'delete',
      parentId: no,
      staffNo: '',
      myUserId: '',
      lineNo: '',
      recId: req.params.lineNo,
      amount: 0,
      type: '',
    }),
    submit: ({ no }) => ({ docNo: no }),
    cancel: ({ no }) => ({ docNo: no, requisitionNo: no }),
  },
}

/**
 * Inter-Bank Transfer / Petty Cash Replenishment —
 * `App\Http\Controllers\Staff\InterBankTransferController`.
 *
 * SOAP: FnSaveInterBankTransfer / FnUpdateInterBankTransfer /
 *       RequestInterBankTransferApproval / CancelInterBankTransferRequest
 */
const interBankTransfer: ModuleSpec = {
  module: 'inter-bank-transfer',
  headerService: 'PgInterBankTransfers',
  headerTableId: 50883,
  supportsAttachments: true,
  ownerField: 'Employee_No',
  ownerSource: 'employeeNo',
  soap: {
    saveHeader: 'FnSaveInterBankTransfer', // edit branch swapped at runtime
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestInterBankTransferApproval',
    cancel: 'CancelInterBankTransferRequest',
  },
  params: {
    deleteDocument: draftDeleteParams('inter-bank-transfer'),
    saveHeader: ({ req, user, no }) => ({
      myUserId: user.userID,
      staffNo: user.employeeNo,
      myAction: no ? 'edit' : 'create',
      // BC derives organisation dimensions from Staff No. Sending portal
      // values here triggers "Branch when Department already selected".
      sector: '',
      remarks: req.body?.remarks ?? '',
      division: '',
      department: '',
      dateCreated: req.body?.dateCreated ?? '',
      sourceAmount: Number(req.body?.sourceAmount ?? 0),
      payingAccount: '',
      receivingAmount: Number(req.body?.receivingAmount ?? req.body?.sourceAmount ?? 0),
      receivingAccount: req.body?.receivingAccount ?? '',
      interBankTransferNo: no,
    }),
    submit: ({ no }) => ({ docNo: no }),
    cancel: ({ no }) => ({ docNo: no, requisitionNo: no }),
  },
}

/**
 * Store Requisition — `App\Http\Controllers\Staff\StoreRequisitionsController`.
 *
 * SOAP: StoreRequisitionHeader / StoreRequisitionLine / DeleteStoreReqLine /
 *       RequestStoreReqApproval / CancelStoreRequisition
 */
const storeRequisition: ModuleSpec = {
  module: 'store-requisition',
  headerService: 'QyStoreRequisitionHeader',
  headerTableId: 50575,
  supportsAttachments: true,
  ownerField: 'UserID',
  ownerSource: 'userID',
  lineService: 'QyStoreRequisitionLines',
  lineHeaderField: 'RequistionNo',
  soap: {
    saveHeader: 'StoreRequisitionHeader',
    saveLine: 'StoreRequisitionLine',
    deleteLine: 'DeleteStoreReqLine',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestStoreReqApproval',
    cancel: 'CancelStoreRequisition',
  },
  params: {
    deleteDocument: draftDeleteParams('store-requisition'),
    saveHeader: ({ req, user, no }) => {
      const justification = String(req.body?.justification ?? req.body?.purpose ?? '').trim()
      const requiredDate = String(req.body?.dateRequired ?? req.body?.requestDate ?? '').trim()
      if (!justification) {
        throw Object.assign(new Error('Purpose / justification is required.'), { status: 422 })
      }
      if (!requiredDate) {
        throw Object.assign(new Error('Required Date is required.'), { status: 422 })
      }
      return {
      myAction: no ? 'edit' : 'create',
      docNo: no,
      myUserID: user.userID,
      requestDescription: String(
        req.body?.description ??
          req.body?.requestDescription ??
          justification ??
          '',
      ).slice(0, 150),
      requestDate: requiredDate,
      // Store assignment is an internal fulfillment decision. Never accept a
      // store/location selected or injected by the requester.
      issuingStore: '',
      justification: justification.slice(0, 250),
      priority: storePriorityCode(req.body?.priority ?? 'normal'),
      storeRequisitionType: storeHeaderRequestTypeCode(req.body?.requestType ?? 'item'),
      }
    },
    saveLine: async ({ req, user, no }) => {
      // Requesters describe the need; Operations/Store maps it to a BC item.
      const itemNo = ''
      const itemName = String(req.body?.itemName ?? '').trim()
      const lineDescription = String(req.body?.lineDescription ?? req.body?.description ?? '').trim()
      const unitOfMeasure = String(req.body?.uom ?? req.body?.unitOfMeasure ?? '').trim()
      const quantity =
        storeLineTypeCode(req.body?.type) === 1
          ? Number(req.body?.quantity ?? 0)
          : 0
      if (!itemName || !lineDescription || !unitOfMeasure || Number(req.body?.quantity ?? 0) <= 0) {
        throw Object.assign(
          new Error('Item / asset name, description, UOM, and a positive quantity are required.'),
          { status: 422 },
        )
      }
      await assertNoDuplicateStoreLine(
        user,
        no,
        itemNo,
        quantity,
        '',
      )
      // Use only an internally assigned store from the BC header. New requester
      // drafts intentionally leave it blank; BC propagates the store to lines
      // when Operations assigns the fulfillment location later.
      let headerStore = ''
      try {
        const rows = (await fetchOData('QyStoreRequisitionHeader', {
          $filter: `No eq '${odataString(no)}'`,
          $top: 1,
        })) as ODataRecord[] | null
        if (Array.isArray(rows) && rows[0]) {
          headerStore = fieldText(rows[0], ['IssuingStore', 'Issuing_Store'])
        }
      } catch {
        // Keep the line unassigned until Operations selects the store in BC.
      }
      return {
        action: req.body?.action ?? 'create',
        reqNo: no,
        lineNo: Number(req.body?.lineNo ?? 0),
        type: storeLineTypeCode(req.body?.type),
        itemNo,
        quantity:
          storeLineTypeCode(req.body?.type) === 1
            ? Number(req.body?.quantity ?? 0)
            : Number(req.body?.quantity ?? 1),
        // Use only a store already assigned internally on the BC header.
        location: headerStore,
        description: itemName.slice(0, 70),
        remarks: (() => {
          const name = itemName
          const extra = lineDescription
          return extra && extra !== name ? extra.slice(0, 200) : ''
        })(),
        unitOfMeasure: unitOfMeasure.slice(0, 20),
        preferredBrandModel: String(
          req.body?.preferredBrandModel ?? req.body?.preferredBrand ?? req.body?.brandModel ?? '',
        ).slice(0, 50),
      }
    },
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
      tableID: 50575,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 50575,
    }),
  },
}

/**
 * Purchase Requisition —
 * `App\Http\Controllers\Staff\PurchaseRequisitionsController`.
 *
 * SOAP: PurchaseRequisitionHeader / PurchaseRequisitionLine /
 *       DeletePurchaseReqLine / RequestPurchaseReqApproval /
 *       CancelPurchaseRequisition
 */
const purchaseRequisition: ModuleSpec = {
  module: 'purchase-requisition',
  headerService: 'QyPurchaseHeader',
  headerTableId: 52121800,
  supportsAttachments: true,
  ownerField: 'AssignedUserID',
  ownerSource: 'userID',
  extraListFilter: `DocApprovalType eq 'Requisition'`,
  // Dedicated query is installed and published by the Felix AL package. The
  // legacy QyPurchaseLine service was manually configured and can be absent or
  // point at a different Purchase Line query, which made approvers see only the
  // PR header with ETB 0 and no requested items.
  lineService: 'QyPortalPurchaseLines',
  // Existing HIJRA tenants can still have the original web-service name. The
  // dedicated query is authoritative, but falling back keeps approval details
  // populated during the AL upgrade/publish transition.
  lineFallbackServices: ['QyPurchaseLine'],
  lineHeaderField: 'DocumentNo',
  soap: {
    saveHeader: 'PurchaseRequisitionHeader',
    saveLine: 'PurchaseRequisitionLine',
    deleteLine: 'DeletePurchaseReqLine',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestPurchaseReqApproval',
    cancel: 'CancelPurchaseRequisition',
  },
  params: {
    deleteDocument: draftDeleteParams('purchase-requisition'),
    saveHeader: async ({ req, user, no }) => {
      const selected = String(
        req.body?.requestingDepartment ?? req.body?.departmentCode ?? '',
      ).trim()
      const profileDepartment = String(user.department || user.departmentName || '').trim()
      const [requestingDepartment, employeeDepartment] = await Promise.all([
        selected ? resolveRequestingDepartmentCode(selected) : Promise.resolve(''),
        profileDepartment
          ? resolveRequestingDepartmentCode(profileDepartment)
          : Promise.resolve(''),
      ])
      const submittedDepartment =
        requestingDepartment ||
        (selected.length > 0 && selected.length <= 20 ? selected : '')
      const authoritativeDepartment =
        employeeDepartment ||
        (profileDepartment.length > 0 && profileDepartment.length <= 20 ? profileDepartment : '')
      // Only enforce profile department on create. Store/procurement users often
      // edit purchase requests created for another employee (e.g. store → PQ).
      if (
        !no &&
        authoritativeDepartment &&
        selected &&
        (!submittedDepartment ||
          submittedDepartment.trim().toUpperCase() !== authoritativeDepartment.trim().toUpperCase())
      ) {
        throw Object.assign(
          new Error(
            `Department must match your employee profile (${authoritativeDepartment}). If your card shows a different department, ask HR to update Business Central, then try again.`,
          ),
          { status: 422, code: 'PROFILE_DEPARTMENT_MISMATCH' },
        )
      }
      const departmentForSoap = no
        ? submittedDepartment || authoritativeDepartment
        : authoritativeDepartment || submittedDepartment
      if (selected && !departmentForSoap) {
        throw Object.assign(
          new Error(
            `Department "${selected}" is not a valid Business Central department code. Pick a department from the list or ask finance to configure Departments / dimension values.`,
          ),
          { status: 422, code: 'INVALID_DEPARTMENT' },
        )
      }
      const justification = String(
        req.body?.justification ??
          req.body?.description ??
          req.body?.postingDescription ??
          req.body?.reason ??
          '',
      ).trim()
      const requiredDate = String(
        req.body?.dateNeeded ?? req.body?.orderDate ?? req.body?.requestDate ?? '',
      ).trim()
      const projectCode = String(req.body?.projectCode ?? req.body?.costCenter ?? '').trim()
      const budgetType = String(req.body?.budgetType ?? '').trim().toLowerCase()
      const isProjectBudget = budgetType === 'project' || budgetType === '0'
      const isNonProjectBudget = ['nonproject', 'non-project', 'non project', '1'].includes(
        budgetType,
      )
      const purchaseRequestType = String(
        req.body?.purchaseRequestType ?? req.body?.requestType ?? '',
      ).trim().toLowerCase()
      const priority = String(req.body?.priority ?? '').trim()
      const scopeOfWork = String(req.body?.scopeOfWork ?? '').trim()
      const technicalRequirement = String(req.body?.technicalRequirement ?? '').trim()
      const submittedCurrency = String(req.body?.currencyCode ?? req.body?.currency ?? '')
        .trim()
        .replace(/^OTHER$/i, '')
      const purchaseMode = String(
        req.body?.purchaseMode ?? (submittedCurrency ? 'foreign' : 'local'),
      ).trim().toLowerCase()
      if (!isProjectBudget && !isNonProjectBudget) {
        throw Object.assign(new Error('Budget Type must be Project or Non-Project.'), {
          status: 422,
          code: 'INVALID_BUDGET_TYPE',
        })
      }
      const purchaseRequestTypeValue = purchaseRequestTypeCode(purchaseRequestType)
      const priorityValue = purchasePriorityCode(priority)
      const otherRequirements = purchaseOtherRequirementsForSoap(
        purchaseRequestType,
        req.body?.otherPurchaseType,
        req.body?.otherRequirements,
      )
      if (!departmentForSoap || !justification || !requiredDate) {
        throw Object.assign(
          new Error('Department, Budget Type, Required Date, and Purpose / Justification are required.'),
          { status: 422 },
        )
      }
      if (isProjectBudget && !projectCode) {
        throw Object.assign(
          new Error(
            'Budget Type is Project, but Project Name / Code is missing. Choose Non-Project, or enter a project code before saving.',
          ),
          { status: 422, code: 'PURCHASE_PROJECT_CODE_REQUIRED' },
        )
      }
      if (!['local', 'foreign'].includes(purchaseMode)) {
        throw Object.assign(new Error('Purchase mode must be Local or Foreign.'), {
          status: 422,
        })
      }
      if (purchaseMode === 'foreign' && !submittedCurrency) {
        throw Object.assign(new Error('Currency is required for a foreign purchase request.'), {
          status: 422,
        })
      }
      return {
        action: no ? 'edit' : 'create',
        reqNo: no,
        postingDescription: justification.slice(0, 100),
        pricesIncludingVAT: false,
        myUserId: user.userID,
        orderDate: requiredDate,
        requestingDepartment: departmentForSoap,
        priority: priorityValue,
        purchaseRequestType: purchaseRequestTypeValue,
        projectCode: isProjectBudget ? projectCode.slice(0, 10) : '',
        justification: justification.slice(0, 250),
        currencyCode: purchaseMode === 'foreign' ? submittedCurrency : '',
        technicalRequirement: technicalRequirement.slice(0, 250),
        otherRequirements,
        scopeOfWork: scopeOfWork.slice(0, 250),
      }
    },
    saveLine: async ({ req, user, no }) => {
      const quantity = Number(req.body?.quantity ?? 0)
      const itemName = String(req.body?.itemName ?? '').trim()
      const description = String(
        req.body?.description ?? req.body?.reasonForRequest ?? req.body?.reason ?? '',
      ).trim()
      const specification = String(
        req.body?.specification ??
          req.body?.itemDescription ??
          '',
      ).trim()
      const category = String(req.body?.category ?? '').trim()
      const unitOfMeasure = String(req.body?.unitOfMeasure ?? req.body?.uom ?? '').trim()
      const requiredDate = String(req.body?.requiredDate ?? req.body?.dateNeeded ?? '').trim()
      const rawLineType = String(req.body?.type ?? '').trim()
      const typeCode = purchaseLineTypeCode(rawLineType)
      const estimatedUnitPrice = Number(req.body?.estimatedUnitPrice ?? 0)
      if (!rawLineType || ![1, 2, 4].includes(typeCode)) {
        throw Object.assign(new Error('Line Type must be Item, Service, or Asset.'), {
          status: 422,
          code: 'INVALID_PURCHASE_LINE_TYPE',
        })
      }
      if (!Number.isFinite(estimatedUnitPrice) || estimatedUnitPrice < 0) {
        throw Object.assign(new Error('Estimated Unit Price must be zero or a positive amount.'), {
          status: 422,
          code: 'INVALID_ESTIMATED_UNIT_PRICE',
        })
      }
      let itemNo = String(req.body?.itemNo ?? req.body?.itemCode ?? req.body?.item ?? '').trim()
      if (!itemNo && (typeCode === 2 || typeCode === 4)) {
        itemNo = await resolvePurchaseMasterNoByName(typeCode, itemName)
      }
      if (!itemName || !description || !specification || !category || !unitOfMeasure || !requiredDate || quantity <= 0) {
        throw Object.assign(
          new Error('Item/service name, category, description, specification, quantity, UOM, and line Required Date are required.'),
          { status: 422 },
        )
      }
      await assertNoDuplicatePurchaseLine(user, no, itemNo, quantity)
      return {
        action: req.body?.action ?? 'create',
        reqNo: no,
        lineNo: Number(req.body?.lineNo ?? 0),
        itemNo,
        // Keep SOAP element order identical to PurchaseRequisitionLine AL params.
        location: String(req.body?.whereNeeded ?? req.body?.location ?? ''),
        quantity,
        type: typeCode,
        procurementPlan: req.body?.procurementPlan ?? '',
        reasonForRequest: description || specification,
        specification,
        itemName: itemName || description,
        unitOfMeasure,
        estimatedUnitPrice,
        preferredBrandModel: String(req.body?.preferredBrandModel ?? '').trim().slice(0, 50),
        suggestedSupplier: String(req.body?.suggestedSupplier ?? '').trim().slice(0, 100),
        remarks: String(req.body?.remarks ?? '').trim().slice(0, 100),
        category: category.slice(0, 50),
        requiredDate,
      }
    },
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: async ({ user, no }) => {
      let employeeNo = user.employeeNo
      try {
        const rows = (await fetchOData('QyPurchaseHeader', {
          $filter: `No eq '${odataString(no)}'`,
          $top: 1,
        })) as ODataRecord[] | null
        if (Array.isArray(rows) && rows[0]) {
          const documentEmployee = fieldText(rows[0], ['EmployeeNo', 'Employee_No'])
          if (documentEmployee) employeeNo = documentEmployee
        }
      } catch {
        // keep logged-in employee when OData is unavailable
      }
      return {
        reqNo: no,
        employeeNo,
        tableID: 52121800,
      }
    },
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 52121800,
    }),
  },
}

/**
 * Transport Requisition —
 * `App\Http\Controllers\Staff\TransportRequisitionsController`.
 *
 * SOAP: TransportRequisition / TransportRequisitionPassenger /
 *       RequestTransportReqApproval / CancelTransportRequisition
 */
const transport: ModuleSpec = {
  module: 'transport',
  headerService: 'QyTransportRequisition',
  headerTableId: 61801,
  ownerField: 'Requested_By',
  ownerSource: 'userID',
  headerKey: 'Transport_Requisition_No',
  headerReturnsBoolean: true,
  soap: {
    saveHeader: 'TransportRequisition',
    saveLine: 'TransportRequisitionPassenger',
    deleteLine: 'TransportRequisitionPassenger',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestTransportReqApproval',
    cancel: 'CancelTransportRequisition',
  },
  params: {
    deleteDocument: draftDeleteParams('transport'),
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      reqNo: no,
      requestType: transportRequestTypeCode(
        req.body?.requestType ?? req.body?.transportType,
      ),
      employeeNo: user.employeeNo,
      purpose: req.body?.purpose ?? '',
      responsibilityCenter: req.body?.responsibilityCenter ?? '',
      destination: req.body?.destination ?? '',
      commenceFrom:
        req.body?.commencement ?? req.body?.commenceFrom ?? req.body?.tripTime ?? '',
      dateOfTrip: formatBcSoapDate(String(req.body?.dateOfTrip ?? req.body?.tripDate ?? '')),
      noOfDays: Number(req.body?.noOfDays ?? 0),
      noOfPassengers: Number(
        req.body?.noOfPassengers ??
          (Array.isArray(req.body?.passengers) ? req.body.passengers.length : 0),
      ),
      travelType: 0,
      noSeries: 'TR',
    }),
    saveLine: ({ req, no }) => ({
      myAction: req.body?.action ?? 'create',
      passengerType: passengerTypeCode(req.body?.passengerType),
      employeeNo:
        req.body?.employeeNo ??
        (passengerTypeCode(req.body?.passengerType) === 'Staff' ? req.body?.name : '') ??
        '',
      transportNo: no,
      externalPassName:
        req.body?.externalPassName ??
        (passengerTypeCode(req.body?.passengerType) === 'External' ? req.body?.name : '') ??
        '',
      externalPassOrganization: req.body?.externalPassOrganization ?? '',
      recId: req.body?.recId ?? '',
    }),
    deleteLine: ({ req }) => ({
      myAction: 'delete',
      passengerType: passengerTypeCode(req.body?.passengerType),
      employeeNo: '',
      transportNo: '',
      externalPassName: '',
      externalPassOrganization: '',
      recId: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
      tableID: 61801,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 61801,
    }),
  },
}

/**
 * Fuel Requisition (and Maintenance) — single ESS controller, but the
 * frontend exposes them as two pages. Use `requestType` on create:
 * `0`=fuel-vehicle, `3`=fuel-card, others=maintenance.
 *
 * `App\Http\Controllers\Staff\FuelMaintenanceController`.
 * SOAP: FnFuelRequisitionHeader / FnFuelRequisitionApprovalAction
 */
/** Map the ESS fuel request-type label/number to the BC code (0 = vehicle, 3 = card). */
function fuelTypeCode(value: unknown) {
  const numeric = Number(value)
  if (Number.isFinite(numeric) && String(value).trim() !== '') return numeric
  return String(value ?? '').toLowerCase().includes('card') ? 3 : 0
}

function fuelMaintenanceRequestTypeCode(row: ODataRecord) {
  const raw = row.RequestType ?? row.Request_Type ?? row.MaintenanceType
  const numeric = Number(raw)
  if (Number.isFinite(numeric) && String(raw).trim() !== '') return numeric
  return -1
}

/** HIJRA OData uses `Type` = Maintenance; other sites may use numeric RequestType. */
function isMaintenanceRequestRow(row: ODataRecord) {
  const docType = String(row.Type ?? row.DocumentType ?? row.Document_Type ?? '')
    .trim()
    .toLowerCase()
  if (docType === 'maintenance') return true
  const type = fuelMaintenanceRequestTypeCode(row)
  return type === 1 || type === 2
}

function isFuelRequestRow(row: ODataRecord) {
  if (isMaintenanceRequestRow(row)) return false
  const type = fuelMaintenanceRequestTypeCode(row)
  if (type === 0 || type === 3) return true
  const label = String(row.RequisitionType ?? row.Requisition_Type ?? '').toLowerCase()
  return label.includes('fuel') || label.includes('card')
}

/** Fuel + maintenance share QyFuelMaintenanceRequests; HIJRA often rejects OData $filter. */
const FUEL_MAINTENANCE_MODULES = new Set(['fuel', 'maintenance'])

function portalOwnerFieldKeys(spec: ModuleSpec) {
  return [
    ...new Set([
      spec.ownerField,
      'AssignedUserID',
      'Assigned_User_ID',
      'AssignedUser',
      'UserID',
      'User_ID',
      'RequesterID',
      'Requester_ID',
      'RequestedBy',
      'Requested_By',
      'EmployeeNo',
      'Employee_No',
      'PreparedBy',
      'Prepared_By',
    ]),
  ]
}

function purchaseRowText(row: ODataRecord, keys: string[]) {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') {
      return String(value).trim()
    }
  }
  return ''
}

/** Store stock-unavailable path: LPR created from a store requisition for another employee. */
export function isStoreOriginatedPurchaseRow(row: ODataRecord) {
  const combined = [
    purchaseRowText(row, ['Justification', 'Purpose', 'RequestDescription', 'Request_Description']),
    purchaseRowText(row, ['PostingDescription', 'Posting_Description', 'Description']),
  ]
    .filter(Boolean)
    .join(' ')
  return /store requisition|lpr from store/i.test(combined)
}

export function storeOriginatedPurchaseVisible(
  row: ODataRecord,
  spec: ModuleSpec,
  canViewStoreProcess: boolean,
) {
  return spec.module === 'purchase-requisition' && canViewStoreProcess && isStoreOriginatedPurchaseRow(row)
}

export function portalModuleDocumentOwnedByUser(
  row: ODataRecord,
  spec: ModuleSpec,
  user: AuthUser,
) {
  const wanted = new Set(
    [ownerValue(spec, user), user.userID, user.employeeNo]
      .map((value) => String(value ?? '').trim().toUpperCase())
      .filter(Boolean),
  )
  if (wanted.size === 0) return false
  for (const key of portalOwnerFieldKeys(spec)) {
    const value = String(row[key] ?? '').trim().toUpperCase()
    if (value && wanted.has(value)) return true
  }
  return false
}

async function fetchFuelMaintenanceRows(spec: ModuleSpec, user: AuthUser) {
  const fetched = await fetchOData(spec.headerService, {})
  let rows = Array.isArray(fetched) ? fetched : []
  if (!spec.unscopedList) {
    rows = rows.filter((row) => portalModuleDocumentOwnedByUser(row, spec, user))
  }
  return spec.postListFilter ? rows.filter(spec.postListFilter) : rows
}

/** Portal maintenance types: 1 = fixed asset, 2 = vehicle service. */
function maintenanceTypeCode(value: unknown) {
  return Number(value) === 2 ? 2 : 1
}

function fuelMaintenanceSaveHeader(
  module: 'fuel' | 'maintenance',
  {
    req,
    user,
    no,
  }: {
    req: Request
    user: AuthUser
    no: string
  },
) {
  return {
    myAction: no ? 'edit' : 'create',
    recId: no ? String(req.body?.recId ?? '') : '',
    staffNo: user.employeeNo,
    purpose: req.body?.purpose ?? req.body?.issueDescription ?? '',
    quantity: Number(req.body?.quantity ?? req.body?.liters ?? 0),
    requestType:
      module === 'maintenance'
        ? maintenanceTypeCode(req.body?.requestType)
        : fuelTypeCode(req.body?.requestType),
    cardNo: req.body?.cardNo ?? '',
    vehicleNo: req.body?.vehicleNo ?? req.body?.faTagNumber ?? '',
    fuelDealer: req.body?.fuelDealer ?? '',
    price: Number(req.body?.price ?? 0),
  }
}

const fuelMaintenanceSoap = {
  saveHeader: 'FnFuelRequisitionHeader',
  deleteDocument: 'DeletePortalDraftDocument',
  submit: 'FnFuelRequisitionApprovalAction',
  cancel: 'FnFuelRequisitionApprovalAction',
} as const

const fuelRequest: ModuleSpec = {
  module: 'fuel',
  headerService: 'QyFuelMaintenanceRequests',
  headerTableId: 50865,
  ownerField: 'RequesterID',
  ownerSource: 'employeeNo',
  headerKey: 'RequisitionNo',
  postListFilter: isFuelRequestRow,
  soap: fuelMaintenanceSoap,
  params: {
    deleteDocument: draftDeleteParams('fuel'),
    saveHeader: (ctx) => fuelMaintenanceSaveHeader('fuel', ctx),
    submit: ({ no }: { no: string }) => ({ docNo: no, action: 'request' }),
    cancel: ({ no }: { no: string }) => ({ docNo: no, action: 'cancel' }),
  },
}

const maintenance: ModuleSpec = {
  module: 'maintenance',
  headerService: 'QyFuelMaintenanceRequests',
  headerTableId: 50865,
  ownerField: 'RequesterID',
  ownerSource: 'employeeNo',
  headerKey: 'RequisitionNo',
  postListFilter: isMaintenanceRequestRow,
  soap: fuelMaintenanceSoap,
  params: {
    deleteDocument: draftDeleteParams('maintenance'),
    saveHeader: (ctx) => fuelMaintenanceSaveHeader('maintenance', ctx),
    submit: ({ no }: { no: string }) => ({ docNo: no, action: 'request' }),
    cancel: ({ no }: { no: string }) => ({ docNo: no, action: 'cancel' }),
  },
}

/**
 * Transfer Order — `App\Http\Controllers\Staff\TransferOrderController`.
 *
 * SOAP: TransferOrderHeader / TransferOrderLine / DeleteTransferLine /
 *       TransferOrderApproval (myAction = 'requestApproval' | 'cancelApproval')
 */
const transferOrder: ModuleSpec = {
  module: 'transfer-order',
  headerService: 'QyTransferOrderHeader',
  headerTableId: 5740,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  lineService: 'QyTransferLines',
  lineHeaderField: 'DocumentNo',
  headerReturnsBoolean: true,
  soap: {
    saveHeader: 'TransferOrderHeader',
    saveLine: 'TransferOrderLine',
    deleteLine: 'DeleteTransferLine',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'TransferOrderApproval',
    cancel: 'TransferOrderApproval',
  },
  decideMode: 'submitCancelOnSameMethod',
  params: {
    deleteDocument: draftDeleteParams('transfer-order'),
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      fromCode: req.body?.from ?? req.body?.fromCode ?? '',
      toCode: req.body?.to ?? req.body?.toCode ?? '',
      employeeNo: user.employeeNo,
      inTransit: req.body?.inTransit ?? '',
      truckNo: req.body?.truckNo ?? '',
      postingDate: req.body?.postingDate ?? '',
      driverName: req.body?.driverName ?? '',
      requisitionNo: no,
    }),
    saveLine: ({ req, no }) => ({
      itemNo: req.body?.item ?? req.body?.itemNo ?? '',
      quantity: Number(req.body?.quantity ?? 0),
      requisitionNo: no,
    }),
    deleteLine: ({ req, no }) => ({
      lineNo: req.params.lineNo,
      requisitionNo: no,
    }),
    submit: ({ no }) => ({ docNo: no, myAction: 'requestApproval' }),
    cancel: ({ no }) => ({ docNo: no, myAction: 'cancelApproval' }),
  },
}

/**
 * Work Tickets — list/detail + create header/line + line delete (ESS UI parity).
 * `App\Http\Controllers\Staff\WorkTicketsController`.
 */
const workTickets: ModuleSpec = {
  module: 'work-tickets',
  headerService: 'QyWorkTickets',
  headerTableId: 50866,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  headerKey: 'TicketNo',
  unscopedList: true,
  lineService: 'QyWorkTicketLines',
  lineHeaderField: 'TicketNo',
  soap: {
    saveHeader: 'WorkTicketHeader',
    saveLine: 'WorkTicketLine',
    deleteLine: 'DeleteWorkTicketLine',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      ticketNo: no,
      employeeNo: user.employeeNo,
      previousWTNo: req.body?.previousTicketNo ?? req.body?.previousWTNo ?? '',
      gkNo: req.body?.gkNo ?? '',
      type: req.body?.type ?? '',
      department: req.body?.department ?? user.department ?? '',
    }),
    saveLine: ({ req, user, no }) => ({
      action: req.body?.action ?? 'create',
      ticketNo: no,
      lineNo: Number(req.body?.lineNo ?? 0),
      driverName: req.body?.driverName ?? '',
      departureFrom: req.body?.departureFrom ?? '',
      destination: req.body?.destination ?? '',
      workDate: formatBcSoapDate(req.body?.workDate ?? ''),
      authorizingOfficer:
        req.body?.authorizingOfficer ??
        req.body?.authorizingOfficerNo ??
        req.body?.authorizingOfficerName ??
        '',
      employeeNo: user.employeeNo,
    }),
    deleteLine: ({ req, no }) => ({
      lineNo: req.params.lineNo,
      ticketNo: no,
    }),
  },
}

/**
 * Training Request — `App\Http\Controllers\Staff\TrainingController`.
 */
const training: ModuleSpec = {
  module: 'training',
  headerService: 'QyTrainingApplicationHeader',
  headerTableId: 0,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  headerKey: 'ApplicationNo',
  soap: {
    saveHeader: 'FnTrainingRequest',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'TrainingApproval',
    cancel: 'TrainingApproval',
  },
  params: {
    deleteDocument: draftDeleteParams('training'),
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      docNo: no,
      purpose: req.body?.comments ?? req.body?.justification ?? '',
      trainingCourseCode:
        req.body?.trainingNeed ?? req.body?.trainingCourseCode ?? req.body?.trainingTitle ?? '',
      myUserID: user.userID,
      employeeNo: user.employeeNo,
    }),
    submit: ({ no }) => ({ docNo: no, myAction: 'requestApproval' }),
    cancel: ({ no }) => ({ docNo: no, myAction: 'cancelApproval' }),
  },
}

async function resolveSalaryAdvanceCustomerNo(
  user: AuthUser,
  body: Record<string, unknown>,
) {
  const fromBody = String(body.customerNo ?? body.accountNo ?? body.accountNumber ?? '').trim()
  if (fromBody) return fromBody

  const fromUser = String(user.imprestNo || user.accountNumber || '').trim()
  if (fromUser) return fromUser

  return fetchEmployeeCustomerAccountNo(user.employeeNo)
}

async function fetchSalaryAdvanceRows(spec: ModuleSpec, user: AuthUser) {
  const customerNo = await resolveSalaryAdvanceCustomerNo(user, {})
  if (!customerNo) return [] as ODataRecord[]

  const fetched = await fetchOData(spec.headerService, {
    $filter: `CustomerNo eq '${odataString(customerNo)}'`,
  })
  return Array.isArray(fetched) ? fetched : []
}

/**
 * Salary Advance — `App\Http\Controllers\SalaryAdvanceController`.
 */
const salaryAdvance: ModuleSpec = {
  module: 'salary-advance',
  headerService: 'QyStaffAdvanceHeader',
  headerTableId: 50880,
  ownerField: 'CustomerNo',
  ownerSource: 'imprestNo',
  lineService: 'QyStaffAdvanceLines',
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'FnSalaryAdvanceHeader',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'FnSalaryAdvanceApprovalAction',
    cancel: 'FnSalaryAdvanceApprovalAction',
  },
  params: {
    deleteDocument: draftDeleteParams('salary-advance'),
    saveHeader: async ({ req, user, no }) => {
      const fromBody = String(
        req.body?.customerNo ?? req.body?.accountNo ?? req.body?.accountNumber ?? '',
      ).trim()
      const fromUser = String(user.imprestNo || user.accountNumber || '').trim()
      const customerNo = fromBody || fromUser
      if (!customerNo) {
        const resolved = await fetchEmployeeCustomerAccountNo(user.employeeNo)
        if (!resolved) {
          throw Object.assign(
            new Error(
              'Your employee profile does not have a customer/account number in Business Central. Contact HR to update your employee record.',
            ),
            { status: 422 },
          )
        }
      }
      // Match ESS SOAP payload — BC derives customer/account from staffNo.
      return {
        myAction: no ? 'edit' : 'create',
        recId: no ? String(req.body?.recId ?? '') : '',
        staffNo: user.employeeNo,
        purpose: req.body?.purpose ?? req.body?.reason ?? '',
        percentageSalary: Number(req.body?.percentageSalary ?? 0),
      }
    },
    submit: ({ no }) => ({ docNo: no, action: 'request' }),
    cancel: ({ no }) => ({ docNo: no, action: 'cancel' }),
  },
}

/**
 * Gate Pass documents are created by BC from Store Issue, Transfer Order, or
 * Asset Transfer source documents. The portal lists them and controls
 * request/cancel approval.
 */
const gatePass: ModuleSpec = {
  module: 'gate-pass',
  headerService: 'QyGatePass',
  headerTableId: 50296,
  ownerField: 'EmployeeNo',
  ownerSource: 'employeeNo',
  unscopedList: true,
  extraListFilter: `Linkto eq 'Store Issue'`,
  headerKey: 'GatePassNo',
  lineService: 'QyStoreRequisitionLines',
  lineHeaderField: 'RequistionNo',
  soap: {
    saveHeader: 'GatePassHeader',
    deleteDocument: 'DeletePortalDraftDocument',
    submit: 'RequestGatePassApproval',
    cancel: 'CancelGatePassApproval',
  },
  params: {
    deleteDocument: draftDeleteParams('gate-pass'),
    saveHeader: ({ req, user }) => {
      const source = gatePassSourceFromQuery(
        req.body?.gatePassSource ?? req.body?.source ?? req.body?.linkTo ?? req.body?.Linkto,
      )
      const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
      const sourceDocumentNo = fieldText(req.body ?? {}, [
        'sourceDocumentNo',
        'transferNo',
        'TransferNo',
        'Transfer_No',
      ])
      if (!sourceDocumentNo) {
        throw Object.assign(new Error(`${sourceSpec.linkTo} document number is required`), {
          status: 422,
        })
      }
      return {
        myUserID: user.userID,
        gpLinkTo: sourceSpec.linkTo,
        gpTransferNo: sourceDocumentNo,
        gpDateOut: req.body?.dateOut ?? req.body?.issueDate ?? '',
        gpTimeOut: normalizeBcTime(req.body?.timeOut),
        gpDescription: req.body?.description ?? req.body?.reason ?? '',
        gpFromLocation: req.body?.fromLocation ?? req.body?.from ?? '',
        gpToLocation: req.body?.toLocation ?? req.body?.to ?? req.body?.destination ?? '',
        gpComment: req.body?.comment ?? '',
      }
    },
    submit: async ({ user, no }) => ({
      gatePassNo: no,
      transferNo: await gatePassTransferNo(no),
      tableID: 50296,
      employeeNo: user.employeeNo,
    }),
    cancel: async ({ user, no }) => ({
      gatePassNo: no,
      transferNo: await gatePassTransferNo(no),
      tableID: 50296,
      employeeNo: user.employeeNo,
    }),
  },
}

const STUB_MODULES: Array<{ module: string; reason: string }> = [
  {
    module: 'overtime',
    reason:
      'Overtime requests are not available in the portal. Contact HR if you need to submit overtime.',
  },
  {
    module: 'travel',
    reason:
      'Travel requests are tracked via the Imprest module today (TravelDestination feeds Imprest header). Use /api/staff/imprest until a dedicated SOAP method exists.',
  },
]

/* -------------------------------------------------------------------------- */
/* Generic router builder                                                     */
/* -------------------------------------------------------------------------- */

function buildModuleRouter(spec: ModuleSpec): Router {
  const router = Router({ mergeParams: true })
  const headerKey = spec.headerKey ?? 'No'
  const ownerProtected =
    spec.module === 'purchase-requisition' || spec.module === 'store-requisition'

  const requireProtectedOwner = async (user: AuthUser, no: string) => {
    if (!ownerProtected || !no) return
    const row = await getPortalModuleDocument(spec, user, no, false)
    if (!row || !portalModuleDocumentOwnedByUser(row, spec, user)) {
      throw Object.assign(new Error(`${spec.module} request not found`), {
        status: 404,
        code: 'REQUEST_NOT_FOUND',
      })
    }
  }

  router.get(
    '/',
    safe(async (req, res) => {
      const user = authUser(req)
      if (FUEL_MAINTENANCE_MODULES.has(spec.module)) {
        res.json({ rows: sortNewestFirst(await fetchFuelMaintenanceRows(spec, user)) })
        return
      }
      const currentOwner = ownerValue(spec, user)
      const filterParts =
        spec.module === 'gate-pass'
          ? gatePassListFilterParts(gatePassSourceFromQuery(req.query.source), user)
          : spec.unscopedList
            ? []
            : [`${spec.ownerField} eq '${odataString(currentOwner)}'`]
      if (spec.extraListFilter && spec.module !== 'gate-pass') filterParts.push(spec.extraListFilter)
      const fetched = await fetchOData(spec.headerService, {
        ...(filterParts.length ? { $filter: filterParts.join(' and ') } : {}),
      })
      let rows = Array.isArray(fetched) ? fetched : []
      if (spec.postListFilter) rows = rows.filter(spec.postListFilter)
      res.json({ rows: sortNewestFirst(rows) })
    }),
  )

  router.get(
    '/:no',
    safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '')

      const headerRows = (await fetchOData(spec.headerService, {
        $filter: `${headerKey} eq '${odataString(no)}'`,
        $top: 1,
      })) as ODataRecord[] | null
      const requisition = Array.isArray(headerRows) && headerRows.length > 0 ? headerRows[0]! : null
      if (!requisition) {
        res.status(404).json({ message: `${spec.module} request not found` })
        return
      }
      if (ownerProtected && !portalModuleDocumentOwnedByUser(requisition, spec, user)) {
        res.status(404).json({ message: `${spec.module} request not found` })
        return
      }

      const [lines, approvers, attachments] = await Promise.all([
        listPortalModuleLines(spec, requisition, no),
        fetchPortalApprovalEntries(spec, no, requisition),
        spec.headerTableId > 0
          ? fetchOData('QyDocumentAttachments', {
              $filter: `No eq '${odataString(no)}' and TableID eq ${spec.headerTableId}`,
            }).catch(() => [] as ODataRecord[])
          : Promise.resolve([] as ODataRecord[]),
      ])

      res.json({
        requisition,
        lines: Array.isArray(lines) ? lines : [],
        approvers: Array.isArray(approvers) ? approvers : [],
        attachments: Array.isArray(attachments) ? attachments : [],
        tableID: spec.headerTableId,
        docNo: no,
      })
    }),
  )

  if (spec.soap.saveHeader && spec.params?.saveHeader) {
    const handler = safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '')
      await requireProtectedOwner(user, no)
      const body = SCHEMAS.saveHeader.parse(req.body ?? {})
      // Pull through validated body for the param builder (re-attach reference).
      ;(req as Request).body = body
      let methodName = spec.soap.saveHeader!
      // Inter-Bank Transfer routes edits through a separate SOAP method.
      if (spec.module === 'inter-bank-transfer' && no) {
        methodName = 'FnUpdateInterBankTransfer'
      }
      const editBody = no
        ? await resolveRecIdHeaderEditBody(spec, user, no, body as Record<string, unknown>)
        : (body as Record<string, unknown>)
      ;(req as Request).body = editBody
      const params = await spec.params!.saveHeader!({ req, user, no })
      const result = await callSoapMethod(methodName, params)
      res.json({
        ok: ok(result),
        no: result.returnValue ?? null,
        returnValue: result.returnValue,
      })
    })
    router.post('/', handler)
    router.post('/:no/edit', handler)
  }

  if (spec.soap.saveLine && spec.params?.saveLine) {
    router.post(
      '/:no/lines',
      safe(async (req, res) => {
        const user = authUser(req)
        const no = String(req.params.no ?? '')
        await requireProtectedOwner(user, no)
        const params = await spec.params!.saveLine!({ req, user, no })
        const result = await callSoapMethod(spec.soap.saveLine!, params)
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  if (spec.soap.deleteLine && spec.params?.deleteLine) {
    router.delete(
      '/:no/lines/:lineNo',
      safe(async (req, res) => {
        const user = authUser(req)
        const no = String(req.params.no ?? '')
        await requireProtectedOwner(user, no)
        const params = await spec.params!.deleteLine!({ req, user, no })
        const result = await callSoapMethod(spec.soap.deleteLine!, params)
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  if (spec.soap.submit && spec.params?.submit) {
    router.post(
      '/:no/submit',
      safe(async (req, res) => {
        const user = authUser(req)
        const no = String(req.params.no ?? '')
        await requireProtectedOwner(user, no)
        await assertRequiredPortalAttachment(spec, no)
        const params = await spec.params!.submit!({ req, user, no })
        const result = await callSoapMethod(spec.soap.submit!, params)
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  if (spec.soap.cancel && spec.params?.cancel) {
    router.post(
      '/:no/cancel',
      safe(async (req, res) => {
        const user = authUser(req)
        const no = String(req.params.no ?? '')
        await requireProtectedOwner(user, no)
        const params = await spec.params!.cancel!({ req, user, no })
        const result = await callSoapMethod(spec.soap.cancel!, params)
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  return router
}

async function listDocumentAttachmentsForTable(no: string, tableIds: number[]) {
  const noFilter = `No eq '${odataString(no)}'`
  const tableClause = tableIds.map((id) => `TableID eq ${id}`).join(' or ')
  const tableClauseAlt = tableIds.map((id) => `Table_ID eq ${id}`).join(' or ')
  let rows = (await fetchOData('QyDocumentAttachments', {
    $filter: `${noFilter} and (${tableClause})`,
  }).catch(() => null)) as ODataRecord[] | null
  if (!Array.isArray(rows) || rows.length === 0) {
    rows = (await fetchOData('QyDocumentAttachments', {
      $filter: `${noFilter} and (${tableClauseAlt})`,
    }).catch(() => null)) as ODataRecord[] | null
  }
  if (!Array.isArray(rows) || rows.length === 0) {
    const loose = (await fetchOData('QyDocumentAttachments', { $filter: noFilter }).catch(
      () => null,
    )) as ODataRecord[] | null
    rows = Array.isArray(loose)
      ? loose.filter((row) => {
          const id = Number(row.TableID ?? row.Table_ID ?? 0)
          return tableIds.includes(id)
        })
      : []
  }
  return Array.isArray(rows) ? rows : []
}

async function assertRequiredPortalAttachment(spec: ModuleSpec, no: string) {
  // Latest ABH purchase decision: supporting documents, Scope/TOR, and service
  // technical notes are helpful but optional. Claims and Store Requests retain
  // their existing mandatory attachment rules.
  if (spec.module === 'purchase-requisition') return

  const tableIds =
    spec.headerTableId === 52121800 ? [52121800, 38] : [spec.headerTableId]
  const rows = await listDocumentAttachmentsForTable(no, tableIds)

  if (spec.module === 'claim') {
    if (rows.length === 0) {
      throw Object.assign(
        new Error('Attach at least one supporting document before requesting approval for a claim.'),
        { status: 422, code: 'CLAIM_ATTACHMENT_REQUIRED' },
      )
    }
    return
  }

  if (spec.module === 'store-requisition') {
    if (rows.length === 0) {
      throw Object.assign(
        new Error(
          'Attach at least one supporting document before requesting approval for store requisition.',
        ),
        { status: 422, code: 'STORE_ATTACHMENT_REQUIRED' },
      )
    }
    return
  }

}

function buildStubRouter(reason: string): Router {
  const router = Router({ mergeParams: true })
  router.use((_req, res) => {
    res.status(501).json({
      ok: false,
      message: 'Not yet implemented',
      reason,
    })
  })
  return router
}

/* -------------------------------------------------------------------------- */
/* Public entrypoint                                                          */
/* -------------------------------------------------------------------------- */

const DUPLICATE_REQUISITION_WINDOW_MS = 24 * 60 * 60 * 1000

function fieldNumber(row: ODataRecord, keys: string[], fallback = 0) {
  for (const key of keys) {
    const raw = row[key]
    if (raw === undefined || raw === null || String(raw).trim() === '') continue
    const n = Number(raw)
    if (Number.isFinite(n)) return n
  }
  return fallback
}

function duplicateBlockingStatus(status: string) {
  const normalized = String(status ?? '').trim().toLowerCase()
  return [
    'open',
    'draft',
    'pending',
    'pending approval',
    'pendingapproval',
  ].includes(normalized)
}

export function purchaseDuplicateBlockingStatus(status: string) {
  return duplicateBlockingStatus(status)
}

export function storeDuplicateBlockingStatus(status: string) {
  return duplicateBlockingStatus(status)
}

function headerIssuingStore(row: ODataRecord) {
  return fieldText(row, ['IssuingStore', 'Issuing_Store']).trim().toUpperCase()
}

function headerActivityTimestamp(row: ODataRecord) {
  const raw = fieldText(row, [
    'SystemCreatedAt',
    'SystemCreatedAt',
    'OrderDate',
    'Order_Date',
    'Needed_By_Date',
    'Requestdate',
    'RequestDate',
    'Date',
  ])
  const parsed = Date.parse(raw)
  return Number.isFinite(parsed) ? parsed : Date.now()
}

function lineItemNo(row: ODataRecord) {
  return fieldText(row, ['No', 'No_', 'ItemNo', 'Item_No', 'itemNo', 'item']).trim().toUpperCase()
}

export async function assertNoDuplicatePurchaseLine(
  user: AuthUser,
  currentDocNo: string,
  itemNo: string,
  quantity: number,
) {
  const normalizedItem = itemNo.trim().toUpperCase()
  if (!normalizedItem || quantity <= 0) return
  const spec = findModuleSpec('purchase-requisition')
  if (!spec) return
  let headers: ODataRecord[] = []
  try {
    headers = await listPortalModuleRows(spec, user)
  } catch {
    return
  }
  // Excel PR_07 joint remark: 24 hours.
  const cutoff = Date.now() - DUPLICATE_REQUISITION_WINDOW_MS
  const currentKey = currentDocNo.trim().toUpperCase()
  for (const header of headers) {
    const docNo = fieldText(header, ['No', 'No_', 'DocumentNo'])
    if (docNo.trim().toUpperCase() === currentKey) continue
    const status = resolveModuleRequestStatus(header, 'purchaseRequisition')
    if (!purchaseDuplicateBlockingStatus(status)) continue
    if (headerActivityTimestamp(header) < cutoff) continue
    const lines = await listPortalModuleLines(spec, header, docNo)
    const duplicateLine = lines.find((line) => {
      const lineQty = fieldNumber(line, ['Quantity'])
      return lineItemNo(line) === normalizedItem && Math.abs(lineQty - quantity) < 0.01
    })
    if (duplicateLine) {
      throw Object.assign(
        new Error(
          `Duplicate request: item ${itemNo} (qty ${quantity}) is already on ${docNo} (${status}). Cancel that request or wait 24 hours.`,
        ),
        { status: 409, code: 'DUPLICATE_PURCHASE_REQUISITION' },
      )
    }
  }
}

export async function assertNoDuplicateStoreLine(
  user: AuthUser,
  currentDocNo: string,
  itemNo: string,
  quantity: number,
  issuingStore = '',
) {
  const normalizedItem = itemNo.trim().toUpperCase()
  if (!normalizedItem) return
  const spec = findModuleSpec('store-requisition')
  if (!spec) return
  let headers: ODataRecord[] = []
  try {
    headers = await listPortalModuleRows(spec, user)
  } catch {
    return
  }
  const currentKey = currentDocNo.trim().toUpperCase()
  if (!issuingStore.trim() && currentKey) {
    try {
      const rows = (await fetchOData('QyStoreRequisitionHeader', {
        $filter: `No eq '${odataString(currentDocNo)}'`,
        $top: 1,
      })) as ODataRecord[] | null
      if (Array.isArray(rows) && rows[0]) {
        issuingStore = headerIssuingStore(rows[0])
      }
    } catch {
      // keep blank — match any store
    }
  }
  const storeFilter = issuingStore.trim().toUpperCase()
  for (const header of headers) {
    const docNo = fieldText(header, ['No', 'No_'])
    if (docNo.trim().toUpperCase() === currentKey) continue
    const status = resolveModuleRequestStatus(header, 'storeRequisition')
    if (!storeDuplicateBlockingStatus(status)) continue
    if (storeFilter && headerIssuingStore(header) && headerIssuingStore(header) !== storeFilter) {
      continue
    }
    const lines = await listPortalModuleLines(spec, header, docNo)
    const duplicateLine = lines.find((line) => {
      const lineQty = fieldNumber(line, ['Quantity', 'QuantityRequested', 'Quantity_Requested'])
      const sameItem = lineItemNo(line) === normalizedItem
      const sameQty = quantity <= 0 || Math.abs(lineQty - quantity) < 0.01
      return sameItem && sameQty
    })
    if (duplicateLine) {
      throw Object.assign(
        new Error(
          `Duplicate request: item ${itemNo}${quantity > 0 ? ` (qty ${quantity})` : ''} is already on ${docNo} (${status}). Only rejected or cancelled requests allow the same item again.`,
        ),
        { status: 409, code: 'DUPLICATE_STORE_REQUISITION' },
      )
    }
  }
}

export const MODULE_SPECS: ModuleSpec[] = [
  imprest,
  imprestSurrender,
  staffClaim,
  pettyCash,
  interBankTransfer,
  storeRequisition,
  purchaseRequisition,
  transport,
  fuelRequest,
  maintenance,
  transferOrder,
  workTickets,
  training,
  salaryAdvance,
  gatePass,
]

export function findModuleSpec(module: string) {
  return MODULE_SPECS.find((spec) => spec.module === module)
}

const FRONTEND_MODULE_ALIASES: Record<string, string> = {
  imprest: 'imprest',
  imprestSurrender: 'imprest-surrender',
  staffClaim: 'claim',
  pettyCash: 'petty-cash',
  pettyCashReplenishment: 'inter-bank-transfer',
  storeRequisition: 'store-requisition',
  purchaseRequisition: 'purchase-requisition',
  fuelRequest: 'fuel',
  transport: 'transport',
  maintenance: 'maintenance',
  transferOrder: 'transfer-order',
  training: 'training',
  salaryAdvance: 'salary-advance',
  gatePass: 'gate-pass',
}

export function findFrontendModuleSpec(module: string) {
  const internalName = FRONTEND_MODULE_ALIASES[module]
  return internalName ? findModuleSpec(internalName) : undefined
}

const MODULE_APPROVAL_KEYS: Partial<Record<string, ApprovalTableKey>> = {
  imprest: 'imprest',
  'imprest-surrender': 'imprestSurrender',
  claim: 'staffClaim',
  'petty-cash': 'pettyCash',
  'inter-bank-transfer': 'pettyCashReplenishment',
  'store-requisition': 'storeRequisition',
  'purchase-requisition': 'purchaseRequisition',
  fuel: 'fuel',
  'transfer-order': 'transferOrder',
  'salary-advance': 'salaryAdvance',
  'gate-pass': 'gatePass',
  transport: 'transport',
}

export function portalApprovalEntryFilter(spec: ModuleSpec, no: string) {
  let tableFilter = ''
  if (spec.module === 'purchase-requisition') {
    tableFilter = `(${approvalTableFilter('purchaseRequisition')} or ${approvalTableFilter('purchaseOrder')})`
  } else {
    const approvalKey = MODULE_APPROVAL_KEYS[spec.module]
    tableFilter = approvalKey
      ? approvalTableFilter(approvalKey)
      : spec.headerTableId > 0
        ? `TableID eq ${spec.headerTableId}`
        : ''
  }
  return `DocumentNo eq '${odataString(no)}'${tableFilter ? ` and ${tableFilter}` : ''}`
}

/** Alternate BC field names used on some `QyApprovalEntry` pages. */
function portalApprovalEntryDocumentFilters(no: string) {
  const escaped = odataString(no)
  // Query 50070 "Approval Entries" exposes DocumentNo and DocumentNo2 only —
  // there is no Document_No column, so that filter 400s on every lookup and
  // burns a full BC round trip. DocumentNo2 matters: this deployment leaves
  // "Document No." blank on some approval entries and carries the number in
  // "Document No2" (report 50314 exists purely to backfill the blank ones).
  return [
    `DocumentNo eq '${escaped}'`,
    `DocumentNo2 eq '${escaped}'`,
  ]
}

/** Document numbers BC may store on approval entries for a header row. */
export function approvalDocumentNoCandidates(
  spec: ModuleSpec,
  document: ODataRecord | undefined,
  fallbackNo: string,
) {
  const values: string[] = []
  const push = (value: string) => {
    const trimmed = value.trim()
    if (trimmed) values.push(trimmed)
  }
  push(fallbackNo)
  if (document) {
    push(resolveAttachmentDocNo(spec, document, fallbackNo))
    if (spec.module === 'transfer-order') {
      push(fieldText(document, ['GatePassNo', 'Gate_Pass_No']))
    }
    if (/^\d+$/.test(fallbackNo.trim())) {
      push(fallbackNo.trim().padStart(10, '0'))
    }
  }
  return [...new Set(values)]
}

/**
 * Records the last approval-entry lookup failure so callers can tell "BC says
 * there are no approvers" apart from "the approval query itself is broken".
 * Swallowing both as [] is what makes a misconfigured BC and an unpublished
 * QyApprovalEntry produce the identical, unactionable error.
 */
let lastApprovalLookupError: string | null = null

export function lastApprovalEntryLookupError() {
  return lastApprovalLookupError
}

async function queryApprovalEntries(filter: string) {
  try {
    const rows = (await fetchOData('QyApprovalEntry', { $filter: filter })) as
      | ODataRecord[]
      | null
    return Array.isArray(rows) ? rows : []
  } catch (error) {
    lastApprovalLookupError = error instanceof Error ? error.message : String(error)
    return [] as ODataRecord[]
  }
}

function approvalEntryKey(row: ODataRecord) {
  const entryNo = fieldText(row, ['EntryNo', 'Entry_No'])
  if (entryNo) return `entry:${entryNo}`
  const systemId = fieldText(row, ['SystemId', 'SystemID'])
  if (systemId) return `system:${systemId}`
  return JSON.stringify(row)
}

function dedupeApprovalEntries(rows: ODataRecord[]) {
  const seen = new Set<string>()
  const merged: ODataRecord[] = []
  for (const row of rows) {
    const key = approvalEntryKey(row)
    if (seen.has(key)) continue
    seen.add(key)
    merged.push(row)
  }
  return merged
}

function sortApprovalEntries(rows: ODataRecord[]) {
  return [...rows].sort((left, right) => {
    const leftSeq = Number(fieldText(left, ['SequenceNo', 'Sequence_No']) || 0)
    const rightSeq = Number(fieldText(right, ['SequenceNo', 'Sequence_No']) || 0)
    if (leftSeq !== rightSeq) return leftSeq - rightSeq
    const leftEntry = Number(fieldText(left, ['EntryNo', 'Entry_No']) || 0)
    const rightEntry = Number(fieldText(right, ['EntryNo', 'Entry_No']) || 0)
    return leftEntry - rightEntry
  })
}

async function collectApprovalEntriesForCandidate(spec: ModuleSpec, candidate: string) {
  const rows: ODataRecord[] = []
  rows.push(...(await queryApprovalEntries(portalApprovalEntryFilter(spec, candidate))))
  for (const documentFilter of portalApprovalEntryDocumentFilters(candidate)) {
    rows.push(...(await queryApprovalEntries(documentFilter)))
  }
  return rows
}

function approvalTableFilterForSpec(spec: ModuleSpec) {
  if (spec.module === 'purchase-requisition') {
    return `(${approvalTableFilter('purchaseRequisition')} or ${approvalTableFilter('purchaseOrder')})`
  }
  const approvalKey = MODULE_APPROVAL_KEYS[spec.module]
  if (approvalKey) return approvalTableFilter(approvalKey)
  return spec.headerTableId > 0 ? `TableID eq ${spec.headerTableId}` : ''
}

async function fetchApprovalEntriesByRecordId(spec: ModuleSpec, document: ODataRecord) {
  const recordId = fieldText(document, ['RecId', 'RecID', 'RecordID', 'SystemId', 'SystemID'])
  if (!recordId) return [] as ODataRecord[]

  const tableFilter = approvalTableFilterForSpec(spec)
  const numericId = Number(recordId)
  const isNumericRecordId =
    Number.isFinite(numericId) &&
    (String(numericId) === recordId.replace(/^0+/, '') || String(numericId) === recordId)
  // Query 50070 publishes no "Record ID to Approve" column, so a RecordID filter
  // can only 400. The guid'...' form is OData v3 syntax on top of that. Both
  // shapes cost a full BC round trip each and never return a row; SystemId is
  // the only identity column the query actually exposes.
  const idFilters = isNumericRecordId
    ? []
    : [`SystemId eq ${odataString(recordId)}`]

  for (const idFilter of idFilters) {
    const scoped = tableFilter ? `${idFilter} and ${tableFilter}` : idFilter
    const scopedRows = await queryApprovalEntries(scoped)
    if (scopedRows.length) return scopedRows
    const rows = await queryApprovalEntries(idFilter)
    if (rows.length) return rows
  }
  return [] as ODataRecord[]
}

/** ESS `getApprovers()` loads by document number; merge table-scoped and document-only rows. */
export async function fetchPortalApprovalEntries(
  spec: ModuleSpec,
  no: string,
  document?: ODataRecord,
): Promise<ODataRecord[]> {
  const candidates = approvalDocumentNoCandidates(spec, document, no)
  let collected: ODataRecord[] = []

  for (const candidate of candidates) {
    collected.push(...(await collectApprovalEntriesForCandidate(spec, candidate)))
  }

  collected = sortApprovalEntries(dedupeApprovalEntries(collected))
  if (collected.length) return collected

  if (document) {
    const byRecord = await fetchApprovalEntriesByRecordId(spec, document)
    if (byRecord.length) return sortApprovalEntries(dedupeApprovalEntries(byRecord))
  }

  // Some BC builds post transfer-order approvals against the linked gate pass number.
  if (spec.module === 'transfer-order' && document) {
    const gatePassNo = fieldText(document, ['GatePassNo', 'Gate_Pass_No'])
    const gatePassSpec = findModuleSpec('gate-pass')
    if (gatePassNo && gatePassSpec) {
      const gatePassEntries: ODataRecord[] = await fetchPortalApprovalEntries(gatePassSpec, gatePassNo)
      if (gatePassEntries.length) return gatePassEntries
    }
  }

  return [] as ODataRecord[]
}

function ownerValue(spec: ModuleSpec, user: AuthUser) {
  if (spec.ownerSource === 'employeeNo') return user.employeeNo
  if (spec.ownerSource === 'imprestNo') return user.imprestNo ?? ''
  return user.userID
}

function requestWithBody(body: Record<string, unknown>, params: Record<string, string> = {}) {
  return { body, params } as unknown as Request
}

export async function listPortalModuleRows(
  spec: ModuleSpec,
  user: AuthUser,
  options: { gatePassSource?: GatePassSourceKey; includeAll?: boolean } = {},
) {
  if (spec.module === 'salary-advance') {
    return sortNewestFirst(await fetchSalaryAdvanceRows(spec, user))
  }

  if (FUEL_MAINTENANCE_MODULES.has(spec.module)) {
    return sortNewestFirst(await fetchFuelMaintenanceRows(spec, user))
  }
  const filterParts =
    spec.module === 'gate-pass'
      ? gatePassListFilterParts(options.gatePassSource ?? 'storeIssue', user)
      : spec.unscopedList || options.includeAll
        ? []
        : [`${spec.ownerField} eq '${odataString(ownerValue(spec, user))}'`]
  if (spec.extraListFilter && spec.module !== 'gate-pass') filterParts.push(spec.extraListFilter)
  const fetched = await fetchOData(spec.headerService, {
    ...(filterParts.length ? { $filter: filterParts.join(' and ') } : {}),
  })
  let rows = Array.isArray(fetched) ? fetched : []
  if (spec.postListFilter) rows = rows.filter(spec.postListFilter)
  return sortNewestFirst(rows)
}

export async function getPortalModuleDocument(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  enforceOwner = true,
) {
  const headerKey = spec.headerKey ?? 'No'
  const ownerFilter = enforceOwner
    && !spec.unscopedList
    ? ` and ${spec.ownerField} eq '${odataString(ownerValue(spec, user))}'`
    : ''

  if (spec.module === 'gate-pass') {
    for (const key of ['GatePassNo', 'Gate_Pass_No']) {
      const rows = (await fetchOData(spec.headerService, {
        $filter: `${key} eq '${odataString(no)}'`,
        $top: 1,
      })) as ODataRecord[] | null
      if (Array.isArray(rows) && rows.length > 0) return rows[0]!
    }
    return null
  }

  if (FUEL_MAINTENANCE_MODULES.has(spec.module)) {
    for (const key of [headerKey, 'RequisitionNo', 'Requisition_No', 'No']) {
      const rows = (await fetchOData(spec.headerService, {
        $filter: `${key} eq '${odataString(no)}'`,
        $top: 1,
      })) as ODataRecord[] | null
      const row = Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
      if (!row) continue
      if (
        enforceOwner &&
        !spec.unscopedList &&
        !portalModuleDocumentOwnedByUser(row, spec, user)
      ) return null
      return row
    }
    return null
  }

  if (spec.module === 'salary-advance') {
    const customerNo = await resolveSalaryAdvanceCustomerNo(user, {})
    if (!customerNo) return null
    const rows = (await fetchOData(spec.headerService, {
      $filter: `${headerKey} eq '${odataString(no)}' and CustomerNo eq '${odataString(customerNo)}'`,
      $top: 1,
    })) as ODataRecord[] | null
    return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
  }

  const rows = (await fetchOData(spec.headerService, {
    $filter: `${headerKey} eq '${odataString(no)}'${ownerFilter}`,
    $top: 1,
  }).catch(() => null)) as ODataRecord[] | null
  if (Array.isArray(rows) && rows.length > 0) return rows[0]!

  const headerServices =
    spec.module === 'petty-cash'
      ? [spec.headerService, 'Paymentsheader', 'QyPaymentHeader', 'PaymentsHeader']
      : [spec.headerService]
  const headerKeys =
    spec.module === 'petty-cash' || spec.module === 'purchase-requisition'
      ? [...new Set([headerKey, 'No', 'No_'])]
      : [headerKey]
  for (const service of headerServices) {
    for (const key of headerKeys) {
      const altRows = (await fetchODataFirstBase(service, {
        $filter: `${key} eq '${odataString(no)}'${ownerFilter}`,
        $top: 1,
      }).catch(() => [])) as ODataRecord[]
      if (Array.isArray(altRows) && altRows.length > 0) return altRows[0]!
    }
  }

  // Purchase Header OData may expose No_ instead of No on older published queries.
  if (spec.module === 'purchase-requisition' && headerKey === 'No') {
    for (const altKey of ['No_', 'No']) {
      if (altKey === headerKey) continue
      const altRows = (await fetchOData(spec.headerService, {
        $filter: `${altKey} eq '${odataString(no)}'${ownerFilter}`,
        $top: 1,
      }).catch(() => null)) as ODataRecord[] | null
      if (Array.isArray(altRows) && altRows.length > 0) return altRows[0]!
    }
  }
  return null
}

/** Read the document lines exactly as the ESS controllers do, including transport's two passenger pages. */
export async function listPortalModuleLines(
  spec: ModuleSpec,
  header: ODataRecord,
  no: string,
) {
  if (spec.module === 'transport') {
    const [staffRows, externalRows] = await Promise.all([
      fetchOData('PgTransportStaffPassengers', {
        $filter: `Req_No eq '${odataString(no)}'`,
      }).catch(() => [] as ODataRecord[]),
      fetchOData('PgTransportExternalPassengers', {
        $filter: `Transport_No eq '${odataString(no)}'`,
      }).catch(() => [] as ODataRecord[]),
    ])
    const staff = (Array.isArray(staffRows) ? staffRows : []).map((row) => ({
      ...row,
      PassengerType: 'Staff',
      EmployeeNo: fieldText(row, ['EmployeeNo', 'No']),
      PassengerName: fieldText(row, ['Name', 'Passenger_Names']),
      PassengerOrganization: fieldText(row, ['Position', 'Passenger_Organization']),
      RecId: fieldText(row, ['SystemId', 'SystemID']),
    }))
    const external = (Array.isArray(externalRows) ? externalRows : []).map((row) => ({
      ...row,
      PassengerType: 'External',
      PassengerName: fieldText(row, ['Passenger_Names', 'Name']),
      PassengerOrganization: fieldText(row, ['Passenger_Organization', 'Organization']),
      RecId: fieldText(row, ['SystemId', 'SystemID']),
    }))
    return [...staff, ...external]
  }

  const gatePassBinding = spec.module === 'gate-pass' ? gatePassLineBinding(header, no) : null
  const lineService = gatePassBinding?.lineService ?? spec.lineService
  const lineHeaderField = gatePassBinding?.lineHeaderField ?? spec.lineHeaderField
  const lineDocumentNo = gatePassBinding?.documentNo ?? no
  if (!lineService || !lineHeaderField) return []
  // Hijra-parity: try primary + fallback line services (petty cash / purchase).
  const services = [lineService, ...(spec.lineFallbackServices ?? [])]
  const lineFilterKeys =
    spec.module === 'purchase-requisition'
      ? ['DocumentNo', 'Document_No_', 'Document_No']
      : spec.module === 'petty-cash'
        ? [lineHeaderField, 'DocumentNo', 'No', 'No_']
        : [lineHeaderField]
  let firstError: unknown = null
  const documentType = fieldText(header, ['DocumentType', 'Document_Type', 'Document_Type_'])
  for (const service of services) {
    for (const filterKey of lineFilterKeys) {
      const typedFilters =
        spec.module === 'purchase-requisition' && documentType
          ? [
              `${filterKey} eq '${odataString(lineDocumentNo)}' and DocumentType eq '${odataString(documentType)}'`,
              `${filterKey} eq '${odataString(lineDocumentNo)}'`,
            ]
          : [`${filterKey} eq '${odataString(lineDocumentNo)}'`]
      for (const filter of typedFilters) {
        try {
          const rows = await fetchOData(service, { $filter: filter })
          if (Array.isArray(rows) && rows.length > 0) return rows
        } catch (error) {
          firstError ??= error
        }
      }
    }
  }
  if (firstError) {
    console.warn(
      `[portal-lines] ${spec.module} ${lineDocumentNo}: no published line service returned rows (${services.join(', ')})`,
    )
  }
  return []
}

function lineHasContent(line: Record<string, unknown>) {
  return Object.entries(line).some(([key, value]) => {
    if (['action', 'lineNo', 'id', 'recId'].includes(key)) return false
    const raw = String(value ?? '').trim()
    return raw !== '' && raw !== '0'
  })
}

function portalLineBodies(spec: ModuleSpec, body: Record<string, unknown>) {
  if (spec.module === 'transport') {
    const passengers = Array.isArray(body.passengers)
      ? (body.passengers as Record<string, unknown>[])
      : []
    return passengers.filter(lineHasContent)
  }
  const lines = Array.isArray(body.lines) ? (body.lines as Record<string, unknown>[]) : []
  return lines.filter(lineHasContent)
}

function attachmentBodies(body: Record<string, unknown>) {
  return Array.isArray(body.attachments)
    ? (body.attachments as Record<string, unknown>[])
    : []
}

function attachmentFileName(attachment: Record<string, unknown>) {
  const originalName = String(attachment.fileName ?? 'attachment')
  const extension = originalName.includes('.') ? originalName.split('.').pop() : ''
  const description = String(attachment.description ?? '').trim()
  if (!description) {
    throw Object.assign(new Error('Attachment description is required'), { status: 422 })
  }
  return `${description}${extension ? `.${extension}` : ''}`.replaceAll(' ', '-').replaceAll('/', '_')
}

function attachmentOk(result: SoapResult) {
  if (result.returnValue == null) return false
  const value = String(result.returnValue).trim()
  return Boolean(value) && value.toLowerCase() !== 'false'
}

export async function createPortalModuleRequest(
  spec: ModuleSpec,
  user: AuthUser,
  body: Record<string, unknown>,
) {
  if (!spec.soap.saveHeader || !spec.params?.saveHeader) {
    throw Object.assign(new Error(`${spec.module} creation is not supported by Business Central`), {
      status: 501,
    })
  }

  const headerBody =
    spec.module === 'fuel'
      ? { ...body, requestType: fuelTypeCode(body.requestType ?? 'Vehicle fuel') }
      : spec.module === 'maintenance'
        ? { ...body, requestType: maintenanceTypeCode(body.requestType) }
        : body
  const headerRequest = requestWithBody(headerBody)
  const headerKey = spec.headerKey ?? 'No'
  const numberAliases = [headerKey, 'No', 'RequisitionNo', 'Transport_Requisition_No']
  // Boolean-return creates (transport, fuel) return only true/false, so we detect the new
  // document by diffing rows before/after. Combine the owner-scoped read (keeps module-specific
  // logic, e.g. fuel) with an UNSCOPED read: BC may stamp the owner field with the employee's BC
  // User ID, which can differ from the portal session user, so an owner-only read can miss it.
  const readbackRows = async (): Promise<ODataRecord[]> => {
    const scoped = await listPortalModuleRows(spec, user)
    const fetched = await fetchOData(spec.headerService, {})
    return [...scoped, ...(Array.isArray(fetched) ? fetched : [])]
  }
  const existingNumbers = spec.headerReturnsBoolean
    ? new Set((await readbackRows()).map((row) => fieldText(row, numberAliases)))
    : null
  const headerParams = await spec.params.saveHeader({
    req: headerRequest,
    user,
    no: '',
  })
  const headerResult = await callSoapMethod(spec.soap.saveHeader, headerParams)
  if (!ok(headerResult)) {
    throw Object.assign(new Error(`Business Central did not create the ${spec.module} request`), {
      status: 502,
    })
  }
  let no = String(headerResult.returnValue ?? '').trim()
  if (spec.headerReturnsBoolean) {
    no = ''
    for (let attempt = 0; attempt < 6 && !no; attempt += 1) {
      if (attempt > 0) await new Promise((resolve) => setTimeout(resolve, 300))
      const created = (await readbackRows()).find((row) => {
        const candidate = fieldText(row, numberAliases)
        return candidate && !existingNumbers?.has(candidate)
      })
      no = created ? fieldText(created, numberAliases) : ''
    }
  }
  if (!no) {
    throw Object.assign(
      new Error(`Business Central created the ${spec.module} request but did not return its document number`),
      { status: 502 },
    )
  }

  if (spec.soap.saveLine && spec.params?.saveLine) {
    const lines = portalLineBodies(spec, body)
    for (let index = 0; index < lines.length; index += 1) {
      const line = {
        ...body,
        ...lines[index],
        action: 'create',
        lineNo: Number(lines[index]?.lineNo ?? (index + 1) * 10000),
      }
      const lineParams = await spec.params.saveLine({
        req: requestWithBody(line),
        user,
        no,
      })
      const lineResult = await callSoapMethod(spec.soap.saveLine, lineParams)
      if (!ok(lineResult)) {
        throw Object.assign(
          new Error(`Business Central created ${no}, but line ${index + 1} failed`),
          { status: 502, documentNo: no },
        )
      }
    }
  }

  for (const attachment of attachmentBodies(body)) {
    const contentBase64 = String(attachment.contentBase64 ?? '').replace(/^data:[^,]+,/, '')
    if (!contentBase64) continue
    const fileName = String(attachment.fileName ?? '')
    const description = String(attachment.description ?? '').trim()
    if (!description) {
      throw Object.assign(new Error('Attachment description is required'), { status: 422 })
    }
    const extension = fileName.split('.').pop()?.toLowerCase() ?? ''
    if (!ALLOWED_ATTACHMENT_EXTENSIONS.has(extension)) {
      throw Object.assign(new Error(`${fileName || 'Attachment'} is not an allowed file type`), {
        status: 422,
      })
    }
    if (Buffer.from(contentBase64, 'base64').byteLength > MAX_ATTACHMENT_BYTES) {
      throw Object.assign(new Error(`${fileName || 'Attachment'} exceeds the 10 MB limit`), {
        status: 422,
      })
    }
    const uploadResult = await callSoapMethod('UploadDocumentAttachment', {
      docNo: no,
      docNo2: no,
      description,
      tableID: spec.headerTableId,
      file: contentBase64,
      fileName: attachmentFileName(attachment),
    })
    if (!attachmentOk(uploadResult)) {
      throw Object.assign(
        new Error(`Business Central created ${no}, but an attachment upload failed`),
        { status: 502, documentNo: no },
      )
    }
  }

  if (body.submit === true && spec.soap.submit && spec.params?.submit) {
    const submitParams = await spec.params.submit({
      req: requestWithBody(body),
      user,
      no,
    })
    const submitResult = await callSoapMethod(spec.soap.submit, submitParams)
    if (!ok(submitResult)) {
      throw Object.assign(
        new Error(`Business Central created ${no}, but approval submission failed`),
        { status: 502, documentNo: no },
      )
    }
  }

  return no
}

export async function cancelPortalModuleRequest(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
) {
  if (!spec.soap.cancel || !spec.params?.cancel) {
    throw Object.assign(new Error(`${spec.module} cancellation is not supported`), {
      status: 501,
    })
  }
  const document = spec.module === 'gate-pass'
    ? await getPortalModuleDocument(spec, user, no, false)
    : null
  const params = await spec.params.cancel({
    req: requestWithBody({
      transferNo: document?.TransferNo ?? document?.Transfer_No ?? '',
    }),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.cancel, params)
  if (!soapActionOk(spec, result)) {
    throw Object.assign(new Error(`Business Central did not cancel ${no}`), { status: 502 })
  }
}

export async function deletePortalModuleDocument(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
) {
  if (!spec.soap.deleteDocument || !spec.params?.deleteDocument) {
    throw Object.assign(
      new Error(`${spec.module} draft delete is not supported`),
      { status: 501, code: 'DELETE_NOT_SUPPORTED' },
    )
  }
  const header = await getPortalModuleDocument(spec, user, no, false)
  if (!header) {
    throw Object.assign(new Error(`Business Central document ${no} was not found`), {
      status: 404,
    })
  }
  const params = await spec.params.deleteDocument({
    req: requestWithBody({}),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.deleteDocument, params)
  if (!ok(result) && !approvalOk(result)) {
    throw Object.assign(
      new Error(
        typeof result.returnValue === 'string' && result.returnValue
          ? String(result.returnValue)
          : `Business Central did not delete draft ${no}`,
      ),
      { status: 422, code: 'DOCUMENT_DELETE_FAILED' },
    )
  }
}

export async function submitPortalModuleRequest(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
) {
  if (!spec.soap.submit || !spec.params?.submit) {
    throw Object.assign(new Error(`${spec.module} submission is not supported`), {
      status: 501,
    })
  }
  const header = await getPortalModuleDocument(spec, user, no, false)
  if (!header) {
    throw Object.assign(new Error(`Business Central document ${no} was not found`), { status: 404 })
  }
  await assertRequiredPortalAttachment(spec, no)
  if (!canRequestApprovalForSpec(spec.module, header)) {
    throw Object.assign(new Error(requestApprovalBlockedMessage(spec.module, header)), {
      status: 422,
    })
  }
  if (spec.module === 'inter-bank-transfer') {
    const sourceAmount = Number(header.Source_Amount ?? header.SourceAmount ?? 0)
    const payingAccount = fieldText(header, ['Paying_Account', 'PayingAccount'])
    const receivingAccount = fieldText(header, ['Receiving_Account', 'ReceivingAccount'])
    if (sourceAmount <= 0 || !payingAccount || !receivingAccount) {
      throw Object.assign(
        new Error(
          'Complete the paying account, receiving account, and source amount before requesting approval.',
        ),
        { status: 422 },
      )
    }
  }
  if (spec.module === 'purchase-requisition') {
    const budgetType = fieldText(header, ['BudgetType', 'Budget_Type', 'budgetType'])
    const projectCode = fieldText(header, ['ProjectCode', 'Project_Code', 'projectCode'])
    const isProjectBudget =
      budgetType === '0' || budgetType.toLowerCase() === 'project'
    if (isProjectBudget && !projectCode) {
      throw Object.assign(
        new Error(
          'Cannot send for approval: Budget Type is Project but Project Name / Code is missing. Click Edit, set Budget Type to Non-Project (or enter a project code), save, then try Request Approval again.',
        ),
        { status: 422, code: 'PURCHASE_PROJECT_CODE_REQUIRED' },
      )
    }
  }
  if (spec.module === 'salary-advance') {
    const lines = await listPortalModuleLines(spec, header, no)
    const percentage = Number(
      header.PercentageofSalary ??
        header.PercentageOfSalary ??
        header.Percentage_of_Salary ??
        lines[0]?.PercentageofSalary ??
        lines[0]?.PercentageOfSalary ??
        lines[0]?.Percentage_of_Salary ??
        0,
    )
    const purpose = fieldText(header, ['Purpose', 'purpose'])
    if (!purpose.trim()) {
      throw Object.assign(new Error('Enter the salary advance purpose before requesting approval.'), {
        status: 422,
      })
    }
    if (percentage <= 0) {
      throw Object.assign(
        new Error('Save the salary advance with a valid percentage before requesting approval.'),
        { status: 422 },
      )
    }
  }
  const document = spec.module === 'gate-pass' ? header : null
  const params = await spec.params.submit({
    req: requestWithBody({
      transferNo: fieldText(document ?? {}, ['TransferNo', 'Transfer_No']),
    }),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.submit, params)
  if (!soapActionOk(spec, result)) {
    if (spec.module === 'fuel' || spec.module === 'maintenance') {
      const docType = fieldText(header, ['DocumentType', 'Document_Type'])
      const hint = docType
        ? ` Enable the Business Central approval workflow for "${docType}" (table ${spec.headerTableId}).`
        : ` Enable the Business Central approval workflow for this document type (table ${spec.headerTableId}).`
      throw Object.assign(new Error(`Business Central did not submit ${no}.${hint}`), { status: 502 })
    }
    throw Object.assign(new Error(`Business Central did not submit ${no}`), { status: 502 })
  }

  const portalModule = MODULE_APPROVAL_KEYS[spec.module]
  if (portalModule) {
    let verified = false
    for (let attempt = 0; attempt < 3; attempt++) {
      const refreshed = await getPortalModuleDocument(spec, user, no, false)
      if (!refreshed) break
      const approvers = await fetchPortalApprovalEntries(spec, no, refreshed)
      const resolved = resolveModuleRequestStatus(
        refreshed,
        portalModule as PortalModuleKey,
        approvers,
      )
      if (
        (resolved !== 'Open' && resolved !== 'Draft') ||
        approvers.length > 0 ||
        documentSentForApproval(refreshed)
      ) {
        verified = true
        break
      }
      if (attempt < 2) {
        await new Promise((resolve) => setTimeout(resolve, 400))
      }
    }
    if (!verified) {
      const facilityHint =
        spec.module === 'store-requisition' || spec.module === 'purchase-requisition'
          ? ' Enable the Business Central approval workflow for this document type and confirm approvers are assigned.'
          : ' Confirm the approval workflow is enabled and approvers are configured.'
      throw Object.assign(
        new Error(`Business Central did not start approval for ${no}.${facilityHint}`),
        { status: 502 },
      )
    }
  }
}

/**
 * Update the header of an existing document (ESS "edit" flow). Mirrors the
 * `POST /:no/edit` branch of `buildModuleRouter` but callable from the React
 * `/api/requests/:id` JSON contract.
 */
export async function updatePortalModuleHeader(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  body: Record<string, unknown>,
) {
  if (!spec.soap.saveHeader || !spec.params?.saveHeader) {
    throw Object.assign(new Error(`${spec.module} header editing is not supported`), {
      status: 501,
    })
  }
  let methodName = spec.soap.saveHeader
  if (spec.module === 'inter-bank-transfer') {
    methodName = 'FnUpdateInterBankTransfer'
  }
  const editBody = await resolveRecIdHeaderEditBody(spec, user, no, body)
  const params = await spec.params.saveHeader({
    req: requestWithBody(editBody),
    user,
    no,
  })
  const result = await callSoapMethod(methodName, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not update ${no}`), { status: 502 })
  }
}

/**
 * Create or edit a single line on an existing document. `body.action`
 * (`create`/`edit`) drives the BC behaviour; defaults to create.
 */
export async function savePortalModuleLine(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  body: Record<string, unknown>,
) {
  if (!spec.soap.saveLine || !spec.params?.saveLine) {
    throw Object.assign(new Error(`${spec.module} does not support line editing`), {
      status: 501,
    })
  }
  const params = await spec.params.saveLine({ req: requestWithBody(body), user, no })
  const result = await callSoapMethod(spec.soap.saveLine, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not save the ${spec.module} line`), {
      status: 502,
    })
  }
  return result.returnValue
}

/** Replace all lines: delete existing ones, then create the supplied set. */
export async function setPortalModuleLines(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  lines: Record<string, unknown>[],
) {
  for (let index = 0; index < lines.length; index += 1) {
    const incoming = lines[index] ?? {}
    await savePortalModuleLine(spec, user, no, {
      ...incoming,
      action: incoming.action ?? (incoming.lineNo ? 'edit' : 'create'),
      lineNo: Number(incoming.lineNo ?? (index + 1) * 10000),
    })
  }
}

export async function deletePortalModuleLine(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  lineNo: string,
) {
  if (!spec.soap.deleteLine || !spec.params?.deleteLine) {
    throw Object.assign(new Error(`${spec.module} does not support line deletion`), {
      status: 501,
    })
  }
  let deleteBody: Record<string, unknown> = {}
  if (spec.module === 'transport') {
    const header = await getPortalModuleDocument(spec, user, no)
    if (!header) {
      throw Object.assign(new Error(`Transport request ${no} was not found`), { status: 404 })
    }
    const passengers = await listPortalModuleLines(spec, header, no)
    const passenger = passengers.find(
      (row) => fieldText(row, ['RecId', 'recId', 'SystemId', 'SystemID']) === lineNo,
    )
    if (!passenger) {
      throw Object.assign(new Error(`Transport passenger ${lineNo} was not found`), { status: 404 })
    }
    deleteBody = { passengerType: fieldText(passenger, ['PassengerType', 'Type']) }
  }
  const params = await spec.params.deleteLine({
    req: requestWithBody(deleteBody, { lineNo }),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.deleteLine, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not delete line ${lineNo}`), {
      status: 502,
    })
  }
}

export function resolveAttachmentDocNo(spec: ModuleSpec, document: ODataRecord, fallbackNo: string) {
  const headerKey = spec.headerKey ?? 'No'
  return fieldText(document, [
    headerKey,
    'No',
    'RequisitionNo',
    'Transport_Requisition_No',
    'GatePassNo',
    'Gate_Pass_No',
    'ApplicationCode',
  ], fallbackNo)
}

export function moduleSpecSupportsAttachments(spec: ModuleSpec) {
  return spec.supportsAttachments === true
}

export async function uploadPortalAttachment(
  tableID: number,
  no: string,
  attachment: Record<string, unknown>,
) {
  const contentBase64 = String(attachment.contentBase64 ?? '').replace(/^data:[^,]+,/, '')
  if (!contentBase64) {
    throw Object.assign(new Error('Attachment content is required'), { status: 422 })
  }
  const description = String(attachment.description ?? '').trim()
  if (!description) {
    throw Object.assign(new Error('Attachment description is required'), { status: 422 })
  }
  const fileName = String(attachment.fileName ?? '')
  const extension = fileName.split('.').pop()?.toLowerCase() ?? ''
  if (!ALLOWED_ATTACHMENT_EXTENSIONS.has(extension)) {
    throw Object.assign(new Error(`${fileName || 'Attachment'} is not an allowed file type`), {
      status: 422,
    })
  }
  if (Buffer.from(contentBase64, 'base64').byteLength > MAX_ATTACHMENT_BYTES) {
    throw Object.assign(new Error(`${fileName || 'Attachment'} exceeds the 10 MB limit`), {
      status: 422,
    })
  }
  const result = await callSoapMethod('UploadDocumentAttachment', {
    docNo: no,
    docNo2: no,
    description,
    tableID,
    file: contentBase64,
    fileName: attachmentFileName(attachment),
  })
  if (!attachmentOk(result)) {
    throw Object.assign(new Error('Business Central did not store the attachment'), {
      status: 502,
    })
  }
}

export async function uploadPortalModuleAttachment(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  attachment: Record<string, unknown>,
) {
  if (!moduleSpecSupportsAttachments(spec)) {
    throw Object.assign(
      new Error('Attachments are not supported for this document type in Business Central'),
      { status: 501 },
    )
  }
  const document = await getPortalModuleDocument(spec, user, no, false)
  if (!document) {
    throw Object.assign(new Error(`Business Central record ${no} was not found`), { status: 404 })
  }
  const docNo = resolveAttachmentDocNo(spec, document, no)
  return uploadPortalAttachment(spec.headerTableId, docNo, attachment)
}

export function buildModulesRouter(): Router {
  const root = Router()

  // Stubs first so they reply 501 even without auth — the SPA can detect
  // unsupported modules without first prompting for login.
  for (const stub of STUB_MODULES) {
    root.use(`/${stub.module}`, buildStubRouter(stub.reason))
  }

  // All implemented module routes require an authenticated session.
  for (const spec of MODULE_SPECS) {
    root.use(`/${spec.module}`, requireAuth, buildModuleRouter(spec))
  }
  return root
}
