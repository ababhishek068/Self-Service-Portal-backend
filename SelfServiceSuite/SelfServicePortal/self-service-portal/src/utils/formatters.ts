import { format, parseISO } from 'date-fns'

export const formatCurrency = (value: number) =>
  new Intl.NumberFormat('en-ET', {
    style: 'currency',
    currency: 'ETB',
    maximumFractionDigits: 0,
  }).format(value)

export const formatNumber = (value: number) =>
  new Intl.NumberFormat('en-ET', { maximumFractionDigits: 0 }).format(value)

export const formatDate = (value?: string) => {
  if (!value) return '-'
  const parsed = parseISO(value)
  return Number.isNaN(parsed.getTime()) ? value : format(parsed, 'dd MMM yyyy')
}

export const formatDateTime = (value?: string) => {
  if (!value) return '-'
  const parsed = parseISO(value)
  return Number.isNaN(parsed.getTime()) ? value : format(parsed, 'dd MMM yyyy, HH:mm')
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
  return String(value).replace(/\.\d+$/, '')
}

export function formatAttendanceMac(value?: string | null) {
  const raw = String(value ?? '').trim()
  if (!raw || raw.toLowerCase() === 'mac unavailable') return '—'
  if (/latitude/i.test(raw) && /longitude/i.test(raw)) return '—'
  return raw.replace(/^MAC:\s*/i, '')
}
