import { formatDate } from '@/utils/formatters'

/** BC card values: blank placeholders, first non-blank value, dates. */
export function text(value: unknown) {
  const raw = String(value ?? '').trim()
  return raw.startsWith('0001-01-01') || raw === '0' || raw === '_' ? '' : raw
}

/** First non-blank value (BC placeholders such as 0001-01-01, 0 and _ count as blank). */
export function pick(...values: unknown[]) {
  for (const value of values) {
    const found = text(value)
    if (found) return found
  }
  return ''
}

export function dateValue(value: string) {
  return value ? formatDate(value.slice(0, 10)) : ''
}

export function dateTimeValue(value: string) {
  if (!value) return ''
  const parsed = new Date(value)
  return Number.isNaN(parsed.getTime())
    ? value
    : parsed.toLocaleString(undefined, { dateStyle: 'medium', timeStyle: 'short' })
}
