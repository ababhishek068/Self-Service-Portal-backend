import { authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type {
  HrLetterStatus,
  HrLetterType,
  RequestableHrLetterType,
} from '@/data/hrServiceLetters'

export interface HrServiceLetterRequest {
  id: string
  requestNo: string
  letterType: HrLetterType
  letterTypeLabel: string
  status: HrLetterStatus
  submittedAt: string
  updatedAt: string
  employeeNo: string
  employeeName: string
  departmentName: string
  details: Record<string, string>
  hrRemarks?: string
  hrDecisionAt?: string
  hrDecisionBy?: string
  /** Uses the dedicated Business Central HR service decision queue. */
  approvalRequired: true
}

export async function fetchHrServiceLetterRequests() {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: HrServiceLetterRequest[] }>('/api/hr/service-letters')
  return rows
}

export interface HrServiceLetterFormContext {
  employeeId: string
  employeeName: string
  employeeDepartment: string
  monthlySalaryBase: number | null
  jobTitle?: string
  dateOfJoin?: string
  yearsOfService?: string
}

export async function fetchHrServiceLetterFormContext() {
  requireAuthApiUrl()
  return authGet<HrServiceLetterFormContext>('/api/hr/service-letters/form-context')
}

export async function submitHrServiceLetterRequest(input: {
  letterType: RequestableHrLetterType
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
