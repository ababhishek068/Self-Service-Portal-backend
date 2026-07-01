import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import { callSoapMethod, fetchOData, fetchODataCount, odataString, type ODataRecord } from './bcClient.js'
import { requireAuth } from './auth.js'
import { approvalTableFilter, approvalModuleFromEntry, resolveApprovalModuleFromEntry, type ApprovalTableKey } from './approvalTableIds.js'
import {
  findFrontendModuleSpec,
  getPortalModuleDocument,
  listPortalModuleLines,
} from './staffModules.js'

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
    if (value === null || value === undefined) continue
    const text = String(value).trim()
    if (text) return text
  }
  return fallback
}

function fieldNumber(row: ODataRecord | null | undefined, keys: string[]) {
  if (!row) return null
  for (const key of keys) {
    const value = row[key]
    if (value === null || value === undefined || value === '') continue
    const numeric = Number(String(value).replaceAll(',', ''))
    if (Number.isFinite(numeric)) return numeric
  }
  return null
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
  const status = fieldText(row, ['Status', 'EmployeeStatus', 'Employee_Status']).toLowerCase()
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
    if (list.length > 0) return list
  }
  return []
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

const leaveRequestSchema = z.object({
  leaveType: z.string().min(1),
  appliedDays: z.coerce.number(),
  startDate: z.string().min(1),
  isHalfDayLeave: z.union([z.literal('0'), z.literal('1'), z.literal('2')]).default('0'),
  reliever: z.string().optional().default(''),
  reason: z.string().min(1),
  requisitionNo: z.string().optional().default(''),
})

function submittedLeaveNoFromReturn(value: unknown) {
  const normalized = String(value ?? '').trim()
  if (!normalized) return ''
  if (['true', 'false', '1', '0', 'yes', 'no', 'ok'].includes(normalized.toLowerCase())) return ''
  return normalized
}

function sameBcDate(left: unknown, right: unknown) {
  const leftDate = formatBcSoapDate(String(left ?? ''))
  const rightDate = formatBcSoapDate(String(right ?? ''))
  return Boolean(leftDate && rightDate && leftDate === rightDate)
}

function submittedLeaveScore(row: ODataRecord, body: z.infer<typeof leaveRequestSchema>, endDate: string) {
  let score = 0
  if (fieldText(row, ['LeaveType', 'Leave_Type', 'LeaveTypeCode', 'Leave_Type_Code']) === body.leaveType) score += 10
  if (sameBcDate(fieldText(row, ['StartDate', 'Start_Date']), body.startDate)) score += 8
  if (sameBcDate(fieldText(row, ['EndDate', 'End_Date']), endDate)) score += 8
  const days = fieldNumber(row, ['DaysApplied', 'Days_Applied', 'NoofDays', 'No_of_Days'])
  if (days !== null && Math.abs(days - body.appliedDays) < 0.01) score += 4
  const reason = fieldText(row, ['Reasonforleave', 'Reason_for_leave', 'Reason', 'Description'])
  if (reason && reason === body.reason) score += 2
  const status = fieldText(row, ['Status']).toLowerCase()
  if (status === 'open') score += 1
  return score
}

async function resolveSubmittedLeaveNo(
  user: ReturnType<typeof authUser>,
  body: z.infer<typeof leaveRequestSchema>,
  endDate: string,
  rawReturnValue: unknown,
) {
  if (body.requisitionNo) return body.requisitionNo

  const returnedNo = submittedLeaveNoFromReturn(rawReturnValue)
  if (returnedNo) return returnedNo

  const rows = (await fetchOData('QyHRLeaveApplications', {
    $filter: `EmployeeNo eq '${odataString(user.employeeNo)}'`,
    $orderby: 'ApplicationDate desc',
    $top: 20,
  }).catch(() => [])) as ODataRecord[] | null

  const list = Array.isArray(rows) ? rows : []
  let bestRow: ODataRecord | null = null
  let bestScore = -1
  for (const row of list) {
    const score = submittedLeaveScore(row, body, endDate)
    if (score > bestScore) {
      bestRow = row
      bestScore = score
    }
  }

  return bestRow
    ? fieldText(bestRow, ['ApplicationCode', 'No', 'ApplicationNo', 'Application_No'])
    : ''
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
      const rows = await fetchOData('QyHRLeaveApplications', {
        $filter: `UserID eq '${odataString(user.userID)}' and (ApplicationDate gt ${start} and ApplicationDate lt ${end})`,
      })
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => ({
          ApplicationCode: String(row.ApplicationCode ?? ''),
          LeaveType: String(row.LeaveType ?? row.Leave_Type ?? ''),
          LeaveTypeCode: String(row.LeaveTypeCode ?? row.Leave_Type_Code ?? row.LeaveType ?? ''),
          ApplicationDate: String(row.ApplicationDate ?? row.Application_Date ?? ''),
          DaysApplied: Number(row.DaysApplied ?? row.Days_Applied ?? row.NoofDays ?? row.No_of_Days ?? 0) || undefined,
          StartDate: String(row.StartDate ?? row.Start_Date ?? ''),
          EndDate: String(row.EndDate ?? row.End_Date ?? ''),
          ReturnDate: String(row.ReturnDate ?? row.Return_Date ?? ''),
          RelieverName: String(row.RelieverName ?? row.Reliever_Name ?? ''),
          Status: String(row.Status ?? ''),
        })),
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
        }) as Promise<ODataRecord[] | null>,
        fetchCurrentEmployeeRow(user.employeeNo),
      ])
      const metrics = employeeLeaveMetrics(employeeRow, user)
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => ({
          ...row,
          Hourly: soapTruthy(String(row.Hourly ?? row.Allow_Hourly ?? false)),
          Days: leaveTypeIsAnnual(row)
            ? roundLeaveValue(
                metrics.earnedLeaveDays ?? metrics.leaveBalance ?? Number(row.Days ?? row.NoofDays ?? 0),
              )
            : roundLeaveValue(Number(row.Days ?? row.NoofDays ?? 0)),
          Annual: leaveTypeIsAnnual(row),
        })),
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
      const isHourly = soapTruthy(String(leaveTypeRow?.Allow_Hourly ?? leaveTypeRow?.Hourly ?? false))
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
      const entitlement = isAnnual
        ? roundLeaveValue(metrics.earnedLeaveDays ?? metrics.leaveBalance ?? leaveTypeDays)
        : roundLeaveValue(leaveTypeDays)

      res.json({ balance, pendingCount, isHourly, entitlement })
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
    '/leave/:no',
    safe(async (req, res) => {
      const user = authUser(req)
      const no = req.params.no

      const [reqRows, approvers, attachments] = await Promise.all([
        fetchOData('QyHRLeaveApplications', {
          $filter: `ApplicationCode eq '${odataString(no)}' and EmployeeNo eq '${odataString(user.employeeNo)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
        fetchOData('QyApprovalEntry', {
          $filter: `DocumentNo eq '${odataString(no)}'`,
        }),
        fetchOData('QyDocumentAttachments', {
          $filter: `No eq '${odataString(no)}' and TableID eq 50532`,
        }).catch(() => []),
      ])

      const requisition = Array.isArray(reqRows) && reqRows.length > 0 ? reqRows[0]! : null
      if (!requisition) {
        res.status(404).json({ message: 'Leave application not found' })
        return
      }

      res.json({ requisition, approvers, attachments })
    }),
  )

  router.post(
    '/leave',
    safe(async (req, res) => {
      const user = authUser(req)
      const body = leaveRequestSchema.parse(req.body)

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

      const ok = soapTruthy(result.returnValue)
      const documentNo = ok ? await resolveSubmittedLeaveNo(user, body, endDate, result.returnValue) : ''
      res.json({
        ok,
        message: ok
          ? action === 'edit'
            ? 'Leave application updated successfully'
            : 'Leave application created successfully'
          : 'Leave application failed. Please try again.',
        returnValue: result.returnValue,
        documentNo,
        request: documentNo
          ? {
              id: `leave-${documentNo}`,
              requestNo: documentNo,
              requestType: 'leave',
              status: 'Open',
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
      res.json({
        ok,
        message: ok
          ? 'Leave application sent for approval successfully'
          : 'Leave application could not be sent for approval.',
      })
    }),
  )

  return router
}
