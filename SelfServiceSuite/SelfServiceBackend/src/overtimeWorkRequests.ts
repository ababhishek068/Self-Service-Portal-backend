import { createHash, randomUUID } from 'node:crypto'
import { mkdir, readFile, writeFile } from 'node:fs/promises'
import path from 'node:path'
import type { OvertimeRequest, OvertimeStep } from './overtimeRequests.js'

/**
 * Overtime Work Request (permission to work OT + the hours).
 * Same line shape as Overtime Payment, plus overall justification fields.
 * Payment requests select an approved work request and reuse these lines (no Add Line).
 */
export const OVERTIME_WORK_MODULE = 'overtimeWork' as const

export type OvertimeWorkStatus = 'Draft' | 'Pending Approval' | 'Approved' | 'Rejected' | 'Cancelled'

/** Same bands as overtime payment / the OT sheet. */
export type OvertimeWorkDayType = 'working' | 'night' | 'restDay' | 'holiday'
export type OvertimeWorkLocation = 'office' | 'field' | 'projectSite'

/** @deprecated Kept for older stored rows; new forms use dayType on each line. */
export type OvertimeWorkType = 'weekday' | 'weekend' | 'publicHoliday'

export type OvertimeWorkStepStatus = 'Waiting' | 'Pending' | 'Approved' | 'Rejected' | 'Skipped'

export type OvertimeWorkStep = {
  stage: number
  label: string
  approverUserId: string
  approverName: string
  status: OvertimeWorkStepStatus
  decidedAt: string
  comment: string
}

export type OvertimeWorkLine = {
  overtimeDate: string
  startTime: string
  endTime: string
  dayType: OvertimeWorkDayType
  workLocation: OvertimeWorkLocation
  reason: string
  totalHours: number
}

export type OvertimeWorkRequest = {
  id: string
  requestNo: string
  status: OvertimeWorkStatus
  employeeNo: string
  employeeName: string
  designation: string
  departmentCode: string
  departmentName: string
  /** Derived from the first line (list / payment preview). */
  overtimeDate: string
  normalHoursFrom: string
  normalHoursTo: string
  overtimeFrom: string
  overtimeTo: string
  totalHours: number
  /** @deprecated Prefer lines[].dayType */
  overtimeType: OvertimeWorkType
  workLocation: OvertimeWorkLocation
  /** Overall justification (below the lines). */
  reason: string
  expectedDeliverables: string
  lines: OvertimeWorkLine[]
  requesterUserId: string
  createdAt: string
  submittedAt: string
  approvedAt: string
  decisionRemarks: string
  steps: OvertimeWorkStep[]
  /**
   * Once linked to an Overtime Payment Request, this work document is marked used
   * and must not appear again in the payment picker for any other claim.
   */
  linkedPaymentRequestNo: string
  linkedAt: string
  /**
   * BC 1.0.3.636: this row mirrors BC Stage 1 Overtime Request `requestNo` (PortalOvertime*).
   * BC owns its status, Superior → FAD steps and Stage 2 link; the portal keeps only the extras
   * BC has no field for (expected deliverables, work location).
   */
  bcStage1?: boolean
  /** From BC on read: show "Request overtime payment" (Stage 1 approved, no Stage 2 yet). */
  canRequestPayment?: boolean
  paymentApproved?: boolean
  addedToSheet?: boolean
}

/** The BC Stage 1 state the local row mirrors after PortalOvertimeSave / Withdraw. */
export type BcStage1Snapshot = {
  requestNo: string
  status: OvertimeWorkStatus
  steps: OvertimeWorkStep[]
  approvedAt: string
  submittedAt: string
}

function bcStepStatus(status: OvertimeStep['status']): OvertimeWorkStepStatus {
  if (status === 'Pending' || status === 'Approved' || status === 'Rejected' || status === 'Skipped') return status
  return 'Waiting'
}

/** BC Stage 1 steps (Superior → FAD) in the work-request step shape. */
export function bcStage1Steps(steps: OvertimeStep[]): OvertimeWorkStep[] {
  return steps.map((step, index) => ({
    stage: step.stage || index + 1,
    label: step.label,
    approverUserId: step.approverUserId,
    approverName: step.approverName,
    status: bcStepStatus(step.status),
    decidedAt: step.decidedAt,
    comment: step.status === 'Skipped' ? step.skipReason : step.comment,
  }))
}

export function bcStage1Snapshot(request: OvertimeRequest): BcStage1Snapshot {
  return {
    requestNo: request.requestNo,
    status: request.status,
    steps: bcStage1Steps(request.steps),
    approvedAt: request.approvedAt,
    submittedAt: request.submittedAt,
  }
}

/**
 * Overlay the live BC Stage 1 request on its local row. Rows not backed by BC (portal-only
 * drafts, pre-636 work requests) can never start Stage 2: BC only pays its own Stage 1 numbers.
 */
export function applyBcStage1(row: OvertimeWorkRequest, bc: OvertimeRequest | null | undefined): OvertimeWorkRequest {
  if (!row.bcStage1 || !bc) {
    return { ...row, canRequestPayment: false, paymentApproved: false, addedToSheet: false }
  }
  return {
    ...row,
    status: bc.status,
    steps: bc.steps.length ? bcStage1Steps(bc.steps) : row.steps,
    submittedAt: bc.submittedAt || row.submittedAt,
    approvedAt: bc.approvedAt,
    decisionRemarks: bc.decisionRemarks,
    linkedPaymentRequestNo: bc.paymentRequestNo,
    canRequestPayment: bc.canRequestPayment,
    paymentApproved: bc.paymentApproved,
    addedToSheet: bc.addedToSheet,
  }
}

export type OvertimeWorkDetails = {
  /** No longer collected on the form; kept empty for older stored rows. */
  normalHoursFrom?: string
  normalHoursTo?: string
  /** Derived from the first line when omitted; each line has its own workLocation. */
  workLocation?: OvertimeWorkLocation
  reason: string
  expectedDeliverables: string
  lines: Array<{
    overtimeDate: string
    startTime: string
    endTime: string
    dayType: OvertimeWorkDayType
    workLocation: OvertimeWorkLocation
    reason: string
  }>
  employeeName?: string
  designation?: string
  departmentCode?: string
  departmentName?: string
  lineManagerUserId?: string
  lineManagerName?: string
  hrUserId?: string
  hrName?: string
  managerUserId?: string
  managerName?: string
}

type StoreFile = { sequence: number; rows: OvertimeWorkRequest[] }

const DAY_TYPES: OvertimeWorkDayType[] = ['working', 'night', 'restDay', 'holiday']
const LOCATIONS: OvertimeWorkLocation[] = ['office', 'field', 'projectSite']
/** Same as BC Stage 1 (ABH Overtime Request Mgt MaxLines): a full month of daily lines from a Start → End Date period. */
const OVERTIME_WORK_MAX_LINES = 31

function storePath() {
  return path.resolve(process.cwd(), 'data', 'overtime-work-requests.json')
}

function str(value: unknown) {
  return value === undefined || value === null ? '' : String(value).trim()
}

function minutesOf(value: string) {
  const match = /^(\d{1,2}):(\d{2})$/.exec(value.trim())
  if (!match) return null
  const hours = Number(match[1])
  const minutes = Number(match[2])
  if (!Number.isFinite(hours) || !Number.isFinite(minutes) || hours > 23 || minutes > 59) return null
  return hours * 60 + minutes
}

function hoursBetween(from: string, to: string) {
  const start = minutesOf(from)
  let end = minutesOf(to)
  if (start === null || end === null) return 0
  if (end <= start) end += 1440
  return Number(((end - start) / 60).toFixed(2))
}

function invalid(message: string) {
  return Object.assign(new Error(message), { status: 400 })
}

function sameId(left: string, right: string) {
  return left.trim().toLowerCase() === right.trim().toLowerCase()
}

function legacyTypeToDayType(value: string): OvertimeWorkDayType {
  const raw = value.trim().toLowerCase()
  if (raw === 'weekend' || raw === 'restday') return 'restDay'
  if (raw === 'publicholiday' || raw === 'holiday') return 'holiday'
  if (raw === 'night') return 'night'
  return 'working'
}

function dayTypeToLegacy(dayType: OvertimeWorkDayType): OvertimeWorkType {
  if (dayType === 'restDay') return 'weekend'
  if (dayType === 'holiday') return 'publicHoliday'
  return 'weekday'
}

function dayTypeLabel(dayType: OvertimeWorkDayType) {
  if (dayType === 'night') return 'Night hours (10 PM – 6 AM)'
  if (dayType === 'restDay') return 'Weekly rest day hours'
  if (dayType === 'holiday') return 'Public holiday hours'
  return 'Normal day hours (6 AM – 10 PM)'
}

function locationLabel(location: OvertimeWorkLocation) {
  if (location === 'field') return 'Field'
  if (location === 'projectSite') return 'Project Site'
  return 'Office'
}

function formatHours(value: number) {
  return `${Number(value.toFixed(2))} hrs`
}

function workDateRange(lines: OvertimeWorkLine[], fallback: string) {
  const dates = lines.map((line) => line.overtimeDate).filter(Boolean).sort()
  if (!dates.length) return fallback
  const first = dates[0]!
  const last = dates[dates.length - 1]!
  return first === last ? first : `${first} – ${last}`
}

/** Normalize stored / API rows so callers always see `lines`. */
export function normalizeOvertimeWorkRequest(row: OvertimeWorkRequest): OvertimeWorkRequest {
  const linkedPaymentRequestNo = str(
    (row as OvertimeWorkRequest & { linkedPaymentRequestNo?: string }).linkedPaymentRequestNo,
  ).toUpperCase()
  const linkedAt = str((row as OvertimeWorkRequest & { linkedAt?: string }).linkedAt)
  const headerLocation = LOCATIONS.includes(row.workLocation) ? row.workLocation : 'office'
  if (Array.isArray(row.lines) && row.lines.length > 0) {
    const lines = row.lines.map((line) => {
      const rawLocation = str((line as OvertimeWorkLine).workLocation)
      const workLocation = (LOCATIONS.includes(rawLocation as OvertimeWorkLocation)
        ? rawLocation
        : headerLocation) as OvertimeWorkLocation
      return {
        overtimeDate: str(line.overtimeDate),
        startTime: str(line.startTime).slice(0, 5),
        endTime: str(line.endTime).slice(0, 5),
        dayType: DAY_TYPES.includes(line.dayType) ? line.dayType : legacyTypeToDayType(String(line.dayType ?? '')),
        workLocation,
        reason: str(line.reason),
        totalHours:
          Number(line.totalHours) > 0
            ? Number(line.totalHours)
            : hoursBetween(str(line.startTime), str(line.endTime)),
      }
    })
    const first = lines[0]!
    const totalHours = Number(lines.reduce((sum, line) => sum + line.totalHours, 0).toFixed(2))
    return {
      ...row,
      lines,
      overtimeDate: first.overtimeDate || row.overtimeDate,
      overtimeFrom: first.startTime || row.overtimeFrom,
      overtimeTo: lines[lines.length - 1]?.endTime || row.overtimeTo,
      totalHours,
      overtimeType: dayTypeToLegacy(first.dayType),
      workLocation: first.workLocation || headerLocation,
      linkedPaymentRequestNo,
      linkedAt,
    }
  }
  const synthetic: OvertimeWorkLine = {
    overtimeDate: row.overtimeDate,
    startTime: row.overtimeFrom || '17:00',
    endTime: row.overtimeTo || '20:00',
    dayType: legacyTypeToDayType(row.overtimeType || 'weekday'),
    workLocation: headerLocation,
    reason: row.reason,
    totalHours: row.totalHours || hoursBetween(row.overtimeFrom, row.overtimeTo),
  }
  return { ...row, lines: [synthetic], linkedPaymentRequestNo, linkedAt }
}

/** Payment form lines copied from an approved work request. */
export function overtimeWorkLinesForPayment(row: OvertimeWorkRequest) {
  return normalizeOvertimeWorkRequest(row).lines.map((line) => ({
    overtimeDate: line.overtimeDate,
    startTime: line.startTime,
    endTime: line.endTime,
    dayType: line.dayType,
    reason: line.reason || row.reason,
  }))
}

async function readStore(): Promise<StoreFile> {
  try {
    const raw = await readFile(storePath(), 'utf8')
    const parsed = JSON.parse(raw) as StoreFile
    return {
      sequence: Number(parsed.sequence) || 0,
      rows: Array.isArray(parsed.rows) ? parsed.rows.map((row) => normalizeOvertimeWorkRequest(row)) : [],
    }
  } catch (error) {
    if ((error as NodeJS.ErrnoException)?.code === 'ENOENT') return { sequence: 0, rows: [] }
    throw error
  }
}

async function writeStore(store: StoreFile) {
  await mkdir(path.dirname(storePath()), { recursive: true })
  await writeFile(storePath(), `${JSON.stringify(store, null, 2)}\n`, 'utf8')
}

export function validateOvertimeWorkDetails(input: unknown, submit: boolean): OvertimeWorkDetails {
  const body = (input && typeof input === 'object' ? input : {}) as Record<string, unknown>
  const rawLines = Array.isArray(body.lines) ? body.lines : []
  // Older single-slot payloads (no lines array): treat the header times as one line.
  const legacyLine =
    rawLines.length === 0 && str(body.overtimeDate)
      ? [
          {
            overtimeDate: str(body.overtimeDate),
            startTime: str(body.overtimeFrom || body.startTime).slice(0, 5),
            endTime: str(body.overtimeTo || body.endTime).slice(0, 5),
            dayType: str(body.dayType) || str(body.overtimeType),
            reason: str(body.reason),
          },
        ]
      : rawLines

  if (!legacyLine.length) throw invalid('Add at least one overtime line (date, times, category and work location).')
  if (legacyLine.length > OVERTIME_WORK_MAX_LINES) {
    throw invalid(
      `One overtime request can have at most ${OVERTIME_WORK_MAX_LINES} daily lines. Make a second request for the other days.`,
    )
  }

  const overallReason = str(body.reason).slice(0, 1000)
  const headerLocation = (LOCATIONS.includes(str(body.workLocation) as OvertimeWorkLocation)
    ? str(body.workLocation)
    : 'office') as OvertimeWorkLocation
  const lines = legacyLine.map((raw, index) => {
    const line = (raw && typeof raw === 'object' ? raw : {}) as Record<string, unknown>
    const prefix = legacyLine.length > 1 ? `Line ${index + 1}: ` : ''
    const overtimeDate = str(line.overtimeDate)
    const startTime = str(line.startTime).slice(0, 5)
    const endTime = str(line.endTime).slice(0, 5)
    const dayTypeRaw = str(line.dayType)
    const dayType = (DAY_TYPES.includes(dayTypeRaw as OvertimeWorkDayType)
      ? dayTypeRaw
      : legacyTypeToDayType(dayTypeRaw)) as OvertimeWorkDayType
    const locationRaw = str(line.workLocation) || headerLocation
    const workLocation = (LOCATIONS.includes(locationRaw as OvertimeWorkLocation)
      ? locationRaw
      : '') as OvertimeWorkLocation | ''
    // One justification on the form: use overall reason when the line has none.
    const reason = (str(line.reason) || overallReason).slice(0, 500)
    if (!/^\d{4}-\d{2}-\d{2}$/.test(overtimeDate)) throw invalid(`${prefix}Enter the overtime date.`)
    if (minutesOf(startTime) === null) throw invalid(`${prefix}Enter the start time.`)
    if (minutesOf(endTime) === null) throw invalid(`${prefix}Enter the end time.`)
    if (hoursBetween(startTime, endTime) <= 0) {
      throw invalid(`${prefix}The end time must be different from the start time.`)
    }
    if (!DAY_TYPES.includes(dayType)) throw invalid(`${prefix}Choose the overtime category.`)
    if (!workLocation) throw invalid(`${prefix}Choose the work location.`)
    return { overtimeDate, startTime, endTime, dayType, workLocation, reason }
  })

  const details: OvertimeWorkDetails = {
    // Normal hours are no longer collected on the form.
    normalHoursFrom: '',
    normalHoursTo: '',
    workLocation: lines[0]?.workLocation || headerLocation,
    reason: overallReason,
    expectedDeliverables: str(body.expectedDeliverables).slice(0, 1000),
    lines,
    employeeName: str(body.employeeName),
    designation: str(body.designation),
    departmentCode: str(body.departmentCode),
    departmentName: str(body.departmentName),
    lineManagerUserId: str(body.lineManagerUserId),
    lineManagerName: str(body.lineManagerName),
    hrUserId: str(body.hrUserId),
    hrName: str(body.hrName),
    managerUserId: str(body.managerUserId),
    managerName: str(body.managerName),
  }

  if (submit && details.reason.length < 5) throw invalid('Enter the reason / justification for overtime.')
  if (submit && details.expectedDeliverables.length < 3) {
    throw invalid('Enter the expected deliverables / outputs.')
  }
  return details
}

function nextNo(sequence: number) {
  return `OTW-${String(sequence).padStart(5, '0')}`
}

/** Local draft preview only — BC Stage 1 is Superior → FAD (Portal-Handoff-1.0.3.636). */
function buildSteps(details: OvertimeWorkDetails, submit: boolean): OvertimeWorkStep[] {
  const chain = [
    {
      stage: 1,
      label: 'Superior',
      approverUserId: details.lineManagerUserId || '',
      approverName: details.lineManagerName || details.lineManagerUserId || 'Superior',
    },
    {
      stage: 2,
      label: 'FAD',
      approverUserId: details.managerUserId || details.hrUserId || '',
      approverName:
        details.managerName ||
        details.managerUserId ||
        details.hrName ||
        details.hrUserId ||
        'FAD',
    },
  ]
  return chain.map((step, index) => ({
    ...step,
    status: !submit ? 'Waiting' : index === 0 ? 'Pending' : 'Waiting',
    decidedAt: '',
    comment: '',
  })) as OvertimeWorkStep[]
}

export async function listOvertimeWorkRequests(employeeNo: string) {
  const store = await readStore()
  return store.rows
    .filter((row) => sameId(row.employeeNo, employeeNo))
    .toSorted((a, b) => String(b.createdAt).localeCompare(String(a.createdAt)))
}

/**
 * Approved work requests for the payment picker.
 * Used documents (already linked to a payment) are omitted unless `keepRequestNo` matches
 * so an in-progress payment can still show its own linked work request.
 */
export async function listApprovedOvertimeWorkRequests(
  employeeNo: string,
  options: { keepRequestNo?: string; includeUsed?: boolean } = {},
) {
  const keep = str(options.keepRequestNo).toUpperCase()
  return (await listOvertimeWorkRequests(employeeNo)).filter((row) => {
    if (row.status !== 'Approved') return false
    if (options.includeUsed) return true
    if (!row.linkedPaymentRequestNo) return true
    return keep && sameId(row.requestNo, keep)
  })
}

/** Mark an approved work request as used by a payment claim (one-to-one). */
export async function linkOvertimeWorkToPayment(input: {
  workRequestNo: string
  paymentRequestNo: string
  employeeNo: string
}) {
  const store = await readStore()
  const row = store.rows.find(
    (item) => sameId(item.requestNo, input.workRequestNo) && sameId(item.employeeNo, input.employeeNo),
  )
  if (!row) {
    throw Object.assign(new Error(`Overtime work request ${input.workRequestNo} was not found.`), {
      status: 404,
    })
  }
  if (row.status !== 'Approved') {
    throw Object.assign(
      new Error(`Only an approved overtime work request can be linked to a payment claim.`),
      { status: 409 },
    )
  }
  const paymentNo = str(input.paymentRequestNo).toUpperCase()
  if (row.linkedPaymentRequestNo && !sameId(row.linkedPaymentRequestNo, paymentNo)) {
    throw Object.assign(
      new Error(
        `Overtime work request ${row.requestNo} is already linked to payment ${row.linkedPaymentRequestNo} and cannot be reused.`,
      ),
      { status: 409 },
    )
  }
  // Clear any previous link from this payment onto a different work request.
  for (const other of store.rows) {
    if (
      sameId(other.employeeNo, input.employeeNo) &&
      sameId(other.linkedPaymentRequestNo, paymentNo) &&
      !sameId(other.requestNo, row.requestNo)
    ) {
      other.linkedPaymentRequestNo = ''
      other.linkedAt = ''
    }
  }
  row.linkedPaymentRequestNo = paymentNo
  row.linkedAt = new Date().toISOString()
  await writeStore(store)
  return normalizeOvertimeWorkRequest(row)
}

/** Find the work request already linked to a payment claim (for View / Print). */
export async function getOvertimeWorkByPayment(paymentRequestNo: string, employeeNo = '') {
  const paymentNo = str(paymentRequestNo).toUpperCase()
  if (!paymentNo) return null
  const store = await readStore()
  const row = store.rows.find((item) => {
    if (!sameId(item.linkedPaymentRequestNo, paymentNo)) return false
    if (employeeNo && !sameId(item.employeeNo, employeeNo)) return false
    return true
  })
  return row ? normalizeOvertimeWorkRequest(row) : null
}

/** Free a work request when its payment draft is deleted or the link is cleared. */
export async function unlinkOvertimeWorkFromPayment(paymentRequestNo: string, employeeNo = '') {
  const store = await readStore()
  const paymentNo = str(paymentRequestNo).toUpperCase()
  if (!paymentNo) return { ok: true, cleared: 0 }
  let cleared = 0
  for (const row of store.rows) {
    if (!sameId(row.linkedPaymentRequestNo, paymentNo)) continue
    if (employeeNo && !sameId(row.employeeNo, employeeNo)) continue
    row.linkedPaymentRequestNo = ''
    row.linkedAt = ''
    cleared += 1
  }
  if (cleared) await writeStore(store)
  return { ok: true, cleared }
}

export async function getOvertimeWorkRequest(requestNo: string, employeeNo = '') {
  const store = await readStore()
  const row = store.rows.find((item) => sameId(item.requestNo, requestNo))
  if (!row) return null
  if (employeeNo && !sameId(row.employeeNo, employeeNo)) return null
  return normalizeOvertimeWorkRequest(row)
}

export async function saveOvertimeWorkRequest(input: {
  employeeNo: string
  requesterUserId: string
  requestNo?: string
  details: OvertimeWorkDetails
  submit: boolean
  /** BC Stage 1 state after PortalOvertimeSave: the local row takes BC's number, status and steps. */
  bc?: BcStage1Snapshot
}) {
  const store = await readStore()
  const existing = input.requestNo
    ? store.rows.find((row) => sameId(row.requestNo, input.requestNo!) && sameId(row.employeeNo, input.employeeNo))
    : undefined
  // BC already enforced its own draft rule when it accepted the save.
  if (!input.bc && existing && existing.status !== 'Draft' && existing.status !== 'Rejected') {
    throw Object.assign(new Error(`Overtime work request ${existing.requestNo} can no longer be changed.`), {
      status: 409,
    })
  }

  const now = new Date().toISOString()
  const bcNo = str(input.bc?.requestNo).toUpperCase()
  const sequence = bcNo
    ? store.sequence
    : existing
      ? Number(existing.requestNo.replace(/\D/g, '')) || store.sequence
      : store.sequence + 1
  // A portal-only draft (OTW-…) becomes the BC Stage 1 number once BC has it.
  const requestNo = bcNo || existing?.requestNo || nextNo(sequence)
  const lines: OvertimeWorkLine[] = input.details.lines.map((line) => ({
    ...line,
    totalHours: hoursBetween(line.startTime, line.endTime),
  }))
  const first = lines[0]!
  const last = lines[lines.length - 1]!
  const totalHours = Number(lines.reduce((sum, line) => sum + line.totalHours, 0).toFixed(2))
  const steps = input.bc ? input.bc.steps : buildSteps(input.details, input.submit)
  const row: OvertimeWorkRequest = {
    id: existing?.id || createHash('sha1').update(`${requestNo}-${randomUUID()}`).digest('hex').slice(0, 16),
    requestNo,
    status: input.bc ? input.bc.status : input.submit ? 'Pending Approval' : 'Draft',
    employeeNo: input.employeeNo,
    employeeName: input.details.employeeName || existing?.employeeName || '',
    designation: input.details.designation || existing?.designation || '',
    departmentCode: input.details.departmentCode || existing?.departmentCode || '',
    departmentName: input.details.departmentName || existing?.departmentName || '',
    overtimeDate: first.overtimeDate,
    normalHoursFrom: '',
    normalHoursTo: '',
    overtimeFrom: first.startTime,
    overtimeTo: last.endTime,
    totalHours,
    overtimeType: dayTypeToLegacy(first.dayType),
    workLocation: first.workLocation || input.details.workLocation || 'office',
    reason: input.details.reason,
    expectedDeliverables: input.details.expectedDeliverables,
    lines,
    requesterUserId: input.requesterUserId,
    createdAt: existing?.createdAt || now,
    submittedAt: input.bc?.submittedAt || (input.submit ? now : existing?.submittedAt || ''),
    approvedAt: input.bc?.approvedAt || '',
    decisionRemarks: '',
    steps,
    linkedPaymentRequestNo: existing?.linkedPaymentRequestNo || '',
    linkedAt: existing?.linkedAt || '',
    ...(input.bc ? { bcStage1: true } : {}),
  }

  store.sequence = Math.max(store.sequence, sequence)
  const replaced = existing?.requestNo ?? ''
  store.rows = [
    row,
    ...store.rows.filter((item) => item.requestNo !== requestNo && (!replaced || item.requestNo !== replaced)),
  ]
  await writeStore(store)
  return row
}

export async function withdrawOvertimeWorkRequest(
  employeeNo: string,
  requestNo: string,
  bc?: BcStage1Snapshot,
) {
  const store = await readStore()
  const row = store.rows.find((item) => sameId(item.requestNo, requestNo) && sameId(item.employeeNo, employeeNo))
  if (!row) throw Object.assign(new Error(`Overtime work request ${requestNo} was not found.`), { status: 404 })
  // A BC Stage 1 row was already withdrawn in BC (PortalOvertimeWithdraw); mirror it.
  if (!bc && row.status !== 'Pending Approval') {
    throw Object.assign(new Error(`Only a pending overtime work request can be withdrawn.`), { status: 409 })
  }
  row.status = bc ? bc.status : 'Draft'
  row.submittedAt = ''
  row.steps = bc
    ? bc.steps
    : row.steps.map((step) => ({ ...step, status: 'Waiting', decidedAt: '', comment: '' }))
  await writeStore(store)
  return normalizeOvertimeWorkRequest(row)
}

export async function deleteOvertimeWorkRequest(employeeNo: string, requestNo: string, deletedInBc = false) {
  const store = await readStore()
  const row = store.rows.find((item) => sameId(item.requestNo, requestNo) && sameId(item.employeeNo, employeeNo))
  if (!row) throw Object.assign(new Error(`Overtime work request ${requestNo} was not found.`), { status: 404 })
  if (!deletedInBc && row.status !== 'Draft' && row.status !== 'Rejected') {
    throw Object.assign(new Error(`Only a draft overtime work request can be deleted.`), { status: 409 })
  }
  store.rows = store.rows.filter((item) => item.requestNo !== row.requestNo)
  await writeStore(store)
  return { ok: true, requestNo: row.requestNo }
}

export async function listOvertimeWorkApprovals(actingUserIds: string[], scope: 'pending' | 'decided' = 'pending') {
  const store = await readStore()
  const ids = actingUserIds.map((id) => id.trim()).filter(Boolean)
  return store.rows.filter((row) => {
    // BC Stage 1 (Superior → FAD) is listed and decided through PortalOvertimeApprovals / Decide.
    if (row.bcStage1) return false
    if (scope === 'pending') {
      return row.steps.some(
        (step) => step.status === 'Pending' && ids.some((id) => sameId(id, step.approverUserId)),
      )
    }
    return row.steps.some(
      (step) =>
        (step.status === 'Approved' || step.status === 'Rejected') &&
        ids.some((id) => sameId(id, step.approverUserId)),
    )
  })
}

function portalStepStatus(
  status: OvertimeWorkStepStatus,
): 'Submitted' | 'Waiting' | 'Pending Approval' | 'Approved' | 'Rejected' | 'Cancelled' {
  if (status === 'Pending') return 'Pending Approval'
  if (status === 'Approved' || status === 'Rejected') return status
  return 'Waiting'
}

/** Approvals detail: dates, times, category, justification and line items. */
export function overtimeWorkDetailFacts(request: OvertimeWorkRequest) {
  const normalized = normalizeOvertimeWorkRequest(request)
  const several = normalized.lines.length > 1
  const categories = [
    ...new Set(normalized.lines.map((line) => dayTypeLabel(line.dayType)).filter(Boolean)),
  ]
  const facts: Array<{ label: string; value: string }> = [
    several
      ? {
          label: 'Overtime dates',
          value: `${workDateRange(normalized.lines, normalized.overtimeDate)} (${normalized.lines.length} lines, below)`,
        }
      : { label: 'Overtime date', value: normalized.overtimeDate },
    {
      label: 'Time',
      value:
        !several && normalized.overtimeFrom && normalized.overtimeTo
          ? `${normalized.overtimeFrom} – ${normalized.overtimeTo}`
          : '',
    },
    {
      label: 'Overtime category',
      value: several ? categories.join(' · ') : dayTypeLabel(normalized.lines[0]?.dayType ?? 'working'),
    },
    { label: 'Overtime hours', value: formatHours(normalized.totalHours) },
    {
      label: 'Work location',
      value: several
        ? [
            ...new Set(normalized.lines.map((line) => locationLabel(line.workLocation)).filter(Boolean)),
          ].join(' · ')
        : locationLabel(normalized.lines[0]?.workLocation || normalized.workLocation),
    },
    { label: 'Designation', value: normalized.designation },
    {
      label: 'Department',
      value: normalized.departmentName || normalized.departmentCode,
    },
    { label: 'Justification', value: normalized.reason },
    { label: 'Expected deliverables', value: normalized.expectedDeliverables },
    {
      label: 'Payment link',
      value: normalized.linkedPaymentRequestNo
        ? `Linked to ${normalized.linkedPaymentRequestNo}`
        : '',
    },
  ]
  return facts.filter((fact) => fact.value)
}

export function overtimeWorkDocumentLines(request: OvertimeWorkRequest) {
  return normalizeOvertimeWorkRequest(request).lines.map((line, index) => ({
    lineNo: (index + 1) * 10000,
    date: line.overtimeDate,
    startTime: line.startTime,
    endTime: line.endTime,
    overtimeHours: Number(line.totalHours.toFixed(2)),
    category: dayTypeLabel(line.dayType),
    workLocation: locationLabel(line.workLocation),
    reason: line.reason,
  }))
}

export function overtimeWorkToPortalRequest(request: OvertimeWorkRequest, actingUserId = '') {
  const normalized = normalizeOvertimeWorkRequest(request)
  const pending = normalized.steps.find((step) => step.status === 'Pending')
  const title =
    normalized.lines.length > 1
      ? `Overtime work ${workDateRange(normalized.lines, normalized.overtimeDate)} (${formatHours(normalized.totalHours)}, ${normalized.lines.length} lines)`
      : `Overtime work ${normalized.overtimeDate} (${formatHours(normalized.totalHours)})`
  const steps = [
    {
      id: 'maker',
      actorEmployeeNo: normalized.employeeNo,
      actorName: normalized.employeeName,
      role: 'Maker' as const,
      status: 'Submitted' as const,
      timestamp: normalized.submittedAt || normalized.createdAt,
      note: 'Overtime work request submitted from the self-service portal',
      sequenceNo: 0,
    },
    ...normalized.steps.map((step) => ({
      id: `stage-${step.stage}`,
      actorEmployeeNo: step.approverUserId,
      actorName: `${step.label}: ${step.approverName || step.approverUserId || 'not set'}`,
      role: step.label === 'HR' ? ('HR' as const) : ('Checker' as const),
      status: portalStepStatus(step.status),
      timestamp: step.decidedAt || '',
      note: step.comment,
      sequenceNo: step.stage,
    })),
  ]
  return {
    id: `${OVERTIME_WORK_MODULE}-${normalized.requestNo}`,
    requestNo: normalized.requestNo,
    requestType: OVERTIME_WORK_MODULE,
    title,
    status: normalized.status === 'Draft' ? 'Draft' : normalized.status,
    makerEmployeeNo: normalized.employeeNo,
    makerName: normalized.employeeName,
    departmentCode: normalized.departmentCode,
    departmentName: normalized.departmentName,
    responsibleCenter: '',
    amount: 0,
    sourceDocument: { documentNo: normalized.requestNo, erpEntity: 'Overtime Work Request' },
    createdAt: normalized.createdAt || normalized.submittedAt,
    submittedAt: normalized.submittedAt || normalized.createdAt,
    approverEmployeeNo: actingUserId || pending?.approverUserId || '',
    approverName: pending?.approverName || actingUserId,
    auditTrail: [],
    approvalSteps: steps,
    attachments: [],
    payload: {
      sourceDocumentAvailable: true,
      // Always show OT work lines so approvers see date, time, category and line reason.
      hideDocumentLines: false,
      commentRequiredOnReject: true,
      pendingStage: pending?.stage ?? 0,
      pendingStageLabel: pending?.label ?? '',
      reason: normalized.reason,
      expectedDeliverables: normalized.expectedDeliverables,
      totalHours: normalized.totalHours,
      workLocation: normalized.workLocation,
      linkedPaymentRequestNo: normalized.linkedPaymentRequestNo,
      detailFacts: overtimeWorkDetailFacts(normalized),
      overtimeWork: normalized,
      lines: overtimeWorkDocumentLines(normalized),
    },
  }
}

export async function decideOvertimeWorkApproval(input: {
  requestNo: string
  actingUserIds: string[]
  isApprove: boolean
  comments: string
}) {
  const store = await readStore()
  const row = store.rows.find((item) => sameId(item.requestNo, input.requestNo))
  if (!row) throw Object.assign(new Error(`Overtime work request ${input.requestNo} was not found.`), { status: 404 })
  if (row.bcStage1) {
    throw Object.assign(
      new Error(
        `Overtime Request ${row.requestNo} is approved in Business Central (Superior → FAD). Open it from Approvals as Overtime Request (Stage 1).`,
      ),
      { status: 409 },
    )
  }
  if (row.status !== 'Pending Approval') {
    throw Object.assign(new Error(`Overtime work request ${row.requestNo} is not waiting for approval.`), {
      status: 409,
    })
  }
  const ids = input.actingUserIds.map((id) => id.trim()).filter(Boolean)
  const pending = row.steps.find(
    (step) => step.status === 'Pending' && ids.some((id) => sameId(id, step.approverUserId)),
  )
  if (!pending) {
    throw Object.assign(new Error('This overtime work request is not waiting for your approval.'), { status: 403 })
  }
  const now = new Date().toISOString()
  pending.status = input.isApprove ? 'Approved' : 'Rejected'
  pending.decidedAt = now
  pending.comment = str(input.comments).slice(0, 500)
  if (!input.isApprove) {
    row.status = 'Rejected'
    row.decisionRemarks = pending.comment
  } else {
    const next = row.steps.find((step) => step.stage === pending.stage + 1)
    if (next) next.status = 'Pending'
    else {
      row.status = 'Approved'
      row.approvedAt = now
    }
  }
  await writeStore(store)
  return normalizeOvertimeWorkRequest(row)
}
