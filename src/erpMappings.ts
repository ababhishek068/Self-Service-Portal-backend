import type { ODataRecord } from './bcClient.js'
import { EMPLOYEE_SALARY_BASE_FIELDS, employeeSalaryBaseFromRecord, mapAbhEmployeeOrg } from './employeeProfile.js'

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
  gatePass: 'QyGatePass',
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
  gatePass: 'Gate Pass',
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

/** Prefer the first positive amount so a zero FlowField does not hide Total Payment Amount. */
function resolveDocumentAmount(row: ODataRecord, keys: string[], fallback = 0) {
  let firstFinite: number | null = null
  for (const key of keys) {
    const raw = row[key]
    if (raw === undefined || raw === null || String(raw).trim() === '') continue
    const parsed = Number(String(raw).replaceAll(',', ''))
    if (!Number.isFinite(parsed)) continue
    if (firstFinite === null) firstFinite = parsed
    if (parsed > 0) return parsed
  }
  return firstFinite ?? fallback
}

/** Prefer BC header FlowFields (Total Net / Total Payment) over a blank/zero Amount. */
function amountKeysForModule(requestType: PortalModuleKey): string[] {
  if (requestType === 'pettyCashReplenishment') {
    return ['Amount_2', 'Source_Amount', 'SourceAmount', 'Receiving_Amount', 'ReceivingAmount', 'Amount']
  }
  if (requestType === 'pettyCash') {
    return [
      'TotalNetAmount',
      'Total_Net_Amount',
      'TotalPaymentAmount',
      'Total_Payment_Amount',
      'Amount',
      'NetAmount',
    ]
  }
  if (requestType === 'staffClaim' || requestType === 'imprest' || requestType === 'imprestSurrender') {
    return [
      'TotalNetAmount',
      'Total_Net_Amount',
      'TotalPaymentAmount',
      'Total_Payment_Amount',
      'NetAmount',
      'Net_Amount',
      'Amount',
      'TotalAmount',
      'PaidAmount',
    ]
  }
  return ['Amount', 'TotalAmount', 'NetAmount', 'TotalNetAmount', 'Total_Net_Amount', 'Quantity']
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

/** Resolve salary advance amount from BC line/header fields, with percentage fallback. */
export function resolveSalaryAdvanceAmount(line: ODataRecord, header?: ODataRecord) {
  const direct = num(line, SALARY_ADVANCE_AMOUNT_KEYS, 0)
  if (direct > 0) return direct

  const discovered = discoverPositiveNumericField(line, /amount|advance/i, /percentage/i)
  if (discovered > 0) return discovered

  if (header) {
    const headerAmount = num(header, SALARY_ADVANCE_AMOUNT_KEYS, 0)
    if (headerAmount > 0) return headerAmount
  }

  const percentage = resolveSalaryAdvancePercentage(line, header)
  if (percentage <= 0) return 0

  const salaryBase =
    positiveSalaryBase(line, header) ||
    discoverPositiveNumericField(line, /salary|basic|gross|wage|pay/i, /percentage|advance/i) ||
    (header
      ? discoverPositiveNumericField(header, /salary|basic|gross|wage|pay/i, /percentage|advance/i)
      : 0)

  if (salaryBase <= 0) return 0
  return Math.round(((salaryBase * percentage) / 100) * 100) / 100
}

export function injectSalaryAdvanceSalaryHint(header: ODataRecord, salaryBase: number) {
  if (salaryBase <= 0) return header
  const existing = positiveSalaryBase(header)
  const base = existing > 0 ? existing : salaryBase
  return {
    ...header,
    BasicSalary: base,
    Basic_Salary: base,
    MonthlySalary: base,
    Monthly_Salary: base,
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
  if (financeWorkflowStatus(status)) return 'Pending Approval'
  // Finance modules (claims, imprest, salary advance, etc.) use BC Status=Pending before approval is requested.
  if (status === 'pending') return 'Draft'
  if (status === 'open') return 'Open'
  if (status === 'draft') return 'Draft'
  if (status.includes('return')) return 'Returned'
  if (status.includes('reject')) return 'Rejected'
  if (status.includes('cancel')) return 'Cancelled'
  if (status.includes('post')) return 'Posted'
  if (status === 'approved' || status === 'released' || status.endsWith(' approved')) return 'Approved'
  if (status.includes('pending')) return 'Pending Approval'
  return raw.trim() || 'Open'
}

/** BC finance headers use multi-step statuses (1st Approval, Checking, …) while in workflow. */
function financeWorkflowStatus(status: string) {
  return (
    status === '1st approval' ||
    status === '2nd approval' ||
    status === 'checking' ||
    status === 'votebook' ||
    status === 'cheque printing'
  )
}

/** ESS transfer orders use ApprovalStatus; leave uses the same when Status stays Open. */
const FINANCE_STATUS_MODULES = new Set<PortalModuleKey>([
  'staffClaim',
  'pettyCash',
  'imprest',
  'imprestSurrender',
  'salaryAdvance',
])

export function documentStatusFromBc(row: ODataRecord, requestType: PortalModuleKey) {
  if (requestType === 'imprest' || requestType === 'imprestSurrender') {
    const posted = row.Posted ?? row.posted
    if (posted === true || ['true', 'yes', '1'].includes(String(posted ?? '').trim().toLowerCase())) {
      return 'Posted'
    }
  }
  if (requestType === 'transferOrder' || requestType === 'leave') {
    return text(row, ['ApprovalStatus', 'Approval_Status', 'Status', 'DocumentStatus'])
  }
  if (FINANCE_STATUS_MODULES.has(requestType)) {
    const finalApprover = text(row, ['FinalApproverStatus', 'Final_Approver_Status'])
    if (finalApprover) {
      const lower = finalApprover.toLowerCase()
      // Final Approver Status is a FlowField over Approval Entry. With no
      // approval entries BC returns the enum's zero value, "Created". That is
      // still an editable finance draft, not a submitted request.
      if (lower.includes('pending') || lower === 'open') return 'Pending Approval'
      if (lower.includes('approve')) return 'Approved'
      if (lower.includes('reject')) return 'Rejected'
    }
    const current = text(row, ['CurrentStatus', 'Current_Status'])
    if (current) return current
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
])

/** Finance headers often stay Status=Pending while QyApprovalEntry rows exist after Request Approval. */
const FINANCE_APPROVAL_WORKFLOW_MODULES = new Set<PortalModuleKey>([
  'staffClaim',
  'pettyCash',
  'imprest',
  'imprestSurrender',
  'salaryAdvance',
])

function moduleUsesApprovalEntryPromotion(requestType: PortalModuleKey) {
  return (
    OPEN_APPROVAL_WORKFLOW_MODULES.has(requestType) ||
    FINANCE_APPROVAL_WORKFLOW_MODULES.has(requestType)
  )
}

/** After a successful Request Approval SOAP call, promote Draft/Open detail responses. */
export function promoteDetailAfterApprovalSubmit<T extends { status: string; payload?: ODataRecord }>(
  requestType: PortalModuleKey,
  detail: T,
): T {
  if (!moduleUsesApprovalEntryPromotion(requestType)) return detail
  if (detail.status !== 'Draft' && detail.status !== 'Open') return detail
  return {
    ...detail,
    status: 'Pending Approval',
    ...(detail.payload ? { payload: { ...detail.payload, Status: 'Pending Approval' } } : {}),
  }
}

function approvalEntryStatus(entry: ODataRecord) {
  return text(entry, ['Status']).trim().toLowerCase()
}

function hasActiveApprovalEntries(entries: ODataRecord[]) {
  if (!entries.length) return false
  return entries.some((entry) => {
    const status = approvalEntryStatus(entry)
    if (!status) return true
    return (
      status === 'open' ||
      status === 'pending' ||
      status === 'created' ||
      status.includes('pending') ||
      (!status.includes('approve') &&
        !status.includes('reject') &&
        !status.includes('return') &&
        status !== 'canceled' &&
        status !== 'cancelled')
    )
  })
}

function approvalEntryIsReturned(entry: ODataRecord) {
  const status = approvalEntryStatus(entry)
  if (status.includes('return')) return true
  const comment = text(entry, ['Comment', 'Comments', 'ApprovalComment']).trim()
  return /^\[RETURNED\](?:\s|$)/i.test(comment)
}

function latestTerminalApprovalEntry(entries: ODataRecord[]) {
  const terminal = entries.filter((entry) => {
    const status = approvalEntryStatus(entry)
    return status.includes('approve') || status.includes('reject') || status.includes('return')
  })
  return terminal.sort((left, right) => {
    const leftNo = Number(text(left, ['EntryNo', 'Entry_No']))
    const rightNo = Number(text(right, ['EntryNo', 'Entry_No']))
    if (Number.isFinite(leftNo) && Number.isFinite(rightNo) && leftNo !== rightNo) {
      return leftNo - rightNo
    }
    const leftDate = Date.parse(text(left, ['LastDateTimeModified', 'DateTimeSentforApproval']))
    const rightDate = Date.parse(text(right, ['LastDateTimeModified', 'DateTimeSentforApproval']))
    if (Number.isFinite(leftDate) && Number.isFinite(rightDate) && leftDate !== rightDate) {
      return leftDate - rightDate
    }
    return entries.indexOf(left) - entries.indexOf(right)
  }).at(-1)
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

  if (!moduleUsesApprovalEntryPromotion(requestType)) return base

  // A live entry belongs to the newest approval cycle and takes precedence over
  // historical rejected/returned entries left behind by a previous submission.
  if (hasActiveApprovalEntries(approvalEntries)) return 'Pending Approval'

  const latestTerminal = latestTerminalApprovalEntry(approvalEntries)
  if (latestTerminal) {
    if (approvalEntryIsReturned(latestTerminal)) return 'Returned'
    const latestStatus = approvalEntryStatus(latestTerminal)
    if (latestStatus.includes('reject')) return 'Rejected'
    if (latestStatus.includes('approve')) return 'Approved'
  }
  if (base === 'Returned' || base === 'Rejected' || base === 'Approved') return base
  if (base === 'Pending Approval' || documentSentForApproval(row)) return 'Pending Approval'
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

function leaveApprovalEntryIsActive(entry: ODataRecord) {
  const rawStatus = text(entry, ['Status']).trim().toLowerCase()
  if (rawStatus === 'open' || rawStatus === 'pending' || rawStatus === 'created') return true
  return rawStatus.includes('pending')
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
  const approvalStatus = text(row, ['ApprovalStatus', 'Approval_Status']).trim().toLowerCase()
  if (approvalStatus === 'pending approval' || approvalStatus === 'pending') {
    return 'Pending Approval'
  }

  if (leaveSentForApproval(row)) return 'Pending Approval'

  if (leaveSentForApprovalFlag(row)) return 'Pending Approval'

  if (approvalEntries.some(leaveApprovalEntryIsActive)) {
    return 'Pending Approval'
  }

  const mapped = statusFromBc(documentStatusFromBc(row, 'leave'))
  if (mapped === 'Approved' || mapped === 'Rejected' || mapped === 'Cancelled') {
    return mapped
  }
  if (mapped !== 'Open' && mapped !== 'Draft') return mapped

  // Only promote Open/Draft → Pending below; terminal states already returned.
  if (leaveHeaderSignalsPending(row)) return 'Pending Approval'

  if (
    approvalEntries.some((entry) => {
      const stepStatus = statusFromBc(text(entry, ['Status'], 'Open'))
      return ['Pending Approval', 'Submitted', 'Approved', 'Rejected'].includes(stepStatus)
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
  const org = mapAbhEmployeeOrg(row)
  const departmentCode = org.departmentCode

  return {
    id: employeeNo || crypto.randomUUID(),
    employeeNo,
    displayName,
    email: text(row, ['Email', 'CompanyEMail', 'CompanyEmail', 'E_Mail']),
    departmentCode,
    departmentName: org.departmentName || departmentCode,
    branchCode: org.branchCode,
    branchName: org.branchName,
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
  const code = text(row, ['Code', 'GlobalDimension2Code'])
  return {
    code,
    name: text(row, ['Name', 'DepartmentName'], code),
    branchCode: text(row, ['BranchCode'], 'HO'),
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
  const makerEmployeeNo = text(row, ['EmployeeNo', 'StaffNo', 'RequesterID', 'Requested_By', 'UserID'])
  const title = text(row, ['Purpose', 'Description', 'PostingDescription', 'RequestDescription', 'Narration', 'Reason', 'Linkto'], moduleLabels[requestType])
  const createdAt = text(row, ['CreatedAt', 'DateCreated', 'Date', 'Requestdate', 'ApplicationDate', 'DocumentDate', 'OrderDate', 'SurrenderDate'], new Date().toISOString())

  return {
    id: `${requestType}-${requestNo || crypto.randomUUID()}`,
    requestNo,
    requestType,
    title,
    status: statusFromBc(documentStatusFromBc(row, requestType)),
    makerEmployeeNo,
    makerName: text(
      row,
      ['RequestorName', 'RequesterName', 'RequestedByName', 'EmployeeName', 'StaffName'],
      makerEmployeeNo,
    ),
    departmentCode: text(row, [
      'ShortcutDimension2Code',
      'Shortcut_Dimension_2_Code',
      'GlobalDimension2Code',
      'Department',
      'DepartmentCode',
    ]),
    departmentName: text(row, [
      'BudgetCenterName',
      'Budget_Center_Name',
      'DepartmentName',
      'Department_Name',
      'GlobalDimension2Name',
    ]),
    responsibleCenter: text(row, ['ResponsibilityCenter', 'Responsibility_Center']),
    amount:
      requestType === 'salaryAdvance'
        ? resolveSalaryAdvanceAmount(
            {
              PercentageofSalary: num(row, SALARY_ADVANCE_PERCENTAGE_KEYS, 0),
              PercentageOfSalary: num(row, SALARY_ADVANCE_PERCENTAGE_KEYS, 0),
              Percentage_of_Salary: num(row, SALARY_ADVANCE_PERCENTAGE_KEYS, 0),
            },
            row,
          )
        : resolveDocumentAmount(row, amountKeysForModule(requestType), 0),
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
