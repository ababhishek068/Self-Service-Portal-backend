import { BadgeCheck, Banknote, Landmark, UserCheck, UserCog } from 'lucide-react'
import type { LocalPurchaseState } from '@/api/endpoints/requestEndpoint'
import type { TrackerStep } from '@/components/shared/ProcessTracker'
import type { PortalRequest } from '@/types/erp.types'
import { approvalStepsSummary } from '@/utils/requestStatus'

/**
 * Where a document is in its process flow, for the process banner. `index` is the 0-based step the
 * document is at; `index === steps.length` means every step is done. `caption` is BC's own word for
 * the stage (Issue Stage, Flow Stage), shown under the current step.
 */
export type ProcessStage = {
  index: number
  state: 'active' | 'rejected' | 'cancelled'
  caption?: string
}

function text(value: unknown) {
  return String(value ?? '').trim()
}

function key(value: unknown) {
  return text(value).toUpperCase().replace(/_x0020_/gi, ' ').replace(/[_\s]+/g, ' ')
}

/** Draft / Pending Approval / Rejected / Cancelled on the request, before the store or LPR steps. */
function approvalStage(request: PortalRequest, approvalIndex: number): ProcessStage | null {
  const status = request.status.trim().toLowerCase()
  if (status.includes('reject')) return { index: approvalIndex, state: 'rejected', caption: 'Rejected' }
  if (status.includes('cancel')) return { index: 0, state: 'cancelled', caption: 'Cancelled' }
  if (status.includes('pending')) {
    return { index: approvalIndex, state: 'active', caption: approvalStepsSummary(request.approvalSteps ?? []) || request.status }
  }
  if (['approved', 'released', 'posted'].includes(status)) return null
  return { index: 0, state: 'active', caption: status && status !== 'open' ? request.status : 'Draft' }
}

function storeReceiptConfirmed(requestNo: string) {
  try {
    return window.localStorage.getItem(`ssp.storeReceipt.${requestNo}`) === 'received'
  } catch {
    return false
  }
}

/**
 * Store Requisition steps (storeRequisitionProcess): 0 Requisition, 1 Review & Approval,
 * 2 Store Keeper, 3 Store Manager, 4 Accept the Item, 5 Confirm Receipt. After approval the BC Issue
 * Stage moves it on, read the same way as StoreOperationsPanel (the browser receipt flag included).
 */
export function storeRequisitionStage(request: PortalRequest): ProcessStage {
  const early = approvalStage(request, 1)
  if (early) return early
  const raw = key(request.payload?.IssueStage ?? request.payload?.Issue_Stage)
  if (raw.includes('LPR REQUESTED') || raw === '5') return { index: 3, state: 'active', caption: 'LPR requested' }
  if (raw.includes('LPR STARTED') || raw === '6') return { index: 3, state: 'active', caption: 'Local purchase running' }
  if (raw.includes('PREPARED') || raw === '1') return { index: 3, state: 'active', caption: 'Prepared by store' }
  if (raw.includes('ACCEPTED') || raw === '2') return { index: 4, state: 'active', caption: 'Item offered to you' }
  if (raw.includes('RECEIVED') || raw === '4') return { index: 6, state: 'active', caption: 'Received' }
  const lines = request.payload?.lines
  const issued = Array.isArray(lines) && lines.some((line) => Number((line as { quantityIssued?: unknown }).quantityIssued ?? 0) > 0)
  const transit = raw.includes('TRANSIT') || raw === '3'
  const legacyIssued = !transit && (issued || request.status.trim().toLowerCase() === 'posted')
  if ((transit || legacyIssued) && storeReceiptConfirmed(request.requestNo)) {
    return { index: 6, state: 'active', caption: 'Received' }
  }
  if (transit || issued) return { index: 5, state: 'active', caption: 'In transit' }
  return { index: 2, state: 'active', caption: 'With the store keeper' }
}

/** PO Flow Stages from the GRN on (BC RECEIVED_PO_STAGES without LPR Closed): the invoice and payment phase. */
const INVOICE_PO_STAGES = new Set([
  'GOODS RECEIVED',
  'PENDING OPS INVOICE',
  'PENDING OPERATIONS MANAGER INVOICE',
  'INVOICE CREATED',
  'PENDING INVOICE CHECK',
  'INVOICE VERIFIED',
  'INVOICE RETURNED',
  'INVOICE RETURNED TO PROCUREMENT',
  'PENDING CEO PAYMENT',
  'PENDING F&A PAYMENT APPROVAL',
  'PAYMENT APPROVED',
])

/** RFQ Flow Stages of the evaluation and supplier selection phase. */
const EVALUATION_RFQ_STAGES = new Set([
  'WINNER SELECTED',
  'PENDING OPS EVALUATION',
  'PENDING OPERATIONS MANAGER EVALUATION',
  'PENDING TECHNICAL',
  'PENDING FAD FINAL',
])

/**
 * Local Purchase steps (purchaseRequisitionProcess): 0 LPR & Approval, 1 RFQ & Quotations,
 * 2 Evaluation & Supplier Selection, 3 Purchase Order, 4 GRN & Issue, 5 Invoice & Payment. Read from
 * the furthest document in the BC chain (PO, else RFQ, else LPR); without the chain (Local Purchase
 * not live, or an older LPR) from the request status.
 */
export function localPurchaseStage(request: PortalRequest, state?: LocalPurchaseState | null): ProcessStage {
  const lpr = state?.chain.lpr
  const rfq = state?.chain.rfq
  const po = state?.chain.po
  const lprStatus = key(lpr?.lprStatus)
  if (lprStatus === 'CLOSED' || key(po?.flowStage) === 'LPR CLOSED') {
    return { index: 6, state: 'active', caption: 'LPR closed' }
  }
  if (po) {
    const stage = key(po.flowStage)
    const caption = text(po.flowStage) || undefined
    if (stage.includes('REJECT')) return { index: 3, state: 'rejected', caption }
    if (stage === 'PO RELEASED') return { index: 4, state: 'active', caption }
    if (INVOICE_PO_STAGES.has(stage)) return { index: 5, state: 'active', caption }
    return { index: 3, state: 'active', caption }
  }
  if (rfq) {
    const stage = key(rfq.flowStage)
    const caption = text(rfq.flowStage) || undefined
    if (stage.includes('REJECT')) return { index: 1, state: 'rejected', caption }
    if (stage === 'READY FOR PO') return { index: 3, state: 'active', caption }
    if (EVALUATION_RFQ_STAGES.has(stage)) return { index: 2, state: 'active', caption }
    return { index: 1, state: 'active', caption }
  }
  if (lpr) {
    const caption = text(lpr.lprStatus) || undefined
    if (lprStatus.includes('REJECT')) return { index: 0, state: 'rejected', caption }
    if (lprStatus.includes('CANCEL')) return { index: 0, state: 'cancelled', caption }
    if (lprStatus === 'APPROVED' || text(lpr.createdRfqNo)) return { index: 1, state: 'active', caption: 'Approved, RFQ next' }
    return { index: 0, state: 'active', caption }
  }
  return approvalStage(request, 0) ?? { index: 1, state: 'active', caption: 'Approved, RFQ next' }
}

/**
 * The stage of a flow whose steps each carry their own state (e.g. the overtime approval chain):
 * stopped at the first rejected step, else at the first step not done, else every step done.
 */
export function stageFromSteps(steps: Array<{ state: 'done' | 'rejected' | 'open'; caption?: string }>): ProcessStage {
  const stopped = steps.findIndex((step) => step.state === 'rejected')
  if (stopped >= 0) return { index: stopped, state: 'rejected', caption: steps[stopped].caption }
  const at = steps.findIndex((step) => step.state !== 'done')
  if (at < 0) return { index: steps.length, state: 'active' }
  return { index: at, state: 'active', caption: steps[at].caption }
}

/**
 * Medical Claim after HR → Finance (BC 1.0.3.648): Finance creates the payment voucher, FAD then the
 * Finance Manager approve it, and the Finance Manager posts and pays it. Posting closes the claim
 * (Posted) and the Self / Dependants medical balance drops.
 */
/** BC 1.0.3.648: a Medical Claim goes to HR, then Finance (PR Medical Setup), shown before BC has the entries. */
export const MEDICAL_CLAIM_APPROVERS: TrackerStep[] = [
  { key: 'hr', heading: 'HR', owner: 'Verifies the claim', icon: UserCog },
  { key: 'finance', heading: 'Finance', owner: 'Approves the claim', icon: Banknote },
]

export const MEDICAL_CLAIM_AFTER_APPROVAL: { steps: TrackerStep[]; caption: string } = {
  caption: 'Payment voucher with Finance',
  steps: [
    { key: 'payment-voucher', heading: 'Payment Voucher', owner: 'FAD → Finance Manager', icon: Banknote },
    { key: 'paid', heading: 'Paid', owner: 'Medical balance updated', icon: BadgeCheck },
  ],
}

/**
 * ESSP Staff Salary Advance (ABH form section 5 and the infographic's process flow): the Line Manager
 * recommends, the HR Manager verifies eligibility, the Chief Financial Officer approves. Shown until BC has
 * the approval entries of the Staff Advance workflow.
 */
export const SALARY_ADVANCE_APPROVERS: TrackerStep[] = [
  { key: 'line-manager', heading: 'Line Manager', owner: 'Recommends', icon: UserCheck },
  { key: 'hr-manager', heading: 'HR Manager', owner: 'Verifies eligibility', icon: UserCog },
  { key: 'cfo', heading: 'Chief Financial Officer', owner: 'Approves / rejects', icon: Landmark },
]

/** After approval: Finance pays the advance and sets up the monthly payroll deduction. */
export const SALARY_ADVANCE_AFTER_APPROVAL: { steps: TrackerStep[]; caption: string } = {
  caption: 'Payment and payroll deduction with Finance',
  steps: [{ key: 'finance', heading: 'Finance', owner: 'Payment & payroll deduction', icon: Banknote }],
}

/** A Staff Claim document that is a Medical Claim (BC Is Medical Claim, or its medical purpose / type). */
export function isMedicalClaimDocument(request: { requestType?: string; title?: string; payload?: Record<string, unknown> }) {
  if (request.requestType && request.requestType !== 'staffClaim') return false
  const payload = request.payload ?? {}
  const flag = payload.IsMedicalClaim ?? payload.Is_Medical_Claim
  if (flag === true || String(flag ?? '').toLowerCase() === 'true') return true
  const purpose = String(request.title || payload.Purpose || payload.ClaimDescription || '')
  if (/medical/i.test(purpose)) return true
  return /^medical$/i.test(String(payload.ClaimType ?? payload.claimType ?? payload.Claim_Type ?? '').trim())
}
