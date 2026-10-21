import { cn } from '@/lib/utils'
import { quantityLabel } from './storeOfferLines'

/** Stock at the issuing store: green in stock, amber below the requested quantity, grey none. */
export function StoreStockPill({ atStore, unit, low }: { atStore: number; unit: string; low: boolean }) {
  if (atStore <= 0) {
    return (
      <span className="inline-flex shrink-0 items-center rounded-full bg-slate-100 px-2 py-0.5 text-[11px] font-semibold text-slate-500">
        Out of stock
      </span>
    )
  }
  return (
    <span
      className={cn(
        'inline-flex shrink-0 items-center gap-1 rounded-full px-2 py-0.5 text-[11px] font-semibold ring-1',
        low ? 'bg-amber-50 text-amber-800 ring-amber-200' : 'bg-emerald-50 text-emerald-700 ring-emerald-200',
      )}
    >
      <span className={cn('h-1.5 w-1.5 rounded-full', low ? 'bg-amber-500' : 'bg-emerald-500')} />
      {quantityLabel(atStore)} {unit}
    </span>
  )
}

/** "Requested by the employee" box, shared by the store keeper and store manager cards. */
export function RequestedSummary({
  lines,
}: {
  lines: Array<{ key: string; itemName: string; details: string; brand: string; unitOfMeasure: string; quantity: number }>
}) {
  if (!lines.length) return null
  return (
    <ul className="space-y-1">
      {lines.map((line) => (
        <li key={line.key} className="flex flex-wrap items-baseline gap-x-2 text-sm text-slate-800">
          <span className="font-semibold">{line.itemName || '—'}</span>
          <span className="text-xs text-slate-500">
            {quantityLabel(line.quantity)} {line.unitOfMeasure}
            {line.brand ? ` · ${line.brand}` : ''}
          </span>
          {line.details ? <span className="basis-full text-xs text-slate-500">{line.details}</span> : null}
        </li>
      ))}
    </ul>
  )
}
