import type { ODataRecord } from './bcClient.js'
import { EMPLOYEE_SALARY_BASE_FIELDS, employeeSalaryBaseFromRecord } from './employeeProfile.js'

export const requestServices = {
  imprest: 'QyImprestHeader',
  imprestSurrender: 'QyImprestSurrenderHeader',
  staffClaim: 'QyStaffClaimHeader',
  pettyCash: 'QyPaymentsHeader',
  pettyCashReplenishment: 'PgInterBankTransfers',
  storeRequisition: 'QyStoreRequisitionHeader',
  purchaseRequisition: 'QyPurchaseHeader',
  fuelRequest: 'QyFuelMaintenanceRequests',
  transport: 'QyTransportRequisition',
  maintenance: 'QyFuelMaintenanceRequests',
  transferOrder: 'QyTransferOrderHeader',
  workTickets: 'QyWorkTickets',
  gatePass: 'QyGatePass',
  assetTransfer: 'QyAssetTransfer',
  leave: 'QyHRLeaveApplications',
  overtime: 'QyHRLeaveApplications',
  travel: 'QyTransportRequisition',
  training: 'QyTrainingApplicationHeader',
  salaryAdvance: 'QyStaffAdvanceHeader',
} as const

export type PortalModuleKey = keyof typeof requestServices

const moduleLabels: Record<PortalModuleKey, string> = {
  imprest: 'Imprest Requisition',
  imprestSurrender: 'Imprest Surrender',
  staffClaim: 'Staff Claims',
  pettyCash: 'Petty Cash',
  pettyCashReplenishment: 'Petty Cash Replenishment',
  storeRequisition: 'Store Requisition',
  purchaseRequisition: 'Purchase Requisition',
  fuelRequest: 'Fuel Requisition',
  transport: 'Transport Requisition',
  maintenance: 'Maintenance Request',
  transferOrder: 'Transfer Orders',
  workTickets: 'Work Tickets / Flight Booking',
  gatePass: 'Gate Pass',
  assetTransfer: 'Asset Transfer',
  leave: 'Leave Requisition',
  overtime: 'Overtime Request',
  travel: 'Travel Request',
  training: 'Training Request',
  salaryAdvance: 'Salary Advance',
}

function text(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

function num(row: ODataRecord, keys: string[], fallback = 0) {
  const value = text(row, keys)
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : fallback
}

function bool(row: ODataRecord, keys: string[], fallback = true) {
  const value = text(row, keys)
  if (!value) return fallback
  return ['true', '1', 'yes', 'active'].includes(value.toLowerCase())
}

const SALARY_ADVANCE_AMOUNT_KEYS = [
  'Amount',
  'amount',
  'Amount_LCY',
  'Advance_Amount',
  'AdvanceAmount',
  'Net_Amount',
  'NetAmount',
  'Salary_Amount',
  'SalaryAmount',
  'Line_Amount',
  'LineAmount',
  'Requested_Amount',
  'RequestedAmount',
  'TotalAmount',
  'Total_Amount',
]

const SALARY_ADVANCE_PERCENTAGE_KEYS = [
  'PercentageofSalary',
  'PercentageOfSalary',
  'Percentage_of_Salary',
  'PercentageSalary',
  'percentageSalary',
  'Percentage_Salary',
]

const SALARY_ADVANCE_SALARY_BASE_KEYS = [
  ...EMPLOYEE_SALARY_BASE_FIELDS,
  'Staff_Salary',
  'StaffSalary',
  'Employee_Salary',
  'EmployeeSalary',
  'Monthly_Basic',
  'MonthlyBasic',
  'Current_Basic',
  'CurrentBasic',
  'Total_Salary',
  'TotalSalary',
  'Basic_Pay_Amount',
  'BasicPayAmount',
]

function positiveSalaryBase(...rows: Array<ODataRecord | undefined>) {
  for (const row of rows) {
    if (!row) continue
    const fromKnown = employeeSalaryBaseFromRecord(row)
    if (fromKnown > 0) return fromKnown
  }
  return 0
}

function discoverPositiveNumericField(
  row: ODataRecord,
  keyPattern: RegExp,
  excludePattern?: RegExp,
) {
  for (const [key, value] of Object.entries(row)) {
    if (excludePattern?.test(key)) continue
    if (!keyPattern.test(key)) continue
    const parsed = Number(value)
    if (Number.isFinite(parsed) && parsed > 0) return parsed
  }
  return 0
}

export function resolveSalaryAdvancePercentage(line: ODataRecord, header?: ODataRecord) {
  const fromLine = num(line, SALARY_ADVANCE_PERCENTAGE_KEYS, 0)
  if (fromLine > 0) return fromLine
  return header ? num(header, SALARY_ADVANCE_PERCENTAGE_KEYS, 0) : 0
}

/** Resolve salary advance amount from percentage × salary base when both are known. */
export function resolveSalaryAdvanceAmount(line: ODataRecord, header?: ODataRecord) {
  const percentage = resolveSalaryAdvancePercentage(line, header)
  const salaryBase =
    positiveSalaryBase(line, header) ||
    discoverPositiveNumericField(line, /salary|basic|gross|wage|pay/i, /percentage|advance/i) ||
    (header
      ? discoverPositiveNumericField(header, /salary|basic|gross|wage|pay/i, /percentage|advance/i)
      : 0)

  if (percentage > 0 && salaryBase > 0) {
    return Math.round(((salaryBase * percentage) / 100) * 100) / 100
  }

  const direct = num(line, SALARY_ADVANCE_AMOUNT_KEYS, 0)
  if (direct > 0) return direct

  const discovered = discoverPositiveNumericField(line, /amount|advance/i, /percentage/i)
  if (discovered > 0) return discovered

  if (header) {
    const headerAmount = num(header, SALARY_ADVANCE_AMOUNT_KEYS, 0)
    if (headerAmount > 0) return headerAmount
  }

  return 0
}

export function injectSalaryAdvanceSalaryHint(header: ODataRecord, salaryBase: number) {
  if (salaryBase <= 0) return header
  return {
    ...header,
    monthlySalaryBase: salaryBase,
    BasicSalary: salaryBase,
    Basic_Salary: salaryBase,
    MonthlySalary: salaryBase,
    Monthly_Salary: salaryBase,
  }
}

export function mapSalaryAdvanceLine(line: ODataRecord, header: ODataRecord) {
  const amount = resolveSalaryAdvanceAmount(line, header)
  if (amount <= 0) return line
  return stampSalaryAdvanceLineAmount(line, amount)
}

function stampSalaryAdvanceLineAmount(line: ODataRecord, amount: number) {
  return {
    ...line,
    resolvedAmount: amount,
    Amount: amount,
    amount,
    AdvanceAmount: amount,
    Advance_Amount: amount,
  }
}

export function statusFromBc(raw: string) {
  const status = raw.trim().toLowerCase()
  if (status === 'pending approval') return 'Pending Approval'
  // Finance modules (claims, imprest, salary advance, etc.) use BC Status=Pending before approval is requested.
  if (status === 'pending') return 'Draft'
  if (status === 'open') return 'Open'
  if (status === 'draft') return 'Draft'
  if (status.includes('approve')) return 'Approved'
  if (status.includes('reject')) return 'Rejected'
  if (status.includes('cancel')) return 'Cancelled'
  if (status.includes('post')) return 'Posted'
  if (status.includes('pending')) return 'Pending Approval'
  return raw.trim() || 'Open'
}

/** ESS transfer orders use ApprovalStatus; leave uses the same when Status stays Open. */
export function documentStatusFromBc(row: ODataRecord, requestType: PortalModuleKey) {
  if (requestType === 'transferOrder' || requestType === 'leave') {
    return text(row, ['ApprovalStatus', 'Approval_Status', 'Status', 'DocumentStatus'])
  }
  return text(row, ['Status', 'DocumentStatus', 'ApprovalStatus'])
}

const OPEN_APPROVAL_WORKFLOW_MODULES = new Set<PortalModuleKey>([
  'storeRequisition',
  'purchaseRequisition',
  'transport',
  'training',
  'fuelRequest',
  'maintenance',
  'gatePass',
  'assetTransfer',
  'workTickets',
])

function approvalEntryStatus(entry: ODataRecord) {
  return text(entry, ['Status']).trim().toLowerCase()
}

function hasActiveApprovalEntries(entries: ODataRecord[]) {
  return entries.some((entry) => {
    const status = approvalEntryStatus(entry)
    return status === 'open' || status === 'pending' || status === 'created' || status.includes('pending')
  })
}

/** True when BC shows the document has entered the approval workflow. */
export function documentSentForApproval(row: ODataRecord) {
  for (const key of ['Sent_for_Approval', 'SentForApproval', 'Sent_For_Approval']) {
    const value = row[key]
    if (value === true || value === 1) return true
    if (typeof value === 'string' && ['true', '1', 'yes'].includes(value.trim().toLowerCase())) return true
  }
  const sentAt = text(row, [
    'DateTimeSentforApproval',
    'Date_Time_Sent_for_Approval',
    'DateTimeSentForApproval',
  ])
  return Boolean(sentAt && !sentAt.startsWith('0001-01-01'))
}

/**
 * Purchase/store/transport headers often stay Status=Open while QyApprovalEntry rows exist.
 * Promote to Pending Approval so cancel + approval history work like ESS.
 */
export function resolveModuleRequestStatus(
  row: ODataRecord,
  requestType: PortalModuleKey,
  approvalEntries: ODataRecord[] = [],
) {
  const base = statusFromBc(documentStatusFromBc(row, requestType))

  // A BC workflow rejection can set the source header to Cancelled even though
  // the Approval Entry correctly says Rejected. The approval decision is the
  // authoritative terminal status and must be visible to Finance requesters.
  if (approvalEntries.some((entry) => approvalEntryStatus(entry) === 'rejected') || base === 'Rejected') {
    return 'Rejected'
  }
  if (
    base === 'Approved' ||
    (approvalEntries.length > 0 &&
      approvalEntries.every((entry) => approvalEntryStatus(entry) === 'approved'))
  ) {
    return 'Approved'
  }

  // Finance headers can be Pending before approval is requested. Only the
  // modules below use Open/Pending approval-entry signals to promote a header
  // into Pending Approval; terminal decisions above apply to every module.
  if (!OPEN_APPROVAL_WORKFLOW_MODULES.has(requestType)) return base

  if (
    base === 'Pending Approval' ||
    hasActiveApprovalEntries(approvalEntries) ||
    documentSentForApproval(row)
  ) {
    return 'Pending Approval'
  }
  return base
}

export function leaveSentForApproval(row: ODataRecord) {
  const sentAt = text(row, [
    'DateTimeSentforApproval',
    'Date_Time_Sent_for_Approval',
    'DateTimeSentForApproval',
  ])
  return Boolean(sentAt && !sentAt.startsWith('0001-01-01'))
}

/** True once the employee (or BC) has sent this leave into the approval workflow. */
export function leaveHasEnteredApprovalWorkflow(row: ODataRecord) {
  const approvalStatus = text(row, ['ApprovalStatus', 'Approval_Status']).trim().toLowerCase()
  if (approvalStatus === 'pending approval' || approvalStatus === 'pending') return true
  if (leaveSentForApproval(row)) return true
  if (leaveSentForApprovalFlag(row)) return true
  return false
}

/** Open/Draft leave that has not been sent for approval must stay a draft in the portal. */
export function leaveDraftNotYetSubmitted(row: ODataRecord) {
  const headerStatus = text(row, ['Status', 'DocumentStatus']).trim().toLowerCase()
  const approvalStatus = text(row, ['ApprovalStatus', 'Approval_Status']).trim().toLowerCase()

  if (
    headerStatus.includes('approved') ||
    headerStatus.includes('cancel') ||
    headerStatus.includes('reject')
  ) {
    return false
  }

  // BC keeps Status=Open until the employee clicks Request Approval, then sets ApprovalStatus.
  if (headerStatus === 'open' || headerStatus === 'draft' || headerStatus === '') {
    return approvalStatus !== 'pending approval' && approvalStatus !== 'pending'
  }

  return false
}

function leaveApprovalEntryIsActive(entry: ODataRecord) {
  const rawStatus = text(entry, ['Status']).trim().toLowerCase()
  if (rawStatus === 'open' || rawStatus === 'pending' || rawStatus === 'created') return true
  return rawStatus.includes('pending')
}

function leaveApprovalEntryTimestamp(entry: ODataRecord) {
  const raw = text(entry, [
    'DateTimeSentforApproval',
    'Date_Time_Sent_for_Approval',
    'DateTimeSentForApproval',
    'CreatedDateTime',
    'Created_Date_Time',
  ])
  const parsed = Date.parse(raw)
  return Number.isFinite(parsed) ? parsed : null
}

function leaveApprovalEntryNumber(entry: ODataRecord) {
  const parsed = Number(text(entry, ['EntryNo', 'Entry_No']))
  return Number.isFinite(parsed) ? parsed : null
}

function normalizedLeaveDocumentKey(value: unknown) {
  const normalized = String(value ?? '').trim().toUpperCase()
  if (!normalized) return ''
  const withoutPrefix = normalized.replace(/^LV/, '')
  return withoutPrefix.replace(/^0+/, '') || withoutPrefix
}

function validDateTimestamp(value: unknown) {
  const raw = String(value ?? '').trim()
  if (!raw || raw.startsWith('0001-01-01')) return null
  const parsed = Date.parse(raw)
  return Number.isFinite(parsed) ? parsed : null
}

/**
 * A reused/reset BC number series can leave historical Approval Entry rows with
 * the same document number as a newly-created leave. Keep only leave-table entries
 * for the exact document whose sent/created timestamp is on or after this application date.
 */
export function currentLeaveApplicationApprovalEntries(
  row: ODataRecord,
  entries: ODataRecord[],
) {
  const applicationCode = text(row, ['ApplicationCode', 'Application_Code', 'No'])
  const applicationKey = normalizedLeaveDocumentKey(applicationCode)
  const applicationTimestamp = validDateTimestamp(
    text(row, [
      'ApplicationDate',
      'Application_Date',
      'CreatedDateTime',
      'Created_Date_Time',
      'SystemCreatedAt',
    ]),
  )

  return entries.filter((entry) => {
    const tableIdRaw = entry.TableID ?? entry.TableId
    if (tableIdRaw !== undefined && tableIdRaw !== null && String(tableIdRaw).trim() !== '') {
      const tableId = Number(tableIdRaw)
      if (Number.isFinite(tableId) && tableId !== 50532) return false
    }

    const entryDocumentKey = normalizedLeaveDocumentKey(
      text(entry, ['DocumentNo', 'Document_No', 'No']),
    )
    if (applicationKey && entryDocumentKey && applicationKey !== entryDocumentKey) return false

    if (applicationTimestamp !== null) {
      const entryTimestamp = validDateTimestamp(
        text(entry, [
          'DateTimeSentforApproval',
          'Date_Time_Sent_for_Approval',
          'DateTimeSentForApproval',
          'CreatedDateTime',
          'Created_Date_Time',
          'SystemCreatedAt',
          'Date',
        ]),
      )
      if (entryTimestamp !== null && entryTimestamp < applicationTimestamp) return false
    }

    return true
  })
}

/**
 * Approval Entry retains every submission/cancellation cycle for a document.
 * Use only the newest cycle when resolving the current leave state.
 */
export function latestLeaveApprovalCycleEntries(entries: ODataRecord[]) {
  if (entries.length <= 1) return [...entries]

  const timed = entries
    .map((entry) => ({ entry, timestamp: leaveApprovalEntryTimestamp(entry) }))
    .filter((item): item is { entry: ODataRecord; timestamp: number } => item.timestamp !== null)
  if (timed.length > 0) {
    const latestTimestamp = Math.max(...timed.map((item) => item.timestamp))
    return timed
      .filter((item) => item.timestamp === latestTimestamp)
      .map((item) => item.entry)
  }

  const numbered = entries
    .map((entry) => ({ entry, entryNo: leaveApprovalEntryNumber(entry) }))
    .filter((item): item is { entry: ODataRecord; entryNo: number } => item.entryNo !== null)
  if (numbered.length > 0) {
    const latestEntryNo = Math.max(...numbered.map((item) => item.entryNo))
    return numbered.filter((item) => item.entryNo === latestEntryNo).map((item) => item.entry)
  }

  return [...entries]
}

function leaveApprovalCycleStatus(entries: ODataRecord[]) {
  const current = latestLeaveApprovalCycleEntries(entries)
  if (current.length === 0) return ''
  const statuses = current.map((entry) => statusFromBc(text(entry, ['Status'], 'Open')))
  if (statuses.some((status) => status === 'Pending Approval' || status === 'Submitted')) {
    return 'Pending Approval'
  }
  if (statuses.some((status) => status === 'Rejected')) return 'Rejected'
  if (statuses.some((status) => status === 'Cancelled')) return 'Cancelled'
  if (statuses.every((status) => status === 'Approved')) return 'Approved'
  return ''
}

function leaveHeaderTerminalStatus(row: ODataRecord) {
  for (const key of ['Status', 'DocumentStatus', 'ApprovalStatus', 'Approval_Status']) {
    const raw = row[key]
    if (raw === undefined || raw === null || String(raw).trim() === '') continue
    const mapped = statusFromBc(String(raw))
    if (mapped === 'Approved' || mapped === 'Rejected' || mapped === 'Cancelled') return mapped
  }
  return ''
}

function leaveSentForApprovalFlag(row: ODataRecord) {
  for (const key of ['Sent_for_Approval', 'SentForApproval', 'Sent_For_Approval']) {
    const value = row[key]
    if (value === true || value === 1) return true
    if (typeof value === 'string' && ['true', '1', 'yes'].includes(value.trim().toLowerCase())) return true
  }
  return false
}

/**
 * Last-resort safety net: scan every status-like header field for a value that
 * says "pending". Catches BC deployments that expose the pending state on the
 * leave header under a field name we don't explicitly read. Only ever used to
 * promote Open/Draft → Pending, never to override a terminal status.
 */
function leaveHeaderSignalsPending(row: ODataRecord) {
  for (const [key, value] of Object.entries(row)) {
    if (value === null || value === undefined) continue
    const valueType = typeof value
    if (valueType !== 'string' && valueType !== 'number' && valueType !== 'boolean') continue
    const name = key.toLowerCase()
    const statusLike =
      name.includes('status') ||
      name.includes('approv') ||
      name.includes('sent') ||
      name.includes('stage') ||
      name.includes('state')
    if (!statusLike) continue
    if (String(value).toLowerCase().includes('pending')) return true
  }
  return false
}

/**
 * Resolve leave status strictly from Business Central data (header fields +
 * approval entries). BC is the single source of truth — nothing is stored locally.
 */
export function resolveLeaveStatus(row: ODataRecord, approvalEntries: ODataRecord[] = []) {
  const headerTerminal = leaveHeaderTerminalStatus(row)
  if (headerTerminal) return headerTerminal

  if (leaveDraftNotYetSubmitted(row)) {
    return statusFromBc(documentStatusFromBc(row, 'leave'))
  }

  const applicationApprovalEntries = currentLeaveApplicationApprovalEntries(row, approvalEntries)
  const cycleStatus = leaveApprovalCycleStatus(applicationApprovalEntries)
  if (
    cycleStatus === 'Approved' ||
    cycleStatus === 'Rejected' ||
    cycleStatus === 'Cancelled'
  ) {
    return cycleStatus
  }

  const approvalStatus = text(row, ['ApprovalStatus', 'Approval_Status']).trim().toLowerCase()
  if (approvalStatus === 'pending approval' || approvalStatus === 'pending') {
    return 'Pending Approval'
  }

  if (leaveSentForApproval(row)) return 'Pending Approval'

  if (leaveSentForApprovalFlag(row)) return 'Pending Approval'

  const currentApprovalEntries = latestLeaveApprovalCycleEntries(applicationApprovalEntries)
  if (cycleStatus === 'Pending Approval' || currentApprovalEntries.some(leaveApprovalEntryIsActive)) {
    return 'Pending Approval'
  }

  const mapped = statusFromBc(documentStatusFromBc(row, 'leave'))
  if (mapped !== 'Open' && mapped !== 'Draft') return mapped

  if (leaveHeaderSignalsPending(row)) return 'Pending Approval'

  if (
    currentApprovalEntries.some((entry) => {
      const stepStatus = statusFromBc(text(entry, ['Status'], 'Open'))
      return ['Pending Approval', 'Submitted'].includes(stepStatus)
    })
  ) {
    return 'Pending Approval'
  }

  return mapped
}

/** True only when Business Central itself reflects the leave as pending approval. */
export function leaveIsPendingInBc(row: ODataRecord, approvalEntries: ODataRecord[] = []) {
  return resolveLeaveStatus(row, approvalEntries) === 'Pending Approval'
}

export function mapEmployee(row: ODataRecord) {
  const employeeNo = text(row, ['No', 'EmployeeNo', 'Employee_No'])
  const firstName = text(row, ['FirstName', 'First_Name'])
  const middleName = text(row, ['MiddleName', 'Middle_Name'])
  const lastName = text(row, ['LastName', 'Last_Name'])
  const displayName = text(row, ['FullName', 'Name', 'EmployeeName'], [firstName, middleName, lastName].filter(Boolean).join(' '))
  const departmentCode = text(
    row,
    [
      'GlobalDimension1Code',
      'ShortcutDimension2Code',
      'DepartmentCode',
      'Department_Code',
      'Department',
    ],
    text(row, ['GlobalDimension2Code']),
  )

  return {
    id: employeeNo || crypto.randomUUID(),
    employeeNo,
    displayName,
    email: text(row, ['Email', 'CompanyEMail', 'CompanyEmail', 'E_Mail']),
    departmentCode,
    departmentName: text(
      row,
      ['DepartmentName', 'Department_Name'],
      departmentCode,
    ),
    branchCode: text(row, ['BranchCode', 'Branch_Code', 'GlobalDimension3Code', 'ShortcutDimension3Code'], 'HO'),
    branchName: text(row, ['BranchName', 'Branch_Name'], 'Head Office'),
    jobTitle: text(row, ['JobTitle', 'Job_Title']),
    jobGrade: text(row, ['JobGrade', 'Grade']),
    placeOfDuty: text(row, ['PlaceOfDuty', 'Place_of_Duty']),
    accountNumber: text(row, ['AccountNumber', 'Account_No', 'CustomerNo', 'Customer_Account_No', 'CustomerAccountNo']),
    managerEmployeeNo: text(row, ['ManagerNo', 'ManagerEmployeeNo', 'SupervisorNo']),
    leaveBalance: num(row, ['LeaveBalance', 'Leave_Balance'], 0),
    responsibleCenter: text(row, ['ResponsibilityCenter', 'Responsibility_Center']),
    permissionDepartments: departmentCode ? [departmentCode] : [],
    isActive: text(row, ['Status'], 'Active').toLowerCase() === 'active',
    raw: row,
  }
}

export function mapItem(row: ODataRecord) {
  const code = text(row, ['No', 'Code', 'ItemNo', 'Item_No'])
  return {
    code,
    description: text(row, ['Description', 'Name']),
    uom: text(row, ['BaseUnitofMeasure', 'Base_Unit_of_Measure', 'UnitOfMeasure'], 'Pcs'),
    stock: num(row, ['Inventory', 'Stock', 'Quantity', 'Balance'], 0),
    unitPrice: num(row, ['UnitPrice', 'Unit_Price', 'StandardCost'], 0),
    categoryCode: text(row, ['ItemCategoryCode', 'CategoryCode', 'InventoryPostingGroup']),
    isFixedAsset: false,
    isActive: bool(row, ['Blocked'], true),
    raw: row,
  }
}

export function mapDepartment(row: ODataRecord) {
  const code = text(row, ['Code', 'GlobalDimension1Code'])
  return {
    code,
    name: text(row, ['Name', 'DepartmentName'], code),
    branchCode: text(row, ['BranchCode', 'GlobalDimension2Code'], 'HO'),
    spendingLimit: num(row, ['SpendingLimit', 'BudgetAmount'], 0),
    isActive: true,
    raw: row,
  }
}

export function mapRequest(row: ODataRecord, requestType: PortalModuleKey) {
  const requestNo = text(row, requestType === 'gatePass' ? [
    'GatePassNo',
    'Gate_Pass_No',
  ] : requestType === 'leave' ? [
    'ApplicationCode',
    'Application_Code',
    'No',
    'ApplicationNo',
  ] : requestType === 'transport' ? [
    // QyTransportRequisition also exposes a generic `No` that contains the
    // employee/application number (for example A00052). The transport document
    // key is Transport_Requisition_No (for example TR0023), and must win in both
    // list labels and the View route.
    'Transport_Requisition_No',
    'TransportRequisitionNo',
    'RequisitionNo',
    'Requisition_No',
    'No',
  ] : [
    'No',
    'ApplicationCode',
    'RequisitionNo',
    'Transport_Requisition_No',
    'DocumentNo',
    'Document_No',
    'ApplicationNo',
    'TicketNo',
    'GatePassNo',
    'InterBankTransferNo',
  ])
  const makerEmployeeNo = text(row, [
    'EmployeeNo',
    'StaffNo',
    'RequesterID',
    'Requested_By',
    'UserID',
    'RaisedBy',
    'Raised_By',
  ])
  const title = text(row, ['Purpose', 'Purpose_of_Trip', 'PurposeOfTrip', 'Description', 'PostingDescription', 'PaymentNarration', 'Payment_Narration', 'RequestDescription', 'Narration', 'Reason', 'Linkto'], moduleLabels[requestType])
  const createdAt = text(row, ['CreatedAt', 'DateCreated', 'Date_of_Request', 'DateOfRequest', 'Date', 'Requestdate', 'ApplicationDate', 'DocumentDate', 'OrderDate', 'SurrenderDate'], new Date().toISOString())

  return {
    id: `${requestType}-${requestNo || crypto.randomUUID()}`,
    requestNo,
    requestType,
    title,
    status: statusFromBc(documentStatusFromBc(row, requestType)),
    makerEmployeeNo,
    makerName: text(row, ['EmployeeName', 'Employee_Name', 'StaffName', 'RequesterName'], makerEmployeeNo),
    departmentCode: text(row, [
      'DepartmentCode',
      'Department_Code',
      'Department',
      'DistrictDepartmentCode',
      'District_Department_Code',
    ]),
    departmentName: text(row, [
      'DepartmentName',
      'Department_Name',
      'DistrictDepartmentName',
      'District_Department_Name',
    ]),
    responsibleCenter: text(row, ['ResponsibilityCenter', 'Responsibility_Center']),
    amount:
      requestType === 'leave'
        ? num(row, ['DaysApplied', 'Days_Applied', 'NoofDays', 'No_of_Days'], 0)
        : requestType === 'salaryAdvance'
        ? resolveSalaryAdvanceAmount(
            {
              PercentageofSalary: num(row, SALARY_ADVANCE_PERCENTAGE_KEYS, 0),
              PercentageOfSalary: num(row, SALARY_ADVANCE_PERCENTAGE_KEYS, 0),
              Percentage_of_Salary: num(row, SALARY_ADVANCE_PERCENTAGE_KEYS, 0),
            },
            row,
          )
        : num(
            row,
            requestType === 'pettyCashReplenishment'
              ? ['Amount_2', 'Source_Amount', 'SourceAmount', 'Receiving_Amount', 'ReceivingAmount', 'Amount']
              : requestType === 'pettyCash'
                ? ['TotalNetAmount', 'Total_Net_Amount', 'TotalPaymentAmount', 'Total_Payment_Amount', 'Amount', 'NetAmount']
              : ['Amount', 'TotalAmount', 'NetAmount', 'TotalNetAmount', 'Total_Net_Amount', 'Quantity'],
            0,
          ),
    sourceDocument: {
      documentNo: requestNo,
      erpEntity: moduleLabels[requestType],
    },
    createdAt,
    submittedAt: text(row, ['SubmittedAt', 'SubmissionDate']),
    approverEmployeeNo: text(row, ['ApproverID', 'ApproverEmployeeNo']),
    approverName: text(row, ['ApproverName', 'ApproverID']),
    auditTrail: [],
    approvalSteps: [],
    attachments: [],
    payload: row,
  }
}
