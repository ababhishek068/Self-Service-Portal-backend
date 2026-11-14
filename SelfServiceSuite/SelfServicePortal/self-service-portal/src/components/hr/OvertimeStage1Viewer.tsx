import { useEffect } from 'react'
import { createPortal } from 'react-dom'
import { CalendarDays, CheckCircle2, Clock, Printer, X, XCircle } from 'lucide-react'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'

export interface OvertimeStage1ViewLine {
  date: string
  time: string
  category: string
  location: string
  hours: number
  reason: string
}

export interface OvertimeStage1ViewStep {
  label: string
  approver: string
  status: string
  decidedAt: string
  comment: string
}

/** Everything shown is pre-formatted by the page that opens the viewer. */
export interface OvertimeStage1View {
  requestNo: string
  status: string
  period: string
  totalHours: number
  employee: string
  designation: string
  department: string
  justification: string
  expectedDeliverables: string
  lines: OvertimeStage1ViewLine[]
  steps: OvertimeStage1ViewStep[]
}

function stepIcon(status: string) {
  if (status === 'Approved') return <CheckCircle2 className="h-4 w-4 text-emerald-600" />
  if (status === 'Rejected') return <XCircle className="h-4 w-4 text-red-600" />
  return <Clock className="h-4 w-4 text-amber-600" />
}

/**
 * The Stage 1 Overtime Request behind an Overtime Payment Request, opened over the payment form
 * (View) so the employee never leaves the form they are filling in.
 */
export function OvertimeStage1Viewer({
  view,
  loading,
  onClose,
  onPrint,
}: {
  view: OvertimeStage1View | null
  loading?: boolean
  onClose: () => void
  onPrint?: () => void
}) {
  useEffect(() => {
    const handler = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose()
    }
    window.addEventListener('keydown', handler)
    return () => window.removeEventListener('keydown', handler)
  }, [onClose])

  const showLocation = Boolean(view?.lines.some((line) => line.location))

  return createPortal(
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-2 sm:p-4">
      <button
        type="button"
        aria-label="Close the Overtime Request"
        onClick={onClose}
        className="absolute inset-0 bg-[#151722]/45 backdrop-blur-sm"
      />
      <div
        role="dialog"
        aria-modal="true"
        aria-label={view ? `Overtime Request ${view.requestNo}` : 'Overtime Request'}
        className="portal-rise-children relative mx-auto flex max-h-[92vh] w-[min(97vw,60rem)] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xl"
      >
        <div className="h-1.5 w-full shrink-0 bg-gradient-to-r from-[var(--portal-navy)] to-[var(--portal-green)]" />
        <div className="flex shrink-0 items-start justify-between gap-3 border-b border-slate-200 px-4 py-3">
          <div className="min-w-0">
            <div className="flex flex-wrap items-center gap-2">
              <p className="text-base font-semibold text-slate-900">
                Overtime Request {view?.requestNo ?? ''}
              </p>
              {view ? <StatusBadge status={view.status} /> : null}
            </div>
            <p className="text-xs text-slate-500">Stage 1 · work authorization (Business Central)</p>
          </div>
          <div className="flex shrink-0 items-center gap-1">
            {view && onPrint ? (
              <Button type="button" variant="outline" size="sm" onClick={onPrint}>
                <Printer className="mr-2 h-4 w-4" />
                Print
              </Button>
            ) : null}
            <Button type="button" variant="ghost" size="icon" aria-label="Close" onClick={onClose}>
              <X className="h-4 w-4" />
            </Button>
          </div>
        </div>

        <div className="min-h-0 flex-1 space-y-4 overflow-y-auto px-4 py-4">
          {!view ? (
            <p className="rounded-lg border border-slate-200 bg-slate-50 px-3 py-6 text-center text-sm text-slate-600">
              {loading ? 'Loading the Overtime Request…' : 'This Overtime Request could not be found.'}
            </p>
          ) : (
            <>
              <div className="grid gap-3 sm:grid-cols-3">
                <div className="rounded-xl border border-teal-100 bg-teal-50/70 px-3 py-2">
                  <p className="text-xs text-teal-900/80">Period</p>
                  <p className="mt-0.5 flex items-center gap-1.5 text-sm font-semibold text-teal-950">
                    <CalendarDays className="h-4 w-4 shrink-0" />
                    {view.period || '—'}
                  </p>
                </div>
                <div className="rounded-xl border border-teal-100 bg-teal-50/70 px-3 py-2">
                  <p className="text-xs text-teal-900/80">Calculated Days</p>
                  <p className="mt-0.5 text-sm font-semibold tabular-nums text-teal-950">{view.lines.length}</p>
                </div>
                <div className="rounded-xl border border-teal-100 bg-teal-50/70 px-3 py-2">
                  <p className="text-xs text-teal-900/80">Calculated Hours</p>
                  <p className="mt-0.5 text-sm font-semibold tabular-nums text-teal-950">
                    {Number(view.totalHours || 0).toFixed(2)} hrs
                  </p>
                </div>
              </div>

              <dl className="grid gap-3 text-sm sm:grid-cols-3">
                <div>
                  <dt className="text-xs text-slate-500">Employee</dt>
                  <dd className="mt-0.5 font-medium text-slate-900">{view.employee || '—'}</dd>
                </div>
                <div>
                  <dt className="text-xs text-slate-500">Designation</dt>
                  <dd className="mt-0.5 font-medium text-slate-900">{view.designation || '—'}</dd>
                </div>
                <div>
                  <dt className="text-xs text-slate-500">Department</dt>
                  <dd className="mt-0.5 font-medium text-slate-900">{view.department || '—'}</dd>
                </div>
              </dl>

              <section>
                <h3 className="mb-2 text-sm font-semibold text-slate-900">Overtime lines</h3>
                <div className="overflow-x-auto rounded-xl border border-slate-200">
                  <table className="w-full min-w-[36rem] text-left text-sm">
                    <thead className="bg-slate-50 text-xs text-slate-500">
                      <tr>
                        <th className="px-3 py-2 font-medium">Date</th>
                        <th className="px-3 py-2 font-medium">Category</th>
                        {showLocation ? <th className="px-3 py-2 font-medium">Location</th> : null}
                        <th className="px-3 py-2 font-medium">Time</th>
                        <th className="px-3 py-2 text-right font-medium">Hours</th>
                        <th className="px-3 py-2 font-medium">Reason</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {view.lines.map((line, index) => (
                        <tr key={`${line.date}-${line.time}-${index}`}>
                          <td className="whitespace-nowrap px-3 py-2 font-medium text-slate-900">{line.date}</td>
                          <td className="px-3 py-2 text-slate-700">{line.category}</td>
                          {showLocation ? <td className="px-3 py-2 text-slate-700">{line.location || '—'}</td> : null}
                          <td className="whitespace-nowrap px-3 py-2 text-slate-700">{line.time}</td>
                          <td className="px-3 py-2 text-right tabular-nums text-slate-900">{line.hours.toFixed(2)}</td>
                          <td className="max-w-[16rem] truncate px-3 py-2 text-slate-500" title={line.reason}>
                            {line.reason || '—'}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </section>

              <dl className="grid gap-3 text-sm sm:grid-cols-2">
                <div>
                  <dt className="text-xs text-slate-500">Overall justification</dt>
                  <dd className="mt-0.5 whitespace-pre-wrap text-slate-900">{view.justification || '—'}</dd>
                </div>
                <div>
                  <dt className="text-xs text-slate-500">Expected deliverables</dt>
                  <dd className="mt-0.5 whitespace-pre-wrap text-slate-900">{view.expectedDeliverables || '—'}</dd>
                </div>
              </dl>

              {view.steps.length ? (
                <section>
                  <h3 className="mb-2 text-sm font-semibold text-slate-900">Approvals</h3>
                  <ol className="space-y-2">
                    {view.steps.map((step, index) => (
                      <li
                        key={`${step.label}-${index}`}
                        className={cn(
                          'flex items-start gap-2 rounded-lg border px-3 py-2 text-sm',
                          step.status === 'Approved'
                            ? 'border-emerald-100 bg-emerald-50/60'
                            : step.status === 'Rejected'
                              ? 'border-red-100 bg-red-50/60'
                              : 'border-slate-200 bg-white',
                        )}
                      >
                        <span className="mt-0.5 shrink-0">{stepIcon(step.status)}</span>
                        <div className="min-w-0 flex-1">
                          <div className="flex flex-wrap items-baseline justify-between gap-2">
                            <span className="font-medium text-slate-900">
                              {step.label}
                              {step.approver ? <span className="font-normal text-slate-600"> — {step.approver}</span> : null}
                            </span>
                            <span className="text-xs text-slate-500">
                              {step.status}
                              {step.decidedAt ? ` · ${step.decidedAt}` : ''}
                            </span>
                          </div>
                          {step.comment ? <p className="mt-1 whitespace-pre-wrap text-slate-700">{step.comment}</p> : null}
                        </div>
                      </li>
                    ))}
                  </ol>
                </section>
              ) : null}
            </>
          )}
        </div>
      </div>
    </div>,
    document.body,
  )
}
