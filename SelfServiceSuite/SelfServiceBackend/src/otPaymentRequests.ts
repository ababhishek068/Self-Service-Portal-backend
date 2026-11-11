import { callSoapMethod } from './bcClient.js'

/**
 * Stage 2 — Overtime Payment Request (BC 1.0.3.636).
 * Linked to an approved Stage 1 PortalOvertime request; hours hit the OT sheet only after Stage 2 approve.
 */
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
  canDecide: boolean
  createdAt: string
  submittedAt: string
  approvedAt: string
  otRequest?: Record<string, unknown>
  raw: Record<string, unknown>
}

function str(value: unknown) {
  return value === undefined || value === null ? '' : String(value).trim()
}

function bool(value: unknown) {
  if (typeof value === 'boolean') return value
  return ['true', '1', 'yes'].includes(str(value).toLowerCase())
}

function record(value: unknown): Record<string, unknown> {
  return value && typeof value === 'object' && !Array.isArray(value) ? (value as Record<string, unknown>) : {}
}

function parseJson(value: unknown): unknown {
  if (typeof value !== 'string') return value
  const trimmed = value.trim()
  if (!trimmed) return null
  try {
    return JSON.parse(trimmed)
  } catch {
    throw Object.assign(new Error('Business Central returned an overtime payment answer the portal could not read.'), {
      status: 502,
    })
  }
}

function statusOf(value: unknown): OtPaymentStatus {
  const text = str(value) as OtPaymentStatus
  return (['Draft', 'Pending Approval', 'Approved', 'Rejected', 'Cancelled'] as const).includes(text)
    ? text
    : 'Draft'
}

export function parseOtPaymentRequest(value: unknown): OtPaymentRequest {
  const row = record(value)
  const paymentNo = str(row.paymentNo ?? row.requestNo ?? row.id)
  return {
    id: paymentNo,
    paymentNo,
    status: statusOf(row.status),
    employeeNo: str(row.employeeNo),
    employeeName: str(row.employeeName),
    otRequestNo: str(row.otRequestNo),
    workCompletedOn: str(row.workCompletedOn),
    employeeRemarks: str(row.employeeRemarks ?? row.remarks),
    superiorJustification: str(row.superiorJustification),
    addedToSheet: bool(row.addedToSheet),
    canDecide: bool(row.canDecide),
    createdAt: str(row.createdAt),
    submittedAt: str(row.submittedAt),
    approvedAt: str(row.approvedAt),
    otRequest: row.otRequest && typeof row.otRequest === 'object' ? record(row.otRequest) : undefined,
    raw: row,
  }
}

export function parseOtPaymentRequests(value: unknown): OtPaymentRequest[] {
  const parsed = parseJson(value)
  return (Array.isArray(parsed) ? parsed : []).map(parseOtPaymentRequest)
}

export function parseOtPaymentContext(value: unknown) {
  const root = record(parseJson(value))
  return {
    ...root,
    otRequest: root.otRequest && typeof root.otRequest === 'object' ? record(root.otRequest) : undefined,
  }
}

async function callOtPayment(method: string, params: Record<string, unknown>) {
  return callSoapMethod(method, params)
}

export async function getOtPaymentContext(employeeNo: string, requesterUserId: string, otRequestNo: string) {
  const result = await callOtPayment('PortalOTPaymentContext', {
    employeeNo,
    requesterUserId,
    otRequestNo,
  })
  return parseOtPaymentContext(result.returnValue)
}

export async function listOtPaymentRequests(employeeNo: string) {
  const result = await callOtPayment('PortalOTPaymentList', { employeeNo })
  return parseOtPaymentRequests(result.returnValue)
}

export async function getOtPaymentByNo(paymentNo: string) {
  const trimmed = paymentNo.trim()
  if (!trimmed) return null
  try {
    const result = await callOtPayment('PortalOTPaymentByNo', { paymentNo: trimmed })
    const parsed = parseJson(result.returnValue)
    return parsed ? parseOtPaymentRequest(parsed) : null
  } catch (error) {
    if (/was not found/i.test(String((error as Error)?.message ?? ''))) return null
    throw error
  }
}

export async function saveOtPaymentRequest(input: {
  employeeNo: string
  requesterUserId: string
  paymentNo?: string
  details: { otRequestNo: string; workCompletedOn: string; employeeRemarks: string }
  submit: boolean
}) {
  const otRequestNo = str(input.details.otRequestNo).toUpperCase()
  const workCompletedOn = str(input.details.workCompletedOn)
  const employeeRemarks = str(input.details.employeeRemarks).slice(0, 250)
  if (!otRequestNo) {
    throw Object.assign(new Error('Select the approved Overtime Request (Stage 1) to pay.'), {
      status: 422,
    })
  }
  if (input.submit && !/^\d{4}-\d{2}-\d{2}$/.test(workCompletedOn)) {
    throw Object.assign(new Error('Enter the work completed date.'), { status: 422 })
  }
  const result = await callOtPayment('PortalOTPaymentSave', {
    employeeNo: input.employeeNo,
    requesterUserId: input.requesterUserId,
    paymentNo: input.paymentNo ?? '',
    detailsJson: JSON.stringify({
      otRequestNo,
      workCompletedOn,
      employeeRemarks,
    }),
    submitRequest: input.submit,
  })
  return parseOtPaymentRequest(parseJson(result.returnValue))
}

export async function withdrawOtPaymentRequest(employeeNo: string, paymentNo: string) {
  const result = await callOtPayment('PortalOTPaymentWithdraw', { employeeNo, paymentNo })
  return parseOtPaymentRequest(parseJson(result.returnValue))
}

export async function deleteOtPaymentRequest(employeeNo: string, paymentNo: string) {
  const result = await callOtPayment('PortalOTPaymentDelete', { employeeNo, paymentNo })
  if (!bool(result.returnValue)) {
    throw Object.assign(new Error('Business Central did not delete the overtime payment request.'), {
      status: 502,
    })
  }
  return { ok: true, id: paymentNo }
}

export async function listOtPaymentApprovals(
  approverUserIds: string,
  scope: 'pending' | 'decided' = 'pending',
) {
  if (!approverUserIds.trim()) return []
  try {
    const result = await callSoapMethod('PortalOTPaymentApprovals', { approverUserIds, scope })
    return parseOtPaymentRequests(result.returnValue)
  } catch {
    return []
  }
}

export async function decideOtPaymentApproval(input: {
  approverUserIds: string
  paymentNo: string
  approve: boolean
  remarks: string
}) {
  const remarks = input.remarks.trim().slice(0, 250)
  if (input.approve && remarks.length < 3) {
    throw Object.assign(
      new Error('Enter the Superior justification (at least 3 characters) when approving overtime payment.'),
      { status: 422 },
    )
  }
  if (!input.approve && remarks.length < 3) {
    throw Object.assign(new Error('Enter the reason for rejecting (at least 3 characters).'), {
      status: 422,
    })
  }
  const result = await callOtPayment('PortalOTPaymentDecide', {
    approverUserIds: input.approverUserIds,
    paymentNo: input.paymentNo,
    approve: input.approve,
    remarks,
  })
  return parseOtPaymentRequest(parseJson(result.returnValue))
}
