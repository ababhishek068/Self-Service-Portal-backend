import { authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type {
  EmployeeExitRequestStatus,
  EmployeeExitRequestType,
} from '@/data/employeeExit'

export interface EmployeeExitRequest {
  id: string
  requestNo: string
  requestType: EmployeeExitRequestType
  requestTypeLabel: string
  status: EmployeeExitRequestStatus
  submittedAt: string
  updatedAt: string
  employeeNo: string
  employeeName: string
  departmentName: string
  details: Record<string, string>
  approvalRequired: boolean
  erpWorkflowConnected: true
  requesterUserId?: string
  supervisorUserId?: string
  hrApproverUserId?: string
  supervisorDecisionBy?: string
  supervisorDecisionAt?: string
  hrDecisionBy?: string
  hrDecisionAt?: string
  rejectedAtStage?: string
  decisionRemarks?: string
  cancellationReason?: string
  cancellationRequestedAt?: string
}

export async function fetchEmployeeExitRequests() {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: EmployeeExitRequest[] }>('/api/hr/employee-exit')
  return rows
}

export async function submitEmployeeExitRequest(input: {
  requestType: EmployeeExitRequestType
  details: Record<string, string>
}) {
  requireAuthApiUrl()
  return authPost<EmployeeExitRequest>('/api/hr/employee-exit', input)
}

export async function requestEmployeeExitCancellation(id: string, reason: string) {
  requireAuthApiUrl()
  return authPost<EmployeeExitRequest>(
    `/api/hr/employee-exit/${encodeURIComponent(id)}/request-cancellation`,
    { reason },
  )
}

/** Withdraw a request that is still Open or Pending Approval (before it is approved). */
export async function cancelEmployeeExitRequest(id: string) {
  requireAuthApiUrl()
  return authPost<EmployeeExitRequest>(
    `/api/hr/employee-exit/${encodeURIComponent(id)}/cancel`,
    {},
  )
}
