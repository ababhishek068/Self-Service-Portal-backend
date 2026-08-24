import type { LookupOption } from '@/api/endpoints/lookups'

/** Match a BC lookup option by code or label (ERP often stores names on the employee card). */
export function matchLookupOption(options: LookupOption[], candidate: string): string {
  const trimmed = candidate.trim()
  if (!trimmed || options.length === 0) return trimmed

  const normalized = trimmed.toLowerCase()
  const exactValue = options.find((option) => option.value === trimmed)
  if (exactValue) return exactValue.value

  const exactLabel = options.find((option) => option.label === trimmed)
  if (exactLabel) return exactLabel.value

  const prefixLabel = options.find((option) => {
    const label = option.label.trim()
    if (label.toLowerCase() === normalized) return true
    const dash = label.indexOf(' - ')
    const code = dash >= 0 ? label.slice(0, dash).trim() : label
    return code.toLowerCase() === normalized
  })
  if (prefixLabel) return prefixLabel.value

  const contains = options.find(
    (option) =>
      option.value.toLowerCase() === normalized ||
      option.label.toLowerCase().includes(normalized) ||
      normalized.includes(option.value.toLowerCase()),
  )
  return contains?.value ?? trimmed
}
