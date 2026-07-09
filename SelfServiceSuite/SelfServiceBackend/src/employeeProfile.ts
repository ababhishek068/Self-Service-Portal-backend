import { config } from './config.js'
import { fetchODataFromBase, fetchODataMetadata, odataString, type ODataRecord } from './bcClient.js'

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

function employeeFieldText(record: Record<string, unknown>, keys: string[], fallback = '') {
  for (const key of keys) {
    const value = record[key]
    if (value !== undefined && value !== null && String(value).trim()) return String(value).trim()
  }
  return fallback
}

const EMPLOYEE_BC_USER_ID_FIELDS = [
  'Employee_User_ID',
  'EmployeeUserID',
  'Employee_UserID',
  'User_ID',
  'Portal_User_ID',
  'PortalUserID',
]

/** Employee card BC login — may differ from QyUserSetup when portal SOAP runs as ADMIN. */
export function employeeBcUserIdFromRecord(record: Record<string, unknown>) {
  const fromCard = employeeFieldText(record, EMPLOYEE_BC_USER_ID_FIELDS)
  if (fromCard) return fromCard
  for (const [key, value] of Object.entries(record)) {
    if (!value || typeof value !== 'string') continue
    const normalized = key.toLowerCase().replace(/[_\s]/g, '')
    if (normalized === 'employeeuserid' || normalized === 'portaluserid') {
      return value.trim()
    }
  }
  return ''
}

export function looksLikeServiceBcUserId(userID: string) {
  const normalized = userID.trim().toUpperCase()
  if (!normalized) return true
  return ['ADMIN', 'SERVICE', 'SYSTEM', 'BCADMIN', 'SUPER', 'TAADMIN'].includes(normalized)
}

/** When several User Setup rows share one Employee No., ignore service accounts like ADMIN. */
export function pickPreferredUserSetupRow<T extends { UserID?: string }>(rows: T[]): T | null {
  if (!rows.length) return null
  const nonService = rows.filter((row) => !looksLikeServiceBcUserId(String(row.UserID ?? '')))
  return nonService[0] ?? rows[0] ?? null
}

/** BC user IDs differ by publish (HERMON_GETACHEW vs HERMON.GETACHEW) — compare loosely. */
export function normalizeBcUserIdForMatch(userID: string) {
  return userID.trim().toUpperCase().replace(/[._\\-]/g, '')
}

export function bcUserIdsEquivalent(left: string, right: string) {
  const a = normalizeBcUserIdForMatch(left)
  const b = normalizeBcUserIdForMatch(right)
  return Boolean(a && b && a === b)
}

/** Prefer configured / employee-card login over QyUserSetup when setup points at a service account. */
export function resolveEffectiveBcUserId(
  sessionUserId: string,
  employeeRow?: ODataRecord | null,
  employeeNo?: string,
) {
  const fromEnv = employeeNo ? configuredBcUserIdByEmployeeNo(employeeNo) : ''
  if (fromEnv) return fromEnv

  const fromEmployee = employeeRow ? employeeBcUserIdFromRecord(employeeRow as Record<string, unknown>) : ''
  const candidate = fromEmployee ? canonicalBcUserId(fromEmployee) : ''
  if (candidate && looksLikeServiceBcUserId(sessionUserId)) return candidate
  if (!sessionUserId.trim() && candidate) return candidate
  if (candidate && bcUserIdsEquivalent(sessionUserId, candidate)) return candidate

  const fromSession = canonicalBcUserId(sessionUserId)
  if (fromSession && fromSession !== sessionUserId.trim()) return fromSession
  return fromSession || candidate
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
  const derivedPageBase = derivePageODataBaseFromSoapCodeunit(config.BC_SOAP_CODEUNIT_URL)
  const bases = [
    config.BC_ODATA_BASE_URL,
    config.BC_SOAP_PAGE_BASE_URL,
    config.BC_ODATA_PAGE_BASE_URL,
    derivedPageBase,
  ].filter((base): base is string => Boolean(base))
  return [...new Set(bases.map((base) => normalizeBaseUrl(base)))]
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
  }
  return abhDefaults[code] ?? ''
}

const ABH_EMPLOYEE_JOB_TITLES: Record<string, string> = {
  'ABH-010': 'Media and IT Expert',
  'ABH-029': 'Finance and Admin Director',
  'ABH-114': 'IT Manger',
}

export function configuredJobTitleByEmployeeNo(employeeNo: string) {
  const no = employeeNo.trim().toUpperCase()
  if (!no) return ''
  const fromEnv = config.BC_JOB_TITLE_BY_EMPNO.get(no)
  if (fromEnv) return fromEnv
  return ABH_EMPLOYEE_JOB_TITLES[no] ?? ''
}

const ABH_EMPLOYEE_BC_USER_IDS: Record<string, string> = {
  'ABH-114': 'HERMON_GETACHEW',
}

/** QyUserSetup aliases → canonical BC User ID used by approval workflows. */
const BC_USER_ID_CANONICAL: Record<string, string> = {
  HERMONGETACHEW: 'HERMON_GETACHEW',
}

export function normalizeEmployeeNoForLookup(employeeNo: string) {
  const trimmed = employeeNo.trim().toUpperCase()
  if (!trimmed) return ''
  if (/^ABH-?\d+$/.test(trimmed.replace(/_/g, '-'))) {
    return trimmed.replace(/_/g, '-').replace(/^ABH(\d)/, 'ABH-$1')
  }
  return trimmed.replace(/_/g, '-')
}

export function configuredBcUserIdByEmployeeNo(employeeNo: string) {
  const no = normalizeEmployeeNoForLookup(employeeNo)
  if (!no) return ''
  const fromEnv = config.BC_BC_USER_ID_BY_EMPNO.get(no)
  if (fromEnv) return fromEnv
  return ABH_EMPLOYEE_BC_USER_IDS[no] ?? ''
}

export function canonicalBcUserId(userID: string) {
  const key = normalizeBcUserIdForMatch(userID)
  return BC_USER_ID_CANONICAL[key] ?? userID.trim()
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

const FAST_EMPLOYEE_SERVICES = ['QyHREmployee', 'QyPREmployee', 'Employee_Card', 'EmployeeCard']
const PAGE_EMPLOYEE_SERVICES = ['Employee_Card', 'EmployeeCard', 'QyHREmployeeCard', 'HREmployeeCard']

/** Single fast lookup for login/auth — avoids metadata scans and brute-force OData probing. */
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

  for (const base of [...new Set(bases)]) {
    for (const service of FAST_EMPLOYEE_SERVICES) {
      const rows = (await fetchODataFromBase(base, service, { $filter: filter, $top: 1 }).catch(
        () => null,
      )) as ODataRecord[] | null
      if (Array.isArray(rows) && rows.length > 0) return rows[0]!
    }
  }

  return null
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

export async function fetchMergedEmployeeRecord(employeeNo: string): Promise<ODataRecord | null> {
  const fast = await fetchEmployeeRecordFast(employeeNo)
  if (!fast) return null

  let merged: ODataRecord = { ...fast }
  const hasDirectTitle = Boolean(
    employeeFieldText(merged, ['JobTitle', 'Job_Title', 'JobTitleDescription', 'Job_Title_Description', 'Position']) ||
      discoverEmployeeJobTitle(merged),
  )
  const hasJobId = Boolean(discoverEmployeeJobId(merged))
  if (!hasDirectTitle || !hasJobId) {
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
