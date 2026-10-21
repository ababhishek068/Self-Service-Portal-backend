import { callSoapMethod } from './bcClient.js'

/**
 * Business Central owns the attendance ledger and applies its own local clock.
 * Calling this method on an interval makes the 7:00 PM close independent of a
 * browser session while keeping all ledger updates and validation in ERP.
 */
export async function runAttendanceAutoSignOut() {
  const result = await callSoapMethod('RunAttendanceAutoSignOut', {})
  const closed = Number(result.returnValue ?? 0)
  return Number.isFinite(closed) ? closed : 0
}
