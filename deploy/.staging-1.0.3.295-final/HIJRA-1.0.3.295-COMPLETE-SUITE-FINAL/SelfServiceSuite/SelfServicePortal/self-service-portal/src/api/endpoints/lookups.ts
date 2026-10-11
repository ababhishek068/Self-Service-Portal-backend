import { authGet } from '@/api/client/authClient'

export interface LookupOption {
  label: string
  value: string
  meta?: Record<string, unknown>
}

export async function listLookupOptions(
  catalog: string,
  params?: { assetNo?: string },
) {
  const query = params?.assetNo
    ? `?assetNo=${encodeURIComponent(params.assetNo)}`
    : ''
  const { rows } = await authGet<{ rows: LookupOption[] }>(
    `/api/lookups/${encodeURIComponent(catalog)}${query}`,
  )
  return rows
}
