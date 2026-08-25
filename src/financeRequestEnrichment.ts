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
    if (value === undefined || value === null) continue
    const raw = String(value).trim()
    if (!raw || raw.startsWith('0001-01-01')) continue
    return raw
  }
  return fallback
}

function number(row: ODataRecord | Record<string, unknown>, keys: string[], fallback = 0) {
  const parsed = Number(text(row as ODataRecord, keys))
  return Number.isFinite(parsed) ? parsed : fallback
}

function positiveNumber(row: ODataRecord | Record<string, unknown>, keys: string[], fallback = 0) {
  let firstFinite: number | null = null
  for (const key of keys) {
    const raw = (row as Record<string, unknown>)[key]
    if (raw === undefined || raw === null || String(raw).trim() === '') continue
    const parsed = Number(String(raw).replaceAll(',', ''))
    if (!Number.isFinite(parsed)) continue
    if (firstFinite === null) firstFinite = parsed
    if (parsed > 0) return parsed
  }
  return firstFinite ?? fallback
}

function sumLineAmounts(lines: Record<string, unknown>[]) {
  return lines.reduce(
    (sum, line) =>
      sum +
      number(line, [
        'amount',
        'Amount',
        'amountToRefund',
        'AmountToRefund',
        'Amount_To_Refund',
        'NetAmount',
        'Net_Amount',
      ]),
    0,
  )
}

export type FinanceEnrichmentHints = {
  departmentCode?: string
  departmentName?: string
  division?: string
  district?: string
  branchCode?: string
  branchName?: string
  jobTitle?: string
  jobGrade?: string
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
    branchCode: authUser.branchCode,
    branchName: authUser.branchName,
    jobTitle: authUser.jobTitle,
    jobGrade: authUser.jobGrade,
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
      'GlobalDimension2Code',
      'ShortcutDimension2Code',
    ],
    hints.departmentCode ?? '',
  )

  const departmentName = text(
    row,
    [
      'GlobalDimension2Name',
      'DepartmentName',
      'Department_Name',
    ],
    hints.departmentName ?? departmentCode,
  )

  const responsibleCenter = text(
    row,
    ['ResponsibilityCenter', 'Responsibility_Center', 'JobTitle', 'Job_Title'],
    hints.responsibleCenter || hints.jobTitle || '',
  )

  const division = text(row, ['DivisionName', 'Division_Name', 'GlobalDimension1Name', 'Division', 'GlobalDimension1Code'], hints.division ?? '')
  const district = text(
    row,
    ['DistrictName', 'District_Name', 'DistrictCode', 'LocationDivisionCode', 'District'],
    hints.district ?? '',
  )
  const branchCode = text(
    row,
    ['BranchCode', 'Branch_Code', 'BranchName'],
    hints.branchCode ?? '',
  )
  const branchName = text(row, ['BranchName', 'Branch_Name', 'BranchDisplayName'], hints.branchName || branchCode)
  const jobTitle = text(row, ['JobTitle', 'Job_Title', 'JobTitleDescription'], hints.jobTitle ?? '')
  const jobGrade = text(
    row,
    ['JobGrade', 'Job_Grade', 'Grade', 'SalaryGrade'],
    hints.jobGrade ?? '',
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

  const headerAmount = positiveNumber(row, [
    'TotalNetAmount',
    'Total_Net_Amount',
    'TotalPaymentAmount',
    'Total_Payment_Amount',
    'NetAmount',
    'Net_Amount',
    'Amount',
    'TotalAmount',
    'Total_Amount',
  ])
  const linesTotal = sumLineAmounts(lines)
  // Prefer a positive header total; otherwise fall back to summed line amounts.
  const totalNetAmount = headerAmount > 0 ? headerAmount : linesTotal > 0 ? linesTotal : headerAmount
  // Always stamp so mapRequest can read TotalNetAmount even when still zero.

  const enriched: ODataRecord = { ...row }
  if (departmentCode) {
    enriched.Department = departmentCode
    enriched.GlobalDimension2Code = departmentCode
  }
  if (departmentName) enriched.DepartmentName = departmentName
  if (division) enriched.Division = division
  if (district) enriched.District = district
  if (branchCode) enriched.BranchCode = branchCode
  if (branchName) enriched.BranchName = branchName
  if (jobTitle) enriched.JobTitle = jobTitle
  if (jobGrade) enriched.JobGrade = jobGrade
  if (responsibleCenter) enriched.ResponsibilityCenter = responsibleCenter
  if (placeOfDuty) {
    enriched.PlaceofDuty = placeOfDuty
    enriched.PlaceOfDuty = placeOfDuty
  }
  if (employeeAccountNo) {
    enriched.EmployeeAccountNo = employeeAccountNo
    enriched.CustomerNo = employeeAccountNo
  }
  if (totalNetAmount > 0) {
    enriched.TotalNetAmount = totalNetAmount
    enriched.Total_Net_Amount = totalNetAmount
    enriched.Amount = totalNetAmount
  }

  const startDate = text(enriched, ['TravelStartDate', 'Travel_Start_Date', 'TravelDate', 'Travel_Date'])
  const endDate = text(enriched, ['ExpectedReturnDate', 'Expected_Return_Date', 'ReturnDate', 'Return_Date'])
  if (startDate || endDate) {
    enriched.DurationDate = startDate && endDate ? `${startDate.slice(0, 10)} – ${endDate.slice(0, 10)}` : (startDate || endDate).slice(0, 10)
  } else if (module === 'staffClaim') {
    const dates = lines
      .map((line) => text(line, ['expenditureDate', 'ExpenditureDate', 'Expenditure_Date', 'Date']).slice(0, 10))
      .filter((value) => /^\d{4}-\d{2}-\d{2}$/.test(value))
      .sort()
    if (dates.length) enriched.DurationDate = dates[0] === dates.at(-1) ? dates[0] : `${dates[0]} – ${dates.at(-1)}`
  }

  const remaining = number(enriched, [
    'RemainingUnsettledAmount',
    'RemainingNotSettledAmount',
    'OutstandingBalance',
    'Balance',
  ])
  if (remaining > 0) enriched.RemainingUnsettledAmount = remaining

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
        division: text(mapped.raw, ['Division', 'DivisionName', 'Division_Name']),
        district: text(mapped.raw, ['District', 'DistrictName', 'District_Name']),
        branchCode: mapped.branchCode || sessionHints.branchCode,
        branchName: mapped.branchName || sessionHints.branchName,
        jobTitle: mapped.jobTitle || sessionHints.jobTitle,
        jobGrade: mapped.jobGrade || sessionHints.jobGrade,
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
