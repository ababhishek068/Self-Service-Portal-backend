import { formatDate } from '@/utils/formatters'

/**
 * BC 1.0.3.667 (client comments, 17 Nov 2026): an advance must be settled within 7 days of its activity end date
 * (overdue ones are reminded in the bell and by a daily BC e-mail), and an employee with 4 advances not settled cannot
 * request a new one until one is settled. Business Central counts an advance from submission until its settlement is
 * posted. Both the Advance Request and the Advance Settlement contexts carry this as `outstanding`.
 */
export type OutstandingAdvance = {
  advanceNo: string
  purpose: string
  requestPurposeText: string
  amount: number
  status: string
  /**
   * pendingApproval, awaitingPayment, confirmReceipt (paid, receipt not confirmed), paymentNotRecorded (received,
   * Finance's payment not in BC yet), readyToSettle, settlementDraft, settlementSubmitted.
   */
  stage: string
  settlementNo: string
  activityEndDate: string
  /** Activity end date + `settlementDueDays`; blank when the advance has no activity dates. */
  settlementDueDate: string
  overdue: boolean
  daysOverdue: number
}

export type AdvanceOutstanding = {
  maxUnsettled: number
  settlementDueDays: number
  unsettledCount: number
  overdueCount: number
  canRequest: boolean
  advances: OutstandingAdvance[]
}

const text = (value: unknown) => (value === undefined || value === null ? '' : String(value).trim())
const number = (value: unknown) => (Number.isFinite(Number(value)) ? Number(value) : 0)
const yes = (value: unknown) => value === true || ['true', '1', 'yes'].includes(text(value).toLowerCase())
const date = (value: unknown) => {
  const day = text(value).slice(0, 10)
  return /^\d{4}-\d{2}-\d{2}$/.test(day) && !day.startsWith('0001-') ? day : ''
}

/** The `outstanding` block of a BC context; null on BC before 1.0.3.667. */
export function parseAdvanceOutstanding(value: unknown): AdvanceOutstanding | null {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return null
  const raw = value as Record<string, unknown>
  const advances = (Array.isArray(raw.advances) ? raw.advances : [])
    .filter((row): row is Record<string, unknown> => Boolean(row) && typeof row === 'object')
    .map((row) => ({
      advanceNo: text(row.advanceNo),
      purpose: text(row.purpose),
      requestPurposeText: text(row.requestPurposeText),
      amount: number(row.amount),
      status: text(row.status),
      stage: text(row.stage),
      settlementNo: text(row.settlementNo),
      activityEndDate: date(row.activityEndDate),
      settlementDueDate: date(row.settlementDueDate),
      overdue: yes(row.overdue),
      daysOverdue: Math.max(0, Math.trunc(number(row.daysOverdue))),
    }))
    .filter((row) => row.advanceNo)
  const maxUnsettled = Math.max(0, Math.trunc(number(raw.maxUnsettled)))
  const unsettledCount = Math.max(advances.length, Math.trunc(number(raw.unsettledCount)))
  return {
    maxUnsettled,
    settlementDueDays: Math.max(0, Math.trunc(number(raw.settlementDueDays))) || 7,
    unsettledCount,
    overdueCount: advances.filter((row) => row.overdue).length,
    canRequest: raw.canRequest === undefined ? !(maxUnsettled > 0 && unsettledCount >= maxUnsettled) : yes(raw.canRequest),
    advances,
  }
}

/** What the employee does next for an advance not settled (short, for lists). */
export function outstandingStageLabel(row: OutstandingAdvance) {
  switch (row.stage) {
    case 'pendingApproval':
      return 'Waiting for approval'
    case 'awaitingPayment':
      return 'Approved, waiting for Finance to pay'
    case 'confirmReceipt':
      return 'Paid: confirm you received the money'
    case 'paymentNotRecorded':
      return 'Received: Finance records the payment'
    case 'readyToSettle':
      return 'Ready to settle'
    case 'settlementDraft':
      return row.settlementNo ? `Settlement ${row.settlementNo} saved, not submitted` : 'Settlement saved, not submitted'
    case 'settlementSubmitted':
      return row.settlementNo ? `Settlement ${row.settlementNo} with Finance` : 'Settlement with Finance'
    default:
      return row.status || 'Not settled'
  }
}

/** Where the employee acts on it: the open settlement, else the advance. */
export function outstandingHref(row: OutstandingAdvance) {
  if (row.settlementNo && (row.stage === 'settlementDraft' || row.stage === 'settlementSubmitted')) {
    return `/finance/advance-settlement?open=${encodeURIComponent(`imprestSurrender-${row.settlementNo}`)}`
  }
  return `/finance/advance-request?open=${encodeURIComponent(`imprest-${row.advanceNo}`)}`
}

/** "Overdue 3 days · due 12 Nov 2026", "Settle by 24 Nov 2026", or '' (no activity dates, or nothing to do yet). */
export function settleByText(row: OutstandingAdvance) {
  if (!row.settlementDueDate) return ''
  if (row.overdue) {
    const late = row.daysOverdue > 0 ? `Overdue ${row.daysOverdue} day${row.daysOverdue === 1 ? '' : 's'}` : 'Overdue'
    return `${late} · due ${formatDate(row.settlementDueDate)}`
  }
  return row.stage === 'pendingApproval' || row.stage === 'settlementSubmitted' ? '' : `Settle by ${formatDate(row.settlementDueDate)}`
}
