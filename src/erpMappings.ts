import type { ODataRecord } from './bcClient.js'

export const requestServices = {
  imprest: 'QyImprestHeader',
  imprestSurrender: 'QyImprestSurrenderHeader',
  staffClaim: 'QyStaffClaimHeader',
  pettyCash: 'QyPaymentsHeader',
  storeRequisition: 'QyStoreRequisitionHeader',
  purchaseRequisition: 'QyPurchaseHeader',
  fuelRequest: 'QyFuelMaintenanceRequests',
  transport: 'QyTransportRequisition',
  maintenance: 'QyFuelMaintenanceRequests',
  transferOrder: 'QyTransferOrderHeader',
  gatePass: 'QyTransferOrderHeader',
  leave: 'QyHRLeaveApplications',
  overtime: 'QyHRLeaveApplications',
  travel: 'QyTransportRequisition',
} as const

export type PortalModuleKey = keyof typeof requestServices

const moduleLabels: Record<PortalModuleKey, string> = {
  imprest: 'Imprest Requisition',
  imprestSurrender: 'Imprest Surrender',
  staffClaim: 'Staff Claims',
  pettyCash: 'Petty Cash',
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

function statusFromBc(raw: string) {
  const status = raw.toLowerCase()
  if (status.includes('pending')) return 'Pending Approval'
  if (status.includes('approve')) return 'Approved'
  if (status.includes('reject')) return 'Rejected'
  if (status.includes('cancel')) return 'Cancelled'
  if (status.includes('post')) return 'Posted'
  if (status.includes('open')) return 'Draft'
  return raw || 'Draft'
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
    jobTitle: text(row, ['JobTitle', 'Job_Title', 'JobID']),
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
  const requestNo = text(row, [
    'No',
    'ApplicationCode',
    'RequisitionNo',
    'Transport_Requisition_No',
    'DocumentNo',
    'Document_No',
  ])
  const makerEmployeeNo = text(row, ['EmployeeNo', 'StaffNo', 'RequesterID', 'Requested_By', 'UserID'])
  const title = text(row, ['Purpose', 'Description', 'PostingDescription', 'RequestDescription', 'Narration', 'Reason'], moduleLabels[requestType])
  const createdAt = text(row, ['CreatedAt', 'Date', 'Requestdate', 'ApplicationDate', 'DocumentDate', 'OrderDate', 'SurrenderDate'], new Date().toISOString())

  return {
    id: `${requestType}-${requestNo || crypto.randomUUID()}`,
    requestNo,
    requestType,
    title,
    status: statusFromBc(text(row, ['Status', 'DocumentStatus', 'ApprovalStatus'])),
    makerEmployeeNo,
    makerName: text(row, ['EmployeeName', 'StaffName', 'RequesterName'], makerEmployeeNo),
    departmentCode: text(row, ['Department', 'DepartmentCode', 'GlobalDimension1Code']),
    departmentName: text(row, ['DepartmentName', 'Department_Name']),
    responsibleCenter: text(row, ['ResponsibilityCenter', 'Responsibility_Center']),
    amount: num(row, ['Amount', 'TotalAmount', 'NetAmount', 'Quantity'], 0),
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
