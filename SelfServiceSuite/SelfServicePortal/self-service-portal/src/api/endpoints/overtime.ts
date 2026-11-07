import { authDelete, authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

/** Staff Overtime Request (BC 1.0.3.606; BC workflow 1.0.3.622/623): Line Manager, FD, HR, Finance, then payroll. */
/** Normal day (6 AM - 10 PM), night (10 PM - 6 AM), rest day, public holiday: the four overtime sheet bands. */
export type OvertimeDayType = 'working' | 'night' | 'restDay' | 'holiday'

export type OvertimeStepStatus =
  | 'Not started'
  | 'Waiting'
  | 'Pending'
  | 'Approved'
  | 'Rejected'
  | 'Cancelled'
  | 'Skipped'

export interface OvertimeStep {
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

export interface OvertimeLogEntry {
  at: string
  stage: number
  stageLabel: string
  action: string
  userId: string
  userName: string
  comment: string
}

export type OvertimeRequestStatus = 'Draft' | 'Pending Approval' | 'Approved' | 'Rejected'

/** One overtime date and time of a request (BC 1.0.3.612). */
export interface OvertimeLine {
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

export interface OvertimeRequest {
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
  linesFromBc: boolean
}

export interface OvertimeContext {
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
  /** BC 1.0.3.622: the approvers come from the Business Central workflow (like Leave) when it is sent. */
  usesWorkflow?: boolean
  /** The enabled BC approval workflow ('' when none is enabled). */
  approvalWorkflow?: string
  /** BC 1.0.3.612: several dates and times in one request. */
  supportsLines: boolean
  maxLines: number
}

export interface OvertimeLineInput {
  overtimeDate: string
  startTime: string
  endTime: string
  dayType: OvertimeDayType
  reason: string
}

export interface OvertimeDetails extends OvertimeLineInput {
  projectNo: string
  lines: OvertimeLineInput[]
}

export async function fetchOvertimeContext() {
  requireAuthApiUrl()
  return authGet<OvertimeContext>('/api/hr/overtime/context')
}

export async function fetchOvertimeRequests() {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: OvertimeRequest[] }>('/api/hr/overtime')
  return rows
}

/** Save a draft, or with `submit` send it to the Line Manager. */
export async function saveOvertimeRequest(input: { requestNo?: string; details: OvertimeDetails; submit: boolean }) {
  requireAuthApiUrl()
  return authPost<OvertimeRequest>('/api/hr/overtime', input)
}

export async function withdrawOvertimeRequest(requestNo: string) {
  requireAuthApiUrl()
  return authPost<OvertimeRequest>(`/api/hr/overtime/${encodeURIComponent(requestNo)}/withdraw`, {})
}

export async function deleteOvertimeRequest(requestNo: string) {
  requireAuthApiUrl()
  return authDelete<{ ok: boolean; id: string }>(`/api/hr/overtime/${encodeURIComponent(requestNo)}`)
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

/** The same split as Business Central (end before start = next morning; night is 10 PM - 6 AM). */
export function splitOvertimeHours(startTime: string, endTime: string, dayType: OvertimeDayType) {
  const start = minutesOf(startTime)
  let end = minutesOf(endTime)
  const empty = { totalHours: 0, normalHours: 0, nightHours: 0, restDayHours: 0, holidayHours: 0 }
  if (start === null || end === null || start === end) return empty
  if (end < start) end += 1440
  const round = (minutes: number) => Math.round((minutes / 60) * 100) / 100
  const totalHours = round(end - start)
  if (dayType === 'night') return { ...empty, totalHours, nightHours: totalHours }
  if (dayType === 'restDay') return { ...empty, totalHours, restDayHours: totalHours }
  if (dayType === 'holiday') return { ...empty, totalHours, holidayHours: totalHours }
  const normalHours = round(overlap(start, end, 360, 1320) + overlap(start, end, 1800, 2760))
  return { ...empty, totalHours, normalHours, nightHours: Math.round((totalHours - normalHours) * 100) / 100 }
}

/** The estimated pay as BC works it out: hourly rate x rate x hours, per band, rounded per band. */
export function estimateOvertimeAmount(
  hours: ReturnType<typeof splitOvertimeHours>,
  hourlyRate: number,
  rates: OvertimeContext['rates'],
) {
  const round = (value: number) => Math.round(value * 100) / 100
  return (
    round(hourlyRate * rates.normal * hours.normalHours) +
    round(hourlyRate * rates.night * hours.nightHours) +
    round(hourlyRate * rates.restDay * hours.restDayHours) +
    round(hourlyRate * rates.holiday * hours.holidayHours)
  )
}
