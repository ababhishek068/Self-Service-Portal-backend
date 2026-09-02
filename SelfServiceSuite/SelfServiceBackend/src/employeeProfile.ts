import { config } from './config.js'
import {
  callSoapMethod,
  configuredODataBases,
  fetchODataFirstBase,
  fetchODataFromBase,
  fetchODataMetadata,
  odataString,
  type ODataRecord,
} from './bcClient.js'

const EMPLOYEE_ODATA_SERVICES = [
  'QyHREmployee',
  'QyPREmployee',
  'EmployeeCard',
  'Employee_Card',
  'QyEmployeeCard',
  'QyHREmployeeCard',
  'HREmployeeCard',
  'Employee',
  'QyEmployee',
  'Employee_List',
  'QyEmployee_List',
  'HREmployee_List',
  'Staff',
  'QyStaff',
]

const JOB_ODATA_SERVICES = [
  'QyHRJob',
  'QyJob',
  'QyHRJobs',
  'QyJobTitle',
  'QyHRJobTitle',
  'QyJobTitles',
  'QyHRJobTitles',
  'QyHRJobTitleList',
  'QyHRJob_List',
  'QyJob_List',
  'Job_List',
  'QyPosition',
  'QyHRPosition',
  'QyPositions',
  'Job',
  'JobTitles',
  'HrJob',
  'QyHrJob',
]

const EMPLOYMENT_HISTORY_SERVICES = [
  'QyEmploymentHistory',
  'QyHREmploymentHistory',
  'EmploymentHistory',
  'Employment_History',
  'QyEmployment_History',
]

const JOB_CODE_FIELDS = ['Code', 'No', 'JobID', 'Job_ID', 'JobCode', 'Job_Code', 'JobNo', 'Job_No']
const EMPLOYEE_JOB_CODE_FIELDS = [
  'JobID',
  'Job_ID',
  'JobCode',
  'Job_Code',
  'JobNo',
  'Job_No',
  'CurrentJobID',
  'Current_Job_ID',
  'ActingJobID',
  'Acting_Job_ID',
]
const JOB_TITLE_FIELDS = [
  'Title',
  'Description',
  'JobTitle',
  'Job_Title',
  'JobTitleDescription',
  'Job_Title_Description',
  'Name',
  'Position',
  'Job',
]

let jobCatalogCache: { expiresAt: number; rows: Array<{ code: string; title: string }> } | null = null
const entitySetCache = new Map<string, { expiresAt: number; names: string[] }>()

export function employeeFieldText(record: Record<string, unknown>, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = record[key]
    if (value !== undefined && value !== null && String(value).trim()) return String(value).trim()
  }
  return fallback
}

/**
 * ABH employee card: Global Dimension 1 = Division, Global Dimension 2 = Department,
 * Location/Division Code = District, Branch Name = branch. Do not treat GD1 as department
 * or GD2 as branch — that swapped Zerihun to Department = Finance and Admin / District = IT.
 */
export function mapAbhEmployeeOrg(record: Record<string, unknown>) {
  const divisionCode = employeeFieldText(record, ['GlobalDimension1Code', 'Division', 'Global_Dimension_1_Code'])
  const divisionName = employeeFieldText(
    record,
    ['DivisionName', 'Division_Name', 'GlobalDimension1Name', 'Global_Dimension_1_Name'],
    divisionCode,
  )
  const departmentCode = employeeFieldText(record, [
    'GlobalDimension2Code',
    'Global_Dimension_2_Code',
    'DepartmentCode',
    'Department_Code',
  ])
  let departmentName = employeeFieldText(record, [
    'GlobalDimension2Name',
    'Global_Dimension_2_Name',
    'DepartmentName',
    'Department_Name',
  ], departmentCode)
  if (
    departmentName &&
    divisionName &&
    departmentName.toLowerCase() === divisionName.toLowerCase() &&
    departmentCode &&
    departmentCode.toLowerCase() !== divisionCode.toLowerCase()
  ) {
    departmentName = employeeFieldText(record, ['GlobalDimension2Name', 'Global_Dimension_2_Name'], departmentCode)
  }
  const district = employeeFieldText(record, [
    'DistrictName',
    'District_Name',
    'DistrictCode',
    'LocationDivisionCode',
    'Location_Division_Code',
    'District',
    'GlobalDimension3Name',
    'Global_Dimension_3_Name',
    'GlobalDimension3Code',
    'Global_Dimension_3_Code',
  ])
  const branchName = employeeFieldText(record, [
    'BranchName',
    'Branch_Name',
    'BranchDisplayName',
    'Branch_Display_Name',
  ])
  const responsibilityCenter = employeeFieldText(record, [
    'ResponsibilityCenter',
    'Responsibility_Center',
  ])
  const resolvedBranch =
    branchName ||
    (/head\s*office|^ho$/i.test(responsibilityCenter) ? 'Head Office' : '') ||
    (district ? '' : 'Head Office')
  return {
    divisionCode,
    divisionName,
    departmentCode,
    departmentName,
    district,
    branchCode: resolvedBranch === 'Head Office' ? 'HO' : resolvedBranch,
    branchName: resolvedBranch,
    sector: employeeFieldText(record, ['SectorName', 'Sector_Name', 'Sector']),
  }
}

export const EMPLOYEE_ACCOUNT_NO_FIELDS = [
  'CustomerNo',
  'Customer_No',
  'AccountNumber',
  'Account_No',
  'Customer_Account_No',
  'CustomerAccountNo',
  'Bank_Account_No',
  'BankAccountNo',
  'Imprest_No',
  'ImprestNo',
]

export function employeeAccountNoFromRecord(record: Record<string, unknown>) {
  return employeeFieldText(record, EMPLOYEE_ACCOUNT_NO_FIELDS)
}

export const EMPLOYEE_SALARY_BASE_FIELDS = [
  'BasicSalary',
  'Basic_Salary',
  'MonthlySalary',
  'Monthly_Salary',
  'GrossSalary',
  'Gross_Salary',
  'Salary',
  'BasicPay',
  'Basic_Pay',
  'NetSalary',
  'Net_Salary',
  'Basic_Wage',
  'BasicWage',
  'Actual_Basic_Salary',
  'ActualBasicSalary',
  'Basic',
  'Earning_Basic',
  'EarningBasic',
  'Consolidated_Basic',
  'Fixed_Basic',
  'Payroll_Basic',
  'Current_Salary',
  'CurrentSalary',
  'Basic_Earnings',
  'Actual_Salary',
  'ActualSalary',
  'Starting_Salary',
  'StartingSalary',
  'Gross_Pay',
  'GrossPay',
  'Gross_Pay_Amount',
  'GrossPayAmount',
  'Pay_Amount',
  'PayAmount',
  'Salary_Amount',
  'SalaryAmount',
  'Contract_Salary',
  'ContractSalary',
  'Annual_Salary',
  'AnnualSalary',
  'Remuneration_Amount',
  'RemunerationAmount',
  'Basic_Remuneration',
  'BasicRemuneration',
  'Current_Basic_Salary',
  'CurrentBasicSalary',
]

function normalizeSalaryMagnitude(value: number, fieldKey: string) {
  if (/annual/i.test(fieldKey) && value > 50_000) return Math.round(value / 12)
  if (value > 500_000 && !/month|monthly|basic|gross|current/i.test(fieldKey)) {
    return Math.round(value / 12)
  }
  return value
}

export function employeeSalaryBaseFromRecord(record: Record<string, unknown>) {
  if (config.BC_SALARY_BASE_FIELD) {
    const configured = Number(record[config.BC_SALARY_BASE_FIELD])
    if (Number.isFinite(configured) && configured > 0) {
      return normalizeSalaryMagnitude(configured, config.BC_SALARY_BASE_FIELD)
    }
  }
  for (const key of EMPLOYEE_SALARY_BASE_FIELDS) {
    const value = record[key]
    const parsed = Number(value)
    if (Number.isFinite(parsed) && parsed > 0) {
      return normalizeSalaryMagnitude(parsed, key)
    }
  }
  for (const [key, value] of Object.entries(record)) {
    if (!/salary|basic|gross|wage|pay|earning|remuneration/i.test(key)) continue
    if (/percentage|advance|loan|deduction|tax|pension|nhif|nssf|balance|leave|count|days/i.test(key)) {
      continue
    }
    const parsed = Number(value)
    if (!Number.isFinite(parsed) || parsed <= 0) continue
    const normalized = normalizeSalaryMagnitude(parsed, key)
    if (normalized >= 1_000 && normalized <= 10_000_000) return normalized
  }
  return 0
}

const PAYROLL_EMPLOYEE_SERVICES = [
  'QyPREmployee',
  'QyPayrollEmployee',
  'PREmployee',
  'PayrollEmployee',
  'QyEmployeePayroll',
  'EmployeePayroll',
  'QyPREmployeeCard',
  'QyHRPayrollEmployee',
  'QyPayrollEmployeeCard',
  'QyEmployeeSalary',
  'EmployeeSalary',
]

function salaryLookupServices() {
  return [
    ...new Set(
      [...config.BC_SALARY_LOOKUP_SERVICE, ...PAYROLL_EMPLOYEE_SERVICES]
        .map((service) => service.trim())
        .filter(Boolean),
    ),
  ]
}

function employeeLookupFilters(employeeNo: string) {
  const trimmed = employeeNo.trim()
  if (!trimmed) return []
  const quoted = odataString(trimmed)
  return [
    `No eq '${quoted}'`,
    `Employee_No eq '${quoted}'`,
    `EmployeeNo eq '${quoted}'`,
    `Staff_No eq '${quoted}'`,
    `StaffNo eq '${quoted}'`,
  ]
}

function customerLookupFilters(customerNo: string) {
  const trimmed = customerNo.trim()
  if (!trimmed) return []
  const quoted = odataString(trimmed)
  return [
    `CustomerNo eq '${quoted}'`,
    `Customer_No eq '${quoted}'`,
    `No eq '${quoted}'`,
  ]
}

async function fetchPayrollEmployeeRecords(employeeNo: string): Promise<ODataRecord[]> {
  const filters = employeeLookupFilters(employeeNo)
  if (filters.length === 0) return []

  const records: ODataRecord[] = []
  for (const base of odataBases()) {
    for (const service of salaryLookupServices()) {
      for (const filter of filters) {
        const rows = (await fetchODataFromBase(base, service, { $filter: filter, $top: 1 }).catch(
          () => null,
        )) as ODataRecord[] | null
        if (Array.isArray(rows) && rows.length > 0) records.push(rows[0]!)
      }
    }
  }
  return records
}

async function fetchPayrollEmployeeRecordsByCustomerNo(customerNo: string): Promise<ODataRecord[]> {
  const filters = customerLookupFilters(customerNo)
  if (filters.length === 0) return []

  const records: ODataRecord[] = []
  for (const base of odataBases()) {
    for (const service of salaryLookupServices()) {
      for (const filter of filters) {
        const rows = (await fetchODataFromBase(base, service, { $filter: filter, $top: 1 }).catch(
          () => null,
        )) as ODataRecord[] | null
        if (Array.isArray(rows) && rows.length > 0) records.push(rows[0]!)
      }
    }
  }
  return records
}

async function resolveSalaryFromEmploymentHistory(employeeNo: string) {
  const filters = [
    `Employee_No eq '${odataString(employeeNo)}'`,
    `EmployeeNo eq '${odataString(employeeNo)}'`,
  ]
  const orderings = ['Starting_Date desc', 'Start_Date desc', 'FromDate desc', 'From_Date desc']

  for (const base of odataBases()) {
    for (const service of EMPLOYMENT_HISTORY_SERVICES) {
      for (const filter of filters) {
        for (const orderBy of orderings) {
          const history = (await fetchODataFromBase(base, service, {
            $filter: filter,
            $top: 1,
            $orderby: orderBy,
          }).catch(() => [])) as ODataRecord[] | null
          if (!Array.isArray(history) || history.length === 0) continue
          const salary = employeeSalaryBaseFromRecord(history[0] as Record<string, unknown>)
          if (salary > 0) return salary
        }
      }
    }
  }
  return 0
}

/** Best-effort monthly salary for salary-advance amount display when BC line amount is still zero. */
export async function fetchEmployeeSalaryBase(employeeNo: string) {
  const trimmed = employeeNo.trim()
  if (!trimmed) return 0

  for (const record of await fetchPayrollEmployeeRecords(trimmed)) {
    const salary = employeeSalaryBaseFromRecord(record)
    if (salary > 0) return salary
  }

  const fast = await fetchEmployeeRecordFast(trimmed)
  if (fast) {
    const fromFast = employeeSalaryBaseFromRecord(fast)
    if (fromFast > 0) return fromFast
    const enriched = await enrichEmployeeRecordFromPageBases(trimmed, fast)
    const fromEnriched = employeeSalaryBaseFromRecord(enriched)
    if (fromEnriched > 0) return fromEnriched
  }

  const fromHistory = await resolveSalaryFromEmploymentHistory(trimmed)
  if (fromHistory > 0) return fromHistory

  const merged = await fetchMergedEmployeeRecord(trimmed)
  if (merged) {
    const fromMerged = employeeSalaryBaseFromRecord(merged)
    if (fromMerged > 0) return fromMerged
  }

  return 0
}

async function fetchHREmployeeByCustomerNo(customerNo: string): Promise<ODataRecord | null> {
  const filters = customerLookupFilters(customerNo)
  if (filters.length === 0) return null

  const bases = [
    config.BC_ODATA_BASE_URL,
    config.BC_ODATA_PAGE_BASE_URL,
    config.BC_SOAP_PAGE_BASE_URL,
    derivePageODataBaseFromSoapCodeunit(config.BC_SOAP_CODEUNIT_URL),
  ]
    .filter((base): base is string => Boolean(base))
    .map((base) => normalizeBaseUrl(base))

  const services = ['QyHREmployee', 'QyHREmployeeCard', 'Employee_Card', 'EmployeeCard']
  for (const base of [...new Set(bases)]) {
    for (const service of services) {
      for (const filter of filters) {
        const rows = (await fetchODataFromBase(base, service, { $filter: filter, $top: 1 }).catch(
          () => null,
        )) as ODataRecord[] | null
        if (Array.isArray(rows) && rows.length > 0) return rows[0]!
      }
    }
  }
  return null
}

export async function fetchEmployeeSalaryBaseByCustomerNo(customerNo: string) {
  const trimmed = customerNo.trim()
  if (!trimmed) return 0

  for (const record of await fetchPayrollEmployeeRecordsByCustomerNo(trimmed)) {
    const salary = employeeSalaryBaseFromRecord(record)
    if (salary > 0) return salary
  }

  return 0
}

export async function fetchEmployeeSalaryBaseFast(
  employeeNo: string,
  hints: {
    customerNo?: string
    header?: ODataRecord
    lines?: ODataRecord[]
  } = {},
) {
  if (hints.header) {
    const fromHeader = employeeSalaryBaseFromRecord(hints.header)
    if (fromHeader > 0) return fromHeader
  }

  for (const line of hints.lines ?? []) {
    const fromLine = employeeSalaryBaseFromRecord(line)
    if (fromLine > 0) return fromLine
  }

  const fast = await fetchEmployeeRecordFast(employeeNo)
  if (fast) {
    const fromFast = employeeSalaryBaseFromRecord(fast)
    if (fromFast > 0) return fromFast
  }

  const customerNo = hints.customerNo?.trim()
  if (customerNo) {
    const fromCustomer = await fetchEmployeeSalaryBaseByCustomerNo(customerNo)
    if (fromCustomer > 0) return fromCustomer
  }

  return 0
}

export async function resolveEmployeeMonthlySalaryBase(
  employeeNo: string,
  hints: { customerNo?: string; existing?: number } = {},
) {
  const existing = Number(hints.existing ?? 0)
  if (Number.isFinite(existing) && existing > 0) return existing
  return fetchEmployeeSalaryBaseForAdvance(employeeNo, { customerNo: hints.customerNo })
}

export async function fetchEmployeeSalaryBaseForAdvance(
  employeeNo: string,
  hints: {
    customerNo?: string
    header?: ODataRecord
    lines?: ODataRecord[]
  } = {},
  options: { fast?: boolean } = {},
) {
  if (options.fast) {
    return fetchEmployeeSalaryBaseFast(employeeNo, hints)
  }

  if (hints.header) {
    const fromHeader = employeeSalaryBaseFromRecord(hints.header)
    if (fromHeader > 0) return fromHeader
  }

  for (const line of hints.lines ?? []) {
    const fromLine = employeeSalaryBaseFromRecord(line)
    if (fromLine > 0) return fromLine
  }

  const fromEmployee = await fetchEmployeeSalaryBase(employeeNo)
  if (fromEmployee > 0) return fromEmployee

  const customerNo = hints.customerNo?.trim()
  if (customerNo) {
    const fromCustomer = await fetchEmployeeSalaryBaseByCustomerNo(customerNo)
    if (fromCustomer > 0) return fromCustomer

    const hrEmployee = await fetchHREmployeeByCustomerNo(customerNo)
    if (hrEmployee) {
      const fromHr = employeeSalaryBaseFromRecord(hrEmployee)
      if (fromHr > 0) return fromHr
    }
  }

  const merged = await fetchMergedEmployeeRecord(employeeNo)
  if (merged) {
    const fromMerged = employeeSalaryBaseFromRecord(merged)
    if (fromMerged > 0) return fromMerged
  }

  return 0
}

const DIMENSION_SERVICES = ['QyDimensionValues', 'DimensionValue', 'Dimension_Values']
const DIMENSION_LIST_FILTERS = [
  // ABH query 50036 publishes column Global_Dimension_No_ with the trailing
  // underscore. Keep this first so the normal UAT lookup succeeds immediately.
  'Global_Dimension_No_ eq 2',
  "Dimension_Code eq 'DEPARTMENT'",
  "DimensionCode eq 'DEPARTMENT'",
  "Dimension_Code eq 'DEPARTMENTS'",
  "DimensionCode eq 'DEPARTMENTS'",
  "Auxiliary_Index_1 eq 'DEPART/DIST'",
  "AuxiliaryIndex1 eq 'DEPART/DIST'",
  'Global_Dimension_No eq 2',
  'GlobalDimensionNo eq 2',
]

const DEPARTMENT_PAGE_CODE_KEYS = [
  'Department_Code',
  'DepartmentCode',
  'Department_x0020_Code',
  'Code',
]

const DEPARTMENT_PAGE_NAME_KEYS = [
  'Department_Name',
  'DepartmentName',
  'Department_x0020_Name',
  'Name',
]

const DIMENSION_CODE_KEYS = [
  'Code',
  'Code_',
  'GlobalDimension2Code',
  'Global_Dimension_2_Code',
]

const DIMENSION_GLOBAL_NO_KEYS = [
  'Global_Dimension_No_',
  'GlobalDimensionNo',
  'Global_Dimension_No',
  'Global_x0020_Dimension_x0020_No_x002e_',
]

function dimensionRowText(row: ODataRecord, keys: string[]) {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') {
      return String(value).trim()
    }
  }
  return ''
}

/** Identify department rows when BC cannot filter the published dimension query. */
export function isRequestingDepartmentDimensionRow(row: ODataRecord) {
  const dimensionCode = dimensionRowText(row, [
    'Dimension_Code',
    'DimensionCode',
    'Auxiliary_Index_1',
    'AuxiliaryIndex1',
  ]).toUpperCase()
  if (['DEPARTMENT', 'DEPARTMENTS', 'DEPART/DIST'].includes(dimensionCode)) return true

  const globalDimensionNo = Number(dimensionRowText(row, DIMENSION_GLOBAL_NO_KEYS))
  return Number.isFinite(globalDimensionNo) && globalDimensionNo === 2
}

/** Match a dimension OData row to a human label or code (for tests and lookup). */
export function pickDimensionCodeFromRow(row: ODataRecord, label: string, maxLen = 20) {
  const normalized = label.trim().toLowerCase()
  if (!normalized) return ''
  const code = dimensionRowText(row, ['Code', 'Code_', 'GlobalDimension2Code'])
  const name = dimensionRowText(row, ['Name', 'Description', 'Dimension_Value_Name'])
  if (!code || code.length > maxLen) return ''
  if (name.toLowerCase() === normalized) return code
  if (code.toLowerCase() === normalized) return code
  return ''
}

async function fetchDimensionRows(filter: string, top = 1) {
  for (const base of odataBases()) {
    for (const service of DIMENSION_SERVICES) {
      const query: Record<string, unknown> = { $top: top }
      if (filter.trim()) query.$filter = filter
      const rows = (await fetchODataFromBase(base, service, query).catch(
        () => null,
      )) as ODataRecord[] | null
      if (Array.isArray(rows) && rows.length > 0) return rows
    }
  }
  return [] as ODataRecord[]
}

async function scanDimensionListForLabel(label: string, maxLen = 20) {
  for (const listFilter of DIMENSION_LIST_FILTERS) {
    const rows = await fetchDimensionRows(listFilter, 500)
    for (const row of rows) {
      const code = pickDimensionCodeFromRow(row, label, maxLen)
      if (code) return code
    }
  }
  return ''
}

function dimensionNameFilters(label: string) {
  const escaped = odataString(label)
  const scoped = [
    `Name eq '${escaped}' and Dimension_Code eq 'DEPARTMENT'`,
    `Name eq '${escaped}' and DimensionCode eq 'DEPARTMENT'`,
    `Name eq '${escaped}' and Dimension_Code eq 'DEPARTMENTS'`,
    `Name eq '${escaped}' and DimensionCode eq 'DEPARTMENTS'`,
    `Name eq '${escaped}' and Auxiliary_Index_1 eq 'DEPART/DIST'`,
    `Name eq '${escaped}' and AuxiliaryIndex1 eq 'DEPART/DIST'`,
    `Description eq '${escaped}' and Dimension_Code eq 'DEPARTMENT'`,
    `Description eq '${escaped}' and Dimension_Code eq 'DEPARTMENTS'`,
    `Description eq '${escaped}' and Auxiliary_Index_1 eq 'DEPART/DIST'`,
  ]
  return [
    ...scoped,
    `Name eq '${escaped}'`,
    `Description eq '${escaped}'`,
    `Code eq '${escaped}'`,
  ]
}

async function resolveDimensionCodeByName(name: string, maxLen = 20) {
  const trimmed = name.trim()
  if (!trimmed) return ''
  if (trimmed.length <= maxLen && !trimmed.includes(' ')) {
    const byCode = await fetchDimensionRows(`Code eq '${odataString(trimmed)}'`, 1)
    if (byCode.length > 0) {
      const code = dimensionRowText(byCode[0]!, ['Code', 'Code_'])
      if (code && code.length <= maxLen) return code
    }
  }

  for (const filter of dimensionNameFilters(trimmed)) {
    const rows = await fetchDimensionRows(filter, 1)
    if (rows.length === 0) continue
    const code = pickDimensionCodeFromRow(rows[0]!, trimmed, maxLen)
    if (code) return code
    // Only trust an unverified first row when BC gave us no name to check it
    // against. Taking the code regardless books the document against whatever
    // department happened to sort first.
    const rowName = dimensionRowText(rows[0]!, ['Name', 'Description', 'Dimension_Value_Name'])
    if (rowName) continue
    const fallback = dimensionRowText(rows[0]!, ['Code', 'Code_'])
    if (fallback && fallback.length <= maxLen) return fallback
  }

  const scanned = await scanDimensionListForLabel(trimmed, maxLen)
  if (scanned) return scanned

  return ''
}

/** Resolve department/branch codes that fit BC Code[20] fields on finance documents. */
export async function resolveEmployeeDimensionCodesForSoap(
  employeeNo: string,
  hints: { department?: string; branchCode?: string } = {},
) {
  const emp = await fetchEmployeeRecordFast(employeeNo)
  const departmentRaw = String(
    emp?.GlobalDimension2Code ?? emp?.DepartmentCode ?? emp?.Department ?? hints.department ?? '',
  ).trim()
  const branchRaw = String(
    emp?.BranchCode ?? emp?.BranchName ?? emp?.Branch ?? hints.branchCode ?? '',
  ).trim()

  const departmentCode = await resolveDimensionCodeByName(departmentRaw)
  const branchCode = branchRaw.length <= 20 ? branchRaw : ''

  return { departmentCode, branchCode }
}

/**
 * Before finance documents (claims, etc.), ensure the employee's Global Dimension 2
 * department can be resolved to the Code[20] expected by SOAP.
 */
function firstEmployeeFieldText(
  record: ODataRecord | null | undefined,
  keys: string[],
) {
  if (!record) return ''
  return employeeFieldText(record, keys)
}
async function resolveDimensionCodeCandidate(raw: string, maxLen = 20) {
  const trimmed = raw.trim()
  if (!trimmed) return ''
  // Anything short enough to BE a Code[20] gets a direct code lookup first —
  // including codes with spaces. Skipping that fast path pushed spaced codes
  // through a dozen name-shaped filters before finding the same row.
  if (trimmed.length <= maxLen) {
    const byCode = await fetchDimensionRows(`Code eq '${odataString(trimmed)}'`, 1)
    if (byCode.length > 0) {
      const code = dimensionRowText(byCode[0]!, ['Code', 'Code_'])
      if (code && code.length <= maxLen) return code
    }
  }
  const byName = await resolveDimensionCodeByName(trimmed, maxLen)
  if (byName) return byName

  // Last resort: the Departments master (table 50935) can carry codes that are
  // not published as Dimension Values. Match by code OR label, then hand the
  // code to BC (AL ValidateTableRelation=false on Purchase Header.Department).
  if (trimmed.length <= maxLen) {
    const departments = await fetchRequestingDepartmentOptions().catch(() => [])
    const exact = departments.find((row) => row.value.toLowerCase() === trimmed.toLowerCase())
    if (exact) return exact.value
  }
  {
    const departments = await fetchRequestingDepartmentOptions().catch(() => [])
    const byLabel = departments.find((row) => row.label.toLowerCase() === trimmed.toLowerCase())
    if (byLabel?.value && byLabel.value.length <= maxLen) return byLabel.value
  }
  return ''
}

function isDepartmentPageLevel(row: ODataRecord) {
  const level = dimensionRowText(row, ['level', 'Level'])
  if (!level) return true
  const normalized = level.trim().toLowerCase()
  return normalized === 'department' || normalized === '0'
}

function inferDepartmentCodeFromRow(row: ODataRecord) {
  const direct = dimensionRowText(row, DEPARTMENT_PAGE_CODE_KEYS)
  if (direct) return direct
  for (const [key, value] of Object.entries(row)) {
    if (!/department/i.test(key) || !/code/i.test(key)) continue
    const text = String(value ?? '').trim()
    if (text && text.length <= 20) return text
  }
  return dimensionRowText(row, DIMENSION_CODE_KEYS)
}

/** All department codes for purchase/store requisition dropdowns — merged from BC masters. */
export async function fetchRequestingDepartmentOptions() {
  const byCode = new Map<string, { value: string; label: string }>()
  const add = (value: string, label: string) => {
    const code = value.trim()
    // BC Code[20] permits spaces, and ABH UAT does use codes like "FIN ADMIN".
    // Only the length cap is a real BC constraint here — rejecting spaces
    // silently emptied the whole dropdown ("No matches"). Values reaching this
    // point already came from a Code/Department Code column, not a free label.
    if (!code || code.length > 20) return
    const name = (label || code).trim()
    const previous = byCode.get(code)
    byCode.set(code, {
      value: code,
      label: previous?.label && previous.label !== code ? previous.label : name !== code ? name : code,
    })
  }

  const pageRows = await fetchODataFirstBase('PgDepartmentsList', { $top: 5000 })
  for (const row of pageRows) {
    if (!isDepartmentPageLevel(row)) continue
    const code = inferDepartmentCodeFromRow(row)
    const name = dimensionRowText(row, DEPARTMENT_PAGE_NAME_KEYS)
    if (code) add(code, name || code)
  }

  // The custom Departments page is authoritative. If it is not published,
  // fall back to Dimension Values global dimension 2 (the table relation used
  // by Departments."Department Code"). Stop at the first valid field shape so
  // one dropdown does not generate a long chain of rejected OData filters.
  if (byCode.size === 0) {
    for (const listFilter of DIMENSION_LIST_FILTERS) {
      const rows = await fetchDimensionRows(listFilter, 5000)
      for (const row of rows) {
        const code = dimensionRowText(row, DIMENSION_CODE_KEYS)
        const name = dimensionRowText(row, ['Name', 'Description', 'Dimension_Value_Name'])
        if (code) add(code, name || code)
      }
      if (byCode.size > 0) break
    }
  }

  // Last fallback: some BC publications expose the rows but reject filters on
  // their generated field names. Fetch once and apply the dimension test here.
  if (byCode.size === 0) {
    const rows = await fetchDimensionRows('', 5000)
    for (const row of rows) {
      if (!isRequestingDepartmentDimensionRow(row)) continue
      const code = dimensionRowText(row, DIMENSION_CODE_KEYS)
      const name = dimensionRowText(row, ['Name', 'Description', 'Dimension_Value_Name'])
      if (code) add(code, name || code)
    }
  }

  return [...byCode.values()].sort((a, b) => a.label.localeCompare(b.label))
}

/** Map a portal department label/code to a BC Dimension Value code (Purchase Req, etc.). */
export async function resolveRequestingDepartmentCode(raw: string, maxLen = 20) {
  return resolveDimensionCodeCandidate(String(raw ?? '').trim(), maxLen)
}


const EMPLOYEE_FINANCE_DEPARTMENT_CODE_FIELDS = [
  'GlobalDimension2Code',
  'Global_Dimension_2_Code',
  'DepartmentCode',
  'Department_Code',
  'Department',
  'ShortcutDimension2Code',
  'Shortcut_Dimension_2_Code',
]

const EMPLOYEE_FINANCE_DEPARTMENT_NAME_FIELDS = [
  'GlobalDimension2Name',
  'Global_Dimension_2_Name',
  'DepartmentName',
  'Department_Name',
]

export async function resolveFinanceDepartmentCodeForSoap(
  employeeNo: string,
  hints: { department?: string; departmentName?: string; branchCode?: string } = {},
) {
  const emp = (await fetchMergedEmployeeRecord(employeeNo)) ?? (await fetchEmployeeRecordFast(employeeNo))

  for (const key of EMPLOYEE_FINANCE_DEPARTMENT_CODE_FIELDS) {
    const resolved = await resolveDimensionCodeCandidate(firstEmployeeFieldText(emp, [key]))
    if (resolved) return resolved
  }

  for (const key of EMPLOYEE_FINANCE_DEPARTMENT_NAME_FIELDS) {
    const resolved = await resolveDimensionCodeCandidate(firstEmployeeFieldText(emp, [key]))
    if (resolved) return resolved
  }

  for (const hint of [hints.department, hints.departmentName]) {
    const resolved = await resolveDimensionCodeCandidate(String(hint ?? ''))
    if (resolved) return resolved
  }

  return ''
}

export async function ensureEmployeeDepartmentCodeForFinance(
  employeeNo: string,
  hints: { department?: string; departmentName?: string; branchCode?: string } = {},
) {
  const dims = await resolveEmployeeDimensionCodesForSoap(employeeNo, hints)
  const emp = await fetchEmployeeRecordFast(employeeNo)
  const departmentRaw = String(
    emp?.GlobalDimension2Code ?? emp?.DepartmentCode ?? emp?.Department ?? hints.department ?? '',
  ).trim()

  if (departmentRaw.length > 20 && !dims.departmentCode) {
    throw Object.assign(
      new Error(
        `Your BC employee department (${departmentRaw}) is too long and could not be mapped to a dimension code. Ask HR to fix Global Dimension 2 on employee ${employeeNo}.`,
      ),
      { status: 422, code: 'EMPLOYEE_DIMENSION_TOO_LONG' },
    )
  }

  return dims
}

/** Fast lookup for salary advance / imprest flows — page OData only when HR employee lacks account no. */
export async function fetchEmployeeCustomerAccountNo(employeeNo: string) {
  const trimmed = employeeNo.trim()
  if (!trimmed) return ''

  const fast = await fetchEmployeeRecordFast(trimmed)
  if (!fast) return ''

  const fromFast = employeeAccountNoFromRecord(fast)
  if (fromFast) return fromFast

  const enriched = await enrichEmployeeRecordFromPageBases(trimmed, fast)
  return employeeAccountNoFromRecord(enriched)
}

function normalizeFieldKey(key: string) {
  return key.toLowerCase().replace(/[_\s]/g, '')
}

function normalizeBaseUrl(value: string) {
  return value.endsWith('/') ? value : `${value}/`
}

export function derivePageODataBaseFromSoapCodeunit(soapCodeunitUrl: string) {
  const trimmed = soapCodeunitUrl.trim()
  if (!trimmed) return ''
  if (/\/Page\/?$/i.test(trimmed)) return normalizeBaseUrl(trimmed)
  if (/\/Codeunit\//i.test(trimmed)) {
    return normalizeBaseUrl(trimmed.replace(/Codeunit\/[^/]+\/?$/i, 'Page/'))
  }
  return ''
}

function odataBases() {
  return configuredODataBases()
}

function configuredJobTitle(jobId: string) {
  const code = jobId.trim().toUpperCase()
  if (!code) return ''
  const fromEnv = config.BC_JOB_TITLE_BY_CODE.get(code)
  if (fromEnv) return fromEnv
  if (!/ABH/i.test(config.BC_ODATA_BASE_URL)) return ''
  const abhDefaults: Record<string, string> = {
    ITM: 'IT Manger',
    FAD: 'Finance and Admin Director',
    DHM: 'Human Resource Manager',
  }
  return abhDefaults[code] ?? ''
}

const ABH_EMPLOYEE_JOB_TITLES: Record<string, string> = {
  'ABH-029': 'Finance and Admin Director',
  'ABH-032': 'Human Resource Manager',
  'ABH-114': 'IT Manger',
}

export function configuredJobTitleByEmployeeNo(employeeNo: string) {
  const no = employeeNo.trim().toUpperCase()
  if (!no) return ''
  const fromEnv = config.BC_JOB_TITLE_BY_EMPNO.get(no)
  if (fromEnv) return fromEnv
  return ABH_EMPLOYEE_JOB_TITLES[no] ?? ''
}

function employeeEmail(record: Record<string, unknown>) {
  return employeeFieldText(record, ['EMail', 'E_Mail', 'Email', 'CompanyEMail', 'Company_EMail'])
}

function inferJobIdFromEmail(email: string) {
  const local = email.split('@')[0]?.trim()
  if (!local) return ''
  // ABH job IDs are short codes (ITM, FAD), not employee first names like "tesfaye".
  if (/^[a-z][a-z0-9]{1,4}$/i.test(local)) return local.toUpperCase()
  return ''
}

function looksLikeJobCode(value: string) {
  const trimmed = value.trim()
  return trimmed.length > 0 && trimmed.length <= 12 && /^[A-Z0-9_]+$/i.test(trimmed)
}

function discoverJobCodeFromRow(row: Record<string, unknown>) {
  const direct = employeeFieldText(row, JOB_CODE_FIELDS)
  if (direct) return direct

  for (const [key, value] of Object.entries(row)) {
    if (value === undefined || value === null || String(value).trim() === '') continue
    const normalized = normalizeFieldKey(key)
    if (normalized === 'jobid' || normalized === 'jobno' || normalized === 'jobcode') {
      return String(value).trim()
    }
  }
  return ''
}

function discoverJobTitleFromRow(row: Record<string, unknown>) {
  const direct = employeeFieldText(row, JOB_TITLE_FIELDS)
  if (direct && !looksLikeJobCode(direct)) return direct

  for (const [key, value] of Object.entries(row)) {
    if (value === undefined || value === null || String(value).trim() === '') continue
    const normalized = normalizeFieldKey(key)
    if (['jobid', 'jobno', 'jobcode', 'jobgrade', 'grade', 'no', 'code'].includes(normalized)) {
      continue
    }
    if (
      normalized.includes('jobtitle') ||
      normalized === 'designation' ||
      normalized === 'position' ||
      normalized === 'jobdescription' ||
      (normalized === 'description' && !normalized.includes('employer')) ||
      (normalized === 'job' && String(value).includes(' '))
    ) {
      const text = String(value).trim()
      if (text && !looksLikeJobCode(text)) return text
    }
  }
  return ''
}

async function listEntitySets(base: string) {
  const cached = entitySetCache.get(base)
  if (cached && cached.expiresAt > Date.now()) return cached.names

  const metadata = await fetchODataMetadata(base).catch(() => '')
  const names = [...metadata.matchAll(/EntitySet\s+Name="([^"]+)"/gi)].map((match) => match[1]!)
  entitySetCache.set(base, { names, expiresAt: Date.now() + 60 * 60 * 1000 })
  return names
}

async function employeeODataServices() {
  const services = new Set([...EMPLOYEE_ODATA_SERVICES, ...config.BC_EMPLOYEE_ODATA_EXTRA_SERVICES])
  if (!config.BC_DISCOVER_ODATA_SERVICES) return [...services]

  for (const base of odataBases()) {
    const names = await listEntitySets(base).catch(() => [])
    for (const name of names) {
      if (/employee|staff|employeecard|hremployee/i.test(name) && !/kin|qualification|attachment/i.test(name)) {
        services.add(name)
      }
    }
  }
  return [...services]
}

async function jobODataServices() {
  const services = new Set([...JOB_ODATA_SERVICES, ...config.BC_JOB_ODATA_EXTRA_SERVICES])
  if (!config.BC_DISCOVER_ODATA_SERVICES) return [...services]

  for (const base of odataBases()) {
    const names = await listEntitySets(base).catch(() => [])
    for (const name of names) {
      if (/job|position|title|designation/i.test(name) && !/entry|ledger|journal|history|leave|posting/i.test(name)) {
        services.add(name)
      }
    }
  }
  return [...services]
}

const FAST_EMPLOYEE_SERVICES = [
  'QyHREmployee',
  'HrEmployee',
  'QyHrEmployee',
  'QyPREmployee',
  'Employee_Card',
  'EmployeeCard',
]
const PAGE_EMPLOYEE_SERVICES = ['Employee_Card', 'EmployeeCard', 'QyHREmployeeCard', 'HREmployeeCard']

const EMPLOYEE_HOD_FLAG_KEYS = ['IsHOD', 'Is_HOD', 'Is HOD', 'isHOD'] as const
const EMPLOYEE_ICT_FLAG_KEYS = ['ICTOfficer', 'ICT_Officer', 'ICT Officer'] as const

function roleFlagTruthy(value: unknown) {
  if (typeof value === 'boolean') return value
  if (typeof value === 'number') return value !== 0
  return ['true', 'yes', '1'].includes(String(value ?? '').trim().toLowerCase())
}

function recordHasRoleFlagKey(record: ODataRecord, keys: readonly string[]) {
  return keys.some((key) => record[key] !== undefined && record[key] !== null && String(record[key]).trim() !== '')
}

/** Merge OData employee rows; keep identity fields and OR role flags (Is HOD / ICT Officer). */
export function mergeEmployeeODataRecords(records: ODataRecord[]): ODataRecord | null {
  const found = records.filter((row) => row && typeof row === 'object')
  if (found.length === 0) return null
  const merged: ODataRecord = {}
  for (const row of found) {
    for (const [key, value] of Object.entries(row)) {
      if (value === undefined || value === null) continue
      if (String(value).trim() === '' && merged[key] !== undefined) continue
      merged[key] = value
    }
  }
  if (found.some((row) => roleFlagTruthy(row.IsHOD ?? row.Is_HOD ?? row['Is HOD'] ?? row.isHOD))) {
    merged.IsHOD = true
  }
  if (
    found.some((row) =>
      roleFlagTruthy(row.ICTOfficer ?? row.ICT_Officer ?? row['ICT Officer']),
    )
  ) {
    merged.ICTOfficer = true
  }
  return merged
}

function parseEmployeeProfileRoleFlags(raw: string) {
  const text = String(raw ?? '')
  const pick = (name: string) => {
    const match = text.match(new RegExp(`(?:^|#)${name}=([^#]*)`, 'i'))
    return match?.[1]?.trim() ?? ''
  }
  return {
    isHod: roleFlagTruthy(pick('IsHOD') || pick('Is_HOD') || pick('Is HOD')),
    ictOfficer: roleFlagTruthy(pick('ICTOfficer') || pick('ICT_Officer') || pick('ICT Officer')),
    hasHodKey: /(?:^|#)IsHOD=/i.test(text) || /(?:^|#)Is_HOD=/i.test(text),
    hasIctKey: /(?:^|#)ICTOfficer=/i.test(text) || /(?:^|#)ICT_Officer=/i.test(text),
  }
}

/** When OData omits card flags, read Is HOD / ICT Officer from StaffPortal SOAP profile. */
export async function enrichEmployeeRoleFlagsFromSoap(
  employeeNo: string,
  record: ODataRecord,
): Promise<ODataRecord> {
  const trimmed = employeeNo.trim()
  if (!trimmed) return record
  const hasHod = recordHasRoleFlagKey(record, EMPLOYEE_HOD_FLAG_KEYS)
  const hasIct = recordHasRoleFlagKey(record, EMPLOYEE_ICT_FLAG_KEYS)
  if (hasHod && hasIct) return record

  try {
    const profile = await callSoapMethod('FnGetEmployeeProfile', { employeeNo: trimmed })
    const flags = parseEmployeeProfileRoleFlags(String(profile.returnValue ?? ''))
    const next: ODataRecord = { ...record }
    if (!hasHod && flags.hasHodKey) next.IsHOD = flags.isHod
    if (!hasIct && flags.hasIctKey) next.ICTOfficer = flags.ictOfficer
    return next
  } catch {
    return record
  }
}

function salaryProbeServices() {
  return [
    ...new Set([
      ...salaryLookupServices(),
      ...FAST_EMPLOYEE_SERVICES,
      ...PAGE_EMPLOYEE_SERVICES,
      ...EMPLOYMENT_HISTORY_SERVICES,
    ]),
  ]
}

function salaryProbeFields(record: ODataRecord) {
  const configured = config.BC_SALARY_BASE_FIELD.trim()
  const knownFields = new Set(
    [...EMPLOYEE_SALARY_BASE_FIELDS, configured]
      .filter(Boolean)
      .map((field) => normalizeFieldKey(field)),
  )
  const fields: Record<string, unknown> = {}
  for (const [key, value] of Object.entries(record)) {
    if (
      knownFields.has(normalizeFieldKey(key)) ||
      /salary|basic|gross|wage|pay|earning|remuneration/i.test(key)
    ) {
      fields[key] = value
    }
  }
  return fields
}

function salaryProbeIdentity(record: ODataRecord) {
  const identity: Record<string, unknown> = {}
  for (const key of [
    'No',
    'Employee_No',
    'EmployeeNo',
    'Staff_No',
    'StaffNo',
    'CustomerNo',
    'Customer_No',
    'FullName',
    'Full_Name',
    'FirstName',
    'LastName',
  ]) {
    if (record[key] !== undefined && record[key] !== null && String(record[key]).trim()) {
      identity[key] = record[key]
    }
  }
  return identity
}

function salaryProbeError(error: unknown) {
  const message = error instanceof Error ? error.message : String(error)
  return message.length > 500 ? `${message.slice(0, 500)}...` : message
}

export async function probeEmployeeSalarySources(
  employeeNo: string,
  options: { customerNo?: string } = {},
) {
  const trimmed = employeeNo.trim()
  const customerNo = options.customerNo?.trim() ?? ''
  const filters = [
    ...employeeLookupFilters(trimmed).map((filter) => ({ lookup: 'employeeNo', filter })),
    ...customerLookupFilters(customerNo).map((filter) => ({ lookup: 'customerNo', filter })),
  ]

  const probes: Array<{
    baseUrl: string
    service: string
    lookup: string
    filter: string
    ok: boolean
    found: boolean
    salaryBase: number
    salaryFields: Record<string, unknown>
    identity: Record<string, unknown>
    recordKeys: string[]
    error?: string
  }> = []

  if (!trimmed || filters.length === 0) {
    return {
      employeeNo: trimmed,
      customerNo,
      configuredSalaryBaseField: config.BC_SALARY_BASE_FIELD || null,
      configuredSalaryLookupServices: config.BC_SALARY_LOOKUP_SERVICE,
      resolvedSalaryBase: 0,
      probes,
    }
  }

  for (const base of odataBases()) {
    for (const service of salaryProbeServices()) {
      let lastError = ''
      let lastFilter = ''
      let lastLookup = ''
      let found = false

      for (const lookup of filters) {
        lastFilter = lookup.filter
        lastLookup = lookup.lookup
        try {
          const rows = (await fetchODataFromBase(base, service, {
            $filter: lookup.filter,
            $top: 1,
          })) as ODataRecord[] | null
          lastError = ''
          if (!Array.isArray(rows) || rows.length === 0) continue

          const record = rows[0]!
          probes.push({
            baseUrl: base,
            service,
            lookup: lookup.lookup,
            filter: lookup.filter,
            ok: true,
            found: true,
            salaryBase: employeeSalaryBaseFromRecord(record),
            salaryFields: salaryProbeFields(record),
            identity: salaryProbeIdentity(record),
            recordKeys: Object.keys(record).sort(),
          })
          found = true
          break
        } catch (error) {
          lastError ||= salaryProbeError(error)
        }
      }

      if (!found) {
        probes.push({
          baseUrl: base,
          service,
          lookup: lastLookup,
          filter: lastFilter,
          ok: !lastError,
          found: false,
          salaryBase: 0,
          salaryFields: {},
          identity: {},
          recordKeys: [],
          ...(lastError ? { error: lastError } : {}),
        })
      }
    }
  }

  const resolvedSalaryBase = await fetchEmployeeSalaryBaseForAdvance(trimmed, { customerNo }).catch(
    () => 0,
  )

  return {
    employeeNo: trimmed,
    customerNo,
    configuredSalaryBaseField: config.BC_SALARY_BASE_FIELD || null,
    configuredSalaryLookupServices: config.BC_SALARY_LOOKUP_SERVICE,
    resolvedSalaryBase,
    probes,
  }
}

/** Single fast lookup for login/auth — parallel probes, merge rows so Is HOD / ICT Officer are not dropped. */
export async function fetchEmployeeRecordFast(employeeNo: string): Promise<ODataRecord | null> {
  const trimmed = employeeNo.trim()
  if (!trimmed) return null

  const filter = `No eq '${odataString(trimmed)}'`
  const bases = [
    config.BC_ODATA_BASE_URL,
    config.BC_ODATA_PAGE_BASE_URL,
    config.BC_SOAP_PAGE_BASE_URL,
    derivePageODataBaseFromSoapCodeunit(config.BC_SOAP_CODEUNIT_URL),
  ]
    .filter((base): base is string => Boolean(base))
    .map((base) => normalizeBaseUrl(base))

  const timeoutMs = config.BC_LOGIN_PROBE_TIMEOUT_MS
  const probes = [...new Set(bases)].flatMap((base) =>
    FAST_EMPLOYEE_SERVICES.map(async (service) => {
      const rows = (await fetchODataFromBase(
        base,
        service,
        { $filter: filter, $top: 1 },
        timeoutMs,
      ).catch(() => null)) as ODataRecord[] | null
      if (Array.isArray(rows) && rows.length > 0) return rows[0]!
      return null
    }),
  )

  const results = await Promise.all(probes)
  return mergeEmployeeODataRecords(results.filter((row): row is ODataRecord => Boolean(row)))
}

async function enrichEmployeeRecordFromPageBases(employeeNo: string, merged: ODataRecord) {
  const trimmed = employeeNo.trim()
  if (!trimmed) return merged

  const filter = `No eq '${odataString(trimmed)}'`
  const bases = [
    config.BC_ODATA_PAGE_BASE_URL,
    config.BC_SOAP_PAGE_BASE_URL,
    derivePageODataBaseFromSoapCodeunit(config.BC_SOAP_CODEUNIT_URL),
  ]
    .filter((base): base is string => Boolean(base))
    .map((base) => normalizeBaseUrl(base))

  let next = merged
  for (const base of [...new Set(bases)]) {
    for (const service of PAGE_EMPLOYEE_SERVICES) {
      const rows = (await fetchODataFromBase(base, service, { $filter: filter, $top: 1 }).catch(
        () => null,
      )) as ODataRecord[] | null
      if (!Array.isArray(rows) || rows.length === 0) continue
      next = { ...next, ...rows[0]! }
    }
  }
  return next
}

/** Employee Card-backed record for flows that must mirror fields visible on the BC card. */
export async function fetchEmployeeRecordWithCardFields(employeeNo: string): Promise<ODataRecord | null> {
  const fast = await fetchEmployeeRecordFast(employeeNo)
  if (!fast) return null
  return enrichEmployeeRecordFromPageBases(employeeNo, { ...fast })
}

export async function fetchMergedEmployeeRecord(employeeNo: string): Promise<ODataRecord | null> {
  const fast = await fetchEmployeeRecordFast(employeeNo)
  if (!fast) return null

  let merged: ODataRecord = { ...fast }
  const hasDirectTitle = Boolean(
    employeeFieldText(merged, ['JobTitle', 'Job_Title', 'JobTitleDescription', 'Job_Title_Description', 'Position']) ||
      discoverEmployeeJobTitle(merged),
  )
  const hasJobId = Boolean(discoverEmployeeJobId(merged))
  const hasAccountNumber = Boolean(employeeAccountNoFromRecord(merged))
  if (!hasDirectTitle || !hasJobId || !hasAccountNumber) {
    merged = await enrichEmployeeRecordFromPageBases(employeeNo, merged)
  }

  if (!config.BC_DISCOVER_ODATA_SERVICES) {
    return merged
  }

  const trimmed = employeeNo.trim()
  const filters = [
    `No eq '${odataString(trimmed)}'`,
    `EmployeeNo eq '${odataString(trimmed)}'`,
    `Employee_No eq '${odataString(trimmed)}'`,
  ]

  let found = true
  const services = await employeeODataServices()

  for (const base of odataBases()) {
    for (const service of services) {
      for (const filter of filters) {
        const rows = (await fetchODataFromBase(base, service, { $filter: filter, $top: 1 }).catch(
          () => null,
        )) as ODataRecord[] | null
        if (!Array.isArray(rows) || rows.length === 0) continue
        merged = { ...merged, ...rows[0]! }
        found = true
      }
    }
  }

  const email = employeeEmail(merged)
  if (email) {
    for (const base of odataBases()) {
      for (const service of services) {
        for (const emailField of ['EMail', 'E_Mail', 'Email', 'CompanyEMail', 'Company_EMail']) {
          const rows = (await fetchODataFromBase(base, service, {
            $filter: `${emailField} eq '${odataString(email)}'`,
            $top: 1,
          }).catch(() => null)) as ODataRecord[] | null
          if (!Array.isArray(rows) || rows.length === 0) continue
          merged = { ...merged, ...rows[0]! }
          found = true
        }
      }
    }
  }

  return found ? merged : null
}

export function resolveConfiguredJobTitleForEmail(email: string) {
  const jobId = inferJobIdFromEmail(email.trim())
  if (!jobId) return ''
  return configuredJobTitle(jobId)
}

export async function resolveAuthUserJobTitle(
  employee: Record<string, unknown>,
  employeeNo: string,
  email: string,
) {
  const normalizedEmail = email.trim()
  const record =
    normalizedEmail && !employeeEmail(employee)
      ? { ...employee, EMail: normalizedEmail }
      : employee

  const fromEmployee = await resolveEmployeeJobTitleFast(record, employeeNo)
  if (fromEmployee.trim()) return fromEmployee.trim()

  // ABH StaffPortal SOAP — Job Title from HR-Employee card (designation)
  try {
    const profile = await callSoapMethod('FnGetEmployeeProfile', { employeeNo })
    const raw = String(profile.returnValue ?? '')
    const match = raw.match(/(?:^|#)JobTitle=([^#]*)/i)
    const soapTitle = String(match?.[1] ?? '').trim()
    if (soapTitle && !looksLikeJobCode(soapTitle)) return soapTitle
  } catch {
    // SOAP profile optional — fall through to OData / config
  }

  const fromEmployeeNo = configuredJobTitleByEmployeeNo(employeeNo)
  if (fromEmployeeNo) return fromEmployeeNo

  const fromConfig = resolveConfiguredJobTitleForEmail(normalizedEmail)
  if (fromConfig) return fromConfig

  const fromBc = await resolveEmployeeJobTitle(record, employeeNo)
  if (fromBc.trim()) return fromBc.trim()

  return ''
}

export async function resolveEmployeeJobTitleFast(
  employee: Record<string, unknown>,
  employeeNo = String(employee.No ?? employee.EmployeeNo ?? employee.Employee_No ?? ''),
) {
  const direct = employeeFieldText(employee, [
    'JobTitle',
    'Job_Title',
    'JobTitleDescription',
    'Job_Title_Description',
    'Position',
    'CurrentJobTitle',
    'Current_Job_Title',
    'ActingJobTitle',
    'Acting_Job_Title',
    'Designation',
    'JobDescription',
    'Job',
    'Job_Description',
  ])
  if (direct && !looksLikeJobCode(direct)) return direct

  const discovered = discoverEmployeeJobTitle(employee)
  if (discovered) return discovered

  const jobId = discoverEmployeeJobId(employee)
  if (jobId) {
    const configured = configuredJobTitle(jobId)
    if (configured) return configured
  }

  return ''
}

function discoverEmployeeJobTitle(record: Record<string, unknown>) {
  const jobDescription = record.Job
  if (
    jobDescription !== undefined &&
    jobDescription !== null &&
    String(jobDescription).trim() &&
    (String(jobDescription).includes(' ') || String(jobDescription).length > 4)
  ) {
    return String(jobDescription).trim()
  }

  for (const [key, value] of Object.entries(record)) {
    if (value === undefined || value === null || String(value).trim() === '') continue
    const normalized = normalizeFieldKey(key)
    if (['jobid', 'jobno', 'jobcode', 'jobgrade', 'grade'].includes(normalized)) continue
    if (
      normalized.includes('jobtitle') ||
      normalized === 'designation' ||
      normalized === 'position' ||
      normalized === 'jobdescription' ||
      normalized === 'job'
    ) {
      const text = String(value).trim()
      if (text && !looksLikeJobCode(text)) return text
    }
  }
  return ''
}

export function inferEmployeeJobId(record: Record<string, unknown>) {
  return discoverEmployeeJobId(record)
}

function discoverEmployeeJobId(record: Record<string, unknown>) {
  const direct = employeeFieldText(record, EMPLOYEE_JOB_CODE_FIELDS)
  if (direct) return direct

  for (const [key, value] of Object.entries(record)) {
    if (value === undefined || value === null || String(value).trim() === '') continue
    const normalized = normalizeFieldKey(key)
    if (
      normalized === 'jobid' ||
      normalized === 'jobno' ||
      normalized === 'jobcode' ||
      normalized === 'currentjobid' ||
      normalized === 'actingjobid'
    ) {
      return String(value).trim()
    }
  }

  const jobField = employeeFieldText(record, ['Job', 'Job_Code'])
  if (jobField && looksLikeJobCode(jobField)) return jobField

  return inferJobIdFromEmail(employeeEmail(record))
}

async function loadJobCatalog() {
  if (jobCatalogCache && jobCatalogCache.expiresAt > Date.now()) {
    return jobCatalogCache.rows
  }

  const catalog: Array<{ code: string; title: string }> = []
  const seen = new Set<string>()
  const services = await jobODataServices()

  for (const base of odataBases()) {
    for (const service of services) {
      const rows = (await fetchODataFromBase(base, service, { $top: 2000 }).catch(() => [])) as
        | ODataRecord[]
        | null
      if (!Array.isArray(rows)) continue
      for (const row of rows) {
        const code = discoverJobCodeFromRow(row as Record<string, unknown>)
        const title = discoverJobTitleFromRow(row as Record<string, unknown>)
        if (!code || !title) continue
        const key = `${code.toUpperCase()}::${title}`
        if (seen.has(key)) continue
        seen.add(key)
        catalog.push({ code: code.toUpperCase(), title })
      }
    }
  }

  jobCatalogCache = { rows: catalog, expiresAt: Date.now() + 30 * 60 * 1000 }
  return catalog
}

async function resolveJobTitleFromJobId(jobId: string) {
  const trimmed = jobId.trim()
  if (!trimmed) return ''

  const configured = configuredJobTitle(trimmed)
  if (configured) return configured

  const jobFilters = [
    `Code eq '${odataString(trimmed)}'`,
    `No eq '${odataString(trimmed)}'`,
    `JobID eq '${odataString(trimmed)}'`,
    `Job_ID eq '${odataString(trimmed)}'`,
    `Job_Code eq '${odataString(trimmed)}'`,
    `JobCode eq '${odataString(trimmed)}'`,
  ]

  const services = await jobODataServices()
  for (const base of odataBases()) {
    for (const service of services) {
      for (const filter of jobFilters) {
        const rows = (await fetchODataFromBase(base, service, { $filter: filter, $top: 1 }).catch(
          () => [],
        )) as ODataRecord[] | null
        if (!Array.isArray(rows) || rows.length === 0) continue
        const title = discoverJobTitleFromRow(rows[0] as Record<string, unknown>)
        if (title) return title
      }
    }
  }

  const catalog = await loadJobCatalog()
  const hit = catalog.find((entry) => entry.code === trimmed.toUpperCase())
  if (hit?.title) return hit.title

  return configuredJobTitle(trimmed)
}

async function resolveJobTitleFromEmploymentHistory(employeeNo: string) {
  const filters = [
    `Employee_No eq '${odataString(employeeNo)}'`,
    `EmployeeNo eq '${odataString(employeeNo)}'`,
  ]
  const services = EMPLOYMENT_HISTORY_SERVICES
  const orderings = ['Starting_Date desc', 'Start_Date desc', 'FromDate desc']

  for (const base of odataBases()) {
    for (const service of services) {
      for (const filter of filters) {
        for (const orderBy of orderings) {
          const history = (await fetchODataFromBase(base, service, {
            $filter: filter,
            $top: 1,
            $orderby: orderBy,
          }).catch(() => [])) as ODataRecord[] | null
          if (!Array.isArray(history) || history.length === 0) continue
          const title = discoverJobTitleFromRow(history[0] as Record<string, unknown>)
          if (title) return title
        }
      }
    }
  }
  return ''
}

export async function resolveEmployeeJobTitle(
  employee: Record<string, unknown>,
  employeeNo = String(employee.No ?? employee.EmployeeNo ?? employee.Employee_No ?? ''),
) {
  const direct = employeeFieldText(employee, [
    'JobTitle',
    'Job_Title',
    'JobTitleDescription',
    'Job_Title_Description',
    'Position',
    'CurrentJobTitle',
    'Current_Job_Title',
    'ActingJobTitle',
    'Acting_Job_Title',
    'Designation',
    'JobDescription',
    'Job',
    'Job_Description',
  ])
  if (direct && !looksLikeJobCode(direct)) return direct

  const discovered = discoverEmployeeJobTitle(employee)
  if (discovered) return discovered

  const jobId = discoverEmployeeJobId(employee)
  if (jobId) {
    const configured = configuredJobTitle(jobId)
    if (configured) return configured
    const fromJob = await resolveJobTitleFromJobId(jobId)
    if (fromJob) return fromJob
  }

  if (employeeNo) {
    const fromHistory = await resolveJobTitleFromEmploymentHistory(employeeNo)
    if (fromHistory) return fromHistory
  }

  return configuredJobTitleByEmployeeNo(employeeNo)
}

export async function resolveEmployeeJobTitleByNo(employeeNo: string) {
  const merged = await fetchMergedEmployeeRecord(employeeNo)
  if (!merged) return ''
  return resolveEmployeeJobTitle(merged, employeeNo)
}
