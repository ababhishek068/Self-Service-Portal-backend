import { useQuery } from '@tanstack/react-query'
import { getStoreRequisitionOptions } from '@/api/endpoints/requestEndpoint'

/**
 * The BC Unit of Measure list (EACH, PCS, BOX…) as select options: the same lookup as the store
 * requisition form. Empty while loading, or when this BC app does not publish the list.
 */
export function useUnitOfMeasureOptions() {
  const query = useQuery({
    queryKey: ['store-requisition', 'options'],
    queryFn: getStoreRequisitionOptions,
    staleTime: 5 * 60 * 1000,
    retry: false,
  })
  const units = query.data?.unitsOfMeasure ?? []
  return {
    isLoading: query.isLoading,
    options: units.map((unit) => ({
      value: unit.code,
      label: unit.description && unit.description.toUpperCase() !== unit.code ? `${unit.code} — ${unit.description}` : unit.code,
    })),
  }
}
