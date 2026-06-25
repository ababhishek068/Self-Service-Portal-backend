import { authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export async function fetchImprestLineAmount(payload: {
  headerNo: string
  noOfDays: number
  advanceType: string
  destinationCode: string
}) {
  requireAuthApiUrl()
  const { amount } = await authPost<{ amount: number }>('/api/imprest/fetch-line-amount', payload)
  return amount
}
