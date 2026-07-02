import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import { callSoapMethod, fetchOData, fetchODataCount, odataString, type ODataRecord } from './bcClient.js'
import { requireAuth } from './auth.js'
import { approvalTableFilter, approvalModuleFromEntry, resolveApprovalModuleFromEntry, approvalTableIdsFor, type ApprovalTableKey } from './approvalTableIds.js'
import {
  findFrontendModuleSpec,
  getPortalModuleDocument,
  listPortalModuleLines,
  uploadPortalAttachment,
} from './staffModules.js'
import { resolveLeaveStatus, statusFromBc, documentStatusFromBc } from './erpMappings.js'
import { markLeaveSentForApproval } from './leaveApprovalCache.js'

/* -------------------------------------------------------------------------- */
/* Helpers                                                                    */
/* -------------------------------------------------------------------------- */

function yearWindow(now = new Date()) {
  const year = now.getUTCFullYear()
  return {
    start: `${year}-01-01`,
    end: `${year}-12-31`,
  }
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

/** Map BC SOAP `<return_value>` strings into a JS boolean. */
function soapTruthy(value: string | null | undefined) {
  if (!value) return false
  const normalized = String(value).trim().toLowerCase()
  if (['false', '0', 'no', 'n'].includes(normalized)) return false
  return normalized === 'true' || normalized === '1' || normalized === 'yes' || normalized.length > 0
}

/** Leave create/update should not treat arbitrary BC error text as success. */
function soapLeaveActionOk(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw) return false
  const normalized = raw.toLowerCase()
  if (['false', '0', 'no', 'n'].includes(normalized)) return false
  if (['true', '1', 'yes'].includes(normalized)) return true
  if (/^lv\d+/i.test(raw)) return true
  return /^[a-z]{1,6}\d{2,}$/i.test(raw)
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

function fieldText(row: ODataRecord | null | undefined, keys: string[], fallback = '') {
  if (!row) return fallback
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

function fieldNumber(row: ODataRecord | null | undefined, keys: string[]) {
  const value = fieldText(row, keys)
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : null
}

function roundLeaveValue(value: number) {
  return Math.round(value * 100) / 100
}

function employeeLeaveMetrics(row: ODataRecord | null | undefined, user: ReturnType<typeof authUser>) {
  return {
    leaveBalance:
      fieldNumber(row, ['LeaveBalance', 'Leave_Balance', 'AnnualLeaveBalance', 'Annual_Leave_Balance']) ??
      (Number.isFinite(Number(user.leaveBalance)) ? Number(user.leaveBalance) : null),
    earnedLeaveDays: fieldNumber(row, [
      'EarnedLeaveDays',
      'Earned_Leave_Days',
      'EarnedLeave',
      'Earned_Leave',
    ]),
  }
}

async function fetchCurrentEmployeeRow(employeeNo: string) {
  const rows = (await fetchOData('QyHREmployee', {
    $filter: `No eq '${odataString(employeeNo)}'`,
    $top: 1,
  }).catch(() => [])) as ODataRecord[] | null
  return Array.isArray(rows) && rows.length > 0 ? rows[0]! : null
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
    jobTitle: fieldText(row, ['JobTitle', 'Job_Title', 'Position']),
    departmentCode: fieldText(row, ['GlobalDimension1Code', 'DepartmentCode', 'Department_Code']),
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
  const branch = odataString(user.branchCode)
  const filters = [
    department ? `GlobalDimension1Code eq '${department}' and Status eq 'Active'` : '',
    department ? `DepartmentCode eq '${department}' and Status eq 'Active'` : '',
    department ? `GlobalDimension1Code eq '${department}'` : '',
    branch ? `GlobalDimension2Code eq '${branch}' and Status eq 'Active'` : '',
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
  const unique = [...new Set(documentNos.map((value) => value.trim()).filter(Boolean))]
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
    return documentType.includes('leave')
  })
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
  const trimmed = documentNo.trim()
  return [
    ...(grouped.get(trimmed) ?? []),
    ...(grouped.get(trimmed.toUpperCase()) ?? []),
    ...(grouped.get(trimmed.toLowerCase()) ?? []),
  ]
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
  return normalized
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

async function fetchOwnedLeaveRow(user: ReturnType<typeof authUser>, no: string) {
  const filters = [
    `ApplicationCode eq '${odataString(no)}' and EmployeeNo eq '${odataString(user.employeeNo)}'`,
    `ApplicationCode eq '${odataString(no)}' and UserID eq '${odataString(user.userID)}'`,
    `Application_Code eq '${odataString(no)}' and EmployeeNo eq '${odataString(user.employeeNo)}'`,
    `ApplicationCode eq '${odataString(no)}'`,
    `No eq '${odataString(no)}'`,
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

function mapLeaveApprovalStepsSimple(entries: ODataRecord[]) {
  return entries.map((entry, index) => {
    const rawStatus = fieldText(entry, ['Status'], 'Open')
    const status = rawStatus === 'Open' ? 'Pending Approval' : rawStatus
    return {
      id: fieldText(entry, ['EntryNo', 'Entry_No'], `approval-${index}`),
      actorName: fieldText(entry, ['ApproverName', 'ApproverID'], 'Approver'),
      role: 'Approver',
      status,
      timestamp: fieldText(entry, ['DateTimeSentforApproval', 'DueDate'], new Date().toISOString()),
      sequenceNo: index + 1,
    }
  })
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

function buildLeavePortalDetail(
  row: ODataRecord,
  no: string,
  user: ReturnType<typeof authUser>,
  approvalEntries: ODataRecord[],
  attachments: ODataRecord[],
) {
  const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'], no)
      const status = resolveLeaveStatus(row, approvalEntries)
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
    approverEmployeeNo: '',
    approverName: '',
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
    approvalSteps: mapLeaveApprovalStepsSimple(approvalEntries).map((step) => ({
      ...step,
      actorEmployeeNo: '',
    })),
    attachments: mapLeaveAttachmentsSimple(attachments),
  }
}

/** Business Central SOAP dates must use yyyy-mm-dd (locale-neutral). */
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
    const [key, value] = segment.split('=')
    const normalizedKey = key?.trim().toLowerCase() ?? ''
    if (normalizedKey === 'enddate') endDate = (value ?? '').trim()
    if (normalizedKey === 'returndate') returnDate = (value ?? '').trim()
  }
  return { endDate, returnDate }
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

      const result = await callSoapMethod('DocumentApproval', {
        entryNo: body.entryNo,
        docNo: body.docNo,
        userID: user.userID,
        isApprove,
        comments: body.comment || body.comments || '',
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
      const list = [...collected.values()]
      const approvalsByDoc = await fetchLeaveApprovalEntriesByDocumentNos(
        list.map((row) => fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])),
      )
      res.json({
        rows: list.map((row) => {
          const applicationCode = fieldText(row, ['ApplicationCode', 'Application_Code', 'No'])
          const approvalEntries = leaveApprovalEntriesForDocument(approvalsByDoc, applicationCode)
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
            Status: resolveLeaveStatus(row, approvalEntries),
          }
        }),
      })
    }),
  )

  router.get(
    '/leave/types',
    safe(async (req, res) => {
      const user = authUser(req)
      const notGender = user.Gender === 'Male' ? 'Female' : 'Male'
      const [rows, employeeRow] = await Promise.all([
        fetchOData('QyHRLeaveType', {
          $filter: `Gender ne '${odataString(notGender)}'`,
        }),
        fetchCurrentEmployeeRow(user.employeeNo),
      ])
      const metrics = employeeLeaveMetrics(employeeRow, user)
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => {
          const annual = leaveTypeIsAnnual(row)
          const genericDays = Number(row.Days ?? row.NoofDays ?? 0)
          return {
            ...row,
            Hourly: Boolean(row.Hourly ?? row.Allow_Hourly ?? false),
            Days: roundLeaveValue(
              annual ? metrics.earnedLeaveDays ?? metrics.leaveBalance ?? genericDays : genericDays,
            ),
            Annual: annual,
          }
        }),
      })
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
      const leaveTypeCode = req.params.type
      const today = new Date().toISOString().slice(0, 10)

      const [typeRows, pendingCount, ledgerRows, employeeRow] = await Promise.all([
        fetchOData('QyHRLeaveType', {
          $filter: `Code eq '${odataString(leaveTypeCode)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
        fetchODataCount('QyHRLeaveApplications', {
          $filter:
            `Status eq 'Pending Approval'` +
            ` and EmployeeNo eq '${odataString(user.employeeNo)}'` +
            ` and LeaveType eq '${odataString(leaveTypeCode)}'` +
            ` and EndDate gt ${today}`,
        }),
        fetchOData('QyHRLeaveLedger', {
          $filter: `EmployeeNo eq '${odataString(user.employeeNo)}' and LeaveType eq '${odataString(leaveTypeCode)}'`,
        }) as Promise<ODataRecord[] | null>,
        fetchCurrentEmployeeRow(user.employeeNo),
      ])

      const leaveTypeRow = Array.isArray(typeRows) && typeRows.length > 0 ? typeRows[0]! : null
      const leaveTypeDays = Number(leaveTypeRow?.Days ?? 0)
      const isHourly = Boolean(leaveTypeRow?.Allow_Hourly ?? leaveTypeRow?.Hourly ?? false)
      const isAnnual = leaveTypeIsAnnual(leaveTypeRow)
      const metrics = employeeLeaveMetrics(employeeRow, user)

      let additions = 0
      let deductions = 0
      if (Array.isArray(ledgerRows)) {
        for (const entry of ledgerRows) {
          const noOfDays = Number(entry?.NoofDays ?? entry?.['No_of_Days'] ?? 0)
          if (Number.isFinite(noOfDays)) {
            if (noOfDays < 0) deductions += -noOfDays
            else additions += noOfDays
          }
        }
      }

      let leaveBalance = 0
      if (isAnnual) {
        leaveBalance = metrics.leaveBalance ?? metrics.earnedLeaveDays ?? additions - deductions
      } else {
        leaveBalance = leaveTypeDays - (deductions - additions)
      }
      const balance = leaveBalance >= 0 ? roundLeaveValue(leaveBalance) : 0
      const entitlement = roundLeaveValue(
        isAnnual ? metrics.earnedLeaveDays ?? metrics.leaveBalance ?? leaveTypeDays : leaveTypeDays,
      )

      res.json({ balance, entitlement, pendingCount, isHourly })
    }),
  )

  router.get(
    '/leave/dates/:type/:days/:startDate/:halfDay',
    safe(async (req, res) => {
      const user = authUser(req)
      const type = String(req.params.type ?? '')
      const days = String(req.params.days ?? '')
      const startDate = String(req.params.startDate ?? '')
      const halfDay = String(req.params.halfDay ?? '0')
      const start = normalizeLeaveStartDate(startDate)
      const result = await callSoapMethod('GetLeaveDates', {
        empNo: user.employeeNo,
        leaveType: type,
        noOfDays: Number(days),
        startDate: start,
        whetherIsHalfDay: halfDayOptionValue(halfDay),
      })

      const { endDate, returnDate } = parseLeaveDatesReturn(result.returnValue)

      const startAsDate = new Date(`${formatBcSoapDate(startDate)}T12:00:00`)
      const day = startAsDate.getDay()
      const isWeekend = !Number.isNaN(startAsDate.getTime()) && day === 0

      if (!endDate) {
        res.status(422).json({
          endDate: '',
          returnDate: '',
          isWeekend,
          message:
            'Business Central did not return leave dates. Verify the start date, applied days, and leave balance.',
        })
        return
      }

      res.json({
        endDate: formatBcSoapDate(endDate) || endDate,
        returnDate: formatBcSoapDate(returnDate) || returnDate,
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
      const approvalEntries = leaveApprovalEntriesForDocument(
        await fetchLeaveApprovalEntriesByDocumentNos([applicationCode]),
        applicationCode,
      )
      const attachments = (await fetchOData('QyDocumentAttachments', {
        $filter: `No eq '${odataString(applicationCode)}' and TableID eq 50532`,
      }).catch(() => [])) as ODataRecord[] | null
      res.json(
        buildLeavePortalDetail(
          row,
          applicationCode,
          user,
          approvalEntries,
          Array.isArray(attachments) ? attachments : [],
        ),
      )
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

  router.post(
    '/leave',
    safe(async (req, res) => {
      const user = authUser(req)
      const body = z
        .object({
          leaveType: z.string().min(1),
          appliedDays: z.coerce.number(),
          startDate: z.string().min(1),
          isHalfDayLeave: z.union([z.literal('0'), z.literal('1'), z.literal('2')]).default('0'),
          reliever: z.string().optional().default(''),
          reason: z.string().min(1),
          requisitionNo: z.string().optional().default(''),
          requestApproval: z.boolean().optional().default(true),
        })
        .parse(req.body)

      const action = body.requisitionNo ? 'edit' : 'create'

      if (halfDayRequiresAnnualLeave(body.isHalfDayLeave)) {
        const typeRows = (await fetchOData('QyHRLeaveType', {
          $filter: `Code eq '${odataString(body.leaveType)}'`,
          $top: 1,
        })) as ODataRecord[] | null
        const leaveTypeRow = Array.isArray(typeRows) && typeRows.length > 0 ? typeRows[0]! : null
        if (!leaveTypeIsAnnual(leaveTypeRow)) {
          res.status(422).json({
            ok: false,
            message:
              'Half-day leave is only allowed for annual leave. Choose Annual Leave or set half day to Normal.',
          })
          return
        }
      }

      // Resolve dates the same way Laravel does — call BC GetLeaveDates first.
      const datesResult = await callSoapMethod('GetLeaveDates', {
        empNo: user.employeeNo,
        leaveType: body.leaveType,
        noOfDays: body.appliedDays,
        startDate: normalizeLeaveStartDate(body.startDate),
        whetherIsHalfDay: halfDayOptionValue(body.isHalfDayLeave),
      })

      const { endDate } = parseLeaveDatesReturn(datesResult.returnValue)
      if (!endDate) {
        res.status(422).json({
          ok: false,
          message: 'Could not compute end date — please verify start date and applied days.',
        })
        return
      }

      const result = await callSoapMethod('LeaveApplication', {
        action,
        leaveNo: body.requisitionNo,
        employeeNo: user.employeeNo,
        daysApplied: body.appliedDays,
        startDate: formatBcSoapDate(body.startDate),
        endDate: formatBcSoapDate(endDate),
        reason: body.reason,
        reliever: body.reliever,
        myUserID: user.userID,
        leaveType: body.leaveType,
        isRequestLeaveAllowance: false,
        // LeaveApplication declares this as Boolean; GetLeaveDates uses 0/1/2 separately.
        isHalfDayLeave: isHalfDaySelection(body.isHalfDayLeave),
      })

      const soapOk = soapLeaveActionOk(result.returnValue)
      const documentNo =
        soapOk && action === 'create'
          ? await pollSubmittedLeaveNo(user, body, endDate, result.returnValue).catch(() => '')
          : soapOk
            ? body.requisitionNo || submittedLeaveNoFromReturn(result.returnValue)
            : ''

      let status = 'Open'
      if (documentNo && action === 'create' && body.requestApproval !== false) {
        const approvalResult = await callSoapMethod('RequestLeaveApproval', {
          requisitionNo: documentNo,
          employeeNo: user.employeeNo,
          tableID: 50532,
        })
        if (soapTruthy(approvalResult.returnValue)) {
          status = 'Pending Approval'
          markLeaveSentForApproval(documentNo)
        }
      }

      const ok = action === 'create' ? Boolean(soapOk && documentNo) : soapOk

      res.json({
        ok,
        message: ok
          ? action === 'edit'
            ? 'Leave application updated successfully'
            : status === 'Pending Approval'
              ? 'Leave application submitted for approval successfully'
              : 'Leave application created successfully'
          : soapOk && action === 'create' && !documentNo
            ? 'Leave was saved in Business Central but the application number could not be confirmed. Refresh the list and open the latest application.'
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
      const result = await callSoapMethod('CancelLeaveApplication', {
        requisitionNo: body.no,
        employeeNo: user.employeeNo,
      })
      const ok = soapTruthy(result.returnValue)
      res.json({
        ok,
        message: ok
          ? 'Leave application cancelled successfully'
          : 'Leave application could not be cancelled.',
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

  router.post(
    '/leave/approval',
    safe(async (req, res) => {
      const user = authUser(req)
      const body = z.object({ no: z.string().min(1) }).parse(req.body)
      const result = await callSoapMethod('RequestLeaveApproval', {
        requisitionNo: body.no,
        employeeNo: user.employeeNo,
        tableID: 50532,
      })
      const ok = soapTruthy(result.returnValue)
      let resolvedStatus = ok ? 'Pending Approval' : undefined
      if (ok) {
        markLeaveSentForApproval(body.no)
        for (let attempt = 0; attempt < 6; attempt += 1) {
          await new Promise((resolve) => setTimeout(resolve, 350))
          const row = await fetchOwnedLeaveRow(user, body.no)
          const approvalEntries = leaveApprovalEntriesForDocument(
            await fetchLeaveApprovalEntriesByDocumentNos([body.no]),
            body.no,
          )
          if (row) {
            const status = resolveLeaveStatus(row, approvalEntries)
            if (status === 'Pending Approval' || status === 'Approved') {
              resolvedStatus = status
              break
            }
          } else if (approvalEntries.length > 0) {
            resolvedStatus = 'Pending Approval'
            break
          }
        }
      }
      res.json({
        ok,
        message: ok
          ? 'Leave application sent for approval successfully'
          : 'Leave application could not be sent for approval.',
        status: resolvedStatus,
        requestId: ok ? `leave-${body.no}` : undefined,
      })
    }),
  )

  return router
}
