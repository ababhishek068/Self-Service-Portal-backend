import { callSoapMethod, codeunitSoapNamespace, deriveCodeunitSoapUrl } from './bcClient.js'
import { config } from './config.js'

export const EMPLOYEE_EXIT_SERVICE_NAME = 'CuPortalEmployeeExit'

/**
 * Swap the trailing service name of the CuStaffPortal SOAP URL for the Employee Exit one,
 * preserving any query string. A naive replace on the raw URL mangles the service name
 * when the configured URL carries a `?tenant=` or a trailing slash.
 */
export function deriveEmployeeExitSoapUrl(
  baseUrl: string,
  serviceName = EMPLOYEE_EXIT_SERVICE_NAME,
) {
  return deriveCodeunitSoapUrl(baseUrl, serviceName)
}

const employeeExitSoapEndpoint = {
  url:
    config.BC_SOAP_EXIT_CODEUNIT_URL ?? deriveEmployeeExitSoapUrl(config.BC_SOAP_CODEUNIT_URL),
  namespace:
    config.BC_SOAP_EXIT_NAMESPACE ?? codeunitSoapNamespace(EMPLOYEE_EXIT_SERVICE_NAME),
}

/**
 * BC answers an unpublished web service with "Service ... was not found", which is a
 * deployment problem, not a user error — say so instead of leaking the raw SOAP fault.
 */
function employeeExitCallError(error: unknown) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  if (/was not found|could not be found|not found/i.test(message)) {
    return Object.assign(
      new Error(
        `The Employee Exit codeunit is not published in Business Central. Deploy the Employee Exit extension and publish codeunit 52101 as the web service "${EMPLOYEE_EXIT_SERVICE_NAME}".`,
      ),
      { status: 503, code: 'EMPLOYEE_EXIT_SERVICE_MISSING' },
    )
  }
  return error
}

async function callExitSoap(method: string, params: Record<string, unknown>) {
  try {
    return await callSoapMethod(method, params, employeeExitSoapEndpoint)
  } catch (error) {
    throw employeeExitCallError(error)
  }
}

export const EMPLOYEE_EXIT_REQUEST_TYPES = [
  'transfer',
  'resignation',
  'exit-interview',
] as const

export type EmployeeExitRequestType = (typeof EMPLOYEE_EXIT_REQUEST_TYPES)[number]
export type EmployeeExitRequestStatus =
  | 'Open'
  | 'Pending Approval'
  | 'Pending HR Approval'
  | 'Approved'
  | 'Rejected'
  | 'Cancellation Pending Approval'
  | 'Cancelled'
  | 'Completed'

export type EmployeeExitRequest = {
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
  /** Present only on the approver's queue: which stage is waiting on this approver. */
  pendingStage?: number
  pendingStageLabel?: string
}

const TYPE_LABELS: Record<EmployeeExitRequestType, string> = {
  transfer: 'Transfer Request',
  resignation: 'Resignation Application',
  'exit-interview': 'Employee Exit Form',
}

const PREFIXES: Record<EmployeeExitRequestType, string> = {
  transfer: 'TRF',
  resignation: 'RES',
  'exit-interview': 'EXI',
}

/** Transfer and Resignation are approvals; Employee Exit is sent to HR for information only. */
export function employeeExitApprovalRequired(requestType: EmployeeExitRequestType) {
  return requestType !== 'exit-interview'
}

const REQUIRED_DETAILS: Record<EmployeeExitRequestType, string[]> = {
  transfer: [
    'typeOfTransfer',
    'desiredDepartment',
    'desiredLocation',
    'requestedEffectiveDate',
    'reason',
    'handoverPlan',
  ],
  resignation: [
    'lastWorkingDate',
    'resignationReason',
    'noticePeriodAcknowledged',
    'handoverPlan',
    'personalEmail',
    'personalPhone',
  ],
  // Mirrors Hijra Bank's 17-07-2026 Employee Exit SSP template.
  // UAT 22-07-2026 (HB): transfer type removed from the exit interview.
  'exit-interview': [
    'supervisorName',
    'contractTerminationDate',
    'leavingReasons',
    'joiningAnotherCompany',
    'startOwnBusiness',
    'wouldReturn',
    'mostSatisfying',
    'mostFrustrating',
    'confidentialityAcknowledged',
  ],
}

const FIELD_LABELS: Record<string, string> = {
  desiredDepartment: 'Requested department',
  desiredLocation: 'Requested branch or duty station',
  transferType: 'Transfer type',
  typeOfTransfer: 'Type of transfer',
  requestedEffectiveDate: 'Requested effective date',
  reason: 'Reason for transfer',
  handoverPlan: 'Handover plan',
  lastWorkingDate: 'Proposed last working date',
  resignationReason: 'Reason for resignation',
  noticePeriodAcknowledged: 'Notice-period acknowledgement',
  personalEmail: 'Personal email',
  personalPhone: 'Personal phone',
  exitInterviewDate: 'Proposed exit interview date',
  supervisorName: 'Immediate supervisor at time of termination',
  contractTerminationDate: 'Date contract is terminated',
  leavingReasons: 'Reason(s) for leaving Hijra Bank',
  mainReason: 'Primary reason for leaving',
  joiningAnotherCompany: 'Joining another company',
  newEmployerSectorOther: 'Other sector of the new organisation',
  startOwnBusiness: 'Starting own business',
  otherPlans: 'Other plans after leaving',
  wouldReturn: 'Would consider returning to Hijra Bank',
  mostSatisfying: 'Most satisfying during your stay',
  mostFrustrating: 'Most frustrating during your stay',
  improvements: 'Suggested improvements',
  confidentialityAcknowledged: 'Information confirmation',
}

function localDateIso(now = new Date()) {
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

function isIsoDate(value: string) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false
  const parsed = new Date(`${value}T00:00:00Z`)
  return !Number.isNaN(parsed.getTime()) && parsed.toISOString().slice(0, 10) === value
}

function cleanDetails(details: Record<string, unknown>) {
  return Object.fromEntries(
    Object.entries(details)
      .slice(0, 40)
      .map(([key, value]) => [key.slice(0, 80), String(value ?? '').trim().slice(0, 4000)]),
  )
}

function soapTrue(value: unknown) {
  return ['true', '1', 'yes'].includes(String(value ?? '').trim().toLowerCase())
}

function parseRows(value: unknown): EmployeeExitRequest[] {
  if (!value) return []
  let parsed: unknown
  try {
    parsed = JSON.parse(String(value))
  } catch {
    throw Object.assign(new Error('Business Central returned invalid Employee Exit data.'), {
      status: 502,
    })
  }
  if (!Array.isArray(parsed)) return []
  return parsed.filter((row): row is EmployeeExitRequest => {
    if (!row || typeof row !== 'object') return false
    const request = row as Partial<EmployeeExitRequest>
    return Boolean(
      request.id &&
      request.requestNo &&
      EMPLOYEE_EXIT_REQUEST_TYPES.includes(request.requestType as EmployeeExitRequestType),
    )
  })
}

export function nextEmployeeExitRequestNo(
  rows: Array<Pick<EmployeeExitRequest, 'requestNo'>>,
  requestType: EmployeeExitRequestType,
  year: number,
) {
  const prefix = `${PREFIXES[requestType]}-${year}-`
  const maximum = rows.reduce((current, row) => {
    if (!row.requestNo.startsWith(prefix)) return current
    const match = new RegExp(`^${PREFIXES[requestType]}-\\d{4}-(\\d+)$`).exec(row.requestNo)
    return Math.max(current, match ? Number(match[1]) : 0)
  }, 0)
  return `${prefix}${String(maximum + 1).padStart(4, '0')}`
}

export function validateEmployeeExitDetails(
  requestType: EmployeeExitRequestType,
  details: Record<string, string>,
  today = localDateIso(),
) {
  const errors: string[] = []
  const missing = REQUIRED_DETAILS[requestType].filter((key) => !details[key]?.trim())
  if (missing.length > 0) {
    errors.push(
      `Complete the required fields: ${missing.map((key) => FIELD_LABELS[key] ?? key).join(', ')}.`,
    )
  }

  // The contract termination date on the official exit interview form may already be in the
  // past when the interview is filled in, so only the forward-looking requests enforce it.
  const dateField = requestType === 'transfer'
    ? 'requestedEffectiveDate'
    : requestType === 'resignation'
      ? 'lastWorkingDate'
      : 'contractTerminationDate'
  const dateValue = details[dateField]?.trim()
  if (dateValue && !isIsoDate(dateValue)) {
    errors.push(`${FIELD_LABELS[dateField] ?? dateField} must be a valid date.`)
  } else if (dateValue && requestType !== 'exit-interview' && dateValue < today) {
    errors.push(`${FIELD_LABELS[dateField] ?? dateField} cannot be in the past.`)
  }

  if (requestType === 'resignation' && details.noticePeriodAcknowledged !== 'Yes') {
    errors.push('You must acknowledge the contractual notice-period requirement.')
  }

  if (requestType === 'exit-interview') {
    for (const key of ['joiningAnotherCompany', 'startOwnBusiness']) {
      if (details[key] && !['Yes', 'No'].includes(details[key])) {
        errors.push(`${FIELD_LABELS[key] ?? key} must be Yes or No.`)
      }
    }
    if (details.wouldReturn && !['Yes', 'No', 'Maybe'].includes(details.wouldReturn)) {
      errors.push('Answer whether you would consider returning to Hijra Bank (Yes, No, or Maybe).')
    }

    if (details.confidentialityAcknowledged !== 'Yes') {
      errors.push('You must confirm that the Employee Exit information is accurate and may be reviewed by HR.')
    }
  }

  return errors
}

export async function listEmployeeExitRequests(employeeNo: string) {
  const result = await callExitSoap('GetEmployeeExitRequests', { employeeNo })
  return parseRows(result.returnValue).sort((left, right) =>
    right.submittedAt.localeCompare(left.submittedAt),
  )
}

export async function createEmployeeExitRequest(input: {
  requestType: EmployeeExitRequestType
  employeeNo: string
  requesterUserId: string
  employeeName: string
  departmentName: string
  details: Record<string, unknown>
}) {
  const details = cleanDetails({
    ...input.details,
    employeeName: input.employeeName,
    departmentName: input.departmentName,
  })
  const errors = validateEmployeeExitDetails(input.requestType, details)
  if (errors.length > 0) {
    throw Object.assign(new Error(errors.join(' ')), { status: 422 })
  }

  const saved = await callExitSoap('SaveEmployeeExitRequestRouted', {
    employeeNo: input.employeeNo,
    requesterUserId: input.requesterUserId,
    requestType: input.requestType,
    detailsJson: JSON.stringify(details),
  })
  const requestNo = String(saved.returnValue ?? '').trim()
  if (!requestNo) {
    throw Object.assign(new Error('Business Central did not return an Employee Exit request number.'), {
      status: 502,
    })
  }

  const approval = await callExitSoap('SubmitEmployeeExitForApproval', {
    employeeNo: input.employeeNo,
    requestNo,
  })
  if (!soapTrue(approval.returnValue)) {
    throw Object.assign(new Error('Business Central did not submit the Employee Exit request.'), {
      status: 422,
    })
  }

  const request = (await listEmployeeExitRequests(input.employeeNo)).find(
    (row) => row.requestNo === requestNo,
  )
  if (request) return request

  const now = new Date().toISOString()
  return {
    id: requestNo,
    requestNo,
    requestType: input.requestType,
    requestTypeLabel: TYPE_LABELS[input.requestType],
    status: input.requestType === 'exit-interview' ? 'Completed' : 'Pending Approval',
    submittedAt: now,
    updatedAt: now,
    employeeNo: input.employeeNo,
    employeeName: input.employeeName,
    departmentName: input.departmentName,
    details,
    approvalRequired: employeeExitApprovalRequired(input.requestType),
    erpWorkflowConnected: true,
    requesterUserId: input.requesterUserId,
  } satisfies EmployeeExitRequest
}

export async function requestEmployeeExitCancellation(input: {
  id: string
  employeeNo: string
  reason: string
}) {
  const reason = input.reason.trim()
  if (reason.length < 10) {
    throw Object.assign(new Error('Cancellation reason must contain at least 10 characters.'), {
      status: 422,
    })
  }

  const result = await callExitSoap('RequestEmployeeExitCancellation', {
    employeeNo: input.employeeNo,
    requestNo: input.id,
    cancellationReason: reason,
  })
  if (!soapTrue(result.returnValue)) {
    throw Object.assign(new Error('Business Central did not create the cancellation approval request.'), {
      status: 422,
    })
  }
  return (await listEmployeeExitRequests(input.employeeNo)).find((row) => row.requestNo === input.id) ?? null
}

/**
 * Withdraw a request that is still Open or Pending Approval — the employee's own not-yet-approved
 * submission. Unlike requestEmployeeExitCancellation (which reverses an already-approved request
 * through a second approval), this cancels outright so the employee can raise a new one.
 */
export async function withdrawEmployeeExitRequest(input: { id: string; employeeNo: string }) {
  const result = await callExitSoap('WithdrawEmployeeExitRequest', {
    employeeNo: input.employeeNo,
    requestNo: input.id,
  })
  if (!soapTrue(result.returnValue)) return null
  return (
    (await listEmployeeExitRequests(input.employeeNo)).find((row) => row.requestNo === input.id) ??
    null
  )
}

/** Load one exit request by document number (no employee filter). */
export async function getEmployeeExitRequestByNo(requestNo: string) {
  const trimmed = requestNo.trim()
  if (!trimmed) return null
  try {
    const result = await callExitSoap('GetEmployeeExitRequestByNo', { requestNo: trimmed })
    return parseRows(result.returnValue)[0] ?? null
  } catch {
    return null
  }
}

export function employeeExitSoapApprovalsMissing(error: unknown) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  return /GetEmployeeExitApprovals|GetEmployeeExitRequestByNo|DecideEmployeeExitApproval|not found|was not found/i.test(
    message,
  )
}

/**
 * Requests (Transfer / Resignation) currently waiting on `approverUserId` — the Immediate
 * Supervisor at stage 1, HR at stage 2. Powers the "Employee Exit" tab in the portal Approvals.
 * BC SetFilter on Approver ID is safest with one id per SOAP call, so merge each candidate.
 */
export async function listEmployeeExitApprovals(approverUserIds: string) {
  const ids = [
    ...new Set(
      approverUserIds
        .split('|')
        .map((id) => id.trim())
        .filter(Boolean),
    ),
  ]
  if (!ids.length) return []

  const merged = new Map<string, EmployeeExitRequest>()
  let soapMissing = false

  for (const id of ids) {
    try {
      const result = await callExitSoap('GetEmployeeExitApprovals', { approverUserIds: id })
      for (const row of parseRows(result.returnValue)) merged.set(row.requestNo, row)
    } catch (error) {
      if (employeeExitSoapApprovalsMissing(error)) soapMissing = true
      else throw error
    }
  }

  if (!merged.size && ids.length > 1 && !soapMissing) {
    const result = await callExitSoap('GetEmployeeExitApprovals', { approverUserIds: ids.join('|') })
    for (const row of parseRows(result.returnValue)) merged.set(row.requestNo, row)
  }

  if (soapMissing && !merged.size) return []

  return [...merged.values()].sort((left, right) => right.submittedAt.localeCompare(left.submittedAt))
}

/**
 * Approve or reject an Employee Exit request AS the logged-in approver. The BC SOAP session runs
 * as the service account, so the real approver id is passed and validated in AL against the open
 * approval entry. A reason is required to reject.
 */
export async function decideEmployeeExitApproval(input: {
  approverUserId: string
  id: string
  approve: boolean
  remarks?: string
}) {
  const remarks = (input.remarks ?? '').trim()
  if (!input.approve && remarks.length < 3) {
    throw Object.assign(new Error('A reason is required to reject a request.'), { status: 422 })
  }
  const result = await callExitSoap('DecideEmployeeExitApproval', {
    approverUserIds: input.approverUserId,
    requestNo: input.id,
    approve: input.approve ? 'true' : 'false',
    remarks,
  })
  if (!soapTrue(result.returnValue)) {
    throw Object.assign(new Error('Business Central did not record the approval decision.'), {
      status: 422,
    })
  }
  return listEmployeeExitApprovals(input.approverUserId)
}
