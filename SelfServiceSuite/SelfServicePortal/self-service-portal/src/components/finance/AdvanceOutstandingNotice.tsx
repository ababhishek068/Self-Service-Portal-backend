import { Link } from 'react-router-dom'
import { Ban, CalendarClock, Receipt } from 'lucide-react'
import { Button } from '@/components/ui/button'
import {
  outstandingHref,
  outstandingStageLabel,
  settleByText,
  type AdvanceOutstanding,
  type OutstandingAdvance,
} from '@/api/endpoints/advanceOutstanding'
import { cn } from '@/lib/utils'
import { formatCurrency, formatDate } from '@/utils/formatters'

function AdvanceRows({ rows }: { rows: OutstandingAdvance[] }) {
  return (
    <ul className="mt-2 divide-y divide-slate-100 overflow-hidden rounded-lg border border-slate-200 bg-white text-slate-900">
      {rows.map((row) => {
        const due = settleByText(row)
        return (
          <li key={row.advanceNo} className="flex flex-wrap items-center gap-x-3 gap-y-0.5 px-3 py-2">
            <Link to={outstandingHref(row)} className="font-semibold tabular-nums text-[var(--portal-navy-dark,#0f3b4c)] underline-offset-2 hover:underline">
              {row.advanceNo}
            </Link>
            {row.amount > 0 ? <span className="text-xs tabular-nums text-slate-600">{formatCurrency(row.amount)}</span> : null}
            <span className="text-xs text-slate-600">{outstandingStageLabel(row)}</span>
            {due ? (
              <span className={cn('ml-auto text-xs font-medium tabular-nums', row.overdue ? 'text-rose-700' : 'text-slate-600')}>{due}</span>
            ) : null}
          </li>
        )
      })}
    </ul>
  )
}

/**
 * Client rules of 17 Nov 2026 (BC 1.0.3.667) on the Advance Request and Advance Settlement pages:
 * - with the maximum (4) advances not settled, a new advance cannot be submitted — the list says which, and how far
 *   each one is, so the employee knows what to settle;
 * - otherwise, advances whose settlement is overdue (more than 7 days after the activity ended) are named.
 * Nothing is shown on older BC (no `outstanding`) or when all is in order.
 */
export function AdvanceOutstandingNotice({
  outstanding,
  showSettlementLink = true,
}: {
  outstanding: AdvanceOutstanding | null | undefined
  /** Off on the settlement page itself. */
  showSettlementLink?: boolean
}) {
  if (!outstanding) return null
  const overdue = outstanding.advances.filter((row) => row.overdue)

  if (!outstanding.canRequest) {
    return (
      <section className="adv-reveal rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-950" role="alert">
        <div className="flex items-start gap-3">
          <Ban className="mt-0.5 h-5 w-5 shrink-0 text-rose-600" aria-hidden="true" />
          <div className="min-w-0 flex-1">
            <p className="font-semibold">You cannot submit a new advance yet</p>
            <p className="mt-0.5 text-rose-900">
              {outstanding.unsettledCount} of your advances are not settled, and the limit is {outstanding.maxUnsettled}. Settle at least
              one of them and you can request again. An advance counts from submission until its settlement is posted.
            </p>
            <AdvanceRows rows={outstanding.advances} />
            {showSettlementLink ? (
              <Button asChild size="sm" className="mt-3">
                <Link to="/finance/advance-settlement">
                  <Receipt className="mr-2 h-4 w-4" />
                  Go to Advance Settlement
                </Link>
              </Button>
            ) : null}
          </div>
        </div>
      </section>
    )
  }

  if (!overdue.length) return null
  return (
    <section className="adv-reveal rounded-xl border border-amber-300 bg-amber-50 px-4 py-3 text-sm text-amber-950" role="status">
      <div className="flex items-start gap-3">
        <CalendarClock className="mt-0.5 h-5 w-5 shrink-0 text-amber-700" aria-hidden="true" />
        <div className="min-w-0 flex-1">
          <p className="font-semibold">
            {overdue.length === 1 ? 'An advance settlement is overdue' : `${overdue.length} advance settlements are overdue`}
          </p>
          <p className="mt-0.5 text-amber-900">
            Advances are settled within {outstanding.settlementDueDays} days of the activity end date. With{' '}
            {outstanding.maxUnsettled} advances not settled you cannot request a new one.
          </p>
          <AdvanceRows rows={overdue} />
        </div>
      </div>
    </section>
  )
}

/**
 * On an opened advance (BC 1.0.3.667): its settle-by date — the activity end date + 7 days — or how long its
 * settlement is overdue. Shown only while the employee has to act on it.
 */
export function AdvanceSettleByNote({
  outstanding,
  advanceNo,
}: {
  outstanding: AdvanceOutstanding | null | undefined
  advanceNo: string
}) {
  const row = outstanding?.advances.find((item) => item.advanceNo === advanceNo)
  if (!row || !row.settlementDueDate) return null
  if (row.stage === 'pendingApproval' || row.stage === 'settlementSubmitted') return null
  const days = outstanding!.settlementDueDays
  if (row.overdue) {
    return (
      <section className="flex items-start gap-3 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-950" role="alert">
        <CalendarClock className="mt-0.5 h-5 w-5 shrink-0 text-rose-600" aria-hidden="true" />
        <p className="min-w-0 flex-1">
          <span className="font-semibold">
            Settlement overdue{row.daysOverdue > 0 ? ` by ${row.daysOverdue} day${row.daysOverdue === 1 ? '' : 's'}` : ''}.
          </span>{' '}
          It was due on {formatDate(row.settlementDueDate)}, {days} days after the activity ended
          {row.activityEndDate ? ` on ${formatDate(row.activityEndDate)}` : ''}. {outstandingStageLabel(row)}.
        </p>
      </section>
    )
  }
  return (
    <section className="flex items-start gap-3 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-700">
      <CalendarClock className="mt-0.5 h-4 w-4 shrink-0 text-slate-500" aria-hidden="true" />
      <p className="min-w-0 flex-1">
        <span className="font-semibold text-slate-900">Settle by {formatDate(row.settlementDueDate)}</span>, within {days} days of the
        activity end{row.activityEndDate ? ` (${formatDate(row.activityEndDate)})` : ''}. After that you are reminded until it is settled.
      </p>
    </section>
  )
}
