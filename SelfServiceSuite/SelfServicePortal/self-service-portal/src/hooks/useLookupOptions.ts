import { useQuery } from '@tanstack/react-query'
import { listLookupOptions, type LookupOption } from '@/api/endpoints/lookups'

export function useLookupOptions(catalog: string, fallback: LookupOption[] = []) {
  const query = useQuery({
    queryKey: ['lookups', catalog],
    queryFn: () => listLookupOptions(catalog),
  })

  return {
    ...query,
    // Use seed values when BC lookup fails or returns no rows (broken OData/filter).
    options:
      query.isLoading || !query.isFetched
        ? []
        : (query.data?.length ?? 0) > 0
          ? (query.data ?? [])
          : fallback,
  }
}
