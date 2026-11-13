import { useId, useState, type ReactNode } from 'react'
import { ChevronDown, History } from 'lucide-react'
import { cn } from '@/lib/utils'

/**
 * Approval and Comment History, the same on every page (ABH Operations feedback, Nov 2026): the
 * last section of the page and closed until the user opens it with View more, so it never pushes
 * the request itself out of view.
 */
export function HistorySection({
  title = 'Approval and Comment History',
  count,
  summary,
  className,
  children,
}: {
  title?: string
  /** Number of entries, shown next to the title while the section is closed. */
  count?: number
  /** One line for the closed section, e.g. who the request waits for or the latest decision. */
  summary?: string
  className?: string
  children: ReactNode
}) {
  const [open, setOpen] = useState(false)
  const bodyId = useId()

  return (
    <section className={cn('rounded-lg border border-amber-200 bg-amber-50/70', className)}>
      <button
        type="button"
        className="flex w-full flex-wrap items-center justify-between gap-x-4 gap-y-1 rounded-lg px-4 py-3 text-left focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-amber-400"
        aria-expanded={open}
        aria-controls={bodyId}
        onClick={() => setOpen((value) => !value)}
      >
        <span className="flex min-w-0 items-center gap-2">
          <History className="h-4 w-4 shrink-0 text-[var(--portal-navy)]" aria-hidden="true" />
          <span className="text-sm font-semibold text-[var(--portal-navy)]">{title}</span>
          {count ? (
            <span className="rounded-full bg-white px-2 py-0.5 text-xs font-semibold tabular-nums text-slate-600 ring-1 ring-amber-200">
              {count}
            </span>
          ) : null}
        </span>
        <span className="inline-flex shrink-0 items-center gap-1 text-xs font-semibold text-[var(--portal-navy)]">
          {open ? 'View less' : 'View more'}
          <ChevronDown className={cn('h-4 w-4 transition-transform', open && 'rotate-180')} aria-hidden="true" />
        </span>
        {!open && summary ? (
          <span className="basis-full truncate pl-6 text-xs font-normal text-slate-600">{summary}</span>
        ) : null}
      </button>
      {open ? (
        <div id={bodyId} className="border-t border-amber-200/70 px-4 pb-4 pt-3">
          {children}
        </div>
      ) : null}
    </section>
  )
}
