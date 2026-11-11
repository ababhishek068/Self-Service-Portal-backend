import { authDelete, authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type { OvertimeDayType } from './overtime'

export type OvertimeWorkStatus = 'Draft' | 'Pending Approval' | 'Approved' | 'Rejected' | 'Cancelled'
export type OvertimeWorkLocation = 'office' | 'field' | 'projectSite'

export interface OvertimeWorkStep {
  stage: number
  label: string
  approverUserId: string
  approverName: string
  status: 'Waiting' | 'Pending' | 'Approved' | 'Rejected' | 'Skipped'
  decidedAt: string
  comment: string
}

/** Same categories as Overtime Payment / the OT sheet. */
export interface OvertimeWorkLine {
  overtimeDate: string
  startTime: string
  endTime: string
  dayType: OvertimeDayType
  workLocation: OvertimeWorkLocation
  reason: string
  totalHours: number
}

export interface OvertimeWorkRequest {
  id: string
  requestNo: string
  status: OvertimeWorkStatus
  employeeNo: string
  employeeName: string
  designation: string
  departmentCode: string
  departmentName: string
  overtimeDate: string
  normalHoursFrom: string
  normalHoursTo: string
  overtimeFrom: string
  overtimeTo: string
  totalHours: number
  workLocation: OvertimeWorkLocation
  reason: string
  expectedDeliverables: string
  lines: OvertimeWorkLine[]
  requesterUserId: string
  createdAt: string
  submittedAt: string
  approvedAt: string
  decisionRemarks: string
  steps: OvertimeWorkStep[]
  /** Set once this work request is linked to an Overtime Payment Request. */
  linkedPaymentRequestNo?: string
  linkedAt?: string
  /** BC 1.0.3.636: the row mirrors BC Stage 1 (Superior → FAD); requestNo is the BC number. */
  bcStage1?: boolean
  /** From BC: Stage 1 approved and no Stage 2 payment yet → show "Request overtime payment". */
  canRequestPayment?: boolean
  paymentApproved?: boolean
  addedToSheet?: boolean
}

export interface OvertimeWorkDetails {
  reason: string
  expectedDeliverables: string
  lines: Array<{
    overtimeDate: string
    startTime: string
    endTime: string
    dayType: OvertimeDayType
    workLocation: OvertimeWorkLocation
    reason: string
  }>
}

export async function fetchOvertimeWorkRequests() {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: OvertimeWorkRequest[] }>('/api/hr/overtime-work')
  return rows
}

export async function fetchApprovedOvertimeWorkRequests(keepRequestNo?: string) {
  requireAuthApiUrl()
  const query = keepRequestNo?.trim()
    ? `?keep=${encodeURIComponent(keepRequestNo.trim().toUpperCase())}`
    : ''
  const { rows } = await authGet<{ rows: OvertimeWorkRequest[] }>(`/api/hr/overtime-work/approved${query}`)
  return rows
}

export async function fetchOvertimeWorkByPayment(paymentRequestNo: string) {
  requireAuthApiUrl()
  const { row } = await authGet<{ row: OvertimeWorkRequest | null }>(
    `/api/hr/overtime-work/by-payment/${encodeURIComponent(paymentRequestNo)}`,
  )
  return row
}

export async function saveOvertimeWorkRequest(input: {
  requestNo?: string
  details: OvertimeWorkDetails
  submit: boolean
}) {
  requireAuthApiUrl()
  return authPost<OvertimeWorkRequest>('/api/hr/overtime-work', input)
}

export async function withdrawOvertimeWorkRequest(requestNo: string) {
  requireAuthApiUrl()
  return authPost<OvertimeWorkRequest>(`/api/hr/overtime-work/${encodeURIComponent(requestNo)}/withdraw`, {})
}

export async function deleteOvertimeWorkRequest(requestNo: string) {
  requireAuthApiUrl()
  return authDelete<{ ok: boolean; requestNo: string }>(
    `/api/hr/overtime-work/${encodeURIComponent(requestNo)}`,
  )
}
