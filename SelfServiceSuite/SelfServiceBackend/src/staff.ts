
const LEAVE_FAMILY_MEMBER_OPTIONS = [
  'Aunt',
  'Brother',
  'Child',
  'Father',
  'Father-in-law',
  'Grand-Parents',
  'Mother',
  'Mother-in-Law',
  'Sister',
  'Step-Dad',
  'Step-Mom',
  'Inlaw',
  'Uncle',
] as const

function normalizeLeaveFamilyMember(value: unknown): string {
  const trimmed = String(value ?? '').trim()
  return (LEAVE_FAMILY_MEMBER_OPTIONS as readonly string[]).includes(trimmed) ? trimmed : ''
}

import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import { callSoapMethod, fetchOData, fetchODataCount, odataString, type ODataRecord } from './bcClient.js'
import { requireAuth } from './auth.js'
import { sortNewestFirst } from './sortNewestFirst.js'
import { approvalTableFilter, approvalModuleFromEntry, resolveApprovalModuleFromEntry, approvalTableIdsFor, type ApprovalTableKey } from './approvalTableIds.js'
import {
  findFrontendModuleSpec,
  getPortalModuleDocument,
  listPortalModuleLines,
  uploadPortalAttachment,
} from './staffModules.js'
import {
  resolveLeaveStatus,
  statusFromBc,
  documentStatusFromBc,
  leaveIsPendingInBc,
} from './erpMappings.js'
import {
  enrichLeaveApprovalEntries,
  leaveDocumentNoCandidates,
  mapApprovalSteps,
  resolveLeaveApprovalSteps,
  resolveLeaveApprovalStepsAsync,
  resolveLeaveApprovalRouteAsync,
} from './leaveApprovalSteps.js'
import { logDiagnostic } from './requestLogger.js'
import { config } from './config.js'
import { fetchEmployeeRecordWithCardFields } from './employeeProfile.js'
import {
  employeeAnnualLeaveBalance,
  leaveApplicationExceedsAvailableBalance,
  parseBcLeaveSummary,
  resolveAnnualAvailableLeaveBalance,
  resolveBcLeaveBalance,
  resolveLeaveBalanceBreakdown,
} from './leaveBalance.js'

/* -------------------------------------------------------------------------- */
/* Helpers                                                                    */
/* -------------------------------------------------------------------------- */

export function normalizeAuthGender(gender: string | undefined | null): 'Male' | 'Female' | '' {
  const g = String(gender ?? '').trim().toLowerCase()
  if (!g) return ''
  // HR-Employee.Gender uses Female=0, Male=1. Keep 2 as a compatibility
  // alias because some published queries expose the Leave Type option ordinal
  // (Both=0, Male=1, Female=2) in profile-shaped payloads.
  if (g === '0' || g === '2' || g === 'f' || g.startsWith('female') || g === 'woman') return 'Female'
  if (g === '1' || g === 'm' || g.startsWith('male') || g === 'man') return 'Male'
  if (g === 'female') return 'Female'
  if (g === 'male') return 'Male'
  return ''
}

function leaveTypesGenderFilter(user: ReturnType<typeof authUser>) {
  const normalized = normalizeAuthGender(user.Gender)
  const notGender = normalized === 'Male' ? 'Female' : 'Male'
  return `Gender ne '${odataString(notGender)}'`
}


function leaveTypeGenderRestriction(row: ODataRecord): 'Male' | 'Female' | '' {
  const raw = String((row.Gender ?? (row as Record<string, unknown>).gender) ?? '')
    .trim()
    .toLowerCase()
  if (raw === '2' || raw.startsWith('female')) return 'Female'
  if (raw === '1' || raw.startsWith('male')) return 'Male'
  const name = `${row.Description ?? (row as Record<string, unknown>).description ?? ''} ${
    row.Code ?? (row as Record<string, unknown>).code ?? ''
  }`.toLowerCase()
  if (/patern/.test(name)) return 'Male'
  if (/matern|pre-?natal|ante-?natal/.test(name)) return 'Female'
  return ''
}

function leaveTypeMatchesGender(row: ODataRecord, userGender: 'Male' | 'Female' | '') {
  const restriction = leaveTypeGenderRestriction(row)
  if (!restriction || !userGender) return true
  return restriction === userGender
}

function employeeMaritalStatus(row: ODataRecord | null | undefined) {
  const raw = String(row?.MaritalStatus ?? row?.Marital_Status ?? '').trim().toLowerCase()
  if (raw === '1' || raw.startsWith('single')) return 'Single'
  if (raw === '2' || raw.startsWith('married')) return 'Married'
  if (raw === '3' || raw.startsWith('separated')) return 'Separated'
  if (raw === '4' || raw.startsWith('divorced')) return 'Divorced'
  if (raw === '5' || raw.startsWith('widow')) return 'Widowed'
  return raw ? 'Other' : ''
}

export function leaveTypeIsMarriage(row: ODataRecord | null | undefined) {
  if (!row) return false
  const name = `${row.Description ?? row.description ?? ''} ${row.Code ?? row.code ?? ''}`
  return /marriage|wedding/i.test(name)
}

export function leaveTypeMatchesMaritalStatus(
  row: ODataRecord,
  maritalStatus: string | undefined | null,
) {
  if (!leaveTypeIsMarriage(row)) return true
  const normalized = employeeMaritalStatus({ MaritalStatus: maritalStatus })
  // The reported defect is an already-married employee being offered Marriage
  // Leave. Keep the type visible for Single/unknown/divorced/widowed employees;
  // HR may still need to assess eligibility for remarriage under company policy.
  return normalized !== 'Married'
}

export function parseEmployeeProfileReturn(rawValue: unknown) {
  const values: Record<string, string> = {}
  for (const segment of String(rawValue ?? '').split('#')) {
    const equals = segment.indexOf('=')
    if (equals < 0) continue
    const key = segment.slice(0, equals).trim().toLowerCase()
    const value = segment.slice(equals + 1).trim()
    if (key && value) values[key] = value
  }
  return {
    gender: values.gender ?? '',
    maritalStatus: values.maritalstatus ?? values.marital_status ?? '',
  }
}

async function employeeLeaveEligibility(
  employeeNo: string,
  employeeRow: ODataRecord | null | undefined,
) {
  const fromCard = await callSoapMethod('FnGetEmployeeProfile', { employeeNo })
    .then((result) => parseEmployeeProfileReturn(result.returnValue))
    .catch(() => ({ gender: '', maritalStatus: '' }))
  return {
    gender:
      fromCard.gender ||
      fieldText(employeeRow, ['Gender', 'Sex']),
    maritalStatus:
      fromCard.maritalStatus ||
      fieldText(employeeRow, ['MaritalStatus', 'Marital_Status']),
  }
}

function fieldBoolean(row: ODataRecord | null | undefined, keys: string[]) {
  if (!row) return null
  for (const key of keys) {
    if (!(key in row)) continue
    const value = row[key]
    if (value === undefined || value === null || String(value).trim() === '') continue
    if (typeof value === 'boolean') return value
    const normalized = String(value).trim().toLowerCase()
    if (['true', '1', 'yes', 'y'].includes(normalized)) return true
    if (['false', '0', 'no', 'n'].includes(normalized)) return false
  }
  return null
}

function yearWindow(now = new Date()) {
  const year = now.getUTCFullYear()
  return {
    start: `${year}-01-01`,
    end: `${year}-12-31`,
  }
}

/** Collapse whitespace so a value is safe to drop into a single log line. */
function logSafe(value: unknown, maxLength = 120) {
  return String(value ?? '').replaceAll(/\s+/g, ' ').slice(0, maxLength)
}

/** Convenience: drop a step into express's error pipeline if it throws. */
function safe(handler: (req: Request, res: Response) => Promise<unknown> | unknown) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      await handler(req, res)
    } catch (error) {
      next(error)
    }
  }
}

function authUser(req: Request) {
  const user = req.session.authUser
  if (!user) {
    throw Object.assign(new Error('Unauthenticated'), { status: 401 })
  }
  return user
}

/** SOAP success for send-for-approval — only explicit true values, not BC error text. */
function soapApprovalOk(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw) return false
  const normalized = raw.toLowerCase()
  if (['false', '0', 'no', 'n'].includes(normalized)) return false
  return ['true', '1', 'yes', 'y'].includes(normalized)
}

/**
 * BC SOAP codeunit parameters are positional even though the XML elements are
 * named. Keep this insertion order identical to CuStaffPortal.RequestLeaveApproval:
 * employeeNo, requisitionNo, tableID.
 */
export function leaveApprovalSoapParams(employeeNo: string, requisitionNo: string) {
  return {
    employeeNo,
    requisitionNo,
    tableID: 50532,
  }
}

/** Map BC SOAP `<return_value>` strings into a JS boolean. */
function soapTruthy(value: string | null | undefined) {
  if (!value) return false
  const normalized = String(value).trim().toLowerCase()
  if (['false', '0', 'no', 'n'].includes(normalized)) return false
  return normalized === 'true' || normalized === '1' || normalized === 'yes' || normalized.length > 0
}

/** True when BC returned a leave application / document number (not an error string). */
function soapLeaveDocumentNo(value: string) {
  if (/^lv-?\d+/i.test(value)) return true
  if (/^abh-lap-\d+$/i.test(value)) return true
  if (/^[a-z]{1,6}(?:-[a-z0-9]+)+\d+$/i.test(value)) return true
  if (/^[a-z]{1,6}\d{2,}$/i.test(value)) return true
  return false
}

/** Leave create/update should not treat arbitrary BC error text as success. */
export function soapLeaveActionOk(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw) return false
  const normalized = raw.toLowerCase()
  if (['false', '0', 'no', 'n'].includes(normalized)) return false
  if (['true', '1', 'yes'].includes(normalized)) return true
  return soapLeaveDocumentNo(raw)
}

/** Convert the portal's normal/first-half/second-half selection to BC's Boolean flag. */
export function isHalfDaySelection(value: string) {
  return value !== '0'
}

/** ESS sends 0/1/2 to GetLeaveDates; it is not the same as the LeaveApplication Boolean. */
export function halfDayOptionValue(value: string) {
  const normalized = String(value ?? '0').trim()
  if (normalized === '1' || normalized === '2') return Number(normalized)
  return 0
}

export function leaveTypeIsAnnual(row: ODataRecord | null | undefined) {
  if (!row) return false
  const annual = row.Annual ?? row.annual
  if (typeof annual === 'boolean') return annual
  if (typeof annual === 'string') {
    const normalized = annual.trim().toLowerCase()
    return normalized === 'yes' || normalized === 'true'
  }
  return String(row.Code ?? '') === '0001'
}

export function halfDayRequiresAnnualLeave(value: string) {
  return halfDayOptionValue(value) !== 0
}

/** BC LeaveApplication declares daysApplied as Integer; half-day is carried by its Boolean flag. */
export function bcLeaveDaysApplied(appliedDays: number, halfDayLeave: string) {
  if (halfDayRequiresAnnualLeave(halfDayLeave)) return 1
  const rounded = Math.round(appliedDays)
  return rounded > 0 ? rounded : 1
}

function fieldText(row: ODataRecord | null | undefined, keys: string[], fallback = '') {
  if (!row) return fallback
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

function isSickLeaveValue(value: unknown) {
  return /\b(sick|medical|illness|hospital)\b/i.test(String(value ?? '').replaceAll('_', ' '))
}

function isSickLeaveRow(row: ODataRecord | null | undefined) {
  if (!row) return false
  return [
    fieldText(row, ['LeaveType', 'Leave_Type', 'LeaveTypeCode', 'Leave_Type_Code']),
    fieldText(row, ['LeaveTypeDescription', 'Leave_Type_Description', 'Description']),
  ].some(isSickLeaveValue)
}

async function assertSickLeaveAttachment(no: string, leave: ODataRecord | string) {
  const sick = typeof leave === 'string' ? isSickLeaveValue(leave) : isSickLeaveRow(leave)
  if (!sick) return
  const attachments = (await fetchOData('QyDocumentAttachments', {
    $filter: `No eq '${odataString(no)}' and TableID eq 50532`,
    $top: 1,
  })) as ODataRecord[] | null
  if (!Array.isArray(attachments) || attachments.length === 0) {
    throw Object.assign(
      new Error('A supporting attachment is required before requesting approval for sick leave.'),
      { status: 422, code: 'SICK_LEAVE_ATTACHMENT_REQUIRED' },
    )
  }
}

function isMarriageLeaveValue(value: unknown) {
  return /\b(wedding|marriage)\b/i.test(String(value ?? '').replaceAll('_', ' '))
}

function isMarriageLeaveRow(row: ODataRecord | null | undefined) {
  if (!row) return false
  return [
    fieldText(row, ['LeaveType', 'Leave_Type', 'LeaveTypeCode', 'Leave_Type_Code']),
    fieldText(row, ['LeaveTypeDescription', 'Leave_Type_Description', 'Description']),
  ].some(isMarriageLeaveValue)
}

async function assertMarriageLeaveAttachment(no: string, leave: ODataRecord | string) {
  const marriage =
    typeof leave === 'string' ? isMarriageLeaveValue(leave) : isMarriageLeaveRow(leave)
  if (!marriage) return
  const attachments = (await fetchOData('QyDocumentAttachments', {
    $filter: `No eq '${odataString(no)}' and TableID eq 50532`,
    $top: 1,
  })) as ODataRecord[] | null
  if (!Array.isArray(attachments) || attachments.length === 0) {
    throw Object.assign(
      new Error(
        'A wedding / marriage certificate attachment is required before requesting approval for marriage leave.',
      ),
      { status: 422, code: 'MARRIAGE_LEAVE_ATTACHMENT_REQUIRED' },
    )
  }
}

async function assertLeaveApprovalAttachments(no: string, leave: ODataRecord | string) {
  await assertSickLeaveAttachment(no, leave)
  await assertMarriageLeaveAttachment(no, leave)
}

function fieldNumber(row: ODataRecord | null | undefined, keys: string[]) {
  if (!row) return null
  for (const key of keys) {
    const value = row[key]
    if (value === undefined || value === null || String(value).trim() === '') continue
    const parsed = Number(value)
    if (Number.isFinite(parsed)) return parsed
  }
  return null
}

function normalizeLeaveFieldKey(key: string) {
  return key.toLowerCase().replace(/[_\s]/g, '')
}

function discoverLeaveFieldNumber(
  row: ODataRecord | null | undefined,
  matchers: Array<(normalizedKey: string) => boolean>,
) {
  if (!row) return null
  for (const [key, value] of Object.entries(row)) {
    if (value === undefined || value === null || String(value).trim() === '') continue
    const normalized = normalizeLeaveFieldKey(key)
    if (!matchers.some((match) => match(normalized))) continue
    const parsed = Number(value)
    if (Number.isFinite(parsed)) return parsed
  }
  return null
}

function roundLeaveValue(value: number) {
  return Math.round(value * 100) / 100
}

export function parseEmployeeLeaveBalancesReturn(value: unknown): ODataRecord | null {
  const raw = String(value ?? '').trim()
  if (!raw) return null

  const parsed: ODataRecord = {}
  for (const part of raw.split('#')) {
    const separator = part.indexOf('=')
    if (separator <= 0) continue
    const key = part.slice(0, separator).trim()
    const numeric = Number(part.slice(separator + 1).trim().replaceAll(',', ''))
    if (key && Number.isFinite(numeric)) parsed[key] = numeric
  }
  if (Object.keys(parsed).length === 0) return null

  // Normalize AccruedDays into EarnedLeaveDays field name used by OData/employee metrics
  // when the updated SOAP sends both AccruedDays and Leave Accrued To-Date.
  if (parsed.AccruedDays !== undefined && parsed.EarnedLeaveDays === undefined) {
    parsed.EarnedLeaveDays = parsed.AccruedDays
  }
  return parsed
}

export interface EmployeeLeaveMetrics {
  leaveBalance: number | null
  employeeCardLeaveBalance: number | null
  accruedDays: number | null
  earnedLeaveDays: number | null
  carryForwardBalance?: number | null
}

export function employeeLeaveMetrics(
  row: ODataRecord | null | undefined,
  user: ReturnType<typeof authUser>,
): EmployeeLeaveMetrics {
  if (!row) {
    const sessionBalance = Number(user.leaveBalance)
    return {
      leaveBalance: Number.isFinite(sessionBalance) ? sessionBalance : null,
      employeeCardLeaveBalance: Number.isFinite(sessionBalance) ? sessionBalance : null,
      accruedDays: null,
      earnedLeaveDays: null,
      carryForwardBalance: null,
    }
  }

  const leaveBalance =
    fieldNumber(row, [
      'AnnualLeaveBalance',
      'Annual_Leave_Balance',
      'Annual_Leave_balance',
      'AnnualLeavebalance',
    ]) ??
    discoverLeaveFieldNumber(row, [
      (key) => key === 'annualleavebalance',
    ])

  // BC Employee Card captions (ABH):
  // - "Earned Leave Days" field → Accrued Days (period accrual, e.g. 1.92)
  // - "Leave Balance" field → Leave Accrued To-Date (carry forward + accrued, e.g. 11.92)
  // - Page OnAfterGetRecord: Leave Balance := Carry forward Balance + Earned Leave Days
  const accruedDays =
    fieldNumber(row, [
      'AccruedDays',
      'Accrued_Days',
      'EarnedLeaveDays',
      'Earned_Leave_Days',
      'EarnedLeave',
      'Earned_Leave',
    ]) ??
    discoverLeaveFieldNumber(row, [
      (key) =>
        key === 'accrueddays' || key === 'earnedleavedays' || key === 'earnedleave',
    ])

  const carryForwardBalance =
    fieldNumber(row, [
      'CarryForwardBalance',
      'Carry_forward_Balance',
      'Carry_Forward_Balance',
      'CarryforwardBalance',
      'CarryForward',
      'Carry_forward',
      'Carry_Forward',
    ]) ??
    discoverLeaveFieldNumber(row, [
      (key) => key === 'carryforwardbalance' || key === 'carryforward',
    ])

  const leaveBalanceField =
    fieldNumber(row, ['LeaveBalance', 'Leave_Balance', 'LeaveAccruedToDate', 'Leave_Accrued_To_Date']) ??
    discoverLeaveFieldNumber(row, [
      (key) => key === 'leavebalance' || key === 'leaveaccruedtodate',
    ])

  // Prefer the same formula BC uses on the employee card. Do NOT trust LeaveBalance alone:
  // legacy FnGetEmployeeLeaveBalances SOAP wrongly sets LeaveBalance = AnnualLeaveBalance.
  const computedAccruedToDate =
    accruedDays !== null && carryForwardBalance !== null
      ? roundLeaveValue(accruedDays + carryForwardBalance)
      : null

  const leaveAccruedToDate =
    computedAccruedToDate ??
    (leaveBalanceField !== null &&
    leaveBalance !== null &&
    Math.abs(leaveBalanceField - leaveBalance) < 0.001
      ? null
      : leaveBalanceField) ??
    accruedDays

  return {
    leaveBalance,
    employeeCardLeaveBalance: leaveAccruedToDate,
    accruedDays,
    earnedLeaveDays: leaveAccruedToDate,
    carryForwardBalance,
  }
}

export function resolveAnnualLeaveBalance(
  metrics: ReturnType<typeof employeeLeaveMetrics>,
  ledgerNet: number,
) {
  if (metrics.leaveBalance !== null) return metrics.leaveBalance
  if (metrics.employeeCardLeaveBalance !== null) return metrics.employeeCardLeaveBalance
  return ledgerNet
}

export function resolveAnnualLeaveEntitlement(
  metrics: ReturnType<typeof employeeLeaveMetrics>,
  leaveTypeDays: number,
) {
  if (Number.isFinite(leaveTypeDays) && leaveTypeDays > 0) return leaveTypeDays
  if (metrics.leaveBalance !== null) return metrics.leaveBalance
  return 0
}

async function fetchCurrentEmployeeRow(employeeNo: string) {
  return fetchEmployeeRecordWithCardFields(employeeNo).catch(() => null)
}

async function fetchLeaveApplicationBalanceRows(employeeNo: string, leaveTypeCode: string) {
  const rows = (await fetchOData('QyHRLeaveApplications', {
    $filter:
      `EmployeeNo eq '${odataString(employeeNo)}'` +
      ` and LeaveType eq '${odataString(leaveTypeCode)}'`,
    $orderby: 'ApplicationDate desc',
    $top: 10,
  }).catch(() => [])) as ODataRecord[] | null
  return Array.isArray(rows) ? rows : []
}

function likelyActiveEmployee(row: ODataRecord) {
  const status = fieldText(row, ['Status', 'EmploymentStatus', 'Employment_Status']).trim().toLowerCase()
  if (!status) return true
  return !['inactive', 'terminated', 'resigned', 'dismissed', 'blocked', 'suspended'].includes(status)
}

async function fetchRelieverRows(employeeNo: string) {
  const filters = [
    `No ne '${odataString(employeeNo)}' and Status eq 'Active'`,
    `No ne '${odataString(employeeNo)}'`,
  ]

  for (const filter of filters) {
    const rows = (await fetchOData('QyHREmployee', {
      $filter: filter,
      $top: 500,
    }).catch(() => [])) as ODataRecord[] | null
    const list = Array.isArray(rows) ? rows : []
    const activeRows = list.filter(likelyActiveEmployee)
    if (activeRows.length > 0) return activeRows
    if (list.length > 0 && filter.includes('No ne')) return list
  }

  return []
}

function normalizeScheduleDate(value: string) {
  const raw = (value ?? '').trim()
  if (!raw || raw.startsWith('0001-01-01')) return ''
  return formatBcSoapDate(raw) || raw.slice(0, 10)
}

function leaveScheduleEmployeeNo(row: ODataRecord) {
  return fieldText(row, ['EmployeeNo', 'Employee_No', 'StaffNo', 'Staff_No'])
}

function employeeDisplayFromRow(row: ODataRecord) {
  const employeeNo = fieldText(row, ['No', 'EmployeeNo', 'Employee_No'])
  return {
    employeeNo,
    employeeName:
      fieldText(row, ['FullName', 'Name', 'EmployeeName']) ||
      [fieldText(row, ['FirstName', 'First_Name']), fieldText(row, ['LastName', 'Last_Name'])]
        .filter(Boolean)
        .join(' '),
    jobTitle: fieldText(row, ['JobTitle', 'Job_Title', 'JobTitleDescription', 'Job_Title_Description', 'Position']),
    departmentCode: fieldText(row, ['GlobalDimension2Code', 'DepartmentCode', 'Department_Code']),
  }
}

function mapLeaveRowsToSchedule(
  leaveRows: ODataRecord[],
  directory: Map<string, ReturnType<typeof employeeDisplayFromRow>>,
  userEmployeeNo: string,
  scope: string,
) {
  const allowedEmployees = new Set(directory.keys())

  return leaveRows
    .map((row) => {
      const employeeNo = leaveScheduleEmployeeNo(row) || userEmployeeNo
      if (scope !== 'self' && allowedEmployees.size > 0 && !allowedEmployees.has(employeeNo)) return null

      const person =
        directory.get(employeeNo) ??
        ({
          employeeNo,
          employeeName: fieldText(row, ['EmployeeName', 'StaffName'], employeeNo),
          jobTitle: '',
          departmentCode: '',
        } as const)

      const status = resolveLeaveStatus(row)
      if (status === 'Cancelled' || status === 'Rejected') return null

      const startDate = normalizeScheduleDate(
        fieldText(row, ['StartDate', 'Start_Date']) || fieldText(row, ['ApplicationDate', 'Application_Date']),
      )
      const endDate = normalizeScheduleDate(fieldText(row, ['EndDate', 'End_Date'])) || startDate
      if (!startDate) return null

      const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])
      if (!applicationCode) return null

      return {
        id: applicationCode,
        applicationCode,
        employeeNo,
        employeeName: person.employeeName || employeeNo,
        jobTitle: person.jobTitle,
        leaveType: fieldText(row, ['LeaveType', 'Leave_Type']),
        daysApplied: fieldNumber(row, ['DaysApplied', 'Days_Applied', 'NoofDays', 'No_of_Days']),
        startDate,
        endDate,
        returnDate: normalizeScheduleDate(fieldText(row, ['ReturnDate', 'Return_Date'])),
        status,
        isSelf: employeeNo === userEmployeeNo,
      }
    })
    .filter(Boolean)
}

async function fetchScheduleEmployeeDirectory(user: ReturnType<typeof authUser>, scope: string) {
  const directory = new Map<string, ReturnType<typeof employeeDisplayFromRow>>()
  const addRow = (row: ODataRecord) => {
    const employee = employeeDisplayFromRow(row)
    if (!employee.employeeNo) return
    directory.set(employee.employeeNo, employee)
  }

  const selfRow = await fetchCurrentEmployeeRow(user.employeeNo)
  if (selfRow) addRow(selfRow)

  if (scope === 'self') {
    return directory
  }

  const department = odataString(user.department)
  const filters = [
    department ? `GlobalDimension2Code eq '${department}' and Status eq 'Active'` : '',
    department ? `DepartmentCode eq '${department}' and Status eq 'Active'` : '',
    department ? `GlobalDimension2Code eq '${department}'` : '',
    `Status eq 'Active'`,
  ].filter(Boolean)

  for (const filter of filters) {
    const rows = (await fetchOData('QyHREmployee', {
      $filter: filter,
      $top: 500,
    }).catch(() => [])) as ODataRecord[] | null
    const list = Array.isArray(rows) ? rows.filter(likelyActiveEmployee) : []
    for (const row of list) addRow(row)
    if (directory.size > 1) break
  }

  return directory
}

async function fetchLeaveApprovalEntriesByDocumentNos(documentNos: string[]) {
  const grouped = new Map<string, ODataRecord[]>()
  const unique = [
    ...new Set(
      documentNos
        .flatMap((value) => leaveDocumentNoCandidates(value))
        .map((value) => value.trim())
        .filter(Boolean),
    ),
  ]
  if (!unique.length) return grouped

  for (let offset = 0; offset < unique.length; offset += 12) {
    const chunk = unique.slice(offset, offset + 12)
    const docFilter = chunk.map((no) => `DocumentNo eq '${odataString(no)}'`).join(' or ')
    const rows = (await fetchOData('QyApprovalEntry', {
      $filter: `(${docFilter}) and ${approvalTableFilter('leave')}`,
      $top: 500,
    }).catch(() => [])) as ODataRecord[] | null
    mergeLeaveApprovalRows(grouped, Array.isArray(rows) ? rows : [])
  }

  const missing = unique.filter((no) => leaveApprovalEntriesForDocument(grouped, no).length === 0)
  for (let offset = 0; offset < missing.length; offset += 12) {
    const chunk = missing.slice(offset, offset + 12)
    const docFilter = chunk.map((no) => `DocumentNo eq '${odataString(no)}'`).join(' or ')
    const rows = (await fetchOData('QyApprovalEntry', {
      $filter: `(${docFilter})`,
      $top: 500,
    }).catch(() => [])) as ODataRecord[] | null
    mergeLeaveApprovalRows(grouped, filterLikelyLeaveApprovalEntries(Array.isArray(rows) ? rows : []))
  }

  return grouped
}

function filterLikelyLeaveApprovalEntries(rows: ODataRecord[]) {
  const leaveTableIds = new Set(approvalTableIdsFor('leave'))
  return rows.filter((row) => {
    const tableId = Number(row.TableID ?? row.TableId ?? 0)
    if (leaveTableIds.has(tableId)) return true
    const documentType = fieldText(row, ['DocumentType', 'Document_Type']).toLowerCase()
    if (documentType.includes('leave')) return true
    // Leave document numbers on this deployment look like "LV0001234".
    const docNo = fieldText(row, ['DocumentNo', 'Document_No', 'No'])
    return /^lv/i.test(docNo)
  })
}

/** Normalised key so "LV00022", "lv00022", and "00022" all match the same leave. */
function normalizedLeaveKey(value: string) {
  const trimmed = String(value ?? '').trim().toUpperCase()
  if (!trimmed) return ''
  const stripped = trimmed.replace(/^LV/, '').replace(/^0+/, '')
  return stripped || trimmed
}

function dedupeApprovalEntryList(...lists: ODataRecord[][]) {
  const seen = new Set<string>()
  const merged: ODataRecord[] = []
  for (const list of lists) {
    for (const entry of list) {
      const key = fieldText(entry, ['EntryNo', 'Entry_No']) || JSON.stringify(entry)
      if (seen.has(key)) continue
      seen.add(key)
      merged.push(entry)
    }
  }
  return merged
}

/**
 * Fetch every leave approval entry this user submitted (sender side). BC keys
 * approval entries by SenderID/ApproverID, so this reliably surfaces pending
 * items even when a per-DocumentNo lookup misses due to number formatting.
 */
async function fetchLeaveApprovalEntriesForSender(user: ReturnType<typeof authUser>) {
  const senderFilters = [
    `SenderID eq '${odataString(user.userID)}'`,
    `UserID eq '${odataString(user.userID)}'`,
  ]
  const seen = new Set<string>()
  const collected: ODataRecord[] = []
  for (const senderFilter of senderFilters) {
    for (const scoped of [`${senderFilter} and ${approvalTableFilter('leave')}`, senderFilter]) {
      const rows = (await fetchOData('QyApprovalEntry', {
        $filter: scoped,
        $top: 500,
      }).catch(() => [])) as ODataRecord[] | null
      const list = scoped.includes('TableID')
        ? Array.isArray(rows)
          ? rows
          : []
        : filterLikelyLeaveApprovalEntries(Array.isArray(rows) ? rows : [])
      for (const entry of list) {
        const key = fieldText(entry, ['EntryNo', 'Entry_No']) || JSON.stringify(entry)
        if (seen.has(key)) continue
        seen.add(key)
        collected.push(entry)
      }
      if (collected.length > 0) break
    }
  }
  return collected
}

function indexLeaveApprovalEntriesByNo(entries: ODataRecord[]) {
  const index = new Map<string, ODataRecord[]>()
  for (const entry of entries) {
    const docNo = fieldText(entry, ['DocumentNo', 'Document_No', 'No'])
    const key = normalizedLeaveKey(docNo)
    if (!key) continue
    const bucket = index.get(key) ?? []
    bucket.push(entry)
    index.set(key, bucket)
  }
  return index
}

function mergeLeaveApprovalRows(grouped: Map<string, ODataRecord[]>, rows: ODataRecord[]) {
  for (const row of rows) {
    const docNo = fieldText(row, ['DocumentNo', 'Document_No'])
    if (!docNo) continue
    const list = grouped.get(docNo) ?? []
    list.push(row)
    grouped.set(docNo, list)
  }
}

function leaveApprovalEntriesForDocument(
  grouped: Map<string, ODataRecord[]>,
  documentNo: string,
) {
  const collected: ODataRecord[] = []
  const seen = new Set<string>()
  for (const candidate of leaveDocumentNoCandidates(documentNo)) {
    for (const entry of [
      ...(grouped.get(candidate) ?? []),
      ...(grouped.get(candidate.toUpperCase()) ?? []),
      ...(grouped.get(candidate.toLowerCase()) ?? []),
    ]) {
      const entryNo = fieldText(entry, ['EntryNo', 'Entry_No'])
      const key = entryNo || JSON.stringify(entry)
      if (seen.has(key)) continue
      seen.add(key)
      collected.push(entry)
    }
  }
  return collected
}

/** One sender-side lookup (all approvals this user submitted), matched by no. */
async function findLeaveApprovalEntriesBySender(
  documentNo: string,
  user: ReturnType<typeof authUser>,
) {
  const senderIndex = indexLeaveApprovalEntriesByNo(
    await fetchLeaveApprovalEntriesForSender(user),
  )
  return senderIndex.get(normalizedLeaveKey(documentNo)) ?? []
}

/**
 * Compact ground-truth snapshot for a leave approval attempt. Tells us whether
 * BC created ANY approval entry for this user (senderAll) and whether one maps
 * to this leave (byDoc / senderMatches) — so we can tell a BC-workflow problem
 * apart from a portal detection problem.
 */
async function buildLeaveApprovalDiagnostic(
  user: ReturnType<typeof authUser>,
  no: string,
  row: ODataRecord | null,
  soapReturnValue?: string,
) {
  const candidates = row ? expandLeaveCancelDocumentNos(no, row) : [...leaveDocumentNoCandidates(no)]
  const byDoc = leaveApprovalEntriesForDocument(
    await fetchLeaveApprovalEntriesByDocumentNos(candidates),
    no,
  )
  const senderAll = await fetchLeaveApprovalEntriesForSender(user)
  const senderMatches = indexLeaveApprovalEntriesByNo(senderAll).get(normalizedLeaveKey(no)) ?? []
  return {
    soapReturnValue: soapReturnValue ?? '',
    byDoc: byDoc.length,
    senderAll: senderAll.length,
    senderMatches: senderMatches.length,
    headerStatus: row ? fieldText(row, ['Status']) : '',
    headerApprovalStatus: row ? fieldText(row, ['ApprovalStatus', 'Approval_Status']) : '',
    senderDocs: senderAll.slice(0, 25).map((entry) => ({
      no: fieldText(entry, ['DocumentNo', 'Document_No', 'No']),
      status: fieldText(entry, ['Status']),
      tableId: entry.TableID ?? entry.TableId ?? null,
      sender: fieldText(entry, ['SenderID', 'UserID']),
      approver: fieldText(entry, ['ApproverID']),
    })),
  }
}

async function loadLeaveApprovalEntries(
  documentNo: string,
  pollWhenPending = false,
  user?: ReturnType<typeof authUser>,
) {
  // Cheap by-document lookup first; poll a few times for BC to catch up.
  let approvalEntries = leaveApprovalEntriesForDocument(
    await fetchLeaveApprovalEntriesByDocumentNos([documentNo]),
    documentNo,
  )
  if (!approvalEntries.length && pollWhenPending) {
    for (let attempt = 0; attempt < 5; attempt += 1) {
      await new Promise((resolve) => setTimeout(resolve, 400))
      approvalEntries = leaveApprovalEntriesForDocument(
        await fetchLeaveApprovalEntriesByDocumentNos([documentNo]),
        documentNo,
      )
      if (approvalEntries.length > 0) break
    }
  }
  // Sender-side fallback runs at most once (only when the doc lookup found
  // nothing) so we never fan out into a burst of BC queries.
  if (!approvalEntries.length && user) {
    approvalEntries = await findLeaveApprovalEntriesBySender(documentNo, user)
  }
  return enrichLeaveApprovalEntries(approvalEntries)
}

async function fetchLeaveScheduleRows(user: ReturnType<typeof authUser>, scope: string) {
  const directory = await fetchScheduleEmployeeDirectory(user, scope)
  const { start, end } = yearWindow()

  if (scope === 'self') {
    const filters = [
      `UserID eq '${odataString(user.userID)}' and (ApplicationDate gt ${start} and ApplicationDate lt ${end})`,
      `EmployeeNo eq '${odataString(user.employeeNo)}' and (StartDate gt ${start} and StartDate lt ${end})`,
      `EmployeeNo eq '${odataString(user.employeeNo)}' and (ApplicationDate gt ${start} and ApplicationDate lt ${end})`,
    ]
    const collected = new Map<string, ODataRecord>()
    for (const filter of filters) {
      const rows = (await fetchOData('QyHRLeaveApplications', {
        $filter: filter,
        $top: 100,
      }).catch(() => [])) as ODataRecord[] | null
      for (const row of Array.isArray(rows) ? rows : []) {
        const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])
        if (!applicationCode) continue
        collected.set(applicationCode, row)
      }
    }
    return mapLeaveRowsToSchedule([...collected.values()], directory, user.employeeNo, scope)
  }

  const filters = [
    `StartDate gt ${start} and StartDate lt ${end}`,
    `ApplicationDate gt ${start} and ApplicationDate lt ${end}`,
  ]

  const collected = new Map<string, ODataRecord>()
  for (const filter of filters) {
    const rows = (await fetchOData('QyHRLeaveApplications', {
      $filter: filter,
      $top: 500,
    }).catch(() => [])) as ODataRecord[] | null
    for (const row of Array.isArray(rows) ? rows : []) {
      const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])
      if (!applicationCode) continue
      collected.set(applicationCode, row)
    }
  }

  return mapLeaveRowsToSchedule([...collected.values()], directory, user.employeeNo, scope)
}

function submittedLeaveNoFromReturn(value: unknown) {
  const normalized = String(value ?? '').trim()
  if (!normalized) return ''
  const lower = normalized.toLowerCase()
  if (['true', 'false', '1', '0', 'yes', 'no'].includes(lower)) return ''
  return soapLeaveDocumentNo(normalized) ? normalized : ''
}

function sameBcDate(left: unknown, right: string) {
  const leftDate = formatBcSoapDate(String(left ?? ''))
  const rightDate = formatBcSoapDate(right)
  return Boolean(leftDate && rightDate && leftDate === rightDate)
}

function submittedLeaveScore(row: ODataRecord, body: {
  leaveType: string
  appliedDays: number
  startDate: string
  reason: string
}, endDate: string) {
  let score = 0
  if (fieldText(row, ['LeaveType', 'Leave_Type']) === body.leaveType) score += 4
  if (sameBcDate(fieldText(row, ['StartDate', 'Start_Date']), body.startDate)) score += 4
  if (sameBcDate(fieldText(row, ['EndDate', 'End_Date']), endDate)) score += 2

  const days = fieldNumber(row, ['DaysApplied', 'Days_Applied'])
  if (days !== null && Math.abs(days - body.appliedDays) < 0.001) score += 3

  const reason = fieldText(row, ['Reasonforleave', 'Reason_for_leave', 'Reason', 'Purpose', 'Description'])
    .trim()
    .toLowerCase()
  if (reason && reason === body.reason.trim().toLowerCase()) score += 2

  const status = fieldText(row, ['Status', 'DocumentStatus', 'ApprovalStatus']).trim().toLowerCase()
  if (!status || status === 'open' || status === 'pending') score += 1

  return score
}

async function resolveSubmittedLeaveNo(
  user: ReturnType<typeof authUser>,
  body: {
    leaveType: string
    appliedDays: number
    startDate: string
    reason: string
    requisitionNo: string
  },
  endDate: string,
  rawReturnValue: unknown,
) {
  if (body.requisitionNo) return body.requisitionNo

  const fromReturn = submittedLeaveNoFromReturn(rawReturnValue)
  if (fromReturn) return fromReturn

  const baseFilter =
    `EmployeeNo eq '${odataString(user.employeeNo)}'` +
    ` and LeaveType eq '${odataString(body.leaveType)}'`
  const queryOptions = [
    {
      $filter: `UserID eq '${odataString(user.userID)}'`,
      $orderby: 'ApplicationDate desc',
      $top: 15,
    },
    {
      $filter: `EmployeeNo eq '${odataString(user.employeeNo)}'`,
      $orderby: 'ApplicationDate desc',
      $top: 15,
    },
    { $filter: baseFilter, $orderby: 'ApplicationDate desc', $top: 20 },
    { $filter: baseFilter, $top: 20 },
  ]

  const ranked: Array<{ no: string; score: number }> = []
  const seen = new Set<string>()

  for (const options of queryOptions) {
    const rows = (await fetchOData('QyHRLeaveApplications', options).catch(() => [])) as ODataRecord[] | null
    const list = Array.isArray(rows) ? rows : []
    for (const row of list) {
      const no = fieldText(row, ['ApplicationCode', 'Application_Code', 'No', 'ApplicationNo'])
      if (!no || seen.has(no)) continue
      seen.add(no)
      ranked.push({ no, score: submittedLeaveScore(row, body, endDate) })
    }
  }

  ranked.sort((left, right) => right.score - left.score)
  if (ranked[0]?.no) return ranked[0].no

  return ''
}

async function pollSubmittedLeaveNo(
  user: ReturnType<typeof authUser>,
  body: {
    leaveType: string
    appliedDays: number
    startDate: string
    reason: string
    requisitionNo: string
  },
  endDate: string,
  rawReturnValue: unknown,
) {
  for (let attempt = 0; attempt < 8; attempt += 1) {
    const no = await resolveSubmittedLeaveNo(
      user,
      body,
      endDate,
      attempt === 0 ? rawReturnValue : '',
    )
    if (no) return no
    if (attempt < 7) {
      await new Promise((resolve) => setTimeout(resolve, 500 * (attempt + 1)))
    }
  }
  return ''
}

function leaveBcHeaderStatus(row: ODataRecord) {
  return fieldText(row, ['Status', 'DocumentStatus', 'Approval_Status']).trim()
}

function leaveIsOpenInBc(row: ODataRecord) {
  const status = leaveBcHeaderStatus(row).toLowerCase()
  return !status || status === 'open' || status === 'draft'
}

function expandLeaveCancelDocumentNos(no: string, row: ODataRecord) {
  const docNo = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'], no)
  const values = new Set<string>()
  const push = (value: string) => {
    const trimmed = value.trim()
    if (trimmed) values.add(trimmed)
  }
  for (const candidate of [no, docNo, ...leaveDocumentNoCandidates(no), ...leaveDocumentNoCandidates(docNo)]) {
    push(candidate)
    if (/^lv/i.test(candidate)) {
      const stripped = candidate.replace(/^lv/i, '')
      push(stripped)
      push(stripped.replace(/^0+/, '') || stripped)
      if (/^\d+$/.test(stripped)) push(stripped.padStart(10, '0'))
    }
  }
  return [...values]
}

function soapCancelOk(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw) return false
  const normalized = raw.toLowerCase()
  if (['false', '0', 'no', 'n'].includes(normalized)) return false
  return normalized === 'true' || normalized === '1' || normalized === 'yes'
}

async function tryCancelLeaveSoap(
  user: ReturnType<typeof authUser>,
  candidate: string,
  row: ODataRecord,
  options: { cancelOnly?: boolean } = {},
) {
  const paramSets: Record<string, unknown>[] = [
    { requisitionNo: candidate, employeeNo: user.employeeNo },
    { requisitionNo: candidate, employeeNo: user.employeeNo, tableID: 50532 },
    {
      requisitionNo: candidate,
      employeeNo: user.employeeNo,
      myUserID: user.userID,
      tableID: 50532,
    },
    { leaveNo: candidate, employeeNo: user.employeeNo, myUserID: user.userID },
  ]

  if (leaveIsOpenInBc(row) && !options.cancelOnly) {
    const today = new Date().toISOString().slice(0, 10)
    const startDate = formatBcSoapDate(fieldText(row, ['StartDate', 'Start_Date'])) || today
    const endDate = formatBcSoapDate(fieldText(row, ['EndDate', 'End_Date'])) || startDate
    const returnDate =
      formatBcSoapDate(fieldText(row, ['ReturnDate', 'Return_Date'])) || nextWorkingDayIso(endDate)
    paramSets.unshift({
      action: 'delete',
      leaveNo: candidate,
      employeeNo: user.employeeNo,
      myUserID: user.userID,
      daysApplied: Math.max(1, Math.round(fieldNumber(row, ['DaysApplied', 'Days_Applied']) ?? 1)),
      startDate,
      endDate,
      returnDate,
      reason: fieldText(row, ['Reasonforleave', 'Reason_for_leave', 'Reason']),
      reliever: fieldText(row, ['Reliever', 'Duties_Taken_Over_By', 'RelieverNo']),
      leaveType: fieldText(row, ['LeaveType', 'Leave_Type']),
      isRequestLeaveAllowance: false,
      isHalfDayLeave: false,
    })
  }

  for (const params of paramSets) {
    const method = 'action' in params ? 'LeaveApplication' : 'CancelLeaveApplication'
    try {
      const result = await callSoapMethod(method, params)
      if (soapCancelOk(result.returnValue)) return true
    } catch {
      // try the next BC parameter shape
    }
  }
  return false
}

async function cancelLeaveApplicationInBc(
  user: ReturnType<typeof authUser>,
  portalNo: string,
  row: ODataRecord,
) {
  const docCandidates = expandLeaveCancelDocumentNos(portalNo, row)

  for (const candidate of docCandidates) {
    if (await tryCancelLeaveSoap(user, candidate, row)) {
      return
    }
  }

  if (leaveIsOpenInBc(row)) {
    for (const candidate of docCandidates) {
      try {
        const approval = await callSoapMethod(
          'RequestLeaveApproval',
          leaveApprovalSoapParams(user.employeeNo, candidate),
        )
        if (!soapCancelOk(approval.returnValue)) continue
        if (await tryCancelLeaveSoap(user, candidate, row, { cancelOnly: true })) {
          return
        }
      } catch {
        // try the next document number alias
      }
    }
  }

  const message = leaveIsOpenInBc(row)
    ? 'This leave draft could not be discarded. Verify the application in Business Central or contact support.'
    : 'Leave application could not be cancelled.'
  throw Object.assign(new Error(message), { status: 422 })
}

async function deleteLeaveApplicationInBc(
  user: ReturnType<typeof authUser>,
  portalNo: string,
  row: ODataRecord,
) {
  for (const candidate of expandLeaveCancelDocumentNos(portalNo, row)) {
    try {
      const result = await callSoapMethod('DeleteLeaveApplication', {
        requisitionNo: candidate,
        employeeNo: user.employeeNo,
      })
      if (soapCancelOk(result.returnValue)) return
    } catch {
      // Try the next known document-number shape.
    }
  }
  throw Object.assign(
    new Error('This leave draft could not be deleted in Business Central. Please try again.'),
    { status: 422, code: 'LEAVE_DELETE_FAILED' },
  )
}

async function fetchOwnedLeaveRow(user: ReturnType<typeof authUser>, no: string) {
  const filters = [
    `ApplicationCode eq '${odataString(no)}' and EmployeeNo eq '${odataString(user.employeeNo)}'`,
    `ApplicationCode eq '${odataString(no)}' and UserID eq '${odataString(user.userID)}'`,
    `ApplicationCode eq '${odataString(no)}'`,
  ]
  for (const filter of filters) {
    const rows = (await fetchOData('QyHRLeaveApplications', {
      $filter: filter,
      $top: 1,
    }).catch(() => [])) as ODataRecord[] | null
    if (Array.isArray(rows) && rows.length > 0) return rows[0]!
  }
  return null
}

function mapLeaveAttachmentsSimple(rows: ODataRecord[]) {
  return rows.map((row, index) => {
    const baseName = fieldText(row, ['FileName', 'Name'], `attachment-${index + 1}`)
    const extension = fieldText(row, ['FileExtension', 'Extension'])
    const fileName =
      extension && !baseName.toLowerCase().endsWith(`.${extension.toLowerCase()}`)
        ? `${baseName}.${extension}`
        : baseName
    return {
      id: fieldText(row, ['ID', 'Id', 'AttachmentID', 'Attachment_ID', 'EntryNo', 'Entry_No'], String(index + 1)),
      fileName,
      fileType: fieldText(row, ['MimeType', 'ContentType'], 'application/octet-stream'),
      size: fieldNumber(row, ['FileSize', 'Size']),
      description: fieldText(row, ['Description'], baseName),
      progress: 100,
      uploadedAt: fieldText(row, ['AttachedDate', 'Date', 'CreatedAt'], ''),
    }
  })
}

async function buildLeavePortalDetail(
  row: ODataRecord,
  no: string,
  user: ReturnType<typeof authUser>,
  approvalEntries: ODataRecord[],
  attachments: ODataRecord[],
) {
  const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'], no)
  const status = resolveLeaveStatus(row, approvalEntries)
  const approvalSteps = await resolveLeaveApprovalStepsAsync(row, approvalEntries, applicationCode, {
    employeeNo: fieldText(row, ['EmployeeNo', 'Employee_No'], user.employeeNo),
    userID: user.userID,
    department: user.department,
  })
  const primaryApprover = approvalSteps[0]
  return {
    id: `leave-${applicationCode}`,
    requestNo: applicationCode,
    requestType: 'leave',
    title: `Leave application ${applicationCode}`,
    status,
    makerEmployeeNo: fieldText(row, ['EmployeeNo', 'Employee_No'], user.employeeNo),
    makerName: fieldText(row, ['EmployeeName', 'StaffName'], user.employeeNo),
    departmentCode: '',
    departmentName: '',
    responsibleCenter: '',
    amount: 0,
    sourceDocument: { documentNo: applicationCode, erpEntity: 'Leave Requisition' },
    createdAt: fieldText(row, ['ApplicationDate', 'Application_Date'], new Date().toISOString()),
    submittedAt: fieldText(row, ['ApplicationDate', 'Application_Date'], ''),
    approverEmployeeNo: primaryApprover?.actorEmployeeNo ?? '',
    approverName: primaryApprover?.actorName ?? '',
    payload: {
      ...row,
      ApplicationCode: applicationCode,
      LeaveType: fieldText(row, ['LeaveType', 'Leave_Type']),
      DaysApplied: fieldText(row, ['DaysApplied', 'Days_Applied']),
      StartDate: fieldText(row, ['StartDate', 'Start_Date']),
      EndDate: fieldText(row, ['EndDate', 'End_Date']),
      ReturnDate: fieldText(row, ['ReturnDate', 'Return_Date']),
      RelieverName: fieldText(row, ['RelieverName', 'Reliever_Name']),
      Reason: fieldText(row, ['Reasonforleave', 'Reason_for_leave', 'Reason', 'reason']),
    },
    approvalSteps,
    attachments: mapLeaveAttachmentsSimple(attachments),
  }
}

/** Business Central SOAP dates must use yyyy-mm-dd (locale-neutral). */
export function isErpWorkingDate(value: string) {
  const formatted = formatBcSoapDate(value)
  if (!formatted) return false
  const now = new Date()
  const localToday = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
  const utcToday = now.toISOString().slice(0, 10)
  // Accept the local OR the UTC calendar day. A claim raised near midnight — or a date
  // serialised as an ISO/UTC timestamp (formatBcSoapDate slices the UTC day) — must not be
  // rejected just because the portal server and Business Central sit in different time zones.
  return formatted === localToday || formatted === utcToday
}

export function formatBcSoapDate(value: string) {
  const trimmed = value.trim()
  if (!trimmed) return ''

  const isoDash = /^(\d{4})-(\d{2})-(\d{2})/.exec(trimmed)
  if (isoDash) return `${isoDash[1]}-${isoDash[2]}-${isoDash[3]}`

  const normalized = trimmed.replaceAll('_', '/')
  const mdY = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(normalized)
  if (mdY) {
    const [, month, day, year] = mdY
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }

  const mdYShort = /^(\d{1,2})\/(\d{1,2})\/(\d{2})$/.exec(normalized)
  if (mdYShort) {
    const [, month, day, shortYear] = mdYShort
    const year = Number(shortYear) >= 70 ? 1900 + Number(shortYear) : 2000 + Number(shortYear)
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }

  const ymdSlash = /^(\d{4})\/(\d{1,2})\/(\d{1,2})$/.exec(normalized)
  if (ymdSlash) {
    const [, year, month, day] = ymdSlash
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }

  const parsed = new Date(normalized)
  if (!Number.isNaN(parsed.getTime())) {
    const year = parsed.getFullYear()
    const month = String(parsed.getMonth() + 1).padStart(2, '0')
    const day = String(parsed.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }

  return normalized
}

export function normalizeLeaveStartDate(value: string) {
  return formatBcSoapDate(value)
}

export function parseLeaveDatesReturn(rawValue: unknown) {
  const raw = String(rawValue ?? '').trim()
  let endDate = ''
  let returnDate = ''
  if (!raw) return { endDate, returnDate }
  for (const segment of raw.split('#')) {
    const eq = segment.indexOf('=')
    if (eq < 0) continue
    const key = segment.slice(0, eq).trim().toLowerCase()
    const value = segment.slice(eq + 1).trim()
    if (key === 'enddate') endDate = value
    if (key === 'returndate') returnDate = value
  }
  if (endDate) return { endDate, returnDate }

  // Some BC builds return a single date string instead of key=value pairs.
  if (/^\d{1,2}\/\d{1,2}\/\d{2,4}$/.test(raw) || /^\d{4}-\d{2}-\d{2}/.test(raw)) {
    return { endDate: raw, returnDate: '' }
  }

  return { endDate, returnDate }
}

function parseIsoDateParts(iso: string) {
  const match = /^(\d{4})-(\d{2})-(\d{2})/.exec(iso.trim())
  if (!match) return null
  return { year: Number(match[1]), month: Number(match[2]), day: Number(match[3]) }
}

function toIsoDate(year: number, month: number, day: number) {
  return `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`
}

function addCalendarDays(iso: string, days: number) {
  const parts = parseIsoDateParts(iso)
  if (!parts) return iso
  const date = new Date(Date.UTC(parts.year, parts.month - 1, parts.day))
  date.setUTCDate(date.getUTCDate() + days)
  return toIsoDate(date.getUTCFullYear(), date.getUTCMonth() + 1, date.getUTCDate())
}

function localCalendarDate(now = new Date()) {
  return toIsoDate(now.getFullYear(), now.getMonth() + 1, now.getDate())
}

export function sickLeaveStartDateAllowed(startDate: string, now = new Date()) {
  const start = formatBcSoapDate(startDate)
  if (!start) return false
  const today = localCalendarDate(now)
  const tomorrow = addCalendarDays(today, 1)
  return start >= today && start <= tomorrow
}

function isWeekendIso(iso: string) {
  const parts = parseIsoDateParts(iso)
  if (!parts) return false
  const date = new Date(Date.UTC(parts.year, parts.month - 1, parts.day))
  const dow = date.getUTCDay()
  return dow === 0 || dow === 6
}

function nextWorkingDayIso(iso: string) {
  let cursor = addCalendarDays(iso, 1)
  let guard = 0
  while (isWeekendIso(cursor) && guard < 14) {
    cursor = addCalendarDays(cursor, 1)
    guard += 1
  }
  return cursor
}

/**
 * Safe local fallback when BC GetLeaveDates is temporarily unavailable.
 * ABH leave starts on a working day and ordinary leave does not consume
 * Saturday/Sunday. Business Central remains authoritative for configured
 * holidays and leave types that explicitly include non-working days.
 */
export function computeLeaveDatesFallback(startDate: string, noOfDays: number, halfDay: string) {
  const start = formatBcSoapDate(startDate)
  if (!start) return { endDate: '', returnDate: '' }

  const half = halfDayOptionValue(halfDay)
  if (half === 1 || half === 2 || noOfDays <= 0.5) {
    return {
      endDate: start,
      returnDate: nextWorkingDayIso(start),
    }
  }

  let remaining = Math.max(1, Math.ceil(noOfDays)) - 1
  let endDate = start
  while (remaining > 0) {
    endDate = nextWorkingDayIso(endDate)
    remaining -= 1
  }
  return {
    endDate,
    returnDate: nextWorkingDayIso(endDate),
  }
}

async function resolveLeaveDatesFromBc(
  user: ReturnType<typeof authUser>,
  leaveType: string,
  noOfDays: number,
  startDate: string,
  halfDay: string,
) {
  const start = normalizeLeaveStartDate(startDate)
  const half = halfDayOptionValue(halfDay)
  const productionDates = computeLeaveDatesFallback(start, noOfDays, halfDay)
  const attempts: Array<Record<string, unknown>> = [
    {
      empNo: user.employeeNo,
      leaveType,
      noOfDays,
      startDate: start,
      whetherIsHalfDay: half,
    },
  ]

  if (half !== 0) {
    // Some BC builds accept a Boolean half-day flag instead of 0/1/2.
    attempts.push({
      empNo: user.employeeNo,
      leaveType,
      noOfDays,
      startDate: start,
      whetherIsHalfDay: isHalfDaySelection(halfDay),
    })
    if (noOfDays < 1) {
      attempts.push({
        empNo: user.employeeNo,
        leaveType,
        noOfDays: 1,
        startDate: start,
        whetherIsHalfDay: half,
      })
    }
  }

  for (const params of attempts) {
    try {
      const result = await callSoapMethod('GetLeaveDates', params)
      const parsed = parseLeaveDatesReturn(result.returnValue)
      if (parsed.endDate) {
        const end = formatBcSoapDate(parsed.endDate) || parsed.endDate
        const ret =
          formatBcSoapDate(parsed.returnDate) ||
          parsed.returnDate ||
          addCalendarDays(end, 1)
        // BC owns leave-type weekend/holiday policy. Do not replace its working-
        // day result with a portal calendar-day calculation.
        return { endDate: end, returnDate: ret, source: 'bc' as const }
      }
    } catch {
      // Try the next BC parameter strategy.
    }
  }

  return { ...productionDates, source: 'fallback' as const }
}

export function overlappingLeaveApplication(
  rows: ODataRecord[],
  requestedStartDate: string,
  requestedEndDate: string,
  excludedApplicationNo = '',
) {
  const requestedStart = formatBcSoapDate(requestedStartDate)
  const requestedEnd = formatBcSoapDate(requestedEndDate)
  if (!requestedStart || !requestedEnd) return null

  for (const row of rows) {
    const applicationNo = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])
    if (
      excludedApplicationNo &&
      applicationNo.trim().toUpperCase() === excludedApplicationNo.trim().toUpperCase()
    ) {
      continue
    }
    const status = resolveLeaveStatus(row)
    if (['Rejected', 'Cancelled'].includes(status)) continue

    const startDate = formatBcSoapDate(fieldText(row, ['StartDate', 'Start_Date']))
    const endDate =
      formatBcSoapDate(fieldText(row, ['EndDate', 'End_Date'])) || startDate
    if (!startDate || !endDate) continue
    if (requestedStart <= endDate && requestedEnd >= startDate) {
      return { applicationNo, startDate, endDate, status }
    }
  }
  return null
}

async function employeeLeaveRowsForValidation(user: ReturnType<typeof authUser>) {
  const filters = [
    `EmployeeNo eq '${odataString(user.employeeNo)}'`,
    `UserID eq '${odataString(user.userID)}'`,
  ]
  const collected = new Map<string, ODataRecord>()
  let successfulLookup = false
  for (const filter of filters) {
    try {
      const rows = (await fetchOData('QyHRLeaveApplications', {
        $filter: filter,
        $top: 500,
      })) as ODataRecord[] | null
      successfulLookup = true
      for (const row of Array.isArray(rows) ? rows : []) {
        const no = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])
        if (no) collected.set(no, row)
      }
    } catch {
      // Try the other ownership field. If both fail, validation fails closed.
    }
  }
  if (!successfulLookup) {
    throw Object.assign(
      new Error('Existing leave dates could not be verified in Business Central. Please try again.'),
      { status: 503, code: 'LEAVE_OVERLAP_CHECK_UNAVAILABLE' },
    )
  }
  return [...collected.values()]
}

async function assertNoOverlappingLeaveApplication(
  user: ReturnType<typeof authUser>,
  requestedStartDate: string,
  requestedEndDate: string,
  excludedApplicationNo = '',
) {
  const conflict = overlappingLeaveApplication(
    await employeeLeaveRowsForValidation(user),
    requestedStartDate,
    requestedEndDate,
    excludedApplicationNo,
  )
  if (!conflict) return
  throw Object.assign(
    new Error(
      `These dates overlap leave application ${conflict.applicationNo} (${conflict.startDate} to ${conflict.endDate}, ${conflict.status}). Delete or change the existing draft, or choose different dates.`,
    ),
    { status: 409, code: 'LEAVE_DATE_OVERLAP' },
  )
}

/* -------------------------------------------------------------------------- */
/* Approvals — table-id catalog                                               */
/* -------------------------------------------------------------------------- */

/**
 * Approval table-id mapping. Mirrors the values hard-coded in the Laravel
 * Staff models (see `App\Models\*::tableDesc()`), and is used by the count /
 * detail endpoints to fan out across the right BC entity.
 */
const APPROVAL_COUNT_KEYS = {
  leave: 'leave',
  imprest: 'imprest',
  imprestSurr: 'imprestSurrender',
  store: 'storeRequisition',
  purchase: 'purchaseRequisition',
  claim: 'staffClaim',
  paymentVoucher: 'paymentVoucher',
  pettyCash: 'pettyCash',
  pettyCashReplenishment: 'pettyCashReplenishment',
  fuel: 'fuel',
  gatePass: 'gatePass',
  transferOrder: 'transferOrder',
  salaryAdvance: 'salaryAdvance',
  order: 'purchaseOrder',
} as const satisfies Record<string, ApprovalTableKey>

type ApprovalCountKey = keyof typeof APPROVAL_COUNT_KEYS

const COUNT_KEY_LABELS: Record<ApprovalCountKey, string> = {
  leave: 'totalLeave',
  imprest: 'totalImprest',
  imprestSurr: 'totalImprestSurr',
  store: 'totalStore',
  purchase: 'totalPurchase',
  claim: 'totalClaim',
  paymentVoucher: 'totalPv',
  pettyCash: 'totalPc',
  pettyCashReplenishment: 'totalPcReplenishment',
  fuel: 'totalFuel',
  gatePass: 'totalGatePass',
  transferOrder: 'totalTransferOrder',
  salaryAdvance: 'totalSalaryAdvance',
  order: 'totalOrder',
}

/* -------------------------------------------------------------------------- */
/* Router                                                                     */
/* -------------------------------------------------------------------------- */

export function buildStaffRouter() {
  const router = Router()

  // Every staff route requires an authenticated session.
  router.use(requireAuth)

  /* ------------------------------ Dashboard ------------------------------ */

  router.get(
    '/dashboard/statistics',
    safe(async (req, res) => {
      const user = authUser(req)
      const { start, end } = yearWindow()
      const dueDateRange = `DueDate gt ${start} and DueDate lt ${end}`

      const baseApproval = (status: string) =>
        `Status eq '${odataString(status)}' and ApproverID eq '${odataString(user.userID)}' and (${dueDateRange})`

      const [
        totalPendingApproval,
        totalApproved,
        totalRejected,
        totalLeaveReqs,
        totalImprestReqs,
        totalImprestSurrenderReqs,
        totalPurchaseReqs,
        totalStoreReqs,
        totalClaims,
      ] = await Promise.all([
        fetchODataCount('QyApprovalEntry', { $filter: baseApproval('Open') }),
        fetchODataCount('QyApprovalEntry', { $filter: baseApproval('Approved') }),
        fetchODataCount('QyApprovalEntry', { $filter: baseApproval('Rejected') }),
        fetchODataCount('QyHRLeaveApplications', {
          $filter: `UserID eq '${odataString(user.userID)}' and (StartDate gt ${start} and StartDate lt ${end})`,
        }),
        fetchODataCount('QyImprestHeader', {
          $filter: `EmployeeNo eq '${odataString(user.employeeNo)}' and (Date gt ${start} and Date lt ${end})`,
        }),
        fetchODataCount('QyImprestSurrenderHeader', {
          $filter: `UserID eq '${odataString(user.userID)}' and (SurrenderDate gt ${start} and SurrenderDate lt ${end})`,
        }),
        fetchODataCount('QyPurchaseHeader', {
          $filter: `AssignedUserID eq '${odataString(user.userID)}' and (DocumentDate gt ${start} and DocumentDate lt ${end})`,
        }),
        fetchODataCount('QyStoreRequisitionHeader', {
          $filter: `UserID eq '${odataString(user.userID)}' and (Requestdate gt ${start} and Requestdate lt ${end})`,
        }),
        fetchODataCount('QyStaffClaimHeader', {
          $filter: `EmployeeNo eq '${odataString(user.employeeNo)}' and (Date gt ${start} and Date lt ${end})`,
        }),
      ])

      res.json({
        totalPendingApproval,
        totalApproved,
        totalRejected,
        totalLeaveReqs,
        totalImprestReqs,
        totalImprestSurrenderReqs,
        totalPurchaseReqs,
        totalStoreReqs,
        totalTransportReqs: 0,
        totalClaims,
      })
    }),
  )

  /* ------------------------------ Approvals ------------------------------ */

  router.get(
    '/approvals',
    safe(async (req, res) => {
      const user = authUser(req)
      const status = typeof req.query.status === 'string' ? req.query.status : 'Open'
      const docType = typeof req.query.docType === 'string' ? req.query.docType : ''
      const skip = Number(req.query.skip ?? 0) || 0

      const filterParts = [
        `Status eq '${odataString(status)}'`,
        `ApproverID eq '${odataString(user.userID)}'`,
      ]
      if (docType) filterParts.push(`DocumentType eq '${odataString(docType)}'`)

      const rows = (await fetchOData('QyApprovalEntry', {
        $filter: filterParts.join(' and '),
        $top: 30,
        $skip: skip,
      })) as ODataRecord[]

      res.json({ rows: Array.isArray(rows) ? rows : [], status })
    }),
  )

  router.get(
    '/approvals/count/:type/:status',
    safe(async (req, res) => {
      const user = authUser(req)
      const { type, status } = req.params
      const { start, end } = yearWindow()
      const dueDate = `(DueDate gt ${start} and DueDate lt ${end})`
      const baseFilter = (extra = '') =>
        `Status eq '${odataString(status)}' and ApproverID eq '${odataString(user.userID)}' and ${dueDate}${extra ? ` and ${extra}` : ''}`

      const data: Record<string, unknown> = {}

      if (type === 'all' || type === 'Pending') {
        data.totalAll = await fetchODataCount('QyApprovalEntry', { $filter: baseFilter() })
      }

      const requestedKeys: ApprovalCountKey[] =
        type === 'all'
          ? (Object.keys(APPROVAL_COUNT_KEYS) as ApprovalCountKey[])
          : Object.keys(APPROVAL_COUNT_KEYS).includes(type as ApprovalCountKey)
            ? [type as ApprovalCountKey]
            : []

      const counts = await Promise.all(
        requestedKeys.map((key) =>
          fetchODataCount('QyApprovalEntry', {
            $filter: baseFilter(approvalTableFilter(APPROVAL_COUNT_KEYS[key])),
          }),
        ),
      )
      requestedKeys.forEach((key, index) => {
        data[COUNT_KEY_LABELS[key]] = counts[index]
      })

      // Transport requisition is intentionally always 0 (matches ESS behaviour).
      if (type === 'all' || type === 'transport') data.totalTransport = 0

      if (status === 'Open') {
        data.isNotified = user.isNotified
        // Mark notified for the rest of this session, like Laravel does.
        if (req.session.authUser) req.session.authUser.isNotified = true
      }

      res.json(data)
    }),
  )

  router.get(
    '/approvals/:docNo',
    safe(async (req, res) => {
      const user = authUser(req)
      const docNo = String(req.params.docNo ?? '')
      const document = await fetchOData('QyApprovalEntry', {
        $filter: `DocumentNo eq '${odataString(docNo)}' and ApproverID eq '${odataString(user.userID)}'`,
        $top: 1,
      })
      const first = Array.isArray(document) && document.length > 0 ? document[0]! : null

      // Approver chain for the document — same as ApprovalsController::getApprovers().
      const approvers = first
        ? await fetchOData('QyApprovalEntry', {
            $filter: `DocumentNo eq '${odataString(docNo)}'`,
          })
        : []

      let requisition: ODataRecord | null = null
      let lines: ODataRecord[] = []
      if (first) {
        const module = await resolveApprovalModuleFromEntry(first, docNo, approvalModuleFromEntry)
        const spec = findFrontendModuleSpec(module)
        if (spec) {
          requisition = await getPortalModuleDocument(spec, user, docNo, false)
          if (requisition) {
            lines = await listPortalModuleLines(spec, requisition, docNo)
          }
        }
      }

      res.json({
        document: first,
        approvers,
        requisition,
        lines: Array.isArray(lines) ? lines : [],
      })
    }),
  )

  router.post(
    '/approvals/decide',
    safe(async (req, res) => {
      const user = authUser(req)
      const body = z
        .object({
          docNo: z.string().min(1),
          decision: z.enum(['Approved', 'Rejected']).optional(),
          isApprove: z.union([z.boolean(), z.string()]).optional(),
          comment: z.string().optional().default(''),
          comments: z.string().optional().default(''),
          entryNo: z.union([z.string(), z.number()]).optional().default(''),
        })
        .parse(req.body)

      const isApprove =
        body.decision !== undefined
          ? body.decision === 'Approved'
          : typeof body.isApprove === 'boolean'
            ? body.isApprove
            : String(body.isApprove ?? '').toLowerCase() === 'true'

      const decisionComment = (body.comment || body.comments || '').trim()
      if (!isApprove && decisionComment.length < 3) {
        res.status(422).json({
          message: 'A rejection reason of at least 3 characters is required.',
          code: 'APPROVAL_REASON_REQUIRED',
        })
        return
      }

      const result = await callSoapMethod('DocumentApproval', {
        entryNo: body.entryNo,
        docNo: body.docNo,
        userID: user.userID,
        isApprove,
        comments: decisionComment,
      })

      const ok = soapTruthy(result.returnValue)
      res.json({
        ok,
        message: ok
          ? `Document ${body.docNo} has been ${(body.decision ?? (isApprove ? 'Approved' : 'Rejected')).toLowerCase()}`
          : 'The approval action did not complete. Please try again.',
        returnValue: result.returnValue,
      })
    }),
  )

  /* -------------------------------- Leave -------------------------------- */

  router.get(
    '/leave',
    safe(async (req, res) => {
      const user = authUser(req)
      const { start, end } = yearWindow()
      const filters = [
        `UserID eq '${odataString(user.userID)}' and (ApplicationDate gt ${start} and ApplicationDate lt ${end})`,
        `EmployeeNo eq '${odataString(user.employeeNo)}' and (ApplicationDate gt ${start} and ApplicationDate lt ${end})`,
      ]
      const collected = new Map<string, ODataRecord>()
      for (const filter of filters) {
        const rows = (await fetchOData('QyHRLeaveApplications', {
          $filter: filter,
          $top: 100,
        }).catch(() => [])) as ODataRecord[] | null
        for (const row of Array.isArray(rows) ? rows : []) {
          const code = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])
          if (!code) continue
          collected.set(code, row)
        }
      }
      const list = sortNewestFirst([...collected.values()])
      const [approvalsByDoc, senderEntries] = await Promise.all([
        fetchLeaveApprovalEntriesByDocumentNos(
          list.map((row) => fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])),
        ),
        fetchLeaveApprovalEntriesForSender(user),
      ])
      const senderIndex = indexLeaveApprovalEntriesByNo(senderEntries)
      const leaveDebug = config.LOG_LEAVE_STATUS
      if (leaveDebug) {
        logDiagnostic(
          `[leave-list] user=${logSafe(user.userID)} leaves=${list.length} senderEntries=${senderEntries.length}`,
        )
      }
      res.json({
        rows: list.map((row) => {
          const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])
          const docEntries = leaveApprovalEntriesForDocument(approvalsByDoc, applicationCode)
          const senderMatches = senderIndex.get(normalizedLeaveKey(applicationCode)) ?? []
          const approvalEntries = dedupeApprovalEntryList(docEntries, senderMatches)
          const status = resolveLeaveStatus(row, approvalEntries)
          if (leaveDebug) {
            logDiagnostic(
              `[leave-list]   ${logSafe(applicationCode)} status=${status} byDoc=${docEntries.length} bySender=${senderMatches.length} hdrStatus=${logSafe(row.Status ?? row.ApprovalStatus ?? '')}`,
            )
          }
          return {
            ApplicationCode: applicationCode,
            LeaveType: String(row.LeaveType ?? row.Leave_Type ?? ''),
            LeaveTypeCode: String(row.LeaveTypeCode ?? row.Leave_Type_Code ?? row.LeaveType ?? ''),
            ApplicationDate: String(row.ApplicationDate ?? row.Application_Date ?? ''),
            DaysApplied:
              Number(row.DaysApplied ?? row.Days_Applied ?? row.NoofDays ?? row.No_of_Days ?? 0) ||
              undefined,
            StartDate: String(row.StartDate ?? row.Start_Date ?? ''),
            EndDate: String(row.EndDate ?? row.End_Date ?? ''),
            ReturnDate: String(row.ReturnDate ?? row.Return_Date ?? ''),
            RelieverName: String(row.RelieverName ?? row.Reliever_Name ?? ''),
            Status: status,
          }
        }),
      })
    }),
  )

  router.get(
    '/leave/types',
    safe(async (req, res) => {
      const user = authUser(req)
      const [rows, employeeRow] = await Promise.all([
        fetchOData('QyHRLeaveType'),
        fetchCurrentEmployeeRow(user.employeeNo),
      ])
      const eligibility = await employeeLeaveEligibility(user.employeeNo, employeeRow)
      const metrics = employeeLeaveMetrics(employeeRow, user)
      const userGender = normalizeAuthGender(eligibility.gender || user.Gender || user.gender)
      const maritalStatus = eligibility.maritalStatus
      let mappedRows = (Array.isArray(rows) ? rows : [])
        .filter((row) => leaveTypeMatchesGender(row, userGender))
        .filter((row) => leaveTypeMatchesMaritalStatus(row, maritalStatus))
        .map((row) => {
          const annual = leaveTypeIsAnnual(row)
          const genericDays = Number(row.Days ?? row.NoofDays ?? 0)
          const description = String(row.Description ?? row.description ?? '')
          const code = String(row.Code ?? row.code ?? '')
          const requiresFamilyMember =
            fieldBoolean(row, ['RequiresFamilyMember', 'Requires_Family_Member']) ??
            /mourn|bereav|funeral|compassionate/i.test(`${description} ${code}`)
          const requiresMedicalAttachment =
            fieldBoolean(row, ['RequiresMedicalAttachment', 'Requires_Medical_Attachment']) ??
            /sick|medical|illness|hospital/i.test(`${description} ${code}`)
          const requiresDeliveryDate =
            fieldBoolean(row, ['Maternity', 'Maternity?', 'Maternity_']) ??
            /matern|prenatal|pre-natal|pre natal/i.test(`${description} ${code}`)
          const requiresWeddingAttachment =
            fieldBoolean(row, ['RequiresWeddingAttachment', 'Requires_Wedding_Attachment']) ??
            /wedding|marriage/i.test(`${description} ${code}`)
          return {
            ...row,
            Hourly: Boolean(row.Hourly ?? row.Allow_Hourly ?? false),
            UnlimitedDays: fieldBoolean(row, ['UnlimitedDays', 'Unlimited_Days']) ?? false,
            RequiresDeliveryDate: requiresDeliveryDate,
            RequiresWeddingAttachment: requiresWeddingAttachment,
            MaximumApplicationDays: fieldNumber(row, [
              'MaximumApplicationDays',
              'Maximum_Application_Days',
              'MaxApplicationDays',
              'Max_Application_Days',
            ]),
            RequiresMedicalAttachment: requiresMedicalAttachment,
            RequiresFamilyMember: requiresFamilyMember,
            Days: roundLeaveValue(
              annual ? resolveAnnualLeaveEntitlement(metrics, genericDays) : genericDays,
            ),
            Annual: annual,
          }
        })

      if (mappedRows.length === 0) {
        try {
          const apps = (await fetchOData('QyHRLeaveApplication', {
            $filter: `EmployeeNo eq '${odataString(user.employeeNo)}'`,
            $top: 100,
          })) as ODataRecord[] | null
          const seen = new Set<string>()
          mappedRows = (Array.isArray(apps) ? apps : [])
            .map((row) => {
              const code = String(
                row.LeaveTypeCode ??
                  row.Leave_Type_Code ??
                  row.LeaveType ??
                  row.Leave_Type ??
                  '',
              ).trim()
              if (!code || seen.has(code.toUpperCase())) return null
              seen.add(code.toUpperCase())
              const description = String(row.LeaveType ?? row.Leave_Type ?? code)
              return {
                Code: code,
                Description: description,
                Days: 0,
                Hourly: false,
                UnlimitedDays: false,
                RequiresDeliveryDate: /matern|prenatal/i.test(`${description} ${code}`),
                RequiresWeddingAttachment: /wedding|marriage/i.test(`${description} ${code}`),
                MaximumApplicationDays: null,
                RequiresMedicalAttachment: /sick|medical|illness|hospital/i.test(`${description} ${code}`),
                RequiresFamilyMember: /mourn|bereav|funeral|compassionate/i.test(`${description} ${code}`),
                Annual: /annual/i.test(`${description} ${code}`),
              }
            })
            .filter(Boolean)
            .filter((row) => leaveTypeMatchesGender(row as ODataRecord, userGender))
            .filter((row) => leaveTypeMatchesMaritalStatus(row as ODataRecord, maritalStatus)) as typeof mappedRows
        } catch {
          // keep empty
        }
      }

      res.json({ rows: mappedRows })
    }),
  )

  router.get(
    '/leave/approval-route',
    safe(async (req, res) => {
      const user = authUser(req)
      const steps = await resolveLeaveApprovalRouteAsync([], {
        employeeNo: user.employeeNo,
        userID: user.userID,
        department: user.department,
      })
      res.json({ steps })
    }),
  )

  router.get(
    '/leave/relievers',
    safe(async (req, res) => {
      const user = authUser(req)
      const rows = await fetchRelieverRows(user.employeeNo)
      res.json({ rows })
    }),
  )

  router.get(
    '/leave/balance/:type',
    safe(async (req, res) => {
      const user = authUser(req)
      const leaveTypeCode = String(req.params.type ?? '')
      const today = new Date().toISOString().slice(0, 10)
      const currentPeriod = new Date().getFullYear()

      const [typeRows, pendingCount, ledgerRows, employeeRow, applicationRows, soapEmployeeBalances, summarySoap] = await Promise.all([
        fetchOData('QyHRLeaveType', {
          $filter: `Code eq '${odataString(leaveTypeCode)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
        (fetchOData('QyHRLeaveApplications', {
          $filter: `Status eq 'Pending Approval' and EmployeeNo eq '${odataString(user.employeeNo)}' and LeaveType eq '${odataString(leaveTypeCode)}' and EndDate gt ${today}`,
        }) as Promise<ODataRecord[] | null>)
          .then((rows) => (Array.isArray(rows) ? rows : []).filter((row) => resolveLeaveStatus(row) === 'Pending Approval').length)
          .catch(() => 0),
        fetchOData('QyHRLeaveLedger', {
          $filter: `EmployeeNo eq '${odataString(user.employeeNo)}' and LeaveType eq '${odataString(leaveTypeCode)}'`,
        }) as Promise<ODataRecord[] | null>,
        fetchCurrentEmployeeRow(user.employeeNo),
        fetchLeaveApplicationBalanceRows(user.employeeNo, leaveTypeCode),
        callSoapMethod('FnGetEmployeeLeaveBalances', { employeeNo: user.employeeNo }).catch(() => null),
        callSoapMethod('GetLeaveBalance', {
          employeeNo: user.employeeNo,
          leaveType: leaveTypeCode,
        }).catch(() => null),
      ])

      const leaveTypeRow = Array.isArray(typeRows) && typeRows.length > 0 ? typeRows[0]! : null
      if (!leaveTypeRow) {
        res.status(404).json({ message: 'The selected leave type was not found in Business Central.' })
        return
      }
      const leaveTypeDays = Number(leaveTypeRow.Days ?? leaveTypeRow.NoofDays ?? 0)
      const unlimitedDays = fieldBoolean(leaveTypeRow, ['UnlimitedDays', 'Unlimited_Days']) ?? false
      const maximumApplicationDays = fieldNumber(leaveTypeRow, [
        'MaximumApplicationDays',
        'Maximum_Application_Days',
        'MaxApplicationDays',
        'Max_Application_Days',
      ])
      const isHourly = Boolean(leaveTypeRow?.Allow_Hourly ?? leaveTypeRow?.Hourly ?? false)
      const isAnnual = leaveTypeIsAnnual(leaveTypeRow)
      const parsedSoapBalances = parseEmployeeLeaveBalancesReturn(soapEmployeeBalances?.returnValue)
      // Legacy SOAP sets LeaveBalance=AnnualLeaveBalance and EarnedLeaveDays=Accrued Days.
      // Only merge Annual from SOAP; leave Accrued/CF/LeaveBalance to the employee OData row
      // (and GetLeaveBalance JSON below) so earned days stay Leave Accrued To-Date.
      const metricsSource: ODataRecord = { ...(employeeRow ?? {}) }
      if (parsedSoapBalances) {
        for (const key of [
          'AnnualLeaveBalance',
          'Annual_Leave_Balance',
          'Annual_Leave_balance',
          'AccruedDays',
          'CarryForwardBalance',
          'Carry_forward_Balance',
        ] as const) {
          if (parsedSoapBalances[key] !== undefined) metricsSource[key] = parsedSoapBalances[key]
        }
      }
      const metrics = employeeLeaveMetrics(metricsSource, user)

      let additions = 0
      let deductions = 0
      let openNet = 0
      let currentPeriodNet = 0
      let hasOpenEntries = false
      let hasCurrentPeriodEntries = false
      if (Array.isArray(ledgerRows)) {
        for (const entry of ledgerRows) {
          const noOfDays = Number(entry?.NoofDays ?? entry?.['No_of_Days'] ?? 0)
          if (Number.isFinite(noOfDays)) {
            if (noOfDays < 0) deductions += -noOfDays
            else additions += noOfDays
            const closed = entry.Closed === true || String(entry.Closed ?? '').toLowerCase() === 'true'
            if (!closed) {
              hasOpenEntries = true
              openNet += noOfDays
              if (Number(entry.LeavePeriod ?? entry.Leave_Period) === currentPeriod) {
                hasCurrentPeriodEntries = true
                currentPeriodNet += noOfDays
              }
            }
          }
        }
      }

      const applicationBalance = applicationRows
        .map((row) => fieldNumber(row, ['CurrentLeaveBalance', 'Current_Leave_Balance']))
        .find((value): value is number => value !== null)
      const exactSummary = parseBcLeaveSummary(summarySoap?.returnValue)
      const cardAnnualBalance =
        employeeAnnualLeaveBalance(employeeRow) ??
        metrics.leaveBalance ??
        (isAnnual ? applicationBalance ?? null : null)
      const earnedLeaveDays = isAnnual
        ? exactSummary?.leaveAccruedToDate ?? metrics.earnedLeaveDays
        : null
      const ledgerNet = additions - deductions
      const entitlement = roundLeaveValue(
        exactSummary?.leaveEntitlement ??
          exactSummary?.allocatedDays ??
          (isAnnual ? resolveAnnualLeaveEntitlement(metrics, leaveTypeDays) : leaveTypeDays),
      )
      const carryForwardBalance = isAnnual
        ? exactSummary?.carryForward ??
          exactSummary?.carryForwardBalanceForType ??
          metrics.carryForwardBalance ??
          null
        : exactSummary?.carryForwardBalanceForType ?? null
      const totalLeaveTakenToDate =
        exactSummary?.totalLeaveTakenToDate ??
        exactSummary?.currentTotalLeaveTaken ??
        roundLeaveValue(deductions)
      const leaveAccruedToDate = isAnnual
        ? exactSummary?.leaveAccruedToDate ?? earnedLeaveDays
        : null
      const balance = roundLeaveValue(resolveBcLeaveBalance({
        isAnnual,
        leaveTypeDays,
        leaveTypeUnlimitedDays: unlimitedDays,
        maximumApplicationDays,
        summary: exactSummary,
        cardAnnualBalance,
        leaveAccruedToDate,
        totalLeaveTakenToDate,
        hasCurrentPeriodEntries,
        currentPeriodNet,
        hasOpenEntries,
        openNet,
        ledgerNetDays: ledgerNet,
      }))
      const breakdown = resolveLeaveBalanceBreakdown({
        summary: exactSummary,
        entitlement,
        carryForward: carryForwardBalance,
        leaveAccruedToDate,
        totalLeaveTakenToDate,
        availableLeaveBalance: balance,
      })
      const balanceSource = isAnnual
        ? exactSummary?.availableLeaveBalance !== null &&
          exactSummary?.availableLeaveBalance !== undefined
          ? 'employeeCardAvailable'
          : leaveAccruedToDate !== null
            ? 'employeeCardAccruedLimit'
            : 'unavailable'
        : (exactSummary?.availableLeaveBalance !== null &&
              exactSummary?.availableLeaveBalance !== undefined) ||
            (exactSummary?.currentLeaveBalance !== null &&
              exactSummary?.currentLeaveBalance !== undefined)
          ? 'leaveLedger'
          : 'leaveTypeSetup'

      res.json({
        // Canonical six employee-facing values. These names are intentionally
        // explicit so Total Available can never be mistaken for the balance
        // against which a leave application is validated.
        ...breakdown,
        // Backward-compatible aliases used by older portal builds.
        balance: breakdown.availableLeaveBalance,
        entitlement: breakdown.leaveEntitlement,
        allocatedDays: breakdown.leaveEntitlement,
        currentLeaveBalance: breakdown.availableLeaveBalance,
        earnedLeaveDays: breakdown.leaveAccruedToDate,
        carryForwardBalance: breakdown.carryForward,
        balanceSource,
        isAnnual,
        unlimitedDays: exactSummary?.unlimitedDays ?? unlimitedDays,
        maximumApplicationDays:
          exactSummary?.maximumApplicationDays ?? maximumApplicationDays,
        applicationLimit: breakdown.availableLeaveBalance,
        pendingCount,
        isHourly,
      })
    }),
  )

  router.get(
    '/leave/dates/:type/:days/:startDate/:halfDay',
    safe(async (req, res) => {
      const user = authUser(req)
      const type = String(req.params.type ?? '')
      const days = Number(String(req.params.days ?? ''))
      const startDate = String(req.params.startDate ?? '')
      const halfDay = String(req.params.halfDay ?? '0')
      const start = normalizeLeaveStartDate(startDate)

      const startAsDate = new Date(`${formatBcSoapDate(startDate)}T12:00:00`)
      const day = startAsDate.getDay()
      const isWeekend = !Number.isNaN(startAsDate.getTime()) && (day === 0 || day === 6)

      if (!type || !start || !Number.isFinite(days) || days <= 0) {
        res.status(422).json({
          endDate: '',
          returnDate: '',
          isWeekend,
          message: 'Start date and applied days are required to calculate leave dates.',
        })
        return
      }

      const resolved = await resolveLeaveDatesFromBc(user, type, days, start, halfDay)

      if (!resolved.endDate) {
        res.status(422).json({
          endDate: '',
          returnDate: '',
          isWeekend,
          message:
            'Could not calculate leave dates. Verify the start date, applied days, and leave balance.',
        })
        return
      }

      res.json({
        endDate: resolved.endDate,
        returnDate: resolved.returnDate,
        isWeekend,
      })
    }),
  )

  router.get(
    '/leave/schedule',
    safe(async (req, res) => {
      const user = authUser(req)
      const scope = typeof req.query.scope === 'string' ? req.query.scope : 'self'
      const rows = await fetchLeaveScheduleRows(user, scope === 'self' ? 'self' : 'department')
      res.json({ rows })
    }),
  )

  router.get(
    '/leave/request/:no',
    safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '').trim()
      const row = await fetchOwnedLeaveRow(user, no)
      if (!row) {
        res.status(404).json({ message: 'Leave application not found' })
        return
      }
      const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'], no)
      const approvalEntries = await loadLeaveApprovalEntries(applicationCode, true, user)
      const attachments = (await fetchOData('QyDocumentAttachments', {
        $filter: `No eq '${odataString(applicationCode)}' and TableID eq 50532`,
      }).catch(() => [])) as ODataRecord[] | null
      res.json(
        await buildLeavePortalDetail(
          row,
          applicationCode,
          user,
          approvalEntries,
          Array.isArray(attachments) ? attachments : [],
        ),
      )
    }),
  )

  // Diagnostic: dump exactly what Business Central returns for one of the
  // caller's own leaves, so pending-approval detection can be verified without
  // guessing. Only ever exposes the current user's data.
  router.get(
    '/leave/:no/debug',
    safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '').trim()
      const row = await fetchOwnedLeaveRow(user, no)
      if (!row) {
        res.status(404).json({ message: 'Leave application not found' })
        return
      }
      const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'], no)
      const candidates = expandLeaveCancelDocumentNos(applicationCode, row)
      const byDoc = leaveApprovalEntriesForDocument(
        await fetchLeaveApprovalEntriesByDocumentNos(candidates),
        applicationCode,
      )
      const senderAll = await fetchLeaveApprovalEntriesForSender(user)
      const senderMatches =
        indexLeaveApprovalEntriesByNo(senderAll).get(normalizedLeaveKey(applicationCode)) ?? []
      const approvalEntries = dedupeApprovalEntryList(byDoc, senderMatches)
      res.json({
        applicationCode,
        normalizedKey: normalizedLeaveKey(applicationCode),
        candidates,
        resolvedStatus: resolveLeaveStatus(row, approvalEntries),
        headerStatusFields: {
          Status: row.Status ?? row.status ?? null,
          ApprovalStatus: row.ApprovalStatus ?? row.Approval_Status ?? null,
          DateTimeSentforApproval:
            row.DateTimeSentforApproval ?? row.Date_Time_Sent_for_Approval ?? null,
          Sent_for_Approval: row.Sent_for_Approval ?? row.SentForApproval ?? null,
        },
        headerKeys: Object.keys(row),
        counts: {
          byDoc: byDoc.length,
          senderAll: senderAll.length,
          senderMatches: senderMatches.length,
        },
        byDocEntries: byDoc,
        senderMatchEntries: senderMatches,
        senderAllSummaries: senderAll.map((entry) => ({
          DocumentNo: entry.DocumentNo ?? entry.Document_No ?? entry.No ?? null,
          TableID: entry.TableID ?? entry.TableId ?? null,
          DocumentType: entry.DocumentType ?? entry.Document_Type ?? null,
          Status: entry.Status ?? null,
          SenderID: entry.SenderID ?? entry.UserID ?? null,
          ApproverID: entry.ApproverID ?? null,
        })),
      })
    }),
  )

  router.post(
    '/leave/:no/attachments',
    safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '').trim()
      if (!no) {
        res.status(422).json({ ok: false, message: 'Leave application number is required.' })
        return
      }

      const row = await fetchOwnedLeaveRow(user, no)
      if (!row) {
        res.status(404).json({ ok: false, message: 'Leave application not found.' })
        return
      }

      const approvalEntries = leaveApprovalEntriesForDocument(
        await fetchLeaveApprovalEntriesByDocumentNos([no]),
        no,
      )
      const status = resolveLeaveStatus(row, approvalEntries)
      if (status !== 'Open' && status !== 'Draft') {
        res.status(422).json({
          ok: false,
          message: 'Attachments cannot be added after the request has been submitted for approval.',
          code: 'ATTACHMENT_LOCKED',
        })
        return
      }

      await uploadPortalAttachment(50532, no, req.body ?? {})
      const attachments = (await fetchOData('QyDocumentAttachments', {
        $filter: `No eq '${odataString(no)}' and TableID eq 50532`,
      }).catch(() => [])) as ODataRecord[] | null

      res.status(201).json({
        ok: true,
        attachments: mapLeaveAttachmentsSimple(Array.isArray(attachments) ? attachments : []),
      })
    }),
  )

  router.get(
    '/leave/:no',
    safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '')

      const row = await fetchOwnedLeaveRow(user, no)
      if (!row) {
        res.status(404).json({ message: 'Leave application not found' })
        return
      }

      const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'], no)
      const [approvers, attachments] = await Promise.all([
        fetchOData('QyApprovalEntry', {
          $filter: `DocumentNo eq '${odataString(applicationCode)}'`,
        }),
        fetchOData('QyDocumentAttachments', {
          $filter: `No eq '${odataString(applicationCode)}' and TableID eq 50532`,
        }).catch(() => []),
      ])

      res.json({ requisition: row, approvers, attachments })
    }),
  )

  router.delete(
    '/leave/:no',
    safe(async (req, res) => {
      const user = authUser(req)
      const no = String(req.params.no ?? '').trim()
      const row = await fetchOwnedLeaveRow(user, no)
      if (!row) {
        res.status(404).json({ ok: false, message: 'Leave application not found.' })
        return
      }
      const approvalEntries = leaveApprovalEntriesForDocument(
        await fetchLeaveApprovalEntriesByDocumentNos(expandLeaveCancelDocumentNos(no, row)),
        no,
      )
      const status = resolveLeaveStatus(row, approvalEntries)
      if (!['Open', 'Draft'].includes(status)) {
        res.status(422).json({
          ok: false,
          code: 'LEAVE_DELETE_NOT_ALLOWED',
          message:
            status === 'Pending Approval'
              ? 'Cancel the pending approval first; then the reopened draft can be deleted.'
              : 'Only an open draft can be permanently deleted. Approved leave applications cannot be deleted.',
        })
        return
      }

      await deleteLeaveApplicationInBc(user, no, row)
      res.json({ ok: true, message: 'Leave draft permanently deleted.' })
    }),
  )

  router.post(
    '/leave',
    safe(async (req, res) => {
      const user = authUser(req)
      const body = z
        .object({
          leaveType: z.string().min(1),
          appliedDays: z.coerce.number().positive(),
          startDate: z.string().min(1),
          isHalfDayLeave: z.union([z.literal('0'), z.literal('1'), z.literal('2')]).default('0'),
          reliever: z.string().optional().default(''),
          reason: z.string().min(1),
          requisitionNo: z.string().optional().default(''),
          requestApproval: z.boolean().optional().default(true),
          endDate: z.string().optional().default(''),
          returnDate: z.string().optional().default(''),
          familyMember: z.string().optional().default(''),
          deliveryDate: z.string().optional().default(''),
        })
        .parse(req.body)

      const action = body.requisitionNo ? 'edit' : 'create'

      const [typeRows, employeeRow, balanceSummarySoap] = await Promise.all([
        fetchOData('QyHRLeaveType', {
          $filter: `Code eq '${odataString(body.leaveType)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
        fetchCurrentEmployeeRow(user.employeeNo),
        callSoapMethod('GetLeaveBalance', {
          employeeNo: user.employeeNo,
          leaveType: body.leaveType,
        }).catch(() => null),
      ])
      const leaveTypeRow = Array.isArray(typeRows) && typeRows.length > 0 ? typeRows[0]! : null
      const eligibility = await employeeLeaveEligibility(user.employeeNo, employeeRow)
      if (leaveTypeRow) {
        const userGender = normalizeAuthGender(
          eligibility.gender || user.Gender || user.gender,
        )
        if (!leaveTypeMatchesGender(leaveTypeRow, userGender)) {
          res.status(422).json({
            ok: false,
            message: 'This leave type is not available for the gender recorded on your Employee Card.',
          })
          return
        }
        if (leaveTypeIsMarriage(leaveTypeRow)) {
          if (!leaveTypeMatchesMaritalStatus(leaveTypeRow, eligibility.maritalStatus)) {
            res.status(422).json({
              ok: false,
              message:
                'Marriage leave is not available because your Business Central Employee Card is already marked Married.',
            })
            return
          }
        }
        if (isSickLeaveRow(leaveTypeRow) && !sickLeaveStartDateAllowed(body.startDate)) {
          res.status(422).json({
            ok: false,
            code: 'SICK_LEAVE_DATE_NOT_ALLOWED',
            message: 'Sick leave can only start today or tomorrow.',
          })
          return
        }
      }

      if (halfDayRequiresAnnualLeave(body.isHalfDayLeave)) {
        if (!leaveTypeIsAnnual(leaveTypeRow)) {
          res.status(422).json({
            ok: false,
            message:
              'Half-day leave is only allowed for annual leave. Choose Annual Leave or set half day to Normal.',
          })
          return
        }
      }

      // Enforce the employee-facing Available Leave Balance, never the larger
      // Total Available Leave Balance. BC repeats this validation when saving;
      // doing it here gives the employee a clear error before any draft is
      // created and protects older BC builds that only validate in the UI.
      const balanceSummary = parseBcLeaveSummary(balanceSummarySoap?.returnValue)
      const employeeBalanceMetrics = employeeLeaveMetrics(employeeRow, user)
      const employeeTakenRaw = fieldNumber(employeeRow, [
        'TotalLeaveTaken',
        'Total_Leave_Taken',
        'TotalLeaveTakenToDate',
        'Total_Leave_Taken_To_Date',
      ])
      const employeeLeaveEntitlement = fieldNumber(employeeRow, [
        'LeaveAllocation',
        'Leave_Allocation',
        'LeaveEntitlement',
        'Leave_Entitlement',
      ])
      const employeeCarryForward = fieldNumber(employeeRow, [
        'CarryForward',
        'Carry_forward',
        'Carry_Forward',
      ])
      const availableLeaveBalance = leaveTypeIsAnnual(leaveTypeRow)
        ? resolveAnnualAvailableLeaveBalance({
            summary: balanceSummary,
            leaveEntitlement: employeeLeaveEntitlement,
            carryForward: employeeCarryForward,
            leaveAccruedToDate: employeeBalanceMetrics.earnedLeaveDays,
            totalLeaveTakenToDate:
              employeeTakenRaw === null ? null : Math.abs(employeeTakenRaw),
          })
        : balanceSummary?.availableLeaveBalance ?? balanceSummary?.currentLeaveBalance ?? 0
      const requestedBalanceDays = body.deliveryDate
        ? 1
        : isHalfDaySelection(body.isHalfDayLeave)
          ? 0.5
          : body.appliedDays
      if (
        leaveApplicationExceedsAvailableBalance(
          requestedBalanceDays,
          availableLeaveBalance,
        )
      ) {
        res.status(422).json({
          ok: false,
          code: 'LEAVE_BALANCE_EXCEEDED',
          message: `You can apply for at most ${Math.max(0, Number(availableLeaveBalance ?? 0))} day(s), based on your Available Leave Balance.`,
          availableLeaveBalance,
        })
        return
      }

      const deliveryDate = formatBcSoapDate(body.deliveryDate)
      // Resolve dates the same way Laravel does — call BC GetLeaveDates first.
      // Maternity/prenatal leave uses Delivery Date in BC; skip date math when provided.
      const calculatedDates = deliveryDate
        ? { endDate: body.endDate, returnDate: body.returnDate, source: 'maternity' as const }
        : await resolveLeaveDatesFromBc(
            user,
            body.leaveType,
            body.appliedDays,
            body.startDate,
            body.isHalfDayLeave,
          )
      const formattedStartDate = formatBcSoapDate(deliveryDate || body.startDate)
      const formattedEndDate = formatBcSoapDate(
        calculatedDates.endDate || body.endDate || (deliveryDate ? deliveryDate : ''),
      )
      const formattedReturnDate = formatBcSoapDate(
        calculatedDates.returnDate || body.returnDate,
      )
      if (!deliveryDate && (!formattedStartDate || !formattedEndDate || !formattedReturnDate)) {
        res.status(422).json({
          ok: false,
          message: 'Could not compute leave dates — please verify start date and applied days.',
        })
        return
      }

      if (!deliveryDate) {
        await assertNoOverlappingLeaveApplication(
          user,
          formattedStartDate,
          formattedEndDate,
          body.requisitionNo,
        )
      }

      const result = await callSoapMethod('LeaveApplication', {
        action,
        leaveNo: body.requisitionNo,
        employeeNo: user.employeeNo,
        daysApplied: deliveryDate ? 1 : bcLeaveDaysApplied(body.appliedDays, body.isHalfDayLeave),
        startDate: formattedStartDate,
        endDate: formattedEndDate || formattedStartDate,
        returnDate: formattedReturnDate || formattedEndDate || formattedStartDate,
        reason: body.reason,
        reliever: body.reliever,
        myUserID: user.userID,
        leaveType: body.leaveType,
        isRequestLeaveAllowance: false,
        // LeaveApplication declares this as Boolean; GetLeaveDates uses 0/1/2 separately.
        isHalfDayLeave: isHalfDaySelection(body.isHalfDayLeave),
        familyMember: normalizeLeaveFamilyMember(body.familyMember),
        deliveryDate: deliveryDate || '',
      })

      const fromReturn = submittedLeaveNoFromReturn(result.returnValue)
      const soapOk = soapLeaveActionOk(result.returnValue)
      const documentNo =
        action === 'create'
          ? fromReturn ||
            (await pollSubmittedLeaveNo(user, body, formattedEndDate, result.returnValue).catch(
              () => '',
            ))
          : body.requisitionNo || fromReturn

      let status = 'Open'
      if (documentNo && action === 'create' && body.requestApproval !== false) {
        await assertLeaveApprovalAttachments(documentNo, body.leaveType)
        const approvalResult = await callSoapMethod(
          'RequestLeaveApproval',
          leaveApprovalSoapParams(user.employeeNo, documentNo),
        )
        if (soapApprovalOk(approvalResult.returnValue)) {
          const wait = await waitForLeavePendingInBc(user, documentNo)
          if (wait.confirmed) {
            status = resolveLeaveStatus(wait.row ?? {}, wait.approvalEntries)
            if (status === 'Open') status = 'Pending Approval'
          }
        }
      }

      const ok = action === 'create' ? Boolean(documentNo) : soapOk

      res.json({
        ok,
        message: ok
          ? action === 'edit'
            ? 'Leave application updated successfully'
            : status === 'Pending Approval'
              ? 'Leave application submitted for approval successfully'
              : 'Leave application created successfully'
          : soapOk && action === 'create' && !documentNo
            ? 'Your leave was saved, but the application number could not be confirmed. Refresh the list and open the latest application.'
            : String(result.returnValue ?? '').trim() &&
                !['false', '0', 'true', '1'].includes(
                  String(result.returnValue).trim().toLowerCase(),
                )
              ? String(result.returnValue).trim()
              : 'Leave application failed. Please verify reliever, dates, and leave balance, then try again.',
        returnValue: result.returnValue,
        documentNo: documentNo || undefined,
        request: documentNo
          ? {
              id: `leave-${documentNo}`,
              requestNo: documentNo,
              requestType: 'leave',
              status,
            }
          : undefined,
      })
    }),
  )

  router.post(
    '/leave/cancel',
    safe(async (req, res) => {
      const user = authUser(req)
      const body = z.object({ no: z.string().min(1) }).parse(req.body)
      const row = await fetchOwnedLeaveRow(user, body.no)
      if (!row) {
        res.status(404).json({ ok: false, message: 'Leave application not found.' })
        return
      }
      const status = resolveLeaveStatus(row)
      if (status !== 'Pending Approval') {
        res.status(422).json({
          ok: false,
          message:
            ['Open', 'Draft'].includes(status)
              ? 'This application is already a draft. Use Delete Draft to remove it permanently.'
              : 'Only a pending leave approval can be cancelled.',
        })
        return
      }
      await cancelLeaveApplicationInBc(user, body.no, row)
      let updatedRow: ODataRecord | null = null
      for (let attempt = 0; attempt < 6; attempt += 1) {
        updatedRow = await fetchOwnedLeaveRow(user, body.no)
        if (updatedRow && leaveIsOpenInBc(updatedRow)) break
        await new Promise((resolve) => setTimeout(resolve, 250))
      }
      const updatedStatus = updatedRow ? resolveLeaveStatus(updatedRow) : 'Open'
      res.json({
        ok: true,
        message: 'Approval cancelled. The leave application is open as a draft and can now be deleted.',
        status: ['Open', 'Draft'].includes(updatedStatus) ? updatedStatus : 'Open',
        confirmedInBc: Boolean(updatedRow && leaveIsOpenInBc(updatedRow)),
      })
    }),
  )

  /* ----------------------------- Master data ----------------------------- */

  router.get(
    '/items',
    safe(async (_req, res) => {
      const rows = await fetchOData('QyItem', { $select: 'No,Description' })
      res.json({ rows: Array.isArray(rows) ? rows : [] })
    }),
  )

  router.get(
    '/items/store/:store',
    safe(async (req, res) => {
      const rows = await fetchOData('QyItem', {
        $filter: `Ledger_Location eq '${odataString(req.params.store)}'`,
        $select: 'No,Description',
      })
      res.json({ rows: Array.isArray(rows) ? rows : [] })
    }),
  )

  router.get(
    '/services',
    safe(async (_req, res) => {
      const rows = await fetchOData('QyGlAccounts', {
        $filter: `DirectPosting eq true`,
        $select: 'No,Name',
      })
      res.json({ rows: Array.isArray(rows) ? rows : [] })
    }),
  )

  router.get(
    '/assets',
    safe(async (_req, res) => {
      const rows = await fetchOData('QyFixedAssets', { $select: 'No,Description' })
      res.json({ rows: Array.isArray(rows) ? rows : [] })
    }),
  )

  router.get(
    '/items/:item/balance/:store',
    safe(async (req, res) => {
      const rows = (await fetchOData('QyItemLedgerEntry', {
        $filter: `ItemNo eq '${odataString(req.params.item)}' and LocationCode eq '${odataString(req.params.store)}'`,
      })) as ODataRecord[] | null
      const balance = Array.isArray(rows)
        ? rows.reduce((sum, entry) => sum + Number(entry?.Quantity ?? 0), 0)
        : 0
      res.json({ balance: Math.round(balance) })
    }),
  )

  router.get(
    '/payroll/years',
    safe(async (_req, res) => {
      const rows = (await fetchOData('QyPayrollPeriods', {
        $filter: `Closed eq true`,
        $select: 'PeriodYear',
      })) as ODataRecord[] | null
      const seen = new Set<unknown>()
      const unique = (Array.isArray(rows) ? rows : []).filter((row) => {
        if (seen.has(row.PeriodYear)) return false
        seen.add(row.PeriodYear)
        return true
      })
      res.json({ rows: unique })
    }),
  )

  router.get(
    '/payroll/years/:year/months',
    safe(async (req, res) => {
      const year = Number(req.params.year)
      const rows = (await fetchOData('QyPayrollPeriods', {
        $filter: `Closed eq true and PeriodYear eq ${Number.isFinite(year) ? year : 0}`,
        $select: 'PeriodMonth',
      })) as ODataRecord[] | null
      const seen = new Set<unknown>()
      const unique = (Array.isArray(rows) ? rows : []).filter((row) => {
        if (seen.has(row.PeriodMonth)) return false
        seen.add(row.PeriodMonth)
        return true
      })
      res.json({ rows: unique })
    }),
  )

async function tryRequestLeaveApproval(
  user: ReturnType<typeof authUser>,
  candidates: string[],
) {
  let lastMessage = ''
  for (const candidate of candidates) {
    try {
      const result = await callSoapMethod(
        'RequestLeaveApproval',
        leaveApprovalSoapParams(user.employeeNo, candidate),
      )
      const raw = String(result.returnValue ?? '').trim()
      if (soapApprovalOk(result.returnValue)) {
        return { ok: true as const, candidate, returnValue: raw }
      }
      if (raw) lastMessage = raw
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error)
      if (message) lastMessage = message
    }
  }
  return {
    ok: false as const,
    message: lastMessage || 'Leave application could not be sent for approval.',
  }
}

async function waitForLeavePendingInBc(
  user: ReturnType<typeof authUser>,
  documentNo: string,
  row?: ODataRecord | null,
) {
  const candidates = row
    ? expandLeaveCancelDocumentNos(documentNo, row)
    : [...leaveDocumentNoCandidates(documentNo)]

  // Bounded, non-nested poll: each attempt does ONE cheap by-document query.
  // ~6.4s worst case, comfortably under the frontend request timeout.
  let currentRow: ODataRecord | null = row ?? null
  for (let attempt = 0; attempt < 8; attempt += 1) {
    if (attempt > 0) {
      await new Promise((resolve) => setTimeout(resolve, 800))
    }
    currentRow = (await fetchOwnedLeaveRow(user, documentNo)) ?? currentRow
    const byDoc = leaveApprovalEntriesForDocument(
      await fetchLeaveApprovalEntriesByDocumentNos(candidates),
      documentNo,
    )
    if ((currentRow && leaveIsPendingInBc(currentRow, byDoc)) || byDoc.length > 0) {
      return {
        row: currentRow,
        approvalEntries: await enrichLeaveApprovalEntries(byDoc),
        confirmed: true,
      }
    }
  }

  // Single sender-side fallback (not per attempt) to catch DocumentNo
  // formatting differences without fanning out into a query burst.
  const senderMatches = await findLeaveApprovalEntriesBySender(documentNo, user)
  if (senderMatches.length > 0) {
    return {
      row: currentRow,
      approvalEntries: await enrichLeaveApprovalEntries(senderMatches),
      confirmed: true,
    }
  }

  return { row: currentRow, approvalEntries: [], confirmed: false }
}

  router.post(
    '/leave/approval',
    safe(async (req, res) => {
      const user = authUser(req)
      const body = z.object({ no: z.string().min(1) }).parse(req.body)
      const row = await fetchOwnedLeaveRow(user, body.no)
      if (!row) {
        res.status(404).json({ ok: false, message: 'Leave application not found.' })
        return
      }

      const existingApprovalEntries = leaveApprovalEntriesForDocument(
        await fetchLeaveApprovalEntriesByDocumentNos(expandLeaveCancelDocumentNos(body.no, row)),
        body.no,
      )
      const currentStatus = resolveLeaveStatus(row, existingApprovalEntries)
      if (currentStatus === 'Pending Approval') {
        res.json({
          ok: true,
          confirmedInBc: true,
          message: 'Leave application is already pending approval.',
          status: 'Pending Approval',
          requestId: `leave-${body.no}`,
          approvalSteps: await resolveLeaveApprovalStepsAsync(row, existingApprovalEntries, body.no, {
            employeeNo: user.employeeNo,
            userID: user.userID,
            department: user.department,
          }),
        })
        return
      }
      if (!['Open', 'Draft'].includes(currentStatus)) {
        res.status(422).json({
          ok: false,
          message: `Leave application is already ${currentStatus.toLowerCase()}.`,
        })
        return
      }

      await assertLeaveApprovalAttachments(body.no, row)

      const candidates = expandLeaveCancelDocumentNos(body.no, row)
      const soap = await tryRequestLeaveApproval(user, candidates)
      if (!soap.ok) {
        res.status(422).json({ ok: false, message: soap.message })
        return
      }

      const wait = await waitForLeavePendingInBc(user, body.no, row)

      // Ground-truth snapshot for this explicit action (low volume — one per
      // click). Reveals whether BC actually created an approval entry.
      const diagnostic = await buildLeaveApprovalDiagnostic(
        user,
        body.no,
        wait.row ?? row,
        soap.returnValue,
      )
      logDiagnostic(
        `[leave-approval] no=${logSafe(body.no)} user=${logSafe(user.userID)} soap=${logSafe(diagnostic.soapReturnValue)} confirmed=${wait.confirmed} byDoc=${diagnostic.byDoc} senderAll=${diagnostic.senderAll} senderMatch=${diagnostic.senderMatches} hdrStatus=${logSafe(diagnostic.headerStatus)}`,
      )
      if (!wait.confirmed) {
        logDiagnostic(
          `[leave-approval] senderDocs=${logSafe(JSON.stringify(diagnostic.senderDocs), 2000)}`,
        )
      }
      const approvalSteps = wait.row
        ? await resolveLeaveApprovalStepsAsync(wait.row, wait.approvalEntries, body.no, {
            employeeNo: user.employeeNo,
            userID: user.userID,
            department: user.department,
          })
        : mapApprovalSteps(wait.approvalEntries)
      const resolvedStatus = wait.row
        ? resolveLeaveStatus(wait.row, wait.approvalEntries)
        : wait.confirmed
          ? 'Pending Approval'
          : 'Open'

      if (!approvalSteps.length && wait.confirmed) {
        const fallbackSteps = wait.row
          ? await resolveLeaveApprovalStepsAsync(wait.row, wait.approvalEntries, body.no, {
              employeeNo: user.employeeNo,
              userID: user.userID,
              department: user.department,
            })
          : mapApprovalSteps([
              {
                Status: 'Pending Approval',
                SequenceNo: 1,
                Role: 'Approver',
                ApproverName: 'Awaiting approver assignment',
                Comment: 'Submitted for approval',
              },
            ])
        res.json({
          ok: true,
          confirmedInBc: true,
          message: 'Leave application sent for approval successfully',
          status: resolvedStatus === 'Open' ? 'Pending Approval' : resolvedStatus,
          requestId: `leave-${body.no}`,
          approvalSteps: fallbackSteps,
          diagnostic,
        })
        return
      }

      res.json({
        ok: true,
        confirmedInBc: wait.confirmed,
        message: wait.confirmed
          ? 'Leave application sent for approval successfully'
          : 'Leave application sent for approval. Status will update shortly — refresh in a few seconds if it still shows Open.',
        status: resolvedStatus,
        requestId: `leave-${body.no}`,
        approvalSteps,
        diagnostic,
      })
    }),
  )

  return router
}
