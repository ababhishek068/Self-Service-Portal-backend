import { StatusBadge } from './StatusBadge'
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
      {orderedSteps.map((step, index) => {
        // UAT 18/07/2026: when an approver rejects, the requester must see the reason.
        const isRejected = /reject|declin/i.test(String(step.status ?? ''))
        const note = step.note?.trim()
        return (
          <div key={step.id} className="border-b border-slate-100 py-2 text-sm">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <div className="flex min-w-0 items-center gap-2">
                <span className="inline-flex h-6 items-center justify-center rounded-full bg-slate-100 px-2 text-xs font-semibold text-slate-600">
                  {/* Show BC's workflow sequence — parallel approvers share a step number. */}
                  Step {step.sequenceNo ?? index + 1}
                </span>
                <span>{step.actorName || step.actorEmployeeNo || 'Approver'} - {step.role}</span>
              </div>
              <StatusBadge status={step.status} />
            </div>
            {note ? (
              <p
                className={
                  isRejected
                    ? 'mt-1.5 rounded-md border-l-4 border-red-500 bg-red-50 px-3 py-2 text-sm text-red-800'
                    : 'mt-1.5 text-xs text-slate-500'
                }
              >
                {isRejected ? <span className="font-semibold">Rejection reason: </span> : null}
                {note}
              </p>
            ) : null}
          </div>
        )
      })}
    </div>
  )
}
