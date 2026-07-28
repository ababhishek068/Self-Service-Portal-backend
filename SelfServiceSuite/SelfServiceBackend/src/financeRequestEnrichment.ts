import type { AuthUser } from './auth.js'
import type { ODataRecord } from './bcClient.js'
import { fetchEmployeeCustomerAccountNo, fetchEmployeeRecordFast } from './employeeProfile.js'
import { mapEmployee, type PortalModuleKey } from './erpMappings.js'

const FINANCE_DETAIL_MODULES = new Set<PortalModuleKey>([
  'imprest',
  'imprestSurrender',
  'staffClaim',
  'pettyCash',
])

function text(row: ODataRecord, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value) !== '') return String(value)
  }
  return fallback
}

function number(row: ODataRecord | Record<string, unknown>, keys: string[], fallback = 0) {
  const parsed = Number(text(row as ODataRecord, keys))
  return Number.isFinite(parsed) ? parsed : fallback
}

function sumLineAmounts(lines: Record<string, unknown>[]) {
  return lines.reduce((sum, line) => sum + number(line, ['amount', 'Amount']), 0)
}

export type FinanceEnrichmentHints = {
  departmentCode?: string
  departmentName?: string
  jobTitle?: string
  responsibleCenter?: string
  placeOfDuty?: string
  accountNumber?: string
  imprestNo?: string
}

export function isFinanceDetailModule(module: string): module is PortalModuleKey {
  return FINANCE_DETAIL_MODULES.has(module as PortalModuleKey)
}

export function financeSessionHints(authUser: AuthUser): FinanceEnrichmentHints {
  return {
    departmentCode: authUser.department,
    departmentName: authUser.departmentName,
    jobTitle: authUser.jobTitle,
    responsibleCenter: authUser.responsibleCenter || authUser.jobTitle,
    placeOfDuty: authUser.placeOfDuty,
    accountNumber: authUser.accountNumber || authUser.imprestNo,
    imprestNo: authUser.imprestNo,
  }
}

/** Merge employee/session hints into the BC header row so Finance detail views can read them. */
export function enrichFinanceHeaderRow(
  module: PortalModuleKey,
  row: ODataRecord,
  hints: FinanceEnrichmentHints = {},
  lines: Record<string, unknown>[] = [],
): ODataRecord {
  if (!FINANCE_DETAIL_MODULES.has(module)) return row

  const departmentCode = text(
    row,
    [
      'Department',
      'DepartmentCode',
      'GlobalDimension1Code',
      'ShortcutDimension1Code',
      'DistrictDepartmentCode',
    ],
    hints.departmentCode ?? '',
  )

  const departmentName = text(
    row,
    [
      'DepartmentName',
      'Department_Name',
      'DistrictDepartmentName',
      'BranchName',
      'Branch_Name',
      'DivisionName',
      'Division_Name',
      'SectorName',
      'Sector_Name',
    ],
    hints.departmentName ?? departmentCode,
  )

  const responsibleCenter = text(
    row,
    ['ResponsibilityCenter', 'Responsibility_Center', 'JobTitle', 'Job_Title'],
    hints.responsibleCenter || hints.jobTitle || '',
  )

  const placeOfDuty = text(
    row,
    ['PlaceofDuty', 'PlaceOfDuty', 'Place_of_Duty', 'DutyArea', 'Duty_Area'],
    hints.placeOfDuty ?? '',
  )

  const employeeAccountNo = text(
    row,
    [
      'EmployeeAccountNo',
      'Employee_Account_No',
      'CustomerNo',
      'Customer_Account_No',
      'ImprestNo',
      'AccountNumber',
      'Account_Number',
    ],
    hints.accountNumber || hints.imprestNo || '',
  )

  const headerAmount = number(row, [
    'TotalNetAmount',
    'Total_Net_Amount',
    'NetAmount',
    'Net_Amount',
    'Amount',
    'TotalAmount',
    'Total_Amount',
  ])
  const linesTotal = sumLineAmounts(lines)
  const totalNetAmount = headerAmount > 0 ? headerAmount : linesTotal
  const travelDate = text(row, [
    'TravelDate',
    'Travel_Date',
    'TravelStartDate',
    'Travel_Start_Date',
    'StartDate',
  ])
  const returnDate = text(row, ['ReturnDate', 'Return_Date', 'TravelEndDate', 'Travel_End_Date'])
  const durationDate = text(
    row,
    ['DurationDate', 'Duration_Date'],
    travelDate && returnDate ? `${travelDate} — ${returnDate}` : travelDate || returnDate,
  )
  const travelDestination = text(
    row,
    ['TravelDestination', 'Travel_Destination', 'Destination', 'DestinationCode'],
    text((lines[0] ?? {}) as ODataRecord, [
      'destination',
      'Destination',
      'DestinationCode',
      'Destination_Code',
    ]),
  )
  const directRemainingText = text(row, [
    'RemainingUnsettledAmount',
    'RemainingNotSettledAmount',
    'OutstandingBalance',
    'Balance',
    'BalanceLessThisEntry',
  ])
  const settledAmount = number(row, [
    'SettledAmount',
    'SurrenderedAmount',
    'AmountSurrendered',
    'ActualSpent',
  ])
  const remainingUnsettled =
    directRemainingText !== ''
      ? Number(directRemainingText)
      : totalNetAmount > 0 && settledAmount > 0
        ? Math.max(0, totalNetAmount - settledAmount)
        : 0

  const enriched: ODataRecord = { ...row }
  if (departmentCode) {
    enriched.Department = departmentCode
    enriched.GlobalDimension1Code = departmentCode
  }
  if (departmentName) enriched.DepartmentName = departmentName
  if (responsibleCenter) enriched.ResponsibilityCenter = responsibleCenter
  if (placeOfDuty) {
    enriched.PlaceofDuty = placeOfDuty
    enriched.PlaceOfDuty = placeOfDuty
  }
  if (employeeAccountNo) {
    enriched.EmployeeAccountNo = employeeAccountNo
    enriched.CustomerNo = employeeAccountNo
  }
  if (totalNetAmount > 0) enriched.TotalNetAmount = totalNetAmount
  if (travelDate) enriched.TravelDate = travelDate
  if (returnDate) enriched.ReturnDate = returnDate
  if (durationDate) enriched.DurationDate = durationDate
  if (travelDestination) enriched.TravelDestination = travelDestination
  if (Number.isFinite(remainingUnsettled) && (directRemainingText !== '' || remainingUnsettled > 0)) {
    enriched.RemainingUnsettledAmount = remainingUnsettled
  }

  return enriched
}

export async function enrichFinanceHeaderFromEmployee(
  module: PortalModuleKey,
  row: ODataRecord,
  authUser: AuthUser,
  lines: Record<string, unknown>[] = [],
): Promise<ODataRecord> {
  if (!FINANCE_DETAIL_MODULES.has(module)) return row

  const employeeNo = text(row, ['EmployeeNo', 'StaffNo', 'Employee_No', 'Staff_No'], authUser.employeeNo)
  const sessionHints = financeSessionHints(authUser)
  let hints = sessionHints

  if (employeeNo) {
    const emp = await fetchEmployeeRecordFast(employeeNo)
    if (emp) {
      const mapped = mapEmployee(emp)
      hints = {
        departmentCode: mapped.departmentCode || sessionHints.departmentCode,
        departmentName: mapped.departmentName || sessionHints.departmentName,
        jobTitle: mapped.jobTitle || sessionHints.jobTitle,
        responsibleCenter:
          mapped.responsibleCenter || mapped.jobTitle || sessionHints.responsibleCenter,
        placeOfDuty: mapped.placeOfDuty || sessionHints.placeOfDuty,
        accountNumber: mapped.accountNumber || sessionHints.accountNumber,
        imprestNo: sessionHints.imprestNo,
      }
    }
    const accountFromProfile = hints.accountNumber || (await fetchEmployeeCustomerAccountNo(employeeNo))
    if (accountFromProfile) hints = { ...hints, accountNumber: accountFromProfile }
  }

  return enrichFinanceHeaderRow(module, row, hints, lines)
}
