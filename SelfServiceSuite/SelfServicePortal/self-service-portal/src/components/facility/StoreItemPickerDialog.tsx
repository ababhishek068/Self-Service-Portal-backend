import { useQuery } from '@tanstack/react-query'
import { useEffect, useMemo, useState } from 'react'
import { createPortal } from 'react-dom'
import { CheckCircle2, Minus, PackagePlus, Plus, RefreshCw, Search, X } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { getStoreOfferItems, type StoreOfferItem } from '@/api/endpoints/requestEndpoint'
import { cn } from '@/lib/utils'
import { quantityLabel, text, type RequestedLine } from './storeOfferLines'
import { StoreStockPill } from './StoreStockPill'

function brandModelOf(item: StoreOfferItem) {
  return [item.brand, item.model].map(text).filter(Boolean).join(' / ')
}

function matchesFilter(item: StoreOfferItem, filter: string) {
  if (!filter) return true
  const haystack = [item.no, item.description, item.brand, item.model, item.specification, item.category, item.assetTag]
    .map(text)
    .join(' ')
    .toLowerCase()
  return filter
    .toLowerCase()
    .split(/\s+/)
    .filter(Boolean)
    .every((word) => haystack.includes(word))
}

/**
 * Add Item to Issue in a dialog: the store's items as cards (in stock first), a filter that
 * works as you type (Enter searches every item in BC), and a fixed bar with the quantity.
 */
export function StoreItemPickerDialog({
  requestId,
  requestNo,
  requestedLines,
  requested,
  busy,
  onAdd,
  onClose,
}: {
  requestId: string
  requestNo: string
  requestedLines: RequestedLine[]
  requested: number
  busy: boolean
  /** Resolves true when Business Central added the store offer line. */
  onAdd: (item: StoreOfferItem, quantity: number) => Promise<boolean>
  onClose: () => void
}) {
  const [filter, setFilter] = useState('')
  const [serverSearch, setServerSearch] = useState('')
  const [inStockOnly, setInStockOnly] = useState(true)
  const [selected, setSelected] = useState<StoreOfferItem | null>(null)
  const [quantity, setQuantity] = useState(requested > 0 ? requested : 1)
  const itemsQuery = useQuery({
    queryKey: ['store-offer-items', requestId, serverSearch],
    queryFn: () => getStoreOfferItems(requestId, serverSearch),
    retry: false,
    staleTime: 60_000,
  })
  const allItems = useMemo(() => itemsQuery.data?.items ?? [], [itemsQuery.data])
  const issuingStore = itemsQuery.data?.issuingStore || 'the store'
  const inStockCount = allItems.filter((item) => Number(item.available ?? 0) > 0).length
  const visibleItems = allItems.filter(
    (item) => matchesFilter(item, filter) && (!inStockOnly || Number(item.available ?? 0) > 0),
  )
  const selectedAvailable = Number(selected?.available ?? 0)
  // BC 1.0.3.591: a fixed asset card is one unit; offer 3 laptops = 3 cards.
  const selectedIsAsset = selected?.isFixedAsset === true || String(selected?.isFixedAsset).toLowerCase() === 'true'
  const tooMany = Boolean(selected) && !selectedIsAsset && quantity > selectedAvailable
  const loading = itemsQuery.isLoading || itemsQuery.isFetching

  // Esc closes; the page behind does not scroll while the dialog is open.
  useEffect(() => {
    const handler = (event: KeyboardEvent) => {
      if (event.key === 'Escape' && !busy) onClose()
    }
    window.addEventListener('keydown', handler)
    const previousOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    return () => {
      window.removeEventListener('keydown', handler)
      document.body.style.overflow = previousOverflow
    }
  }, [busy, onClose])

  const searchEverywhere = () => {
    setSelected(null)
    setInStockOnly(false)
    setServerSearch(filter.trim())
  }

  const add = async () => {
    if (!selected || !(quantity > 0) || tooMany) return
    if (await onAdd(selected, selectedIsAsset ? 1 : quantity)) onClose()
  }

  const requestedText = requestedLines
    .map((line) => `${line.itemName || '—'} · ${quantityLabel(line.quantity)} ${line.unitOfMeasure}${line.brand ? ` · ${line.brand}` : ''}`)
    .join('  |  ')

  return createPortal(
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-2 sm:p-4">
      <button
        type="button"
        aria-label="Close"
        onClick={() => (busy ? undefined : onClose())}
        className="absolute inset-0 bg-slate-900/45 backdrop-blur-sm"
      />
      <div
        role="dialog"
        aria-modal="true"
        aria-label={`Add Item to Issue — ${requestNo}`}
        className="relative flex max-h-[94vh] mx-auto w-[min(97vw,84rem)] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xl"
      >
        <div className="h-1.5 w-full shrink-0 bg-gradient-to-r from-[var(--portal-navy)] to-[var(--portal-green)]" />

        <div className="shrink-0 space-y-3 border-b border-slate-100 px-5 pb-4 pt-4">
          <div className="flex items-start justify-between gap-3">
            <div className="flex items-start gap-3">
              <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[var(--portal-navy)]/10 text-[var(--portal-navy-dark)]">
                <PackagePlus className="h-5 w-5" />
              </span>
              <div className="min-w-0">
                <p className="text-base font-semibold text-slate-900">Add Item to Issue</p>
                <p className="text-xs text-slate-500">
                  Store requisition {requestNo} · items at {issuingStore}
                </p>
              </div>
            </div>
            <Button type="button" variant="ghost" size="icon" aria-label="Close" disabled={busy} onClick={onClose}>
              <X className="h-4 w-4" />
            </Button>
          </div>

          {requestedText ? (
            <p className="truncate rounded-lg bg-slate-50 px-3 py-2 text-xs text-slate-600" title={requestedText}>
              <span className="font-semibold text-slate-700">Requested: </span>
              {requestedText}
            </p>
          ) : null}

          <div className="flex flex-col gap-2 sm:flex-row sm:items-center">
            <form
              className="relative flex-1"
              onSubmit={(event) => {
                event.preventDefault()
                searchEverywhere()
              }}
            >
              <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
              <input
                autoFocus
                value={filter}
                onChange={(event) => setFilter(event.target.value)}
                placeholder="Search by name, item no., brand or spec"
                aria-label="Search the store items"
                className="h-10 w-full rounded-lg border border-slate-200 bg-white pl-9 pr-9 text-sm text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-[var(--portal-navy)] focus:ring-2 focus:ring-[var(--portal-navy)]/15"
              />
              {filter ? (
                <button
                  type="button"
                  aria-label="Clear the search"
                  onClick={() => {
                    setFilter('')
                    if (serverSearch) setServerSearch('')
                  }}
                  className="absolute right-2 top-1/2 -translate-y-1/2 rounded-md p-1 text-slate-400 hover:bg-slate-100 hover:text-slate-600"
                >
                  <X className="h-4 w-4" />
                </button>
              ) : null}
            </form>
            <div className="inline-flex shrink-0 rounded-full bg-slate-100 p-0.5 text-xs font-medium">
              {[
                { value: true, label: `In stock (${inStockCount})` },
                { value: false, label: `All (${allItems.length})` },
              ].map((option) => (
                <button
                  key={option.label}
                  type="button"
                  onClick={() => setInStockOnly(option.value)}
                  className={cn(
                    'rounded-full px-3 py-1.5 transition',
                    inStockOnly === option.value
                      ? 'bg-white text-[var(--portal-navy-dark)] shadow-sm'
                      : 'text-slate-500 hover:text-slate-700',
                  )}
                >
                  {option.label}
                </button>
              ))}
            </div>
          </div>
        </div>

        <div className="min-h-[16rem] flex-1 overflow-y-auto bg-slate-50/60 px-5 py-4">
          {loading ? (
            <div className="grid grid-cols-[repeat(auto-fill,minmax(min(100%,18rem),1fr))] gap-2.5">
              {[0, 1, 2, 3, 4, 5].map((index) => (
                <div key={index} className="h-24 animate-pulse rounded-xl border border-slate-100 bg-white" />
              ))}
            </div>
          ) : itemsQuery.isError ? (
            <div className="mx-auto flex max-w-md flex-col items-center gap-3 py-10 text-center text-sm text-red-800">
              {itemsQuery.error instanceof Error ? itemsQuery.error.message : 'Could not load the store items.'}
              <Button type="button" variant="outline" size="sm" onClick={() => void itemsQuery.refetch()}>
                <RefreshCw className="h-3.5 w-3.5" /> Try again
              </Button>
            </div>
          ) : visibleItems.length ? (
            <div className="grid grid-cols-[repeat(auto-fill,minmax(min(100%,18rem),1fr))] gap-2.5">
              {visibleItems.map((item) => {
                const atStore = Number(item.available ?? 0)
                const onHand = item.onHand === undefined ? undefined : Number(item.onHand)
                const inStock = atStore > 0
                const active = selected?.no === item.no
                const brandModel = brandModelOf(item)
                const isAsset = item.isFixedAsset === true || String(item.isFixedAsset).toLowerCase() === 'true'
                return (
                  <button
                    key={item.no}
                    type="button"
                    disabled={!inStock || busy}
                    title={inStock ? undefined : `No stock at ${issuingStore} — use Request for LPR.`}
                    onClick={() => {
                      setSelected(item)
                      setQuantity(Math.min(Math.max(requested, 1), atStore))
                    }}
                    className={cn(
                      'flex flex-col gap-1 rounded-xl border bg-white p-3 text-left transition',
                      active
                        ? 'border-[var(--portal-navy)] ring-2 ring-[var(--portal-navy)]/25'
                        : inStock
                          ? 'border-slate-200 hover:-translate-y-px hover:border-teal-300 hover:shadow-md'
                          : 'cursor-not-allowed border-slate-100 opacity-55',
                    )}
                  >
                    <div className="flex items-start justify-between gap-2">
                      <span className="flex items-center gap-1.5 font-mono text-[11px] text-slate-400">
                        {item.no}
                        {isAsset ? (
                          <span className="rounded bg-sky-100 px-1.5 py-0.5 font-sans text-[10px] font-semibold text-sky-800">
                            Asset{item.assetTag ? ` · ${item.assetTag}` : ''}
                          </span>
                        ) : null}
                      </span>
                      {active ? (
                        <CheckCircle2 className="h-4 w-4 text-[var(--portal-navy)]" />
                      ) : (
                        <StoreStockPill atStore={atStore} unit={item.unitOfMeasure} low={inStock && atStore < requested} />
                      )}
                    </div>
                    <p className="line-clamp-1 text-sm font-semibold text-slate-900">{item.description || 'No description'}</p>
                    {brandModel ? (
                      <span className="line-clamp-1 w-fit rounded-md bg-slate-100 px-1.5 py-0.5 text-[11px] font-medium text-slate-600">
                        {brandModel}
                      </span>
                    ) : null}
                    {item.specification ? (
                      <p className="line-clamp-2 text-xs leading-snug text-slate-500">{item.specification}</p>
                    ) : null}
                    {onHand !== undefined && onHand !== atStore ? (
                      <p className="mt-auto text-[11px] text-slate-400">{quantityLabel(onHand)} in all stores</p>
                    ) : null}
                  </button>
                )
              })}
            </div>
          ) : (
            <div className="mx-auto max-w-md py-10 text-center">
              <p className="text-sm font-medium text-slate-700">
                {filter ? `Nothing at ${issuingStore} matches “${filter}”.` : `No item in stock at ${issuingStore}.`}
              </p>
              <p className="mt-1 text-xs text-slate-500">
                {filter && !serverSearch
                  ? 'Search every item in Business Central, or close this and use Request for LPR if nothing similar is in store.'
                  : 'If there is no similar item in store, close this and use Request for LPR.'}
              </p>
              {filter && !serverSearch ? (
                <Button type="button" variant="outline" size="sm" className="mt-3" onClick={searchEverywhere}>
                  <Search className="h-3.5 w-3.5" /> Search all items
                </Button>
              ) : null}
            </div>
          )}
        </div>

        <div className="flex shrink-0 flex-wrap items-center gap-3 border-t border-slate-200 bg-white px-5 py-3">
          {selected ? (
            <>
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-semibold text-slate-900">
                  {selected.description}{' '}
                  <span className="font-mono text-[11px] font-normal text-slate-400">{selected.no}</span>
                </p>
                <p className={cn('text-xs', tooMany ? 'font-semibold text-red-700' : 'text-slate-500')}>
                  {selectedIsAsset
                    ? `One asset card${selected.assetTag ? ` (tag ${selected.assetTag})` : ''} · requested ${quantityLabel(requested)}. Add each card on its own.`
                    : tooMany
                      ? `Only ${quantityLabel(selectedAvailable)} ${selected.unitOfMeasure} at ${issuingStore}`
                      : `${quantityLabel(selectedAvailable)} ${selected.unitOfMeasure} available · requested ${quantityLabel(requested)}`}
                </p>
              </div>
              {selectedIsAsset ? null : (
                <>
                  <div className="flex items-center rounded-lg border border-slate-200 bg-white shadow-sm">
                    <button
                      type="button"
                      aria-label="Less"
                      disabled={quantity <= 1}
                      onClick={() => setQuantity((current) => Math.max(1, current - 1))}
                      className="p-2 text-slate-500 hover:text-slate-800 disabled:opacity-40"
                    >
                      <Minus className="h-4 w-4" />
                    </button>
                    <input
                      type="number"
                      min={1}
                      step="any"
                      value={Number.isFinite(quantity) ? quantity : ''}
                      onChange={(event) => setQuantity(Number(event.target.value))}
                      aria-label="Quantity to issue"
                      className="w-14 border-x border-slate-200 py-1.5 text-center text-sm font-semibold text-slate-900 outline-none"
                    />
                    <button
                      type="button"
                      aria-label="More"
                      disabled={quantity >= selectedAvailable}
                      onClick={() => setQuantity((current) => Math.min(selectedAvailable, current + 1))}
                      className="p-2 text-slate-500 hover:text-slate-800 disabled:opacity-40"
                    >
                      <Plus className="h-4 w-4" />
                    </button>
                  </div>
                  <span className="text-xs text-slate-500">{selected.unitOfMeasure}</span>
                </>
              )}
            </>
          ) : (
            <p className="flex-1 text-xs text-slate-500">Choose the item you will issue. Out-of-stock items cannot be issued.</p>
          )}
          <div className="flex items-center gap-2">
            <Button type="button" variant="outline" className="rounded-full" disabled={busy} onClick={onClose}>
              Cancel
            </Button>
            <Button
              type="button"
              variant="gradient"
              className="rounded-full"
              disabled={busy || !selected || !(quantity > 0) || tooMany}
              onClick={() => void add()}
            >
              <PackagePlus className="h-4 w-4" />
              {busy ? 'Adding…' : 'Add to offer'}
            </Button>
          </div>
        </div>
      </div>
    </div>,
    document.body,
  )
}
