import { callSoapMethod } from './bcClient.js'

/**
 * Staff Overtime Request (BC 1.0.3.606, codeunit "ABH Overtime Request Mgt" through the Staff
 * Portal Codeunit): the employee asks, then the Line Manager, HR, the Director / COO and Finance
 * approve one after the other; the approved hours go to the Overtime Sheet of the open payroll
 * period, which HR sends to payroll.
 */
export const OVERTIME_MODULE = 'overtime' as const

export const OVERTIME_DAY_TYPES = ['working', 'restDay', 'holiday'] as const
export type OvertimeDayType = (typeof OVERTIME_DAY_TYPES)[number]

export type OvertimeStepStatus =
  | 'Not started'
  | 'Waiting'
  | 'Pending'
  | 'Approved'
  | 'Rejected'
  | 'Cancelled'
  | 'Skipped'

export type OvertimeStep = {
  stage: number
  label: string
  approverUserId: string
  approverName: string
  status: OvertimeStepStatus
  skipped: boolean
  skipReason: string
  decidedAt: string
  comment: string
}

export type OvertimeLogEntry = {
  at: string
  stage: number
  stageLabel: string
  action: string
  userId: string
  userName: string
  comment: string
}

export type OvertimeRequestStatus = 'Draft' | 'Pending Approval' | 'Approved' | 'Rejected'

/** One overtime date and time of a request (BC 1.0.3.612; older requests have one). */
export type OvertimeLine = {
  lineNo: number
  overtimeDate: string
  startTime: string
  endTime: string
  dayType: OvertimeDayType
  dayTypeLabel: string
  totalHours: number
  normalHours: number
  nightHours: number
  restDayHours: number
  holidayHours: number
  estimatedAmount: number
  reason: string
}

export type OvertimeRequest = {
  id: string
  requestNo: string
  status: OvertimeRequestStatus
  stage: number
  stageLabel: string
  employeeNo: string
  employeeName: string
  designation: string
  departmentCode: string
  departmentName: string
  costCentre: string
  projectNo: string
  projectName: string
  overtimeDate: string
  startTime: string
  endTime: string
  dayType: OvertimeDayType
  dayTypeLabel: string
  totalHours: number
  normalHours: number
  nightHours: number
  restDayHours: number
  holidayHours: number
  hourlyRate: number
  estimatedAmount: number
  reason: string
  warnings: string
  requesterUserId: string
  createdAt: string
  submittedAt: string
  approvedAt: string
  rejectedAtStage: string
  decisionRemarks: string
  sheetNo: string
  addedToSheet: boolean
  addedAt: string
  sheetNote: string
  sheetStatus: string
  payrollPeriodName: string
  sentToPayroll: boolean
  sentToPayrollAt: string
  steps: OvertimeStep[]
  log: OvertimeLogEntry[]
  lines: OvertimeLine[]
  /** False when BC (before 1.0.3.612) returned no lines: the one line comes from the request. */
  linesFromBc: boolean
}

export type OvertimeContext = {
  employee: {
    employeeNo: string
    employeeName: string
    designation: string
    departmentCode: string
    departmentName: string
    costCentre: string
    active: boolean
    allowOvertime: boolean
    hasBasicPay: boolean
    paySuspended: boolean
  }
  rates: { normal: number; night: number; restDay: number; holiday: number }
  monthlyHours: number
  maxHoursPerMonth: number
  hourlyRate: number
  approvers: OvertimeStep[]
  routingProblem: string
  /** BC 1.0.3.612: one request can hold several dates and times. */
  supportsLines: boolean
  maxLines: number
}

export type OvertimeLineInput = {
  overtimeDate: string
  startTime: string
  endTime: string
  dayType: OvertimeDayType
  reason: string
}

/** The first line is also sent as the request's own date and time (BC before 1.0.3.612 reads only those). */
export type OvertimeDetails = OvertimeLineInput & {
  projectNo: string
  lines: OvertimeLineInput[]
}

const STEP_STATUSES: OvertimeStepStatus[] = [
  'Not started',
  'Waiting',
  'Pending',
  'Approved',
  'Rejected',
  'Cancelled',
  'Skipped',
]
const REQUEST_STATUSES: OvertimeRequestStatus[] = ['Draft', 'Pending Approval', 'Approved', 'Rejected']

function str(value: unknown) {
  return value === undefined || value === null ? '' : String(value).trim()
}

function num(value: unknown) {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : 0
}

function bool(value: unknown) {
  return value === true || ['true', '1', 'yes'].includes(str(value).toLowerCase())
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
    throw Object.assign(new Error('Business Central returned an overtime answer the portal could not read.'), {
      status: 502,
    })
  }
}

function dayTypeOf(value: unknown): OvertimeDayType {
  const text = str(value)
  return (OVERTIME_DAY_TYPES as readonly string[]).includes(text) ? (text as OvertimeDayType) : 'working'
}

export function parseOvertimeStep(value: unknown): OvertimeStep {
  const row = record(value)
  const status = str(row.status) as OvertimeStepStatus
  return {
    stage: num(row.stage),
    label: str(row.label),
    approverUserId: str(row.approverUserId),
    approverName: str(row.approverName) || str(row.approverUserId),
    status: STEP_STATUSES.includes(status) ? status : 'Waiting',
    skipped: bool(row.skipped),
    skipReason: str(row.skipReason),
    decidedAt: str(row.decidedAt),
    comment: str(row.comment),
  }
}

function parseOvertimeLine(value: unknown, index: number): OvertimeLine {
  const row = record(value)
  return {
    lineNo: num(row.lineNo) || (index + 1) * 10000,
    overtimeDate: str(row.overtimeDate),
    startTime: str(row.startTime),
    endTime: str(row.endTime),
    dayType: dayTypeOf(row.dayType),
    dayTypeLabel: str(row.dayTypeLabel),
    totalHours: num(row.totalHours),
    normalHours: num(row.normalHours),
    nightHours: num(row.nightHours),
    restDayHours: num(row.restDayHours),
    holidayHours: num(row.holidayHours),
    estimatedAmount: num(row.estimatedAmount),
    reason: str(row.reason),
  }
}

export function parseOvertimeRequest(value: unknown): OvertimeRequest {
  const row = record(value)
  const status = str(row.status) as OvertimeRequestStatus
  const linesFromBc = Array.isArray(row.lines) && row.lines.length > 0
  const lines = linesFromBc
    ? (row.lines as unknown[]).map(parseOvertimeLine)
    : str(row.overtimeDate)
      ? [parseOvertimeLine(row, 0)]
      : []
  return {
    id: str(row.id) || str(row.requestNo),
    requestNo: str(row.requestNo) || str(row.id),
    status: REQUEST_STATUSES.includes(status) ? status : 'Draft',
    stage: num(row.stage),
    stageLabel: str(row.stageLabel),
    employeeNo: str(row.employeeNo),
    employeeName: str(row.employeeName),
    designation: str(row.designation),
    departmentCode: str(row.departmentCode),
    departmentName: str(row.departmentName),
    costCentre: str(row.costCentre),
    projectNo: str(row.projectNo),
    projectName: str(row.projectName),
    overtimeDate: str(row.overtimeDate),
    startTime: str(row.startTime),
    endTime: str(row.endTime),
    dayType: dayTypeOf(row.dayType),
    dayTypeLabel: str(row.dayTypeLabel),
    totalHours: num(row.totalHours),
    normalHours: num(row.normalHours),
    nightHours: num(row.nightHours),
    restDayHours: num(row.restDayHours),
    holidayHours: num(row.holidayHours),
    hourlyRate: num(row.hourlyRate),
    estimatedAmount: num(row.estimatedAmount),
    reason: str(row.reason),
    warnings: str(row.warnings),
    requesterUserId: str(row.requesterUserId),
    createdAt: str(row.createdAt),
    submittedAt: str(row.submittedAt),
    approvedAt: str(row.approvedAt),
    rejectedAtStage: str(row.rejectedAtStage),
    decisionRemarks: str(row.decisionRemarks),
    sheetNo: str(row.sheetNo),
    addedToSheet: bool(row.addedToSheet),
    addedAt: str(row.addedAt),
    sheetNote: str(row.sheetNote),
    sheetStatus: str(row.sheetStatus),
    payrollPeriodName: str(row.payrollPeriodName),
    sentToPayroll: bool(row.sentToPayroll),
    sentToPayrollAt: str(row.sentToPayrollAt),
    steps: (Array.isArray(row.steps) ? row.steps : []).map(parseOvertimeStep),
    log: (Array.isArray(row.log) ? row.log : []).map((entry) => {
      const item = record(entry)
      return {
        at: str(item.at),
        stage: num(item.stage),
        stageLabel: str(item.stageLabel),
        action: str(item.action),
        userId: str(item.userId),
        userName: str(item.userName) || str(item.userId),
        comment: str(item.comment),
      }
    }),
    lines,
    linesFromBc,
  }
}

export function parseOvertimeRequests(value: unknown): OvertimeRequest[] {
  const parsed = parseJson(value)
  return (Array.isArray(parsed) ? parsed : []).map(parseOvertimeRequest)
}

export function parseOvertimeContext(value: unknown): OvertimeContext {
  const root = record(parseJson(value))
  const employee = record(root.employee)
  const rates = record(root.rates)
  return {
    employee: {
      employeeNo: str(employee.employeeNo),
      employeeName: str(employee.employeeName),
      designation: str(employee.designation),
      departmentCode: str(employee.departmentCode),
      departmentName: str(employee.departmentName),
      costCentre: str(employee.costCentre),
      active: employee.active === undefined ? true : bool(employee.active),
      allowOvertime: employee.allowOvertime === undefined ? true : bool(employee.allowOvertime),
      hasBasicPay: bool(employee.hasBasicPay),
      paySuspended: bool(employee.paySuspended),
    },
    rates: {
      normal: num(rates.normal) || 1.5,
      night: num(rates.night) || 1.75,
      restDay: num(rates.restDay) || 2,
      holiday: num(rates.holiday) || 2.5,
    },
    monthlyHours: num(root.monthlyHours) || 208,
    maxHoursPerMonth: num(root.maxHoursPerMonth),
    hourlyRate: num(root.hourlyRate),
    approvers: (Array.isArray(root.approvers) ? root.approvers : []).map(parseOvertimeStep),
    routingProblem: str(root.routingProblem),
    supportsLines: bool(root.supportsLines),
    maxLines: num(root.maxLines) || (bool(root.supportsLines) ? OVERTIME_MAX_LINES : 1),
  }
}

const TIME_PATTERN = /^([01]?\d|2[0-3]):([0-5]\d)$/

function minutesOf(time: string) {
  const match = TIME_PATTERN.exec(time.trim())
  if (!match) return null
  return Number(match[1]) * 60 + Number(match[2])
}

function overlap(fromA: number, toA: number, fromB: number, toB: number) {
  return Math.max(0, Math.min(toA, toB) - Math.max(fromA, fromB))
}

/**
 * The same split as Business Central: an end before the start is the next morning; on a working
 * day 6 AM - 10 PM is normal day overtime and the rest night overtime; on a weekly rest day or a
 * public holiday every hour is in that band.
 */
export function splitOvertimeHours(startTime: string, endTime: string, dayType: OvertimeDayType) {
  const start = minutesOf(startTime)
  let end = minutesOf(endTime)
  const empty = { totalHours: 0, normalHours: 0, nightHours: 0, restDayHours: 0, holidayHours: 0 }
  if (start === null || end === null || start === end) return empty
  if (end < start) end += 1440
  const round = (minutes: number) => Math.round((minutes / 60) * 100) / 100
  const totalHours = round(end - start)
  if (dayType === 'restDay') return { ...empty, totalHours, restDayHours: totalHours }
  if (dayType === 'holiday') return { ...empty, totalHours, holidayHours: totalHours }
  const normalHours = round(overlap(start, end, 360, 1320) + overlap(start, end, 1800, 2760))
  return { ...empty, totalHours, normalHours, nightHours: Math.round((totalHours - normalHours) * 100) / 100 }
}

function isIsoDate(value: string) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false
  const parsed = new Date(`${value}T00:00:00Z`)
  return !Number.isNaN(parsed.getTime()) && parsed.toISOString().slice(0, 10) === value
}

function invalid(message: string) {
  return Object.assign(new Error(message), { status: 422, code: 'OVERTIME_INVALID' })
}

export const OVERTIME_MAX_LINES = 31

function dayNumber(date: string) {
  return Date.UTC(Number(date.slice(0, 4)), Number(date.slice(5, 7)) - 1, Number(date.slice(8, 10))) / 86_400_000
}

/** The minutes a line covers, counted from 1 January 1970 (an end before the start is the next morning). */
export function overtimeSlot(line: Pick<OvertimeLineInput, 'overtimeDate' | 'startTime' | 'endTime'>) {
  const start = minutesOf(line.startTime) ?? 0
  let end = minutesOf(line.endTime) ?? 0
  if (end <= start) end += 1440
  const base = dayNumber(line.overtimeDate) * 1440
  return { start: base + start, end: base + end }
}

function validateLine(input: unknown, submit: boolean, prefix: string): OvertimeLineInput {
  const body = record(input)
  const line: OvertimeLineInput = {
    overtimeDate: str(body.overtimeDate),
    startTime: str(body.startTime).slice(0, 5),
    endTime: str(body.endTime).slice(0, 5),
    dayType: dayTypeOf(body.dayType),
    reason: str(body.reason).slice(0, 250),
  }
  if (!isIsoDate(line.overtimeDate)) throw invalid(`${prefix}Enter the overtime date.`)
  if (minutesOf(line.startTime) === null) throw invalid(`${prefix}Enter the start time, for example 17:00.`)
  if (minutesOf(line.endTime) === null) throw invalid(`${prefix}Enter the end time, for example 21:00.`)
  if (line.startTime === line.endTime) throw invalid(`${prefix}The end time must be different from the start time.`)
  if (submit && line.reason.length < 3) throw invalid(`${prefix}Enter the reason / justification for the overtime.`)
  return line
}

/**
 * What the portal sends to BC: one or more lines (date, times, category, reason), sorted by date,
 * none overlapping another. BC checks them again (other requests, routing, the monthly limit).
 */
export function validateOvertimeDetails(input: unknown, submit: boolean): OvertimeDetails {
  const body = record(input)
  const rawLines = Array.isArray(body.lines) && body.lines.length ? body.lines : [body]
  if (rawLines.length > OVERTIME_MAX_LINES) {
    throw invalid(`One overtime request can have at most ${OVERTIME_MAX_LINES} lines. Make a second request for the other days.`)
  }
  const lines = rawLines
    .map((line, index) => validateLine(line, submit, rawLines.length > 1 ? `Line ${index + 1}: ` : ''))
    .sort((left, right) => (left.overtimeDate + left.startTime).localeCompare(right.overtimeDate + right.startTime))
  for (let index = 0; index < lines.length; index += 1) {
    for (let other = index + 1; other < lines.length; other += 1) {
      const a = overtimeSlot(lines[index]!)
      const b = overtimeSlot(lines[other]!)
      if (overlap(a.start, a.end, b.start, b.end) > 0) {
        const describe = (line: OvertimeLineInput) => `${line.overtimeDate} ${line.startTime}–${line.endTime}`
        throw invalid(`Two overtime lines overlap: ${describe(lines[index]!)} and ${describe(lines[other]!)}.`)
      }
    }
  }
  const reasons = [...new Set(lines.map((line) => line.reason).filter(Boolean))]
  const first = lines[0]!
  return {
    ...first,
    reason: (str(body.reason) || reasons.join('; ')).slice(0, 500),
    projectNo: str(body.projectNo).toUpperCase().slice(0, 20),
    lines,
  }
}

/** BC without package 1.0.3.606 does not know the overtime methods. */
export function overtimeServiceMissing(error: unknown) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  // Only BC without the method ("Method 'X' is invalid"); every other BC message is shown as BC wrote it.
  return /Method '?PortalOvertime\w*'? is invalid|PortalOvertime\w*.*(not found|not published)|soapaction/i.test(message)
}

function overtimeCallError(error: unknown) {
  if (overtimeServiceMissing(error)) {
    return Object.assign(
      new Error(
        'Overtime Request needs Business Central package 1.0.3.606. Ask the BC administrator to publish it.',
      ),
      { status: 503, code: 'OVERTIME_SERVICE_MISSING' },
    )
  }
  return error
}

async function callOvertime(method: string, params: Record<string, unknown>) {
  try {
    return await callSoapMethod(method, params)
  } catch (error) {
    throw overtimeCallError(error)
  }
}

export async function getOvertimeContext(employeeNo: string, requesterUserId: string) {
  const result = await callOvertime('PortalOvertimeContext', { employeeNo, requesterUserId })
  return parseOvertimeContext(result.returnValue)
}

export async function listOvertimeRequests(employeeNo: string) {
  const result = await callOvertime('PortalOvertimeList', { employeeNo })
  return parseOvertimeRequests(result.returnValue)
}

export async function getOvertimeRequestByNo(requestNo: string) {
  const trimmed = requestNo.trim()
  if (!trimmed) return null
  try {
    const result = await callOvertime('PortalOvertimeByNo', { requestNo: trimmed })
    const parsed = parseJson(result.returnValue)
    return parsed ? parseOvertimeRequest(parsed) : null
  } catch (error) {
    if ((error as { code?: string }).code === 'OVERTIME_SERVICE_MISSING') throw error
    if (/was not found/i.test(String((error as Error)?.message ?? ''))) return null
    throw error
  }
}

export async function saveOvertimeRequest(input: {
  employeeNo: string
  requesterUserId: string
  requestNo?: string
  details: OvertimeDetails
  submit: boolean
}) {
  const result = await callOvertime('PortalOvertimeSave', {
    employeeNo: input.employeeNo,
    requesterUserId: input.requesterUserId,
    requestNo: input.requestNo ?? '',
    detailsJson: JSON.stringify(input.details),
    submitRequest: input.submit,
  })
  const saved = parseOvertimeRequest(parseJson(result.returnValue))
  if (input.details.lines.length > 1 && !saved.linesFromBc) {
    throw Object.assign(
      new Error(
        `Business Central kept only the first line of ${saved.requestNo}: several dates in one request need BC package 1.0.3.612. Ask the BC administrator to publish it, then edit the draft.`,
      ),
      { status: 503, code: 'OVERTIME_LINES_MISSING' },
    )
  }
  return saved
}

export async function withdrawOvertimeRequest(employeeNo: string, requestNo: string) {
  const result = await callOvertime('PortalOvertimeWithdraw', { employeeNo, requestNo })
  return parseOvertimeRequest(parseJson(result.returnValue))
}

export async function deleteOvertimeRequest(employeeNo: string, requestNo: string) {
  const result = await callOvertime('PortalOvertimeDelete', { employeeNo, requestNo })
  if (!bool(result.returnValue)) {
    throw Object.assign(new Error('Business Central did not delete the overtime request.'), { status: 502 })
  }
  return { ok: true, id: requestNo }
}

/** Requests waiting for this approver ('pending') or already decided by them ('decided'). */
export async function listOvertimeApprovals(approverUserIds: string, scope: 'pending' | 'decided' = 'pending') {
  if (!approverUserIds.trim()) return []
  try {
    const result = await callSoapMethod('PortalOvertimeApprovals', { approverUserIds, scope })
    return parseOvertimeRequests(result.returnValue)
  } catch (error) {
    if (overtimeServiceMissing(error)) return []
    throw error
  }
}

export async function decideOvertimeApproval(input: {
  approverUserIds: string
  requestNo: string
  approve: boolean
  remarks: string
}) {
  const remarks = input.remarks.trim().slice(0, 250)
  if (!input.approve && remarks.length < 3) {
    throw Object.assign(new Error('Enter the reason for rejecting (at least 3 characters).'), { status: 422 })
  }
  const result = await callOvertime('PortalOvertimeDecide', {
    approverUserIds: input.approverUserIds,
    requestNo: input.requestNo,
    approve: input.approve,
    remarks,
  })
  return parseOvertimeRequest(parseJson(result.returnValue))
}

function sameId(left: string, right: string) {
  return Boolean(left) && left.trim().toUpperCase() === right.trim().toUpperCase()
}

/** The acting user is the employee or one of the request's approvers. */
export function overtimeActingUserMayView(request: OvertimeRequest, actingIds: string[], employeeNo = '') {
  if (employeeNo && sameId(request.employeeNo, employeeNo)) return true
  return request.steps.some((step) => actingIds.some((id) => sameId(step.approverUserId, id)))
}

/** The decision this approver took on the request (newest step first), for Approved / Rejected Documents. */
export function overtimeApproverOutcome(request: OvertimeRequest, actingIds: string[]) {
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

/** The Approvals detail facts (the reason shows as the Application reason above them). */
export function overtimeDetailFacts(request: OvertimeRequest) {
  const bands = [
    request.normalHours ? `Normal day ${formatHours(request.normalHours)}` : '',
    request.nightHours ? `Night ${formatHours(request.nightHours)}` : '',
    request.restDayHours ? `Rest day ${formatHours(request.restDayHours)}` : '',
    request.holidayHours ? `Public holiday ${formatHours(request.holidayHours)}` : '',
  ].filter(Boolean)
  const several = request.lines.length > 1
  const categories = [...new Set(request.lines.map((line) => line.dayTypeLabel).filter(Boolean))]
  const facts: Array<{ label: string; value: string }> = [
    several
      ? { label: 'Overtime dates', value: `${overtimeDateRange(request)} (${request.lines.length} lines, below)` }
      : { label: 'Overtime date', value: request.overtimeDate },
    {
      label: 'Time',
      value: !several && request.startTime && request.endTime ? `${request.startTime} – ${request.endTime}` : '',
    },
    { label: 'Overtime category', value: several ? categories.join(' · ') : request.dayTypeLabel },
    { label: 'Overtime hours', value: formatHours(request.totalHours) },
    { label: 'Hours by rate', value: bands.join(' · ') },
    { label: 'Estimated amount', value: request.estimatedAmount ? formatEtb(request.estimatedAmount) : '' },
    { label: 'Designation', value: request.designation },
    { label: 'Department', value: request.departmentName || request.departmentCode },
    { label: 'Cost centre', value: request.costCentre },
    {
      label: 'Project',
      value: request.projectNo ? [request.projectNo, request.projectName].filter(Boolean).join(' · ') : '',
    },
    { label: 'Checks', value: request.warnings },
  ]
  return facts.filter((fact) => fact.value)
}

/** "2026-06-11" or "2026-06-11 – 2026-06-13". */
export function overtimeDateRange(request: OvertimeRequest) {
  const dates = request.lines.map((line) => line.overtimeDate).filter(Boolean).sort()
  if (!dates.length) return request.overtimeDate
  const first = dates[0]!
  const last = dates[dates.length - 1]!
  return first === last ? first : `${first} – ${last}`
}

function bandText(line: OvertimeLine) {
  return [
    line.normalHours ? `${Number(line.normalHours.toFixed(2))} normal day` : '',
    line.nightHours ? `${Number(line.nightHours.toFixed(2))} night` : '',
    line.restDayHours ? `${Number(line.restDayHours.toFixed(2))} rest day` : '',
    line.holidayHours ? `${Number(line.holidayHours.toFixed(2))} public holiday` : '',
  ]
    .filter(Boolean)
    .join(' · ')
}

/** The Approvals document lines: one per overtime date and time. */
export function overtimeDocumentLines(request: OvertimeRequest) {
  return request.lines.map((line) => ({
    lineNo: line.lineNo,
    date: line.overtimeDate,
    startTime: line.startTime,
    endTime: line.endTime,
    overtimeHours: Number(line.totalHours.toFixed(2)),
    category: line.dayTypeLabel,
    hoursByRate: bandText(line),
    estimatedAmount: line.estimatedAmount ? formatEtb(line.estimatedAmount) : '',
    reason: line.reason,
  }))
}

function queueStatus(status: OvertimeRequestStatus) {
  if (status === 'Approved') return 'Approved'
  if (status === 'Rejected') return 'Rejected'
  return 'Pending Approval'
}

export function overtimeApprovalQueueItem(request: OvertimeRequest) {
  const pendingStep = request.steps.find((step) => step.status === 'Pending')
  return {
    id: `${OVERTIME_MODULE}-${request.requestNo}`,
    requestNo: request.requestNo,
    module: OVERTIME_MODULE,
    title:
      request.lines.length > 1
        ? `Overtime ${overtimeDateRange(request)} (${formatHours(request.totalHours)}, ${request.lines.length} lines)`
        : `Overtime ${request.overtimeDate} (${formatHours(request.totalHours)})`,
    makerEmployeeNo: request.employeeNo,
    makerName: request.employeeName,
    amount: request.estimatedAmount,
    status: queueStatus(request.status),
    submittedAt: request.submittedAt || request.createdAt,
    approverEmployeeNo: pendingStep?.approverUserId ?? '',
    sourceDocumentNo: request.requestNo,
  }
}

type PortalStepStatus = 'Submitted' | 'Waiting' | 'Pending Approval' | 'Approved' | 'Rejected' | 'Cancelled'

function portalStepStatus(status: OvertimeStepStatus): PortalStepStatus {
  if (status === 'Pending') return 'Pending Approval'
  if (status === 'Approved' || status === 'Rejected' || status === 'Cancelled') return status
  return 'Waiting'
}

function stepRole(stage: number) {
  return stage === 2 ? ('HR' as const) : stage === 4 ? ('Finance' as const) : ('Checker' as const)
}

/** Approvals detail: the request, its five steps and the payroll step, as a PortalRequest. */
export function overtimeToPortalRequest(request: OvertimeRequest, actingUserId = '') {
  const queue = overtimeApprovalQueueItem(request)
  const pendingStep = request.steps.find((step) => step.status === 'Pending')
  const steps = [
    {
      id: 'maker',
      actorEmployeeNo: request.employeeNo,
      actorName: request.employeeName,
      role: 'Maker' as const,
      status: 'Submitted' as const,
      timestamp: request.submittedAt || request.createdAt,
      note: 'Overtime request submitted from the self-service portal',
      sequenceNo: 0,
    },
    ...request.steps.map((step) => ({
      id: `stage-${step.stage}`,
      actorEmployeeNo: step.approverUserId,
      actorName: `${step.label}: ${step.approverName || step.approverUserId || 'not set'}`,
      role: stepRole(step.stage),
      status: portalStepStatus(step.status),
      timestamp: step.decidedAt || '',
      note: step.status === 'Skipped' ? step.skipReason : step.comment,
      sequenceNo: step.stage,
    })),
  ]
  return {
    id: queue.id,
    requestNo: request.requestNo,
    requestType: OVERTIME_MODULE,
    title: queue.title,
    status: queue.status,
    makerEmployeeNo: request.employeeNo,
    makerName: request.employeeName,
    departmentCode: request.departmentCode,
    departmentName: request.departmentName,
    responsibleCenter: '',
    amount: request.estimatedAmount,
    sourceDocument: { documentNo: request.requestNo, erpEntity: 'Overtime Request' },
    createdAt: request.createdAt || request.submittedAt,
    submittedAt: request.submittedAt || request.createdAt,
    approverEmployeeNo: actingUserId || pendingStep?.approverUserId || '',
    approverName: pendingStep?.approverName || actingUserId,
    auditTrail: [],
    approvalSteps: steps,
    attachments: [],
    payload: {
      sourceDocumentAvailable: true,
      // One date shows in the facts; several show as the document lines.
      hideDocumentLines: request.lines.length <= 1,
      commentRequiredOnReject: true,
      pendingStage: pendingStep?.stage ?? request.stage,
      pendingStageLabel: pendingStep?.label ?? request.stageLabel,
      bcStatus: request.status,
      reason: request.reason,
      totalHours: request.totalHours,
      detailFacts: overtimeDetailFacts(request),
      overtime: request,
      lines: request.lines.length > 1 ? overtimeDocumentLines(request) : [],
    },
  }
}
