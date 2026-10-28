import { useQuery } from '@tanstack/react-query'
import { getToken, resolveApiBaseUrl } from '@/api/client/authClient'
import { getNotifications } from '@/api/endpoints/notifications'
import { useAuth } from '@/hooks/useAuth'

/** The bell and the dashboard banners share one poll (every two minutes). */
export function useNotifications() {
  const { isAuthenticated, bootstrapped } = useAuth()
  return useQuery({
    queryKey: ['notifications'],
    queryFn: getNotifications,
    enabled: bootstrapped && isAuthenticated && Boolean(resolveApiBaseUrl()) && Boolean(getToken()),
    staleTime: 60_000,
    gcTime: 5 * 60_000,
    refetchOnMount: true,
    refetchInterval: 120_000,
    retry: false,
  })
}
