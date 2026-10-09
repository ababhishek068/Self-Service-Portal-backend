import { callSoapMethod, fetchOData, odataString, type ODataRecord } from './bcClient.js'

const keyOf = (key: string) => key.replace(/[^a-z0-9]/gi, '').toLowerCase()
const SECRET_PROFILE_KEYS = new Set([
  'portalpassword', 'portalotpcode', 'portalotpdate', 'portalotpdevice',
  'portalresettoken', 'portalresettokenexpired', 'resettoken', 'tokenexpired',
  'verificationtoken', 'changedpassword',
])
function isSecretProfileKey(key: string) {
  return SECRET_PROFILE_KEYS.has(keyOf(key)) || /password|otp|token|secret|userid|user id/i.test(key)
}
export function profileText(value: unknown): string {
  if (value === null || value === undefined || typeof value === 'object') return ''
  const text = String(value).trim()
  return /^(?:-|—|0D|null|undefined)$/i.test(text) || /^(?:0000|0001)-01-01(?:T|$)/.test(text) ? '' : text
}
/** Drop blank / placeholder BC values so the portal can omit the field entirely. */
export function sanitizeProfileRecord(row: ODataRecord): ODataRecord {
  const clean: ODataRecord = {}
  for (const [key, value] of Object.entries(row)) {
    if (isSecretProfileKey(key)) continue
    const text = profileText(value)
    if (text) clean[key] = typeof value === 'boolean' || typeof value === 'number' ? value : text
  }
  return clean
}
export function profilePick(row: ODataRecord, ...keys: string[]) {
  for (const key of keys) {
    const match = Object.keys(row).find(candidate => keyOf(candidate) === keyOf(key))
    const value = profileText(match ? row[match] : undefined)
    if (value) return value
  }
  return ''
}
function option(row: ODataRecord, key: string, captions: string[]) {
  const value = profilePick(row, key)
  return /^\d+$/.test(value) ? captions[Number(value)] ?? '' : value
}
function date(row: ODataRecord, ...keys: string[]) {
  const value = profilePick(row, ...keys)
  return /^\d{4}-\d{2}-\d{2}(?:T.*)?$/.test(value) && Number.isFinite(Date.parse(value)) ? value.slice(0, 10) : ''
}
export function parseLegacyProfile(raw: unknown): ODataRecord {
  return Object.fromEntries(String(raw ?? '').split('#').flatMap(segment => {
    const split = segment.indexOf('=')
    return split < 1 ? [] : [[segment.slice(0, split), segment.slice(split + 1)]]
  }))
}
export function mergeProfileRecords(...records: ODataRecord[]): ODataRecord {
  const merged: ODataRecord = {}
  for (const record of records) for (const [key, value] of Object.entries(sanitizeProfileRecord(record))) {
    if (profileText(value)) merged[key] = value
  }
  return merged
}

/** Field value kinds emitted by codeunit 50997 "Portal Employee Profile" (schema 2). */
export const PROFILE_FIELD_TYPES = ['text', 'code', 'date', 'datetime', 'time', 'number', 'integer', 'boolean', 'option'] as const
export type ProfileFieldType = (typeof PROFILE_FIELD_TYPES)[number]
export type ProfileSectionField = { key: string; label: string; value: string; type: ProfileFieldType }
/** A group of the BC Employee Card (Personal Information, Job Details, Leave Summary, …). */
export type ProfileSection = { key: string; title: string; fields: ProfileSectionField[] }

export type ProfileSections = {
  nextOfKin?: ODataRecord[]
  beneficiaries?: ODataRecord[]
  dependants?: ODataRecord[]
  qualifications?: ODataRecord[]
  employmentHistory?: ODataRecord[]
  internalHistory?: ODataRecord[]
  trainingHistory?: ODataRecord[]
  memberships?: ODataRecord[]
  rewards?: ODataRecord[]
  assignedAssets?: ODataRecord[]
  salaryAllowances?: ODataRecord[]
  salaryAllowancePeriod?: unknown
  /** Card groups from the schema-2 AL contract. */
  sections?: unknown
  /** Legacy flat `details` list from the first AL iteration. */
  details?: unknown
}
export type ProfileExtraField = { key: string; label: string; value: string }
export type MappedProfileDetails = {
  employeeNo: string
  fullName: string
  jobTitle: string
  jobId: string
  jobGrade: string
  division: string
  department: string
  sector: string
  district: string
  branch: string
  responsibilityCenter: string
  placeOfDuty: string
  maritalStatus: string
  gender: string
  employmentType: string
  employeeType: string
  status: string
  phoneNumber: string
  homePhoneNumber: string
  workPhoneNumber: string
  extension: string
  email: string
  personalEmail: string
  idNumber: string
  employeeAccountNo: string
  annualLeaveBalance: string
  availableLeaveBalance: string
  nationality: string
  country: string
  postalAddress: string
  residentialAddress: string
  city: string
  postCode: string
  region: string
  dateOfBirth: string
  age: string
  dateOfJoin: string
  lengthOfService: string
  contractStartDate: string
  contractEndDate: string
  probationEndDate: string
  onProbation: string
  contractDuration: string
  noticePeriod: string
  supervisorNo: string
  supervisorName: string
  supervisorJobTitle: string
  actingJob: string
  actingJobStartDate: string
  actingJobExpiryDate: string
  temporaryJob: string
  temporaryJobExpiryDate: string
  dateOfLeaving: string
  pensionSchemeJoin: string
  medicalSchemeJoin: string
  /** Card groups (schema 2). Empty when BC still runs the legacy contract. */
  sections: ProfileSection[]
  /** Extra populated BC card fields not covered by the fixed bio/contract layout (legacy contract only). */
  extraFields: ProfileExtraField[]
  nextOfKin: Record<string, string>[]
  beneficiaries: Record<string, string>[]
  dependants: Record<string, string>[]
  qualifications: Record<string, string>[]
  employmentHistory: Record<string, string>[]
  internalHistory: Record<string, string>[]
  trainingHistory: Record<string, string>[]
  memberships: Record<string, string>[]
  rewards: Record<string, string>[]
  assignedAssets: Record<string, string>[]
  salaryAllowances: Record<string, string>[]
  salaryAllowancePeriod: string
}

const KNOWN_PROFILE_VALUE_KEYS = new Set([
  'employeeno', 'no', 'fullname', 'firstname', 'middlename', 'lastname', 'jobtitle', 'jobid', 'jobgrade',
  'jobgroup', 'salarygrade', 'grade', 'division', 'divisionname', 'department', 'departmentname',
  'departmentcode', 'globaldimension1code', 'globaldimension1name', 'globaldimension2code',
  'globaldimension2name', 'sector', 'sectorname', 'district', 'districtname', 'districtcode',
  'locationdivisioncode', 'branch', 'branchdisplayname', 'workbranchname', 'branchname',
  'responsibilitycenter', 'placeofduty', 'workstation', 'office', 'maritalstatus', 'gender',
  'employmenttype', 'employeecontracttype', 'contracttype', 'employeetype', 'status',
  'phonenumber', 'cellphoneumber', 'cellularphonenumber', 'mobilephoneno', 'homephonenumber',
  'workphonenumber', 'extension', 'ext', 'email', 'companyemail', 'personalemail', 'idnumber',
  'employeeaccountno', 'customerno', 'annualleavebalance', 'availableleavebalance', 'nationality', 'citizenship',
  'country', 'countrycode', 'postaladdress', 'postaladdress2', 'postaladdress3', 'address',
  'residentialaddress', 'residentialaddress2', 'residentialaddress3', 'city', 'postcode',
  'region', 'regionname', 'dateofbirth', 'birthdate', 'age', 'dateofjoin', 'dateofjoining',
  'dateofjoiningthecompany', 'employmentdate', 'lengthofservice', 'contractstartdate', 'contractenddate',
  'contractend', 'endofcontractdate', 'endofcontract', 'probationenddate', 'endofprobation',
  'endofprobationdate', 'onprobation', 'contractduration', 'noticeperiod', 'supervisorno',
  'supervisorname', 'supervisorjobtitle', 'actingjob', 'actingjobstartdate', 'actingjobexpirydate', 'temporaryjob',
  'temporaryjobexpirydate', 'dateofleaving', 'dateofleavingthecompany', 'pensionschemejoin',
  'pensionschemejoindate', 'medicalschemejoin', 'medicalschemejoindate', 'currentjobtitle',
  'designation',
])

function humanizeFieldKey(key: string) {
  return key
    .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
    .replace(/_/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
}

type FlatProfile = Omit<
  MappedProfileDetails,
  | 'sections' | 'extraFields' | 'nextOfKin' | 'beneficiaries' | 'dependants' | 'qualifications' | 'employmentHistory'
  | 'internalHistory' | 'trainingHistory' | 'memberships' | 'rewards' | 'assignedAssets' | 'salaryAllowances' | 'salaryAllowancePeriod'
>

export function collectExtraProfileFields(
  row: ODataRecord,
  mapped: Partial<FlatProfile>,
  details?: unknown,
): ProfileExtraField[] {
  const shownValues = new Set(
    Object.values(mapped)
      .map(value => profileText(value).toLowerCase())
      .filter(Boolean),
  )
  const extras: ProfileExtraField[] = []
  const seen = new Set<string>()

  const push = (key: string, label: string, value: unknown) => {
    const text = profileText(value)
    if (!text || isSecretProfileKey(key) || KNOWN_PROFILE_VALUE_KEYS.has(keyOf(key))) return
    const dedupe = `${keyOf(key)}:${text.toLowerCase()}`
    if (seen.has(dedupe) || shownValues.has(text.toLowerCase())) return
    seen.add(dedupe)
    extras.push({ key, label: label.trim() || humanizeFieldKey(key), value: text })
  }

  if (Array.isArray(details)) {
    for (const entry of details) {
      if (!entry || typeof entry !== 'object' || Array.isArray(entry)) continue
      const item = entry as Record<string, unknown>
      push(String(item.key ?? item.Key ?? ''), String(item.label ?? item.Label ?? item.key ?? ''), item.value ?? item.Value)
    }
  }

  for (const [key, value] of Object.entries(row)) push(key, humanizeFieldKey(key), value)
  return extras.sort((a, b) => a.label.localeCompare(b.label))
}

const MAX_PROFILE_SECTIONS = 40
const MAX_SECTION_FIELDS = 400
const MAX_LIST_ROWS = 500

function isPlainObject(value: unknown): value is Record<string, unknown> {
  return Boolean(value) && typeof value === 'object' && !Array.isArray(value)
}

/**
 * Validates and sanitises the `sections` array produced by AL. Anything that is not a
 * well-formed, non-secret, populated field is dropped rather than rendered.
 */
export function parseProfileSections(raw: unknown): ProfileSection[] {
  if (!Array.isArray(raw)) return []
  const sections: ProfileSection[] = []
  const usedSectionKeys = new Set<string>()
  for (const entry of raw.slice(0, MAX_PROFILE_SECTIONS)) {
    if (!isPlainObject(entry)) continue
    const sectionKey = String(entry.key ?? '').replace(/[^a-z0-9]/gi, '').slice(0, 40)
    const title = profileText(entry.title).slice(0, 120)
    if (!sectionKey || !title || usedSectionKeys.has(sectionKey) || !Array.isArray(entry.fields)) continue
    const fields: ProfileSectionField[] = []
    const usedFieldKeys = new Set<string>()
    for (const item of entry.fields.slice(0, MAX_SECTION_FIELDS)) {
      if (!isPlainObject(item)) continue
      const key = String(item.key ?? '').replace(/[^a-z0-9]/gi, '').slice(0, 80)
      const label = profileText(item.label).slice(0, 120)
      const value = profileText(item.value).slice(0, 2000)
      if (!key || !label || !value || usedFieldKeys.has(key) || isSecretProfileKey(key) || isSecretProfileKey(label)) continue
      const typeText = String(item.type ?? 'text').toLowerCase()
      const type = (PROFILE_FIELD_TYPES as readonly string[]).includes(typeText) ? (typeText as ProfileFieldType) : 'text'
      usedFieldKeys.add(key)
      fields.push({ key, label, value, type })
    }
    if (!fields.length) continue
    usedSectionKeys.add(sectionKey)
    sections.push({ key: sectionKey, title, fields })
  }
  return sections
}

/** Reads one value from a section field, e.g. the resolved supervisor from Organisation & Placement. */
export function sectionFieldValue(sections: ProfileSection[], fieldKey: string) {
  for (const section of sections) {
    const match = section.fields.find(field => keyOf(field.key) === keyOf(fieldKey))
    if (match) return match.value
  }
  return ''
}

export function mapProfileDetails(row: ODataRecord, sections: ProfileSections = {}): MappedProfileDetails {
  const pick = (...keys: string[]) => profilePick(row, ...keys)
  const cardSections = parseProfileSections(sections.sections)
  const contract = option(row, 'EmployeeContractType', ['', 'Permanent and Pensionable', 'Contract', 'Probation', 'Casual', 'Intern', 'Seconded'])
  const contractCode = pick('ContractType')
  const bool = pick('OnProbation').toLowerCase()
  const email = pick('CompanyEMail', 'EMail')
  const personalEmailRaw = pick('EMail')
  const phoneNumber = pick('CellPhoneNumber', 'CellularPhoneNumber', 'MobilePhoneNo', 'HomePhoneNumber')
  const homePhoneRaw = pick('HomePhoneNumber')
  const dateOfJoin = date(row, 'DateOfJoiningtheCompany', 'DateOfJoining', 'EmploymentDate', 'DateOfJoin')
  const contractStartDate = date(row, 'ContractStartDate') || dateOfJoin
  let employmentType = contract || (/^\d+$/.test(contractCode) ? '' : contractCode) || pick('EmploymentType', 'EmployementType')
  let employeeType = option(row, 'EmployeeType', ['Primary', 'Seconded'])
  let gender = option(row, 'Gender', ['', 'Male', 'Female'])
  let maritalStatus = option(row, 'MaritalStatus', ['', 'Single', 'Married', 'Separated', 'Divorced', 'Widow(er)', 'Other'])
  let status = option(row, 'Status', ['New', 'Pending Approval', 'Active', 'Inactive'])
  // Never surface raw option ordinals like "0" once a caption/code was unavailable.
  if (/^\d+$/.test(employmentType)) employmentType = ''
  if (/^\d+$/.test(employeeType)) employeeType = ''
  if (/^\d+$/.test(gender)) gender = ''
  if (/^\d+$/.test(maritalStatus)) maritalStatus = ''
  if (/^\d+$/.test(status)) status = ''

  const cleanRows = (rows: ODataRecord[] | undefined, map: (row: ODataRecord) => Record<string, string>) =>
    (rows ?? [])
      .slice(0, MAX_LIST_ROWS)
      .filter(isPlainObject)
      .map(map)
      .filter(mapped => Object.entries(mapped).some(([key, value]) => key !== 'id' && Boolean(value)))

  const kinRow = (r: ODataRecord) => ({
    id: profilePick(r, 'SystemId', 'LineNo', 'No'),
    name: profilePick(r, 'Name', 'FullName') || [profilePick(r, 'SurName'), profilePick(r, 'OtherNames')].filter(Boolean).join(' '),
    relationship: profilePick(r, 'Relationship', 'Relationship2'),
    phone: profilePick(r, 'Phone', 'PhoneNo', 'PhoneNumber', 'HomeTelNo'),
    workPhone: profilePick(r, 'OfficeTelNo'),
    address: profilePick(r, 'Address'),
    dateOfBirth: date(r, 'DateOfBirth'),
    gender: profilePick(r, 'Gender'),
    occupation: profilePick(r, 'Occupation'),
    identification: [profilePick(r, 'IdentificationType'), profilePick(r, 'CardNo', 'IDNoPassportNo')].filter(Boolean).join(' '),
    memberId: profilePick(r, 'MemberID'),
    percentage: profilePick(r, 'Percentage'),
    status: profilePick(r, 'Status'),
    type: profilePick(r, 'Type'),
  })

  const mapped: FlatProfile = {
    employeeNo: pick('No', 'EmployeeNo'),
    fullName: pick('FullName') || [pick('FirstName'), pick('MiddleName'), pick('LastName')].filter(Boolean).join(' '),
    jobTitle: pick('JobTitle', 'CurrentJobTitle', 'Designation'),
    jobId: pick('JobID'),
    jobGrade: pick('JobGrade', 'JobGroup', 'SalaryGrade', 'Grade'),
    division: pick('DivisionName', 'GlobalDimension1Name', 'GlobalDimension1Code', 'Division'),
    department: pick('GlobalDimension2Name', 'DepartmentName', 'GlobalDimension2Code', 'DepartmentCode'),
    sector: pick('SectorName', 'Sector'),
    district: pick('DistrictName', 'DistrictCode', 'LocationDivisionCode'),
    branch: pick('BranchDisplayName', 'WorkBranchName'),
    responsibilityCenter: pick('ResponsibilityCenter'),
    placeOfDuty: pick('PlaceOfDuty', 'WorkStation', 'Office'),
    maritalStatus,
    gender,
    employmentType,
    employeeType,
    status,
    phoneNumber,
    homePhoneNumber: homePhoneRaw === phoneNumber ? '' : homePhoneRaw,
    workPhoneNumber: pick('WorkPhoneNumber'),
    extension: pick('Ext', 'Extension'),
    email,
    personalEmail: personalEmailRaw === email ? '' : personalEmailRaw,
    idNumber: pick('IDNumber'),
    employeeAccountNo: pick('CustomerNo'),
    annualLeaveBalance: pick('AnnualLeaveBalance'),
    availableLeaveBalance: pick('AvailableLeaveBalance'),
    nationality: pick('Nationality', 'Citizenship'),
    country: pick('CountryCode'),
    postalAddress: [pick('PostalAddress', 'Address'), pick('PostalAddress2'), pick('PostalAddress3')].filter(Boolean).join(', '),
    residentialAddress: [pick('ResidentialAddress'), pick('ResidentialAddress2'), pick('ResidentialAddress3')].filter(Boolean).join(', '),
    city: pick('City'),
    postCode: pick('PostCode'),
    region: pick('RegionName', 'Region'),
    dateOfBirth: date(row, 'DateOfBirth', 'BirthDate'),
    age: pick('Age'),
    dateOfJoin,
    lengthOfService: pick('LengthOfService'),
    contractStartDate,
    contractEndDate: date(row, 'ContractEndDate', 'ContractEnd', 'EndofContractDate', 'EndOfContract'),
    probationEndDate: date(row, 'EndOfProbationDate', 'EndOfProbation', 'ProbationEndDate'),
    onProbation: ['true', 'yes', '1'].includes(bool) ? 'Yes' : ['false', 'no', '0'].includes(bool) ? 'No' : '',
    contractDuration: pick('ContractDuration') === '0' ? '' : pick('ContractDuration'),
    noticePeriod: pick('NoticePeriod'),
    supervisorNo: pick('SupervisorNo'),
    supervisorName: pick('SupervisorName'),
    supervisorJobTitle: pick('SupervisorJobTitle'),
    actingJob: pick('ActingJob'),
    actingJobStartDate: date(row, 'ActingJobStartDate'),
    actingJobExpiryDate: date(row, 'ActingJobExpiryDate'),
    temporaryJob: pick('TemporaryJob'),
    temporaryJobExpiryDate: date(row, 'TemporaryJobExpiryDate'),
    dateOfLeaving: date(row, 'DateOfLeavingtheCompany', 'DateOfLeaving'),
    pensionSchemeJoin: date(row, 'PensionSchemeJoinDate', 'PensionSchemeJoin'),
    medicalSchemeJoin: date(row, 'MedicalSchemeJoinDate', 'MedicalSchemeJoin'),
  }

  return {
    ...mapped,
    sections: cardSections,
    // With card groups available every populated field is already shown in its section.
    extraFields: cardSections.length ? [] : collectExtraProfileFields(row, mapped, sections.details),
    nextOfKin: cleanRows(sections.nextOfKin, kinRow).filter(r => r.name || r.relationship || r.phone),
    beneficiaries: cleanRows(sections.beneficiaries, kinRow).filter(r => r.name || r.relationship || r.phone),
    dependants: cleanRows(sections.dependants, kinRow).filter(r => r.name || r.relationship || r.phone),
    qualifications: cleanRows(sections.qualifications, r => ({
      id: profilePick(r, 'SystemId', 'LineNo'),
      title: profilePick(r, 'QualificationDescription', 'Description', 'Qualification', 'QualificationCode'),
      institution: profilePick(r, 'InstitutionName', 'InstitutionCompany', 'Institution'),
      level: profilePick(r, 'Level', 'QualificationType'),
      year: profilePick(r, 'Year', 'CompletionYear'),
      fromDate: date(r, 'FromDate'),
      toDate: date(r, 'ToDate'),
      grade: profilePick(r, 'CourseGrade', 'Grade'),
      type: profilePick(r, 'Type'),
      highestQualification: profilePick(r, 'HighestQualification'),
    })),
    employmentHistory: cleanRows(sections.employmentHistory, r => ({
      id: profilePick(r, 'SystemId', 'LineNo'),
      organisation: profilePick(r, 'CompanyName', 'Employer', 'Organisation'),
      position: profilePick(r, 'JobTitle', 'Position'),
      fromDate: date(r, 'From', 'FromDate', 'StartDate'),
      toDate: date(r, 'ToDate', 'EndDate'),
      type: profilePick(r, 'Type'),
      experience: profilePick(r, 'KeyExperience'),
      reasonForLeaving: profilePick(r, 'ReasonForLeaving'),
    })),
    internalHistory: cleanRows(sections.internalHistory, r => ({
      id: profilePick(r, 'SystemId', 'RefNo', 'LineNo'),
      refNo: profilePick(r, 'RefNo'),
      change: profilePick(r, 'ReasonForChange'),
      reason: profilePick(r, 'ReasonDescription'),
      jobId: profilePick(r, 'JobId'),
      jobTitle: profilePick(r, 'JobTitle'),
      fromDate: date(r, 'FromDate', 'From'),
      toDate: date(r, 'ToDate'),
      division: profilePick(r, 'Division'),
      department: profilePick(r, 'Department'),
      sector: profilePick(r, 'Sector'),
      district: profilePick(r, 'District'),
      workStation: profilePick(r, 'WorkStation'),
      grade: profilePick(r, 'Grade'),
      status: profilePick(r, 'Status'),
      current: profilePick(r, 'Current'),
    })),
    trainingHistory: cleanRows(sections.trainingHistory, r => ({
      id: profilePick(r, 'SystemId', 'ApplicationNo'),
      applicationNo: profilePick(r, 'ApplicationNo'),
      course: profilePick(r, 'Description', 'CourseTitle'),
      courseCode: profilePick(r, 'CourseTitle'),
      institution: profilePick(r, 'Institution', 'TrainingInstitution'),
      location: profilePick(r, 'Location'),
      category: profilePick(r, 'Category'),
      fromDate: date(r, 'FromDate'),
      toDate: date(r, 'ToDate'),
      duration: profilePick(r, 'Duration'),
      year: profilePick(r, 'Year'),
      status: profilePick(r, 'TrainingStatus', 'Status'),
      result: profilePick(r, 'EvaluationResult'),
      purpose: profilePick(r, 'Purpose'),
    })),
    memberships: cleanRows(sections.memberships, r => ({
      id: profilePick(r, 'SystemId', 'MembershipNo', 'LineNo'),
      body: profilePick(r, 'NameOfBody'),
      membershipNo: profilePick(r, 'MembershipNo'),
      since: date(r, 'DateOfMembership'),
      status: profilePick(r, 'Status', 'MembershipStatus'),
      subscriptionFrom: date(r, 'SubscriptionCommenceDate'),
      renewalDate: date(r, 'SubscriptionRenewalDate'),
      remarks: profilePick(r, 'Remarks'),
    })),
    rewards: cleanRows(sections.rewards, r => ({
      id: profilePick(r, 'SystemId', 'Code'),
      code: profilePick(r, 'Code'),
      description: profilePick(r, 'Description'),
      dateAcquired: date(r, 'DateAcquired'),
    })),
    assignedAssets: cleanRows(sections.assignedAssets, r => ({
      tagNumber: profilePick(r, 'FATagNumber', 'No'),
      description: profilePick(r, 'Description'),
      assignedDate: date(r, 'AssignedDate'),
      status: profilePick(r, 'Status') || (profilePick(r, 'Blocked') ? 'Blocked' : profilePick(r, 'Inactive') ? 'Inactive' : ''),
      location: profilePick(r, 'FALocationCode', 'LocationCode'),
      assetClass: [profilePick(r, 'FAClassCode'), profilePick(r, 'FASubclassCode')].filter(Boolean).join(' / '),
      serialNo: profilePick(r, 'SerialNo'),
    })),
    salaryAllowances: cleanRows(sections.salaryAllowances, r => ({
      id: profilePick(r, 'SystemId', 'Code'),
      code: profilePick(r, 'Code', 'TransactionCode'),
      name: profilePick(r, 'Name', 'TransactionName'),
      amount: profilePick(r, 'Amount'),
      period: profilePick(r, 'Period'),
    })).filter(r => Boolean(r.name || r.code) && Boolean(r.amount)),
    salaryAllowancePeriod: profileText(sections.salaryAllowancePeriod),
  }
}

/** Modern JSON profile is deliberately allowlisted in AL; never expose the raw HR record. */
type ProfileServices = {
  soap: (method: string, params: Record<string, string>) => Promise<{ returnValue?: unknown }>
  odata: (service: string, query: Record<string, string | number>) => Promise<ODataRecord[]>
}

const REQUIRED_PROFILE_LISTS = ['nextOfKin', 'qualifications', 'employmentHistory', 'assignedAssets'] as const
const OPTIONAL_PROFILE_LISTS = [
  'beneficiaries', 'dependants', 'internalHistory', 'trainingHistory', 'memberships', 'rewards', 'salaryAllowances',
] as const
const UNAVAILABLE_SECTION_KEYS = [
  'bio', 'contract', 'kin', 'beneficiaries', 'dependants', 'qualifications', 'history', 'internalHistory',
  'training', 'memberships', 'rewards', 'assets', 'allowances', 'details',
]

function validProfileList(value: unknown) {
  return Array.isArray(value) && value.every(row => isPlainObject(row))
}

export async function fetchPortalProfileDetails(
  employeeNo: string,
  services: ProfileServices = { soap: callSoapMethod, odata: fetchOData },
) {
  if (!employeeNo.trim()) throw Object.assign(new Error('Employee identity is required.'), { status: 401 })
  try {
    const result = await services.soap('GetEmployeeProfileDetails', { employeeNo })
    const body = JSON.parse(String(result.returnValue ?? ''))
    if (!isPlainObject(body) || !isPlainObject(body.employee) || profilePick(body.employee as ODataRecord, 'No', 'EmployeeNo') !== employeeNo) {
      throw new Error('Business Central returned an invalid profile identity.')
    }
    for (const section of REQUIRED_PROFILE_LISTS) {
      if (!validProfileList(body[section])) throw new Error('Business Central returned an invalid profile section.')
    }
    for (const section of OPTIONAL_PROFILE_LISTS) {
      if (body[section] !== undefined && !validProfileList(body[section])) {
        throw new Error('Business Central returned an invalid profile section.')
      }
    }
    if (body.sections !== undefined && !Array.isArray(body.sections)) {
      throw new Error('Business Central returned an invalid profile section.')
    }
    const lists = Object.fromEntries(
      [...REQUIRED_PROFILE_LISTS, ...OPTIONAL_PROFILE_LISTS].map(key => [key, Array.isArray(body[key]) ? (body[key] as ODataRecord[]) : []]),
    ) as Record<(typeof REQUIRED_PROFILE_LISTS)[number] | (typeof OPTIONAL_PROFILE_LISTS)[number], ODataRecord[]>
    return {
      ...mapProfileDetails(body.employee as ODataRecord, {
        ...lists,
        salaryAllowancePeriod: body.salaryAllowancePeriod,
        sections: body.sections,
        details: body.details,
      }),
      unavailableSections: Array.isArray(body.unavailableSections)
        ? body.unavailableSections.filter((value: unknown): value is string => typeof value === 'string' && UNAVAILABLE_SECTION_KEYS.includes(value))
        : [],
    }
  } catch (error) {
    // Only an undeployed method can use the legacy contract. Outages and invalid
    // payloads must remain visible rather than becoming a successful empty profile.
    if (
      !(error instanceof Error) ||
      !/GetEmployeeProfileDetails/i.test(error.message) ||
      !/not.*(valid|found|exist|supported)|unknown|invalid.*method|method.*invalid|SOAPAction/i.test(error.message)
    ) {
      throw error
    }
  }

  const filter = odataString(employeeNo)
  const results = await Promise.allSettled([
    services.odata('QyHREmployee', { $filter: `No eq '${filter}'`, $top: 1 }),
    services.soap('FnGetEmployeeProfile', { employeeNo }),
    services.odata('QyHREmployeeKin', { $filter: `EmployeeCode eq '${filter}'` }),
    services.odata('QyEmploymentHistory', { $filter: `Employee_No eq '${filter}'` }),
    services.odata('QyHREmployeeQualifications', { $filter: `Employee_No eq '${filter}' or EmployeeNo eq '${filter}'` }),
    services.odata('QyFixedAsset', { $filter: `ResponsibleEmployee eq '${filter}'` }),
  ])
  const hr = results[0].status === 'fulfilled' && results[0].value[0] ? sanitizeProfileRecord(results[0].value[0]) : undefined
  const soap = results[1].status === 'fulfilled' ? sanitizeProfileRecord(parseLegacyProfile(results[1].value.returnValue)) : {}
  if (!hr && !profilePick(soap, 'FullName')) {
    throw Object.assign(new Error('Could not load your employee profile from Business Central.'), { status: 502 })
  }
  const unavailableSections: string[] = []
  if (results[0].status === 'rejected' || results[1].status === 'rejected') unavailableSections.push('bio', 'contract', 'details')
  if (results[2].status === 'rejected') unavailableSections.push('kin')
  if (results[3].status === 'rejected') unavailableSections.push('history')
  // The legacy kin query returns every kin type in one list; split dependants / beneficiaries like the card does.
  const kinRows = results[2].status === 'fulfilled' ? results[2].value.filter(isPlainObject) : []
  const kinType = (row: ODataRecord) => profilePick(row, 'Type').toLowerCase()
  // Qualifications / assets are best-effort until GetEmployeeProfileDetails is published.
  return {
    ...mapProfileDetails(mergeProfileRecords(hr ?? {}, soap, { No: employeeNo }), {
      nextOfKin: kinRows.filter(row => !['dependant', 'beneficiary', '3', '2'].includes(kinType(row))),
      dependants: kinRows.filter(row => ['dependant', '3'].includes(kinType(row))),
      beneficiaries: kinRows.filter(row => ['beneficiary', '2'].includes(kinType(row))),
      employmentHistory: results[3].status === 'fulfilled' ? results[3].value : [],
      qualifications: results[4].status === 'fulfilled' ? results[4].value : [],
      assignedAssets: results[5].status === 'fulfilled' ? results[5].value : [],
    }),
    unavailableSections,
  }
}
