import { useQuery } from '@tanstack/react-query'
import { getLocalPurchaseAccess } from '@/api/endpoints/requestEndpoint'

/**
 * Whether Local Purchase is live in Business Central for this user. Until BC has the LPR
 * portal methods this is { enabled: false } and every screen keeps its 1.0.3.382 behaviour.
 */
export function useLocalPurchaseAccess() {
  const query = useQuery({
    queryKey: ['local-purchase', 'access'],
    queryFn: getLocalPurchaseAccess,
    staleTime: 60_000,
    retry: false,
  })
  return {
    enabled: query.data?.enabled === true,
    roles: query.data?.roles ?? [],
    isLoading: query.isLoading,
  }
}
