import { authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export interface MedicalClaimAmountResult {
  Amount?: number
  amount?: number
  AmountToRefund?: number
  amountToRefund?: number
  CoveragePercent?: number
  coveragePercent?: number
  availableBalance?: number | null
  budgetCapped?: boolean
  policyCoveragePercent?: number
}

export async function validateHospitalCategory(payload: {
  medicalAmount: number
  hospitalCategory: string
  patient?: string
}) {
  requireAuthApiUrl()
  return authPost<MedicalClaimAmountResult>('/api/claims/validate-hospital-category', payload)
}
