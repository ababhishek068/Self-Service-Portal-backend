import type { ODataRecord } from '../../infrastructure/bc/client.js'

/** Convert the portal's normal/first-half/second-half selection to BC's Boolean flag. */
export function isHalfDaySelection(value: string) {
  return value !== '0'
}

/** ESS sends 0/1/2 to GetLeaveDates; it is not the same as the LeaveApplication Boolean. */
export function halfDayOptionValue(value: string) {
  const normalized = String(value ?? '0').trim()
  if (normalized === '1' || normalized === '2') return Number(normalized)
  return 0
}

export function leaveTypeIsAnnual(row: ODataRecord | null | undefined) {
  if (!row) return false
  const annual = row.Annual ?? row.annual
  if (typeof annual === 'boolean') return annual
  if (typeof annual === 'string') {
    const normalized = annual.trim().toLowerCase()
    return normalized === 'yes' || normalized === 'true'
  }
  return String(row.Code ?? '') === '0001'
}

export function halfDayRequiresAnnualLeave(value: string) {
  return halfDayOptionValue(value) !== 0
}

/** Business Central SOAP dates must use yyyy-mm-dd (locale-neutral). */
export function formatBcSoapDate(value: string) {
  const trimmed = value.trim()
  if (!trimmed) return ''

  const isoDash = /^(\d{4})-(\d{2})-(\d{2})/.exec(trimmed)
  if (isoDash) return `${isoDash[1]}-${isoDash[2]}-${isoDash[3]}`

  const normalized = trimmed.replaceAll('_', '/')
  const mdY = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(normalized)
  if (mdY) {
    const [, month, day, year] = mdY
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }

  const mdYShort = /^(\d{1,2})\/(\d{1,2})\/(\d{2})$/.exec(normalized)
  if (mdYShort) {
    const [, month, day, shortYear] = mdYShort
    const year = Number(shortYear) >= 70 ? 1900 + Number(shortYear) : 2000 + Number(shortYear)
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }

  const ymdSlash = /^(\d{4})\/(\d{1,2})\/(\d{1,2})$/.exec(normalized)
  if (ymdSlash) {
    const [, year, month, day] = ymdSlash
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }

  const parsed = new Date(normalized)
  if (!Number.isNaN(parsed.getTime())) {
    const year = parsed.getFullYear()
    const month = String(parsed.getMonth() + 1).padStart(2, '0')
    const day = String(parsed.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }

  return normalized
}

export function normalizeLeaveStartDate(value: string) {
  return formatBcSoapDate(value)
}

export function parseLeaveDatesReturn(rawValue: unknown) {
  const raw = String(rawValue ?? '').trim()
  let endDate = ''
  let returnDate = ''
  if (!raw) return { endDate, returnDate }
  for (const segment of raw.split('#')) {
    const [key, value] = segment.split('=')
    const normalizedKey = key?.trim().toLowerCase() ?? ''
    if (normalizedKey === 'enddate') endDate = (value ?? '').trim()
    if (normalizedKey === 'returndate') returnDate = (value ?? '').trim()
  }
  return { endDate, returnDate }
}
