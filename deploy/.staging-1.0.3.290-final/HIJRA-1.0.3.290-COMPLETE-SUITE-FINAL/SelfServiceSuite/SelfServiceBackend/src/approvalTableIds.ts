import { fetchOData, odataString, type ODataRecord } from './bcClient.js'

/**
 * Canonical Business Central approval table IDs (ESS model `tableDesc()` values).
 * Some UAT companies still emit legacy page IDs on `QyApprovalEntry`; filters accept both.
 */
export const APPROVAL_TABLE_IDS = {
  leave: 50532,
  imprest: 50891,
  imprestSurrender: 50884,
  staffClaim: 50885,
  pettyCash: 50887,
  pettyCashReplenishment: 50883,
  storeRequisition: 50575,
  purchaseRequisition: 52121800,
  purchaseOrder: 38,
  fuel: 50865,
  transferOrder: 5740,
  gatePass: 50296,
  assetTransfer: 50278,
  transport: 50863,
  workTicket: 50866,
  salaryAdvance: 50880,
  paymentVoucher: 50000,
} as const

export type ApprovalTableKey = keyof typeof APPROVAL_TABLE_IDS

/** Portal modules that have full request/approval workflows (matches `frontendModules` in portalApi). */
export const SUPPORTED_FRONTEND_MODULES = [
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
  'pettyCashReplenishment',
  'storeRequisition',
  'purchaseRequisition',
  'fuelRequest',
  'transport',
  'maintenance',
  'transferOrder',
  'workTickets',
  'training',
  'salaryAdvance',
  'gatePass',
  'assetTransfer',
  'leave',
] as const

export type SupportedFrontendModule = (typeof SUPPORTED_FRONTEND_MODULES)[number]

export function isSupportedFrontendModule(value: string): value is SupportedFrontendModule {
  return SUPPORTED_FRONTEND_MODULES.includes(value as SupportedFrontendModule)
}

/** Sync module guess from approval entry metadata (used as fallback after ESS OData probes). */
export function approvalModuleFromEntry(row: ODataRecord): SupportedFrontendModule {
  const tableId = Number(row.TableID ?? row.TableId ?? 0)
  const documentType = entryText(row, ['DocumentType', 'Document_Type'])
  if (tableId === APPROVAL_TABLE_IDS.fuel && /maintenance|service/i.test(documentType)) {
    return 'maintenance'
  }
  const resolved = resolveApprovalModuleFromTableId(tableId, documentType)
  if (resolved && isSupportedFrontendModule(resolved)) return resolved
  return 'purchaseRequisition'
}

/**
 * Fuel and maintenance use the same BC table (50865).  Approval Entry often
 * exposes only that table ID, so the source header is the authoritative module
 * discriminator.
 */
/** Portal maintenance requests stamp Description / IssueDescription with Item + Priority. */
export function portalMaintenancePurposeStamp(value: unknown) {
  const text = String(value ?? '')
  return (
    /\|\s*Item:/i.test(text) &&
    /\|\s*Priority:/i.test(text) &&
    /\|\s*Location:/i.test(text)
  )
}

export function fuelMaintenanceModuleFromSourceRow(
  row: ODataRecord,
): 'fuelRequest' | 'maintenance' | null {
  const sourceType = entryText(row, [
    'Type',
    'Type_Field',
    'DocumentType',
    'Document_Type',
  ]).toLowerCase()
  // BC table 50865 exposes Type as "Maintenance" or as the option ordinal 1.
  if (sourceType === 'maintenance' || sourceType === '1') return 'maintenance'
  if (/maintenance|service/.test(sourceType)) return 'maintenance'

  const requestType = entryText(row, ['RequestType', 'Request_Type', 'MaintenanceType'])
  const numericRequestType = Number(requestType)
  if (requestType !== '' && Number.isFinite(numericRequestType)) {
    if (numericRequestType === 1 || numericRequestType === 2) return 'maintenance'
    if (numericRequestType === 0 || numericRequestType === 3) return 'fuelRequest'
  }

  const purposeText = entryText(row, [
    'IssueDescription',
    'MaintenanceDescription',
    'Description',
    'Purpose',
  ])
  if (portalMaintenancePurposeStamp(purposeText)) return 'maintenance'

  if (
    entryText(row, ['FixedAssetNo', 'Fixed_Asset_No']) ||
    (entryText(row, ['Item']) && entryText(row, ['Priority']))
  ) {
    return 'maintenance'
  }

  if (sourceType === 'fuel' || sourceType === '16') return 'fuelRequest'
  const requisitionType = entryText(row, ['RequisitionType', 'Requisition_Type']).toLowerCase()
  if (/fuel|card/.test(requisitionType)) return 'fuelRequest'
  return null
}

function normalizedDocumentNo(value: unknown) {
  return String(value ?? '').trim().toUpperCase()
}

function fuelMaintenanceDocumentNo(row: ODataRecord) {
  return entryText(row, ['RequisitionNo', 'Requisition_No', 'DocumentNo', 'Document_No', 'No'])
}

async function fetchFuelMaintenanceSourceRows(service: string, documentNos: string[]) {
  const wanted = new Set(documentNos.map(normalizedDocumentNo).filter(Boolean))
  if (!wanted.size) return [] as ODataRecord[]

  const numbers = [...wanted]
  const collected: ODataRecord[] = []
  let filteredLookupFailed = false
  for (let offset = 0; offset < numbers.length; offset += 10) {
    const chunk = numbers.slice(offset, offset + 10)
    const filter = chunk
      .map((no) => `RequisitionNo eq '${odataString(no)}'`)
      .join(' or ')
    try {
      const rows = (await fetchOData(service, { $filter: `(${filter})`, $top: 1000 })) as
        | ODataRecord[]
        | null
      if (Array.isArray(rows)) collected.push(...rows)
    } catch {
      // Older HIJRA query publications reject filters on this shared service.
      filteredLookupFailed = true
      break
    }
  }

  const rows = filteredLookupFailed
    ? (((await fetchOData(service, { $top: 5000 }).catch(() => [])) as ODataRecord[] | null) ?? [])
    : collected
  return rows.filter((row) => wanted.has(normalizedDocumentNo(fuelMaintenanceDocumentNo(row))))
}

/** Resolve shared table-50865 documents in one BC read per source service. */
export async function resolveFuelMaintenanceModules(documentNos: string[]) {
  const unique = [...new Set(documentNos.map(normalizedDocumentNo).filter(Boolean))]
  const [headers, extras] = await Promise.all([
    fetchFuelMaintenanceSourceRows('QyFuelMaintenanceRequests', unique),
    fetchFuelMaintenanceSourceRows('QyPortalFuelMaintExtra', unique),
  ])
  const headerByNo = new Map(headers.map((row) => [normalizedDocumentNo(fuelMaintenanceDocumentNo(row)), row]))
  const extraByNo = new Map(extras.map((row) => [normalizedDocumentNo(fuelMaintenanceDocumentNo(row)), row]))
  const resolved = new Map<string, 'fuelRequest' | 'maintenance'>()
  for (const no of unique) {
    const source = { ...(headerByNo.get(no) ?? {}), ...(extraByNo.get(no) ?? {}) }
    const module = fuelMaintenanceModuleFromSourceRow(source)
    if (module) resolved.set(no, module)
  }
  return resolved
}

/** Legacy IDs observed on `QyApprovalEntry` in older ESS builds. */
export const LEGACY_APPROVAL_TABLE_IDS: Partial<Record<ApprovalTableKey, number>> = {
  imprest: 52202786,
  imprestSurrender: 52202707,
  storeRequisition: 52202966,
  staffClaim: 52202717,
  transport: 61801,
}

export function approvalTableIdsFor(key: ApprovalTableKey): number[] {
  const canonical = APPROVAL_TABLE_IDS[key]
  const legacy = LEGACY_APPROVAL_TABLE_IDS[key]
  return legacy && legacy !== canonical ? [canonical, legacy] : [canonical]
}

/** OData `$filter` fragment matching any known table ID for a module. */
export function approvalTableFilter(key: ApprovalTableKey): string {
  const ids = approvalTableIdsFor(key)
  if (ids.length === 1) return `TableID eq ${ids[0]}`
  return `(${ids.map((id) => `TableID eq ${id}`).join(' or ')})`
}

export function resolveApprovalModuleFromTableId(
  tableId: number,
  documentType = '',
): string | null {
  const doc = documentType.toLowerCase()
  if (tableId === APPROVAL_TABLE_IDS.leave) return 'leave'
  if (approvalTableIdsFor('imprest').includes(tableId)) return 'imprest'
  if (approvalTableIdsFor('imprestSurrender').includes(tableId)) return 'imprestSurrender'
  if (approvalTableIdsFor('storeRequisition').includes(tableId)) return 'storeRequisition'
  if (
    tableId === APPROVAL_TABLE_IDS.purchaseRequisition ||
    tableId === APPROVAL_TABLE_IDS.purchaseOrder
  ) {
    return 'purchaseRequisition'
  }
  if (approvalTableIdsFor('staffClaim').includes(tableId)) return 'staffClaim'
  if (tableId === APPROVAL_TABLE_IDS.pettyCash || doc.includes('petty cash')) return 'pettyCash'
  if (tableId === APPROVAL_TABLE_IDS.pettyCashReplenishment) return 'pettyCashReplenishment'
  if (tableId === APPROVAL_TABLE_IDS.salaryAdvance) return 'salaryAdvance'
  if (tableId === APPROVAL_TABLE_IDS.gatePass) return 'gatePass'
  if (tableId === APPROVAL_TABLE_IDS.assetTransfer) return 'assetTransfer'
  if (approvalTableIdsFor('transport').includes(tableId)) return 'transport'
  if (tableId === APPROVAL_TABLE_IDS.transferOrder) return 'transferOrder'
  if (tableId === APPROVAL_TABLE_IDS.workTicket) return 'workTickets'
  if (tableId === APPROVAL_TABLE_IDS.fuel) return 'fuelRequest'
  if (doc.includes('imprest surrender')) return 'imprestSurrender'
  if (doc.includes('imprest')) return 'imprest'
  if (doc.includes('staff claim') || doc === 'claim') return 'staffClaim'
  if (doc.includes('inter bank') || doc.includes('replenishment')) return 'pettyCashReplenishment'
  if (doc.includes('salary advance')) return 'salaryAdvance'
  if (doc.includes('gate pass')) return 'gatePass'
  if (doc.includes('asset transfer')) return 'assetTransfer'
  if (doc.includes('transfer order')) return 'transferOrder'
  if (doc.includes('work ticket') || doc.includes('flight booking')) return 'workTickets'
  if (doc.includes('fuel')) return 'fuelRequest'
  if (doc.includes('training')) return 'training'
  if (doc.includes('transport')) return 'transport'
  if (doc.includes('store requisition')) return 'storeRequisition'
  if (doc.includes('petty') || doc.includes('payment voucher') || doc === 'payment') return 'pettyCash'
  if (doc.includes('purchase') || doc === 'order') return 'purchaseRequisition'
  return null
}

function entryText(row: ODataRecord, keys: string[]) {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return String(value).trim()
  }
  return ''
}

function purchaseHeaderLooksLikeRequisition(row: ODataRecord) {
  const approvalType = entryText(row, ['DocApprovalType', 'Doc_Approval_Type']).toLowerCase()
  if (approvalType.includes('requisition')) return true
  const documentType = entryText(row, ['DocumentType', 'Document_Type']).toLowerCase()
  return documentType === 'quote' || documentType.includes('requisition')
}

function documentCreatedAt(row: ODataRecord) {
  const raw = entryText(row, [
    'SystemCreatedAt',
    'System_Created_At',
    'CreatedDateTime',
    'Created_Date_Time',
  ])
  if (!raw || raw.startsWith('0001-01-01')) return null
  const timestamp = Date.parse(raw)
  return Number.isFinite(timestamp) ? timestamp : null
}

/**
 * Table 38 approval entries can belong to either a Purchase Requisition or a
 * legacy store document. Never prefer store just because a same-numbered store
 * header exists — that made live PRs open with Issuing Store / store fields.
 */
export async function resolvePurchaseOrderTableModule(
  docNo: string,
  preferred?: 'storeRequisition' | 'purchaseRequisition',
): Promise<'storeRequisition' | 'purchaseRequisition' | null> {
  const [storeRows, purchaseRows] = (await Promise.all([
    fetchOData('QyStoreRequisitionHeader', {
      $filter: `No eq '${odataString(docNo)}'`,
      $top: 1,
    }).catch(() => [] as ODataRecord[]),
    fetchOData('QyPurchaseHeader', {
      $filter: `No eq '${odataString(docNo)}'`,
      $top: 1,
    }).catch(() => [] as ODataRecord[]),
  ])) as [ODataRecord[] | null, ODataRecord[] | null]

  const store = Array.isArray(storeRows) && storeRows[0] ? storeRows[0] : null
  const purchase = Array.isArray(purchaseRows) && purchaseRows[0] ? purchaseRows[0] : null

  if (preferred === 'purchaseRequisition' && purchase) return 'purchaseRequisition'
  if (preferred === 'storeRequisition' && store && !purchase) return 'storeRequisition'

  // HIJRA reuses numbers across Store and Purchase Quote after series resets.
  // When both headers exist, prefer Purchase unless the store document is clearly
  // newer and the caller explicitly asked for store.
  if (purchase && store) {
    const purchaseCreated = documentCreatedAt(purchase)
    const storeCreated = documentCreatedAt(store)
    if (
      preferred === 'storeRequisition' &&
      storeCreated !== null &&
      (purchaseCreated === null || storeCreated > purchaseCreated)
    ) {
      return 'storeRequisition'
    }
    return 'purchaseRequisition'
  }

  if (purchase) return 'purchaseRequisition'
  if (store) return 'storeRequisition'
  return null
}

/**
 * Payments Header (50887) and Inter-Bank (50883) numbers collide with other series.
 * Probe the source document so Petty Cash is not labelled Purchase Requisition.
 *
 * BC Option "Payment Type" = Normal, "Petty Cash", Cash, ... (0/1/2). OData may
 * return the caption or the ordinal — treat any Payments Header hit as petty cash
 * settlement unless it is clearly a Normal payment voucher.
 */
export async function resolvePettyCashModuleFromSource(
  docNo: string,
): Promise<'pettyCash' | 'pettyCashReplenishment' | null> {
  const no = String(docNo ?? '').trim()
  if (!no) return null

  const [paymentRows, interBankRows] = (await Promise.all([
    fetchOData('QyPaymentsHeader', {
      $filter: `No eq '${odataString(no)}'`,
      $top: 1,
    }).catch(() => [] as ODataRecord[]),
    fetchOData('PgInterBankTransfers', {
      $filter: `No eq '${odataString(no)}'`,
      $top: 1,
    }).catch(() => [] as ODataRecord[]),
  ])) as [ODataRecord[] | null, ODataRecord[] | null]

  const payment = Array.isArray(paymentRows) && paymentRows[0] ? paymentRows[0] : null
  if (payment) {
    const paymentType = entryText(payment, ['PaymentType', 'Payment_Type']).toLowerCase()
    const documentType = entryText(payment, ['DocumentType', 'Document_Type']).toLowerCase()
    const isNormalVoucher = paymentType === '0' || paymentType === 'normal'
    const isPetty =
      !paymentType ||
      paymentType === '1' ||
      paymentType.includes('petty') ||
      documentType.includes('petty') ||
      paymentType === 'cash' ||
      paymentType === '2'
    if (isPetty || !isNormalVoucher) return 'pettyCash'
  }

  if (Array.isArray(interBankRows) && interBankRows[0]) return 'pettyCashReplenishment'
  return null
}

/**
 * Resolve the portal module from an approval entry the same way ESS
 * `ApprovalsController::viewDocument` picks OData services.
 *
 * `preferredModule` comes from the request id (e.g. purchaseRequisition-1540)
 * so a PR link is not flipped onto store fields when numbers collide.
 */
export async function resolveApprovalModuleFromEntry(
  entry: ODataRecord,
  docNo: string,
  fallback: (row: ODataRecord) => string,
  preferredModule?: string,
): Promise<string> {
  const tableId = Number(entry.TableID ?? entry.TableId ?? 0)
  // The source table is authoritative. Some older Approval Entry publications
  // expose TransportRequest as the generic document type Order, which must not
  // route a live TR document through the Purchase Requisition source service.
  if (approvalTableIdsFor('transport').includes(tableId)) return 'transport'

  // Honour the request-id module before table-id shortcuts — PR links must not
  // flip to Store when BC stamped TableID 50575 on a Purchase Quote approval.
  if (preferredModule === 'purchaseRequisition') {
    const petty = await resolvePettyCashModuleFromSource(docNo)
    if (petty) return petty
    const purchaseOrStore = await resolvePurchaseOrderTableModule(docNo, 'purchaseRequisition')
    if (purchaseOrStore === 'purchaseRequisition') return 'purchaseRequisition'
    return 'purchaseRequisition'
  }
  if (preferredModule === 'storeRequisition') {
    const resolved = await resolvePurchaseOrderTableModule(docNo, 'storeRequisition')
    if (resolved) return resolved
    return 'storeRequisition'
  }
  if (preferredModule === 'pettyCash' || preferredModule === 'pettyCashReplenishment') {
    return preferredModule
  }

  if (approvalTableIdsFor('storeRequisition').includes(tableId)) {
    const resolved = await resolvePurchaseOrderTableModule(docNo)
    if (resolved === 'purchaseRequisition') return 'purchaseRequisition'
    return 'storeRequisition'
  }

  const documentType = entryText(entry, ['DocumentType', 'Document_Type'])
  if (documentType === 'TransportRequest') return 'transport'
  if (documentType === 'Petty Cash' || /petty\s*cash/i.test(documentType)) return 'pettyCash'
  if (/inter\s*bank|replenishment/i.test(documentType)) return 'pettyCashReplenishment'
  if (/store\s*requisition/i.test(documentType)) return 'storeRequisition'

  const looksLikeMislabelledPurchase =
    tableId === APPROVAL_TABLE_IDS.purchaseRequisition ||
    tableId === APPROVAL_TABLE_IDS.purchaseOrder ||
    tableId === APPROVAL_TABLE_IDS.pettyCash ||
    tableId === APPROVAL_TABLE_IDS.pettyCashReplenishment ||
    tableId === 0 ||
    /payment|petty|voucher/i.test(documentType) ||
    /purchase\s*requisition/i.test(documentType) ||
    documentType === 'Order' ||
    documentType === 'Quote'

  if (looksLikeMislabelledPurchase) {
    const petty = await resolvePettyCashModuleFromSource(docNo)
    if (petty) return petty
  }

  if (tableId === APPROVAL_TABLE_IDS.purchaseRequisition) return 'purchaseRequisition'
  if (/purchase\s*requisition/i.test(documentType)) return 'purchaseRequisition'

  if (tableId === APPROVAL_TABLE_IDS.fuel) {
    const resolved = await resolveFuelMaintenanceModules([docNo])
    const sourceModule = resolved.get(normalizedDocumentNo(docNo))
    if (sourceModule) return sourceModule
  }

  const needsPurchaseStoreProbe =
    tableId === APPROVAL_TABLE_IDS.purchaseOrder ||
    documentType === 'Order' ||
    documentType === 'Quote'

  if (needsPurchaseStoreProbe) {
    const resolved = await resolvePurchaseOrderTableModule(docNo)
    if (resolved) return resolved
    if (documentType === 'Order' || documentType === 'Quote') return 'purchaseRequisition'
  }

  if (tableId === APPROVAL_TABLE_IDS.pettyCash) return 'pettyCash'
  if (tableId === APPROVAL_TABLE_IDS.pettyCashReplenishment) return 'pettyCashReplenishment'

  return fallback(entry)
}
