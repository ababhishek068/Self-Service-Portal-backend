import { StatusBadge } from './StatusBadge'
import { formatDateTime } from '@/utils/formatters'
import type { ApprovalStep } from '@/types/erp.types'

export function ApprovalHistory({ steps }: { steps: ApprovalStep[] }) {
  if (!steps.length) {
    return <p className="text-sm italic text-slate-500">No approval entries yet.</p>
  }

  const orderedSteps = [...steps].sort((left, right) => {
    const leftSequence = left.sequenceNo ?? Number.MAX_SAFE_INTEGER
    const rightSequence = right.sequenceNo ?? Number.MAX_SAFE_INTEGER
    return leftSequence - rightSequence
  })

  return (
    <div className="space-y-2">
      {orderedSteps.map((step, index) => (
        <div key={step.id} className="border-b border-slate-100 py-2.5 text-sm">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <div className="flex min-w-0 items-center gap-2">
              <span className="inline-flex h-6 items-center justify-center rounded-full bg-slate-100 px-2 text-xs font-semibold text-slate-600">
                {/* Show BC's workflow sequence — parallel approvers share a step number. */}
                Step {step.sequenceNo ?? index + 1}
              </span>
              <span className="font-medium text-slate-900">
                {step.actorName || step.actorEmployeeNo || 'Approver'}
              </span>
              <span className="text-slate-500">· {step.role}</span>
            </div>
            <StatusBadge status={step.status} />
          </div>
          <p className="mt-1 pl-1 text-xs text-slate-500">
            {step.timestamp ? formatDateTime(step.timestamp) : 'No decision timestamp yet'}
          </p>
          {step.note ? (
            <p className="mt-1.5 rounded-md bg-slate-50 px-2.5 py-1.5 text-xs text-slate-700">{step.note}</p>
          ) : null}
        </div>
      ))}
    </div>
  )
}
