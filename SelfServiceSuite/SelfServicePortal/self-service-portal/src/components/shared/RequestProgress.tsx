import { Check, ClipboardCheck, FileCheck2, FileSignature, ListPlus, PackageCheck, Send } from 'lucide-react'
import type { ApprovalStep, PortalModuleKey } from '@/types/erp.types'

interface RequestProgressProps {
  status: string
  hasLines?: boolean
  requiresLines?: boolean
  module?: PortalModuleKey
  lines?: Record<string, unknown>[]
  payload?: Record<string, unknown>
  approvalSteps?: ApprovalStep[]
}

type ProgressTone = 'complete' | 'active' | 'pending' | 'stopped'

interface ProgressStep {
  label: string
  note: string
  tone: ProgressTone
  icon: typeof FileCheck2
}

function numericTotal(lines: Record<string, unknown>[], keys: string[]) {
  return lines.reduce((total, line) => {
    for (const key of keys) {
      const value = Number(line[key] ?? Number.NaN)
      if (Number.isFinite(value)) return total + value
    }
    return total
  }, 0)
}

function booleanField(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    if (!(key in payload)) continue
    const value = payload[key]
    if (typeof value === 'boolean') return value
    return ['true', 'yes', '1'].includes(String(value ?? '').trim().toLowerCase())
  }
  return false
}

/** BC Issue Stage on the store requisition (Store Req Header Approved / Store Requisition Header UP). */
function storeIssueStage(payload: Record<string, unknown>) {
  const raw = String(payload.IssueStage ?? payload.Issue_Stage ?? '').trim().toLowerCase()
  if (raw.includes('lpr requested')) return 'LPR_REQUESTED'
  if (raw.includes('lpr started')) return 'LPR_STARTED'
  if (raw.includes('prepared')) return 'PREPARED'
  if (raw.includes('accepted')) return 'ACCEPTED'
  if (raw.includes('transit')) return 'TRANSIT'
  if (raw.includes('received')) return 'RECEIVED'
  return ''
}

function quantityLabel(value: number) {
  return value.toLocaleString(undefined, { maximumFractionDigits: 2 })
}

function storeRequisitionSteps(
  status: string,
  lines: Record<string, unknown>[],
  payload: Record<string, unknown>,
  approvalSteps: ApprovalStep[],
): ProgressStep[] {
  const normalizedStatus = status.trim().toLowerCase()
  const rejected = normalizedStatus === 'rejected' || normalizedStatus === 'cancelled'
  const approvalPending =
    normalizedStatus === 'pending approval' || normalizedStatus === 'submitted'
  const allApprovalStepsApproved =
    approvalSteps.length > 0 && approvalSteps.every((step) => step.status === 'Approved')
  const approvalDone =
    normalizedStatus === 'approved' ||
    normalizedStatus === 'posted' ||
    allApprovalStepsApproved
  const currentApprover = [...approvalSteps]
    .sort((left, right) => (left.sequenceNo ?? 9999) - (right.sequenceNo ?? 9999))
    .find((step) => step.status === 'Pending Approval' || step.status === 'Submitted')
  const requested = numericTotal(lines, ['quantityRequested', 'quantity'])
  const issued = numericTotal(lines, ['quantityIssued'])
  const received = numericTotal(lines, ['quantityReceived'])
  const fullyIssued =
    booleanField(payload, ['FullyIssued', 'Fully_Issued']) ||
    (requested > 0 && issued >= requested)
  const fullyReceived =
    booleanField(payload, ['FullyReceived', 'Fully_Received']) ||
    (issued > 0 && received >= issued)
  const lineNote =
    lines.length === 0
      ? 'Add the requested items or assets'
      : `${lines.length} line${lines.length === 1 ? '' : 's'}${
          requested > 0 ? ` • ${quantityLabel(requested)} requested` : ''
        }`
  const approvalNote = rejected
    ? status
    : approvalDone
      ? 'Approved in Business Central'
      : approvalPending
        ? `With ${currentApprover?.actorName || currentApprover?.actorEmployeeNo || 'the current approver'}`
        : 'Request approval when lines are complete'
  // Store hand-off as in BC: Store Keeper → Store Manager → requester accepts the
  // borrowing form (GIV, In Transit) → Confirm Receipt. No stock: Request for LPR → LPR.
  const stage = storeIssueStage(payload)
  const declined = /declin/i.test(String(payload.RequesterDecision ?? payload.Requester_Decision ?? '')) && !stage
  const givNo = String(payload.StoreIssueNo ?? payload.Store_Issue_No ?? '').trim()
  const itemAccepted = ['TRANSIT', 'RECEIVED'].includes(stage) || Boolean(givNo) || issued > 0
  const receiptDone = stage === 'RECEIVED' || (!stage && fullyReceived)
  const storeIssueDone = ['ACCEPTED', 'TRANSIT', 'RECEIVED'].includes(stage) || itemAccepted || fullyIssued
  const issueNote = storeIssueDone
    ? 'Store manager accepted the item'
    : stage === 'PREPARED'
      ? 'With the store manager to accept the item'
      : stage === 'LPR_REQUESTED'
        ? 'Not in stock — with the Store Manager to start the LPR'
        : stage === 'LPR_STARTED'
          ? 'Local purchase (LPR) in progress'
          : declined
            ? 'You declined — the store can offer another item'
            : approvalDone
              ? 'Store keeper: add the item to issue, or Request for LPR'
              : 'Starts after approval'
  const acceptNote = itemAccepted
    ? givNo
      ? `Accepted — GIV ${givNo}`
      : 'Item accepted — GIV created'
    : stage === 'ACCEPTED'
      ? 'Open the Item Borrowing Form, then accept or decline'
      : 'Starts after the store manager accepts'
  const receiptNote = receiptDone
    ? received > 0 || issued > 0
      ? `${quantityLabel(received || issued)} receipt confirmed`
      : 'Receipt confirmed'
    : received > 0
      ? `${quantityLabel(received)} of ${quantityLabel(issued)} received`
      : itemAccepted
        ? 'In transit — confirm receipt when you have the item'
        : 'Starts after you accept the item'

  return [
    {
      label: 'Request created',
      note: 'Header saved in Business Central',
      tone: 'complete',
      icon: FileCheck2,
    },
    {
      label: 'Items requested',
      note: lineNote,
      tone: lines.length > 0 ? 'complete' : 'active',
      icon: ListPlus,
    },
    {
      label: 'Approval',
      note: approvalNote,
      tone: rejected ? 'stopped' : approvalDone ? 'complete' : approvalPending ? 'active' : 'pending',
      icon: Send,
    },
    {
      label: 'Store issue',
      note: issueNote,
      tone: rejected
        ? 'pending'
        : storeIssueDone
          ? 'complete'
          : approvalDone
            ? 'active'
            : 'pending',
      icon: PackageCheck,
    },
    {
      label: 'Accept item',
      note: acceptNote,
      tone: rejected ? 'pending' : itemAccepted ? 'complete' : stage === 'ACCEPTED' ? 'active' : 'pending',
      icon: FileSignature,
    },
    {
      label: 'Receipt confirmation',
      note: receiptNote,
      tone: rejected
        ? 'pending'
        : receiptDone
          ? 'complete'
          : itemAccepted
            ? 'active'
            : 'pending',
      icon: ClipboardCheck,
    },
  ]
}

export function RequestProgress({
  status,
  hasLines = false,
  requiresLines = false,
  module,
  lines = [],
  payload = {},
  approvalSteps = [],
}: RequestProgressProps) {
  const approvalRequested = ['Pending Approval', 'Submitted', 'Approved', 'Rejected', 'Cancelled', 'Posted'].includes(status)
  const detailReady = !requiresLines || hasLines
  const workflowNote = approvalRequested ? status : 'Not requested yet'
  const genericSteps: ProgressStep[] = [
    { label: 'Draft created', note: 'Header saved in Business Central', tone: 'complete', icon: FileCheck2 },
    {
      label: requiresLines ? 'Lines & attachments' : 'Review details',
      note: detailReady ? 'Ready for approval' : 'Add at least one line',
      tone: detailReady ? (approvalRequested ? 'complete' : 'active') : 'pending',
      icon: ListPlus,
    },
    {
      label: 'Approval workflow',
      note: workflowNote,
      tone: ['Approved', 'Posted'].includes(status)
        ? 'complete'
        : ['Rejected', 'Cancelled'].includes(status)
          ? 'stopped'
          : ['Pending Approval', 'Submitted'].includes(status)
            ? 'active'
            : 'pending',
      icon: Send,
    },
  ]
  const steps =
    module === 'storeRequisition'
      ? storeRequisitionSteps(status, lines, payload, approvalSteps)
      : genericSteps
  const gridClass =
    steps.length === 6
      ? 'sm:grid-cols-2 lg:grid-cols-3'
      : steps.length === 5
        ? 'sm:grid-cols-2 lg:grid-cols-5'
        : 'sm:grid-cols-3'

  return (
    <div className={`grid gap-2 rounded-2xl border border-blue-100 bg-gradient-to-r from-blue-50/80 to-white p-3 ${gridClass}`}>
      {steps.map((step, index) => {
        const Icon = step.icon
        const complete = step.tone === 'complete'
        const active = step.tone === 'active'
        const stopped = step.tone === 'stopped'
        return (
          <div
            key={step.label}
            className={`relative flex min-h-20 items-center gap-3 rounded-xl border p-3 transition ${
              active
                ? 'border-blue-300 bg-white shadow-sm'
                : stopped
                  ? 'border-red-200 bg-red-50/70'
                  : 'border-transparent'
            }`}
          >
            <span className={`flex h-9 w-9 shrink-0 items-center justify-center rounded-full ${
              complete
                ? 'bg-emerald-100 text-emerald-700'
                : active
                  ? 'bg-blue-100 text-blue-700'
                  : stopped
                    ? 'bg-red-100 text-red-700'
                    : 'bg-slate-100 text-slate-400'
            }`}>
              {complete ? <Check className="h-4 w-4" /> : <Icon className="h-4 w-4" />}
            </span>
            <div className="min-w-0">
              <p className="text-sm font-semibold text-slate-900"><span className="mr-1 text-xs text-slate-400">0{index + 1}</span>{step.label}</p>
              <p className="mt-0.5 text-xs leading-4 text-slate-500">{step.note}</p>
            </div>
          </div>
        )
      })}
    </div>
  )
}

