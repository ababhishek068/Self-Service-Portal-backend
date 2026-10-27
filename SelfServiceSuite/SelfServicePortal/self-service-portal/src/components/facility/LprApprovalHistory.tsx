import { Badge } from '@/components/ui/badge'
import { formatDateTime } from '@/utils/formatters'

const ACTION_TONE: Record<string, 'green' | 'red' | 'orange' | 'blue' | 'gray'> = {
  Approved: 'green',
  Done: 'green',
  'Sent Back': 'orange',
  Rejected: 'red',
  Cancelled: 'red',
  Submitted: 'blue',
  Resubmitted: 'blue',
}

function text(value: unknown) {
  return String(value ?? '').trim()
}

/**
 * BC 1.0.3.576 Approval History of the LPR chain (ABH LPR Approval Log): every submit, approve,
 * send back and reject on the LPR, RFQ, PO and invoice, with who, when and the comment.
 */
export function LprApprovalHistory({ entries }: { entries: Array<Record<string, unknown>> | undefined }) {
  const rows = entries ?? []
  if (!rows.length) return null
  return (
    <div className="space-y-1.5 pt-1">
      <p className="text-[11px] font-semibold uppercase tracking-wide text-slate-500">Approval History</p>
      <div className="overflow-x-auto rounded-lg border border-slate-200">
        <table className="min-w-full text-left text-sm">
          <thead className="bg-slate-50 text-xs text-slate-600">
            <tr>
              <th className="whitespace-nowrap px-3 py-2 font-medium">Date</th>
              <th className="whitespace-nowrap px-3 py-2 font-medium">Document</th>
              <th className="px-3 py-2 font-medium">Step</th>
              <th className="px-3 py-2 font-medium">Action</th>
              <th className="whitespace-nowrap px-3 py-2 font-medium">By</th>
              <th className="px-3 py-2 font-medium">Comment</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row, index) => {
              const action = text(row.action)
              return (
                <tr key={`${text(row.actionAt)}-${index}`} className="border-t border-slate-100 align-top">
                  <td className="whitespace-nowrap px-3 py-2 text-slate-600">{formatDateTime(text(row.actionAt))}</td>
                  <td className="whitespace-nowrap px-3 py-2">
                    {[text(row.document), text(row.documentNo)].filter(Boolean).join(' ')}
                  </td>
                  <td className="px-3 py-2">{text(row.step)}</td>
                  <td className="px-3 py-2">
                    <Badge variant={ACTION_TONE[action] ?? 'gray'}>{action}</Badge>
                  </td>
                  <td className="whitespace-nowrap px-3 py-2">{text(row.userId)}</td>
                  <td className="min-w-[14rem] whitespace-pre-wrap px-3 py-2 text-slate-900">{text(row.comment)}</td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </div>
  )
}
