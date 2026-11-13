import { authDelete, authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type { OvertimeRequest, OvertimeStep } from './overtime'

/** Stage 2 — Overtime Payment Request (BC 1.0.3.636 PortalOTPayment*). */
export type OtPaymentStatus = 'Draft' | 'Pending Approval' | 'Approved' | 'Rejected' | 'Cancelled'

export type OtPaymentRequest = {
  id: string
  paymentNo: string
  status: OtPaymentStatus
  stage: number
  stageLabel: string
  employeeNo: string
  employeeName: string
  designation: string
  departmentCode: string
  departmentName: string
  costCentre: string
  otRequestNo: string
  totalHours: number
  estimatedAmount: number
  workCompletedOn: string
  employeeRemarks: string
  superiorJustification: string
  superiorUserId: string
  rejectedAtStage: string
  decisionRemarks: string
  addedToSheet: boolean
  createdAt: string
  submittedAt: string
  approvedAt: string
  /** Stage 2 BC workflow steps (Workflow User Group since 1.0.3.649). */
  steps: OvertimeStep[]
  /** The linked, approved Stage 1 Overtime Request. */
  otRequest?: OvertimeRequest
}

export type OtPaymentContext = {
  stage: string
  stageCaption: string
  otRequestNo: string
  otRequest?: OvertimeRequest
  /** Stage 2 approver preview from the BC workflow (Workflow User Group since 1.0.3.649). */
  approvers: OvertimeStep[]
  routingProblem: string
  usesWorkflow: boolean
  approvalWorkflow: string
}

export async function fetchOtPaymentContext(otRequestNo: string) {
  requireAuthApiUrl()
  return authGet<OtPaymentContext>(
    `/api/hr/overtime-payments/context?otRequestNo=${encodeURIComponent(otRequestNo)}`,
  )
}

export async function fetchOtPaymentRequests() {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: OtPaymentRequest[] }>('/api/hr/overtime-payments')
  return rows
}

export async function saveOtPaymentRequest(input: {
  paymentNo?: string
  otRequestNo: string
  workCompletedOn: string
  employeeRemarks: string
  submit: boolean
}) {
  requireAuthApiUrl()
  return authPost<OtPaymentRequest>('/api/hr/overtime-payments', {
    paymentNo: input.paymentNo,
    submit: input.submit,
    otRequestNo: input.otRequestNo,
    workCompletedOn: input.workCompletedOn,
    employeeRemarks: input.employeeRemarks,
  })
}

export async function withdrawOtPaymentRequest(paymentNo: string) {
  requireAuthApiUrl()
  return authPost<OtPaymentRequest>(
    `/api/hr/overtime-payments/${encodeURIComponent(paymentNo)}/withdraw`,
    {},
  )
}

export async function deleteOtPaymentRequest(paymentNo: string) {
  requireAuthApiUrl()
  return authDelete<{ ok: boolean; id: string }>(
    `/api/hr/overtime-payments/${encodeURIComponent(paymentNo)}`,
  )
}
