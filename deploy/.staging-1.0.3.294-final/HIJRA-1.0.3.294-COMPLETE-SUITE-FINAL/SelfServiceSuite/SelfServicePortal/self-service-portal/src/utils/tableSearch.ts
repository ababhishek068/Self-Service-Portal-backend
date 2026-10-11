const MAX_SEARCH_PARTS = 500
const MAX_SEARCH_DEPTH = 7

function collectSearchParts(
  value: unknown,
  parts: string[],
  seen: WeakSet<object>,
  depth: number,
): void {
  if (value === null || value === undefined || parts.length >= MAX_SEARCH_PARTS || depth > MAX_SEARCH_DEPTH) {
    return
  }

  if (typeof value === 'string' || typeof value === 'number' || typeof value === 'bigint') {
    parts.push(String(value))
    return
  }

  if (typeof value === 'boolean') {
    parts.push(value ? 'yes true' : 'no false')
    return
  }

  if (value instanceof Date) {
    parts.push(value.toISOString())
    return
  }

  if (typeof value !== 'object' || seen.has(value)) {
    return
  }

  seen.add(value)

  if (Array.isArray(value)) {
    value.forEach((entry) => collectSearchParts(entry, parts, seen, depth + 1))
    return
  }

  Object.values(value as Record<string, unknown>).forEach((entry) =>
    collectSearchParts(entry, parts, seen, depth + 1),
  )
}

export function normalizeSearchText(value: unknown): string {
  return String(value ?? '')
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLocaleLowerCase()
    .replace(/\s+/g, ' ')
    .trim()
}

export function searchableText(value: unknown): string {
  const parts: string[] = []
  collectSearchParts(value, parts, new WeakSet<object>(), 0)
  return normalizeSearchText(parts.join(' '))
}

export function matchesSearchQuery(value: unknown, query: string, extraValues: unknown[] = []): boolean {
  const normalizedQuery = normalizeSearchText(query)
  if (!normalizedQuery) return true

  const haystack = searchableText([value, ...extraValues])
  const compactHaystack = haystack.replace(/[^a-z0-9]+/g, '')

  return normalizedQuery.split(' ').every((term) => {
    if (!term) return true
    const compactTerm = term.replace(/[^a-z0-9]+/g, '')
    return haystack.includes(term) || (compactTerm.length > 0 && compactHaystack.includes(compactTerm))
  })
}
