import { useQuery } from '@tanstack/react-query'
import { useMemo, useState, type ReactNode } from 'react'
import {
  CheckCircle2,
  ClipboardList,
  Minus,
  PackageCheck,
  PackagePlus,
  Plus,
  RefreshCw,
  Search,
  Trash2,
  X,
} from 'lucide-react'
import { Button } from '@/components/ui/button'
import { getStoreOfferItems, type StoreOfferItem } from '@/api/endpoints/requestEndpoint'
import { cn } from '@/lib/utils'
import type { PortalRequest } from '@/types/erp.types'
import { quantityLabel, storeOfferLines, text } from './storeOfferLines'
import { RequestedSummary, StoreStockPill } from './StoreStockPill'

type StoreAction = (
  actionCode: string,
  title: string,
  message: string,
  extra?: Record<string, string | number>,
  confirmFirst?: boolean,
) => Promise<boolean>

function brandModelOf(item: StoreOfferItem) {
  return [item.brand, item.model].map(text).filter(Boolean).join(' / ')
}

function matchesFilter(item: StoreOfferItem, filter: string) {
  if (!filter) return true
  const haystack = [item.no, item.description, item.brand, item.model, item.specification, item.category]
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
 * Store Keeper on an approved store requisition — the BC Store Req Header Approved steps:
 * Add Item to Issue (the real item in stock), Submit to Store Manager; after the requester
 * declines, Offer Another Item or Close Request.
 */
export function StoreKeeperOfferSection({
  request,
  stage,
  declined,
  available,
  busy,
  run,
  secondaryAction,
}: {
  request: PortalRequest
  /** '' (with the store) or 'PREPARED' (with the store manager). */
  stage: string
  declined: boolean
  /** On-hand quantity at the issuing store per offered item No. */
  available: Record<string, number>
  busy: boolean
  run: StoreAction
  /** Extra footer action, e.g. Request for LPR when nothing similar is in store. */
  secondaryAction?: ReactNode
}) {
  const { offers, requestedLines, requested } = storeOfferLines(request)
  const requestNo = request.requestNo
  const withManager = stage === 'PREPARED'

  // The store's items load straight away; typing filters them, Enter searches every item in BC.
  const [filter, setFilter] = useState('')
  const [serverSearch, setServerSearch] = useState('')
  const [inStockOnly, setInStockOnly] = useState(true)
  const [selected, setSelected] = useState<StoreOfferItem | null>(null)
  const [quantity, setQuantity] = useState(requested > 0 ? requested : 1)
  const itemsQuery = useQuery({
    queryKey: ['store-offer-items', request.id, serverSearch],
    queryFn: () => getStoreOfferItems(request.id, serverSearch),
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
  const tooMany = Boolean(selected) && quantity > selectedAvailable

  const searchEverywhere = () => {
    setSelected(null)
    setInStockOnly(false)
    setServerSearch(filter.trim())
  }

  const addOffer = async () => {
    if (!selected || !(quantity > 0) || tooMany) return
    const added = await run(
      'ADD_STORE_OFFER',
      'Add Item to Issue',
      '',
      { itemNo: selected.no, quantity },
      false,
    )
    if (added) setSelected(null)
  }

  const footerHint = withManager
    ? 'With the store manager. You can still change the item until they accept it.'
    : declined
      ? 'The requester declined the last item. Offer another item, or close the request.'
      : offers.length
        ? 'Check the items, then submit them to the store manager. Stock does not move yet.'
        : 'Add the item you will issue, then submit it to the store manager.'

  return (
    <div className="mt-4 overflow-hidden rounded-xl border border-[var(--portal-card-border)] bg-white shadow-sm">
      <div className="flex flex-wrap items-start justify-between gap-3 border-b border-slate-100 bg-gradient-to-r from-teal-50 via-white to-white px-4 py-3">
        <div className="flex items-start gap-3">
          <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-[var(--portal-navy)]/10 text-[var(--portal-navy-dark)]">
            <PackageCheck className="h-4 w-4" />
          </span>
          <div>
            <p className="text-sm font-semibold text-slate-900">Items to issue</p>
            <p className="text-xs text-slate-500">Store offer — the real item from stock. The requester’s line stays as written.</p>
          </div>
        </div>
        <span
          className={cn(
            'rounded-full px-2.5 py-1 text-[11px] font-semibold',
            offers.length ? 'bg-emerald-50 text-emerald-700' : 'bg-slate-100 text-slate-500',
          )}
        >
          {offers.length ? `${offers.length} item${offers.length === 1 ? '' : 's'} offered` : 'No item offered yet'}
        </span>
      </div>

      <div className="space-y-4 px-4 py-4">
        {requestedLines.length ? (
          <div className="rounded-lg border border-dashed border-slate-200 bg-slate-50/70 px-3 py-2.5">
            <p className="flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-slate-500">
              <ClipboardList className="h-3.5 w-3.5" /> Requested by the employee
            </p>
            <div className="mt-1.5">
              <RequestedSummary lines={requestedLines} />
            </div>
          </div>
        ) : null}

        {offers.length ? (
          <ul className="space-y-2">
            {offers.map((offer) => {
              const onHand = available[offer.itemNo.toUpperCase()]
              const short = onHand !== undefined && onHand < offer.quantity
              return (
                <li
                  key={offer.lineNo}
                  className="flex flex-wrap items-center gap-3 rounded-lg border border-emerald-200 bg-emerald-50/40 px-3 py-2.5"
                >
                  <CheckCircle2 className="h-4 w-4 shrink-0 text-emerald-600" />
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-semibold text-slate-900">
                      {offer.itemName || offer.itemNo}
                      <span className="ml-2 font-mono text-[11px] font-normal text-slate-500">{offer.itemNo}</span>
                    </p>
                    {offer.brandModel || offer.specification ? (
                      <p className="truncate text-xs text-slate-500">
                        {[offer.brandModel, offer.specification].filter(Boolean).join(' · ')}
                      </p>
                    ) : null}
                  </div>
                  <span className="text-sm font-semibold text-slate-800">
                    {quantityLabel(offer.quantity)} {offer.unitOfMeasure}
                  </span>
                  {onHand !== undefined ? (
                    <span className={cn('text-xs', short ? 'font-semibold text-red-700' : 'text-slate-500')}>
                      {short ? `only ${quantityLabel(onHand)} in stock` : `${quantityLabel(onHand)} in stock`}
                    </span>
                  ) : null}
                  <button
                    type="button"
                    disabled={busy}
                    aria-label={`Remove ${offer.itemNo}`}
                    title="Remove this item"
                    className="rounded-md p-1.5 text-slate-400 transition hover:bg-red-50 hover:text-red-600 disabled:opacity-50"
                    onClick={() =>
                      void run(
                        'REMOVE_STORE_OFFER',
                        'Remove store offer',
                        `Remove ${offer.itemNo} from the items to issue on store requisition ${requestNo}?`,
                        { lineNo: Number(offer.lineNo) },
                      )
                    }
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </li>
              )
            })}
          </ul>
        ) : null}

        <div className="space-y-3">
          <div className="flex flex-wrap items-center justify-between gap-2">
            <p className="flex items-center gap-1.5 text-sm font-semibold text-slate-800">
              <PackagePlus className="h-4 w-4 text-[var(--portal-navy)]" />
              {offers.length ? 'Add another item' : 'Add Item to Issue'}
            </p>
            <div className="inline-flex rounded-full bg-slate-100 p-0.5 text-xs font-medium">
              {[
                { value: true, label: `In stock (${inStockCount})` },
                { value: false, label: `All (${allItems.length})` },
              ].map((option) => (
                <button
                  key={option.label}
                  type="button"
                  onClick={() => setInStockOnly(option.value)}
                  className={cn(
                    'rounded-full px-3 py-1 transition',
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

          <form
            className="relative"
            onSubmit={(event) => {
              event.preventDefault()
              searchEverywhere()
            }}
          >
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
            <input
              value={filter}
              onChange={(event) => setFilter(event.target.value)}
              placeholder={`Filter ${issuingStore} items by name, number, brand or spec — Enter searches every item`}
              aria-label="Filter the store items"
              className="h-10 w-full rounded-lg border border-slate-200 bg-white pl-9 pr-9 text-sm text-slate-800 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[var(--portal-navy)] focus:ring-2 focus:ring-[var(--portal-navy)]/15"
            />
            {filter ? (
              <button
                type="button"
                aria-label="Clear the filter"
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

          {itemsQuery.isLoading || itemsQuery.isFetching ? (
            <div className="grid gap-2 sm:grid-cols-2">
              {[0, 1, 2, 3].map((index) => (
                <div key={index} className="h-[5.5rem] animate-pulse rounded-lg border border-slate-100 bg-slate-50" />
              ))}
            </div>
          ) : itemsQuery.isError ? (
            <div className="flex flex-wrap items-center justify-between gap-2 rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-xs text-red-800">
              {itemsQuery.error instanceof Error ? itemsQuery.error.message : 'Could not load the store items.'}
              <Button type="button" variant="outline" size="sm" onClick={() => void itemsQuery.refetch()}>
                <RefreshCw className="h-3.5 w-3.5" /> Retry
              </Button>
            </div>
          ) : visibleItems.length ? (
            <div className="grid max-h-[22rem] gap-2 overflow-y-auto pr-1 sm:grid-cols-2">
              {visibleItems.map((item) => {
                const atStore = Number(item.available ?? 0)
                const onHand = item.onHand === undefined ? undefined : Number(item.onHand)
                const inStock = atStore > 0
                const active = selected?.no === item.no
                const brandModel = brandModelOf(item)
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
                      'relative flex flex-col gap-1 rounded-lg border p-3 text-left transition',
                      active
                        ? 'border-[var(--portal-navy)] bg-teal-50/70 ring-2 ring-[var(--portal-navy)]/20'
                        : inStock
                          ? 'border-slate-200 bg-white hover:-translate-y-px hover:border-teal-300 hover:shadow-md'
                          : 'cursor-not-allowed border-slate-100 bg-slate-50 opacity-60',
                    )}
                  >
                    <div className="flex items-start justify-between gap-2">
                      <span className="font-mono text-[11px] text-slate-500">{item.no}</span>
                      {active ? (
                        <CheckCircle2 className="h-4 w-4 text-[var(--portal-navy)]" />
                      ) : (
                        <StoreStockPill atStore={atStore} unit={item.unitOfMeasure} low={inStock && atStore < requested} />
                      )}
                    </div>
                    <p className="line-clamp-1 text-sm font-semibold text-slate-900">{item.description || 'No description'}</p>
                    {brandModel ? (
                      <span className="w-fit rounded-md bg-slate-100 px-1.5 py-0.5 text-[11px] font-medium text-slate-600">
                        {brandModel}
                      </span>
                    ) : null}
                    {item.specification ? (
                      <p className="line-clamp-2 text-xs leading-snug text-slate-500">{item.specification}</p>
                    ) : null}
                    {onHand !== undefined && onHand !== atStore ? (
                      <p className="text-[11px] text-slate-400">{quantityLabel(onHand)} in all stores</p>
                    ) : null}
                  </button>
                )
              })}
            </div>
          ) : (
            <div className="rounded-lg border border-dashed border-slate-200 px-4 py-6 text-center text-sm text-slate-600">
              <p className="font-medium text-slate-700">
                {filter ? `Nothing at ${issuingStore} matches “${filter}”.` : `No item in stock at ${issuingStore}.`}
              </p>
              <p className="mt-1 text-xs text-slate-500">
                {filter && !serverSearch
                  ? 'Press Enter to search every item in Business Central, or use Request for LPR if nothing similar is in store.'
                  : 'If there is no similar item in store, use Request for LPR.'}
              </p>
              {filter && !serverSearch ? (
                <Button type="button" variant="outline" size="sm" className="mt-3" onClick={searchEverywhere}>
                  <Search className="h-3.5 w-3.5" /> Search all items
                </Button>
              ) : null}
            </div>
          )}

          {selected ? (
            <div className="flex flex-wrap items-center gap-3 rounded-lg border border-teal-200 bg-gradient-to-r from-teal-50 to-white px-3 py-2.5">
              <div className="min-w-0 flex-1">
                <p className="text-[11px] font-semibold uppercase tracking-wide text-teal-700">Selected</p>
                <p className="truncate text-sm font-semibold text-slate-900">
                  {selected.description} <span className="font-mono text-[11px] font-normal text-slate-500">{selected.no}</span>
                </p>
                <p className={cn('text-xs', tooMany ? 'font-semibold text-red-700' : 'text-slate-500')}>
                  {tooMany
                    ? `Only ${quantityLabel(selectedAvailable)} ${selected.unitOfMeasure} at ${issuingStore}`
                    : `${quantityLabel(selectedAvailable)} ${selected.unitOfMeasure} available · requested ${quantityLabel(requested)}`}
                </p>
              </div>
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
              <Button type="button" variant="ghost" size="sm" onClick={() => setSelected(null)}>
                Cancel
              </Button>
              <Button
                type="button"
                variant="gradient"
                disabled={busy || !(quantity > 0) || tooMany}
                onClick={() => void addOffer()}
              >
                <PackagePlus className="h-4 w-4" /> Add to offer
              </Button>
            </div>
          ) : null}
        </div>
      </div>

      <div className="flex flex-wrap items-center justify-between gap-3 border-t border-slate-100 bg-slate-50/70 px-4 py-3">
        <p className="text-xs text-slate-600">{footerHint}</p>
        <div className="flex flex-wrap items-center gap-2">
          {secondaryAction}
          {withManager ? null : declined ? (
            <>
              <Button
                type="button"
                variant="outline"
                disabled={busy}
                className="border-red-200 text-red-700 hover:bg-red-50"
                onClick={() =>
                  void run(
                    'CLOSE_REQUEST',
                    'Close Request',
                    `Close store requisition ${requestNo}? The requester declined the item. No goods issue voucher will be created.`,
                  )
                }
              >
                Close Request
              </Button>
              <Button
                type="button"
                variant="gradient"
                disabled={busy || offers.length === 0}
                onClick={() =>
                  void run(
                    'OFFER_ANOTHER_ITEM',
                    'Offer Another Item',
                    `Send the changed item on store requisition ${requestNo} to the store manager? After the manager accepts, the requester can accept or decline it.`,
                  )
                }
              >
                Offer Another Item
              </Button>
            </>
          ) : (
            <Button
              type="button"
              variant="gradient"
              disabled={busy || offers.length === 0}
              title={offers.length === 0 ? 'Add the item to issue first.' : undefined}
              onClick={() =>
                void run(
                  'PREPARE_ISSUE',
                  'Submit to Store Manager',
                  `Send the item on store requisition ${requestNo} to the store manager? Stock does not move yet.`,
                )
              }
            >
              Submit to Store Manager
            </Button>
          )}
        </div>
      </div>
    </div>
  )
}
