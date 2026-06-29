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
  transport: 61801,
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
  'training',
  'salaryAdvance',
  'gatePass',
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

/** Legacy IDs observed on `QyApprovalEntry` in older ESS builds. */
export const LEGACY_APPROVAL_TABLE_IDS: Partial<Record<ApprovalTableKey, number>> = {
  imprest: 52202786,
  imprestSurrender: 52202707,
  storeRequisition: 52202966,
  staffClaim: 52202717,
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
  if (tableId === APPROVAL_TABLE_IDS.transport) return 'transport'
  if (tableId === APPROVAL_TABLE_IDS.transferOrder) return 'transferOrder'
  if (tableId === APPROVAL_TABLE_IDS.fuel) return 'fuelRequest'
  if (doc.includes('imprest surrender')) return 'imprestSurrender'
  if (doc.includes('imprest')) return 'imprest'
  if (doc.includes('staff claim') || doc === 'claim') return 'staffClaim'
  if (doc.includes('inter bank') || doc.includes('replenishment')) return 'pettyCashReplenishment'
  if (doc.includes('salary advance')) return 'salaryAdvance'
  if (doc.includes('gate pass')) return 'gatePass'
  if (doc.includes('transfer order')) return 'transferOrder'
  if (doc.includes('fuel')) return 'fuelRequest'
  if (doc.includes('training')) return 'training'
  if (doc.includes('transport')) return 'transport'
  if (doc.includes('store requisition')) return 'storeRequisition'
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

/** ESS `ApprovalsController::viewDocument` store-vs-purchase check on table 38 headers. */
function isEssStoreRequisitionHeader(row: ODataRecord) {
  return (
    entryText(row, ['DocApprovalType', 'Doc_Approval_Type']) === 'Requisition' &&
    entryText(row, ['DocumentType', 'Document_Type']) === 'Quote' &&
    entryText(row, ['DocumentType2', 'Document_Type2']) === 'Requisition'
  )
}

async function resolvePurchaseOrderTableModule(
  docNo: string,
): Promise<'storeRequisition' | 'purchaseRequisition' | null> {
  const purchaseRows = (await fetchOData('QyPurchaseHeader', {
    $filter: `No eq '${odataString(docNo)}'`,
    $top: 1,
  })) as ODataRecord[] | null
  if (Array.isArray(purchaseRows) && purchaseRows[0]) {
    return isEssStoreRequisitionHeader(purchaseRows[0]) ? 'storeRequisition' : 'purchaseRequisition'
  }
  const storeRows = (await fetchOData('QyStoreRequisitionHeader', {
    $filter: `No eq '${odataString(docNo)}'`,
    $top: 1,
  })) as ODataRecord[] | null
  if (Array.isArray(storeRows) && storeRows[0]) return 'storeRequisition'
  return null
}

/**
 * Resolve the portal module from an approval entry the same way ESS
 * `ApprovalsController::viewDocument` picks OData services.
 */
export async function resolveApprovalModuleFromEntry(
  entry: ODataRecord,
  docNo: string,
  fallback: (row: ODataRecord) => string,
): Promise<string> {
  const documentType = entryText(entry, ['DocumentType', 'Document_Type'])
  if (documentType === 'TransportRequest') return 'transport'
  if (documentType === 'Petty Cash') return 'pettyCash'
  if (documentType === 'Order') return 'purchaseRequisition'

  const tableId = Number(entry.TableID ?? entry.TableId ?? 0)
  if (tableId === APPROVAL_TABLE_IDS.purchaseOrder) {
    const resolved = await resolvePurchaseOrderTableModule(docNo)
    if (resolved) return resolved
  }

  return fallback(entry)
}
