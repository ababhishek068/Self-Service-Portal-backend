import { authGet } from '@/api/client/authClient'

export interface LookupOption {
  label: string
  value: string
  /** When true, shown in select lists but not choosable. */
  disabled?: boolean
  meta?: Record<string, unknown>
}

export async function listLookupOptions(catalog: string) {
  const { rows } = await authGet<{ rows: LookupOption[] }>(
    `/api/lookups/${encodeURIComponent(catalog)}`,
  )
  return rows
}
