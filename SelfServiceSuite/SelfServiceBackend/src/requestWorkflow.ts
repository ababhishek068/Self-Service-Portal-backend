import type { ODataRecord } from './bcClient.js'

function fieldText(row: ODataRecord, keys: string[]) {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') {
      return String(value).trim()
    }
  }
  return ''
}

/** Raw BC status used by ESS action blades before request/cancel approval. */
export function bcDocumentStatus(specModule: string, row: ODataRecord) {
  if (specModule === 'transfer-order') {
    return fieldText(row, ['ApprovalStatus', 'Approval_Status', 'Status'])
  }
  return fieldText(row, ['Status', 'DocumentStatus', 'ApprovalStatus'])
}

const PENDING_STATUS_MODULES = new Set([
  'imprest',
  'imprest-surrender',
  'claim',
  'petty-cash',
  'inter-bank-transfer',
  'salary-advance',
])

const OPEN_STATUS_MODULES = new Set([
  'store-requisition',
  'purchase-requisition',
  'transport',
  'training',
  'fuel',
  'maintenance',
  'gate-pass',
])

/**
 * ESS only exposes Request Approval when the BC header is in the module's
 * pre-submission status (`Pending` for finance replenishment/imprest/etc,
 * `Open` for store/purchase/transport/training/fuel, `ApprovalStatus=Open`
 * for transfer orders).
 */
export function canRequestApprovalForSpec(specModule: string, row: ODataRecord) {
  const status = bcDocumentStatus(specModule, row)
  if (!status) return false
  if (specModule === 'transfer-order') return status === 'Open'
  if (PENDING_STATUS_MODULES.has(specModule)) return status === 'Pending'
  if (OPEN_STATUS_MODULES.has(specModule)) return status === 'Open'
  return false
}

export function requestApprovalBlockedMessage(specModule: string, row: ODataRecord) {
  const status = bcDocumentStatus(specModule, row) || 'unknown'
  if (specModule === 'transfer-order') {
    return `Transfer orders can only be sent for approval while Approval Status is Open (current: ${status}).`
  }
  if (PENDING_STATUS_MODULES.has(specModule)) {
    return `This request can only be sent for approval while Business Central status is Pending (current: ${status}).`
  }
  if (OPEN_STATUS_MODULES.has(specModule)) {
    return `This request can only be sent for approval while Business Central status is Open (current: ${status}).`
  }
  return `This request is not in a submittable status (current: ${status}).`
}
