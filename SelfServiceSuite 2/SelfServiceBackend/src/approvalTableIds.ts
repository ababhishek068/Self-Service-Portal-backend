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
  salaryAdvance: 50880,
  paymentVoucher: 50000,
} as const

export type ApprovalTableKey = keyof typeof APPROVAL_TABLE_IDS

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
