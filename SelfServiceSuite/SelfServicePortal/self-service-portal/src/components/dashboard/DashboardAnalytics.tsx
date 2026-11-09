import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { AlertTriangle, ArrowUpRight, Boxes, Package } from 'lucide-react'
import type {
  DashboardModuleCount,
  DashboardStatusCount,
  DashboardStockAvailability,
} from '@/api/endpoints/employee'
import { cn } from '@/lib/utils'

const MODULE_BAR_COLORS = [
  '#03949b',
  '#4d7dbf',
  '#277a53',
  '#b2b435',
  '#b35300',
  '#6b5bb8',
  '#c45d7a',
  '#26225b',
]

const STATUS_COLORS: Record<string, string> = {
  Posted: '#277a53',
  Pending: '#b35300',
  Draft: '#8a8d98',
  Returned: '#4d7dbf',
  Rejected: '#b42318',
}

function VizCard({
  title,
  subtitle,
  accent,
  action,
  children,
  className,
}: {
  title: string
  subtitle?: string
  accent?: string
  action?: ReactNode
  children: ReactNode
  className?: string
}) {
  return (
    <div className={cn('portal-viz', className)}>
      <div className="portal-viz-accent" style={accent ? { background: accent } : undefined} />
      <div className="portal-viz-head">
        <div className="min-w-0">
          <p className="portal-viz-kicker">Insight</p>
          <h3 className="truncate text-sm font-semibold tracking-tight text-slate-900">{title}</h3>
          {subtitle ? <p className="mt-0.5 truncate text-[11px] text-slate-500">{subtitle}</p> : null}
        </div>
        {action}
      </div>
      <div className="portal-viz-body">{children}</div>
    </div>
  )
}

/** Power BI–style column chart for documents by module. */
export function DocumentsByModuleChart({ rows }: { rows: DashboardModuleCount[] }) {
  const data = rows.filter((row) => row.count > 0).slice(0, 8)
  const max = Math.max(1, ...data.map((row) => row.count))
  const total = data.reduce((sum, row) => sum + row.count, 0)

  return (
    <VizCard
      title="Documents by module"
      subtitle="Your request volume"
      accent="linear-gradient(90deg, #03949b, #4d7dbf)"
      action={
        <span className="portal-viz-metric">
          <span className="portal-viz-metric-value">{total}</span>
          <span className="portal-viz-metric-label">docs</span>
        </span>
      }
    >
      {data.length === 0 ? (
        <p className="py-6 text-center text-sm text-slate-500">No documents yet</p>
      ) : (
        <div className="portal-viz-plot">
          <div className="portal-viz-grid" aria-hidden>
            <span />
            <span />
            <span />
            <span />
          </div>
          <div className="relative z-[1] flex h-[7.5rem] items-end gap-1.5 px-0.5 sm:gap-2">
            {data.map((row, index) => {
              const height = Math.max(10, Math.round((row.count / max) * 100))
              const color = MODULE_BAR_COLORS[index % MODULE_BAR_COLORS.length]!
              return (
                <div key={row.key} className="group flex min-w-0 flex-1 flex-col items-center gap-1.5">
                  <span className="text-[10px] font-bold tabular-nums text-slate-700 opacity-0 transition-opacity group-hover:opacity-100 sm:opacity-100">
                    {row.count}
                  </span>
                  <div className="flex h-24 w-full items-end justify-center">
                    <div
                      className="portal-viz-col w-[72%] max-w-[2.25rem] rounded-t-md"
                      style={{
                        height: `${height}%`,
                        background: `linear-gradient(180deg, ${color} 0%, ${color}cc 100%)`,
                        boxShadow: `0 8px 16px -10px ${color}`,
                      }}
                      title={`${row.label}: ${row.count}`}
                    />
                  </div>
                  <span
                    className="w-full truncate text-center text-[10px] font-medium leading-tight text-slate-500"
                    title={row.label}
                  >
                    {row.label}
                  </span>
                </div>
              )
            })}
          </div>
        </div>
      )}
    </VizCard>
  )
}

/** Power BI–style donut with % legend. */
export function WorkflowStatusChart({ rows }: { rows: DashboardStatusCount[] }) {
  const data = rows.filter((row) => row.count > 0)
  const total = data.reduce((sum, row) => sum + row.count, 0)
  const radius = 42
  const circumference = 2 * Math.PI * radius
  let offset = 0
  const segments = data.map((row) => {
    const pct = total > 0 ? row.count / total : 0
    const length = pct * circumference
    const segment = {
      ...row,
      pct,
      color: STATUS_COLORS[row.label] ?? '#70727c',
      dash: `${length} ${circumference - length}`,
      offset,
    }
    offset -= length
    return segment
  })
  const lead = segments[0]

  return (
    <VizCard
      title="Workflow status"
      subtitle="Where documents stand"
      accent="linear-gradient(90deg, #277a53, #b2b435)"
      action={
        lead ? (
          <span className="portal-viz-metric">
            <span className="portal-viz-metric-value" style={{ color: lead.color }}>
              {Math.round(lead.pct * 100)}%
            </span>
            <span className="portal-viz-metric-label">{lead.label}</span>
          </span>
        ) : null
      }
    >
      {total === 0 ? (
        <p className="py-6 text-center text-sm text-slate-500">No status data yet</p>
      ) : (
        <div className="flex items-center gap-4">
          <div className="relative h-[7.25rem] w-[7.25rem] shrink-0">
            <svg viewBox="0 0 120 120" className="h-full w-full -rotate-90 drop-shadow-sm">
              <defs>
                <filter id="vizSoft" x="-20%" y="-20%" width="140%" height="140%">
                  <feDropShadow dx="0" dy="1" stdDeviation="1.2" floodOpacity="0.12" />
                </filter>
              </defs>
              <circle cx="60" cy="60" r={radius} fill="none" stroke="var(--portal-surface-sunken)" strokeWidth="14" />
              {segments.map((segment) => (
                <circle
                  key={segment.label}
                  cx="60"
                  cy="60"
                  r={radius}
                  fill="none"
                  stroke={segment.color}
                  strokeWidth="14"
                  strokeDasharray={segment.dash}
                  strokeDashoffset={segment.offset}
                  strokeLinecap="butt"
                  filter="url(#vizSoft)"
                  className="portal-dash-arc"
                />
              ))}
            </svg>
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <span className="text-2xl font-semibold tabular-nums leading-none text-slate-900">{total}</span>
              <span className="mt-0.5 text-[9px] font-semibold uppercase tracking-[0.12em] text-slate-500">Total</span>
            </div>
          </div>
          <ul className="min-w-0 flex-1 space-y-2">
            {segments.map((segment) => (
              <li key={segment.label} className="flex items-center gap-2">
                <span
                  className="h-2.5 w-2.5 shrink-0 rounded-[3px]"
                  style={{ background: segment.color, boxShadow: `0 0 0 3px ${segment.color}22` }}
                />
                <span className="min-w-0 flex-1 truncate text-xs font-medium text-slate-600">{segment.label}</span>
                <span className="text-[11px] tabular-nums text-slate-400">{Math.round(segment.pct * 100)}%</span>
                <span className="w-5 text-right text-xs font-bold tabular-nums text-slate-800">{segment.count}</span>
              </li>
            ))}
          </ul>
        </div>
      )}
    </VizCard>
  )
}

/** Power BI–style stock KPIs + low-stock matrix. */
export function StockAvailabilityPanel({ stock }: { stock?: DashboardStockAvailability }) {
  const available = stock?.available === true
  const lowStock = (stock?.lowStock ?? []).slice(0, 6)
  const onHand = Math.round(stock?.stockOnHand ?? 0)
  const active = stock?.activeItems ?? 0

  return (
    <VizCard
      title="Stock availability"
      subtitle="Open inventory remaining across stores"
      accent="linear-gradient(90deg, #26225b, #03949b)"
      action={
        <Link
          to="/facility/store-requisition"
          className="inline-flex items-center gap-1 rounded-lg bg-[var(--portal-navy)] px-2.5 py-1.5 text-[11px] font-semibold text-white transition hover:bg-[var(--portal-navy-dark)]"
        >
          Store req
          <ArrowUpRight className="h-3 w-3" />
        </Link>
      }
    >
      <div className="mb-3 grid grid-cols-2 gap-2 sm:grid-cols-3">
        <div className="portal-viz-kpi">
          <div className="flex items-center gap-1.5 text-[10px] font-semibold uppercase tracking-wide text-slate-500">
            <Boxes className="h-3.5 w-3.5 text-[var(--portal-navy)]" />
            On hand
          </div>
          <p className="mt-1 text-xl font-semibold tabular-nums tracking-tight text-slate-900">
            {available ? onHand.toLocaleString() : '—'}
          </p>
        </div>
        <div className="portal-viz-kpi">
          <div className="flex items-center gap-1.5 text-[10px] font-semibold uppercase tracking-wide text-slate-500">
            <Package className="h-3.5 w-3.5 text-[var(--portal-blue)]" />
            Active items
          </div>
          <p className="mt-1 text-xl font-semibold tabular-nums tracking-tight text-slate-900">
            {available ? active.toLocaleString() : '—'}
          </p>
        </div>
        <div className="portal-viz-kpi col-span-2 sm:col-span-1">
          <div className="flex items-center gap-1.5 text-[10px] font-semibold uppercase tracking-wide text-slate-500">
            <AlertTriangle className="h-3.5 w-3.5 text-[var(--portal-orange)]" />
            Low stock
          </div>
          <p className="mt-1 text-xl font-semibold tabular-nums tracking-tight text-slate-900">
            {available ? lowStock.length : '—'}
          </p>
        </div>
      </div>

      {!available ? (
        <p className="text-sm text-slate-500">Stock figures unavailable from Business Central right now.</p>
      ) : lowStock.length > 0 ? (
        <ul className="grid gap-1.5 sm:grid-cols-2 lg:grid-cols-3">
          {lowStock.map((item) => {
            const fill = Math.min(100, Math.max(8, (item.quantity / 5) * 100))
            return (
              <li key={`${item.itemNo}-${item.locationCode}`} className="portal-viz-stock">
                <div className="flex items-start justify-between gap-2">
                  <span className="min-w-0 truncate text-xs font-semibold text-slate-800" title={item.description}>
                    {item.description || item.itemNo}
                  </span>
                  <span className="shrink-0 rounded-full bg-orange-100 px-1.5 py-0.5 text-[10px] font-bold tabular-nums text-orange-800">
                    {item.quantity}
                  </span>
                </div>
                <p className="mt-0.5 truncate text-[10px] text-slate-500">
                  {item.itemNo}
                  {item.locationCode ? ` · ${item.locationCode}` : ''}
                </p>
                <div className="mt-1.5 h-1 overflow-hidden rounded-full bg-orange-100">
                  <div
                    className="h-full rounded-full bg-[var(--portal-orange)]"
                    style={{ width: `${fill}%` }}
                  />
                </div>
              </li>
            )
          })}
        </ul>
      ) : (
        <p className="text-xs text-slate-500">Nothing at or below 5 units.</p>
      )}
    </VizCard>
  )
}
