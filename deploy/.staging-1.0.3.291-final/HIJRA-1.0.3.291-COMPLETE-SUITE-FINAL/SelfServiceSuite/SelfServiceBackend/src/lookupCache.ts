/**
 * Short-lived in-memory cache for BC OData lookup catalogs.
 * Cuts repeat dropdown loads (assets/items/employees/locations/vehicles)
 * from multi-second BC round-trips to near-instant cache hits.
 */

type CacheEntry<T> = { expiresAt: number; value: T }

const store = new Map<string, CacheEntry<unknown>>()

export function cacheGet<T>(key: string): T | undefined {
  const entry = store.get(key)
  if (!entry) return undefined
  if (entry.expiresAt <= Date.now()) {
    store.delete(key)
    return undefined
  }
  return entry.value as T
}

export function cacheSet<T>(key: string, value: T, ttlMs: number) {
  store.set(key, { value, expiresAt: Date.now() + Math.max(1_000, ttlMs) })
}

export async function cacheGetOrLoad<T>(
  key: string,
  ttlMs: number,
  loader: () => Promise<T>,
): Promise<T> {
  const hit = cacheGet<T>(key)
  if (hit !== undefined) return hit
  const value = await loader()
  cacheSet(key, value, ttlMs)
  return value
}

/** Drop one key or the whole lookup cache (e.g. after rare master-data writes). */
export function cacheInvalidate(keyPrefix?: string) {
  if (!keyPrefix) {
    store.clear()
    return
  }
  for (const key of store.keys()) {
    if (key.startsWith(keyPrefix)) store.delete(key)
  }
}

export const LOOKUP_TTL_MS = 15 * 60 * 1000
export const FA_TAG_INDEX_TTL_MS = 5 * 60 * 1000
