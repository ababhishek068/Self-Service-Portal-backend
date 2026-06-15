import { Router, type Request } from 'express'
import { callSoapMethod, fetchOData, fetchODataCount, odataString, type ODataRecord } from './bcClient.js'
import { requireAuth, type AuthUser } from './auth.js'
import { mapItem, mapRequest, type PortalModuleKey } from './erpMappings.js'
import {
  cancelPortalModuleRequest,
  createPortalModuleRequest,
  findFrontendModuleSpec,
  getPortalModuleDocument,
  listPortalModuleRows,
} from './staffModules.js'

function safe(handler: (req: Request, res: import('express').Response) => Promise<unknown>) {
  return async (
    req: Request,
    res: import('express').Response,
    next: import('express').NextFunction,
  ) => {
    try {
      await handler(req, res)
    } catch (error) {
      next(error)
    }
  }
}

function user(req: Request) {
  if (!req.session.authUser) {
    throw Object.assign(new Error('Unauthenticated'), { status: 401 })
  }
  return req.session.authUser
}

function text(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

function number(row: ODataRecord, keys: string[], fallback = 0) {
  const parsed = Number(text(row, keys))
  return Number.isFinite(parsed) ? parsed : fallback
}

function portalError(message: string, status = 400, code?: string) {
  return Object.assign(new Error(message), { status, ...(code ? { code } : {}) })
}

const frontendModules = [
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
  'storeRequisition',
  'purchaseRequisition',
  'fuelRequest',
  'transport',
  'maintenance',
  'training',
  'leave',
] as const

type SupportedFrontendModule = (typeof frontendModules)[number]

function isSupportedModule(value: string): value is SupportedFrontendModule {
  return frontendModules.includes(value as SupportedFrontendModule)
}

function parseRequestId(id: string) {
  const module = frontendModules.find((candidate) => id.startsWith(`${candidate}-`))
  if (!module) throw portalError(`Unsupported request id: ${id}`, 400, 'UNSUPPORTED_MODULE')
  return { module, no: id.slice(module.length + 1) }
}

function approvalModule(row: ODataRecord): SupportedFrontendModule {
  const tableId = Number(row.TableID ?? row.TableId ?? 0)
  const documentType = text(row, ['DocumentType', 'Document_Type']).toLowerCase()
  if (tableId === 50532) return 'leave'
  if (tableId === 52202786) return 'imprest'
  if (tableId === 52202707) return 'imprestSurrender'
  if (tableId === 52202966) return 'storeRequisition'
  if (tableId === 52121800 || tableId === 38) return 'purchaseRequisition'
  if (tableId === 52202717) return 'staffClaim'
  if (tableId === 50887 || documentType.includes('petty cash')) return 'pettyCash'
  if (documentType.includes('transport')) return 'transport'
  return 'purchaseRequisition'
}

function approvalQueueItem(row: ODataRecord) {
  const module = approvalModule(row)
  const documentNo = text(row, ['DocumentNo', 'Document_No'])
  const status = text(row, ['Status'], 'Open')
  return {
    id: `${module}-${documentNo}`,
    requestNo: documentNo,
    module,
    title: text(row, ['DocumentType', 'Description'], `${module} approval`),
    makerEmployeeNo: text(row, ['SenderID', 'UserID', 'EmployeeNo']),
    makerName: text(row, ['SenderName', 'EmployeeName', 'UserID']),
    amount: number(row, ['Amount', 'TotalAmount']),
    status:
      status === 'Open'
        ? 'Pending Approval'
        : status === 'Approved'
          ? 'Approved'
          : status === 'Rejected'
            ? 'Rejected'
            : status,
    submittedAt: text(row, ['DateTimeSentforApproval', 'DueDate', 'Date'], new Date().toISOString()),
    approverEmployeeNo: text(row, ['ApproverID']),
    sourceDocumentNo: documentNo,
  }
}

async function mappedModuleRows(module: SupportedFrontendModule, authUser: AuthUser) {
  const spec = findFrontendModuleSpec(module)
  if (!spec) throw portalError(`${module} is not implemented in the ESS Business Central codeunit`, 501)
  const rows = await listPortalModuleRows(spec, authUser)
  return rows.map((row) => mapRequest(row, module as PortalModuleKey))
}

async function requestDetail(id: string, authUser: AuthUser) {
  const { module, no } = parseRequestId(id)
  if (module === 'leave') {
    const rows = (await fetchOData('QyHRLeaveApplications', {
      $filter: `ApplicationCode eq '${odataString(no)}'`,
      $top: 1,
    })) as ODataRecord[] | null
    const row = Array.isArray(rows) ? rows[0] : undefined
    if (!row) throw portalError('Leave request not found', 404, 'REQUEST_NOT_FOUND')
    return mapRequest(row, 'leave')
  }
  const spec = findFrontendModuleSpec(module)
  if (!spec) throw portalError(`${module} is not supported`, 501)

  let row = await getPortalModuleDocument(spec, authUser, no)
  if (!row) {
    const approvals = (await fetchOData('QyApprovalEntry', {
      $filter:
        `DocumentNo eq '${odataString(no)}'` +
        ` and ApproverID eq '${odataString(authUser.userID)}'`,
      $top: 1,
    })) as ODataRecord[] | null
    if (Array.isArray(approvals) && approvals.length > 0) {
      row = await getPortalModuleDocument(spec, authUser, no, false)
    }
  }
  if (!row) throw portalError('Request not found', 404, 'REQUEST_NOT_FOUND')
  return mapRequest(row, module as PortalModuleKey)
}

function attendanceRow(row: ODataRecord, authUser: AuthUser) {
  const date = text(row, ['Date', 'AttendanceDate', 'PostingDate'])
  return {
    id: text(row, ['EntryNo', 'Entry_No', 'SystemId'], `${authUser.employeeNo}-${date}`),
    date,
    staffName: text(row, ['StaffName', 'EmployeeName'], authUser.displayName),
    employeeNo: text(row, ['StaffNo', 'EmployeeNo'], authUser.employeeNo),
    timeIn: text(row, ['TimeIn', 'CheckInTime', 'SignInTime']),
    timeOut: text(row, ['TimeOut', 'CheckOutTime', 'SignOutTime']),
    hoursWorked: text(row, ['HoursWorked', 'Hours']),
    location: text(row, ['Location', 'CheckinLocation', 'Coordinates']),
    comments: text(row, ['Comments', 'Comment']),
  }
}

export function buildPortalApiRouter() {
  const router = Router()
  router.use(requireAuth)

  router.get(
    '/requests',
    safe(async (req, res) => {
      const module = typeof req.query.module === 'string' ? req.query.module : ''
      if (!isSupportedModule(module)) {
        throw portalError(
          `${module || 'This module'} is not implemented in the ESS Business Central codeunit`,
          501,
          'UNSUPPORTED_MODULE',
        )
      }
      res.json(await mappedModuleRows(module, user(req)))
    }),
  )

  router.post(
    '/requests',
    safe(async (req, res) => {
      const module = typeof req.body?.module === 'string' ? req.body.module : ''
      if (!isSupportedModule(module)) {
        throw portalError(
          `${module || 'This module'} is not implemented in the ESS Business Central codeunit`,
          501,
          'UNSUPPORTED_MODULE',
        )
      }
      const spec = findFrontendModuleSpec(module)
      if (!spec) {
        throw portalError(
          `${module} uses a dedicated Business Central endpoint`,
          501,
          'DEDICATED_MODULE_ENDPOINT',
        )
      }
      const no = await createPortalModuleRequest(spec, user(req), req.body ?? {})
      const created = await getPortalModuleDocument(spec, user(req), no).catch(() => null)
      res.status(201).json(
        created
          ? mapRequest(created, module as PortalModuleKey)
          : mapRequest(
              {
                ...req.body,
                No: no,
                Status: req.body?.submit === false ? 'Open' : 'Pending Approval',
              },
              module as PortalModuleKey,
            ),
      )
    }),
  )

  router.get(
    '/requests/:id',
    safe(async (req, res) => {
      res.json(await requestDetail(String(req.params.id), user(req)))
    }),
  )

  router.post(
    '/requests/:id/cancel',
    safe(async (req, res) => {
      const requestId = String(req.params.id)
      const { module, no } = parseRequestId(requestId)
      const spec = findFrontendModuleSpec(module)
      if (!spec) {
        throw portalError(
          `${module} uses a dedicated Business Central endpoint`,
          501,
          'DEDICATED_MODULE_ENDPOINT',
        )
      }
      await cancelPortalModuleRequest(spec, user(req), no)
      res.json(await requestDetail(requestId, user(req)).catch(() => ({ id: requestId, status: 'Cancelled' })))
    }),
  )

  router.delete('/requests/:id', (_req, res) => {
    res.status(501).json({
      message: 'ESS does not expose safe header deletion. Cancel the BC document instead.',
      code: 'DELETE_NOT_SUPPORTED',
    })
  })

  router.get(
    '/approvals',
    safe(async (req, res) => {
      const authUser = user(req)
      const type = typeof req.query.type === 'string' ? req.query.type.toLowerCase() : 'pending'
      const status = type === 'approved' ? 'Approved' : type === 'rejected' ? 'Rejected' : 'Open'
      const rows = (await fetchOData('QyApprovalEntry', {
        $filter:
          `Status eq '${status}'` +
          ` and ApproverID eq '${odataString(authUser.userID)}'`,
        $top: 30,
      })) as ODataRecord[] | null
      res.json({ rows: (Array.isArray(rows) ? rows : []).map(approvalQueueItem) })
    }),
  )

  router.post(
    '/approvals/:id/decide',
    safe(async (req, res) => {
      const authUser = user(req)
      const requestId = String(req.params.id)
      const { no } = parseRequestId(requestId)
      const entries = (await fetchOData('QyApprovalEntry', {
        $filter:
          `DocumentNo eq '${odataString(no)}'` +
          ` and ApproverID eq '${odataString(authUser.userID)}'` +
          ` and Status eq 'Open'`,
        $top: 1,
      })) as ODataRecord[] | null
      const entry = Array.isArray(entries) ? entries[0] : undefined
      if (!entry) throw portalError('Open approval entry not found', 404)

      const decision = req.body?.decision === 'Rejected' ? 'Rejected' : 'Approved'
      const result = await callSoapMethod('DocumentApproval', {
        entryNo: text(entry, ['EntryNo', 'Entry_No']),
        docNo: no,
        userID: authUser.userID,
        isApprove: decision === 'Approved',
        comments: String(req.body?.comment ?? ''),
      })
      if (!result.returnValue || String(result.returnValue).toLowerCase() === 'false') {
        throw portalError(`Business Central did not mark ${no} as ${decision.toLowerCase()}`, 502)
      }
      res.json({ ...(await requestDetail(requestId, authUser).catch(() => ({ id: requestId }))), status: decision })
    }),
  )

  router.get(
    '/approvals/count/:type/:status',
    safe(async (req, res) => {
      const authUser = user(req)
      const count = await fetchODataCount('QyApprovalEntry', {
        $filter:
          `Status eq '${odataString(String(req.params.status))}'` +
          ` and ApproverID eq '${odataString(authUser.userID)}'`,
      })
      res.json({ totalAll: count, isNotified: authUser.isNotified })
    }),
  )

  router.get(
    '/dashboard/summary',
    safe(async (req, res) => {
      const authUser = user(req)
      const approvalFilter = (status: string) =>
        `Status eq '${status}' and ApproverID eq '${odataString(authUser.userID)}'`
      const listModules: SupportedFrontendModule[] = [
        'imprest',
        'imprestSurrender',
        'staffClaim',
        'purchaseRequisition',
        'storeRequisition',
      ]
      const [
        pendingApprovals,
        approvedDocuments,
        rejectedDocuments,
        leaveApplications,
        moduleRows,
      ] = await Promise.all([
        fetchODataCount('QyApprovalEntry', { $filter: approvalFilter('Open') }),
        fetchODataCount('QyApprovalEntry', { $filter: approvalFilter('Approved') }),
        fetchODataCount('QyApprovalEntry', { $filter: approvalFilter('Rejected') }),
        fetchODataCount('QyHRLeaveApplications', {
          $filter: `UserID eq '${odataString(authUser.userID)}'`,
        }),
        Promise.all(listModules.map((module) => mappedModuleRows(module, authUser))),
      ])
      const [imprest, surrender, claims, purchase, store] = moduleRows
      const recentActivity = moduleRows
        .flat()
        .toSorted((a, b) => String(b.createdAt).localeCompare(String(a.createdAt)))
        .slice(0, 8)
      const openRequests = recentActivity.filter((row) =>
        ['Draft', 'Pending Approval'].includes(row.status),
      ).length
      res.json({
        pendingApprovals,
        approvedDocuments,
        rejectedDocuments,
        leaveApplications,
        staffClaims: claims.length,
        imprestRequisitions: imprest.length,
        imprestSurrenders: surrender.length,
        purchaseRequisitions: purchase.length,
        storeRequisitions: store.length,
        leaveBalance: authUser.leaveBalance,
        openRequests,
        unresolved: openRequests,
        recentActivity,
      })
    }),
  )

  router.get(
    '/attendance',
    safe(async (req, res) => {
      const authUser = user(req)
      const rows = (await fetchOData('QyAttendanceLedger', {
        $filter: `StaffNo eq '${odataString(authUser.employeeNo)}'`,
      })) as ODataRecord[] | null
      res.json({ rows: (Array.isArray(rows) ? rows : []).map((row) => attendanceRow(row, authUser)) })
    }),
  )

  router.get(
    '/attendance/team',
    safe(async (req, res) => {
      const authUser = user(req)
      if (!authUser.HOD) throw portalError('HOD access required', 403)
      const rows = (await fetchOData('QyAttendanceLedger', {
        $filter: authUser.department
          ? `DepartmentCode eq '${odataString(authUser.department)}'`
          : undefined,
      })) as ODataRecord[] | null
      res.json({ rows: (Array.isArray(rows) ? rows : []).map((row) => attendanceRow(row, authUser)) })
    }),
  )

  const attendanceAction = (type: 'checkin' | 'checkout') =>
    safe(async (req, res) => {
      const authUser = user(req)
      const result = await callSoapMethod('FnCheckinCheckout', {
        employeeNo: authUser.employeeNo,
        myUserID: authUser.userID,
        type,
        location: type === 'checkin' ? String(req.body?.location ?? '') : '',
      })
      if (!result.returnValue) throw portalError(`Business Central ${type} failed`, 502)
      res.json({
        id: `${authUser.employeeNo}-${Date.now()}`,
        date: new Date().toISOString().slice(0, 10),
        staffName: authUser.displayName,
        employeeNo: authUser.employeeNo,
        timeIn: type === 'checkin' ? new Date().toISOString() : '',
        timeOut: type === 'checkout' ? new Date().toISOString() : '',
        hoursWorked: '',
        location: String(req.body?.location ?? ''),
        comments: String(result.returnValue),
      })
    })
  router.post('/attendance/sign-in', attendanceAction('checkin'))
  router.post('/attendance/sign-out', attendanceAction('checkout'))

  router.get(
    '/profile/details',
    safe(async (req, res) => {
      const authUser = user(req)
      const [employees, kin, history, qualifications, assets] = await Promise.all([
        fetchOData('QyHREmployee', {
          $filter: `No eq '${odataString(authUser.employeeNo)}'`,
          $top: 1,
        }) as Promise<ODataRecord[] | null>,
        fetchOData('QyHREmployeeKin', {
          $filter: `EmployeeCode eq '${odataString(authUser.employeeNo)}'`,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyEmploymentHistory', {
          $filter: `Employee_No eq '${odataString(authUser.employeeNo)}'`,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyEmployeeQualifications', {
          $filter: `EmployeeNo eq '${odataString(authUser.employeeNo)}'`,
        }).catch(() => [] as ODataRecord[]),
        fetchOData('QyFixedAssets', {
          $filter: `ResponsibleEmployee eq '${odataString(authUser.employeeNo)}'`,
        }).catch(() => [] as ODataRecord[]),
      ])
      const employee = Array.isArray(employees) ? employees[0] ?? {} : {}
      res.json({
        sector: text(employee, ['Sector', 'GlobalDimension1Code']),
        division: text(employee, ['Division']),
        district: text(employee, ['District', 'GlobalDimension2Code']),
        maritalStatus: text(employee, ['MaritalStatus', 'Marital_Status']),
        employmentType: text(employee, ['EmploymentType', 'ContractType']),
        gender: text(employee, ['Gender'], authUser.gender),
        phoneNumber: text(employee, ['CellPhoneNumber', 'HomePhoneNumber'], authUser.phoneNumber),
        dateOfJoin: text(employee, ['EmploymentDate', 'DateOfJoin']),
        contractStartDate: text(employee, ['ContractStartDate']),
        contractEndDate: text(employee, ['ContractEndDate']),
        probationEndDate: text(employee, ['ProbationEndDate']),
        nextOfKin: (Array.isArray(kin) ? kin : []).map((row) => ({
          name: text(row, ['Name', 'FullName']),
          relationship: text(row, ['Relationship']),
          phone: text(row, ['PhoneNo', 'PhoneNumber']),
          address: text(row, ['Address']),
        })),
        employmentHistory: (Array.isArray(history) ? history : []).map((row) => ({
          organisation: text(row, ['Employer', 'Organisation', 'CompanyName']),
          position: text(row, ['Position', 'JobTitle']),
          fromDate: text(row, ['FromDate', 'StartDate']),
          toDate: text(row, ['ToDate', 'EndDate'], 'Present'),
          type: text(row, ['Type'], 'External'),
        })),
        qualifications: (Array.isArray(qualifications) ? qualifications : []).map((row) => ({
          title: text(row, ['Qualification', 'Description']),
          institution: text(row, ['Institution']),
          year: text(row, ['Year', 'CompletionYear']),
          level: text(row, ['Level', 'QualificationType']),
        })),
        assignedAssets: (Array.isArray(assets) ? assets : []).map((row) => ({
          tagNumber: text(row, ['No', 'FATagNumber']),
          description: text(row, ['Description']),
          assignedDate: text(row, ['AcquisitionDate', 'AssignedDate']),
          status: text(row, ['Status'], 'Active'),
        })),
      })
    }),
  )

  router.get(
    '/documents',
    safe(async (_req, res) => {
      const rows = (await fetchOData('PgHrDownloads')) as ODataRecord[] | null
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => {
          const id = text(row, ['No', 'Code', 'SystemId'])
          return {
            id,
            title: text(row, ['Description', 'Title', 'Name'], id),
            category: text(row, ['Category', 'DocumentType'], 'HR'),
            updated: text(row, ['LastModifiedDateTime', 'Date', 'UpdatedAt']),
            fileName: text(row, ['FileName'], `${id || 'policy-document'}.pdf`),
            mimeType: 'application/pdf',
          }
        }),
      })
    }),
  )

  router.get(
    '/documents/:id/download',
    safe(async (req, res) => {
      const result = await callSoapMethod('FnGetDocumentAttachmentBase64', {
        docNo: req.params.id,
        tableID: 51007,
      })
      if (!result.returnValue) throw portalError('Document attachment was not found', 404)
      const bytes = Buffer.from(result.returnValue, 'base64')
      res.setHeader('Content-Type', 'application/pdf')
      res.setHeader('Content-Disposition', `attachment; filename="${req.params.id}.pdf"`)
      res.send(bytes)
    }),
  )

  router.get(
    '/work-tickets',
    safe(async (req, res) => {
      const authUser = user(req)
      const rows = (await fetchOData('QyWorkTickets')) as ODataRecord[] | null
      res.json({
        rows: (Array.isArray(rows) ? rows : []).map((row) => {
          const ticketNo = text(row, ['TicketNo', 'No'])
          return {
            id: ticketNo,
            ticketNo,
            vehicle: text(row, ['VehicleNo', 'RegistrationNo']),
            driver: text(row, ['DriverName', 'Driver']),
            date: text(row, ['Date', 'PostingDate']),
            status: text(row, ['Status'], 'Open'),
            employeeNo: text(row, ['EmployeeNo'], authUser.employeeNo),
          }
        }),
      })
    }),
  )

  router.get('/performance', (_req, res) => {
    res.json({ rows: [] })
  })

  router.get(
    '/items',
    safe(async (_req, res) => {
      const rows = (await fetchOData('QyItem')) as ODataRecord[] | null
      res.json({ rows: (Array.isArray(rows) ? rows : []).map(mapItem) })
    }),
  )

  router.get('/payroll/payslip', (_req, res) => {
    res.status(501).json({
      message: 'ESS exposes payslips as PDF. The React JSON payslip screen needs a BC payroll-line mapping.',
      code: 'PAYSLIP_JSON_NOT_AVAILABLE',
    })
  })

  router.get('/payroll/master-roll', (_req, res) => {
    res.status(501).json({
      message: 'ESS exposes the master roll as PDF. The React JSON master-roll screen needs a BC payroll-line mapping.',
      code: 'MASTER_ROLL_JSON_NOT_AVAILABLE',
    })
  })

  router.get('/hod/team-requests', (_req, res) => res.json({ rows: [] }))
  router.get('/hod/staff-on-leave', (_req, res) => res.json({ rows: [] }))
  router.get('/reports/store-usage', (_req, res) => res.json([]))
  router.get('/reports/leave-balance', (_req, res) => res.json([]))
  router.get('/reports/gate-pass-log', (_req, res) => res.json([]))

  return router
}
