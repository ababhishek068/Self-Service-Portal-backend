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
  'TotalPaymentAmount',
  'Total_Payment_Amount',
  'CommittedAmount',
  'Committed_Amount',
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
    ['GlobalDimension1Code', 'Department', 'DepartmentCode', 'Department_Code'],
    hints.departmentCode ?? '',
  )

  const departmentName = text(
    row,
    ['DepartmentName', 'Department_Name'],
    hints.departmentName ?? '',
  )

  const division = text(
    row,
    ['Division', 'DivisionName', 'Division_Name'],
    hints.division ?? '',
  )

  const district = text(
    row,
    ['District', 'DistrictName', 'District_Name'],
    hints.district ?? '',
  )

  const branchName = text(row, ['BranchName', 'Branch_Name'], hints.branchName ?? '')
  const branchCode = text(
    row,
    ['BranchCode', 'Branch_Code', 'ShortcutDimension3Code'],
    hints.branchCode ?? '',
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
  const dateRequired = text(row, [
    'DateRequired',
    'Date_Required',
    'PaymentReleaseDate',
    'Payment_Release_Date',
    'Date',
  ])
  const travelDestination = text(row, [
    'TravelDestination',
    'Travel_Destination',
    'Destination',
    'DestinationCode',
    'Destination_Code',
  ])
  const travelDate = text(row, [
    'TravelStartDate',
    'Travel_Start_Date',
    'TravelDate',
    'Travel_Date',
    'StartDate',
    'Start_Date',
  ])
  const returnDate = text(row, [
    'ExpectedReturnDate',
    'Expected_Return_Date',
    'ReturnDate',
    'Return_Date',
    'EndDate',
    'End_Date',
  ])
  const jobTitle = text(row, ['JobTitle', 'Job_Title', 'JobTitleDescription', 'Job_Title_Description'])
  const jobGrade = text(row, [
    'JobGrade',
    'Job_Grade',
    'JobGradeCode',
    'Grade',
    'GradeCode',
    'SalaryGrade',
    'CurrentSalaryGrade',
  ], hints.jobGrade ?? '')

  const enriched: ODataRecord = { ...row }
  if (dateRequired) {
    enriched.DateRequired = dateRequired
    enriched.PaymentReleaseDate = dateRequired
  }
  if (departmentCode) {
    enriched.Department = departmentCode
    enriched.GlobalDimension1Code = departmentCode
  }
  if (departmentName) enriched.DepartmentName = departmentName
  if (division) enriched.Division = division
  if (district) enriched.District = district
  if (branchName) enriched.BranchName = branchName
  if (branchCode) enriched.BranchCode = branchCode
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
  if (jobGrade) enriched.JobGrade = jobGrade
  if (travelDestination) {
    enriched.TravelDestination = travelDestination
    enriched.Destination = travelDestination
  } else if (lines.length > 0) {
    const lineDestination = text(lines[0] as ODataRecord, [
      'destination',
      'Destination',
      'DestinationCode',
      'Destination_Code',
    ])
    if (lineDestination) {
      enriched.TravelDestination = lineDestination
      enriched.Destination = lineDestination
    }
  }
  if (travelDate) {
    enriched.TravelDate = travelDate
    enriched.TravelStartDate = travelDate
  }
  if (returnDate) {
    enriched.ReturnDate = returnDate
    enriched.ExpectedReturnDate = returnDate
  }
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
  if (module === 'imprest' && hints.jobTitle && !jobTitle) {
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
        departmentName:
          text(emp, ['DepartmentName', 'Department_Name']) ||
          mapped.departmentName ||
          sessionHints.departmentName,
        division: text(emp, ['Division', 'DivisionName', 'Division_Name']),
        district: text(emp, ['District', 'DistrictName', 'District_Name']),
        branchCode:
          text(emp, ['BranchCode', 'Branch_Code', 'GlobalDimension3Code', 'ShortcutDimension3Code']) ||
          authUser.branchCode,
        branchName: text(emp, ['BranchName', 'Branch_Name']) || authUser.branchName,
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

async function fetchMergedSourceImprest(imprestNo: string): Promise<ODataRecord> {
  const escaped = odataString(imprestNo)
  const lookups = [
    { service: 'QyImprestHeader', filter: `No eq '${escaped}'` },
    { service: 'QyPaymentsHeader', filter: `No eq '${escaped}'` },
    { service: 'QyPaymentsHeader', filter: `ImprestNo eq '${escaped}'` },
  ]
  const parts: ODataRecord[] = []
  for (const lookup of lookups) {
    try {
      const rows = (await fetchOData(lookup.service, {
        $filter: lookup.filter,
        $top: 1,
      })) as ODataRecord[] | null
      if (Array.isArray(rows) && rows[0]) parts.push(rows[0])
    } catch {
      // try the next published BC service
    }
  }
  const merged: ODataRecord = {}
  for (const row of parts) {
    for (const [key, value] of Object.entries(row)) {
      if (value === undefined || value === null) continue
      if (typeof value === 'string' && value.trim() === '') continue
      merged[key] = value
    }
  }
  return merged
}

async function fetchImprestLinesForNo(imprestNo: string) {
  try {
    const rows = (await fetchOData('QyImprestLines', {
      $filter: `No eq '${odataString(imprestNo)}'`,
    })) as ODataRecord[] | null
    return Array.isArray(rows) ? (rows as Record<string, unknown>[]) : []
  } catch {
    return []
  }
}

/** @deprecated use fetchMergedSourceImprest */
async function fetchSourceImprestHeader(imprestNo: string) {
  return fetchMergedSourceImprest(imprestNo)
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
      const imprest = await fetchMergedSourceImprest(imprestNo)
      if (Object.keys(imprest).length > 0) {
        copyIfBlank(['TravelDestination', 'Destination'], [
          'TravelDestination',
          'Travel_Destination',
          'Destination',
          'DestinationCode',
        ], imprest)
        copyIfBlank(
          ['TravelDate', 'TravelStartDate'],
          ['TravelStartDate', 'Travel_Start_Date', 'TravelDate', 'Travel_Date', 'StartDate'],
          imprest,
        )
        copyIfBlank(
          ['ReturnDate', 'ExpectedReturnDate'],
          ['ExpectedReturnDate', 'Expected_Return_Date', 'ReturnDate', 'Return_Date', 'EndDate'],
          imprest,
        )
        copyIfBlank(
          ['DateRequired', 'PaymentReleaseDate'],
          [
            'DateRequired',
            'Date_Required',
            'PaymentReleaseDate',
            'Payment_Release_Date',
            'Date',
          ],
          imprest,
        )
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
        copyIfBlank(['JobTitle'], ['JobTitle', 'Job_Title', 'JobTitleDescription'], imprest)
        copyIfBlank(['JobGrade'], ['JobGrade', 'Job_Grade', 'Grade', 'SalaryGrade'], imprest)
        copyIfBlank(['Division'], ['Division', 'DivisionName'], imprest)
        copyIfBlank(['District'], ['District', 'GlobalDimension2Code', 'ShortcutDimension2Code'], imprest)
        copyIfBlank(
          ['DepartmentName', 'Department'],
          ['DepartmentName', 'Department_Name', 'ShortcutDimension2Code', 'GlobalDimension1Code'],
          imprest,
        )
        copyIfBlank(['PlaceofDuty', 'PlaceOfDuty'], ['PlaceofDuty', 'PlaceOfDuty', 'DutyArea'], imprest)
        copyIfBlank(['Purpose', 'ImpPurpose'], ['Purpose', 'Description', 'ImpPurpose', 'PaymentNarration'], imprest)
        copyIfBlank(['ResponsibilityCenter'], ['ResponsibilityCenter', 'Responsibility_Center'], imprest)
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

  const travelDate = text(merged, ['TravelDate', 'TravelStartDate', 'Travel_Date', 'Travel_Start_Date'])
  const returnDate = text(merged, ['ReturnDate', 'ExpectedReturnDate', 'Return_Date', 'Expected_Return_Date'])
  if (travelDate || returnDate) {
    merged.DurationDate = formatDurationDate(travelDate, returnDate)
  }

  // When BC OData omits Balance on posted imprest, treat the imprest amount as outstanding.
  if (!hasPositiveAmount(merged, IMPREST_BALANCE_KEYS)) {
    const imprestAmount = number(merged, IMPREST_AMOUNT_KEYS)
    if (imprestAmount > 0) merged.Balance = imprestAmount
  }

  return merged
}

/** Full imprest lookup for the surrender create preview (header + lines + employee hints). */
export async function buildImprestSurrenderPreview(imprestNo: string, authUser: AuthUser) {
  const source = await fetchMergedSourceImprest(imprestNo)
  const lines = await fetchImprestLinesForNo(imprestNo)
  const seed: ODataRecord = {
    ImprestIssueDocNo: imprestNo,
    ImprestNo: imprestNo,
    ...source,
  }
  let row = await enrichImprestSurrenderFromSourceImprest(seed, lines)
  row = await enrichFinanceHeaderFromEmployee('imprestSurrender', row, authUser, lines)
  return row
}
