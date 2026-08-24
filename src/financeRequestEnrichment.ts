import type { AuthUser } from './auth.js'
import type { ODataRecord } from './bcClient.js'
import { fetchOData, odataString } from './bcClient.js'
import {
  fetchEmployeeCustomerAccountNo,
  fetchMergedEmployeeRecord,
  resolveEmployeeJobTitle,
  resolveEmployeeOrgDisplayFields,
} from './employeeProfile.js'
import { mapEmployee, type PortalModuleKey } from './erpMappings.js'
import { formatBcSoapDate } from './staff.js'
import {
  imprestSurrenderLineActualSpent,
  imprestSurrenderLineAmount,
  imprestSurrenderLineCashReceiptAmount,
  imprestSurrenderLineOutstanding,
} from './imprestSurrenderLines.js'

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
    // Business Central serializes an unset Date as 0001-01-01. Treat it as
    // blank so a real value from another published query/alias can win.
    if (!raw || raw.startsWith('0001-01-01')) continue
    return raw
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

function sumSurrenderCashReceiptAmounts(lines: Record<string, unknown>[]) {
  return roundMoney(
    lines.reduce(
      (sum, line) =>
        sum +
        number(line, [
          'cashReceiptAmount',
          'CashReceiptAmount',
          'Cash_Receipt_Amount',
          'Cash Receipt Amount',
          'CashSurrenderAmt',
          'Cash_Surrender_Amt',
        ]),
      0,
    ),
  )
}

function optionalNumber(
  row: ODataRecord | Record<string, unknown>,
  keys: string[],
): number | undefined {
  for (const key of keys) {
    const value = row[key]
    if (value === undefined || value === null || String(value).trim() === '') continue
    const parsed = Number(value)
    if (Number.isFinite(parsed)) return parsed
  }
  return undefined
}

function roundMoney(value: number) {
  return Math.round(value * 100) / 100
}

const SURRENDER_LINE_OUTSTANDING_KEYS = [
  'outstandingAmount',
  'OutstandingAmount',
  'Outstanding_Amount',
]

/**
 * Resolve the portion of an imprest that a surrender has not yet settled.
 * A line is settled by its accepted expenditure plus any cash receipt/refund.
 * This is intentionally calculated from the BC line values because the legacy
 * surrender header Balance fields are normal decimals and are often left at 0.
 */
export function remainingUnsettledAmount(
  lines: Record<string, unknown>[],
  fallbackAmount = 0,
) {
  if (lines.length === 0) return Math.max(0, roundMoney(fallbackAmount))

  const remaining = lines.reduce((sum, line) => {
    const outstanding = imprestSurrenderLineOutstanding(line)
    if (outstanding !== undefined) return sum + Math.max(0, outstanding)

    const issued = imprestSurrenderLineAmount(line)
    if (issued > 0) {
      const actualSpent = imprestSurrenderLineActualSpent(line)
      const cashReceipt = imprestSurrenderLineCashReceiptAmount(line)
      return sum + Math.max(0, issued - actualSpent - cashReceipt)
    }

    const explicitOutstanding = optionalNumber(line, SURRENDER_LINE_OUTSTANDING_KEYS)
    return sum + Math.max(0, explicitOutstanding ?? 0)
  }, 0)

  return roundMoney(remaining)
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

function withRemainingUnsettled(row: ODataRecord, value: number): ODataRecord {
  const remaining = Math.max(0, roundMoney(value))
  return {
    ...row,
    RemainingUnsettledAmount: remaining,
    RemainingNotSettledAmount: remaining,
    OutstandingBalance: remaining,
    Balance: remaining,
  }
}

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

/**
 * Normalize BC / portal date strings to yyyy-mm-dd for comparisons and arithmetic.
 * HB approvers use DD/MM/YYYY (06/08/2026 = 6 Aug 2026), not US M/D/Y.
 */
function normalizeFinanceBcDate(value: string) {
  const trimmed = value.trim()
  if (!trimmed || trimmed.startsWith('0001-01-01')) return ''

  const iso = /^(\d{4})-(\d{2})-(\d{2})/.exec(trimmed)
  if (iso) return `${iso[1]}-${iso[2]}-${iso[3]}`

  const normalized = trimmed.replaceAll('_', '/')
  const slash = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/.exec(normalized)
  if (slash) {
    const first = Number(slash[1])
    const second = Number(slash[2])
    const year = slash[3]
    let day: string
    let month: string
    if (first > 12) {
      day = slash[1]
      month = slash[2]
    } else if (second > 12) {
      month = slash[1]
      day = slash[2]
    } else {
      // Ambiguous d/m/y — portal display is day-first (HB).
      day = slash[1]
      month = slash[2]
    }
    return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
  }

  return formatBcSoapDate(trimmed)
}

function formatBcDisplayDate(value: string) {
  const iso = normalizeFinanceBcDate(value)
  if (!iso) return ''
  const [year, month, day] = iso.split('-')
  if (year && month && day) return `${day}/${month}/${year}`
  return value.trim()
}

function formatDurationDate(start: string, end: string) {
  const startText = formatBcDisplayDate(start)
  const endText = formatBcDisplayDate(end)
  if (startText && endText) {
    // Exact travel period for approvers, e.g. 14/07/2026 – 20/07/2026.
    // Same calendar day is shown once (single-day trip).
    if (startText === endText) return startText
    return `${startText} – ${endText}`
  }
  return startText || endText
}

function claimExpenditureDuration(lines: Record<string, unknown>[]) {
  const dates = lines
    .map((line) =>
      text(line as ODataRecord, [
        'expenditureDate',
        'ExpenditureDate',
        'Expenditure_Date',
        'Date',
      ]),
    )
    .filter(Boolean)
    .map((value) => value.slice(0, 10))
    .filter((value) => /^\d{4}-\d{2}-\d{2}$/.test(value))
    .sort()
  if (!dates.length) return { start: '', end: '' }
  return { start: dates[0]!, end: dates[dates.length - 1]! }
}

function preferredText(row: ODataRecord, keys: string[], preferred?: string) {
  const preferredValue = (preferred ?? '').trim()
  return preferredValue || text(row, keys)
}

function firstLineField(lines: Record<string, unknown>[], keys: string[]) {
  for (const line of lines) {
    const value = text(line as ODataRecord, keys)
    if (value) return value
  }
  return ''
}

function resolveFinanceDocumentEmployeeNo(row: ODataRecord) {
  return text(row, [
    'EmployeeNo',
    'StaffNo',
    'Employee_No',
    'Staff_No',
    'RequesterID',
    'Requester_ID',
    'RequestedBy',
    'Requested_By',
    'RaisedBy',
    'Raised_By',
    'ImprestHolder',
    'Imprest_Holder',
  ])
}

function looksLikeOrgCode(value: string) {
  const trimmed = value.trim()
  if (!trimmed) return false
  // Short codes like FIN / HQ / ICT — not multi-word display names.
  return trimmed.length <= 8 && !/\s/.test(trimmed)
}

function addCalendarDays(value: string, days: number) {
  const iso = normalizeFinanceBcDate(value)
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(iso)
  if (!match) return value

  const date = new Date(
    Date.UTC(Number(match[1]), Number(match[2]) - 1, Number(match[3])),
  )
  if (!Number.isFinite(date.getTime())) return value
  date.setUTCDate(date.getUTCDate() + days)
  return date.toISOString().slice(0, 10)
}

function imprestDurationDays(lines: Record<string, unknown>[]) {
  return lines.reduce((maximum, line) => {
    const days = optionalNumber(line, [
      'noOfDays',
      'NoOfDays',
      'NoofDays',
      'No_of_Days',
      'NumberOfDays',
      'Number_of_Days',
    ])
    return days && days > maximum ? Math.ceil(days) : maximum
  }, 0)
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

  const departmentCode = preferredText(
    row,
    ['GlobalDimension1Code', 'Department', 'DepartmentCode', 'Department_Code'],
    hints.departmentCode,
  )

  const departmentName = preferredText(
    row,
    ['DepartmentName', 'Department_Name'],
    hints.departmentName,
  )

  const division = preferredText(
    row,
    ['Division', 'DivisionName', 'Division_Name'],
    hints.division,
  )

  const district = preferredText(
    row,
    [
      'District',
      'DistrictName',
      'District_Name',
      'GlobalDimension2Code',
      'GlobalDimension2Name',
      'ShortcutDimension2Code',
    ],
    hints.district,
  )

  const branchName = preferredText(row, ['BranchName', 'Branch_Name'], hints.branchName)
  const branchCode = preferredText(
    row,
    ['BranchCode', 'Branch_Code', 'ShortcutDimension3Code'],
    hints.branchCode,
  )

  const responsibleCenter = preferredText(
    row,
    ['ResponsibilityCenter', 'Responsibility_Center', 'JobTitle', 'Job_Title'],
    hints.responsibleCenter || hints.jobTitle,
  )

  const lineDutyArea = firstLineField(lines, [
    'dutyArea',
    'DutyArea',
    'Duty_Area',
    'PlaceofDuty',
    'PlaceOfDuty',
    'Place_of_Duty',
  ])
  const lineJobGrade = firstLineField(lines, [
    'employeeJobGroup',
    'EmployeeJobGroup',
    'Employee_Job_Group',
    'JobGroup',
    'Job_Group',
    'jobGrade',
    'JobGrade',
    'Job_Grade',
    'Grade',
    'SalaryGrade',
    'CurrentSalaryGrade',
  ])
  const lineJobTitle = firstLineField(lines, [
    'jobTitle',
    'JobTitle',
    'Job_Title',
    'JobTitleDescription',
    'Job_Title_Description',
  ])

  const placeOfDuty = preferredText(
    row,
    ['PlaceofDuty', 'PlaceOfDuty', 'Place_of_Duty', 'DutyArea', 'Duty_Area'],
    hints.placeOfDuty || lineDutyArea,
  )

  const employeeAccountNo = preferredText(
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
    hints.accountNumber || hints.imprestNo,
  )

  const headerAmount = number(row, IMPREST_AMOUNT_KEYS)
  const linesTotal = sumLineAmounts(lines)
  const totalNetAmount = headerAmount > 0 ? headerAmount : linesTotal

  const outstandingBalance = number(row, [...IMPREST_BALANCE_KEYS, ...SURRENDER_BALANCE_LESS_KEYS])
  const balanceLessThisEntry = number(row, SURRENDER_BALANCE_LESS_KEYS)
  const headerCashSurrender = number(row, SURRENDER_CASH_AMOUNT_KEYS)
  const lineCashSurrender =
    module === 'imprestSurrender' ? sumSurrenderCashReceiptAmounts(lines) : 0
  const cashSurrenderAmount =
    headerCashSurrender > 0 ? headerCashSurrender : lineCashSurrender
  const totalExpenditure = number(row, ['TotalExpenditure', 'Total_Expenditure'])
  const surrenderStatus = text(row, ['SurrenderStatus', 'Surrender_Status'])
  const dateRequired = normalizeFinanceBcDate(
    text(row, [
      'DateRequired',
      'Date_Required',
      'PaymentReleaseDate',
      'Payment_Release_Date',
      'Date',
    ]),
  )
  const travelDestination = text(row, [
    'TravelDestination',
    'Travel_Destination',
    'Destination',
    'DestinationCode',
    'Destination_Code',
  ])
  const travelDate = normalizeFinanceBcDate(
    text(row, [
      'TravelStartDate',
      'Travel_Start_Date',
      'TravelDate',
      'Travel_Date',
      'StartDate',
      'Start_Date',
    ]),
  )
  const returnDate = normalizeFinanceBcDate(
    text(row, [
      'ExpectedReturnDate',
      'Expected_Return_Date',
      'ReturnDate',
      'Return_Date',
      'EndDate',
      'End_Date',
    ]),
  )
  const jobTitle = preferredText(
    row,
    ['JobTitle', 'Job_Title', 'JobTitleDescription', 'Job_Title_Description'],
    hints.jobTitle || lineJobTitle,
  )
  const jobGrade = preferredText(
    row,
    [
      'JobGrade',
      'Job_Grade',
      'JobGradeCode',
      'Grade',
      'GradeCode',
      'SalaryGrade',
      'CurrentSalaryGrade',
    ],
    hints.jobGrade || lineJobGrade,
  )
  const durationStart =
    travelDate || (module === 'imprest' || module === 'imprestSurrender' ? dateRequired : '')
  const durationDays =
    module === 'imprest' || module === 'imprestSurrender' ? imprestDurationDays(lines) : 0
  let durationEnd = returnDate
  // Prefer line No. of Days when BC Expected Return is blank or wrongly equals start
  // (common UAT case: Travel Date and Return Date both stamped as Date Required).
  if (durationStart && durationDays >= 1) {
    const fromLines = addCalendarDays(durationStart, durationDays - 1)
    if (
      !durationEnd ||
      durationEnd.slice(0, 10) === durationStart.slice(0, 10)
    ) {
      durationEnd = fromLines
    }
  } else if (!durationEnd && durationStart) {
    durationEnd = addCalendarDays(durationStart, 1)
  }
  if (
    durationStart &&
    durationEnd &&
    durationStart.slice(0, 10) === durationEnd.slice(0, 10)
  ) {
    // HB: start and return must not be the same calendar day for approvers.
    durationEnd = addCalendarDays(durationStart, 1)
  }

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
  if (division) {
    // Never substitute Department Name for Division — that made approvers see FIN/Finance
    // swapped. Keep the division label from HR (name preferred) and stash the code separately.
    if (looksLikeOrgCode(division)) {
      enriched.DivisionCode = division
      enriched.Division = division
      enriched.DivisionName = division
    } else {
      enriched.Division = division
      enriched.DivisionName = division
    }
  }
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
      'TravelDestination',
      'Travel_Destination',
    ])
    if (lineDestination) {
      enriched.TravelDestination = lineDestination
      enriched.Destination = lineDestination
    }
  }
  if (!placeOfDuty && lines.length > 0) {
    const lineDutyAreaFallback = firstLineField(lines, [
      'dutyArea',
      'DutyArea',
      'Duty_Area',
      'PlaceofDuty',
      'PlaceOfDuty',
    ])
    if (lineDutyAreaFallback) {
      enriched.PlaceofDuty = lineDutyAreaFallback
      enriched.PlaceOfDuty = lineDutyAreaFallback
    }
  }
  if (durationStart) {
    enriched.TravelDate = durationStart
    enriched.TravelStartDate = durationStart
  }
  if (durationEnd) {
    enriched.ReturnDate = durationEnd
    enriched.ExpectedReturnDate = durationEnd
  }
  if (durationStart || durationEnd) {
    enriched.DurationDate = formatDurationDate(durationStart, durationEnd)
  }
  // Promote line daily rate to header so approvers see job-grade rate (Excel R7).
  if (module === 'imprest' || module === 'imprestSurrender') {
    let maxDailyRate = 0
    for (const line of lines) {
      const rate = Number(
        (line as ODataRecord).dailyRate ??
          (line as ODataRecord).DailyRate ??
          (line as ODataRecord).Daily_Rate ??
          (line as ODataRecord)['Daily Rate(Amount)'] ??
          0,
      )
      if (Number.isFinite(rate) && rate > maxDailyRate) maxDailyRate = rate
    }
    if (maxDailyRate > 0) {
      enriched.DailyRate = maxDailyRate
      enriched.Daily_Rate = maxDailyRate
      enriched.DailyRateAmount = maxDailyRate
    }
  }
  if (module === 'staffClaim' && lines.length > 0 && !enriched.DurationDate) {
    const claimDuration = claimExpenditureDuration(lines)
    if (claimDuration.start || claimDuration.end) {
      enriched.TravelDate = claimDuration.start
      enriched.ReturnDate = claimDuration.end
      enriched.DurationDate = formatDurationDate(claimDuration.start, claimDuration.end)
    }
  }
  const actualReturnDate = normalizeFinanceBcDate(
    text(row, ['ActualReturnDate', 'Actual_Return_Date']),
  )
  if (actualReturnDate) {
    enriched.ActualReturnDate = actualReturnDate
    enriched.Actual_Return_Date = actualReturnDate
  }
  if (module === 'imprestSurrender' && lines.length > 0) {
    const remaining = remainingUnsettledAmount(lines, totalNetAmount)
    Object.assign(enriched, withRemainingUnsettled(enriched, remaining))
  } else if (outstandingBalance > 0) {
    enriched.Balance = outstandingBalance
  }
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
  return enriched
}

export async function enrichFinanceHeaderFromEmployee(
  module: PortalModuleKey,
  row: ODataRecord,
  authUser: AuthUser,
  lines: Record<string, unknown>[] = [],
  rawLines: Record<string, unknown>[] = [],
): Promise<ODataRecord> {
  if (!FINANCE_DETAIL_MODULES.has(module)) return row

  const documentEmployeeNo = resolveFinanceDocumentEmployeeNo(row)
  const sessionHints = financeSessionHints(authUser)
  const currentUserOwnsRequest =
    documentEmployeeNo.trim().toLowerCase() === authUser.employeeNo.trim().toLowerCase()
  // Approvers must see the requester's HR profile — never substitute the approver's
  // employee card when the finance header omits Employee No.
  const employeeNo =
    documentEmployeeNo || (currentUserOwnsRequest ? authUser.employeeNo : '')
  let hints: FinanceEnrichmentHints = currentUserOwnsRequest ? sessionHints : {}

  if (employeeNo) {
    const emp = await fetchMergedEmployeeRecord(employeeNo)
    if (emp) {
      const mapped = mapEmployee(emp)
      const org = await resolveEmployeeOrgDisplayFields(emp, sessionHints)
      const resolvedJobTitle = await resolveEmployeeJobTitle(emp, employeeNo).catch(() => '')
      const mappedJobTitle = mapped.jobTitle.trim()
      const usableMappedJobTitle =
        mappedJobTitle.includes(' ') || mappedJobTitle.length > 4 ? mappedJobTitle : ''
      hints = {
        departmentCode:
          org.departmentCode ||
          mapped.departmentCode ||
          hints.departmentCode ||
          (currentUserOwnsRequest ? sessionHints.departmentCode : ''),
        departmentName:
          org.departmentName ||
          hints.departmentName ||
          (currentUserOwnsRequest ? sessionHints.departmentName : ''),
        division: org.division || hints.division,
        district: org.district || hints.district,
        branchCode:
          org.branchCode ||
          hints.branchCode ||
          (currentUserOwnsRequest ? sessionHints.branchCode : ''),
        branchName:
          org.branchName ||
          hints.branchName ||
          (currentUserOwnsRequest ? sessionHints.branchName : ''),
        jobTitle:
          resolvedJobTitle ||
          usableMappedJobTitle ||
          hints.jobTitle ||
          (currentUserOwnsRequest ? sessionHints.jobTitle : ''),
        jobGrade:
          mapped.jobGrade ||
          hints.jobGrade ||
          (currentUserOwnsRequest ? sessionHints.jobGrade : ''),
        responsibleCenter:
          mapped.responsibleCenter ||
          hints.responsibleCenter ||
          (currentUserOwnsRequest ? sessionHints.responsibleCenter : '') ||
          resolvedJobTitle,
        placeOfDuty:
          mapped.placeOfDuty ||
          hints.placeOfDuty ||
          (currentUserOwnsRequest ? sessionHints.placeOfDuty : ''),
        accountNumber:
          mapped.accountNumber ||
          hints.accountNumber ||
          (currentUserOwnsRequest ? sessionHints.accountNumber : ''),
        imprestNo:
          hints.imprestNo || (currentUserOwnsRequest ? sessionHints.imprestNo : ''),
      }
    }
    const accountFromProfile = hints.accountNumber || (await fetchEmployeeCustomerAccountNo(employeeNo))
    if (accountFromProfile) hints = { ...hints, accountNumber: accountFromProfile }
  }

  // Use mapped portal lines for amounts; raw OData rows are only a fallback so we
  // never double-count the same surrender line (header 24k vs line 12k bug).
  const lineSource = lines.length > 0 ? lines : rawLines
  return enrichFinanceHeaderRow(module, row, hints, lineSource)
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
      if (
        typeof value === 'string' &&
        (!value.trim() || value.trim().startsWith('0001-01-01'))
      ) {
        continue
      }
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

function surrenderStatusIsFull(row: ODataRecord) {
  const status = text(row, ['SurrenderStatus', 'Surrender_Status']).toLowerCase()
  return status === 'full' || status === 'fully surrendered' || status === 'complete'
}

function surrenderHeaderSortValue(row: ODataRecord) {
  return text(row, [
    'SystemModifiedAt',
    'System_Modified_At',
    'SurrenderDate',
    'Surrender_Date',
    'DatePosted',
    'Date_Posted',
  ])
}

async function fetchLatestSurrenderForImprest(imprestNo: string) {
  const rows = (await fetchOData('QyImprestSurrenderHeader', {
    $filter: `ImprestIssueDocNo eq '${odataString(imprestNo)}'`,
    $top: 100,
  }).catch(() => [])) as ODataRecord[] | null

  const activeRows = (Array.isArray(rows) ? rows : []).filter(
    (row) => !/cancel/i.test(text(row, ['Status'])),
  )
  const header = activeRows
    .toSorted((left, right) =>
      surrenderHeaderSortValue(right).localeCompare(surrenderHeaderSortValue(left)),
    )[0]
  if (!header) return null

  const surrenderNo = text(header, ['No', 'DocumentNo', 'Document_No'])
  const lines = surrenderNo
    ? ((await fetchOData('QyImprestSurrenderLines', {
        $filter: `SurrenderDocNo eq '${odataString(surrenderNo)}'`,
        $top: 1000,
      }).catch(() => [])) as ODataRecord[] | null)
    : []

  return {
    header,
    lines: Array.isArray(lines) ? (lines as Record<string, unknown>[]) : [],
  }
}

/**
 * Add a requester's real remaining settlement amount to a posted imprest.
 * Full surrenders are zero; partial surrenders are calculated from the latest
 * BC surrender lines; an issued imprest with no surrender remains fully open.
 */
export async function enrichImprestRemainingSettlement(row: ODataRecord) {
  const imprestNo = text(row, ['No', 'ImprestNo', 'DocumentNo', 'Document_No'])
  const amount = number(row, IMPREST_AMOUNT_KEYS)

  if (surrenderStatusIsFull(row)) return withRemainingUnsettled(row, 0)
  if (!imprestNo) return row

  try {
    const surrender = await fetchLatestSurrenderForImprest(imprestNo)
    if (surrender) {
      if (surrenderStatusIsFull(surrender.header)) return withRemainingUnsettled(row, 0)
      if (surrender.lines.length > 0) {
        return withRemainingUnsettled(
          row,
          remainingUnsettledAmount(surrender.lines, amount),
        )
      }
      const headerRemaining = number(surrender.header, [
        ...SURRENDER_BALANCE_LESS_KEYS,
        ...IMPREST_BALANCE_KEYS,
      ])
      if (headerRemaining > 0) return withRemainingUnsettled(row, headerRemaining)
    }
  } catch {
    // Keep the original imprest readable when the settlement query is unavailable.
  }

  const postedValue = row.Posted ?? row.posted
  const isPosted =
    postedValue === true ||
    postedValue === 1 ||
    ['true', 'yes', '1'].includes(String(postedValue ?? '').trim().toLowerCase())
  return isPosted && amount > 0 ? withRemainingUnsettled(row, amount) : row
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
          ['ActualReturnDate', 'Actual_Return_Date'],
          ['ActualReturnDate', 'Actual_Return_Date'],
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

  const travelDate = normalizeFinanceBcDate(
    text(merged, ['TravelDate', 'TravelStartDate', 'Travel_Date', 'Travel_Start_Date']),
  )
  const returnDate = normalizeFinanceBcDate(
    text(merged, ['ReturnDate', 'ExpectedReturnDate', 'Return_Date', 'Expected_Return_Date']),
  )
  const actualReturnDate = normalizeFinanceBcDate(
    text(merged, ['ActualReturnDate', 'Actual_Return_Date']),
  )
  if (travelDate || returnDate) {
    let durationEnd = actualReturnDate || returnDate
    if (travelDate && durationEnd && travelDate === durationEnd) {
      durationEnd = addCalendarDays(travelDate, 1)
    }
    if (travelDate) {
      merged.TravelDate = travelDate
      merged.TravelStartDate = travelDate
    }
    if (durationEnd) {
      merged.ReturnDate = durationEnd
      merged.ExpectedReturnDate = durationEnd
    }
    merged.DurationDate = formatDurationDate(travelDate, durationEnd)
  }

  const imprestAmount = number(merged, IMPREST_AMOUNT_KEYS)
  if (surrenderStatusIsFull(merged)) {
    Object.assign(merged, withRemainingUnsettled(merged, 0))
  } else if (lines.length > 0) {
    Object.assign(
      merged,
      withRemainingUnsettled(
        merged,
        remainingUnsettledAmount(lines, imprestAmount),
      ),
    )
  } else {
    // When BC OData omits its legacy Balance fields, the selected imprest is
    // still fully outstanding until the requester enters surrender values.
    const explicitBalance = number(merged, [
      ...SURRENDER_BALANCE_LESS_KEYS,
      ...IMPREST_BALANCE_KEYS,
    ])
    if (explicitBalance > 0 || imprestAmount > 0) {
      Object.assign(
        merged,
        withRemainingUnsettled(merged, explicitBalance || imprestAmount),
      )
    }
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
