import { authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export async function fetchImprestLineAmount(payload: {
  headerNo: string
  noOfDays: number
  advanceType: string
  destinationCode: string
}) {
  requireAuthApiUrl()
  const { amount, dailyRate } = await authPost<{ amount: number; dailyRate?: number }>(
    '/api/imprest/fetch-line-amount',
    payload,
  )
  return { amount, dailyRate: dailyRate ?? (amount > 0 && payload.noOfDays > 0 ? amount / payload.noOfDays : 0) }
}
