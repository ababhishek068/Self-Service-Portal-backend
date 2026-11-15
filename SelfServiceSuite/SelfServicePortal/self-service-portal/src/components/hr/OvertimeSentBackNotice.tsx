import { CornerUpLeft } from 'lucide-react'
import { formatDateTime } from '@/utils/formatters'

/**
 * BC 1.0.3.654: an approver sent the overtime (payment) request back for correction. It is a draft again;
 * after the correction it is submitted and the Workflow User Group approves it again.
 */
export function OvertimeSentBackNotice({
  by,
  on,
  remarks,
  editLabel,
}: {
  by?: string
  on?: string
  remarks?: string
  /** The button the employee presses to correct it (e.g. "Edit and submit"). */
  editLabel: string
}) {
  const approver = by?.trim() || 'The approver'
  return (
    <section className="rounded-xl border border-orange-200 bg-orange-50 px-4 py-3 text-sm text-orange-950" role="status">
      <p className="flex items-center gap-1.5 font-semibold">
        <CornerUpLeft className="h-4 w-4" />
        Sent back for correction
      </p>
      <p className="mt-1 whitespace-pre-wrap text-slate-900">{remarks?.trim() || 'No comment was recorded.'}</p>
      <p className="mt-0.5 text-xs text-slate-600">
        {approver}
        {on ? ` · ${formatDateTime(on)}` : ''}
      </p>
      <p className="mt-2 text-xs text-orange-900">
        Press <span className="font-semibold">{editLabel}</span>, correct what is asked, then submit it again. The Workflow
        User Group approves it again.
      </p>
    </section>
  )
}
