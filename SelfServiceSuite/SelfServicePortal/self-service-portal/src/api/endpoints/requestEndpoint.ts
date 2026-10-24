import { authDelete, authGet, authHttp, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type { PortalModuleKey, PortalRequest } from '@/types/erp.types'

export interface EndpointConfig {
  module: PortalModuleKey
  entity: string
}

export async function listModuleRequests(config: EndpointConfig, params?: Record<string, string | undefined>) {
  requireAuthApiUrl()
  return authGet<PortalRequest[]>('/api/requests', { params: { module: config.module, ...params } })
}

export async function getModuleRequest(_config: EndpointConfig, id: string) {
  requireAuthApiUrl()
  return authGet<PortalRequest>(`/api/requests/${encodeURIComponent(id)}`)
}

export async function createModuleRequest(config: EndpointConfig, payload: Record<string, unknown>) {
  requireAuthApiUrl()
  return authPost<PortalRequest>(
    '/api/requests',
    { ...payload, module: config.module },
    { timeout: 45000 } as Parameters<typeof authPost>[2],
  )
}

export async function cancelModuleRequest(_config: EndpointConfig, id: string) {
  requireAuthApiUrl()
  return authPost<PortalRequest>(`/api/requests/${encodeURIComponent(id)}/cancel`, {})
}

export async function submitModuleRequest(_config: EndpointConfig, id: string) {
  requireAuthApiUrl()
  return authPost<PortalRequest>(`/api/requests/${encodeURIComponent(id)}/submit`, {})
}

export async function deleteModuleRequest(_config: EndpointConfig, id: string) {
  requireAuthApiUrl()
  return authDelete<void>(`/api/requests/${encodeURIComponent(id)}`)
}

export async function updateRequestHeader(id: string, patch: Record<string, unknown>) {
  requireAuthApiUrl()
  return authHttp.patch<PortalRequest>(`/api/requests/${encodeURIComponent(id)}`, patch).then((r) => r.data)
}

export async function addRequestLine(id: string, line: Record<string, unknown>) {
  requireAuthApiUrl()
  return authPost<PortalRequest>(`/api/requests/${encodeURIComponent(id)}/lines`, line)
}

export async function setRequestLines(id: string, lines: Record<string, unknown>[]) {
  requireAuthApiUrl()
  return authHttp.put<PortalRequest>(`/api/requests/${encodeURIComponent(id)}/lines`, { lines }).then((r) => r.data)
}

export async function updateRequestLine(id: string, lineId: string, patch: Record<string, unknown>) {
  requireAuthApiUrl()
  return authHttp
    .patch<PortalRequest>(`/api/requests/${encodeURIComponent(id)}/lines/${encodeURIComponent(lineId)}`, patch)
    .then((r) => r.data)
}

export async function deleteRequestLine(id: string, lineId: string) {
  requireAuthApiUrl()
  return authDelete<PortalRequest>(`/api/requests/${encodeURIComponent(id)}/lines/${encodeURIComponent(lineId)}`)
}

export async function getPurchaseProcurementProcess(id: string) {
  requireAuthApiUrl()
  return authGet<Record<string, unknown>>(`/api/requests/${encodeURIComponent(id)}/procurement-process`)
}

export async function updatePurchaseProcurementProcess(
  id: string,
  actionCode: string,
  linkedDocumentNo = '',
  actionComment = '',
) {
  requireAuthApiUrl()
  return authPost<{ process: Record<string, unknown>; request: PortalRequest }>(
    `/api/requests/${encodeURIComponent(id)}/procurement-process`,
    { actionCode, linkedDocumentNo, actionComment },
  )
}

export async function getStoreRequisitionProcess(id: string) {
  requireAuthApiUrl()
  return authGet<Record<string, unknown>>(`/api/requests/${encodeURIComponent(id)}/store-process`)
}

async function downloadRequestPdf(id: string, path: string, filename: string) {
  requireAuthApiUrl()
  const response = await authHttp.get<Blob>(
    `/api/requests/${encodeURIComponent(id)}/${path}`,
    { responseType: 'blob' },
  )
  const url = URL.createObjectURL(response.data)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  link.remove()
  URL.revokeObjectURL(url)
}

export async function downloadStoreRequisitionVoucher(id: string, requestNo: string) {
  return downloadRequestPdf(id, 'requisition-voucher', `Store-Requisition-${requestNo}.pdf`)
}

export async function downloadStoreBorrowingForm(id: string, requestNo: string) {
  return downloadRequestPdf(id, 'borrowing-form', `Item-Borrowing-Form-${requestNo}.pdf`)
}

/** Item Borrowing Form as a blob URL for the in-page viewer (revoke it when the viewer closes). */
export async function getStoreBorrowingFormUrl(id: string) {
  requireAuthApiUrl()
  const response = await authHttp.get<Blob>(
    `/api/requests/${encodeURIComponent(id)}/borrowing-form`,
    { responseType: 'blob' },
  )
  return URL.createObjectURL(new Blob([response.data], { type: 'application/pdf' }))
}

/** Store Issuance Voucher (GIV) — exists after the requester accepts the item. */
export async function downloadStoreIssueVoucher(id: string, storeIssueNo: string) {
  return downloadRequestPdf(id, 'store-issue-voucher', `Store-Issuance-Voucher-${storeIssueNo}.pdf`)
}

export interface StoreRequisitionStore {
  code: string
  name: string
  locationCode: string
  centralStore: boolean
  defaultIssueStore: boolean
}

export interface StoreUnitOfMeasure {
  code: string
  description: string
}

/** Officer and approver user IDs from BC ABH Local Proc Setup. */
export interface LprOfficers {
  procurementOfficer: string
  projectProcurementOfficer: string
  operationsManager: string
  fad: string
}

/** BC lookups for the store requisition form. A list is null when BC does not publish it yet. */
export interface StoreRequisitionOptions {
  stores: StoreRequisitionStore[] | null
  /** False while BC has no store list yet (portal uses the ABH store list until BC 1.0.3.544). */
  storesFromBc?: boolean
  unitsOfMeasure: StoreUnitOfMeasure[] | null
  projects: LocalPurchaseProject[] | null
  lprOfficers?: LprOfficers | null
  /** Store steps this BC app runs from the portal (storeHandOff, storeOffers, …). */
  features?: string[]
}

/** In-stock item the Store Keeper can offer (Add Item to Issue). */
export interface StoreOfferItem {
  no: string
  description: string
  unitOfMeasure: string
  /** Stock at the request's issuing store (what BC can issue). */
  available: number
  /** Stock in all stores (BC Quantity on Hand); BC 1.0.3.547+. */
  onHand?: number
  brand?: string
  model?: string
  /** Item card Details/Specification. */
  specification?: string
  category?: string
}

export async function getStoreOfferItems(id: string, search: string) {
  requireAuthApiUrl()
  return authGet<{ issuingStore: string; items: StoreOfferItem[] }>(
    `/api/requests/${encodeURIComponent(id)}/store-offer-items`,
    { params: { search } },
  )
}

/** Store Manager / Store Keeper for the signed-in user (portal job title or BC Warehouse Employees / store card). */
export async function getMyStoreRoles() {
  requireAuthApiUrl()
  return authGet<{ storeManager: boolean; storeKeeper: boolean }>('/api/store-requisition/my-roles')
}

export async function getStoreRequisitionOptions() {
  requireAuthApiUrl()
  return authGet<StoreRequisitionOptions>('/api/store-requisition/options')
}

/**
 * `linkedDocumentNo` on START_LPR is the BC project No. (blank = non-project purchase);
 * `options` carries the Start LPR source and officer (procurementSource, officerType).
 */
export async function updateStoreRequisitionProcess(
  id: string,
  actionCode: string,
  linkedDocumentNo = '',
  options: Record<string, string | number> = {},
) {
  requireAuthApiUrl()
  return authPost<{ process: Record<string, unknown>; request: PortalRequest }>(
    `/api/requests/${encodeURIComponent(id)}/store-process`,
    { actionCode, ...(linkedDocumentNo ? { linkedDocumentNo } : {}), ...options },
  )
}

export async function receiveStoreRequestLine(
  id: string,
  lineId: string,
  payload: { quantityToReceive: number; reason?: string },
) {
  requireAuthApiUrl()
  return authHttp
    .patch<PortalRequest>(
      `/api/requests/${encodeURIComponent(id)}/lines/${encodeURIComponent(lineId)}/receive`,
      payload,
    )
    .then((r) => r.data)
}

export async function postStoreRequestReceipt(id: string) {
  requireAuthApiUrl()
  return authPost<PortalRequest>(`/api/requests/${encodeURIComponent(id)}/post-receipt`, {})
}

export async function uploadRequestAttachment(id: string, attachment: Record<string, unknown>) {
  requireAuthApiUrl()
  return authPost<PortalRequest>(`/api/requests/${encodeURIComponent(id)}/attachments`, attachment)
}

export async function deleteRequestAttachment(id: string, attachmentId: string) {
  requireAuthApiUrl()
  return authDelete<PortalRequest>(
    `/api/requests/${encodeURIComponent(id)}/attachments/${encodeURIComponent(attachmentId)}`,
  )
}

export async function downloadRequestAttachment(
  requestId: string,
  attachment: { id: string; fileName: string; fileType: string },
) {
  requireAuthApiUrl()
  const response = await authHttp.get<Blob>(
    `/api/requests/${encodeURIComponent(requestId)}/attachments/${encodeURIComponent(attachment.id)}/download`,
    {
      params: { fileName: attachment.fileName, fileType: attachment.fileType },
      responseType: 'blob',
    },
  )
  const url = URL.createObjectURL(response.data)
  const link = document.createElement('a')
  link.href = url
  link.download = attachment.fileName
  document.body.appendChild(link)
  link.click()
  link.remove()
  URL.revokeObjectURL(url)
}

export interface LocalPurchaseNextAction {
  actionCode: string
  label: string
  target: 'lpr' | 'rfq' | 'po' | 'storeRequisition'
  documentNo: string
  allowed: boolean
  ownerRoles: string[]
  commentRequired?: boolean
}

export interface LocalPurchaseVendorQuote {
  rfqNo: string
  lineNo: number
  vendorNo: string
  vendorName: string
  quotedAmount: number
  leadTimeDays: number
  quoteDate: string
  rank: number
  selected: boolean
  notes: string
  attachments: number
}

export interface LocalPurchaseState {
  chain: {
    documentNo?: string
    storeRequisitionNo?: string
    /** BC 1.0.3.567+: the store requisition behind the LPR (Store Request group of the card). */
    storeRequest?: Record<string, unknown>
    lpr?: Record<string, unknown>
    rfq?: Record<string, unknown>
    po?: Record<string, unknown>
    receipts?: Array<Record<string, unknown>>
  }
  quotes: { rfqNo?: string; quotes?: LocalPurchaseVendorQuote[] }
  roles: string[]
  nextActions: LocalPurchaseNextAction[]
  /** BC card rule + Procurement role: the card (General and lines) can be edited (BC 1.0.3.568). */
  cardEditable?: boolean
  /** BC 1.0.3.569: which cards the signed-in user may edit now (BC's rule per card + the owning role). */
  editing?: { lpr: boolean; rfq: boolean; po: boolean; receive: boolean }
}

export interface LocalPurchaseWaitingItem {
  id: string
  requestNo: string
  title: string
  requester: string
  storeRequisitionNo: string
  stage: string
  processStep: string
  actions: string[]
}

/** Store LPRs where the signed-in user has a step to do now (BC stage + Local Proc Setup roles). */
export async function getLocalPurchaseWaiting() {
  requireAuthApiUrl()
  return authGet<{ items: LocalPurchaseWaitingItem[] }>('/api/local-purchase/waiting')
}

/** Local Purchase chain: Store Req ↔ LPR ↔ Local RFQ ↔ Vendor Quotes ↔ PO ↔ GRN ↔ Invoice. */
export async function getLocalPurchaseState(id: string) {
  requireAuthApiUrl()
  return authGet<LocalPurchaseState>(`/api/requests/${encodeURIComponent(id)}/local-purchase`)
}

/** BC "Open Store Requisition" on an LPR: the store requisition it was started from (read-only). */
export async function getLprStoreRequisition(id: string) {
  requireAuthApiUrl()
  return authGet<{ request: PortalRequest; process: Record<string, unknown> | null }>(
    `/api/requests/${encodeURIComponent(id)}/local-purchase/store-requisition`,
  )
}

export async function runLocalPurchaseAction(
  id: string,
  body: {
    actionCode: string
    documentNo: string
    linkedDocumentNo?: string
    actionComment?: string
    payload?: Record<string, unknown>
  },
) {
  requireAuthApiUrl()
  return authPost<{ result: Record<string, unknown>; request: PortalRequest | null }>(
    `/api/requests/${encodeURIComponent(id)}/local-purchase`,
    body,
    { timeout: 90000 } as Parameters<typeof authPost>[2],
  )
}

export async function upsertLocalPurchaseVendorQuote(
  id: string,
  quote: {
    rfqNo: string
    vendorNo: string
    quotedAmount: number
    leadTimeDays: number
    quoteDate?: string
    notes?: string
    lineNo?: number
  },
) {
  requireAuthApiUrl()
  return authPost<{ result: Record<string, unknown>; quotes: LocalPurchaseState['quotes'] }>(
    `/api/requests/${encodeURIComponent(id)}/vendor-quotes`,
    quote,
  )
}

export async function uploadLocalPurchaseQuoteAttachment(
  id: string,
  lineNo: number,
  attachment: { rfqNo: string; fileName: string; contentBase64: string; description: string },
) {
  requireAuthApiUrl()
  return authPost<{ result: Record<string, unknown>; quotes: LocalPurchaseState['quotes'] }>(
    `/api/requests/${encodeURIComponent(id)}/vendor-quotes/${lineNo}/attachments`,
    attachment,
    { timeout: 60000 } as Parameters<typeof authPost>[2],
  )
}

export interface LocalPurchaseAccess {
  /** False until BC has the Local Purchase portal methods; then 382 behaviour applies. */
  enabled: boolean
  roles: string[]
}

/** BC-driven Local Purchase availability and the signed-in user's LPR roles (ABH Local Proc Setup). */
export async function getLocalPurchaseAccess() {
  requireAuthApiUrl()
  return authGet<LocalPurchaseAccess>('/api/local-purchase/access')
}

export interface LocalPurchaseProject {
  no: string
  description?: string
}

export interface LocalPurchaseBankAccount {
  no: string
  name?: string
  currencyCode?: string
}

/** BC projects (Job) for Start LPR — project first, then BC assigns the officer. */
export async function getLocalPurchaseProjects() {
  requireAuthApiUrl()
  return authGet<{ projects: LocalPurchaseProject[] }>('/api/local-purchase/projects')
}

/** BC bank accounts for Pay Vendor & Close LPR (Finance Checker). */
export async function getLocalPurchaseBankAccounts() {
  requireAuthApiUrl()
  return authGet<{ bankAccounts: LocalPurchaseBankAccount[] }>('/api/local-purchase/bank-accounts')
}
