import { useState, type ReactNode } from 'react'
import { CheckCircle2, ClipboardList, PackageCheck, PackagePlus, Trash2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import type { PortalRequest } from '@/types/erp.types'
import { quantityLabel, storeOfferLines } from './storeOfferLines'
import { StoreItemPickerDialog } from './StoreItemPickerDialog'
import { RequestedSummary } from './StoreStockPill'

type StoreAction = (
  actionCode: string,
  title: string,
  message: string,
  extra?: Record<string, string | number>,
  confirmFirst?: boolean,
) => Promise<boolean>

/**
 * Store Keeper on an approved store requisition — the BC Store Req Header Approved steps:
 * Add Item to Issue (the real item in stock, picked in a dialog), Submit to Store Manager; after
 * the requester declines, Offer Another Item or Close Request.
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
  const [pickerOpen, setPickerOpen] = useState(false)

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

      <div className="grid gap-3 px-4 py-4 md:grid-cols-2">
        <div className="rounded-lg border border-dashed border-slate-200 bg-slate-50/70 px-3 py-2.5">
          <p className="flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-slate-500">
            <ClipboardList className="h-3.5 w-3.5" /> Requested by the employee
          </p>
          <div className="mt-1.5">
            {requestedLines.length ? (
              <RequestedSummary lines={requestedLines} />
            ) : (
              <p className="text-sm text-slate-500">—</p>
            )}
          </div>
        </div>

        <div
          className={cn(
            'rounded-lg border px-3 py-2.5',
            offers.length ? 'border-emerald-200 bg-emerald-50/40' : 'border-dashed border-teal-200 bg-white',
          )}
        >
          <div className="flex items-center justify-between gap-2">
            <p className="flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wide text-slate-500">
              <PackageCheck className="h-3.5 w-3.5" /> Offered by the store
            </p>
            {offers.length ? (
              <button
                type="button"
                disabled={busy}
                onClick={() => setPickerOpen(true)}
                className="inline-flex items-center gap-1 rounded-md px-2 py-1 text-xs font-semibold text-[var(--portal-navy-dark)] hover:bg-teal-50 disabled:opacity-50"
              >
                <PackagePlus className="h-3.5 w-3.5" /> Add another
              </button>
            ) : null}
          </div>
          {offers.length ? (
            <ul className="mt-1.5 divide-y divide-emerald-100">
              {offers.map((offer) => {
                const onHand = available[offer.itemNo.toUpperCase()]
                const short = onHand !== undefined && onHand < offer.quantity
                return (
                  <li key={offer.lineNo} className="flex items-start gap-2 py-1.5 first:pt-0 last:pb-0">
                    <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0 text-emerald-600" />
                    <div className="min-w-0 flex-1">
                      <p className="text-sm font-semibold text-slate-900">
                        {offer.itemName || offer.itemNo}
                        <span className="ml-1.5 font-mono text-[11px] font-normal text-slate-500">{offer.itemNo}</span>
                      </p>
                      <p className="text-xs text-slate-500">
                        Issue {quantityLabel(offer.quantity)} {offer.unitOfMeasure}
                        {offer.brandModel ? ` · ${offer.brandModel}` : ''}
                        {onHand !== undefined ? (
                          <span className={short ? ' font-semibold text-red-700' : ''}>
                            {short ? ` · only ${quantityLabel(onHand)} in stock` : ` · ${quantityLabel(onHand)} in stock`}
                          </span>
                        ) : null}
                      </p>
                      {offer.specification ? <p className="truncate text-xs text-slate-500">{offer.specification}</p> : null}
                    </div>
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
          ) : (
            <div className="flex flex-col items-start gap-2 py-1.5">
              <p className="text-sm text-slate-600">Pick the item in stock that you will issue.</p>
              <Button type="button" variant="gradient" size="sm" disabled={busy} onClick={() => setPickerOpen(true)}>
                <PackagePlus className="h-4 w-4" /> Add Item to Issue
              </Button>
            </div>
          )}
        </div>
      </div>

      <div className="flex flex-wrap items-center justify-between gap-3 border-t border-slate-100 bg-slate-50/70 px-4 py-3">
        <p className="text-xs text-slate-600">{footerHint}</p>
        <div className="flex flex-wrap items-center gap-2">
          {/* Request for LPR only before an item is offered (the LPR buys the item instead). */}
          {offers.length === 0 ? secondaryAction : null}
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

      {pickerOpen ? (
        <StoreItemPickerDialog
          requestId={request.id}
          requestNo={requestNo}
          requestedLines={requestedLines}
          requested={requested}
          busy={busy}
          onClose={() => setPickerOpen(false)}
          onAdd={(item, quantity) =>
            run('ADD_STORE_OFFER', 'Add Item to Issue', '', { itemNo: item.no, quantity }, false)
          }
        />
      ) : null}
    </div>
  )
}
