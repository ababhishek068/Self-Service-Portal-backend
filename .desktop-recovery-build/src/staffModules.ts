import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import {
  callSoapMethod,
  codeunitSoapNamespace,
  deriveCodeunitSoapUrl,
  fetchOData,
  odataString,
  type ODataRecord,
  type SoapEndpoint,
} from './bcClient.js'
import { config } from './config.js'
import {
  APPROVAL_TABLE_IDS,
  approvalTableFilter,
  type ApprovalTableKey,
} from './approvalTableIds.js'
import { requireAuth } from './auth.js'
import type { AuthUser } from './auth.js'
import { fetchEmployeeCustomerAccountNo, ensureEmployeeDepartmentCodeForFinance, resolveFinanceDepartmentCodeForSoap } from './employeeProfile.js'
import { formatBcSoapDate, isErpWorkingDate } from './staff.js'
import { uploadViaPortalAttachments } from './portalAttachments.js'
import {
  canRequestApprovalForSpec,
  requestApprovalBlockedMessage,
} from './requestWorkflow.js'
import { trainingCourseCodeForBc } from './trainingCourses.js'
import { resolveModuleRequestStatus } from './erpMappings.js'
import {
  prepareImprestSurrenderLinesForSave,
  imprestSurrenderLinesToPersist,
  imprestSurrenderAccountNo,
  imprestSurrenderLineActualSpent,
  imprestSurrenderLineOutstanding,
  isImprestSurrenderModule,
  normalizeImprestSurrenderCashReceiptNo,
  mergeImprestSurrenderODataRow,
  imprestSurrenderLinesHaveSpendReadback,
  imprestSurrenderLinePersistedMatches,
  imprestSurrenderLineNo,
} from './imprestSurrenderLines.js'

const DUPLICATE_REQUISITION_WINDOW_MS = 24 * 60 * 60 * 1000

async function recalculateImprestSurrenderSettlement(spec: ModuleSpec, no: string) {
  if (!isImprestSurrenderModule(spec.module)) return
  try {
    const recalc = await callModuleSoap(spec, 'RecalculateImprestSurrenderSettlement', { docNo: no })
    if (!ok(recalc)) {
      console.warn(`[imprest-surrender] settlement recalc returned false for ${no}`)
    }
  } catch (err) {
    console.warn(
      `[imprest-surrender] settlement recalc failed for ${no} (publish AL 1.0.5.166+)`,
      err,
    )
  }
}

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
  /** Older published service names tried when the primary line query is unavailable. */
  lineFallbackServices?: string[]
  /** OData field linking lines to the header (e.g. `No`, `RequistionNo`, …). */
  lineHeaderField?: string

  /** SOAP methods used to mutate the document. */
  soap: {
    saveHeader?: string
    /** Optional separate SOAP method used when editing an existing header. */
    editHeader?: string
    saveLine?: string
    deleteLine?: string
    submit?: string
    cancel?: string
  }
  /** Dedicated published codeunit endpoint; defaults to CuStaffPortal. */
  soapEndpoint?: SoapEndpoint

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
}

function callModuleSoap(
  spec: ModuleSpec,
  methodName: string,
  params: Record<string, unknown>,
) {
  return callSoapMethod(methodName, params, spec.soapEndpoint)
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

export function assetConditionDescriptionValue(description: unknown, condition: unknown) {
  const entered = String(description ?? '').trim()
  if (entered) return entered
  const conditionCode = numericCode(condition, {
    good: 1,
    fair: 2,
    damaged: 3,
  })
  return ({ 1: 'Good', 2: 'Fair', 3: 'Damaged' } as Record<number, string>)[conditionCode] ?? ''
}

function fieldText(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

function fieldNumber(row: ODataRecord, keys: string[], fallback = 0) {
  const raw = fieldText(row, keys, '')
  if (!raw) return fallback
  const parsed = Number(raw)
  return Number.isFinite(parsed) ? parsed : fallback
}

export type GatePassSourceKey = 'storeIssue' | 'transferOrder' | 'assetTransfer' | 'maintenance'

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
  maintenance: {
    label: 'Maintained Asset / Vehicle Requisitions',
    linkTo: 'Maintenance',
    lineService: 'QyFuelMaintenanceRequests',
    lineHeaderField: 'RequisitionNo',
    scopeToEmployee: true,
  },
}

function normalizedGatePassSource(value: unknown): GatePassSourceKey {
  const raw = String(value ?? '').trim().toLowerCase()
  const compact = raw.replace(/[^a-z]/g, '')
  if (compact === 'transferorder' || compact === 'transferorders') return 'transferOrder'
  if (compact === 'assettransfer' || compact === 'assettransfers') return 'assetTransfer'
  if (compact === 'maintenance' || compact === 'maintainedasset' || compact === 'maintainedgoods') {
    return 'maintenance'
  }
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
/**
 * Pick the canonical gate pass for a posted store requisition. The stamped
 * `GatePassNo` on the store header (created when BC posts the requisition) wins
 * over any duplicate gate pass the portal may have created later.
 */
export function storeIssueGatePassFromRows(
  storeRequisitionNo: string,
  storeHeader: ODataRecord | undefined,
  gatePassRows: ODataRecord[],
): string {
  const wanted = storeRequisitionNo.trim()
  if (!wanted) return ''

  const fromHeader = storeHeader
    ? fieldText(storeHeader, ['GatePassNo', 'Gate_Pass_No'])
    : ''
  if (fromHeader) return fromHeader

  for (const row of gatePassRows) {
    if (gatePassSourceFromRow(row) !== 'storeIssue') continue
    if (fieldText(row, ['TransferNo', 'Transfer_No']).trim() !== wanted) continue
    const gatePassNo = fieldText(row, ['GatePassNo', 'Gate_Pass_No'])
    if (gatePassNo) return gatePassNo
  }
  return ''
}

/** Resolve the BC gate pass already linked to a posted store requisition. */
export async function resolveStoreIssueGatePassNo(storeRequisitionNo: string): Promise<string> {
  const wanted = storeRequisitionNo.trim()
  if (!wanted) return ''

  let storeHeader: ODataRecord | undefined
  for (const key of ['No', 'No_']) {
    try {
      const rows = (await fetchOData('QyStoreRequisitionHeader', {
        $filter: `${key} eq '${odataString(wanted)}'`,
        $top: 1,
      })) as ODataRecord[] | null
      storeHeader = Array.isArray(rows) ? rows[0] : undefined
      if (storeHeader) break
    } catch {
      // try the next published key name
    }
  }

  for (const transferKey of ['TransferNo', 'Transfer_No']) {
    for (const linkKey of ['Linkto', 'LinkTo', 'Link_To']) {
      try {
        const rows = (await fetchOData('QyGatePass', {
          $filter: `${linkKey} eq 'Store Issue' and ${transferKey} eq '${odataString(wanted)}'`,
          $top: 10,
        })) as ODataRecord[] | null
        const resolved = storeIssueGatePassFromRows(
          wanted,
          storeHeader,
          Array.isArray(rows) ? rows : [],
        )
        if (resolved) return resolved
      } catch {
        // try the next published key name
      }
    }
  }

  const fetched = (await fetchOData('QyGatePass', { $top: 5000 }).catch(() => [])) as ODataRecord[]
  return storeIssueGatePassFromRows(wanted, storeHeader, Array.isArray(fetched) ? fetched : [])
}

async function gatePassTransferNo(no: string, hint = ''): Promise<string> {
  const hinted = String(hint ?? '').trim()
  if (hinted) return hinted

  for (const key of ['GatePassNo', 'Gate_Pass_No']) {
    try {
      const rows = (await fetchOData('QyGatePass', {
        $filter: `${key} eq '${odataString(no)}'`,
        $top: 1,
      })) as ODataRecord[] | null
      if (Array.isArray(rows) && rows[0]) {
        const transfer = fieldText(rows[0], ['TransferNo', 'Transfer_No'])
        if (transfer) return transfer
      }
    } catch {
      // try the next published key name
    }
  }
  return ''
}

async function gatePassSubmitParams(
  req: Pick<Request, 'body'>,
  user: AuthUser,
  no: string,
) {
  const transferNo = await gatePassTransferNo(
    no,
    fieldText(req.body ?? {}, ['transferNo', 'TransferNo', 'Transfer_No']),
  )
  if (!transferNo) {
    throw Object.assign(
      new Error(
        `Gate pass ${no} has no linked source document number in Business Central. ` +
          'Verify the maintenance/store/transfer document is linked on the gate pass in BC, then retry.',
      ),
      { status: 422 },
    )
  }
  return {
    gatePassNo: no,
    transferNo,
    tableID: 50296,
    employeeNo: user.employeeNo,
  }
}

function storeLineTypeCode(value: unknown) {
  return numericCode(value, { item: 1, asset: 2 })
}

function purchaseLineTypeCode(value: unknown) {
  return numericCode(value, { service: 1, item: 2, asset: 4 })
}

export function transportRequestTypeCode(value: unknown) {
  return numericCode(value, { city: 0, 'field trip': 1, field: 1 })
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
  const base = raw.split(' - ')[0]?.trim() ?? raw
  if (base.toUpperCase().includes('MEDICAL') || base.toUpperCase().startsWith('MED')) return 'MEDICAL'
  return base || raw
}

export function isMedicalClaimType(value: unknown) {
  return claimTypeCode(value) === 'MEDICAL'
}

export function isOtherClaimType(value: unknown) {
  return claimTypeCode(value).toUpperCase() === 'OTHER'
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
    saveHeader: ({ req, user, no }) => {
      const travelDate = formatBcSoapDate(
        String(req.body?.travelDate ?? req.body?.startDate ?? ''),
      )
      let returnDate = formatBcSoapDate(String(req.body?.returnDate ?? ''))
      const todayIso = (() => {
        const now = new Date()
        return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
      })()
      // Excel R5 / Word Aug 7: block back-dated travel start and return.
      if (travelDate && travelDate < todayIso) {
        throw Object.assign(
          new Error('Travel start date cannot be earlier than today.'),
          { status: 422, code: 'IMPREST_TRAVEL_BACKDATE' },
        )
      }
      if (returnDate && returnDate < todayIso) {
        throw Object.assign(
          new Error('Return date cannot be earlier than today.'),
          { status: 422, code: 'IMPREST_RETURN_BACKDATE' },
        )
      }
      // HB: start and return must not be the same calendar day.
      if (travelDate && (!returnDate || returnDate <= travelDate)) {
        const next = new Date(`${travelDate}T12:00:00`)
        next.setDate(next.getDate() + 1)
        returnDate = `${next.getFullYear()}-${String(next.getMonth() + 1).padStart(2, '0')}-${String(next.getDate()).padStart(2, '0')}`
      }
      return {
        action: no ? 'edit' : 'create',
        docNo: no,
        employeeNo: user.employeeNo,
        dateRequired: formatBcSoapDate(String(req.body?.dateRequired ?? req.body?.startDate ?? '')),
        purpose: req.body?.purpose ?? '',
        myUserId: user.userID,
        travelDestination: req.body?.travelDestination ?? req.body?.placeOfDuty ?? '',
        travelDate,
        returnDate,
      }
    },
    saveLine: async ({ req, user, no }) => {
      const advanceType = String(req.body?.advanceType ?? req.body?.expenseType ?? '').trim()
      let destination = String(req.body?.destination ?? req.body?.description ?? '').trim()
      // Word Aug 7: destination is captured on the header — reuse it for ERP rate lookup.
      if (!destination) {
        destination = String(
          req.body?.travelDestination ?? req.body?.headerTravelDestination ?? '',
        ).trim()
        if (!destination) {
          try {
            const headerRows = (await fetchOData('QyImprestHeader', {
              $filter: `No eq '${odataString(no)}'`,
              $top: 1,
            }).catch(() => [])) as ODataRecord[] | null
            const header = Array.isArray(headerRows) ? headerRows[0] : undefined
            destination = fieldText(header ?? {}, [
              'TravelDestination',
              'Travel_Destination',
              'Destination',
            ])
          } catch {
            // keep empty — BC/amount validation below will explain
          }
        }
      }
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
            'Amount is required. Select advance type and days so ERP can calculate the daily rate from the header travel destination — or enter amount manually.',
          ),
          { status: 422 },
        )
      }

      // Advance types whose BC "Rate Source" is Manual (e.g. PETTY CASH) have no
      // per-diem rate in the ERP master. BC's "No of Days" validation then errors
      // ("Please enter Daily Rate for Advance Type ...") unless the line's
      // Daily Rate(Amount) is supplied. Forward the requester/ERP daily rate so BC
      // can stamp it; when it is 0 we fall back to amount / days.
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
    submit: 'RequestImprestSurrenderApproval',
    cancel: 'CancelImprestSurrender',
  },
  params: {
    saveHeader: ({ req, user, no }) => {
      const actualReturnDate = formatBcSoapDate(
        String(req.body?.actualReturnDate ?? req.body?.ActualReturnDate ?? ''),
      )
      if (!actualReturnDate || actualReturnDate.startsWith('0001-01-01')) {
        throw Object.assign(
          new Error(
            'Actual Return Date is required. Business Central uses it to calculate Actual Travel Days before you can enter Actual Spent.',
          ),
          { status: 422 },
        )
      }
      return {
        docNo: no,
        imprestIssueDocNo: req.body?.imprestIssueDocNo ?? req.body?.imprest ?? '',
        myUserID: user.userID,
        employeeNo: user.employeeNo,
        imprestNo: user.imprestNo ?? '',
        myAction: no ? 'update' : 'create',
        receivedFrom: user.userID,
        pVNo: '',
        actualReturnDate,
      }
    },
    saveLine: ({ req, no }) => ({
      lineNo: Number(req.body?.lineNo ?? 0),
      accountNo: req.body?.accountNo ?? '',
      docNo: no,
      actualSpent: Number(req.body?.actualSpent ?? 0),
      cashReceiptNo: normalizeImprestSurrenderCashReceiptNo(req.body?.cashReceiptNo),
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
            'Your Business Central employee record has no department dimension. Ask HR to set Global Dimension 1 (department) on your employee card, then log out and sign in again.',
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
    submit: 'RequestPettyCashApproval',
    cancel: 'CancelPettyCashRequest',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      requiredDate: formatBcSoapDate(
        String(req.body?.dateNeeded ?? req.body?.requiredDate ?? req.body?.requestDate ?? ''),
      ),
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
    submit: 'RequestInterBankTransferApproval',
    cancel: 'CancelInterBankTransferRequest',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myUserId: user.userID,
      staffNo: user.employeeNo,
      myAction: no ? 'edit' : 'create',
      // Leave org blank — AL stamps Sector/Department/Branch from Employee No only.
      // Sending portal org codes made BC reject: Branch when Department already selected.
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
    saveLine: async ({ req, user, no }) => {
      const itemNo = String(req.body?.item ?? req.body?.itemNo ?? req.body?.itemCode ?? '')
      const quantity =
        storeLineTypeCode(req.body?.type) === 1
          ? Number(req.body?.quantity ?? 0)
          : 0
      await assertNoDuplicateStoreLine(
        user,
        no,
        itemNo,
        quantity,
        String(req.body?.issuingStore ?? req.body?.headerIssuingStore ?? '').trim(),
      )
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
    saveLine: async ({ req, user, no }) => {
      const itemNo = String(req.body?.itemNo ?? req.body?.itemCode ?? '')
      const quantity = Number(req.body?.quantity ?? 0)
      await assertNoDuplicatePurchaseLine(user, no, itemNo, quantity)
      return {
        action: req.body?.action ?? 'create',
        reqNo: no,
        lineNo: Number(req.body?.lineNo ?? 0),
        itemNo,
        quantity,
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
          req.body?.specification ??
            req.body?.itemDescription ??
            req.body?.reasonForRequest ??
            req.body?.reason ??
            '',
        ).trim(),
      }
    },
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
  headerTableId: 50863,
  supportsAttachments: true,
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
      tableID: 50863,
    }),
    cancel: ({ user, no }) => ({
      requisitionNo: no,
      employeeNo: user.employeeNo,
      tableID: 50863,
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
  const docType = String(
    row.Type ?? row.Type_Field ?? row.DocumentType ?? row.Document_Type ?? '',
  )
    .trim()
    .toLowerCase()
  if (docType === 'maintenance' || docType === '1') return true
  const type = fuelMaintenanceRequestTypeCode(row)
  if (type === 1 || type === 2) return true
  const description = String(
    row.IssueDescription ?? row.MaintenanceDescription ?? row.Description ?? '',
  )
  return (
    /\|\s*Item:/i.test(description) &&
    /\|\s*Priority:/i.test(description) &&
    /\|\s*Location:/i.test(description)
  )
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
      'RequestedBy',
      'Requested_By',
      'Requester_ID',
      'EmployeeNo',
      'Employee_No',
      'EmpoyeeNo',
      'Empoyee_No',
      'PreparedBy',
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

function transportRowTimestamp(row: ODataRecord) {
  const date = fieldText(row, ['Date_of_Request', 'DateOfRequest', 'Date'])
    .slice(0, 10)
  const time = fieldText(row, ['Time_Requested', 'TimeRequested', 'Time_Requisition_Received'])
  const parsed = Date.parse(`${date || '0001-01-01'}T${time.slice(0, 8) || '00:00:00'}`)
  return Number.isFinite(parsed) ? parsed : Number.NEGATIVE_INFINITY
}

const TRANSPORT_HEADER_FILTER_KEYS = [
  'Transport_Requisition_No',
  'TransportRequisitionNo',
  'RequisitionNo',
  'Requisition_No',
] as const

/** Resolve the transport document number from any known QyTransportRequisition column alias. */
export function transportDocumentNoFromRow(row: ODataRecord) {
  return fieldText(row, [...TRANSPORT_HEADER_FILTER_KEYS, 'No'])
}

export function transportRowsForUser(rows: ODataRecord[], user: AuthUser) {
  return rows
    .filter((row) => rowOwnedByUser(row, transport, user))
    .sort((left, right) => {
      const leftTimestamp = transportRowTimestamp(left)
      const rightTimestamp = transportRowTimestamp(right)
      if (leftTimestamp !== rightTimestamp) return rightTimestamp > leftTimestamp ? 1 : -1
      return transportDocumentNoFromRow(right).localeCompare(transportDocumentNoFromRow(left), undefined, {
        numeric: true,
        sensitivity: 'base',
      })
    })
}

export function mergeFuelMaintenanceExtras(
  rows: ODataRecord[],
  extras: ODataRecord[],
) {
  const extrasByRequisition = new Map(
    extras
      .map((row) => [
        fieldText(row, ['RequisitionNo', 'Requisition_No']),
        row,
      ] as const)
      .filter(([no]) => Boolean(no)),
  )
  return rows.map((row) => {
    const no = fieldText(row, ['RequisitionNo', 'Requisition_No'])
    return {
      ...row,
      ...(extrasByRequisition.get(no) ?? {}),
    }
  })
}

async function fetchFuelMaintenanceRows(spec: ModuleSpec, user: AuthUser) {
  const [fetched, fetchedExtras] = await Promise.all([
    fetchOData(spec.headerService, {}),
    fetchOData('QyPortalFuelMaintExtra', {}).catch(() => []),
  ])
  let rows = mergeFuelMaintenanceExtras(
    Array.isArray(fetched) ? fetched : [],
    Array.isArray(fetchedExtras) ? fetchedExtras : [],
  )
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
  const requestType =
    module === 'maintenance'
      ? maintenanceTypeCode(req.body?.requestType)
      : fuelTypeCode(req.body?.requestType)
  const vehicleNo = String(req.body?.vehicleNo ?? '').trim()
  const faTagNumber = String(req.body?.faTagNumber ?? '').trim()
  return {
    myAction: no ? 'edit' : 'create',
    recId: no ? String(req.body?.recId ?? '') : '',
    staffNo: user.employeeNo,
    purpose: req.body?.purpose ?? req.body?.issueDescription ?? '',
    quantity: Number(req.body?.quantity ?? req.body?.liters ?? 0),
    requestType,
    cardNo: req.body?.cardNo ?? '',
    // BC's legacy SOAP method calls this shared parameter vehicleNo. For
    // fixed-asset maintenance it must carry the real FA tag, while vehicle
    // service must carry only the registration number.
    vehicleNo:
      module === 'maintenance' && requestType === 1
        ? faTagNumber
        : vehicleNo,
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
  supportsAttachments: true,
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
  headerService: 'QyFuelMaintenanceRequests',
  headerTableId: 50865,
  supportsAttachments: true,
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
  supportsAttachments: true,
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
    saveHeader: async ({ req, user, no }) => {
      const departmentCode = await resolveFinanceDepartmentCodeForSoap(user.employeeNo, {
        department: user.department,
        departmentName: user.departmentName,
        branchCode: user.branchCode,
      })
      const rawType = String(req.body?.type ?? '').trim()
      const type = rawType.length > 10 ? rawType.slice(0, 10) : rawType
      return {
        action: no ? 'edit' : 'create',
        ticketNo: no,
        employeeNo: user.employeeNo,
        previousWTNo: req.body?.previousTicketNo ?? req.body?.previousWTNo ?? '',
        gkNo: req.body?.gkNo ?? '',
        type,
        department: departmentCode || String(user.department ?? '').trim(),
      }
    },
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
    submit: 'TrainingApproval',
    cancel: 'TrainingApproval',
  },
  params: {
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      docNo: no,
      purpose: req.body?.comments ?? req.body?.justification ?? '',
      trainingCourseCode: trainingCourseCodeForBc(
        req.body?.trainingCourseCode ?? req.body?.trainingNeed ?? req.body?.trainingTitle ?? '',
      ),
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
  supportsAttachments: true,
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
    submit: ({ req, user, no }) => gatePassSubmitParams(req, user, no),
    cancel: ({ req, user, no }) => gatePassSubmitParams(req, user, no),
  },
}

const ASSET_TRANSFER_SERVICE_NAME = 'CuPortalAssetTransfer'
const assetTransferSoapEndpoint: SoapEndpoint = {
  url:
    config.BC_SOAP_ASSET_TRANSFER_CODEUNIT_URL ??
    deriveCodeunitSoapUrl(config.BC_SOAP_CODEUNIT_URL, ASSET_TRANSFER_SERVICE_NAME),
  namespace:
    config.BC_SOAP_ASSET_TRANSFER_NAMESPACE ??
    codeunitSoapNamespace(ASSET_TRANSFER_SERVICE_NAME),
}

/** Facility UAT R49-R54: a real Asset Transfer, separate from inventory Transfer Orders. */
const assetTransfer: ModuleSpec = {
  module: 'asset-transfer',
  headerService: 'QyAssetTransfer',
  headerTableId: 50278,
  ownerField: 'RaisedBy',
  ownerSource: 'userID',
  headerKey: 'No',
  lineService: 'QyAssetTransferTools',
  lineHeaderField: 'TransferNo',
  soapEndpoint: assetTransferSoapEndpoint,
  soap: {
    saveHeader: 'CreateAssetTransfer',
    editHeader: 'UpdateAssetTransfer',
    saveLine: 'AddAssetTransferTool',
    deleteLine: 'DeleteAssetTransferTool',
    submit: 'AssetTransferApprovalAction',
    cancel: 'AssetTransferApprovalAction',
  },
  decideMode: 'submitCancelOnSameMethod',
  params: {
    saveHeader: ({ req, user, no }) => ({
      myUserID: user.userID,
      ...(no ? { docNo: no } : {}),
      transferType: numericCode(req.body?.transferType, { internal: 1, external: 2 }),
      typeOfTransfer: numericCode(req.body?.typeOfTransfer, { permanent: 1, temporary: 2 }),
      assetType: numericCode(req.body?.assetType, { item: 1, 'fixed asset': 2 }),
      assetNo: req.body?.assetNo ?? '',
      toEmployeeNo: req.body?.toEmployeeNo ?? '',
      toLocation: req.body?.toLocation ?? '',
      destinationLocation: req.body?.destinationLocation ?? '',
      partnerName: req.body?.partnerName ?? '',
      reasonForTransfer: numericCode(req.body?.reasonForTransfer, {
        lost: 1,
        damaged: 2,
        resignation: 3,
        other: 4,
      }),
      reasonText: req.body?.reason ?? '',
      assetCondition: numericCode(req.body?.assetCondition, {
        good: 1,
        fair: 2,
        damaged: 3,
      }),
      // BC requires this separate field before Status can become Pending Approval.
      // Older portal builds allowed it to be blank, so retain the entered detail
      // and use the selected condition as a safe minimum for legacy/API clients.
      assetConditionDescription: assetConditionDescriptionValue(
        req.body?.assetConditionDescription,
        req.body?.assetCondition,
      ),
      temporaryExpiryDate: req.body?.temporaryExpiryDate ?? '',
      fromLocation: req.body?.fromLocation ?? '',
      fromEmployeeNo: req.body?.fromEmployeeNo ?? '',
    }),
    saveLine: async ({ req, user, no }) => {
      const accessoryEntryNo = await resolveAssetTransferAccessoryEntryNo(req.body ?? {}, no, user)
      await assertAssetTransferToolNotAlreadyAssigned(no, accessoryEntryNo, user)
      return {
        docNo: no,
        accessoryEntryNo,
        quantity: Number(req.body?.quantity ?? 0),
        remarks: String(req.body?.remarks ?? ''),
      }
    },
    deleteLine: ({ req, no }) => ({
      docNo: no,
      lineNo: Number(req.params.lineNo ?? 0),
    }),
    submit: ({ no }) => ({ docNo: no, myAction: 'requestApproval' }),
    cancel: ({ no }) => ({ docNo: no, myAction: 'cancelApproval' }),
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
      } else if (no && spec.soap.editHeader) {
        methodName = spec.soap.editHeader
      }
      const editBody = no
        ? await resolveRecIdHeaderEditBody(spec, user, no, body as Record<string, unknown>)
        : (body as Record<string, unknown>)
      ;(req as Request).body = editBody
      const params = await spec.params!.saveHeader!({ req, user, no })
      const result = await callModuleSoap(spec, methodName, params)
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
        const result = await callModuleSoap(spec, spec.soap.saveLine!, params)
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
        const result = await callModuleSoap(spec, spec.soap.deleteLine!, params)
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
        const result = await callModuleSoap(spec, spec.soap.submit!, params)
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
        const result = await callModuleSoap(spec, spec.soap.cancel!, params)
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
  workTickets,
  training,
  salaryAdvance,
  gatePass,
  assetTransfer,
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
  workTickets: 'work-tickets',
  training: 'training',
  salaryAdvance: 'salary-advance',
  gatePass: 'gate-pass',
  assetTransfer: 'asset-transfer',
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
  'work-tickets': 'workTicket',
  'salary-advance': 'salaryAdvance',
  'gate-pass': 'gatePass',
  'asset-transfer': 'assetTransfer',
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

function validBcDateTime(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw || raw.startsWith('0001-01-01')) return null
  const timestamp = Date.parse(raw)
  return Number.isFinite(timestamp) ? timestamp : null
}

/**
 * Purchase quote numbers can be reused after a BC number-series reset while
 * Approval Entry retains the old document's completed workflow. Keep only
 * entries that belong to the Purchase Requisition/Purchase Header tables and
 * were submitted after this exact Purchase Header was created.
 */
export function filterCurrentPortalApprovalEntries(
  spec: ModuleSpec,
  document: ODataRecord | undefined,
  rows: ODataRecord[],
) {
  if (spec.module !== 'purchase-requisition' || !document) return rows

  const allowedTableIds = new Set<number>([
    APPROVAL_TABLE_IDS.purchaseRequisition,
    APPROVAL_TABLE_IDS.purchaseOrder,
  ])
  const tableScoped = rows.filter((row) => {
    const tableId = Number(row.TableID ?? row.TableId)
    return Number.isFinite(tableId) && allowedTableIds.has(tableId)
  })

  const headerCreatedAt = validBcDateTime(
    fieldText(document, ['SystemCreatedAt', 'CreatedDateTime', 'Created_Date_Time']),
  )
  if (headerCreatedAt === null) return tableScoped

  return tableScoped.filter((row) => {
    const approvalSentAt = validBcDateTime(
      fieldText(row, [
        'DateTimeSentforApproval',
        'Date_Time_Sent_for_Approval',
        'DateTimeSentForApproval',
      ]),
    )
    // Current BC Approval Entry rows always carry the sent timestamp. If BC
    // cannot prove when an entry was submitted, it must not be allowed to
    // promote a newly-created header that happens to reuse the same number.
    return approvalSentAt !== null && approvalSentAt >= headerCreatedAt
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

  collected = filterCurrentPortalApprovalEntries(
    spec,
    document,
    sortApprovalEntries(dedupeApprovalEntries(collected)),
  )
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
  if (spec.module === 'transport') {
    // Fetch then scope locally using both BC ownership fields. Some HIJRA rows
    // contain Requested_By while newer/legacy routines populate Empoyee_No.
    // Sorting here makes the just-created document visible at the top instead
    // of below years of ascending OData results.
    const fetched = await fetchOData(spec.headerService, {})
    return transportRowsForUser(Array.isArray(fetched) ? fetched : [], user)
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
    for (const key of [headerKey, 'RequisitionNo', 'Requisition_No', 'No']) {
      const rows = (await fetchOData(spec.headerService, {
        $filter: `${key} eq '${odataString(no)}'`,
        $top: 1,
      })) as ODataRecord[] | null
      const row = Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
      if (!row) continue
      if (enforceOwner && !spec.unscopedList && !rowOwnedByUser(row, spec, user)) return null
      return row
    }
    return null
  }

  if (spec.module === 'purchase-requisition') {
    for (const key of [headerKey, 'No', 'No_', 'DocumentNo']) {
      const rows = (await fetchOData(spec.headerService, {
        $filter: `${key} eq '${odataString(no)}'${ownerFilter}`,
        $top: 1,
      })) as ODataRecord[] | null
      if (Array.isArray(rows) && rows.length > 0) return rows[0]!
    }
    return null
  }

  if (spec.module === 'transport') {
    const wanted = no.trim().toUpperCase()
    for (const key of TRANSPORT_HEADER_FILTER_KEYS) {
      try {
        const rows = (await fetchOData(spec.headerService, {
          $filter: `${key} eq '${odataString(no)}'${ownerFilter}`,
          $top: 1,
        })) as ODataRecord[] | null
        const row = Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
        if (!row) continue
        if (enforceOwner && !spec.unscopedList && !rowOwnedByUser(row, spec, user)) return null
        return row
      } catch {
        // Some HIJRA query publications reject OData filters on QyTransportRequisition.
        break
      }
    }
    // Mirror the transport list: unscoped read then match by document number.
    const fetched = (await fetchOData(spec.headerService, { $top: 5000 }).catch(
      () => [] as ODataRecord[],
    )) as ODataRecord[]
    const match = fetched.find(
      (row) => transportDocumentNoFromRow(row).trim().toUpperCase() === wanted,
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

async function fetchImprestSurrenderLineRows(docNo: string): Promise<ODataRecord[]> {
  const services = [
    'ImprestSurrenderDetails',
    'QyImprestSurrenderDetails',
    'QyImprestSurrenderLines',
  ]
  const filterKeys = [
    'SurrenderDocNo',
    'Surrender_Doc_No',
    'Surrender_Doc_No_',
    'DocNo',
    'Doc_No',
  ]
  const mergedByAccount = new Map<string, ODataRecord>()

  for (const service of services) {
    for (const filterKey of filterKeys) {
      try {
        const rows = await fetchOData(service, {
          $filter: `${filterKey} eq '${odataString(docNo)}'`,
        })
        if (!Array.isArray(rows) || rows.length === 0) continue
        for (const row of rows) {
          const account = imprestSurrenderAccountNo(row as Record<string, unknown>)
          const key = account || `entry-${imprestSurrenderLineNo(row as Record<string, unknown>)}`
          const existing = mergedByAccount.get(key)
          mergedByAccount.set(
            key,
            mergeImprestSurrenderODataRow(
              existing as Record<string, unknown> | undefined,
              row as Record<string, unknown>,
            ),
          )
        }
      } catch {
        // try the next published BC alias
      }
    }
  }

  return Array.from(mergedByAccount.values())
}

async function fetchImprestSurrenderSpendLineRows(docNo: string): Promise<ODataRecord[]> {
  const services = ['ImprestSurrenderDetails', 'QyImprestSurrenderDetails']
  const filterKeys = [
    'SurrenderDocNo',
    'Surrender_Doc_No',
    'Surrender_Doc_No_',
    'DocNo',
    'Doc_No',
  ]
  const mergedByAccount = new Map<string, ODataRecord>()

  for (const service of services) {
    for (const filterKey of filterKeys) {
      try {
        const rows = await fetchOData(service, {
          $filter: `${filterKey} eq '${odataString(docNo)}'`,
        })
        if (!Array.isArray(rows) || rows.length === 0) continue
        for (const row of rows) {
          const account = imprestSurrenderAccountNo(row as Record<string, unknown>)
          const key = account || `entry-${imprestSurrenderLineNo(row as Record<string, unknown>)}`
          const existing = mergedByAccount.get(key)
          mergedByAccount.set(
            key,
            mergeImprestSurrenderODataRow(
              existing as Record<string, unknown> | undefined,
              row as Record<string, unknown>,
            ),
          )
        }
      } catch {
        // try the next published BC alias
      }
    }
  }

  return Array.from(mergedByAccount.values())
}

/** Read the document lines exactly as the ESS controllers do, including transport's two passenger pages. */
export async function listPortalModuleLines(
  spec: ModuleSpec,
  header: ODataRecord,
  no: string,
) {
  if (isImprestSurrenderModule(spec.module)) {
    return await fetchImprestSurrenderLineRows(no)
  }

  if (spec.module === 'transport') {
    const passengerFilter = async (service: string, keys: string[], value: string) => {
      for (const key of keys) {
        try {
          const rows = await fetchOData(service, {
            $filter: `${key} eq '${odataString(value)}'`,
          })
          if (Array.isArray(rows) && rows.length > 0) return rows
        } catch {
          // fall through to next alias
        }
      }
      return [] as ODataRecord[]
    }
    const [staffRows, externalRows] = await Promise.all([
      passengerFilter('PgTransportStaffPassengers', ['Req_No', 'ReqNo'], no),
      passengerFilter('PgTransportExternalPassengers', ['Transport_No', 'TransportNo'], no),
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

  if (spec.module === 'asset-transfer' && spec.lineService) {
    const filterKeys = ['TransferNo', 'Transfer_No', 'Transfer_No_']
    for (const key of filterKeys) {
      try {
        const rows = await fetchOData(spec.lineService, {
          $filter: `${key} eq '${odataString(no)}'`,
        })
        if (Array.isArray(rows) && rows.length > 0) return rows
      } catch {
        // fall through to next alias
      }
    }
    const fetched = (await fetchOData(spec.lineService, { $top: 5000 }).catch(
      () => [] as ODataRecord[],
    )) as ODataRecord[]
    const wanted = no.trim().toUpperCase()
    return fetched.filter((row) =>
      filterKeys.some(
        (key) => fieldText(row, [key]).trim().toUpperCase() === wanted,
      ),
    )
  }

  const gatePassBinding = spec.module === 'gate-pass' ? gatePassLineBinding(header, no) : null
  const lineService = gatePassBinding?.lineService ?? spec.lineService
  const lineHeaderField = gatePassBinding?.lineHeaderField ?? spec.lineHeaderField
  const lineDocumentNo = gatePassBinding?.documentNo ?? no
  if (!lineService || !lineHeaderField) return []
  const services = [lineService, ...(spec.lineFallbackServices ?? [])]
  const lineFilterKeys =
    spec.module === 'purchase-requisition'
      ? ['DocumentNo', 'Document_No_', 'Document_No']
      : [lineHeaderField]
  let firstError: unknown = null
  for (const service of services) {
    for (const filterKey of lineFilterKeys) {
      try {
        const rows = await fetchOData(service, {
          $filter: `${filterKey} eq '${odataString(lineDocumentNo)}'`,
        })
        if (Array.isArray(rows) && rows.length > 0) return rows
      } catch (error) {
        firstError ??= error
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
  let no = ''
  if (spec.module === 'gate-pass') {
    const source = gatePassSourceFromQuery(
      headerBody.gatePassSource ??
        headerBody.source ??
        headerBody.linkTo ??
        headerBody.Linkto,
    )
    const sourceDocumentNo = fieldText(headerBody, [
      'sourceDocumentNo',
      'transferNo',
      'TransferNo',
      'Transfer_No',
    ])
    if (source === 'storeIssue' && sourceDocumentNo) {
      no = await resolveStoreIssueGatePassNo(sourceDocumentNo)
    }
  }

  if (!no) {
    const headerParams = await spec.params.saveHeader({
      req: headerRequest,
      user,
      no: '',
    })
    const headerResult = await callModuleSoap(spec, spec.soap.saveHeader, headerParams)
    if (!ok(headerResult)) {
      throw Object.assign(new Error(`Business Central did not create the ${spec.module} request`), {
        status: 502,
      })
    }
    no = String(headerResult.returnValue ?? '').trim()
  }
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

  await recalculateImprestSurrenderSettlement(spec, no)

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
      const lineResult = await callModuleSoap(spec, spec.soap.saveLine, lineParams)
      if (!ok(lineResult)) {
        throw Object.assign(
          new Error(`Business Central created ${no}, but line ${index + 1} failed`),
          { status: 502, documentNo: no },
        )
      }
    }
    await recalculateImprestSurrenderSettlement(spec, no)
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
    const submitResult = await callModuleSoap(spec, spec.soap.submit, submitParams)
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
  const result = await callModuleSoap(spec, spec.soap.cancel, params)
  if (!soapActionOk(spec, result)) {
    throw Object.assign(new Error(`Business Central did not cancel ${no}`), { status: 502 })
  }
}

export function purchaseBudgetErrorMessage(
  error: unknown,
  header: ODataRecord,
  lines: ODataRecord[],
  departmentKeys: string[] = [
    'RequestingDepartment',
    'Requesting_Department',
    'Department',
    'ShortcutDimension1Code',
    'Shortcut_Dimension_1_Code',
  ],
) {
  const raw = error instanceof Error ? error.message : String(error ?? '')
  if (
    !/does not exist in the finali[sz]ed budget|is not included in (?:the )?(?:current )?finali[sz]ed budget|there is no finali[sz]ed budget for the item|no approved finali[sz]ed budget was found|budget exceeded|budget balance/i.test(
      raw,
    )
  ) {
    return ''
  }

  const matchingLine =
    lines.find((line) => {
      const description = fieldText(line, ['Description', 'description']).trim().toLowerCase()
      return description.length > 0 && raw.toLowerCase().includes(description)
    }) ??
    lines[0] ??
    {}
  const itemNo = fieldText(matchingLine, [
    'No',
    'No_',
    'ItemNo',
    'Item_No',
    'itemNo',
  ])
  const description = fieldText(matchingLine, ['Description', 'description'])
  const department = fieldText(header, departmentKeys)
  const itemLabel = itemNo
    ? `${itemNo}${description ? ` (${description})` : ''}`
    : description || 'This item'
  const departmentLabel = department ? ` (${department})` : ''

  // Keep short — Excel rule still enforced; message is for the end user.
  return `Budget exceeded for ${itemLabel}${departmentLabel}. Choose a budgeted item or ask Finance to update the budget.`
}

function storeLineEstimatedAmount(line: ODataRecord) {
  const lineAmount = fieldNumber(line, ['LineAmount', 'Line_Amount', 'lineAmount'])
  if (lineAmount > 0) return lineAmount
  const unitCost = fieldNumber(line, ['UnitCost', 'Unit_Cost', 'unitCost'])
  const qty = fieldNumber(line, [
    'Quantity',
    'QuantityRequested',
    'Quantity_Requested',
    'quantity',
    'quantityRequested',
  ])
  return unitCost > 0 && qty > 0 ? unitCost * qty : 0
}

export function assertStoreRequisitionBudgetLines(lines: ODataRecord[]) {
  for (const line of lines) {
    const balance = fieldNumber(line, ['BudgetBalance', 'Budget_Balance', 'budgetBalance'], NaN)
    const itemNo = fieldText(line, ['No', 'No_', 'ItemNo', 'Item_No', 'itemNo'])
    const description = fieldText(line, ['Description', 'description'])
    const itemLabel = itemNo
      ? `${itemNo}${description ? ` (${description})` : ''}`
      : description || 'this item'
    const estimated = storeLineEstimatedAmount(line)
    if (Number.isFinite(balance) && balance < 0) {
      throw Object.assign(
        new Error(`Budget exceeded for requested item ${itemLabel}. Available balance: ${balance.toFixed(2)}.`),
        { status: 422, code: 'STORE_BUDGET_EXCEEDED' },
      )
    }
    if (Number.isFinite(balance) && estimated > 0 && estimated > balance + 0.01) {
      throw Object.assign(
        new Error(
          `Budget exceeded for requested item ${itemLabel}. Available balance: ${balance.toFixed(2)}.`,
        ),
        { status: 422, code: 'STORE_BUDGET_EXCEEDED' },
      )
    }
  }
}

function duplicateBlockingStatus(status: string) {
  const normalized = status.trim().toLowerCase()
  return !['cancelled', 'rejected', 'closed'].includes(normalized)
}

/**
 * Excel SR_03 / PR_07: block duplicate items while another request is Open,
 * Draft, Pending Approval, Submitted, or Approved. Only Rejected / Cancelled /
 * Closed allow the same item again.
 */
export function storeDuplicateBlockingStatus(status: string) {
  return duplicateBlockingStatus(status)
}

/** Excel PR_07 — same status gate as store requisition. */
export function purchaseDuplicateBlockingStatus(status: string) {
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

export async function assertNoDuplicateFuelRequest(
  user: AuthUser,
  currentDocNo: string,
  vehicleNo: string,
  litres: number,
  cardNo = '',
) {
  const normalizedVehicle = vehicleNo.trim().toUpperCase()
  const normalizedCard = cardNo.trim().toUpperCase()
  if ((!normalizedVehicle && !normalizedCard) || litres <= 0) return
  const spec = findModuleSpec('fuel')
  if (!spec) return
  let headers: ODataRecord[] = []
  try {
    headers = await listPortalModuleRows(spec, user)
  } catch {
    return
  }
  const cutoff = Date.now() - DUPLICATE_REQUISITION_WINDOW_MS
  const currentKey = currentDocNo.trim().toUpperCase()
  for (const header of headers) {
    const docNo = fieldText(header, ['RequisitionNo', 'Requisition_No', 'No'])
    if (docNo.trim().toUpperCase() === currentKey) continue
    const status = resolveModuleRequestStatus(header, 'fuelRequest')
    if (!duplicateBlockingStatus(status)) continue
    if (headerActivityTimestamp(header) < cutoff) continue
    const headerVehicle = fieldText(header, [
      'VehicleRegNo',
      'Vehicle_Reg_No',
      'VehicleNo',
      'Vehicle_No',
    ]).trim().toUpperCase()
    const headerCard = fieldText(header, ['FuelCardNo', 'Fuel_Card_No', 'CardNo']).trim().toUpperCase()
    const headerLitres = fieldNumber(header, [
      'QuantityofFuelLitres',
      'Quantity_of_Fuel_Litres',
      'Quantity',
    ])
    const sameVehicle = normalizedVehicle && headerVehicle === normalizedVehicle
    const sameCard = normalizedCard && headerCard === normalizedCard
    if ((sameVehicle || sameCard) && Math.abs(headerLitres - litres) < 0.01) {
      throw Object.assign(
        new Error(
          `Duplicate fuel entry detected for ${normalizedVehicle || `card ${normalizedCard}`} (${litres} L). See request ${docNo}.`,
        ),
        { status: 409, code: 'DUPLICATE_FUEL_REQUEST' },
      )
    }
  }
}

/** Active Asset Transfer statuses for Excel VTH_08 duplicate checks. */
export function assetTransferHandoverActive(status: string) {
  return !['Cancelled', 'Rejected', 'Closed', 'Posted'].includes(status)
}

export function assetTransferAssetNo(row: ODataRecord | Record<string, unknown>) {
  return fieldText(row, [
    'AssetToTransfer',
    'Asset_to_Transfer',
    'AssetNo',
    'Asset_No',
    'FixedAssetNo',
    'FANo',
  ])
    .trim()
    .toUpperCase()
}

export function assetTransferToEmployee(row: ODataRecord | Record<string, unknown>) {
  return fieldText(row, [
    'ToResponsibleEmployee',
    'To_Responsible_Employee',
    'ToEmployeeNo',
    'To_Employee_No',
    'NewResponsibleEmployee',
    'ResponsibleEmployee',
  ])
    .trim()
    .toUpperCase()
}

/** Excel VTH_08 — same asset already handed to the same person on an active transfer. */
export async function assertNoDuplicateAssetHandover(
  assetNo: string,
  toEmployee: string,
  excludeDocNo = '',
) {
  const normalizedAsset = assetNo.trim().toUpperCase()
  const normalizedEmployee = toEmployee.trim().toUpperCase()
  if (!normalizedAsset || !normalizedEmployee) return
  const fetched = await fetchOData('QyAssetTransfer', {}).catch(() => [])
  const rows = Array.isArray(fetched) ? fetched : []
  const exclude = excludeDocNo.trim().toUpperCase()
  const duplicate = rows.find((row) => {
    const docNo = fieldText(row, ['No', 'No_']).trim().toUpperCase()
    if (exclude && docNo === exclude) return false
    const status = resolveModuleRequestStatus(row, 'assetTransfer')
    if (!assetTransferHandoverActive(status)) return false
    if (fieldText(row, ['Posted']).toLowerCase() === 'true') return false
    return (
      assetTransferAssetNo(row) === normalizedAsset &&
      assetTransferToEmployee(row) === normalizedEmployee
    )
  })
  if (duplicate) {
    throw Object.assign(
      new Error('Item already assigned. Please return before re-assigning.'),
      { status: 409, code: 'DUPLICATE_ASSET_HANDOVER' },
    )
  }
}

/** Excel VTH_02 — tool/spare checklist required before approval. */
export async function assertAssetTransferToolsChecklist(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  header?: ODataRecord,
) {
  const tools = await listPortalModuleLines(spec, header ?? {}, no)
  if (tools.length === 0) {
    throw Object.assign(new Error('Tools and spare checklist must be completed.'), {
      status: 422,
      code: 'ASSET_TRANSFER_TOOLS_REQUIRED',
    })
  }
}

async function resolveAssetTransferAccessoryEntryNo(
  body: Record<string, unknown>,
  docNo: string,
  user: AuthUser,
) {
  let accessoryEntryNo = Number(body.accessoryEntryNo ?? body.entryNo ?? 0)
  if (Number.isFinite(accessoryEntryNo) && accessoryEntryNo > 0) {
    return accessoryEntryNo
  }

  const toolCode = String(body.toolCode ?? body.accessoryCode ?? '').trim()
  const toolName = String(body.toolName ?? body.toolDescription ?? body.accessoryName ?? '').trim()
  if (!toolCode && !toolName) {
    throw Object.assign(new Error('Select or register a vehicle tool or accessory.'), {
      status: 422,
      code: 'ASSET_TRANSFER_TOOL_REQUIRED',
    })
  }

  const header = await getPortalModuleDocument(findFrontendModuleSpec('assetTransfer')!, user, docNo, false)
  const assetNo = header ? assetTransferAssetNo(header) : ''
  if (!assetNo) {
    throw Object.assign(new Error('Save the asset transfer with an asset/vehicle selected first.'), {
      status: 422,
    })
  }
  const tagNo = header
    ? fieldText(header, ['TagNo', 'Tag_No', 'AssetTag', 'Asset_Tag'])
    : ''
  const quantity = Number(body.quantity ?? 1) || 1
  const serialNo = String(body.serialNo ?? '').trim()
  const result = await callModuleSoap(findFrontendModuleSpec('assetTransfer')!, 'RegisterAssetAccessory', {
    assetNo,
    accessoryCode: toolCode || toolName.replace(/\s+/g, '').slice(0, 20).toUpperCase(),
    accessoryName: toolName || toolCode,
    quantity,
    serialNo,
    tagNo,
  })
  accessoryEntryNo = Number(result.returnValue ?? 0)
  if (!Number.isFinite(accessoryEntryNo) || accessoryEntryNo <= 0) {
    throw Object.assign(
      new Error(
        'Could not register the tool in Business Central. Ask Felix to publish CuPortalAssetTransfer.RegisterAssetAccessory.',
      ),
      { status: 502, code: 'ASSET_ACCESSORY_REGISTER_FAILED' },
    )
  }
  return accessoryEntryNo
}

/** Excel VTH_08 — same tool line already on an active handover to the same person. */
export async function assertAssetTransferToolNotAlreadyAssigned(
  docNo: string,
  accessoryEntryNo: number,
  user: AuthUser,
) {
  if (!accessoryEntryNo) return
  const spec = findFrontendModuleSpec('assetTransfer')
  if (!spec) return
  const header = await getPortalModuleDocument(spec, user, docNo, false)
  if (!header) return
  const toEmployee = assetTransferToEmployee(header)
  const assetNo = assetTransferAssetNo(header)
  if (!toEmployee) return

  const fetched = await fetchOData('QyAssetTransfer', {}).catch(() => [])
  const rows = Array.isArray(fetched) ? (fetched as ODataRecord[]) : []
  const current = docNo.trim().toUpperCase()
  for (const row of rows) {
    const otherNo = fieldText(row, ['No', 'No_']).trim()
    if (!otherNo || otherNo.toUpperCase() === current) continue
    const status = resolveModuleRequestStatus(row, 'assetTransfer')
    if (!assetTransferHandoverActive(status)) continue
    if (fieldText(row, ['Posted']).toLowerCase() === 'true') continue
    if (assetTransferToEmployee(row) !== toEmployee) continue
    if (assetNo && assetTransferAssetNo(row) && assetTransferAssetNo(row) !== assetNo) continue
    const tools = await listPortalModuleLines(spec, row, otherNo).catch(() => [])
    const hit = tools.some((line) => {
      const entry = Number(line.AccessoryEntryNo ?? line.accessoryEntryNo ?? line.EntryNo ?? 0)
      return entry > 0 && entry === accessoryEntryNo
    })
    if (hit) {
      throw Object.assign(
        new Error('Item already assigned. Please return before re-assigning.'),
        { status: 409, code: 'DUPLICATE_ASSET_HANDOVER' },
      )
    }
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
  const purchaseLines =
    spec.module === 'purchase-requisition'
      ? await listPortalModuleLines(spec, header, no)
      : []
  const storeLines =
    spec.module === 'store-requisition'
      ? await listPortalModuleLines(spec, header, no)
      : []
  // Excel SR_02 — budget availability must block approval when balance is exceeded.
  if (spec.module === 'store-requisition' && storeLines.length > 0) {
    assertStoreRequisitionBudgetLines(storeLines)
  }
  if (spec.module === 'asset-transfer') {
    await assertAssetTransferToolsChecklist(spec, user, no, header)
  }
  if (spec.module === 'inter-bank-transfer') {
    const sourceAmount = Number(header.Source_Amount ?? header.SourceAmount ?? 0)
    const receivingAccount = fieldText(header, ['Receiving_Account', 'ReceivingAccount'])
    // HB 05/08/2026: paying bank account is not collected from the requester.
    if (sourceAmount <= 0 || !receivingAccount) {
      throw Object.assign(
        new Error(
          'Complete the receiving account and requested amount before requesting approval.',
        ),
        { status: 422 },
      )
    }
    const limit = await getPortalPettyCashDepartmentLimit(user)
    if (limit.configured && limit.limit > 0 && sourceAmount > limit.limit) {
      throw Object.assign(
        new Error(
          `Petty cash request ${sourceAmount.toFixed(2)} exceeds the Business Central department limit ` +
            `${limit.limit.toFixed(2)} for ${limit.departmentName || limit.departmentCode}.`,
        ),
        { status: 422 },
      )
    }
  }
  // Word Aug 7 / Excel R42–R43: settlement needs at least one line with amount before approval.
  if (spec.module === 'petty-cash') {
    const lines = await listPortalModuleLines(spec, header, no)
    const total = lines.reduce((sum, line) => sum + Number(line.amount ?? line.Amount ?? 0), 0)
    if (!lines.length || total <= 0) {
      throw Object.assign(
        new Error('Add at least one petty cash settlement line with an amount before requesting approval.'),
        { status: 422, code: 'PETTY_CASH_LINES_REQUIRED' },
      )
    }
  }
  // Settlement (petty-cash) no longer enforces department float limit — that is for replenishment/request.
  if (spec.module === 'fuel') {
    let fuelHeader = header
    try {
      const extras = (await fetchOData('QyPortalFuelMaintExtra', {
        $filter: `RequisitionNo eq '${odataString(no)}'`,
        $top: 1,
      }).catch(() => [])) as ODataRecord[] | null
      if (Array.isArray(extras) && extras[0]) {
        fuelHeader = { ...header, ...extras[0] }
      }
    } catch {
      // keep header-only validation when extras OData is unpublished
    }
    const litres = fieldNumber(fuelHeader, [
      'QuantityofFuelLitres',
      'Quantity_of_Fuel_Litres',
      'Quantity',
      'RequestedFuelLitres',
      'Requested_Fuel_Litres',
    ])
    const cardNo = fieldText(fuelHeader, ['FuelCardNo', 'Fuel_Card_No', 'CardNo', 'Card_No'])
    const vehicleNo = fieldText(fuelHeader, [
      'VehicleRegNo',
      'Vehicle_Reg_No',
      'VehicleNo',
      'Vehicle_No',
    ])
    await assertNoDuplicateFuelRequest(user, no, vehicleNo, litres, cardNo)
    if (cardNo && litres > 0) {
      const cards = (await fetchOData('QyFuelCardSetups', {
        $filter: `CardNo eq '${odataString(cardNo)}'`,
        $top: 1,
      }).catch(() => [])) as ODataRecord[] | null
      const card = Array.isArray(cards) ? cards[0] : undefined
      const monthlyLimit = fieldNumber(card ?? {}, [
        'MonthlyLimit',
        'Monthly_Limit',
        'MonthlyFuelLimit',
        'Monthly_Fuel_Limit',
      ])
      if (monthlyLimit > 0 && litres > monthlyLimit) {
        throw Object.assign(
          new Error(
            `Fuel limit exceeded for card ${cardNo}. Requested ${litres.toFixed(2)} L, monthly limit ${monthlyLimit.toFixed(2)} L.`,
          ),
          { status: 422, code: 'FUEL_MONTHLY_LIMIT_EXCEEDED' },
        )
      }
    }
    const odometer = fieldNumber(fuelHeader, [
      'CurrentOdometer',
      'Initial_Odometer_Reading',
      'InitialOdometerReading',
    ])
    if (odometer <= 0) {
      throw Object.assign(new Error('Odometer reading required'), {
        status: 422,
        code: 'FUEL_ODOMETER_REQUIRED',
      })
    }
    // R21/R22: previous km vs current km must meet vehicle fuel rating (km/L).
    let previousReading = fieldNumber(fuelHeader, [
      'VehicleCurrentReading',
      'Vehicle_Current_Reading',
      'PreviousReading',
      'Previous_Reading',
    ])
    let fuelRating = fieldNumber(fuelHeader, [
      'VehicleFuelRating',
      'Vehicle_Fuel_Rating',
      'FuelRating',
      'Fuel_Rating',
    ])
    if ((previousReading <= 0 || fuelRating <= 0) && vehicleNo) {
      try {
        const vehicles = (await fetchOData('QyVehicleHeader', {
          $filter: `RegistrationNo eq '${odataString(vehicleNo)}' or No eq '${odataString(vehicleNo)}'`,
          $top: 1,
        }).catch(() => [])) as ODataRecord[] | null
        const vehicle = Array.isArray(vehicles) ? vehicles[0] : undefined
        if (vehicle) {
          if (fuelRating <= 0) {
            fuelRating = fieldNumber(vehicle, ['FuelRating', 'Fuel_Rating'])
          }
          if (previousReading <= 0) {
            previousReading = fieldNumber(vehicle, [
              'CurrentReading',
              'Current_Reading',
              'CurrentMiliege',
              'CurrentOdometer',
            ])
          }
        }
      } catch {
        // vehicle lookup optional
      }
    }
    if (previousReading > 0 && odometer > 0 && litres > 0 && fuelRating > 0) {
      if (odometer < previousReading) {
        throw Object.assign(
          new Error(
            `Current odometer ${odometer} km cannot be less than the previous vehicle reading ${previousReading} km.`,
          ),
          { status: 422, code: 'FUEL_ODOMETER_BACKWARDS' },
        )
      }
      const kmDriven = odometer - previousReading
      if (kmDriven > 0) {
        const actualKmPerLitre = kmDriven / litres
        if (actualKmPerLitre < fuelRating) {
          throw Object.assign(
            new Error(
              `Fuel request ${actualKmPerLitre.toFixed(2)} km/L is below the vehicle standard ${fuelRating} km/L ` +
                `(${kmDriven} km / ${litres} L). Adjust litres or odometer to match the FLT vehicle fuel rating.`,
            ),
            { status: 422, code: 'FUEL_BELOW_VEHICLE_STANDARD' },
          )
        }
      }
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
  let result: SoapResult
  try {
    result = await callModuleSoap(spec, spec.soap.submit, params)
  } catch (error) {
    if (spec.module === 'purchase-requisition') {
      const message = purchaseBudgetErrorMessage(error, header, purchaseLines)
      if (message) {
        throw Object.assign(new Error(message), {
          status: 422,
          code: 'PURCHASE_ITEM_NOT_IN_FINALIZED_BUDGET',
        })
      }
    }
    if (spec.module === 'store-requisition') {
      const message = purchaseBudgetErrorMessage(error, header, storeLines, [
        'ShortcutDimension2Code',
        'Shortcut_Dimension_2_Code',
        'GlobalDimension2Code',
        'Global_Dimension_2_Code',
        'BudgetCenterName',
        'Budget_Center_Name',
      ])
      if (message) {
        throw Object.assign(new Error(message), {
          status: 422,
          code: 'STORE_ITEM_NOT_IN_FINALIZED_BUDGET',
        })
      }
    }
    throw error
  }
  if (!soapActionOk(spec, result)) {
    if (spec.module === 'fuel' || spec.module === 'maintenance' || spec.module === 'gate-pass') {
      const docType = fieldText(header, ['DocumentType', 'Document_Type', 'Linkto', 'LinkTo', 'Link_To'])
      const hint = docType
        ? ` Enable the Business Central approval workflow for "${docType}" on table ${spec.headerTableId}.`
        : ` Enable the Business Central approval workflow for this document type (table ${spec.headerTableId}).`
      throw Object.assign(new Error(`Business Central did not submit ${no}.${hint}`), { status: 502 })
    }
    throw Object.assign(new Error(`Business Central did not submit ${no}`), { status: 502 })
  }
}

export async function getPortalPettyCashDepartmentLimit(
  user: AuthUser,
  departmentCode = user.department,
) {
  const code = departmentCode.trim()
  if (!code) {
    return {
      departmentCode: '',
      departmentName: user.departmentName,
      limit: 0,
      configured: false,
    }
  }

  const rows = (await fetchOData('QyPettyCashLimitDepartment', {
    $filter: `DepartmentCode eq '${odataString(code)}'`,
    $top: 1,
  }).catch(() => [])) as ODataRecord[] | null
  const row = Array.isArray(rows) ? rows[0] : undefined
  const limit = Number(row?.Limit ?? row?.limit ?? 0)
  return {
    departmentCode: fieldText(row ?? {}, ['DepartmentCode', 'Department_Code']) || code,
    departmentName:
      fieldText(row ?? {}, ['DepartmentName', 'Department_Name']) || user.departmentName || code,
    limit: Number.isFinite(limit) ? limit : 0,
    configured: Boolean(row) && Number.isFinite(limit) && limit > 0,
  }
}

export async function postPortalAssetTransfer(user: AuthUser, no: string) {
  const spec = findFrontendModuleSpec('assetTransfer')
  if (!spec) {
    throw Object.assign(new Error('Asset Transfer is not configured'), { status: 501 })
  }
  const header = await getPortalModuleDocument(spec, user, no, false)
  if (!header) {
    throw Object.assign(new Error(`Asset Transfer ${no} was not found`), { status: 404 })
  }
  const status = fieldText(header, ['Status'])
  const posted = ['true', 'yes', '1'].includes(fieldText(header, ['Posted']).toLowerCase())
  if (status !== 'Approved' || posted) {
    throw Object.assign(
      new Error(
        posted
          ? `Asset Transfer ${no} is already posted`
          : `Asset Transfer ${no} must be approved before posting (current: ${status || 'unknown'})`,
      ),
      { status: 422 },
    )
  }
  const result = await callModuleSoap(spec, 'PostAssetTransfer', {
    docNo: no,
    myUserID: user.userID,
  })
  if (!approvalOk(result)) {
    throw Object.assign(new Error(`Business Central did not post Asset Transfer ${no}`), {
      status: 502,
    })
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
  const result = await callModuleSoap(spec, methodName, params)
  if (!ok(result)) {
    throw Object.assign(new Error(`Business Central did not update ${no}`), { status: 502 })
  }
  await recalculateImprestSurrenderSettlement(spec, no)
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
  const result = await callModuleSoap(spec, spec.soap.saveLine, params)
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
): Promise<Record<string, unknown>[]> {
  let linesToSave = lines
  if (isImprestSurrenderModule(spec.module)) {
    const header = await getPortalModuleDocument(spec, user, no)
    if (!header) {
      throw Object.assign(new Error(`Imprest surrender ${no} was not found`), { status: 404 })
    }
    const approvers = await fetchPortalApprovalEntries(spec, no, header)
    const surrenderStatus = resolveModuleRequestStatus(header, 'imprestSurrender', approvers)
    if (surrenderStatus !== 'Draft' && surrenderStatus !== 'Open') {
      throw Object.assign(
        new Error(
          `Imprest surrender lines cannot be edited when status is ${surrenderStatus}. Cancel approval or use a draft surrender.`,
        ),
        { status: 422 },
      )
    }
    const existingLines = await listPortalModuleLines(spec, header, no)
    linesToSave = imprestSurrenderLinesToPersist(
      prepareImprestSurrenderLinesForSave(existingLines, lines),
    )
  }
  for (let index = 0; index < linesToSave.length; index += 1) {
    const incoming = linesToSave[index] ?? {}
    await savePortalModuleLine(spec, user, no, {
      ...incoming,
      action: incoming.action ?? (incoming.lineNo ? 'edit' : 'create'),
      lineNo: Number(incoming.lineNo ?? (index + 1) * 10000),
    })
  }

  if (isImprestSurrenderModule(spec.module) && linesToSave.length > 0) {
    await recalculateImprestSurrenderSettlement(spec, no)

    const spendLines = await fetchImprestSurrenderSpendLineRows(no)
    const allLines = await fetchImprestSurrenderLineRows(no)
    const verifyLines =
      imprestSurrenderLinesHaveSpendReadback(spendLines as Record<string, unknown>[])
        ? (spendLines as Record<string, unknown>[])
        : (allLines as Record<string, unknown>[])
    if (!imprestSurrenderLinesHaveSpendReadback(verifyLines)) {
      throw Object.assign(
        new Error(
          'Business Central did not return surrender spend fields. Felix must publish OData web service ImprestSurrenderDetails (query 50079) with ActualSpent and OutstandingAmount, then retry.',
        ),
        { status: 502 },
      )
    }
    for (const saved of linesToSave) {
      const expectedSpent = Number(saved.actualSpent ?? 0)
      if (expectedSpent <= 0) continue
      const accountNo = String(saved.accountNo ?? '')
      const expectedReceipt = Number(saved.cashReceiptAmount ?? 0)
      const match = verifyLines.find((row) => imprestSurrenderAccountNo(row) === accountNo)
      if (!match) {
        throw Object.assign(
          new Error(`Business Central surrender line ${accountNo} was not found after save`),
          { status: 502 },
        )
      }
      if (!imprestSurrenderLinePersistedMatches(match, expectedSpent, expectedReceipt)) {
        const readSpent = imprestSurrenderLineActualSpent(match)
        const readOutstanding = imprestSurrenderLineOutstanding(match)
        const odataHint =
          spendLines.length === 0
            ? 'ImprestSurrenderDetails OData is not published — Felix must publish query 50079.'
            : 'Open the surrender in Business Central. If Actual Spent is correct there, republish ImprestSurrenderDetails OData.'
        throw Object.assign(
          new Error(
            `Business Central did not persist surrender expenditure on account ${accountNo} (saved spent ${expectedSpent}, receipt ${expectedReceipt}; OData read spent ${readSpent}, outstanding ${readOutstanding ?? 'n/a'}). Publish AL 1.0.5.166+ (partial settlement tax). ${odataHint}`,
          ),
          { status: 502 },
        )
      }
    }
  }

  return linesToSave
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
  const result = await callModuleSoap(spec, spec.soap.deleteLine, params)
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
  const facilityAttachmentModules = new Set([
    'purchase-requisition',
    'store-requisition',
    'fuel',
    'maintenance',
    'transport',
    'gate-pass',
    'transfer-order',
  ])
  if (facilityAttachmentModules.has(spec.module)) {
    const contentBase64 = String(attachment.contentBase64 ?? '').replace(/^data:[^,]+,/, '')
    const description = String(attachment.description ?? '').trim()
    const fileName = attachmentFileName(attachment)
    const extension = fileName.split('.').pop()?.toLowerCase() ?? ''
    if (!contentBase64) {
      throw Object.assign(new Error('Attachment content is required'), { status: 422 })
    }
    if (!description) {
      throw Object.assign(new Error('Attachment description is required'), { status: 422 })
    }
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
    const result = await uploadViaPortalAttachments({
      docNo,
      description,
      tableID: spec.headerTableId,
      fileName,
      fileBase64: contentBase64,
    })
    if (!attachmentOk(result)) {
      throw Object.assign(new Error('Business Central did not store the attachment'), {
        status: 502,
      })
    }
    return
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
