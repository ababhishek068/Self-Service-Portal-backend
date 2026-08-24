import { format, parseISO } from 'date-fns'

export const formatCurrency = (value: number) =>
  new Intl.NumberFormat('en-ET', {
    style: 'currency',
    currency: 'ETB',
    maximumFractionDigits: 0,
  }).format(value)

export const formatNumber = (value: number) =>
  new Intl.NumberFormat('en-ET', { maximumFractionDigits: 0 }).format(value)

/** Business Central serializes an unset Date as 0001-01-01. Never show it as a real portal date. */
export function isPlaceholderErpDate(value?: string | null) {
  const normalized = String(value ?? '').trim()
  return /^(?:0000|0001)-01-01(?:T|$)/.test(normalized)
}

function formatSingleDate(value: string): string {
  if (!value || isPlaceholderErpDate(value)) return '-'
  const trimmed = value.trim()

  const slash = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(trimmed)
  if (slash) {
    const first = Number(slash[1])
    const second = Number(slash[2])
    // Portal/BC finance dates are dd/mm/yyyy; only treat as mm/dd when day > 12.
    const day = first > 12 ? slash[1]! : second > 12 ? slash[2]! : slash[1]!
    const month = first > 12 ? slash[2]! : second > 12 ? slash[1]! : slash[2]!
    const iso = `${slash[3]}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
    const fromSlash = parseISO(iso)
    if (!Number.isNaN(fromSlash.getTime())) return format(fromSlash, 'dd MMM yyyy')
  }

  const parsed = parseISO(trimmed)
  return Number.isNaN(parsed.getTime()) ? trimmed : format(parsed, 'dd MMM yyyy')
}

export const formatDate = (value?: string): string => {
  if (!value || isPlaceholderErpDate(value)) return '-'
  const trimmed = String(value).trim()
  // Duration ranges from BC enrichment: "11/08/2026 – 22/08/2026"
  const rangeParts = trimmed.split(/\s*[–—-]\s*/).map((part) => part.trim()).filter(Boolean)
  if (rangeParts.length === 2) {
    const left = formatSingleDate(rangeParts[0]!)
    const right = formatSingleDate(rangeParts[1]!)
    if (left !== '-' && right !== '-') return `${left} – ${right}`
  }
  return formatSingleDate(trimmed)
}

export const formatDateTime = (value?: string) => {
  if (!value || isPlaceholderErpDate(value)) return '-'
  const parsed = parseISO(value)
  return Number.isNaN(parsed.getTime()) ? value : format(parsed, 'dd MMM yyyy, HH:mm')
}

/** Normalize BC / portal dates for HTML `<input type="date">` (yyyy-MM-dd). */
export function toHtmlDateInputValue(value?: unknown): string {
  const raw = String(value ?? '').trim()
  if (!raw || isPlaceholderErpDate(raw)) return ''

  const iso = /^(\d{4})-(\d{2})-(\d{2})/.exec(raw)
  if (iso) return `${iso[1]}-${iso[2]}-${iso[3]}`

  const normalized = raw.replaceAll('_', '/')
  const slash = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(normalized)
  if (slash) {
    const first = Number(slash[1])
    const second = Number(slash[2])
    const year = slash[3]
    let day: string
    let month: string
    if (first > 12) {
      day = slash[1]!
      month = slash[2]!
    } else if (second > 12) {
      month = slash[1]!
      day = slash[2]!
    } else {
      day = slash[1]!
      month = slash[2]!
    }
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }

  const parsed = parseISO(raw)
  return Number.isNaN(parsed.getTime()) ? '' : format(parsed, 'yyyy-MM-dd')
}

export const percent = (value: number) => `${Math.round(value)}%`

/** BC OData often returns 00:00:00 when a clock time has not been recorded yet. */
export function isRecordedAttendanceTime(value?: string | null) {
  if (!value || !String(value).trim()) return false
  const normalized = String(value).trim().replace(/\.\d+$/, '')
  if (!normalized || normalized === '—') return false
  const parts = normalized.split(':').map((part) => Number(part))
  if (parts.length >= 2 && parts.every((part) => Number.isFinite(part) && part === 0)) return false
  return true
}

export function formatAttendanceClock(value?: string | null) {
  if (!isRecordedAttendanceTime(value)) return '—'
  const raw = String(value).replace(/\.\d+$/, '').trim()
  const isoMatch = /^(\d{4}-\d{2}-\d{2})[T\s](\d{2}:\d{2}(?::\d{2})?)/.exec(raw)
  if (isoMatch) return isoMatch[2]
  return raw
}

export function formatAttendanceMac(value?: string | null) {
  const raw = String(value ?? '').trim()
  if (!raw || raw.toLowerCase() === 'mac unavailable') return '—'
  if (/latitude/i.test(raw) && /longitude/i.test(raw)) return '—'
  return raw.replace(/^MAC:\s*/i, '')
}
