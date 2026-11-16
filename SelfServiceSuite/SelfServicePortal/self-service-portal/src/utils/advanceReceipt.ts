/**
 * Advance Payment after approval (BC 1.0.3.653+, ERP 1.0.3.660): Finance pays → the requester confirms
 * "I received the money" in ESSP → only then Advance Settlement. Read from the BC Imprest Header (QyImprestHeader).
 * BC 1.0.3.662: the confirmation is possible right after approval; settlement still needs Finance's payment in BC.
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

/**
 * Approved (or posted) advance whose receipt the requester has not confirmed yet: once Finance paid it in BC, or
 * from approval on with BC 1.0.3.662 (`receiptAfterApproval`, like the Store receipt).
 */
export function awaitingReceiptConfirmation(request: AdvanceDocument, receiptAfterApproval = false) {
  return (
    ['Approved', 'Posted'].includes(String(request.status ?? '')) &&
    (receiptAfterApproval || advancePaid(request)) &&
    !receiptConfirmed(request) &&
    !fullySettled(request)
  )
}
