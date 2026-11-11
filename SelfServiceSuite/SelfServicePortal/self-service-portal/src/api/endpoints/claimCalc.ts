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

/** Alias used by Medical Claim UX (same BC FetchMedicalClaimAmountPolicy endpoint). */
export async function fetchMedicalClaimAmountPolicy(payload: {
  medicalAmount: number
  hospitalCategory?: string
  patient?: string
  dependant?: string
}) {
  return validateHospitalCategory({
    medicalAmount: payload.medicalAmount,
    hospitalCategory: payload.hospitalCategory || '0',
    patient: payload.patient,
    dependant: payload.dependant,
  })
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
