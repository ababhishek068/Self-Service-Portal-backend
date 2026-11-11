import { authDelete, authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

/** Stage 2 — Overtime Payment Request (BC 1.0.3.636 PortalOTPayment*). */
export type OtPaymentStatus = 'Draft' | 'Pending Approval' | 'Approved' | 'Rejected' | 'Cancelled'

export type OtPaymentRequest = {
  id: string
  paymentNo: string
  status: OtPaymentStatus
  employeeNo: string
  employeeName: string
  otRequestNo: string
  workCompletedOn: string
  employeeRemarks: string
  superiorJustification: string
  addedToSheet: boolean
  createdAt: string
  submittedAt: string
  approvedAt: string
  otRequest?: Record<string, unknown>
}

export async function fetchOtPaymentContext(otRequestNo = '') {
  requireAuthApiUrl()
  const query = otRequestNo ? `?otRequestNo=${encodeURIComponent(otRequestNo)}` : ''
  return authGet<Record<string, unknown>>(`/api/hr/overtime-payments/context${query}`)
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
