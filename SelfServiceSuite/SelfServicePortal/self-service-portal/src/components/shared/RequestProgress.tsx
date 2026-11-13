import { BadgeCheck, Banknote, FileCheck2, HeartPulse, ListPlus, Send, ShieldCheck, UserCheck, Users, type LucideIcon } from 'lucide-react'
import { ProcessTracker, type TrackerStep } from '@/components/shared/ProcessTracker'
import type { ProcessStage } from '@/data/processStages'
import type { ApprovalStep, PortalModuleKey } from '@/types/erp.types'
import { compareApprovalSteps } from '@/utils/requestStatus'
import { formatDate } from '@/utils/formatters'

interface RequestProgressProps {
  status: string
  hasLines?: boolean
  requiresLines?: boolean
  module?: PortalModuleKey
  lines?: Record<string, unknown>[]
  payload?: Record<string, unknown>
  approvalSteps?: ApprovalStep[]
  className?: string
}

/** One approver (or group of approvers at the same BC sequence) in the latest approval round. */
type ApproverGroup = {
  key: string
  role: ApprovalStep['role']
  names: string[]
  status: string
  timestamp: string
  note?: string
}

const ROLE_HEADING: Partial<Record<ApprovalStep['role'], string>> = {
  Finance: 'Finance',
  HR: 'HR',
  Facility: 'Facility',
}

const ROLE_ICON: Partial<Record<ApprovalStep['role'], LucideIcon>> = {
  Finance: Banknote,
  HR: HeartPulse,
  Facility: ShieldCheck,
}

/**
 * The approvers of the latest round (a request sent back and sent again starts a new round), in BC
 * sequence. Approvers BC put at the same sequence (a user group) are one step; the maker's own
 * Submitted / Resubmitted entries are not approvals.
 */
function approverGroups(steps: ApprovalStep[]): ApproverGroup[] {
  const ordered = [...steps].sort(compareApprovalSteps)
  const lastRound = ordered.reduce((round, step) => Math.max(round, step.round ?? 0), 0)
  const approvers = ordered.filter(
    (step) =>
      (step.round ?? 0) === lastRound && step.role !== 'Maker' && step.status !== 'Submitted' && step.status !== 'Resubmitted',
  )
  const groups: ApproverGroup[] = []
  for (const step of approvers) {
    const name = step.actorName || step.actorEmployeeNo
    const previous = groups[groups.length - 1]
    if (previous && step.sequenceNo !== undefined && previous.key === `seq-${step.sequenceNo}`) {
      if (name && !previous.names.includes(name)) previous.names.push(name)
      // Any approver of the group decides for it.
      if (['Approved', 'Rejected', 'Pending Approval'].includes(step.status)) {
        previous.status = step.status
        previous.timestamp = step.timestamp
        previous.note = step.note
      }
      continue
    }
    groups.push({
      key: step.sequenceNo !== undefined ? `seq-${step.sequenceNo}` : `step-${step.id}`,
      role: step.role,
      names: name ? [name] : [],
      status: step.status,
      timestamp: step.timestamp,
      note: step.note,
    })
  }
  return groups
}

function approverOwner(group: ApproverGroup) {
  if (!group.names.length) return 'Approver'
  return group.names.length > 2 ? `${group.names[0]} +${group.names.length - 1}` : group.names.join(' / ')
}

const isApproved = (status: string) => ['approved', 'posted', 'released', 'completed', 'closed'].includes(status.trim().toLowerCase())
const isPending = (status: string) => ['pending approval', 'submitted', 'pending'].includes(status.trim().toLowerCase())

/**
 * The document's workflow from BC: Draft → Lines & attachments → each approver of the latest round →
 * Approved, and where the document is in it now.
 */
function workflow({
  status,
  hasLines = false,
  requiresLines = false,
  approvalSteps = [],
}: RequestProgressProps): { steps: TrackerStep[]; stage: ProcessStage; groups: ApproverGroup[] } {
  const normalized = status.trim().toLowerCase()
  const detailReady = !requiresLines || hasLines
  const groups = approverGroups(approvalSteps)
  const steps: TrackerStep[] = [
    { key: 'draft', heading: 'Draft created', owner: 'Saved in Business Central', icon: FileCheck2 },
    {
      key: 'details',
      heading: requiresLines ? 'Lines & attachments' : 'Review details',
      owner: detailReady ? 'Ready for approval' : 'Add at least one line',
      icon: ListPlus,
    },
  ]
  if (groups.length) {
    let approverNo = 0
    for (const group of groups) {
      const roleHeading = ROLE_HEADING[group.role]
      approverNo += roleHeading ? 0 : 1
      steps.push({
        key: group.key,
        heading: roleHeading ?? (groups.length === 1 ? 'Approval' : `Approver ${approverNo}`),
        owner: approverOwner(group),
        icon: ROLE_ICON[group.role] ?? (group.names.length > 1 ? Users : UserCheck),
      })
    }
  } else {
    steps.push({ key: 'approval', heading: 'Approval workflow', owner: 'Business Central approvers', icon: Send })
  }
  steps.push({ key: 'approved', heading: 'Approved', owner: 'Document complete', icon: BadgeCheck })

  const firstApproval = 2
  const groupIndex = (wanted: (group: ApproverGroup) => boolean) => {
    const found = groups.findIndex(wanted)
    return found >= 0 ? firstApproval + found : -1
  }
  let stage: ProcessStage
  if (isApproved(status) || (groups.length > 0 && groups.every((group) => group.status === 'Approved') && !normalized.includes('reject'))) {
    stage = { index: steps.length, state: 'active' }
  } else if (normalized.includes('reject')) {
    const at = groupIndex((group) => group.status === 'Rejected')
    stage = { index: at >= 0 ? at : firstApproval, state: 'rejected', caption: 'Rejected' }
  } else if (normalized.includes('cancel')) {
    const at = groupIndex((group) => group.status === 'Pending Approval')
    stage = { index: at >= 0 ? at : firstApproval, state: 'cancelled', caption: 'Cancelled' }
  } else if (normalized === 'returned' || normalized.includes('sent back')) {
    stage = { index: 1, state: 'active', caption: 'Sent back for correction' }
  } else if (isPending(status)) {
    const pendingAt = groupIndex((group) => group.status === 'Pending Approval')
    const openAt = groupIndex((group) => group.status !== 'Approved')
    stage = {
      index: pendingAt >= 0 ? pendingAt : openAt >= 0 ? openAt : firstApproval,
      state: 'active',
      caption: 'Pending approval',
    }
  } else {
    stage = { index: 1, state: 'active', caption: detailReady ? 'Ready · Request Approval' : 'Add a line' }
  }
  return { steps, stage, groups }
}

/**
 * Workflow progress of a document (every request page: MultiStep, single form, leave): the live
 * tracker on the dashboard hero's colours, with one step per BC approver. View details lists each
 * approver's decision and date.
 */
export function RequestProgress(props: RequestProgressProps) {
  const { steps, stage, groups } = workflow(props)
  return (
    <ProcessTracker
      className={props.className}
      title="Workflow Progress"
      steps={steps}
      stage={stage}
      details={
        groups.length ? (
          <ol className="space-y-1.5 pl-6 marker:font-semibold marker:text-slate-800">
            {groups.map((group) => (
              <li key={group.key} className="list-decimal pl-1 leading-relaxed">
                <span className="font-semibold text-slate-900">{group.names.join(' / ') || 'Approver'}</span>
                {' — '}
                {group.status === 'Waiting' ? 'Not reached yet' : group.status}
                {group.timestamp && group.status !== 'Waiting' ? ` · ${formatDate(group.timestamp)}` : ''}
                {group.note ? <span className="block text-xs text-slate-600">{group.note}</span> : null}
              </li>
            ))}
          </ol>
        ) : undefined
      }
    />
  )
}
