import type { PortalNotification } from '@/api/endpoints/notifications'

/** The requester pages of the modules (each opens a request with ?open=<id>). */
export const REQUEST_PAGES: Partial<Record<string, string>> = {
  imprest: '/finance/advance-request',
  imprestSurrender: '/finance/advance-settlement',
  staffClaim: '/finance/staff-claim',
  pettyCash: '/finance/petty-cash',
  purchaseRequisition: '/facility/local-purchase-request',
  storeRequisition: '/facility/store-requisition',
  leave: '/hr/leave-request',
  leaveApplication: '/hr/leave-request',
  // BC Stage 1 Overtime Requests (OTR-…) since BC 1.0.3.636.
  overtime: '/hr/overtime-work-request',
  overtimeWork: '/hr/overtime-work-request',
  overtimePayment: '/hr/overtime-request',
}

/**
 * The overtime document a link names: `?request=OTR-…` (the pages' own links) or `?open=<module>-<no>`
 * (Recent activity and the bell, which send the portal id).
 */
export function overtimeRequestParam(params: URLSearchParams) {
  const direct = params.get('request')?.trim()
  if (direct) return direct
  const open = params.get('open')?.trim() ?? ''
  return open.replace(/^(overtimeWork|overtimePayment|overtime)-/i, '') || null
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
