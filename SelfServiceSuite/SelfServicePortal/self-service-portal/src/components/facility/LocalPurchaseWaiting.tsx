import { useQuery } from '@tanstack/react-query'
import { ArrowUpRight, ShoppingCart } from 'lucide-react'
import { Link } from 'react-router-dom'
import { getLocalPurchaseWaiting } from '@/api/endpoints/requestEndpoint'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'

/**
 * My Approvals → Local Purchase: LPR steps are approved on the LPR itself (as on the BC card), not
 * through Requests to Approve, so FAD, the Operations Manager, officers and the Store Keeper see
 * here every LPR that is waiting for them.
 */
export function LocalPurchaseWaiting() {
  const access = useLocalPurchaseAccess()
  const waitingQuery = useQuery({
    queryKey: ['local-purchase', 'waiting'],
    queryFn: getLocalPurchaseWaiting,
    enabled: access.enabled && access.roles.length > 0,
    refetchInterval: 60_000,
    retry: false,
  })
  const items = waitingQuery.data?.items ?? []
  if (!access.enabled || access.roles.length === 0) return null
  if (waitingQuery.isLoading) {
    return (
      <p className="mb-5 rounded-xl border border-teal-200 bg-teal-50 px-4 py-3 text-sm text-teal-900">
        Checking Local Purchase (LPR) steps waiting for you…
      </p>
    )
  }
  if (items.length === 0) return null

  return (
    <section className="mb-5 overflow-hidden rounded-2xl border border-teal-200 bg-white shadow-sm">
      <div className="flex items-center gap-3 border-b border-teal-100 bg-teal-50 px-5 py-3">
        <span className="flex h-9 w-9 items-center justify-center rounded-full bg-teal-600 text-white">
          <ShoppingCart className="h-4 w-4" />
        </span>
        <div>
          <h2 className="text-base font-semibold text-teal-950">
            Local Purchase — {items.length} waiting for you
          </h2>
          <p className="text-xs text-teal-800">
            Approve or act on the LPR itself, as on the Business Central card. Open it to see the buttons.
          </p>
        </div>
      </div>
      <ul className="divide-y divide-slate-100">
        {items.map((item) => (
          <li key={item.id} className="flex flex-wrap items-center justify-between gap-3 px-5 py-3">
            <div className="min-w-0 flex-1">
              <p className="text-sm font-semibold text-slate-900">
                {item.requestNo}
                {item.title ? <span className="font-normal text-slate-600"> — {item.title}</span> : null}
              </p>
              <p className="mt-0.5 text-xs text-slate-500">
                {[
                  item.requester && `Requester ${item.requester}`,
                  item.storeRequisitionNo && `Store requisition ${item.storeRequisitionNo}`,
                  item.processStep || item.stage,
                ]
                  .filter(Boolean)
                  .join(' · ')}
              </p>
              <div className="mt-1.5 flex flex-wrap gap-1.5">
                {item.actions.map((action) => (
                  <span
                    key={action}
                    className="rounded-full bg-teal-100 px-2.5 py-0.5 text-[11px] font-semibold text-teal-900 ring-1 ring-teal-200"
                  >
                    {action}
                  </span>
                ))}
              </div>
            </div>
            <Link
              to={`/facility/local-purchase-request?open=${encodeURIComponent(item.id)}${
                item.focus ? `&focus=${encodeURIComponent(item.focus)}` : ''
              }`}
              className="inline-flex items-center gap-1.5 rounded-full bg-[var(--portal-navy)] px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:opacity-90"
            >
              Open LPR <ArrowUpRight className="h-4 w-4" />
            </Link>
          </li>
        ))}
      </ul>
    </section>
  )
}
