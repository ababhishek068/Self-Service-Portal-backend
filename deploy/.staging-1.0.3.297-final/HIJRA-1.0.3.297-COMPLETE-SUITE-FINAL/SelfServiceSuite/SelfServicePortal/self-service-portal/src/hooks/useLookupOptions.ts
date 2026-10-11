import { useQuery } from '@tanstack/react-query'
import { listLookupOptions, type LookupOption } from '@/api/endpoints/lookups'

export function useLookupOptions(
  catalog: string,
  fallback: LookupOption[] = [],
  params?: { assetNo?: string },
) {
  const query = useQuery({
    queryKey: ['lookups', catalog, params?.assetNo ?? ''],
    queryFn: () => listLookupOptions(catalog, params),
    enabled: catalog !== 'vehicle-tools' || Boolean(params?.assetNo?.trim()),
  })

  return {
    ...query,
    options: query.data?.length ? query.data : fallback,
  }
}
