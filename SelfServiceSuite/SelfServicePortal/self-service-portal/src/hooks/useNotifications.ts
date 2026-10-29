import { useQuery } from '@tanstack/react-query'
import { getToken, resolveApiBaseUrl } from '@/api/client/authClient'
import { getNotifications } from '@/api/endpoints/notifications'
import { useAuth } from '@/hooks/useAuth'

/**
 * The bell and the dashboard banners share one query per signed-in user. It is asked again every
 * minute, on every page (NotificationBell) and when the bell is opened.
 */
export function useNotifications() {
  const { employee, isAuthenticated, bootstrapped } = useAuth()
  const userKey = String(employee?.userID || employee?.employeeNo || '').toUpperCase()
  return useQuery({
    queryKey: ['notifications', userKey],
    queryFn: getNotifications,
    enabled: bootstrapped && isAuthenticated && Boolean(userKey) && Boolean(resolveApiBaseUrl()) && Boolean(getToken()),
    staleTime: 10_000,
    gcTime: 5 * 60_000,
    refetchOnMount: true,
    refetchOnWindowFocus: true,
    refetchInterval: 60_000,
    retry: 1,
  })
}
