import { MessageSquareText } from 'lucide-react'
import { formatDateTime } from '@/utils/formatters'
import { compareApprovalSteps } from '@/utils/requestStatus'
import type { ApprovalStep } from '@/types/erp.types'

/** Approval comments that the next steps must see (BC Approval Comments), in approval order. */
function approverComments(steps: ApprovalStep[] | undefined, { skipRejected = false } = {}) {
  return [...(steps ?? [])]
    .filter((step) => step.note?.trim() && !(skipRejected && /reject|declin/i.test(String(step.status ?? ''))))
    .sort(compareApprovalSteps)
}

/**
 * The approvers' comments at the top of a request (e.g. "Only 2 is Enough"), so everyone who
 * handles it next — the next approver, Store Keeper, Store Manager, Procurement — sees them. A
 * request sent back and sent again also shows the send back and what the requester corrected.
 */
export function ApproverComments({ steps, skipRejected = false }: { steps: ApprovalStep[] | undefined; skipRejected?: boolean }) {
  const comments = approverComments(steps, { skipRejected })
  if (!comments.length) return null
  return (
    <section className="rounded-lg border border-amber-200 bg-amber-50/70 p-4">
      <p className="flex items-center gap-1.5 text-sm font-semibold text-amber-900">
        <MessageSquareText className="h-4 w-4" />
        Approver comments
      </p>
      <ul className="mt-2 space-y-2.5">
        {comments.map((step) => (
          <li key={step.id}>
            <p className="whitespace-pre-wrap text-sm text-slate-900">{step.note}</p>
            {step.changes?.length ? (
              <ul className="mt-0.5 list-disc space-y-0.5 pl-5 text-sm text-slate-900">
                {step.changes.map((change) => (
                  <li key={change}>{change}</li>
                ))}
              </ul>
            ) : null}
            <p className="mt-0.5 text-xs text-slate-500">
              {step.actorName || step.actorEmployeeNo || 'Approver'}
              {step.sequenceNo ? ` · Step ${step.sequenceNo}` : ''} · {step.status}
              {step.timestamp ? ` · ${formatDateTime(step.timestamp)}` : ''}
            </p>
          </li>
        ))}
      </ul>
    </section>
  )
}
