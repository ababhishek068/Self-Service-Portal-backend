import type { ODataRecord } from './bcClient.js'

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

function bool(row: ODataRecord, keys: string[], fallback = true) {
  const value = text(row, keys)
  if (!value) return fallback
  return ['true', '1', 'yes', 'active'].includes(value.toLowerCase())
}

export function statusFromBc(raw: string) {
  const status = raw.trim().toLowerCase()
  if (status === 'pending approval') return 'Pending Approval'
  // BC leave headers often keep Status/Open while ApprovalStatus is Pending.
  if (status === 'pending') return 'Pending Approval'
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

  // BC leave headers often move Status to Pending Approval while ApprovalStatus stays Open.
  const headerStatus = text(row, ['Status', 'DocumentStatus']).trim().toLowerCase()
  if (headerStatus === 'pending approval' || headerStatus === 'pending') {
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
  const departmentCode = text(row, ['GlobalDimension1Code', 'DepartmentCode', 'Department_Code'])

  return {
    id: employeeNo || crypto.randomUUID(),
    employeeNo,
    displayName,
    email: text(row, ['Email', 'CompanyEMail', 'CompanyEmail', 'E_Mail']),
    departmentCode,
    departmentName: text(row, ['DepartmentName', 'Department_Name'], departmentCode),
    branchCode: text(row, ['GlobalDimension2Code', 'BranchCode', 'Branch_Code'], 'HO'),
    branchName: text(row, ['BranchName', 'Branch_Name'], 'Head Office'),
    jobTitle: text(row, ['JobTitle', 'Job_Title']),
    jobGrade: text(row, ['JobGrade', 'Grade']),
    placeOfDuty: text(row, ['PlaceOfDuty', 'Place_of_Duty']),
    accountNumber: text(row, ['AccountNumber', 'Account_No', 'CustomerNo']),
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
    'AssignedUserID',
    'Assigned_User_ID',
    'UserID',
  ])
  // Prefer posting description over Document Type ("Quote") so purchase reqs don't title as Quote.
  const title = text(
    row,
    requestType === 'purchaseRequisition'
      ? [
          'PostingDescription',
          'Posting_Description',
          'Purpose',
          'Description',
          'RequestDescription',
          'Narration',
          'Reason',
          'Linkto',
        ]
      : [
          'Purpose',
          'Description',
          'PostingDescription',
          'RequestDescription',
          'Narration',
          'Reason',
          'Linkto',
        ],
    moduleLabels[requestType],
  )
  const createdAt = text(row, ['CreatedAt', 'DateCreated', 'Date', 'Requestdate', 'ApplicationDate', 'DocumentDate', 'OrderDate', 'SurrenderDate'], new Date().toISOString())

  return {
    id: `${requestType}-${requestNo || crypto.randomUUID()}`,
    requestNo,
    requestType,
    title,
    status: statusFromBc(documentStatusFromBc(row, requestType)),
    makerEmployeeNo,
    makerName: text(row, ['EmployeeName', 'StaffName', 'RequesterName'], makerEmployeeNo),
    departmentCode: text(row, ['Department', 'DepartmentCode', 'GlobalDimension1Code', 'DistrictDepartmentCode']),
    departmentName: text(row, ['DepartmentName', 'Department_Name', 'DistrictDepartmentName']),
    responsibleCenter: text(row, ['ResponsibilityCenter', 'Responsibility_Center']),
    amount: num(
      row,
      requestType === 'pettyCashReplenishment'
        ? ['Amount_2', 'Source_Amount', 'SourceAmount', 'Receiving_Amount', 'ReceivingAmount', 'Amount']
        : requestType === 'salaryAdvance'
          ? ['Amount', 'AdvanceAmount', 'NetAmount']
          : ['Amount', 'TotalAmount', 'NetAmount', 'Quantity'],
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
