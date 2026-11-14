/**
 * Integration-safe create (ABH ESSP Advance Request spec §5: "Prevent duplicate submission caused
 * by repeated clicks or network retries; use a submission state and an integration-safe request
 * identifier"). The form sends one `clientRequestId` per form; a repeat of the same id within the
 * window gets the document the first call created instead of a second Business Central document.
 */
const WINDOW_MS = 30 * 60 * 1000
const inFlight = new Map<string, { at: number; promise: Promise<string> }>()

type WithDocumentNo = { documentNo?: unknown }

function documentNoOf(error: unknown) {
  return String((error as WithDocumentNo | null)?.documentNo ?? '').trim()
}

export function createOnce(key: string, run: () => Promise<string>, now = Date.now()): Promise<string> {
  for (const [entryKey, entry] of inFlight) {
    if (now - entry.at > WINDOW_MS) inFlight.delete(entryKey)
  }
  if (!key) return run()
  const existing = inFlight.get(key)
  if (existing) {
    // A repeat: the same document, even when the first call failed after BC created the draft.
    return existing.promise.catch((error: unknown) => {
      const documentNo = documentNoOf(error)
      if (documentNo) return documentNo
      throw error
    })
  }
  const promise = run()
  inFlight.set(key, { at: now, promise })
  promise.catch((error: unknown) => {
    // Nothing was created: let the user try again with the same form.
    if (!documentNoOf(error)) inFlight.delete(key)
  })
  return promise
}

export function createOnceKey(employeeNo: string, module: string, clientRequestId: unknown) {
  const id = String(clientRequestId ?? '').trim().slice(0, 80)
  return id ? `${employeeNo}|${module}|${id}` : ''
}
