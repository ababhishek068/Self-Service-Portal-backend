import { callSoapMethod } from './bcClient.js'
import {
  getOvertimeRequestByNo,
  overtimeDateRange,
  overtimeDocumentLines,
  parseOvertimeRequest,
  parseOvertimeStep,
  type OvertimeRequest,
  type OvertimeStep,
} from './overtimeRequests.js'

/**
 * Stage 2 — Overtime Payment Request (BC 1.0.3.636).
 * Linked to an approved Stage 1 PortalOvertime request; hours hit the OT sheet only after Stage 2 approve.
 */
export const OT_PAYMENT_MODULE = 'overtimePayment' as const

/**
 * BC table "ABH OT Payment Request". Its Approval Entries are listed and decided through
 * PortalOTPayment* (BC 1.0.3.649: Workflow User Group; a reject needs a reason), never through the OData queues.
 */
export const OT_PAYMENT_TABLE_ID = 53655

export type OtPaymentStatus = 'Draft' | 'Pending Approval' | 'Approved' | 'Rejected' | 'Cancelled'

export type OtPaymentRequest = {
  id: string
  paymentNo: string
  status: OtPaymentStatus
  /** The step the request waits on (0 when it is not pending). */
  stage: number
  stageLabel: string
  employeeNo: string
  employeeName: string
  designation: string
  departmentCode: string
  departmentName: string
  /** BC 1.0.3.649: employee division (Global Dimension 1), the Stage 2 workflow Event Condition with the department. */
  divisionCode: string
  divisionName: string
  costCentre: string
  otRequestNo: string
  /** Copied by BC from the Stage 1 request when the payment request is created. */
  totalHours: number
  estimatedAmount: number
  workCompletedOn: string
  employeeRemarks: string
  superiorJustification: string
  superiorUserId: string
  requesterUserId: string
  rejectedAtStage: string
  decisionRemarks: string
  addedToSheet: boolean
  canDecide: boolean
  createdAt: string
  submittedAt: string
  approvedAt: string
  /** The Workflow User Group step(s) of the Stage 2 BC workflow (BC 1.0.3.649). */
  steps: OvertimeStep[]
  /** The linked Stage 1 Overtime Request (BC embeds it in every payment answer). */
  otRequest?: OvertimeRequest
  raw: Record<string, unknown>
}

function str(value: unknown) {
  return value === undefined || value === null ? '' : String(value).trim()
}

function num(value: unknown) {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : 0
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
  const otRequest =
    row.otRequest && typeof row.otRequest === 'object' && !Array.isArray(row.otRequest)
      ? parseOvertimeRequest(row.otRequest)
      : undefined
  return {
    id: paymentNo,
    paymentNo,
    status: statusOf(row.status),
    stage: num(row.stage),
    stageLabel: str(row.stageLabel),
    employeeNo: str(row.employeeNo),
    employeeName: str(row.employeeName),
    designation: str(row.designation),
    departmentCode: str(row.departmentCode),
    departmentName: str(row.departmentName),
    divisionCode: str(row.divisionCode) || (otRequest?.divisionCode ?? ''),
    divisionName: str(row.divisionName) || (otRequest?.divisionName ?? ''),
    costCentre: str(row.costCentre),
    otRequestNo: str(row.otRequestNo) || (otRequest?.requestNo ?? ''),
    totalHours: num(row.totalHours) || (otRequest?.totalHours ?? 0),
    estimatedAmount: num(row.estimatedAmount) || (otRequest?.estimatedAmount ?? 0),
    workCompletedOn: str(row.workCompletedOn),
    employeeRemarks: str(row.employeeRemarks ?? row.remarks),
    superiorJustification: str(row.superiorJustification),
    superiorUserId: str(row.superiorUserId),
    requesterUserId: str(row.requesterUserId),
    rejectedAtStage: str(row.rejectedAtStage),
    decisionRemarks: str(row.decisionRemarks),
    addedToSheet: bool(row.addedToSheet),
    canDecide: bool(row.canDecide),
    createdAt: str(row.createdAt),
    submittedAt: str(row.submittedAt),
    approvedAt: str(row.approvedAt),
    steps: (Array.isArray(row.steps) ? row.steps : []).map(parseOvertimeStep),
    otRequest,
    raw: row,
  }
}

export function parseOtPaymentRequests(value: unknown): OtPaymentRequest[] {
  const parsed = parseJson(value)
  return (Array.isArray(parsed) ? parsed : []).map(parseOtPaymentRequest)
}

export type OtPaymentContext = {
  stage: string
  stageCaption: string
  otRequestNo: string
  /** The approved Stage 1 request the payment is for. */
  otRequest?: OvertimeRequest
  /** Stage 2 approver preview from the BC workflow (Workflow User Group since 1.0.3.649). */
  approvers: OvertimeStep[]
  /** Why Stage 2 cannot be routed yet (no workflow enabled); empty when it can. */
  routingProblem: string
  usesWorkflow: boolean
  approvalWorkflow: string
}

export function parseOtPaymentContext(value: unknown): OtPaymentContext {
  const root = record(parseJson(value))
  const otRequest =
    root.otRequest && typeof root.otRequest === 'object' && !Array.isArray(root.otRequest)
      ? parseOvertimeRequest(root.otRequest)
      : undefined
  return {
    stage: str(root.stage) || 'paymentRequest',
    stageCaption: str(root.stageCaption),
    otRequestNo: str(root.otRequestNo) || (otRequest?.requestNo ?? ''),
    otRequest,
    approvers: (Array.isArray(root.approvers) ? root.approvers : []).map(parseOvertimeStep),
    routingProblem: str(root.routingProblem),
    usesWorkflow: bool(root.usesWorkflow),
    approvalWorkflow: str(root.approvalWorkflow),
  }
}

/** BC before 1.0.3.636 has no PortalOTPayment* methods ("Method 'X' is invalid"). */
export function otPaymentServiceMissing(error: unknown) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  return /Method '?PortalOTPayment\w*'? is invalid|PortalOTPayment\w*.*(not found|not published)|soapaction/i.test(
    message,
  )
}

async function callOtPayment(method: string, params: Record<string, unknown>) {
  try {
    return await callSoapMethod(method, params)
  } catch (error) {
    if (otPaymentServiceMissing(error)) {
      throw Object.assign(
        new Error(
          'Overtime Payment Request (Stage 2) needs Business Central package 1.0.3.636. Ask the BC administrator to publish it.',
        ),
        { status: 503, code: 'OT_PAYMENT_SERVICE_MISSING' },
      )
    }
    throw error
  }
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
  let result: Awaited<ReturnType<typeof callOtPayment>>
  try {
    result = await callOtPayment('PortalOTPaymentSave', {
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
  } catch (error) {
    throw await stage2RoutingError(error, otRequestNo)
  }
  return parseOtPaymentRequest(parseJson(result.returnValue))
}

/**
 * BC 1.0.3.649 refuses a Stage 2 submit with "did not create approval entries" when a Stage 2
 * workflow is enabled but none matched: its Event Conditions (Division Code + Department Code,
 * copied from the Stage 1 request) differ, or its Workflow User Group is empty. Name the values
 * the payment request carries so HR can compare them with the workflow in BC.
 */
export async function stage2RoutingError(
  error: unknown,
  otRequestNo: string,
  lookup: (requestNo: string) => Promise<OvertimeRequest | null> = getOvertimeRequestByNo,
) {
  const message = String((error as { message?: unknown } | null)?.message ?? '')
  if (!/did not create approval entries for overtime payment request/i.test(message)) return error
  const stage1 = await lookup(otRequestNo).catch(() => null)
  const division = stage1?.divisionCode || '(blank)'
  const department = stage1?.departmentCode || '(blank)'
  const blank = !stage1?.divisionCode || !stage1?.departmentCode
  const detail =
    ` This payment request has Division Code ${division} and Department Code ${department}` +
    ` (copied from ${otRequestNo}). In Business Central, HR checks Workflows: the enabled Stage 2 workflow` +
    ` ("An Approval Request for an Overtime Payment Request has been Requested.") needs Event Conditions` +
    ` with these values and a Workflow User Group with at least one member.` +
    (blank
      ? ` A blank value means ${otRequestNo} was saved before BC 1.0.3.649: the Stage 1 request needs its Division / Department set (or a new Stage 1 request).`
      : '')
  return Object.assign(new Error(`${message.trim()}${detail}`), {
    status: (error as { status?: number }).status ?? 422,
    cause: error,
  })
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
  } catch (error) {
    // BC before 1.0.3.636: no Stage 2 yet, so nothing waits. Every other BC error is shown.
    if (otPaymentServiceMissing(error)) return []
    throw error
  }
}

export async function decideOtPaymentApproval(input: {
  approverUserIds: string
  paymentNo: string
  approve: boolean
  remarks: string
}) {
  const remarks = input.remarks.trim().slice(0, 250)
  // BC 1.0.3.649: the Workflow User Group approves Stage 2; approval remarks are optional.
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

function sameId(left: string, right: string) {
  return Boolean(left) && left.trim().toUpperCase() === right.trim().toUpperCase()
}

/** The acting user is the employee, the line manager BC stamped, or one of the request's approvers. */
export function otPaymentActingUserMayView(request: OtPaymentRequest, actingIds: string[], employeeNo = '') {
  if (employeeNo && sameId(request.employeeNo, employeeNo)) return true
  return actingIds.some(
    (id) =>
      sameId(request.superiorUserId, id) || request.steps.some((step) => sameId(step.approverUserId, id)),
  )
}

/** The decision this approver took on the payment request, for Approved / Rejected Documents. */
export function otPaymentApproverOutcome(request: OtPaymentRequest, actingIds: string[]) {
  const mine = request.steps
    .filter((step) => actingIds.some((id) => sameId(step.approverUserId, id)))
    .filter((step) => step.status === 'Approved' || step.status === 'Rejected')
  if (!mine.length) return null
  return mine.some((step) => step.status === 'Rejected') ? 'Rejected' : 'Approved'
}

function formatHours(value: number) {
  return `${Number(value.toFixed(2))} hrs`
}

function formatEtb(value: number) {
  return `ETB ${value.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
}

function queueStatus(status: OtPaymentStatus) {
  if (status === 'Approved') return 'Approved'
  if (status === 'Rejected' || status === 'Cancelled') return 'Rejected'
  return 'Pending Approval'
}

export function otPaymentApprovalQueueItem(request: OtPaymentRequest) {
  const pendingStep = request.steps.find((step) => step.status === 'Pending')
  const hours = request.totalHours ? ` (${formatHours(request.totalHours)})` : ''
  return {
    id: `${OT_PAYMENT_MODULE}-${request.paymentNo}`,
    requestNo: request.paymentNo,
    module: OT_PAYMENT_MODULE,
    title: `Overtime payment for ${request.otRequestNo || request.paymentNo}${hours}`,
    makerEmployeeNo: request.employeeNo,
    makerName: request.employeeName,
    amount: request.estimatedAmount,
    status: queueStatus(request.status),
    submittedAt: request.submittedAt || request.createdAt,
    approverEmployeeNo: pendingStep?.approverUserId ?? request.superiorUserId,
    sourceDocumentNo: request.paymentNo,
  }
}

/** The Approvals detail facts: what the Workflow User Group approver needs to decide the payment. */
export function otPaymentDetailFacts(request: OtPaymentRequest) {
  const stage1 = request.otRequest
  const facts: Array<{ label: string; value: string }> = [
    { label: 'Overtime Request (Stage 1)', value: request.otRequestNo },
    { label: 'Overtime dates', value: stage1 ? overtimeDateRange(stage1) : '' },
    { label: 'Overtime hours', value: request.totalHours ? formatHours(request.totalHours) : '' },
    { label: 'Estimated amount', value: request.estimatedAmount ? formatEtb(request.estimatedAmount) : '' },
    { label: 'Work completed on', value: request.workCompletedOn },
    { label: 'Employee remarks', value: request.employeeRemarks },
    { label: 'Stage 1 reason / justification', value: stage1?.reason ?? '' },
    { label: 'Designation', value: request.designation },
    { label: 'Department', value: request.departmentName || request.departmentCode },
    { label: 'Cost centre', value: request.costCentre },
    { label: 'Approval remarks', value: request.superiorJustification },
    { label: 'Division', value: request.divisionName || request.divisionCode },
    { label: 'On overtime sheet', value: request.addedToSheet ? 'Yes' : '' },
  ]
  return facts.filter((fact) => fact.value)
}

type PortalStepStatus = 'Submitted' | 'Waiting' | 'Pending Approval' | 'Approved' | 'Rejected' | 'Cancelled'

function portalStepStatus(status: OvertimeStep['status']): PortalStepStatus {
  if (status === 'Pending') return 'Pending Approval'
  if (status === 'Approved' || status === 'Rejected' || status === 'Cancelled') return status
  return 'Waiting'
}

/** Approvals detail: the Stage 2 payment request, its Workflow User Group steps and the Stage 1 lines, as a PortalRequest. */
export function otPaymentToPortalRequest(request: OtPaymentRequest, actingUserId = '') {
  const queue = otPaymentApprovalQueueItem(request)
  const pendingStep = request.steps.find((step) => step.status === 'Pending')
  const lines = request.otRequest ? overtimeDocumentLines(request.otRequest) : []
  const approvalSteps = [
    {
      id: 'maker',
      actorEmployeeNo: request.employeeNo,
      actorName: request.employeeName,
      role: 'Maker' as const,
      status: 'Submitted' as const,
      timestamp: request.submittedAt || request.createdAt,
      note: 'Overtime payment request submitted from the self-service portal',
      sequenceNo: 0,
    },
    ...request.steps.map((step, index) => ({
      id: `stage-${step.stage || index + 1}`,
      actorEmployeeNo: step.approverUserId,
      actorName: `${step.label || 'Approver'}: ${step.approverName || step.approverUserId || 'not set'}`,
      role: 'Checker' as const,
      status: portalStepStatus(step.status),
      timestamp: step.decidedAt || '',
      note: step.status === 'Skipped' ? step.skipReason : step.comment,
      sequenceNo: step.stage || index + 1,
    })),
  ]
  return {
    id: queue.id,
    requestNo: request.paymentNo,
    requestType: OT_PAYMENT_MODULE,
    title: queue.title,
    status: queue.status,
    makerEmployeeNo: request.employeeNo,
    makerName: request.employeeName,
    departmentCode: request.departmentCode,
    departmentName: request.departmentName,
    responsibleCenter: '',
    amount: request.estimatedAmount,
    sourceDocument: { documentNo: request.paymentNo, erpEntity: 'Overtime Payment Request' },
    createdAt: request.createdAt || request.submittedAt,
    submittedAt: request.submittedAt || request.createdAt,
    approverEmployeeNo: actingUserId || pendingStep?.approverUserId || request.superiorUserId,
    approverName: pendingStep?.approverName || actingUserId,
    auditTrail: [],
    approvalSteps,
    attachments: [],
    payload: {
      sourceDocumentAvailable: true,
      hideDocumentLines: lines.length === 0,
      commentRequiredOnReject: true,
      /** BC 1.0.3.649: approval remarks are optional (BC before 649 still asks for a Superior justification). */
      commentRequiredOnApprove: false,
      pendingStage: pendingStep?.stage ?? request.stage,
      pendingStageLabel: pendingStep?.label ?? request.stageLabel,
      bcStatus: request.status,
      reason: request.employeeRemarks,
      totalHours: request.totalHours,
      otRequestNo: request.otRequestNo,
      workCompletedOn: request.workCompletedOn,
      superiorJustification: request.superiorJustification,
      addedToSheet: request.addedToSheet,
      detailFacts: otPaymentDetailFacts(request),
      overtimePayment: { ...request, raw: undefined },
      lines,
    },
  }
}
