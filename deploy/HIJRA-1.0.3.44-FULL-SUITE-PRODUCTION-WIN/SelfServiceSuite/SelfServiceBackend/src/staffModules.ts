import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import {
  callSoapMethod,
  codeunitSoapNamespace,
  deriveCodeunitSoapUrl,
  fetchOData,
  odataString,
  type ODataRecord,
} from './bcClient.js'
import { config } from './config.js'
import { approvalTableFilter, type ApprovalTableKey } from './approvalTableIds.js'
import { uploadViaPortalAttachments } from './portalAttachments.js'
import { requireAuth } from './auth.js'
import type { AuthUser } from './auth.js'
import { fetchEmployeeCustomerAccountNo, ensureEmployeeDepartmentCodeForFinance } from './employeeProfile.js'
import { formatBcSoapDate, formatBcSoapDateOrBlank } from './staff.js'
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
const ALLOWED_ATTACHMENT_EXTENSIONS = new Set(['pdf', 'doc', 'docx', 'jpeg', 'jpg', 'png'])

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
    | 'RaisedBy'
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
  /** OData field linking lines to the header (e.g. `No`, `RequistionNo`, …). */
  lineHeaderField?: string

  /** SOAP methods used to mutate the document. */
  soap: {
    saveHeader?: string
    /** When set, edits (`/:no/edit`) call this instead of `saveHeader`. */
    editHeader?: string
    saveLine?: string
    deleteLine?: string
    submit?: string
    cancel?: string
  }

  /** Per-module SOAP parameter builders. */
  params?: {
    saveHeader?: ParamBuilder
    saveLine?: ParamBuilder
    deleteLine?: ParamBuilder
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
  /**
   * Table IDs to try when listing document attachments (defaults to
   * `[headerTableId]`). Purchase requisitions store attachments against the
   * real Purchase Header table (38) via CuPortalAttachments so BC users see
   * them in the standard attachments FactBox, while the legacy ESS id
   * (52121800) is kept for anything uploaded by older builds.
   */
  attachmentTableIds?: number[]
  /** Route uploads through the additive CuPortalAttachments codeunit instead of ESS UploadDocumentAttachment. */
  attachmentUploadVia?: 'portalAttachments'
  /** Table ID passed to the upload SOAP (defaults to `headerTableId`). */
  attachmentUploadTableId?: number
  /**
   * Published-codeunit web service that hosts this module's SOAP methods.
   * Defaults to the main CuStaffPortal service; additive portal codeunits
   * (e.g. CuPortalAssetTransfer) declare their own service name here.
   */
  soapService?: string
}

/** SOAP endpoint for an additive portal codeunit, derived from the main portal URL. */
export function portalSoapEndpoint(serviceName: string) {
  return {
    url: deriveCodeunitSoapUrl(config.BC_SOAP_CODEUNIT_URL, serviceName),
    namespace: codeunitSoapNamespace(serviceName),
  }
}

/** Route a module's SOAP call to its own codeunit service when one is declared. */
function moduleSoapEndpoint(spec: ModuleSpec) {
  return spec.soapService ? portalSoapEndpoint(spec.soapService) : undefined
}

const SCHEMAS = {
  saveHeader: z.object({}).passthrough(),
  saveLine: z.object({}).passthrough(),
  deleteLine: z.object({}).passthrough(),
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
    spec.module === 'maintenance'
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
    // Always scope to the logged-in employee — never show another staff member's
    // gate passes on their portal (UAT: Meseret saw Beza's Asset Transfer GPs).
    scopeToEmployee: true,
  },
  assetTransfer: {
    label: 'Asset Transfer Requisitions',
    linkTo: 'Asset Transfer',
    lineService: 'QyTransferShipmentLine',
    lineHeaderField: 'DocumentNo',
    scopeToEmployee: true,
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
  // Always scope every gate-pass source to the logged-in employee.
  filters.unshift(`EmployeeNo eq '${odataString(user.employeeNo)}'`)
  return filters
}

/** Local ownership check when BC OData $filter is ignored/rejected. */
export function gatePassRowOwnedByUser(row: ODataRecord, user: AuthUser) {
  const wanted = new Set(
    [user.employeeNo, user.userID]
      .map((value) => String(value ?? '').trim().toUpperCase())
      .filter(Boolean),
  )
  if (wanted.size === 0) return false
  for (const key of ['EmployeeNo', 'Employee_No', 'RequesterID', 'Requester_ID', 'RaisedBy', 'Raised_By']) {
    const value = String(row[key] ?? '').trim().toUpperCase()
    if (value && wanted.has(value)) return true
  }
  return false
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

function purchaseLineTypeCode(value: unknown) {
  return numericCode(value, { service: 1, item: 2, asset: 4 })
}

/**
 * BC stores the city/field choice in FLT-Transport Requisition "Vehicle Type",
 * an Option whose members are (" ", City, Trip) — so City = 1 and Trip = 2,
 * NOT 0 and 1. Sending 0/1 (the old scheme) wrote blank/City, which is why a
 * Field request "became City" in UAT. Text labels are the canonical input; raw
 * numbers are interpreted as the legacy 0=City / 1=Field scheme and remapped.
 */
function transportRequestTypeCode(value: unknown) {
  const raw = String(value ?? '').trim().toLowerCase()
  if (raw === 'city') return 1
  if (raw === 'trip' || raw === 'field' || raw === 'field trip') return 2
  if (raw === '0' || raw === '1') return raw === '0' ? 1 : 2
  if (raw === '2') return 2
  return 1
}

export function hospitalCategoryCode(value: unknown) {
  return numericCode(value, { government: 1, private: 2, online: 3 })
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
    submit: 'RequestImprestApproval',
    cancel: 'CancelImprestRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      docNo: no,
      employeeNo: user.employeeNo,
      dateRequired: formatBcSoapDate(String(req.body?.dateRequired ?? req.body?.startDate ?? '')),
      purpose: req.body?.purpose ?? '',
      myUserId: user.userID,
      travelDestination: req.body?.travelDestination ?? req.body?.placeOfDuty ?? '',
      travelDate: formatBcSoapDate(String(req.body?.travelDate ?? req.body?.startDate ?? '')),
      returnDate: formatBcSoapDate(String(req.body?.returnDate ?? '')),
    }),
    saveLine: ({ req, user, no }) => ({
      action: req.body?.action ?? 'create',
      docNo: no,
      lineNo: Number(req.body?.lineNo ?? 0),
      destination: req.body?.destination ?? req.body?.description ?? '',
      noOfDays: Number(req.body?.noOfDays ?? 0),
      employeeNo: user.employeeNo,
      advanceType: req.body?.advanceType ?? req.body?.expenseType ?? '',
      dutyArea: req.body?.dutyArea ?? '',
      amount: Number(req.body?.amount ?? 0),
    }),
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
    submit: 'RequestImprestSurrenderApproval',
    cancel: 'CancelImprestSurrender',
  },
  params: {
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
    submit: 'RequestClaimApproval',
    cancel: 'CancelClaimRequisition',
  },
  params: {
    saveHeader: async ({ req, user, no }) => {
      const dims = await ensureEmployeeDepartmentCodeForFinance(user.employeeNo, {
        department: user.department,
        branchCode: user.branchCode,
      })
      const claimDescription = String(
        req.body?.purpose ?? req.body?.claimDescription ?? req.body?.description ?? '',
      ).trim()
      const payload: Record<string, unknown> = {
        action: no ? 'edit' : 'create',
        reqNo: no,
        staffNo: user.employeeNo,
        claimDescription,
        claimDate: formatBcSoapDate(String(req.body?.claimDate ?? '')),
        myUserID: user.userID,
      }
      if (dims.departmentCode) payload.department = dims.departmentCode
      return payload
    },
    saveLine: ({ req, no }) => {
      const claimType = claimTypeCode(req.body?.claimType)
      const medical = isMedicalClaimType(claimType)
      const payload: Record<string, unknown> = {
        action: req.body?.action ?? 'create',
        amount: Number(req.body?.amount ?? req.body?.grossAmount ?? 0),
        reqNo: no,
        claimType,
        accountNo: req.body?.accountNo ?? '',
        medicalAmount: medical ? Number(req.body?.medicalAmount ?? 0) : 0,
        claimReceiptNo: req.body?.claimReceiptNo ?? '',
        expenditureDescription:
          req.body?.expenditureDescription ?? req.body?.description ?? '',
        lineNo: Number(req.body?.lineNo ?? 0),
        expenditureDate: formatBcSoapDate(String(req.body?.expenditureDate ?? '')),
        hospitalCategory: medical
          ? hospitalCategoryCode(req.body?.hospitalCategory)
          : 0,
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
      tableID: 50885,
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
  lineHeaderField: 'No',
  soap: {
    saveHeader: 'FnPettyCashHeader',
    saveLine: 'FnPettyCashLine',
    deleteLine: 'FnPettyCashLine',
    submit: 'RequestPettyCashApproval',
    cancel: 'CancelPettyCashRequest',
  },
  params: {
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
/**
 * UAT 18/07/2026: "petty cash limit depend on department" — block Petty Cash Requests
 * above the department limit. Reads BC table 51043 "Petty Cash Limit-Department" via
 * the QyPettyCashLimitDepartment query (published 25/07/2026). Fails open when the
 * service is unreachable or no limit row exists, so a BC hiccup never blocks finance;
 * the ERP-side approval remains the authoritative check.
 */
async function assertWithinPettyCashDepartmentLimit(departmentCode: string, requestedAmount: number) {
  if (!departmentCode || !(requestedAmount > 0)) return
  let rows: ODataRecord[] | null = null
  try {
    rows = (await fetchOData('QyPettyCashLimitDepartment', {
      $filter: `DepartmentCode eq '${odataString(departmentCode)}'`,
      $top: 1,
    })) as ODataRecord[] | null
  } catch {
    return
  }
  const row = Array.isArray(rows) ? rows[0] : undefined
  if (!row) return
  const limit = Number(String(row.Limit ?? '').replaceAll(',', ''))
  if (!Number.isFinite(limit) || limit <= 0) return
  if (requestedAmount > limit) {
    throw Object.assign(
      new Error(
        `The requested amount (${requestedAmount.toLocaleString()}) exceeds the petty cash limit of ${limit.toLocaleString()} for department ${departmentCode}. Reduce the amount or contact Finance.`,
      ),
      { status: 422 },
    )
  }
}

const interBankTransfer: ModuleSpec = {
  module: 'inter-bank-transfer',
  headerService: 'PgInterBankTransfers',
  headerTableId: 50883,
  supportsAttachments: true,
  ownerField: 'Employee_No',
  ownerSource: 'employeeNo',
  soap: {
    saveHeader: 'FnSaveInterBankTransfer', // edit branch swapped at runtime
    submit: 'RequestInterBankTransferApproval',
    cancel: 'CancelInterBankTransferRequest',
  },
  params: {
    saveHeader: async ({ req, user, no }) => {
      // Serves the portal's "Petty Cash Request" — enforce the department limit on create/edit.
      await assertWithinPettyCashDepartmentLimit(
        String(req.body?.department ?? user.department ?? '').trim(),
        Number(req.body?.sourceAmount ?? 0),
      )
      return {
        myUserId: user.userID,
        staffNo: user.employeeNo,
        myAction: no ? 'edit' : 'create',
        sector: req.body?.sector ?? '',
        remarks: req.body?.remarks ?? '',
        division: req.body?.division ?? '',
        department: req.body?.department ?? '',
        dateCreated: req.body?.dateCreated ?? '',
        sourceAmount: Number(req.body?.sourceAmount ?? 0),
        payingAccount: req.body?.payingAccount ?? '',
        receivingAmount: Number(req.body?.receivingAmount ?? 0),
        receivingAccount: req.body?.receivingAccount ?? '',
        interBankTransferNo: no,
      }
    },
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
  ownerField: 'UserID',
  ownerSource: 'userID',
  lineService: 'QyStoreRequisitionLines',
  lineHeaderField: 'RequistionNo',
  soap: {
    saveHeader: 'StoreRequisitionHeader',
    saveLine: 'StoreRequisitionLine',
    deleteLine: 'DeleteStoreReqLine',
    submit: 'RequestStoreReqApproval',
    cancel: 'CancelStoreRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      docNo: no,
      myUserID: user.userID,
      requestDescription:
        req.body?.description ??
        req.body?.requestDescription ??
        req.body?.justification ??
        '',
      requestDate: req.body?.dateRequired ?? req.body?.requestDate ?? '',
      // Header-level Issuing Store (BC Store Requisition Header UP parity).
      // AL 1.0.2.361+ declares the parameter, so it must always be present —
      // omitting it makes BC fail with "Parameter ... is null!". Blank keeps
      // the AL default (the parameter is only applied when non-empty).
      issuingStore: String(
        req.body?.issuingStore ?? req.body?.headerIssuingStore ?? '',
      ).trim(),
    }),
    saveLine: async ({ req, no }) => {
      // ERP parity: BC's Store Requisition lines subform links lines to the
      // HEADER's Issuing Store — a line saved with a different store becomes
      // invisible on the BC page. Prefer the header's store for every line;
      // fall back to the line's own value for pre-.361 headers without one.
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
        // keep the line-level value
      }
      return {
        action: req.body?.action ?? 'create',
        reqNo: no,
        lineNo: Number(req.body?.lineNo ?? 0),
        type: storeLineTypeCode(req.body?.type),
        itemNo: req.body?.item ?? req.body?.itemNo ?? req.body?.itemCode ?? '',
        quantity:
          storeLineTypeCode(req.body?.type) === 1
            ? Number(req.body?.quantity ?? 0)
            : 0,
        location: headerStore || (req.body?.issuingStore ?? req.body?.location ?? ''),
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
  ownerField: 'AssignedUserID',
  ownerSource: 'userID',
  extraListFilter: `DocApprovalType eq 'Requisition'`,
  lineService: 'QyPurchaseLine',
  lineHeaderField: 'Document_No_',
  // UAT R4: specification documents must attach to the requisition. Uploads go
  // through the additive CuPortalAttachments codeunit against the real
  // Purchase Header table (38) so they also show in the BC attachments FactBox.
  supportsAttachments: true,
  attachmentUploadVia: 'portalAttachments',
  attachmentUploadTableId: 38,
  attachmentTableIds: [38, 52121800],
  soap: {
    saveHeader: 'PurchaseRequisitionHeader',
    saveLine: 'PurchaseRequisitionLine',
    deleteLine: 'DeletePurchaseReqLine',
    submit: 'RequestPurchaseReqApproval',
    cancel: 'CancelPurchaseRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      reqNo: no,
      postingDescription:
        req.body?.description ??
        req.body?.postingDescription ??
        req.body?.reason ??
        '',
      pricesIncludingVAT: false,
      myUserId: user.userID,
      orderDate:
        req.body?.dateNeeded ?? req.body?.orderDate ?? req.body?.requestDate ?? '',
      // Requesting Department picked in the portal (BC dimension code, e.g.
      // FACILTY/HC). Blank keeps the AL default of the employee's own
      // department dimension. AL 1.0.2.361+ declares the parameter, so it
      // must always be present — omitting it makes BC fail with
      // "Parameter requestingDepartment ... is null!".
      requestingDepartment: String(
        req.body?.requestingDepartment ?? req.body?.departmentCode ?? '',
      ).trim(),
    }),
    saveLine: ({ req, no }) => ({
      action: req.body?.action ?? 'create',
      reqNo: no,
      lineNo: Number(req.body?.lineNo ?? 0),
      itemNo: req.body?.itemNo ?? req.body?.itemCode ?? '',
      quantity: Number(req.body?.quantity ?? 0),
      location: req.body?.whereNeeded ?? req.body?.location ?? '',
      type: purchaseLineTypeCode(req.body?.type),
      procurementPlan: req.body?.procurementPlan ?? '',
      reasonForRequest:
        req.body?.reason ??
        req.body?.reasonForRequest ??
        req.body?.description ??
        req.body?.specification ??
        '',
      // R4: free-text specification the requestor types for FA/Service/Item
      // lines; AL writes it to Purchase Line "Description" (overriding the
      // value auto-filled from Validate("No.")) when non-blank. AL 1.0.2.361+
      // declares the parameter, so it must always be present.
      specification: String(
        req.body?.specification ?? req.body?.itemDescription ?? '',
      ).trim(),
    }),
    deleteLine: ({ req, no }) => ({
      requisitionNo: no,
      lineNo: req.params.lineNo,
    }),
    submit: ({ user, no }) => ({
      reqNo: no,
      employeeNo: user.employeeNo,
      tableID: 52121800,
    }),
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
    submit: 'RequestTransportReqApproval',
    cancel: 'CancelTransportRequisition',
  },
  params: {
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

function fuelMaintenanceDocType(row: ODataRecord) {
  // QyPortalFuelMaint publishes BC "Type" as Type_Field (AL column rename).
  return String(row.Type ?? row.Type_Field ?? row.DocumentType ?? row.Document_Type ?? '')
    .trim()
    .toLowerCase()
}

function portalMaintenancePurpose(row: ODataRecord) {
  return String(row.Description ?? row.MaintenanceDescription ?? '').toLowerCase()
}

/** Portal maintenance creates embed these markers because FnFuelRequisitionHeader never sets Type. */
function hasPortalMaintenanceMarker(row: ODataRecord) {
  const purpose = portalMaintenancePurpose(row)
  return purpose.includes('priority:') || purpose.includes('odometer:')
}

/** HIJRA OData uses `Type` / `Type_Field` = Maintenance; portal rows use Priority: in Description. */
export function isMaintenanceRequestRow(row: ODataRecord) {
  if (fuelMaintenanceDocType(row) === 'maintenance') return true
  const type = fuelMaintenanceRequestTypeCode(row)
  if (type === 1 || type === 2) return true
  // MUST win over RequisitionType=Vehicle Fuel: CuStaffPortal FnFuelRequisitionHeader only
  // handles requestType 0/3, so portal maintenance rows are still stamped as fuel in BC
  // (UAT: L00082 created but Maintenance Request list stayed empty).
  if (hasPortalMaintenanceMarker(row)) return true
  if (isFuelRequestRowStrict(row)) return false
  const maintenanceDate = String(row.DateTakenforMaintenance ?? '').trim()
  return Boolean(maintenanceDate && !maintenanceDate.startsWith('0001-01-01'))
}

function isFuelRequestRowStrict(row: ODataRecord) {
  const type = fuelMaintenanceRequestTypeCode(row)
  if (type === 0 || type === 3) return true
  const label = String(row.RequisitionType ?? row.Requisition_Type ?? '').toLowerCase()
  return label.includes('fuel') || label.includes('card')
}

function isFuelRequestRow(row: ODataRecord) {
  if (isMaintenanceRequestRow(row)) return false
  return isFuelRequestRowStrict(row)
}

/** Fuel + maintenance share QyFuelMaintenanceRequests; HIJRA often rejects OData $filter. */
const FUEL_MAINTENANCE_MODULES = new Set(['fuel', 'maintenance'])

function portalOwnerFieldKeys(spec: ModuleSpec) {
  return [
    ...new Set([
      spec.ownerField,
      'Requester_ID',
      'RequesterID',
      'EmployeeNo',
      'Employee_No',
      'PreparedBy',
      'Prepared_By',
    ]),
  ]
}

function rowOwnedByUser(row: ODataRecord, spec: ModuleSpec, user: AuthUser) {
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

function fuelMaintenanceDocNo(row: ODataRecord) {
  return String(row.RequisitionNo ?? row.Requisition_No ?? row.No ?? '')
    .trim()
    .toUpperCase()
}

async function fetchODataRowsQuiet(service: string) {
  try {
    const fetched = await fetchOData(service, {})
    return Array.isArray(fetched) ? (fetched as ODataRecord[]) : []
  } catch {
    return []
  }
}

/** Merge portal + stock fuel/maint queries; prefer portal row when the same doc appears in both. */
function mergeFuelMaintenanceRows(preferredRows: ODataRecord[], fallbackRows: ODataRecord[]) {
  const byNo = new Map<string, ODataRecord>()
  for (const row of fallbackRows) {
    const no = fuelMaintenanceDocNo(row)
    if (no) byNo.set(no, row)
  }
  for (const row of preferredRows) {
    const no = fuelMaintenanceDocNo(row)
    if (no) byNo.set(no, row)
    else byNo.set(`__anon_${byNo.size}`, row)
  }
  return [...byNo.values()]
}

async function fetchFuelMaintenanceRows(spec: ModuleSpec, user: AuthUser) {
  // Always read both services when maintenance prefers QyPortalFuelMaint.
  // Previously we only fell back when preferred returned [] — if preferred was
  // published but classification filtered everything out, the list stayed empty.
  const preferred = spec.headerService
  const fallback =
    preferred === 'QyPortalFuelMaint' ? 'QyFuelMaintenanceRequests' : preferred
  const preferredRows = await fetchODataRowsQuiet(preferred)
  const fallbackRows =
    fallback !== preferred ? await fetchODataRowsQuiet(fallback) : preferredRows
  let rows =
    preferred === 'QyPortalFuelMaint'
      ? mergeFuelMaintenanceRows(preferredRows, fallbackRows)
      : preferredRows.length
        ? preferredRows
        : fallbackRows
  if (!spec.unscopedList) {
    rows = rows.filter((row) => rowOwnedByUser(row, spec, user))
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
    saveHeader: (ctx) => fuelMaintenanceSaveHeader('fuel', ctx),
    submit: ({ no }: { no: string }) => ({ docNo: no, action: 'request' }),
    cancel: ({ no }: { no: string }) => ({ docNo: no, action: 'cancel' }),
  },
}

const maintenance: ModuleSpec = {
  module: 'maintenance',
  // After HIJRA-v948 FacilityUat publish: includes technician / odometer / FA receipt.
  headerService: 'QyPortalFuelMaint',
  headerTableId: 50865,
  ownerField: 'RequesterID',
  ownerSource: 'employeeNo',
  headerKey: 'RequisitionNo',
  postListFilter: isMaintenanceRequestRow,
  soap: fuelMaintenanceSoap,
  params: {
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
    submit: 'TransferOrderApproval',
    cancel: 'TransferOrderApproval',
  },
  decideMode: 'submitCancelOnSameMethod',
  params: {
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
 * Asset Transfer — vehicle/tools handover and temporary transfer to employees
 * (UAT Facility rows R49-R54). Backed by the additive CuPortalAssetTransfer
 * codeunit (52120) + QyAssetTransfer query (52121), which mirror BC card page
 * 50584 over table 50278. This is a different document from Transfer Order
 * (inventory move) — exactly the distinction the bank flagged in UAT.
 *
 * Option contracts (must match PortalAssetTransferMgt.Codeunit.al):
 *   transferType 1=Internal 2=External; typeOfTransfer 1=Permanent 2=Temporary;
 *   assetType 1=Item 2=Fixed Asset; reasonForTransfer 1=Lost 2=Damaged
 *   3=Resignation 4=Other; assetCondition 1=Good 2=Fair 3=Damaged.
 */
const assetTransfer: ModuleSpec = {
  module: 'asset-transfer',
  headerService: 'QyAssetTransfer',
  headerTableId: 50278,
  ownerField: 'RaisedBy',
  ownerSource: 'userID',
  headerKey: 'No',
  soapService: 'CuPortalAssetTransfer',
  soap: {
    saveHeader: 'CreateAssetTransfer',
    editHeader: 'UpdateAssetTransfer',
    submit: 'AssetTransferApprovalAction',
    cancel: 'AssetTransferApprovalAction',
  },
  decideMode: 'submitCancelOnSameMethod',
  params: {
    saveHeader: ({ req, user, no }) => {
      // Parameter order matches the AL procedure signature (NAV SOAP is
      // order-sensitive): myUserID, transferType, typeOfTransfer, assetType,
      // assetNo, toEmployeeNo, toLocation, destinationLocation, partnerName,
      // reasonForTransfer, reasonText, assetCondition,
      // assetConditionDescription, temporaryExpiryDate, fromLocation,
      // fromEmployeeNo.
      const shared = {
        transferType: numericCode(req.body?.transferType, { internal: 1, external: 2 }, 1),
        typeOfTransfer: numericCode(req.body?.typeOfTransfer, {
          permanent: 1,
          'permanent transfer': 1,
          temporary: 2,
          'temporary transfer': 2,
        }, 1),
        assetType: numericCode(req.body?.assetType ?? req.body?.type, {
          item: 1,
          'fixed asset': 2,
          asset: 2,
          vehicle: 2,
        }, 2),
        assetNo: req.body?.assetNo ?? req.body?.vehicleNo ?? req.body?.itemNo ?? '',
        toEmployeeNo: req.body?.toEmployeeNo ?? req.body?.toEmployee ?? '',
        toLocation: req.body?.toLocation ?? '',
        destinationLocation: req.body?.destinationLocation ?? req.body?.destination ?? '',
        partnerName: req.body?.partnerName ?? '',
        reasonForTransfer: numericCode(req.body?.reasonForTransfer, {
          lost: 1,
          damaged: 2,
          resignation: 3,
          other: 4,
        }, 4),
        reasonText: req.body?.reason ?? req.body?.reasonText ?? req.body?.purpose ?? '',
        assetCondition: numericCode(req.body?.assetCondition, { good: 1, fair: 2, damaged: 3 }, 1),
        assetConditionDescription:
          req.body?.assetConditionDescription ?? req.body?.conditionDescription ?? '',
        // Permanent transfers leave expiry blank — BC Date SOAP rejects ''.
        temporaryExpiryDate: formatBcSoapDateOrBlank(String(req.body?.temporaryExpiryDate ?? '')),
        fromLocation: req.body?.fromLocation ?? req.body?.from ?? '',
        // Current holder — required for Internal; fall back to logged-in employee.
        fromEmployeeNo:
          req.body?.fromEmployeeNo ??
          req.body?.fromEmployee ??
          req.body?.fromResponsibleEmployee ??
          user.employeeNo ??
          '',
      }
      if (no) {
        return { myUserID: user.userID, docNo: no, ...shared }
      }
      return { myUserID: user.userID, ...shared }
    },
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
      workDate: formatBcSoapDateOrBlank(String(req.body?.workDate ?? '')),
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
    submit: 'TrainingApproval',
    cancel: 'TrainingApproval',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      docNo: no,
      // The ERP training document stores purpose as Text[100] and validates the course code —
      // the full template assessment goes to the companion CuPortalTraining store below.
      purpose: String(req.body?.comments ?? req.body?.purpose ?? req.body?.justification ?? '').slice(0, 100),
      trainingCourseCode:
        req.body?.trainingNeed === '__OTHER__'
          ? ''
          : req.body?.trainingNeed ?? req.body?.trainingCourseCode ?? req.body?.trainingTitle ?? '',
      myUserID: user.userID,
      employeeNo: user.employeeNo,
    }),
    submit: ({ no }) => ({ docNo: no, myAction: 'requestApproval' }),
    cancel: ({ no }) => ({ docNo: no, myAction: 'cancelApproval' }),
  },
}

export type PortalTrainingAssessment = {
  applicationNo: string
  employeeNo: string
  requesterUserId: string
  supervisorUserId: string
  approvalStatus: string
  trainingNeed: string
  purpose: string
  otherTrainingName: string
  trainingType: string
  durationDays: number
  targetGroup: string
  participants: number
  quarter: string
  priority: string
  vendor: string
  estimatedBudget: string
  remark: string
  department?: string
  periodStart?: string
  periodEnd?: string
}

/** Read the complete assessment and routing snapshot from the additive BC codeunit. */
export async function fetchPortalTrainingAssessment(applicationNo: string) {
  const result = await callSoapMethod(
    'GetTrainingAssessment',
    { applicationNo },
    portalSoapEndpoint('CuPortalTraining'),
  )
  const raw = String(result.returnValue ?? '').trim()
  if (!raw) return null
  try {
    const parsed = JSON.parse(raw) as Partial<PortalTrainingAssessment>
    if (!parsed || typeof parsed !== 'object' || !String(parsed.applicationNo ?? '').trim()) {
      return null
    }
    return parsed
  } catch {
    throw Object.assign(
      new Error(`Business Central returned invalid training assessment data for ${applicationNo}`),
      { status: 502 },
    )
  }
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
    submit: 'FnSalaryAdvanceApprovalAction',
    cancel: 'FnSalaryAdvanceApprovalAction',
  },
  params: {
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
    submit: 'RequestGatePassApproval',
    cancel: 'CancelGatePassApproval',
  },
  params: {
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

  router.get(
    '/',
    safe(async (req, res) => {
      const user = authUser(req)
      if (FUEL_MAINTENANCE_MODULES.has(spec.module)) {
        res.json({ rows: await fetchFuelMaintenanceRows(spec, user) })
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
      // Belt-and-suspenders: never leak another employee's gate passes even if
      // BC ignored/rejected the EmployeeNo $filter (UAT: Meseret saw Beza's).
      if (spec.module === 'gate-pass') {
        rows = rows.filter((row) => gatePassRowOwnedByUser(row, user))
      }
      if (spec.postListFilter) rows = rows.filter(spec.postListFilter)
      res.json({ rows })
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
      const body = SCHEMAS.saveHeader.parse(req.body ?? {})
      // Pull through validated body for the param builder (re-attach reference).
      ;(req as Request).body = body
      let methodName = spec.soap.saveHeader!
      // Inter-Bank Transfer routes edits through a separate SOAP method.
      if (spec.module === 'inter-bank-transfer' && no) {
        methodName = 'FnUpdateInterBankTransfer'
      } else if (spec.soap.editHeader && no) {
        methodName = spec.soap.editHeader
      }
      const editBody = no
        ? await resolveRecIdHeaderEditBody(spec, user, no, body as Record<string, unknown>)
        : (body as Record<string, unknown>)
      ;(req as Request).body = editBody
      const params = await spec.params!.saveHeader!({ req, user, no })
      const result = await callSoapMethod(methodName, params, moduleSoapEndpoint(spec))
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
        const params = await spec.params!.saveLine!({ req, user, no })
        const result = await callSoapMethod(spec.soap.saveLine!, params, moduleSoapEndpoint(spec))
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
        const params = await spec.params!.deleteLine!({ req, user, no })
        const result = await callSoapMethod(spec.soap.deleteLine!, params, moduleSoapEndpoint(spec))
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
        const params = await spec.params!.submit!({ req, user, no })
        const result = await callSoapMethod(spec.soap.submit!, params, moduleSoapEndpoint(spec))
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
        const params = await spec.params!.cancel!({ req, user, no })
        const result = await callSoapMethod(spec.soap.cancel!, params, moduleSoapEndpoint(spec))
        res.json({ ok: ok(result), returnValue: result.returnValue })
      }),
    )
  }

  return router
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
  assetTransfer,
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
  assetTransfer: 'asset-transfer',
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
  fuel: 'fuel',
  'transfer-order': 'transferOrder',
  'asset-transfer': 'assetTransfer',
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
  return [
    `DocumentNo eq '${escaped}'`,
    `Document_No eq '${escaped}'`,
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

async function queryApprovalEntries(filter: string) {
  const rows = (await fetchOData('QyApprovalEntry', { $filter: filter }).catch(
    () => null,
  )) as ODataRecord[] | null
  return Array.isArray(rows) ? rows : []
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
  const idFilters = isNumericRecordId
    ? [`RecordIDtoApprove eq ${numericId}`, `Record_ID_to_Approve eq ${numericId}`]
    : [`RecordIDtoApprove eq guid'${odataString(recordId)}'`]

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
  options: { gatePassSource?: GatePassSourceKey } = {},
) {
  if (spec.module === 'salary-advance') {
    return fetchSalaryAdvanceRows(spec, user)
  }

  if (FUEL_MAINTENANCE_MODULES.has(spec.module)) {
    return fetchFuelMaintenanceRows(spec, user)
  }
  const filterParts =
    spec.module === 'gate-pass'
      ? gatePassListFilterParts(options.gatePassSource ?? 'storeIssue', user)
      : spec.unscopedList
        ? []
        : [`${spec.ownerField} eq '${odataString(ownerValue(spec, user))}'`]
  if (spec.extraListFilter && spec.module !== 'gate-pass') filterParts.push(spec.extraListFilter)
  const fetched = await fetchOData(spec.headerService, {
    ...(filterParts.length ? { $filter: filterParts.join(' and ') } : {}),
  })
  let rows = Array.isArray(fetched) ? fetched : []
  if (spec.module === 'gate-pass') {
    rows = rows.filter((row) => gatePassRowOwnedByUser(row, user))
  }
  return spec.postListFilter ? rows.filter(spec.postListFilter) : rows
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
    const services = [...new Set([spec.headerService, 'QyFuelMaintenanceRequests', 'QyPortalFuelMaint'])]
    for (const service of services) {
      for (const key of [headerKey, 'RequisitionNo', 'Requisition_No', 'No']) {
        try {
          const rows = (await fetchOData(service, {
            $filter: `${key} eq '${odataString(no)}'`,
            $top: 1,
          })) as ODataRecord[] | null
          const row = Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
          if (!row) continue
          if (enforceOwner && !spec.unscopedList && !rowOwnedByUser(row, spec, user)) continue
          return row
        } catch {
          // Service may be unpublished (e.g. QyPortalFuelMaint before Facility AL).
        }
      }
    }
    // Unfiltered fallback — HIJRA often rejects $filter on this query.
    const all = await fetchFuelMaintenanceRows(
      { ...spec, postListFilter: undefined, unscopedList: true },
      user,
    )
    const match = all.find((row) =>
      [headerKey, 'RequisitionNo', 'Requisition_No', 'No'].some(
        (key) => String(row[key] ?? '').trim().toUpperCase() === no.trim().toUpperCase(),
      ),
    )
    if (!match) return null
    if (enforceOwner && !spec.unscopedList && !rowOwnedByUser(match, spec, user)) return null
    return match
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
  })) as ODataRecord[] | null
  return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
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
  const rows = await fetchOData(lineService, {
    $filter: `${lineHeaderField} eq '${odataString(lineDocumentNo)}'`,
  }).catch(() => [] as ODataRecord[])
  return Array.isArray(rows) ? rows : []
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

/**
 * UAT gap: BC does not yet stop an employee raising two transport requisitions
 * for the same trip (the ERP-side duplicate-vehicle check is still pending with
 * TA). Guard the obvious case at the portal: another Open / Pending Approval
 * requisition by the same requester for the same trip date and destination.
 */
async function assertNoDuplicateTransportRequest(
  spec: ModuleSpec,
  user: AuthUser,
  body: Record<string, unknown>,
) {
  const tripDate = String(body.dateOfTrip ?? body.tripDate ?? '').trim().slice(0, 10)
  const destination = String(body.destination ?? '').trim().toLowerCase()
  if (!tripDate) return
  const fetched = await listPortalModuleRows(spec, user).catch(() => [] as ODataRecord[])
  const rows = Array.isArray(fetched) ? fetched : []
  const duplicate = rows.find((row) => {
    const status = fieldText(row, ['Status']).toLowerCase()
    if (status !== 'open' && status !== 'pending approval') return false
    if (fieldText(row, ['Date_of_Trip', 'DateOfTrip']).slice(0, 10) !== tripDate) return false
    // QyTransportRequisition exposes Destination as the "To" column.
    const rowDestination = fieldText(row, ['To', 'Destination']).trim().toLowerCase()
    return !destination || !rowDestination || rowDestination === destination
  })
  if (duplicate) {
    const no = fieldText(duplicate, ['Transport_Requisition_No', 'No'])
    throw Object.assign(
      new Error(
        `You already have transport requisition ${no || '(pending)'} for ${tripDate}` +
          `${destination ? ` to ${String(body.destination).trim()}` : ''} that is still ` +
          `${fieldText(duplicate, ['Status']) || 'open'}. Cancel it or wait for it to be processed before requesting another vehicle.`,
      ),
      { status: 422 },
    )
  }
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

  if (spec.module === 'transport') {
    await assertNoDuplicateTransportRequest(spec, user, body)
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
    if (FUEL_MAINTENANCE_MODULES.has(spec.module)) {
      const unscoped = await fetchFuelMaintenanceRows(
        { ...spec, postListFilter: undefined, unscopedList: true },
        user,
      )
      return mergeFuelMaintenanceRows(scoped, unscoped)
    }
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
  const headerResult = await callSoapMethod(spec.soap.saveHeader, headerParams, moduleSoapEndpoint(spec))
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

  // The bank's Training Need Assessment template carries far more than the ERP training
  // document can hold (Purpose is Text[100]) — persist the full assessment in the companion
  // CuPortalTraining store, keyed by the ERP application number. This call also restores the
  // requester's real BC User ID and validates their Immediate Supervisor before submission.
  if (spec.module === 'training') {
    try {
      const assessmentResult = await callSoapMethod(
        'SaveTrainingAssessment',
        {
          applicationNo: no,
          employeeNo: user.employeeNo,
          requesterUserId: user.userID,
          detailsJson: JSON.stringify({
            trainingNeed: String(headerRequest.body?.trainingNeed ?? ''),
            purpose: String(headerRequest.body?.comments ?? ''),
            otherTrainingName: String(headerRequest.body?.otherTrainingName ?? ''),
            trainingType: String(headerRequest.body?.trainingType ?? ''),
            durationDays: String(headerRequest.body?.durationDays ?? ''),
            targetGroup: String(headerRequest.body?.targetGroup ?? ''),
            participants: String(headerRequest.body?.participants ?? ''),
            quarter: String(headerRequest.body?.quarter ?? ''),
            priority: String(headerRequest.body?.priority ?? ''),
            vendor: String(headerRequest.body?.vendor ?? ''),
            estimatedBudget: String(headerRequest.body?.estimatedBudget ?? ''),
            remark: String(headerRequest.body?.remark ?? ''),
            // Department the request is raised for (persisted on the assessment). Older codeunits
            // simply ignore the extra JSON key, so this is safe to send regardless of AL version.
            department: String(headerRequest.body?.department ?? ''),
            // Training period (start/end dates). Sent as ISO yyyy-mm-dd; older codeunits ignore them.
            periodStart: String(headerRequest.body?.periodStart ?? ''),
            periodEnd: String(headerRequest.body?.periodEnd ?? ''),
          }),
        },
        portalSoapEndpoint('CuPortalTraining'),
      )
      if (!approvalOk(assessmentResult)) {
        throw new Error('Business Central did not save the training assessment.')
      }
    } catch (error) {
      const detail = error instanceof Error ? error.message : String(error)
      throw Object.assign(
        new Error(
          `Business Central created ${no}, but the Training Need Assessment or Immediate Supervisor routing could not be saved. ${detail}`,
        ),
        { status: 502, documentNo: no },
      )
    }
  }

  // FnFuelRequisitionHeader never sets Type:=Maintenance — stamp it when CuPortalFacility is live.
  if (spec.module === 'maintenance') {
    try {
      await callSoapMethod(
        'MarkAsMaintenanceRequest',
        { requisitionNo: no },
        portalSoapEndpoint('CuPortalFacility'),
      )
    } catch {
      // Facility AL not published yet; list filter still matches Priority: in Description.
    }
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
      const lineResult = await callSoapMethod(spec.soap.saveLine, lineParams, moduleSoapEndpoint(spec))
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
      description: String(attachment.description ?? attachment.fileName ?? 'Attachment').trim(),
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
    const submitResult = await callSoapMethod(spec.soap.submit, submitParams, moduleSoapEndpoint(spec))
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
  const result = await callSoapMethod(spec.soap.cancel, params, moduleSoapEndpoint(spec))
  if (!soapActionOk(spec, result)) {
    throw Object.assign(new Error(`Business Central did not cancel ${no}`), { status: 502 })
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
  if (!canRequestApprovalForSpec(spec.module, header)) {
    throw Object.assign(new Error(requestApprovalBlockedMessage(spec.module, header)), {
      status: 422,
    })
  }
  if (spec.module === 'training') {
    const assessment = await fetchPortalTrainingAssessment(no)
    if (!assessment) {
      throw Object.assign(
        new Error('The Training Need Assessment is missing in Business Central. Save the request again before requesting approval.'),
        { status: 422 },
      )
    }
    if (!String(assessment.supervisorUserId ?? '').trim()) {
      throw Object.assign(
        new Error('Your Immediate Supervisor is not configured in Business Central User Setup. HR must assign the Approver ID before this request can be submitted.'),
        { status: 422 },
      )
    }
  }
  if (spec.module === 'inter-bank-transfer') {
    const sourceAmount = Number(header.Source_Amount ?? header.SourceAmount ?? 0)
    const payingAccount = fieldText(header, ['Paying_Account', 'PayingAccount'])
    const receivingAccount = fieldText(header, ['Receiving_Account', 'ReceivingAccount'])
    if (sourceAmount <= 0 || !receivingAccount) {
      throw Object.assign(
        new Error('Complete the receiving account and source amount before requesting approval.'),
        { status: 422 },
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
  const result = await callSoapMethod(spec.soap.submit, params, moduleSoapEndpoint(spec))
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
  } else if (spec.soap.editHeader) {
    methodName = spec.soap.editHeader
  }
  const editBody = await resolveRecIdHeaderEditBody(spec, user, no, body)
  const params = await spec.params.saveHeader({
    req: requestWithBody(editBody),
    user,
    no,
  })
  const result = await callSoapMethod(methodName, params, moduleSoapEndpoint(spec))
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
  const result = await callSoapMethod(spec.soap.saveLine, params, moduleSoapEndpoint(spec))
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
  const result = await callSoapMethod(spec.soap.deleteLine, params, moduleSoapEndpoint(spec))
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

function validatePortalAttachment(attachment: Record<string, unknown>) {
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
  return { contentBase64, description }
}

export async function uploadPortalAttachment(
  tableID: number,
  no: string,
  attachment: Record<string, unknown>,
) {
  const { contentBase64, description } = validatePortalAttachment(attachment)
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

/** Upload through the additive CuPortalAttachments codeunit (purchase specs etc.). */
async function uploadPortalAttachmentViaPortalService(
  tableID: number,
  no: string,
  attachment: Record<string, unknown>,
) {
  const { contentBase64, description } = validatePortalAttachment(attachment)
  const result = await uploadViaPortalAttachments({
    docNo: no,
    description,
    tableID,
    fileName: attachmentFileName(attachment),
    fileBase64: contentBase64,
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
  if (spec.attachmentUploadVia === 'portalAttachments') {
    return uploadPortalAttachmentViaPortalService(
      spec.attachmentUploadTableId ?? spec.headerTableId,
      docNo,
      attachment,
    )
  }
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
