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
  RemainingBalance?: number | null
  remainingBalance?: number | null
  EmployeeContribution?: number | null
  employeeContribution?: number | null
  budgetCapped?: boolean
  policyCoveragePercent?: number
  usedBcPolicy?: boolean
}

export async function validateHospitalCategory(payload: {
  medicalAmount: number
  hospitalCategory: string
  patient?: string
  dependant?: string
}) {
  requireAuthApiUrl()
  return authPost<MedicalClaimAmountResult>('/api/claims/validate-hospital-category', payload)
}
