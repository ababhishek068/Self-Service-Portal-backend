import { isSameDay, parseISO } from 'date-fns'

export const workingDate = () => new Date()

export function isErpWorkingDate(value: string) {
  return isSameDay(parseISO(value), workingDate())
}

export function buildFaTagNumber(
  departmentCode: string,
  categoryCode: string,
  itemCode: string,
  sequence: number,
  year = new Date().getFullYear(),
) {
  const seq = String(sequence).padStart(4, '0')
  return `FA/${departmentCode}/${categoryCode}/${itemCode}/${seq}/${year}`
}

export function isMakerAllowedToApprove(makerEmployeeNo: string, approverEmployeeNo: string) {
  return makerEmployeeNo !== approverEmployeeNo
}

/** BC/ESS editable document states before approval is requested. */
export function isMutableRequestStatus(status: string) {
  return ['Draft', 'Open', 'Pending'].includes(status)
}

/** Prefer mapped status, but fall back to raw BC header status when they disagree. */
export function effectiveRequestStatus(request: {
  status: string
  payload?: Record<string, unknown>
}) {
  if (isMutableRequestStatus(request.status)) return request.status
  const raw = String(
    request.payload?.Status ??
      request.payload?.DocumentStatus ??
      request.payload?.ApprovalStatus ??
      '',
  ).trim()
  if (!raw) return request.status
  const normalized = raw.toLowerCase()
  if (normalized === 'open' || normalized === 'pending') return 'Open'
  if (normalized === 'draft') return 'Draft'
  if (normalized === 'pending approval') return 'Pending Approval'
  if (normalized.includes('approve')) return 'Approved'
  if (normalized.includes('reject')) return 'Rejected'
  if (normalized.includes('cancel')) return 'Cancelled'
  return request.status
}

export function canCancelRequestStatus(status: string) {
  return ['Draft', 'Open', 'Pending', 'Pending Approval'].includes(status)
}

export function canUploadAttachmentStatus(status: string) {
  return ['Draft', 'Open', 'Pending', 'Pending Approval'].includes(status)
}

export function showsApprovalHistory(status: string) {
  return ['Pending Approval', 'Approved', 'Rejected'].includes(status)
}

/** ESS only supports document attachments on these portal modules. */
const ATTACHMENT_ENABLED_MODULES = new Set([
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
  'pettyCashReplenishment',
  'leave',
])

export function moduleSupportsAttachments(module: string) {
  return ATTACHMENT_ENABLED_MODULES.has(module)
}

export function isDuplicateWithin24Hours(existingDateIso: string, candidateDateIso: string) {
  const existing = parseISO(existingDateIso).getTime()
  const candidate = parseISO(candidateDateIso).getTime()
  return Math.abs(candidate - existing) <= 24 * 60 * 60 * 1000
}
