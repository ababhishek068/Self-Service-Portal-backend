import type { ODataRecord } from '../infrastructure/bc/client.js'

export function fieldText(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

export function odataNumber(row: ODataRecord, keys: string[], fallback = 0) {
  const parsed = Number(fieldText(row, keys))
  return Number.isFinite(parsed) ? parsed : fallback
}

export function numericCode(
  value: unknown,
  labels: Record<string, number>,
  fallback = 0,
) {
  const raw = String(value ?? '').trim()
  if (/^\d+$/.test(raw)) return Number(raw)
  return labels[raw.toLowerCase()] ?? fallback
}
