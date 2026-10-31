import type { PortalNotification } from '@/api/endpoints/notifications'

/** The requester pages of the modules (each opens a request with ?open=<id>). */
export const REQUEST_PAGES: Partial<Record<string, string>> = {
  imprest: '/finance/imprest',
  imprestSurrender: '/finance/imprest-surrender',
  staffClaim: '/finance/staff-claim',
  pettyCash: '/finance/petty-cash',
  purchaseRequisition: '/facility/local-purchase-request',
  storeRequisition: '/facility/store-requisition',
}

/** The module page, opened on one request when `requestId` is given. */
export function requestPageHref(module: string, requestId?: string) {
  const page = REQUEST_PAGES[module]
  if (!page) return null
  return requestId ? `${page}?open=${encodeURIComponent(requestId)}` : page
}

/** Where a notification leads: the approval or request itself when it is one, else its list. */
export function notificationHref(item: PortalNotification) {
  if (item.kind === 'approvals') {
    return item.requestId ? `/approvals/${item.requestId}?queue=pending` : '/approvals'
  }
  // Several Local Purchase documents: My Approvals lists every LPR waiting for the user.
  if (item.kind === 'localPurchase' && !item.requestId) return '/approvals'

  const href = (item.module && requestPageHref(item.module, item.requestId)) || '/'
  return item.requestId && item.focus ? `${href}&focus=${encodeURIComponent(item.focus)}` : href
}
