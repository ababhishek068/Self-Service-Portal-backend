import { authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type { HrLetterType } from '@/data/hrServiceLetters'

export interface HrServiceLetterRequest {
  id: string
  requestNo: string
  letterType: HrLetterType
  letterTypeLabel: string
  status:
    | 'Submitted'
    | 'In Progress'
    | 'Approved'
    | 'Rejected'
    | 'Ready for Collection'
    | 'Completed'
    | 'Cancelled'
  submittedAt: string
  updatedAt: string
  employeeNo: string
  employeeName: string
  departmentName: string
  details: Record<string, string>
  hrRemarks?: string
  hrDecisionAt?: string
  hrDecisionBy?: string
  approvalRequired: boolean
}

export async function fetchHrServiceLetterRequests() {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: HrServiceLetterRequest[] }>(
    '/api/hr/service-letters',
  )
  return rows
}

export async function fetchMonthlySalaryBase() {
  requireAuthApiUrl()
  const { monthlySalaryBase } = await authGet<{ monthlySalaryBase: number }>(
    '/api/hr/monthly-salary-base',
  )
  return Number(monthlySalaryBase ?? 0)
}

export async function submitHrServiceLetterRequest(input: {
  letterType: HrLetterType
  details: Record<string, string>
}) {
  requireAuthApiUrl()
  return authPost<HrServiceLetterRequest>('/api/hr/service-letters', input)
}

export async function cancelHrServiceLetterRequest(id: string) {
  requireAuthApiUrl()
  return authPost<HrServiceLetterRequest>(
    `/api/hr/service-letters/${encodeURIComponent(id)}/cancel`,
    {},
  )
}
