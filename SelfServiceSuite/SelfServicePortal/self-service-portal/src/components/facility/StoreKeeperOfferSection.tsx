import { useQuery } from '@tanstack/react-query'
import { useState } from 'react'
import { Search } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { getStoreOfferItems, type StoreOfferItem } from '@/api/endpoints/requestEndpoint'
import type { PortalRequest } from '@/types/erp.types'

type StoreAction = (
  actionCode: string,
  title: string,
  message: string,
  extra?: Record<string, string | number>,
  confirmFirst?: boolean,
) => Promise<boolean>

type OfferLine = {
  lineNo: string
  itemNo: string
  itemName: string
  specification: string
  brandModel: string
  unitOfMeasure: string
  quantity: number
}

function text(value: unknown) {
  return String(value ?? '').trim()
}

function requestLines(request: PortalRequest) {
  const lines = request.payload?.lines
  return Array.isArray(lines) ? (lines as Array<Record<string, unknown>>) : []
}

function isOfferLine(line: Record<string, unknown>) {
  return /offer/i.test(text(line.lineRole))
}

function quantityLabel(value: number) {
  return value.toLocaleString(undefined, { maximumFractionDigits: 2 })
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
}: {
  request: PortalRequest
  /** '' (with the store) or 'PREPARED' (with the store manager). */
  stage: string
  declined: boolean
  /** On-hand quantity at the issuing store per offered item No. */
  available: Record<string, number>
  busy: boolean
  run: StoreAction
}) {
  const lines = requestLines(request)
  const offers: OfferLine[] = lines.filter(isOfferLine).map((line) => ({
    lineNo: text(line.lineNo),
    itemNo: text(line.itemNo),
    itemName: text(line.itemName) || text(line.description),
    specification: text(line.description) === text(line.itemName) ? '' : text(line.description),
    brandModel: text(line.preferredBrandModel),
    unitOfMeasure: text(line.unitOfMeasure),
    quantity: Number(line.quantityRequested ?? line.quantity ?? 0),
  }))
  const requested = lines
    .filter((line) => !isOfferLine(line))
    .reduce((total, line) => total + Number(line.quantityRequested ?? line.quantity ?? 0), 0)
  const requestNo = request.requestNo
  const withManager = stage === 'PREPARED'

  const [searchInput, setSearchInput] = useState('')
  const [search, setSearch] = useState<string | null>(null)
  const [selected, setSelected] = useState<StoreOfferItem | null>(null)
  const [quantity, setQuantity] = useState(requested > 0 ? String(requested) : '1')
  const itemsQuery = useQuery({
    queryKey: ['store-offer-items', request.id, search],
    queryFn: () => getStoreOfferItems(request.id, search ?? ''),
    enabled: search !== null,
    retry: false,
  })
  const items = itemsQuery.data?.items ?? []

  const addOffer = async () => {
    if (!selected) return
    const added = await run(
      'ADD_STORE_OFFER',
      'Add Item to Issue',
      '',
      { itemNo: selected.no, quantity: Number(quantity) },
      false,
    )
    if (added) {
      setSelected(null)
      setSearch(null)
      setSearchInput('')
    }
  }

  return (
    <div className="mt-3 space-y-3 rounded-md border border-teal-100 bg-white/80 p-3">
      <div>
        <p className="text-sm font-semibold text-[var(--portal-navy)]">Items to issue (Store Offer)</p>
        <p className="mt-0.5 text-xs text-slate-600">
          {withManager
            ? 'With the store manager. You can still change the item until the manager accepts it.'
            : declined
              ? 'The requester declined. Change the item, then Offer Another Item — or Close Request.'
              : 'Add the real item in stock that you will issue. The requester’s line stays as they wrote it.'}
        </p>
      </div>

      {offers.length ? (
        <div className="overflow-x-auto rounded-md border border-slate-200">
          <table className="min-w-full text-xs">
            <thead className="bg-slate-50 text-left text-slate-600">
              <tr>
                <th className="px-3 py-2 font-medium">Item No.</th>
                <th className="px-3 py-2 font-medium">Description</th>
                <th className="px-3 py-2 font-medium">UOM</th>
                <th className="px-3 py-2 font-medium">Qty to issue</th>
                <th className="px-3 py-2 font-medium">Available</th>
                <th className="px-3 py-2" />
              </tr>
            </thead>
            <tbody>
              {offers.map((offer) => {
                const onHand = available[offer.itemNo.toUpperCase()]
                const short = onHand !== undefined && onHand < offer.quantity
                return (
                  <tr key={offer.lineNo} className="border-t border-slate-100">
                    <td className="px-3 py-2 font-medium">{offer.itemNo}</td>
                    <td className="px-3 py-2">
                      {offer.itemName || '—'}
                      {offer.specification || offer.brandModel ? (
                        <span className="block text-slate-500">
                          {[offer.brandModel, offer.specification].filter(Boolean).join(' · ')}
                        </span>
                      ) : null}
                    </td>
                    <td className="px-3 py-2">{offer.unitOfMeasure || '—'}</td>
                    <td className="px-3 py-2">{quantityLabel(offer.quantity)}</td>
                    <td className={`px-3 py-2 ${short ? 'font-medium text-red-700' : 'text-teal-800'}`}>
                      {onHand === undefined ? '—' : quantityLabel(onHand)}
                      {short ? ' · not enough' : ''}
                    </td>
                    <td className="px-3 py-2 text-right">
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        disabled={busy}
                        onClick={() =>
                          void run(
                            'REMOVE_STORE_OFFER',
                            'Remove store offer',
                            `Remove ${offer.itemNo} from the items to issue on store requisition ${requestNo}?`,
                            { lineNo: Number(offer.lineNo) },
                          )
                        }
                      >
                        Remove
                      </Button>
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      ) : (
        <p className="text-xs text-slate-500">No item added yet.</p>
      )}

      <div className="space-y-2">
        <p className="text-xs font-medium text-slate-700">Add Item to Issue</p>
        <form
          className="flex max-w-xl gap-2"
          onSubmit={(event) => {
            event.preventDefault()
            setSelected(null)
            setSearch(searchInput.trim())
          }}
        >
          <Input
            value={searchInput}
            onChange={(event) => setSearchInput(event.target.value)}
            placeholder="Item No. or description (blank lists the items in stock)"
            aria-label="Search the items in stock"
          />
          <Button type="submit" variant="outline" disabled={busy || itemsQuery.isFetching}>
            <Search className="h-4 w-4" />
            {itemsQuery.isFetching ? 'Searching…' : 'Search'}
          </Button>
        </form>
        {itemsQuery.isError ? (
          <p className="text-xs text-red-700">
            {itemsQuery.error instanceof Error ? itemsQuery.error.message : 'Could not load the items in stock.'}
          </p>
        ) : null}
        {search !== null && !itemsQuery.isFetching && !itemsQuery.isError ? (
          items.length ? (
            <ul className="max-h-60 max-w-xl overflow-y-auto rounded-md border border-slate-200 bg-white">
              {items.map((item) => {
                const active = selected?.no === item.no
                return (
                  <li key={item.no}>
                    <button
                      type="button"
                      onClick={() => setSelected(item)}
                      className={`flex w-full items-start justify-between gap-3 border-b border-slate-100 px-3 py-2 text-left text-xs last:border-b-0 ${
                        active ? 'bg-teal-50' : 'hover:bg-slate-50'
                      }`}
                    >
                      <span>
                        <span className="font-medium text-slate-900">{item.no}</span>
                        <span className="text-slate-600"> — {item.description || 'No description'}</span>
                        {item.brand || item.model || item.specification ? (
                          <span className="block text-slate-500">
                            {[[item.brand, item.model].filter(Boolean).join(' / '), item.specification].filter(Boolean).join(' · ')}
                          </span>
                        ) : null}
                      </span>
                      <span className="shrink-0 text-teal-800">
                        {quantityLabel(Number(item.available ?? 0))} {item.unitOfMeasure} in stock
                      </span>
                    </button>
                  </li>
                )
              })}
            </ul>
          ) : (
            <p className="text-xs text-slate-600">
              No item in stock at {itemsQuery.data?.issuingStore || 'the issuing store'} matches. If there is no similar
              item, use Request for LPR.
            </p>
          )
        ) : null}
        {selected ? (
          <div className="flex max-w-xl flex-wrap items-end gap-2">
            <div className="min-w-0 flex-1 text-xs text-slate-700">
              Selected: <strong>{selected.no}</strong> — {selected.description} ({quantityLabel(Number(selected.available ?? 0))}{' '}
              {selected.unitOfMeasure} in stock)
            </div>
            <label className="space-y-1 text-xs font-medium text-slate-700">
              Qty to issue
              <Input
                type="number"
                min={0}
                step="any"
                value={quantity}
                onChange={(event) => setQuantity(event.target.value)}
                className="w-28"
              />
            </label>
            <Button
              type="button"
              variant="gradient"
              disabled={busy || !(Number(quantity) > 0)}
              onClick={() => void addOffer()}
            >
              Add Item to Issue
            </Button>
          </div>
        ) : null}
      </div>

      {!withManager ? (
        <div className="flex flex-wrap gap-2 border-t border-slate-100 pt-3">
          {declined ? (
            <>
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
              <Button
                type="button"
                variant="outline"
                disabled={busy}
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
      ) : null}
    </div>
  )
}
