/**
 * Advance Payment after approval (BC 1.0.3.653+, ERP 1.0.3.660): Finance pays → the requester confirms
 * "I received the money" in ESSP → only then Advance Settlement. Read from the BC Imprest Header (QyImprestHeader).
 */
type AdvanceDocument = { status?: string; payload?: Record<string, unknown> }

function payloadFlag(request: AdvanceDocument, keys: string[]) {
  const payload = request.payload ?? {}
  return keys.some((key) => payload[key] === true || String(payload[key] ?? '').toLowerCase() === 'true')
}

/** BC counts an advance as paid once Payment Schedule posting marked it Fully Paid, or it was posted. */
export function advancePaid(request: AdvanceDocument) {
  return request.status === 'Posted' || payloadFlag(request, ['FullyPaid', 'Fully_Paid', 'Posted'])
}

export function receiptConfirmed(request: AdvanceDocument) {
  return payloadFlag(request, ['ReceiptConfirmed', 'Receipt_Confirmed'])
}

export function fullySettled(request: AdvanceDocument) {
  return /^full/i.test(String(request.payload?.SurrenderStatus ?? request.payload?.Surrender_Status ?? '').trim())
}

/** Approved (or posted) advance that Finance paid and the requester has not confirmed yet. */
export function awaitingReceiptConfirmation(request: AdvanceDocument) {
  return ['Approved', 'Posted'].includes(String(request.status ?? '')) && advancePaid(request) && !receiptConfirmed(request)
}
