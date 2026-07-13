/** BC "Pending"/"Open" (pre-submission) and application DB "Draft" are editable in ESS. */
export function isEditableRequestStatus(status: string | undefined) {
  return status === 'Draft' || status === 'Open'
}

/** Submitted documents awaiting checker action — cancel only, no line/header edits. */
export function isPendingApprovalStatus(status: string | undefined) {
  return status === 'Pending Approval'
}

/** ESS show blades only include approvers after approval has been requested. */
export function shouldShowApprovalHistory(status: string | undefined) {
  return (
    status === 'Pending Approval' ||
    status === 'Approved' ||
    status === 'Rejected'
  )
}

/** Lines and attachments can be deleted only before approval submission. */
export function canDeleteRequestItems(status: string | undefined) {
  return isEditableRequestStatus(status)
}

/** Upload attachments only while the header is still editable (Draft/Open). Locked after approval submission. */
export function canUploadRequestAttachments(status: string | undefined) {
  return isEditableRequestStatus(status)
}

/** Portal modules whose BC document types accept UploadDocumentAttachment (see staffModules). */
export const PORTAL_ATTACHMENT_MODULES = new Set([
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
  'pettyCashReplenishment',
])

function bcDocumentStatus(
  payload: Record<string, unknown> | undefined,
  module?: string,
) {
  if (!payload) return ''
  if (module === 'transferOrder') {
    return String(
      payload.ApprovalStatus ?? payload.Approval_Status ?? payload.Status ?? '',
    ).trim()
  }
  return String(payload.Status ?? payload.DocumentStatus ?? payload.ApprovalStatus ?? '').trim()
}

const PENDING_BC_STATUS_MODULES = new Set([
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
  'pettyCashReplenishment',
  'salaryAdvance',
])

const OPEN_BC_STATUS_MODULES = new Set([
  'storeRequisition',
  'purchaseRequisition',
  'transport',
  'training',
  'fuelRequest',
  'maintenance',
  'gatePass',
  'leave',
])

function hasGatePassSourceNumber(payload: Record<string, unknown> | undefined) {
  if (!payload) return false
  return [
    'sourceDocumentNo',
    'SourceDocumentNo',
    'Source_Document_No',
    'TransferNo',
    'Transfer_No',
    'Transfer_No_',
    'AssetTransferNo',
    'Asset_Transfer_No',
    'StoreIssueNo',
    'Store_Issue_No',
    'RequisitionNo',
    'RequistionNo',
    'DocumentNo',
  ].some((key) => String(payload[key] ?? '').trim() !== '')
}

/** Matches ESS action-header blades: Request Approval only in the BC pre-submission status. */
export function canRequestApproval(
  module: string | undefined,
  payload: Record<string, unknown> | undefined,
) {
  const status = bcDocumentStatus(payload, module)
  if (!status || !module) return false
  if (module === 'gatePass' && !hasGatePassSourceNumber(payload)) return false
  if (module === 'transferOrder') return status === 'Open'
  if (PENDING_BC_STATUS_MODULES.has(module)) return status === 'Pending'
  if (OPEN_BC_STATUS_MODULES.has(module)) return status === 'Open'
  return false
}
