import type { AuthUser } from './auth.js'
import type { ODataRecord } from './bcClient.js'
import { fetchOData, odataString } from './bcClient.js'
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

const IMPREST_AMOUNT_KEYS = [
  'TotalNetAmount',
  'Total_Net_Amount',
  'NetAmount',
  'Net_Amount',
  'Amount',
  'TotalAmount',
  'Total_Amount',
]

const IMPREST_BALANCE_KEYS = [
  'Balance',
  'OutstandingBalance',
  'Outstanding_Balance',
]

const SURRENDER_BALANCE_LESS_KEYS = [
  'BalanceLessThisEntry',
  'Balance_Less_This_Entry',
  'Balance_Less_this_Entry',
]

const SURRENDER_CASH_AMOUNT_KEYS = [
  'CashSurrenderAmt',
  'Cash_Surrender_Amt',
  'CashSurrenderAmount',
  'Cash_Surrender_Amount',
]

function hasPositiveAmount(row: ODataRecord | Record<string, unknown>, keys: string[]) {
  return number(row, keys) > 0
}

function copyAmountIfMissing(
  target: ODataRecord,
  targetKeys: string[],
  source: ODataRecord,
  sourceKeys: string[],
) {
  if (hasPositiveAmount(target, targetKeys)) return
  const value = number(source, sourceKeys)
  if (value > 0) target[targetKeys[0]!] = value
}

function formatBcDisplayDate(value: string) {
  const raw = value.trim()
  if (!raw || raw.startsWith('0001-01-01')) return ''
  const iso = raw.slice(0, 10)
  const [year, month, day] = iso.split('-')
  if (year && month && day) return `${day}/${month}/${year}`
  return raw
}

function formatDurationDate(start: string, end: string) {
  const startText = formatBcDisplayDate(start)
  const endText = formatBcDisplayDate(end)
  if (startText && endText) return `${startText}-${endText}`
  return startText || endText
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

  const headerAmount = number(row, IMPREST_AMOUNT_KEYS)
  const linesTotal = sumLineAmounts(lines)
  const totalNetAmount = headerAmount > 0 ? headerAmount : linesTotal

  const outstandingBalance = number(row, [...IMPREST_BALANCE_KEYS, ...SURRENDER_BALANCE_LESS_KEYS])
  const balanceLessThisEntry = number(row, SURRENDER_BALANCE_LESS_KEYS)
  const cashSurrenderAmount = number(row, SURRENDER_CASH_AMOUNT_KEYS)
  const totalExpenditure = number(row, ['TotalExpenditure', 'Total_Expenditure'])
  const surrenderStatus = text(row, ['SurrenderStatus', 'Surrender_Status'])
  const travelDestination = text(row, [
    'TravelDestination',
    'Travel_Destination',
    'Destination',
    'DestinationCode',
    'Destination_Code',
  ])
  const travelDate = text(row, ['TravelDate', 'Travel_Date', 'StartDate', 'Start_Date'])
  const returnDate = text(row, ['ReturnDate', 'Return_Date', 'EndDate', 'End_Date'])
  const jobTitle = text(row, ['JobTitle', 'Job_Title', 'JobTitleDescription', 'Job_Title_Description'])

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
  if (totalNetAmount > 0) {
    enriched.TotalNetAmount = totalNetAmount
    if (!hasPositiveAmount(enriched, ['Amount'])) enriched.Amount = totalNetAmount
  }
  if (jobTitle) enriched.JobTitle = jobTitle
  if (travelDestination) {
    enriched.TravelDestination = travelDestination
    enriched.Destination = travelDestination
  }
  if (travelDate) enriched.TravelDate = travelDate
  if (returnDate) enriched.ReturnDate = returnDate
  if (travelDate || returnDate) {
    enriched.DurationDate = formatDurationDate(travelDate, returnDate)
  }
  if (outstandingBalance > 0) enriched.Balance = outstandingBalance
  if (balanceLessThisEntry > 0) {
    enriched.BalanceLessThisEntry = balanceLessThisEntry
    enriched.Balance_Less_this_Entry = balanceLessThisEntry
  }
  if (cashSurrenderAmount > 0) {
    enriched.CashSurrenderAmt = cashSurrenderAmount
    enriched.Cash_Surrender_Amt = cashSurrenderAmount
  }
  if (totalExpenditure > 0) enriched.TotalExpenditure = totalExpenditure
  if (surrenderStatus) enriched.SurrenderStatus = surrenderStatus
  if (module === 'imprestSurrender' && hints.jobTitle && !jobTitle) {
    enriched.JobTitle = hints.jobTitle
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

async function fetchSourceImprestHeader(imprestNo: string) {
  const filter = `No eq '${odataString(imprestNo)}'`
  const services = ['QyImprestHeader', 'QyPaymentsHeader']
  for (const service of services) {
    try {
      const rows = (await fetchOData(service, { $filter: filter, $top: 1 })) as ODataRecord[] | null
      if (Array.isArray(rows) && rows[0]) return rows[0]
    } catch {
      // try the next published BC service
    }
  }
  return null
}

/** Pull travel dates, destination and balance from the source imprest when surrender header fields are blank. */
export async function enrichImprestSurrenderFromSourceImprest(
  row: ODataRecord,
  lines: Record<string, unknown>[] = [],
) {
  const imprestNo = text(row, ['ImprestIssueDocNo', 'Imprest_Issue_Doc_No', 'ImprestNo'])
  const merged: ODataRecord = { ...row }
  const copyIfBlank = (targetKeys: string[], sourceKeys: string[], source: ODataRecord) => {
    if (text(merged, targetKeys)) return
    const value = text(source, sourceKeys)
    if (value) merged[targetKeys[0]!] = value
  }

  if (imprestNo) {
    try {
      const imprest = await fetchSourceImprestHeader(imprestNo)
      if (imprest) {
        copyIfBlank(['TravelDestination', 'Destination'], [
          'TravelDestination',
          'Travel_Destination',
          'Destination',
          'DestinationCode',
        ], imprest)
        copyIfBlank(['TravelDate'], ['TravelDate', 'Travel_Date', 'StartDate'], imprest)
        copyIfBlank(['ReturnDate'], ['ReturnDate', 'Return_Date', 'EndDate'], imprest)
        copyAmountIfMissing(merged, ['TotalNetAmount'], imprest, IMPREST_AMOUNT_KEYS)
        copyAmountIfMissing(merged, ['Amount'], imprest, IMPREST_AMOUNT_KEYS)
        copyAmountIfMissing(merged, ['Balance'], imprest, IMPREST_BALANCE_KEYS)
        copyAmountIfMissing(merged, ['BalanceLessThisEntry'], imprest, SURRENDER_BALANCE_LESS_KEYS)
        copyAmountIfMissing(
          merged,
          ['Balance_Less_this_Entry'],
          imprest,
          SURRENDER_BALANCE_LESS_KEYS,
        )
        copyIfBlank(['JobTitle'], ['JobTitle', 'Job_Title', 'JobGrade', 'Job_Grade'], imprest)
        copyIfBlank(['PlaceofDuty', 'PlaceOfDuty'], ['PlaceofDuty', 'PlaceOfDuty', 'DutyArea'], imprest)
        copyIfBlank(['Purpose', 'ImpPurpose'], ['Purpose', 'Description', 'ImpPurpose'], imprest)
      }
    } catch {
      // keep the surrender row as-is when BC lookup fails
    }
  }

  const linesTotal = sumLineAmounts(lines)
  copyAmountIfMissing(merged, ['TotalNetAmount'], merged, IMPREST_AMOUNT_KEYS)
  if (!hasPositiveAmount(merged, IMPREST_AMOUNT_KEYS) && linesTotal > 0) {
    merged.TotalNetAmount = linesTotal
    merged.Amount = linesTotal
  }

  const travelDate = text(merged, ['TravelDate', 'Travel_Date'])
  const returnDate = text(merged, ['ReturnDate', 'Return_Date'])
  if (travelDate || returnDate) {
    merged.DurationDate = formatDurationDate(travelDate, returnDate)
  }
  return merged
}
