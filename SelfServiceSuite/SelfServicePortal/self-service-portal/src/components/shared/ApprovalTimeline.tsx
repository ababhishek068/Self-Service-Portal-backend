import { CheckCircle2, Circle, CircleDashed, RefreshCw } from 'lucide-react'
import { StatusBadge } from './StatusBadge'
import { cn } from '@/lib/utils'
import { formatDateTime } from '@/utils/formatters'
import { compareApprovalSteps } from '@/utils/requestStatus'
import type { ApprovalStep } from '@/types/erp.types'

export function ApprovalTimeline({ steps }: { steps: ApprovalStep[] }) {
  const ordered = [...steps].sort(compareApprovalSteps)

  return (
    <ol className="space-y-4">
      {ordered.map((step, index) => {
        const isResubmitted = step.status === 'Resubmitted'
        const isDone = ['Approved', 'Submitted'].includes(step.status)
        const isCurrent = step.status === 'Pending Approval'
        const Icon = isResubmitted ? RefreshCw : isDone ? CheckCircle2 : isCurrent ? CircleDashed : Circle
        const sequence = step.sequenceNo ?? index + 1
        return (
          <li key={step.id} className="flex gap-3">
            <div className="flex flex-col items-center">
              <Icon
                className={cn(
                  'h-5 w-5',
                  isResubmitted ? 'text-sky-600' : isDone ? 'text-emerald-600' : isCurrent ? 'text-amber-600' : 'text-slate-300',
                )}
              />
              {index < ordered.length - 1 ? <span className="mt-2 h-full w-px bg-slate-200" /> : null}
            </div>
            <div className="min-w-0 flex-1 pb-3">
              <div className="flex flex-wrap items-center gap-2">
                <span className="rounded-full bg-slate-100 px-2 py-0.5 text-[11px] font-semibold uppercase tracking-wide text-slate-600">
                  {isResubmitted ? 'Requester' : `Step ${sequence}`}
                </span>
                <p className="font-medium text-slate-900">{step.actorName}</p>
                <StatusBadge status={step.status} />
              </div>
              <p className="mt-1 text-sm text-slate-500">
                {step.role} · {formatDateTime(step.timestamp)}
              </p>
              {step.note ? <p className="mt-2 rounded-md bg-slate-50 p-2 text-sm text-slate-700">{step.note}</p> : null}
              {step.changes?.length ? (
                <ul className="mt-1.5 list-disc space-y-0.5 pl-5 text-sm text-slate-700">
                  {step.changes.map((change) => (
                    <li key={change}>{change}</li>
                  ))}
                </ul>
              ) : null}
            </div>
          </li>
        )
      })}
    </ol>
  )
}
