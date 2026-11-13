import { useQuery } from '@tanstack/react-query'
import { getLocalPurchaseState } from '@/api/endpoints/requestEndpoint'
import { HistorySection } from '@/components/shared/HistorySection'
import { Badge } from '@/components/ui/badge'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import { formatDateTime } from '@/utils/formatters'
import type { PortalRequest } from '@/types/erp.types'

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
 *
 * Shown as the standard Approval and Comment History at the bottom of the LPR page, closed until
 * View more (it used to sit under the ribbon and push the RFQ / PO cards down the page). It reads
 * the same Local Purchase state as the panel, so it costs no extra request.
 */
export function LprApprovalHistorySection({ request }: { request: PortalRequest }) {
  const access = useLocalPurchaseAccess()
  const stateQuery = useQuery({
    queryKey: ['local-purchase', request.id],
    queryFn: () => getLocalPurchaseState(request.id),
    enabled: access.enabled,
    retry: false,
  })
  const rows = stateQuery.data?.chain.approvalHistory ?? []
  if (!access.enabled || !rows.length) return null
  const latest = rows[rows.length - 1]
  const summary = [text(latest.step), text(latest.userId)].filter(Boolean).join(' · ')
  return (
    <HistorySection count={rows.length} summary={summary ? `Latest: ${summary}` : undefined}>
      <LprApprovalHistoryTable rows={rows} />
    </HistorySection>
  )
}

function LprApprovalHistoryTable({ rows }: { rows: Array<Record<string, unknown>> }) {
  return (
    <div>
      <div className="overflow-x-auto rounded-lg border border-slate-200 bg-white">
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
