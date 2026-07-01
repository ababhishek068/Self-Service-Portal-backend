import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import {
  callSoapMethod,
  createSoapPageRecord,
  fetchOData,
  odataString,
  patchOData,
  postOData,
  type ODataRecord,
} from './bcClient.js'
import { config } from './config.js'
import { approvalTableFilter, type ApprovalTableKey } from './approvalTableIds.js'
import { requireAuth } from './auth.js'
import type { AuthUser } from './auth.js'
import { formatBcSoapDate } from './staff.js'
import {
  bcDocumentStatus,
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

function isGatePassApprovalRecordFault(error: unknown) {
  const message = error instanceof Error ? error.message : String(error ?? '')
  return (
    /Requisition is no longer editable or it does not exist/i.test(message) ||
    /linked Business Central document is missing/i.test(message)
  )
}

export function gatePassApprovalSetupMessage(no: string, transferNo: string, sourceLabel = '') {
  const source = sourceLabel ? `${sourceLabel} ` : ''
  const sourceText = transferNo ? `${source}${transferNo}` : 'the linked source document'
  return `Business Central created Gate Pass ${no}, but RequestGatePassApproval could not find an editable native gate-pass requisition for ${sourceText}. Manual Business Central setup is required: page 51244 "Gate Pass Card" is currently writable through OData, but the Store Issue/Transfer Order source link used by the approval codeunit is not being persisted for these OData-created cards. Ask the BC developer to either expose and persist the source link field used by RequestGatePassApproval on page 51244 (for example TransferNo/Transfer_No/Store Issue No), or publish a codeunit action that creates the gate pass from the source document and then requests approval.`
}

function gatePassApprovalSetupError(no: string, transferNo: string, sourceLabel = '') {
  return Object.assign(new Error(gatePassApprovalSetupMessage(no, transferNo, sourceLabel)), {
    status: 422,
    code: 'BC_GATE_PASS_APPROVAL_SETUP_REQUIRED',
  })
}

function gatePassODataPageSourceUnsupportedMessage(sourceLabel: string) {
  return `Manual Business Central setup is required: page 51244 "Gate Pass Card" is published as Gate_Pass_Card, but it does not expose a writable ${sourceLabel} source-number field through OData. The current published page supports AssetTransferNo only, so OData-created ${sourceLabel} gate passes cannot be linked to the source document or sent for approval. Ask the BC developer to expose and persist the ${sourceLabel} source-link field used by RequestGatePassApproval on page 51244, or publish a codeunit action that creates the gate pass from the source document and requests approval.`
}

function gatePassODataPageSourceUnsupportedError(sourceLabel: string) {
  return Object.assign(new Error(gatePassODataPageSourceUnsupportedMessage(sourceLabel)), {
    status: 502,
    code: 'BC_GATE_PASS_SOURCE_FIELD_MISSING',
  })
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
  return normalizedGatePassSource(fieldText(row, ['Linkto', 'LinkTo', 'Link_to', 'Link_To', 'Link']))
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
    documentNo: gatePassTransferNo(row, fallbackNo),
  }
}

const RECENT_GATE_PASS_TTL_MS = 6 * 60 * 60 * 1000
const recentGatePassCreates = new Map<string, { row: ODataRecord; expiresAt: number }>()

function gatePassEmployeeNo(row: ODataRecord) {
  return fieldText(row, ['EmployeeNo', 'Employee_No', 'StaffNo', 'Staff_No'])
}

function pruneRecentGatePassCreates() {
  const now = Date.now()
  for (const [key, value] of recentGatePassCreates) {
    if (value.expiresAt <= now) recentGatePassCreates.delete(key)
  }
}

function recentGatePassRow(no: string) {
  pruneRecentGatePassCreates()
  return recentGatePassCreates.get(no)?.row ?? null
}

function gatePassRowMatchesSource(row: ODataRecord, source: GatePassSourceKey, user: AuthUser) {
  if (gatePassSourceFromRow(row) !== source) return false
  const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
  if (!sourceSpec.scopeToEmployee) return true
  const employeeNo = gatePassEmployeeNo(row)
  return !employeeNo || employeeNo === user.employeeNo
}

function mergeRecentGatePassRow(row: ODataRecord) {
  const no = gatePassDocumentNo(row)
  const recent = no ? recentGatePassRow(no) : null
  return recent ? { ...row, ...recent } : row
}

function mergeRecentGatePassRows(rows: ODataRecord[], source: GatePassSourceKey, user: AuthUser) {
  pruneRecentGatePassCreates()
  const byNo = new Map<string, ODataRecord>()
  const anonymous: ODataRecord[] = []
  for (const row of rows.map(mergeRecentGatePassRow)) {
    const no = gatePassDocumentNo(row)
    if (!no) {
      anonymous.push(row)
      continue
    }
    byNo.set(no, byNo.has(no) ? { ...byNo.get(no), ...row } : row)
  }
  for (const { row } of recentGatePassCreates.values()) {
    if (!gatePassRowMatchesSource(row, source, user)) continue
    const no = gatePassDocumentNo(row)
    if (!no) continue
    byNo.set(no, byNo.has(no) ? { ...byNo.get(no), ...row } : row)
  }
  return [...byNo.values(), ...anonymous]
}

function rememberRecentGatePassCreate(
  source: GatePassSourceKey,
  user: AuthUser,
  values: GatePassPageValues,
  created: ODataRecord | null,
) {
  const no = gatePassDocumentNo(created ?? {}) || String(values.gatePassNo ?? '').trim()
  if (!no) return created
  const row = cleanODataPayload({
    ...(created ?? {}),
    GatePassNo: no,
    Gate_Pass_No: no,
    Linkto: values.linkTo,
    Link_to: values.linkTo,
    gatePassSource: source,
    sourceDocumentNo: values.sourceDocumentNo,
    TransferNo: values.sourceDocumentNo,
    Transfer_No: values.sourceDocumentNo,
    EmployeeNo: values.employeeNo,
    EmployeeName: user.displayName,
    DateCreated: new Date().toISOString().slice(0, 10),
    DateOut: values.dateOut,
    TimeOut: values.timeOut,
    FromLocation: values.fromLocation,
    AssetFromLocation: values.fromLocation,
    ToLocation: values.toLocation,
    AssetToLocation: values.toLocation,
    Description: values.description || values.linkTo,
    Comment: values.comment,
    ResponsibilityCenter: values.responsibilityCenter,
    Status: fieldText(created ?? {}, ['Status']) || 'Open',
  })
  recentGatePassCreates.set(no, {
    row,
    expiresAt: Date.now() + RECENT_GATE_PASS_TTL_MS,
  })
  return row
}

function cleanODataPayload(payload: Record<string, unknown>) {
  return Object.fromEntries(
    Object.entries(payload).filter(([, value]) => {
      if (value === undefined || value === null) return false
      if (typeof value === 'string' && value.trim() === '') return false
      return true
    }),
  )
}

function normalizeBcTime(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw) return ''
  if (/^\d{2}:\d{2}:\d{2}$/.test(raw)) return raw
  if (/^\d{2}:\d{2}$/.test(raw)) return `${raw}:00`
  return raw
}

function generateGatePassNo() {
  const stamp = new Date().toISOString().replace(/\D/g, '').slice(2, 14)
  const suffix = Math.floor(Math.random() * 1000).toString().padStart(3, '0')
  return `GP${stamp}${suffix}`
}

export function gatePassDocumentNo(row: ODataRecord) {
  return fieldText(row, ['GatePassNo', 'Gate_Pass_No', 'Gate_Pass_No_', 'GatePassNumber', 'No'])
}

function gatePassTransferNo(row: Record<string, unknown>, fallback = '') {
  return fieldText(row, [
    'transferNo',
    'TransferNo',
    'Transfer_No',
    'Transfer_No_',
    'assetTransferNo',
    'AssetTransferNo',
    'Asset_Transfer_No',
    'transferOrderNo',
    'TransferOrderNo',
    'Transfer_Order_No',
    'storeIssueNo',
    'StoreIssueNo',
    'Store_Issue_No',
    'RequisitionNo',
    'RequistionNo',
    'sourceDocumentNo',
    'SourceDocumentNo',
    'Source_Document_No',
    'DocumentNo',
  ], fallback)
}

/** Resolve the linked source document number ESS sends as `transferNo` on gate pass approval. */
export function resolveGatePassTransferNo(
  row: ODataRecord,
  ...fallbacks: Array<Record<string, unknown>>
) {
  let transferNo = gatePassTransferNo(row)
  for (const fallback of fallbacks) {
    if (transferNo) break
    transferNo = gatePassTransferNo(fallback)
  }
  return transferNo
}

async function fetchODataTop1(service: string, filter: string) {
  const rows = (await fetchOData(service, { $filter: filter, $top: 1 }).catch(
    () => null,
  )) as ODataRecord[] | null
  return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
}

/** Gate pass approval requires a real linked source document with lines in BC. */
async function assertGatePassSourceReady(header: ODataRecord) {
  const source = gatePassSourceFromRow(header)
  const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
  const transferNo = resolveGatePassTransferNo(header)
  if (!transferNo) {
    throw Object.assign(
      new Error(
        'This gate pass has no linked Store Issue / Transfer / Asset Transfer number in Business Central. Create a new gate pass with a valid source document number.',
      ),
      { status: 422 },
    )
  }
  if (source === 'assetTransfer') return transferNo

  const lineRows = (await fetchOData(sourceSpec.lineService, {
    $filter: `${sourceSpec.lineHeaderField} eq '${odataString(transferNo)}'`,
    $top: 1,
  }).catch(() => null)) as ODataRecord[] | null
  if (Array.isArray(lineRows) && lineRows.length > 0) return transferNo

  const headerServices =
    source === 'transferOrder'
      ? ['QyTransferOrderHeader']
      : ['QyStoreRequisitionHeader']
  for (const service of headerServices) {
    const row = await fetchODataTop1(service, `No eq '${odataString(transferNo)}'`)
    if (row) {
      const status = bcDocumentStatus(
        source === 'transferOrder' ? 'transfer-order' : 'store-requisition',
        row,
      )
      throw Object.assign(
        new Error(
          `Linked ${sourceSpec.linkTo} ${transferNo} exists in Business Central (status: ${status || 'unknown'}) but has no lines available for gate pass approval. Use a posted store issue / released transfer with lines, then create a new gate pass.`,
        ),
        { status: 422 },
      )
    }
  }

  throw Object.assign(
    new Error(
      `${sourceSpec.linkTo} document ${transferNo} was not found in Business Central. Enter a valid source number from BC — not a placeholder test value.`,
    ),
    { status: 422 },
  )
}

function gatePassODataInsertUnsupported(error: unknown) {
  const message = error instanceof Error ? error.message : String(error ?? '')
  return /MethodNotImplemented|does not support insert|Entity does not support insert/i.test(message)
}

function gatePassSoapPageServiceNames() {
  const configured = config.BC_GATE_PASS_PAGE_SERVICE
    .split(',')
    .map((item) => item.trim())
    .filter(Boolean)
  return [
    ...configured,
    'Gate_Pass_Card',
    'Gatepass_Card',
    'GatePassCard',
    'GatepassCard',
    'Gate_Pass',
    'GatePass',
    'Gatepass',
  ].filter((item, index, items) => items.indexOf(item) === index)
}

function gatePassODataPageServiceNames() {
  const configured = config.BC_GATE_PASS_PAGE_SERVICE
    .split(',')
    .map((item) => item.trim())
    .filter(Boolean)
  return configured.length ? configured : ['Gate_Pass_Card']
}

function bcSoapPageServiceNotFound(error: unknown) {
  const message = error instanceof Error ? error.message : String(error ?? '')
  return /Service\s+"?Page\/[^"]+"?\s+was not found|Service .* was not found|Page\/.*not found/i.test(message)
}

function readableBcError(error: unknown) {
  const raw = error instanceof Error ? error.message : String(error ?? '')
  const jsonStart = raw.indexOf('{')
  if (jsonStart >= 0) {
    try {
      const data = JSON.parse(raw.slice(jsonStart))
      const message = data?.error?.message
      const code = data?.error?.code
      if (
        /Internal_InvalidTableRelation/i.test(String(code ?? '')) &&
        /field Transfer No/i.test(String(message ?? '')) &&
        /related table \(Asset Transfer\)/i.test(String(message ?? ''))
      ) {
        const invalidNo = String(message ?? '').match(/value \(([^)]+)\)/i)?.[1]
        return `Invalid Asset Transfer No${invalidNo ? ` "${invalidNo}"` : ''}. Select an existing Asset Transfer document from Business Central.`
      }
      if (message && code) return `${code}: ${message}`
      if (message) return String(message)
    } catch {
      // Keep the original error if the payload is not standalone JSON.
    }
  }
  return raw
}

function gatePassPageSourceDocumentFieldNames(source: GatePassSourceKey) {
  return source === 'assetTransfer' ? ['AssetTransferNo'] : []
}

type GatePassPageValues = {
  gatePassNo: unknown
  linkTo: string
  sourceDocumentNo: string
  dateOut: unknown
  timeOut: string
  description: unknown
  comment: unknown
  fromLocation: unknown
  toLocation: unknown
  employeeNo: string
  responsibilityCenter: unknown
}

function gatePassPageValues(
  sourceSpec: (typeof GATE_PASS_SOURCE_SPECS)[GatePassSourceKey],
  user: AuthUser,
  body: Record<string, unknown>,
  sourceDocumentNo: string,
): GatePassPageValues {
  return {
    gatePassNo: fieldText(body, ['gatePassNo', 'gatePassNumber']) || generateGatePassNo(),
    linkTo: sourceSpec.linkTo,
    sourceDocumentNo,
    dateOut: body.dateOut ?? body.issueDate,
    timeOut: normalizeBcTime(body.timeOut),
    description: body.description ?? body.reason,
    comment: body.comment,
    fromLocation: body.fromLocation ?? body.from,
    toLocation: body.toLocation ?? body.to ?? body.destination,
    employeeNo: user.employeeNo,
    responsibilityCenter: firstBcCodeValue(body.responsibilityCenter, user.responsibleCenter),
  }
}

function gatePassPagePayloads(values: GatePassPageValues) {
  const canonicalFull = {
    Gate_Pass_No: values.gatePassNo,
    Link_to: values.linkTo,
    Transfer_No: values.sourceDocumentNo,
    Date_Out: values.dateOut,
    Time_Out: values.timeOut,
    Description: values.description,
    Comment: values.comment,
    From_Location: values.fromLocation,
    To_Location: values.toLocation,
    Employee_No: values.employeeNo,
    Responsibility_Center: values.responsibilityCenter,
  }
  const canonicalTitleFull = {
    Gate_Pass_No: values.gatePassNo,
    Link_To: values.linkTo,
    Transfer_No: values.sourceDocumentNo,
    Date_Out: values.dateOut,
    Time_Out: values.timeOut,
    Description: values.description,
    Comment: values.comment,
    From_Location: values.fromLocation,
    To_Location: values.toLocation,
    Employee_No: values.employeeNo,
    Responsibility_Center: values.responsibilityCenter,
  }
  const odataFull = {
    GatePassNo: values.gatePassNo,
    Linkto: values.linkTo,
    TransferNo: values.sourceDocumentNo,
    DateOut: values.dateOut,
    TimeOut: values.timeOut,
    Description: values.description,
    Comment: values.comment,
    FromLocation: values.fromLocation,
    ToLocation: values.toLocation,
    EmployeeNo: values.employeeNo,
    ResponsibilityCenter: values.responsibilityCenter,
  }
  const canonicalMinimal = {
    Link_to: values.linkTo,
    Transfer_No: values.sourceDocumentNo,
    Employee_No: values.employeeNo,
    Date_Out: values.dateOut,
    Time_Out: values.timeOut,
    From_Location: values.fromLocation,
    To_Location: values.toLocation,
    Comment: values.comment,
  }
  const canonicalTitleMinimal = {
    Link_To: values.linkTo,
    Transfer_No: values.sourceDocumentNo,
    Employee_No: values.employeeNo,
    Date_Out: values.dateOut,
    Time_Out: values.timeOut,
    From_Location: values.fromLocation,
    To_Location: values.toLocation,
    Comment: values.comment,
  }
  const odataMinimal = {
    Linkto: values.linkTo,
    TransferNo: values.sourceDocumentNo,
    EmployeeNo: values.employeeNo,
    DateOut: values.dateOut,
    TimeOut: values.timeOut,
    FromLocation: values.fromLocation,
    ToLocation: values.toLocation,
    Comment: values.comment,
  }
  return [
    canonicalFull,
    canonicalTitleFull,
    odataFull,
    canonicalMinimal,
    canonicalTitleMinimal,
    odataMinimal,
  ].map(cleanODataPayload)
}

function gatePassODataPagePayloads(source: GatePassSourceKey, values: GatePassPageValues) {
  const sourceFields = gatePassPageSourceDocumentFieldNames(source)
  if (sourceFields.length === 0) return [] as Record<string, unknown>[]

  const basePayloads = [
    {
      Gate_Pass_No: values.gatePassNo,
      Link_to: values.linkTo,
      EmployeeNo: values.employeeNo,
      DateOut: values.dateOut,
      TimeOut: values.timeOut,
      Comment: values.comment,
      AssetFromLocation: values.fromLocation,
      AssetToLocation: values.toLocation,
      ResponsibilityCenter: values.responsibilityCenter,
    },
    {
      Gate_Pass_No: values.gatePassNo,
      Link_to: values.linkTo,
      EmployeeNo: values.employeeNo,
      DateOut: values.dateOut,
      TimeOut: values.timeOut,
      Comment: values.comment,
    },
  ]
  const payloads: Record<string, unknown>[] = []
  for (const sourceField of sourceFields) {
    for (const payload of basePayloads) {
      payloads.push(cleanODataPayload({
        ...payload,
        [sourceField]: values.sourceDocumentNo,
      }))
    }
  }
  return payloads
}

export function gatePassODataPagePayloadVariants(
  source: GatePassSourceKey,
  sourceSpec: (typeof GATE_PASS_SOURCE_SPECS)[GatePassSourceKey],
  user: AuthUser,
  body: Record<string, unknown>,
  sourceDocumentNo: string,
) {
  const seen = new Set<string>()
  const variants: Record<string, unknown>[] = []
  for (const payload of gatePassODataPagePayloads(source, gatePassPageValues(sourceSpec, user, body, sourceDocumentNo))) {
    const key = JSON.stringify(payload)
    if (seen.has(key)) continue
    seen.add(key)
    variants.push(payload)
  }
  return variants
}

function gatePassODataPageSourcePatchPayloads(
  source: GatePassSourceKey,
  _values: GatePassPageValues,
) {
  if (source === 'assetTransfer') return [] as Record<string, unknown>[]
  return [] as Record<string, unknown>[]
}

export function gatePassODataPageSourcePatchPayloadVariants(
  source: GatePassSourceKey,
  sourceSpec: (typeof GATE_PASS_SOURCE_SPECS)[GatePassSourceKey],
  user: AuthUser,
  body: Record<string, unknown>,
  sourceDocumentNo: string,
) {
  return gatePassODataPageSourcePatchPayloads(
    source,
    gatePassPageValues(sourceSpec, user, body, sourceDocumentNo),
  )
}

async function patchGatePassODataPageSource(
  serviceName: string,
  created: ODataRecord | null,
  values: GatePassPageValues,
) {
  const patches = gatePassODataPageSourcePatchPayloads(
    normalizedGatePassSource(values.linkTo),
    values,
  )
  if (patches.length === 0) {
    return created ?? cleanODataPayload({
      Gate_Pass_No: values.gatePassNo,
      Link_to: values.linkTo,
      EmployeeNo: values.employeeNo,
    })
  }
  throw new Error(
    `OData page source link failed for ${serviceName}: no supported source-link patch fields are published for this Gate_Pass_Card page.`,
  )
}

export function gatePassSoapPagePayloadVariants(
  sourceSpec: (typeof GATE_PASS_SOURCE_SPECS)[GatePassSourceKey],
  user: AuthUser,
  body: Record<string, unknown>,
  sourceDocumentNo: string,
) {
  const seen = new Set<string>()
  const variants: Record<string, unknown>[] = []
  for (const payload of gatePassPagePayloads(gatePassPageValues(sourceSpec, user, body, sourceDocumentNo))) {
    const key = JSON.stringify(payload)
    if (seen.has(key)) continue
    seen.add(key)
    variants.push(payload)
  }
  return variants
}

async function createGatePassViaODataPage(
  source: GatePassSourceKey,
  sourceSpec: (typeof GATE_PASS_SOURCE_SPECS)[GatePassSourceKey],
  user: AuthUser,
  body: Record<string, unknown>,
  sourceDocumentNo: string,
) {
  const serviceNames = gatePassODataPageServiceNames()
  const values = gatePassPageValues(sourceSpec, user, body, sourceDocumentNo)
  const variants = gatePassODataPagePayloadVariants(source, sourceSpec, user, body, sourceDocumentNo)
  if (variants.length === 0) {
    throw gatePassODataPageSourceUnsupportedError(sourceSpec.linkTo)
  }
  let lastError: unknown
  for (const serviceName of serviceNames) {
    for (const payload of variants) {
      let created: ODataRecord | null = null
      try {
        created = await postOData(serviceName, payload)
      } catch (error) {
        lastError = error
        continue
      }
      return await patchGatePassODataPageSource(serviceName, created, values)
    }
  }
  throw new Error(
    `OData page create failed for ${serviceNames.join(', ')}: ${readableBcError(lastError)}`,
  )
}

async function createGatePassViaSoapPage(
  sourceSpec: (typeof GATE_PASS_SOURCE_SPECS)[GatePassSourceKey],
  user: AuthUser,
  body: Record<string, unknown>,
  sourceDocumentNo: string,
) {
  const variants = gatePassSoapPagePayloadVariants(sourceSpec, user, body, sourceDocumentNo)
  const serviceNames = gatePassSoapPageServiceNames()
  let lastError: unknown
  for (const serviceName of serviceNames) {
    for (const fields of variants) {
      try {
        return await createSoapPageRecord(serviceName, fields)
      } catch (error) {
        lastError = error
        if (bcSoapPageServiceNotFound(error)) break
      }
    }
  }
  const message = lastError instanceof Error ? lastError.message : String(lastError ?? '')
  throw Object.assign(
    new Error(
      `${message} Tried SOAP page services: ${serviceNames.join(', ')}. Publish BC page 51244 "Gate Pass Card" as a SOAP Web Service or set BC_GATE_PASS_PAGE_SERVICE to the exact published Service Name.`,
    ),
    { cause: lastError },
  )
}

async function createGatePassViaBusinessCentral(
  spec: ModuleSpec,
  user: AuthUser,
  body: Record<string, unknown>,
) {
  const source = gatePassSourceFromQuery(
    body.gatePassSource ?? body.source ?? body.linkTo ?? body.Linkto,
  )
  const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
  const sourceDocumentNo = fieldText(body, [
    'sourceDocumentNo',
    'sourceDocumentNumber',
    'sourceNo',
    'documentNo',
    'storeIssueNo',
    'assetTransferNo',
    'transferNo',
    'TransferNo',
    'Transfer_No',
    'Transfer_No_',
  ])
  if (!sourceDocumentNo) {
    throw Object.assign(new Error(`${sourceSpec.linkTo} document number is required`), {
      status: 422,
    })
  }
  await assertGatePassSourceReady({
    Link_to: sourceSpec.linkTo,
    Linkto: sourceSpec.linkTo,
    TransferNo: sourceDocumentNo,
    Transfer_No: sourceDocumentNo,
    SourceDocumentNo: sourceDocumentNo,
  })
  const gatePassNo = fieldText(body, ['gatePassNo', 'gatePassNumber']) || generateGatePassNo()
  const createBody = { ...body, gatePassNo }
  const pageValues = gatePassPageValues(sourceSpec, user, createBody, sourceDocumentNo)

  const beforeRows = await listPortalModuleRows(spec, user, { gatePassSource: source }).catch(
    () => [] as ODataRecord[],
  )
  const beforeNumbers = new Set(beforeRows.map(gatePassDocumentNo).filter(Boolean))
  const payload = cleanODataPayload({
    GatePassNo: gatePassNo,
    Linkto: sourceSpec.linkTo,
    TransferNo: sourceDocumentNo,
    DateOut: body.dateOut ?? body.issueDate,
    TimeOut: normalizeBcTime(body.timeOut),
    Description: body.description ?? body.reason,
    Comment: body.comment,
    FromLocation: body.fromLocation ?? body.from,
    ToLocation: body.toLocation ?? body.to ?? body.destination,
    EmployeeNo: user.employeeNo,
  })

  let created: ODataRecord | null = null
  try {
    created = await postOData(spec.headerService, payload)
  } catch (error) {
    if (!gatePassODataInsertUnsupported(error)) throw error
    let odataPageError: unknown
    try {
      created = await createGatePassViaODataPage(source, sourceSpec, user, createBody, sourceDocumentNo)
    } catch (odataError) {
      odataPageError = odataError
      created = await createGatePassViaSoapPage(sourceSpec, user, createBody, sourceDocumentNo).catch((soapError) => {
        const odataMessage = readableBcError(odataPageError)
        const soapMessage = readableBcError(soapError)
        throw Object.assign(
          new Error(
            `Business Central QyGatePass is read-only for creation. OData Gate_Pass_Card create failed: ${odataMessage}. SOAP Gate Pass Card create also failed: ${soapMessage}`,
          ),
          { status: 502, code: 'BC_GATE_PASS_CREATE_FAILED' },
        )
      })
    }
    if (!created) {
      throw Object.assign(
        new Error('Business Central did not return a gate pass record after creation.'),
        { status: 502, code: 'BC_GATE_PASS_CREATE_FAILED' },
      )
    }
  }
  created = rememberRecentGatePassCreate(source, user, pageValues, created)
  let no = created ? gatePassDocumentNo(created) : ''
  for (let attempt = 0; attempt < 4 && !no; attempt += 1) {
    if (attempt > 0) await new Promise((resolve) => setTimeout(resolve, 250))
    const rows = await listPortalModuleRows(spec, user, { gatePassSource: source })
    const row = rows.find((candidate) => {
      const candidateNo = gatePassDocumentNo(candidate)
      if (!candidateNo || beforeNumbers.has(candidateNo)) return false
      const transferNo = gatePassTransferNo(candidate)
      return !transferNo || transferNo === sourceDocumentNo
    })
    no = row ? gatePassDocumentNo(row) : ''
  }
  if (!no) {
    throw Object.assign(
      new Error('Business Central created the gate pass but did not return Gate Pass No.'),
      { status: 502 },
    )
  }
  return no
}

function storeLineTypeCode(value: unknown) {
  return numericCode(value, { item: 1, asset: 2 })
}

function purchaseLineTypeCode(value: unknown) {
  return numericCode(value, { service: 1, item: 2, asset: 4 })
}

function bcCodeValue(value: unknown, maxLength = 20) {
  const raw = String(value ?? '').trim()
  return raw && raw.length <= maxLength ? raw : ''
}

function firstBcCodeValue(...values: unknown[]) {
  for (const value of values) {
    const code = bcCodeValue(value)
    if (code) return code
  }
  return ''
}

function userDepartmentCode(user: AuthUser, body: Record<string, unknown>) {
  return firstBcCodeValue(
    body.departmentCode,
    body.DepartmentCode,
    body.Department_Code,
    body.requestingDepartmentCode,
    body.RequestingDepartmentCode,
    body.Requesting_Department_Code,
    body.requesting_Department_Code,
    body.shortcutDimension2Code,
    body.ShortcutDimension2Code,
    body.Shortcut_Dimension_2_Code,
    body.shortcut_Dimension_2_Code,
    body.globalDimension2Code,
    body.GlobalDimension2Code,
    body.Global_Dimension_2_Code,
    body.global_Dimension_2_Code,
    body.requestingDepartment,
    body.RequestingDepartment,
    body.Requesting_Department,
    body.requesting_Department,
    body.department,
    body.Department,
    user.department,
    ...(user.permissionDepartments ?? []),
  )
}

export function resolvePurchaseRequestingDepartment(
  user: AuthUser,
  header: ODataRecord | null | undefined,
  body: Record<string, unknown> = {},
) {
  return firstBcCodeValue(
    userDepartmentCode(user, body),
    purchaseHeaderDepartmentCode(header),
    user.department,
    user.departmentName,
    ...(user.permissionDepartments ?? []),
  )
}

async function loadUserDepartmentCodeFromBc(user: AuthUser) {
  if (!user.employeeNo) return ''
  const rows = (await fetchOData('QyHREmployee', {
    $filter: `No eq '${odataString(user.employeeNo)}'`,
    $top: 1,
  }).catch(() => [])) as ODataRecord[] | null
  const employee = Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
  if (!employee) return ''
  return firstBcCodeValue(
    employee.GlobalDimension1Code,
    employee.Global_Dimension_1_Code,
    employee.DepartmentCode,
    employee.Department_Code,
    employee.ShortcutDimension2Code,
    employee.Shortcut_Dimension_2_Code,
    employee.DistrictDepartmentCode,
    employee.District_Department_Code,
    employee.DepartmentName,
    employee.Department_Name,
    employee.DistrictDepartmentName,
    employee.District_Department_Name,
    user.department,
    user.departmentName,
    ...(user.permissionDepartments ?? []),
  )
}

export async function resolvePurchaseRequestingDepartmentForSave(
  user: AuthUser,
  header: ODataRecord | null | undefined,
  body: Record<string, unknown> = {},
) {
  const resolved = resolvePurchaseRequestingDepartment(user, header, body)
  if (resolved) return resolved
  return loadUserDepartmentCodeFromBc(user)
}

function purchaseHeaderODataEntity(header: ODataRecord, no: string) {
  const documentType = fieldText(header, ['Document_Type', 'DocumentType'], 'Quote')
  const documentNo = fieldText(header, ['No', 'Document_No'], no)
  if (documentType && documentNo) {
    return `QyPurchaseHeader(Document_Type='${odataString(documentType)}',No='${odataString(documentNo)}')`
  }
  return `QyPurchaseHeader('${odataString(documentNo || no)}')`
}

function purchaseHeaderDepartmentPatchBody(department: string) {
  return {
    Requesting_Department: department,
    Requesting_Department_Code: department,
    RequestingDepartment: department,
    RequestingDepartmentCode: department,
    Shortcut_Dimension_2_Code: department,
    ShortcutDimension2Code: department,
    Global_Dimension_1_Code: department,
    GlobalDimension1Code: department,
    Department_Code: department,
    DepartmentCode: department,
  }
}

async function patchPurchaseHeaderDepartment(
  header: ODataRecord,
  no: string,
  department: string,
) {
  try {
    await patchOData(purchaseHeaderODataEntity(header, no), purchaseHeaderDepartmentPatchBody(department))
  } catch {
    // Some tenants block OData PATCH on QyPurchaseHeader; SOAP header edit remains the primary path.
  }
}

function purchaseDepartmentMissingError() {
  return Object.assign(
    new Error(
      'Requesting Department is missing on this purchase requisition. The portal could not find a short department code (20 characters or less) on the employee card or purchase header. Ask HR to set it in Business Central, log out and back in, then create a new requisition.',
    ),
    { status: 422, code: 'BC_PURCHASE_DEPARTMENT_REQUIRED' },
  )
}

function userResponsibilityCenter(user: AuthUser, body: Record<string, unknown>) {
  return firstBcCodeValue(
    body.responsibilityCenter,
    body.responsibleCenter,
    user.responsibleCenter,
  )
}

function purchaseDepartmentAliases(department: string) {
  if (!department) return {}
  return {
    department,
    departmentCode: department,
    DepartmentCode: department,
    Department_Code: department,
    requestingDepartment: department,
    RequestingDepartment: department,
    requesting_Department: department,
    Requesting_Department: department,
    requestingDepartmentCode: department,
    RequestingDepartmentCode: department,
    requesting_Department_Code: department,
    Requesting_Department_Code: department,
    shortcutDimension2Code: department,
    ShortcutDimension2Code: department,
    shortcut_Dimension_2_Code: department,
    Shortcut_Dimension_2_Code: department,
    globalDimension1Code: department,
    GlobalDimension1Code: department,
    global_Dimension_1_Code: department,
    Global_Dimension_1_Code: department,
    globalDimension2Code: department,
    GlobalDimension2Code: department,
    global_Dimension_2_Code: department,
    Global_Dimension_2_Code: department,
  }
}

function purchaseHeaderDepartmentCode(header: ODataRecord | null | undefined) {
  if (!header) return ''
  return firstBcCodeValue(
    fieldText(header, [
      'Requesting_Department_Code',
      'RequestingDepartmentCode',
      'Requesting_Department',
      'RequestingDepartment',
    ]),
    fieldText(header, [
      'Shortcut_Dimension_2_Code',
      'ShortcutDimension2Code',
      'Global_Dimension_1_Code',
      'GlobalDimension1Code',
      'Department_Code',
      'DepartmentCode',
      'Department',
      'District_Department_Code',
      'DistrictDepartmentCode',
    ]),
    fieldText(header, [
      'Department_Name',
      'DepartmentName',
      'District_Department_Name',
      'DistrictDepartmentName',
    ]),
  )
}

function purchaseHeaderDescription(header: ODataRecord | null | undefined, body: Record<string, unknown>) {
  return fieldText(
    header ?? {},
    ['Posting_Description', 'PostingDescription', 'Description', 'Reason'],
    String(body.description ?? body.postingDescription ?? body.reason ?? ''),
  )
}

function purchaseHeaderOrderDate(header: ODataRecord | null | undefined, body: Record<string, unknown>) {
  return fieldText(
    header ?? {},
    ['Needed_By_Date', 'OrderDate', 'Order_Date', 'DocumentDate', 'Document_Date'],
    String(body.dateNeeded ?? body.orderDate ?? body.requestDate ?? ''),
  )
}

function purchaseHeaderResponsibilityCenter(
  header: ODataRecord | null | undefined,
  body: Record<string, unknown>,
  user: AuthUser,
) {
  return firstBcCodeValue(
    fieldText(header ?? {}, ['ResponsibilityCenter', 'Responsibility_Center']),
    userResponsibilityCenter(user, body),
  )
}

function purchaseBodyWithDepartment(
  user: AuthUser,
  body: Record<string, unknown>,
  header?: ODataRecord | null,
) {
  const department = resolvePurchaseRequestingDepartment(user, header, body)
  return department ? { ...body, ...purchaseDepartmentAliases(department) } : body
}

function transportRequestTypeCode(value: unknown) {
  return numericCode(value, { city: 0, 'field trip': 1, field: 1 })
}

export function hospitalCategoryCode(value: unknown) {
  return numericCode(value, {
    government: 1,
    govt: 1,
    private: 2,
    'non govt': 2,
    'non-govt': 2,
    'non government': 2,
    'non-government': 2,
    nongovt: 2,
    online: 3,
    outline: 3,
  })
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
      dateRequired: req.body?.dateRequired ?? req.body?.startDate ?? '',
      purpose: req.body?.purpose ?? '',
      myUserId: user.userID,
      travelDestination: req.body?.travelDestination ?? req.body?.placeOfDuty ?? '',
      travelDate: req.body?.travelDate ?? req.body?.startDate ?? '',
      returnDate: req.body?.returnDate ?? '',
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
    saveHeader: ({ req, user, no }) => ({
      action: no ? 'edit' : 'create',
      reqNo: no,
      staffNo: user.employeeNo,
      claimDescription:
        req.body?.purpose ?? req.body?.claimDescription ?? req.body?.description ?? '',
      claimDate: req.body?.claimDate ?? '',
      myUserID: user.userID,
    }),
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
    }),
    saveLine: ({ req, no }) => ({
      action: req.body?.action ?? 'create',
      reqNo: no,
      lineNo: Number(req.body?.lineNo ?? 0),
      type: storeLineTypeCode(req.body?.type),
      itemNo: req.body?.item ?? req.body?.itemNo ?? req.body?.itemCode ?? '',
      quantity:
        storeLineTypeCode(req.body?.type) === 1
          ? Number(req.body?.quantity ?? 0)
          : 0,
      location: req.body?.issuingStore ?? req.body?.location ?? '',
    }),
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
  soap: {
    saveHeader: 'PurchaseRequisitionHeader',
    saveLine: 'PurchaseRequisitionLine',
    deleteLine: 'DeletePurchaseReqLine',
    submit: 'RequestPurchaseReqApproval',
    cancel: 'CancelPurchaseRequisition',
  },
  params: {
    saveHeader: ({ req, user, no }) => {
      const department = userDepartmentCode(user, req.body)
      return {
        action: no ? 'edit' : 'create',
        reqNo: no,
        postingDescription:
          req.body?.description ??
          req.body?.postingDescription ??
          req.body?.reason ??
          '',
        pricesIncludingVAT: false,
        myUserId: user.userID,
        ...purchaseDepartmentAliases(department),
        responsibilityCenter: userResponsibilityCenter(user, req.body),
        orderDate:
          req.body?.dateNeeded ?? req.body?.orderDate ?? req.body?.requestDate ?? '',
      }
    },
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
      tableID: 38,
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
  return [...new Set([spec.ownerField, 'Requester_ID', 'EmployeeNo', 'Employee_No', 'PreparedBy'])]
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

async function fetchFuelMaintenanceRows(spec: ModuleSpec, user: AuthUser) {
  const fetched = await fetchOData(spec.headerService, {})
  let rows = Array.isArray(fetched) ? fetched : []
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
  headerService: 'QyFuelMaintenanceRequests',
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
    submit: 'TrainingApproval',
    cancel: 'TrainingApproval',
  },
  params: {
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
    saveHeader: ({ req, user, no }) => ({
      myAction: no ? 'edit' : 'create',
      recId: no ? String(req.body?.recId ?? '') : '',
      staffNo: user.employeeNo,
      purpose: req.body?.purpose ?? req.body?.reason ?? '',
      percentageSalary: Number(req.body?.percentageSalary ?? 0),
    }),
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
    submit: 'RequestGatePassApproval',
    cancel: 'CancelGatePassApproval',
  },
  params: {
    submit: ({ req, user, no }) => ({
      gatePassNo: no,
      transferNo: req.body?.transferNo ?? '',
      tableID: 50296,
      employeeNo: user.employeeNo,
    }),
    cancel: ({ req, user, no }) => ({
      gatePassNo: no,
      transferNo: req.body?.transferNo ?? '',
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
        const params = await spec.params!.cancel!({ req, user, no })
        const result = await callSoapMethod(spec.soap.cancel!, params)
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
      push(gatePassDocumentNo(document))
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
    const gatePassNo = gatePassDocumentNo(document)
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

async function fetchGatePassRowsForSource(
  serviceName: string,
  source: GatePassSourceKey,
  user: AuthUser,
) {
  const sourceSpec = GATE_PASS_SOURCE_SPECS[source]
  const rows: ODataRecord[] = []
  const sourceFields = ['Linkto', 'Link_to', 'LinkTo', 'Link_To', 'Link']
  for (const sourceField of sourceFields) {
    const fetched = await fetchOData(serviceName, {
      $filter: `${sourceField} eq '${odataString(sourceSpec.linkTo)}'`,
    }).catch(() => [] as ODataRecord[])
    if (Array.isArray(fetched)) rows.push(...fetched)
  }
  if (rows.length === 0) {
    const fetched = await fetchOData(serviceName, {}).catch(() => [] as ODataRecord[])
    if (Array.isArray(fetched)) rows.push(...fetched)
  }
  return rows.filter((row) => gatePassRowMatchesSource(row, source, user))
}

async function listGatePassRows(
  spec: ModuleSpec,
  user: AuthUser,
  source: GatePassSourceKey,
) {
  const services = [
    spec.headerService,
    ...gatePassODataPageServiceNames(),
  ].filter((item, index, items) => items.indexOf(item) === index)
  const rows: ODataRecord[] = []
  for (const serviceName of services) {
    rows.push(...(await fetchGatePassRowsForSource(serviceName, source, user)))
  }
  return mergeRecentGatePassRows(rows, source, user)
}

async function getGatePassDocument(
  spec: ModuleSpec,
  no: string,
) {
  const services = [
    spec.headerService,
    ...gatePassODataPageServiceNames(),
  ].filter((item, index, items) => items.indexOf(item) === index)
  const keys = ['GatePassNo', 'Gate_Pass_No', 'Gate_Pass_No_', 'GatePassNumber', 'No']
  for (const serviceName of services) {
    for (const key of keys) {
      const rows = (await fetchOData(serviceName, {
        $filter: `${key} eq '${odataString(no)}'`,
        $top: 1,
      }).catch(() => null)) as ODataRecord[] | null
      if (Array.isArray(rows) && rows.length > 0) return mergeRecentGatePassRow(rows[0]!)
    }
  }
  return recentGatePassRow(no)
}

export async function listPortalModuleRows(
  spec: ModuleSpec,
  user: AuthUser,
  options: { gatePassSource?: GatePassSourceKey } = {},
) {
  if (FUEL_MAINTENANCE_MODULES.has(spec.module)) {
    return fetchFuelMaintenanceRows(spec, user)
  }
  if (spec.module === 'gate-pass') {
    return listGatePassRows(spec, user, options.gatePassSource ?? 'storeIssue')
  }
  const filterParts =
    spec.unscopedList
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
    return getGatePassDocument(spec, no)
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

export async function createPortalModuleRequest(
  spec: ModuleSpec,
  user: AuthUser,
  body: Record<string, unknown>,
) {
  if (spec.module === 'gate-pass') {
    const no = await createGatePassViaBusinessCentral(spec, user, body)
    if (body.submit === true && spec.soap.submit && spec.params?.submit) {
      const createdDoc = (await getPortalModuleDocument(spec, user, no, false)) ?? {}
      const sourceLabel = GATE_PASS_SOURCE_SPECS[gatePassSourceFromRow(createdDoc)]?.linkTo ?? ''
      const transferNo = await assertGatePassSourceReady({
        ...createdDoc,
        TransferNo: resolveGatePassTransferNo(createdDoc, body),
        Transfer_No: resolveGatePassTransferNo(createdDoc, body),
      })
      const submitParams = await spec.params.submit({
        req: requestWithBody({ transferNo }),
        user,
        no,
      })
      const submitResult = await callSoapMethod(spec.soap.submit, submitParams).catch((error) => {
        if (isGatePassApprovalRecordFault(error)) {
          throw gatePassApprovalSetupError(no, transferNo, sourceLabel)
        }
        throw error
      })
      if (!soapActionOk(spec, submitResult)) {
        throw Object.assign(
          new Error(`Business Central created ${no}, but approval submission failed`),
          { status: 502, documentNo: no },
        )
      }
    }
    return no
  }

  if (!spec.soap.saveHeader || !spec.params?.saveHeader) {
    throw Object.assign(new Error(`${spec.module} creation is not supported by Business Central`), {
      status: 501,
    })
  }

  let headerBody =
    spec.module === 'fuel'
      ? { ...body, requestType: fuelTypeCode(body.requestType ?? 'Vehicle fuel') }
      : spec.module === 'maintenance'
        ? { ...body, requestType: maintenanceTypeCode(body.requestType) }
        : spec.module === 'purchase-requisition'
          ? purchaseBodyWithDepartment(user, body, null)
          : body
  if (spec.module === 'purchase-requisition') {
    const department = await resolvePurchaseRequestingDepartmentForSave(user, null, headerBody)
    if (!department) throw purchaseDepartmentMissingError()
    headerBody = { ...headerBody, ...purchaseDepartmentAliases(department) }
  }
  const headerRequest = requestWithBody(headerBody)
  const headerKey = spec.headerKey ?? 'No'
  const existingNumbers = spec.headerReturnsBoolean
    ? new Set(
        (await listPortalModuleRows(spec, user)).map((row) =>
          fieldText(row, [headerKey, 'No', 'RequisitionNo', 'Transport_Requisition_No']),
        ),
      )
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
    for (let attempt = 0; attempt < 4 && !no; attempt += 1) {
      if (attempt > 0) await new Promise((resolve) => setTimeout(resolve, 250))
      const rows = await listPortalModuleRows(spec, user)
      const created = rows.find((row) => {
        const candidate = fieldText(row, [headerKey, 'No', 'RequisitionNo', 'Transport_Requisition_No'])
        return candidate && !existingNumbers?.has(candidate)
      })
      no = created
        ? fieldText(created, [headerKey, 'No', 'RequisitionNo', 'Transport_Requisition_No'])
        : ''
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
      const lineBody = await ensurePurchaseRequisitionDepartmentBeforeLine(spec, user, no, line)
      const lineParams = await spec.params.saveLine({
        req: requestWithBody(lineBody),
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
  const document =
    spec.module === 'gate-pass' ? await getPortalModuleDocument(spec, user, no, false) : null
  const transferNo =
    spec.module === 'gate-pass' && document
      ? resolveGatePassTransferNo(document)
      : ''
  if (spec.module === 'gate-pass' && !transferNo) {
    throw Object.assign(
      new Error('This gate pass has no linked source document number in Business Central.'),
      { status: 422 },
    )
  }
  const params = await spec.params.cancel({
    req: requestWithBody({
      transferNo,
    }),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.cancel, params)
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
  if (spec.module === 'salary-advance') {
    const lines = await listPortalModuleLines(spec, header, no)
    const percentage = Number(
      header.PercentageofSalary ??
        header.PercentageOfSalary ??
        lines[0]?.PercentageofSalary ??
        lines[0]?.PercentageOfSalary ??
        0,
    )
    const purpose = fieldText(header, ['Purpose', 'purpose'])
    if (!purpose.trim()) {
      throw Object.assign(new Error('Enter the salary advance purpose before requesting approval.'), {
        status: 422,
      })
    }
    if (!Array.isArray(lines) || lines.length === 0 || percentage <= 0) {
      throw Object.assign(
        new Error('Save the salary advance with a valid percentage before requesting approval.'),
        { status: 422 },
      )
    }
  }
  if (spec.module === 'claim') {
    const lines = await listPortalModuleLines(spec, header, no)
    if (!Array.isArray(lines) || lines.length === 0) {
      throw Object.assign(new Error('Add at least one claim line before requesting approval.'), {
        status: 422,
      })
    }
  }
  let gatePassTransfer = ''
  let gatePassSourceLabel = ''
  if (spec.module === 'gate-pass') {
    gatePassSourceLabel = GATE_PASS_SOURCE_SPECS[gatePassSourceFromRow(header)]?.linkTo ?? ''
    gatePassTransfer = await assertGatePassSourceReady(header)
  }
  const params = await spec.params.submit({
    req: requestWithBody({
      transferNo: gatePassTransfer,
    }),
    user,
    no,
  })
  const result = await callSoapMethod(spec.soap.submit, params).catch((error) => {
    if (spec.module === 'gate-pass' && isGatePassApprovalRecordFault(error)) {
      throw gatePassApprovalSetupError(no, gatePassTransfer, gatePassSourceLabel)
    }
    throw error
  })
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

async function ensurePurchaseRequisitionDepartmentBeforeLine(
  spec: ModuleSpec,
  user: AuthUser,
  no: string,
  body: Record<string, unknown>,
) {
  if (spec.module !== 'purchase-requisition' || !spec.soap.saveHeader || !spec.params?.saveHeader) {
    return body
  }

  const header = await getPortalModuleDocument(spec, user, no, false)
  let department = resolvePurchaseRequestingDepartment(user, header, body)
  if (!department) department = await loadUserDepartmentCodeFromBc(user)
  if (!department) throw purchaseDepartmentMissingError()

  const lineBody = { ...body, ...purchaseDepartmentAliases(department) }
  const headerBody = purchaseBodyWithDepartment(
    user,
    {
      description: purchaseHeaderDescription(header, body),
      postingDescription: purchaseHeaderDescription(header, body),
      orderDate: purchaseHeaderOrderDate(header, body),
      requestDate: purchaseHeaderOrderDate(header, body),
      responsibilityCenter: purchaseHeaderResponsibilityCenter(header, body, user),
    },
    header,
  )
  const headerParams = await spec.params.saveHeader({
    req: requestWithBody(headerBody),
    user,
    no,
  })
  const headerResult = await callSoapMethod(spec.soap.saveHeader, headerParams)
  if (!ok(headerResult)) {
    throw Object.assign(new Error(`Business Central did not update ${no}`), { status: 502 })
  }
  if (header) {
    await patchPurchaseHeaderDepartment(header, no, department)
  }

  return lineBody
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
  const lineBody = await ensurePurchaseRequisitionDepartmentBeforeLine(spec, user, no, body)
  const params = await spec.params.saveLine({ req: requestWithBody(lineBody), user, no })
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
    'Gate_Pass_No_',
    'GatePassNumber',
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
