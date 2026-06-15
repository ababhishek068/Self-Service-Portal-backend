import { Router, type Request, type Response, type NextFunction } from 'express'
import { z } from 'zod'
import { callSoapMethod, fetchOData, fetchODataCount, odataString, type ODataRecord } from './bcClient.js'
import { requireAuth } from './auth.js'

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
  return normalized === 'true' || normalized === '1' || normalized === 'yes' || normalized.length > 0
}

/* -------------------------------------------------------------------------- */
/* Approvals — table-id catalog                                               */
/* -------------------------------------------------------------------------- */

/**
 * Approval table-id mapping. Mirrors the values hard-coded in the Laravel
 * Staff models (see `App\Models\*::tableDesc()`), and is used by the count /
 * detail endpoints to fan out across the right BC entity.
 */
const APPROVAL_TABLE_IDS = {
  leave: 50532,
  imprest: 52202786,
  imprestSurr: 52202707,
  store: 52202966,
  purchase: 52121800,
  claim: 52202717,
  paymentVoucher: 50000,
  pettyCash: 50887,
  order: 38,
} as const

type ApprovalCountKey = keyof typeof APPROVAL_TABLE_IDS

const COUNT_KEY_LABELS: Record<ApprovalCountKey, string> = {
  leave: 'totalLeave',
  imprest: 'totalImprest',
  imprestSurr: 'totalImprestSurr',
  store: 'totalStore',
  purchase: 'totalPurchase',
  claim: 'totalClaim',
  paymentVoucher: 'totalPv',
  pettyCash: 'totalPc',
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
          ? (Object.keys(APPROVAL_TABLE_IDS) as ApprovalCountKey[])
          : Object.keys(APPROVAL_TABLE_IDS).includes(type as ApprovalCountKey)
            ? [type as ApprovalCountKey]
            : []

      const counts = await Promise.all(
        requestedKeys.map((key) =>
          fetchODataCount('QyApprovalEntry', {
            $filter: baseFilter(`TableID eq ${APPROVAL_TABLE_IDS[key]}`),
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
      const docNo = req.params.docNo
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

      res.json({ document: first, approvers })
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
      res.json({ rows: Array.isArray(rows) ? rows : [] })
    }),
  )

  router.get(
    '/leave/types',
    safe(async (req, res) => {
      const user = authUser(req)
      const notGender = user.Gender === 'Male' ? 'Female' : 'Male'
      const rows = await fetchOData('QyHRLeaveType', {
        $filter: `Gender ne '${odataString(notGender)}'`,
      })
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => ({
          ...row,
          Hourly: Boolean(row.Hourly ?? row.Allow_Hourly ?? false),
          Days: Number(row.Days ?? row.NoofDays ?? 0),
        })),
      })
    }),
  )

  router.get(
    '/leave/relievers',
    safe(async (req, res) => {
      const user = authUser(req)
      const rows = await fetchOData('QyHREmployee', {
        $filter: `No ne '${odataString(user.employeeNo)}' and Status eq 'Active'`,
        $select: 'No,FirstName,MiddleName,LastName',
      })
      res.json({ rows: Array.isArray(rows) ? rows : [] })
    }),
  )

  router.get(
    '/leave/balance/:type',
    safe(async (req, res) => {
      const user = authUser(req)
      const leaveTypeCode = req.params.type
      const today = new Date().toISOString().slice(0, 10)

      const [typeRows, pendingCount, ledgerRows] = await Promise.all([
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
      ])

      const leaveTypeRow = Array.isArray(typeRows) && typeRows.length > 0 ? typeRows[0]! : null
      const leaveTypeDays = Number(leaveTypeRow?.Days ?? 0)
      const isHourly = Boolean(leaveTypeRow?.Allow_Hourly ?? leaveTypeRow?.Hourly ?? false)

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
      if (leaveTypeRow?.Code === '0001') {
        leaveBalance = additions - deductions
      } else {
        leaveBalance = leaveTypeDays - (deductions - additions)
      }
      const balance = leaveBalance >= 0 ? Math.trunc(leaveBalance) : 0

      res.json({ balance, pendingCount, isHourly })
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
      const start = startDate.replaceAll('_', '/')
      const result = await callSoapMethod('GetLeaveDates', {
        empNo: user.employeeNo,
        leaveType: type,
        noOfDays: Number(days),
        startDate: start,
        whetherIsHalfDay: Number(halfDay),
      })

      const raw = String(result.returnValue ?? '').trim()
      let endDate = ''
      let returnDate = ''
      if (raw) {
        for (const segment of raw.split('#')) {
          const [key, value] = segment.split('=')
          if (key?.trim().toLowerCase() === 'enddate') endDate = (value ?? '').trim()
          if (key?.trim().toLowerCase() === 'returndate') returnDate = (value ?? '').trim()
        }
      }

      const startAsDate = new Date(start)
      const day = startAsDate.getUTCDay()
      const isWeekend = !Number.isNaN(startAsDate.getTime()) && (day === 0 || day === 6)

      res.json({ endDate, returnDate, isWeekend })
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
        fetchOData('QyAttachments', {
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
      const body = z
        .object({
          leaveType: z.string().min(1),
          appliedDays: z.coerce.number(),
          startDate: z.string().min(1),
          isHalfDayLeave: z.union([z.literal('0'), z.literal('1'), z.literal('2')]).default('0'),
          reliever: z.string().optional().default(''),
          reason: z.string().min(1),
          requisitionNo: z.string().optional().default(''),
        })
        .parse(req.body)

      const action = body.requisitionNo ? 'edit' : 'create'

      // Resolve dates the same way Laravel does — call BC GetLeaveDates first.
      const datesResult = await callSoapMethod('GetLeaveDates', {
        empNo: user.employeeNo,
        leaveType: body.leaveType,
        noOfDays: body.appliedDays,
        startDate: body.startDate,
        whetherIsHalfDay: Number(body.isHalfDayLeave),
      })

      let endDate = ''
      const datesRaw = String(datesResult.returnValue ?? '').trim()
      if (datesRaw) {
        for (const segment of datesRaw.split('#')) {
          const [key, value] = segment.split('=')
          if (key?.trim().toLowerCase() === 'enddate') endDate = (value ?? '').trim()
        }
      }
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
        startDate: new Date(body.startDate).toISOString(),
        endDate: new Date(endDate).toISOString(),
        reason: body.reason,
        reliever: body.reliever,
        myUserID: user.userID,
        leaveType: body.leaveType,
        isRequestLeaveAllowance: 0,
        isHalfDayLeave: Number(body.isHalfDayLeave),
      })

      const ok = Boolean(result.returnValue)
      res.json({
        ok,
        message: ok
          ? action === 'edit'
            ? 'Leave application updated successfully'
            : 'Leave application created successfully'
          : 'Leave application failed. Please try again.',
        returnValue: result.returnValue,
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

  return router
}
