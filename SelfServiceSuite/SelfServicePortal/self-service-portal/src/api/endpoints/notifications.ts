import { authGet } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export type PortalNotificationKind =
  | 'approvals'
  | 'returned'
  | 'storeIssue'
  | 'storeAccept'
  | 'storeLpr'
  | 'storeReceive'
  | 'localPurchase'

export interface PortalNotification {
  id: string
  kind: PortalNotificationKind
  count: number
  title: string
  description: string
  /** The page of the documents; with requestId, the one document. */
  module?: string
  requestId?: string
  /** The part of the request to scroll to (e.g. lpr-doc-rfq: the RFQ of an LPR). */
  focus?: string
}

export interface PortalNotifications {
  total: number
  items: PortalNotification[]
}

/**
 * What is waiting for the signed-in user: approvals, requests sent back, the store hand-off steps
 * and the Local Purchase (LPR → RFQ → PO → invoice) steps of their role.
 */
export async function getNotifications() {
  requireAuthApiUrl()
  return authGet<PortalNotifications>('/api/notifications')
}
