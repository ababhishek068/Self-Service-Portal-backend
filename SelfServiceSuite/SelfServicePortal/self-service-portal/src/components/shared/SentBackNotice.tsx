import { CornerUpLeft, RotateCcw } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { formatDateTime } from '@/utils/formatters'
import type { SentBackInfo } from '@/utils/requestStatus'

/**
 * A request an approver sent back for correction: their comment, and the next step for the
 * requester — reopen it (when BC still holds it as pending), correct it, then Request Approval.
 */
export function SentBackNotice({
  sentBack,
  busy,
  onReopen,
}: {
  sentBack: SentBackInfo
  busy?: boolean
  onReopen?: () => void
}) {
  const approver = sentBack.by || 'The approver'
  return (
    <section className="rounded-lg border border-orange-200 bg-orange-50 p-4 text-sm text-orange-950">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="min-w-0">
          <p className="flex items-center gap-1.5 font-semibold">
            <CornerUpLeft className="h-4 w-4" />
            Sent back for correction
          </p>
          <p className="mt-1 whitespace-pre-wrap text-slate-900">
            {sentBack.comment || 'No comment was recorded in Business Central.'}
          </p>
          <p className="mt-0.5 text-xs text-slate-600">
            {approver}
            {sentBack.sequenceNo ? ` · Step ${sentBack.sequenceNo}` : ''}
            {sentBack.at ? ` · ${formatDateTime(sentBack.at)}` : ''}
          </p>
          <p className="mt-2 text-xs text-orange-900">
            {sentBack.reopenRequired
              ? 'Press Reopen to Correct, make the changes, then press Request Approval.'
              : 'Make the changes, then press Request Approval.'}{' '}
            The approvals already given are kept and the request goes back to {approver}.
          </p>
        </div>
        {sentBack.reopenRequired && onReopen ? (
          <Button type="button" variant="gradient" disabled={busy} onClick={onReopen}>
            <RotateCcw className="h-4 w-4" />
            Reopen to Correct
          </Button>
        ) : null}
      </div>
    </section>
  )
}
