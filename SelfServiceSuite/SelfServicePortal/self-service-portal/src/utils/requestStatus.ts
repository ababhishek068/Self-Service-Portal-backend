import type { ApprovalStep } from '@/types/erp.types'

/**
 * BC "Pending"/"Open" and application DB "Draft" are editable. Asset Transfer
 * and Training both start life at literal BC Status = "New" (see
 * HRTrainingApplications.Table.al Status OptionMembers = New,"Pending
 * Approval",Approved) — not "Open" like most other modules.
 */
export function isEditableRequestStatus(
  status: string | undefined,
  module?: string,
) {
  const normalized = String(status ?? '').trim().toLowerCase()
  return (
    normalized === 'draft' ||
    normalized === 'open' ||
    ((module === 'assetTransfer' || module === 'training') && normalized === 'new')
  )
}

/** Send Back for Correction details the backend adds to a Returned request. */
export type SentBackInfo = {
  comment: string
  by: string
  at: string
  sequenceNo?: number
  /** BC still holds the header as pending: the requester reopens it (Cancel Approval) before editing. */
  reopenRequired: boolean
}

export function sentBackInfo(
  request: { status?: string; payload?: Record<string, unknown> } | undefined,
): SentBackInfo | null {
  if (request?.status !== 'Returned') return null
  const value = request.payload?.sentBack as Partial<SentBackInfo> | undefined
  return {
    comment: String(value?.comment ?? ''),
    by: String(value?.by ?? ''),
    at: String(value?.at ?? ''),
    sequenceNo: Number(value?.sequenceNo) || undefined,
    reopenRequired: value?.reopenRequired !== false,
  }
}

/**
 * The status that decides header, line and attachment editing: a sent-back request is edited like an
 * open draft once Business Central has reopened it.
 */
export function editingStatus(request: { status?: string; payload?: Record<string, unknown> } | undefined) {
  const sentBack = sentBackInfo(request)
  return sentBack && !sentBack.reopenRequired ? 'Open' : request?.status
}

/** Submitted documents awaiting checker action — cancel only, no line/header edits. */
export function isPendingApprovalStatus(status: string | undefined) {
  return status === 'Pending Approval'
}

/**
 * ESS show blades only include approvers after approval has been requested. Once there are
 * approval entries they stay visible at every later status (released, posted, LPR…), with comments.
 */
export function shouldShowApprovalHistory(status: string | undefined, steps?: unknown[]) {
  return (
    status === 'Pending Approval' ||
    status === 'Approved' ||
    status === 'Rejected' ||
    status === 'Returned' ||
    (steps?.length ?? 0) > 0
  )
}

/**
 * The approval history to show: every round of a request that was sent back and sent again (the
 * send back, the resubmission and the new approvals), otherwise the approval steps.
 */
export function approvalHistorySteps(request: { approvalSteps?: ApprovalStep[]; approvalTrail?: ApprovalStep[] }) {
  return request.approvalTrail?.length ? request.approvalTrail : request.approvalSteps ?? []
}

/** Approval history order: by round of a request sent again, then by BC step (parallel approvers share one). */
export function compareApprovalSteps(left: ApprovalStep, right: ApprovalStep) {
  const leftSequence = left.sequenceNo ?? Number.MAX_SAFE_INTEGER
  const rightSequence = right.sequenceNo ?? Number.MAX_SAFE_INTEGER
  return (left.round ?? 0) - (right.round ?? 0) || leftSequence - rightSequence
}

/** Lines and attachments can be deleted only before approval submission. */
export function canDeleteRequestItems(status: string | undefined, module?: string) {
  return isEditableRequestStatus(status, module)
}

/** Modules that support permanent document delete via DeletePortalDraftDocument / leave delete. */
export const DOCUMENT_DELETE_MODULES = new Set([
  'leave',
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
  'pettyCashReplenishment',
  'purchaseRequisition',
  'storeRequisition',
  'fuelRequest',
  'maintenance',
  'transport',
  'transferOrder',
  'training',
  'salaryAdvance',
  'gatePass',
])

/** Whole-document delete: Draft/Open/New, plus Cancelled/Rejected cleanup. */
export function canDeleteDocumentDraft(status: string | undefined, module?: string) {
  if (module && !DOCUMENT_DELETE_MODULES.has(module) && module !== 'leave') return false
  // Store must follow the same safe lifecycle as Leave: a pending approval is
  // cancelled first, which reopens the BC header, and only that editable draft
  // can then be permanently deleted. Never offer delete on a terminal Store
  // document merely because an old approval entry says Cancelled/Rejected.
  if (module === 'storeRequisition' || module === 'leave') {
    return isEditableRequestStatus(status, module)
  }
  if (isEditableRequestStatus(status, module)) return true
  const normalized = String(status ?? '').trim().toLowerCase()
  return normalized === 'cancelled' || normalized === 'canceled' || normalized === 'rejected'
}

/** Upload attachments only while the header is still editable (Draft/Open). Locked after approval submission. */
export function canUploadRequestAttachments(status: string | undefined, module?: string) {
  return isEditableRequestStatus(status, module)
}

/** Portal modules whose BC document types accept UploadDocumentAttachment (see staffModules). */
export const PORTAL_ATTACHMENT_MODULES = new Set([
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
  'pettyCashReplenishment',
  'purchaseRequisition',
  'storeRequisition',
  'fuelRequest',
  'maintenance',
  'transport',
  'transferOrder',
  'gatePass',
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
  'assetTransfer',
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
  if (module === 'assetTransfer' || module === 'training') return status === 'New' || status === 'Open'
  if (PENDING_BC_STATUS_MODULES.has(module)) return status === 'Pending'
  if (OPEN_BC_STATUS_MODULES.has(module)) return status === 'Open'
  return false
}
