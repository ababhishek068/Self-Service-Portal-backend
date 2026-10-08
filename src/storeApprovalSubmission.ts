import type { ODataRecord } from './bcClient.js'
import { documentStatusFromBc, statusFromBc } from './erpMappings.js'

/** Historical approval entries do not prove that a new Store submission succeeded. */
export function storeApprovalSubmissionComplete(header: ODataRecord, entries: ODataRecord[]) {
  const active = entries.some((entry) => ['open', 'created', 'pending', 'pending approval']
    .includes(String(entry.Status ?? '').trim().toLowerCase()))
  const status = statusFromBc(documentStatusFromBc(header, 'storeRequisition'))
  return (status === 'Pending Approval' && active) || status === 'Approved' || status === 'Posted'
}

const inFlight = new Map<string, Promise<void>>()

/** Coalesce simultaneous retries; never cache failures or completed approval cycles. */
export function runStoreApprovalOnce(key: string, action: () => Promise<void>): Promise<void> {
  const existing = inFlight.get(key)
  if (existing) return existing
  const pending = Promise.resolve().then(action).finally(() => inFlight.delete(key))
  inFlight.set(key, pending)
  return pending
}
