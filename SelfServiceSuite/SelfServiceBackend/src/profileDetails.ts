import { callSoapMethod, fetchOData, odataString, type ODataRecord } from './bcClient.js'

const keyOf = (key: string) => key.replace(/[^a-z0-9]/gi, '').toLowerCase()
export function profileText(value: unknown): string {
  if (value === null || value === undefined || typeof value === 'object') return ''
  const text = String(value).trim()
  return /^(?:-|—|0D|null|undefined)$/i.test(text) || /^(?:0000|0001)-01-01(?:T|$)/.test(text) ? '' : text
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
  for (const record of records) for (const [key, value] of Object.entries(record)) {
    if (profileText(value)) merged[key] = value
  }
  return merged
}
export type ProfileSections = { nextOfKin?: ODataRecord[]; qualifications?: ODataRecord[]; employmentHistory?: ODataRecord[]; assignedAssets?: ODataRecord[] }
export function mapProfileDetails(row: ODataRecord, sections: ProfileSections = {}) {
  const pick = (...keys: string[]) => profilePick(row, ...keys)
  const contract = option(row, 'EmployeeContractType', ['', 'Permanent and Pensionable', 'Contract', 'Probation', 'Casual', 'Intern', 'Seconded'])
  const contractCode = pick('ContractType')
  const bool = pick('OnProbation').toLowerCase()
  const values = {
    employeeNo: pick('No', 'EmployeeNo'), fullName: pick('FullName') || [pick('FirstName'), pick('MiddleName'), pick('LastName')].filter(Boolean).join(' '),
    jobTitle: pick('JobTitle', 'CurrentJobTitle', 'Designation'), jobId: pick('JobID'), jobGrade: pick('JobGrade', 'JobGroup', 'SalaryGrade', 'Grade'),
    division: pick('DivisionName', 'GlobalDimension1Name', 'GlobalDimension1Code', 'Division'),
    department: pick('GlobalDimension2Name', 'DepartmentName', 'GlobalDimension2Code', 'DepartmentCode'),
    sector: pick('SectorName', 'Sector'), district: pick('DistrictName', 'DistrictCode', 'LocationDivisionCode'), branch: pick('BranchDisplayName', 'WorkBranchName'),
    responsibilityCenter: pick('ResponsibilityCenter'), placeOfDuty: pick('PlaceOfDuty', 'WorkStation', 'Office'),
    maritalStatus: option(row, 'MaritalStatus', ['', 'Single', 'Married', 'Separated', 'Divorced', 'Widow(er)', 'Other']),
    gender: option(row, 'Gender', ['', 'Male', 'Female']),
    employmentType: contract || (/^\d+$/.test(contractCode) ? '' : contractCode),
    employeeType: option(row, 'EmployeeType', ['Primary', 'Seconded']),
    status: option(row, 'Status', ['New', 'Pending Approval', 'Active', 'Inactive']),
    phoneNumber: pick('CellPhoneNumber', 'CellularPhoneNumber', 'MobilePhoneNo', 'HomePhoneNumber'),
    homePhoneNumber: pick('HomePhoneNumber'), workPhoneNumber: pick('WorkPhoneNumber'), extension: pick('Ext', 'Extension'),
    email: pick('CompanyEMail', 'EMail'), personalEmail: pick('EMail'), idNumber: pick('IDNumber'),
    employeeAccountNo: pick('CustomerNo'), annualLeaveBalance: pick('AnnualLeaveBalance'),
    nationality: pick('Nationality', 'Citizenship'), country: pick('CountryCode'),
    postalAddress: [pick('PostalAddress', 'Address'),pick('PostalAddress2'),pick('PostalAddress3')].filter(Boolean).join(', '), residentialAddress: [pick('ResidentialAddress'),pick('ResidentialAddress2'),pick('ResidentialAddress3')].filter(Boolean).join(', '), city: pick('City'), postCode: pick('PostCode'), region: pick('RegionName', 'Region'),
    dateOfBirth: date(row, 'DateOfBirth', 'BirthDate'), dateOfJoin: date(row, 'DateOfJoiningtheCompany', 'DateOfJoining', 'EmploymentDate', 'DateOfJoin'),
    contractStartDate: date(row, 'ContractStartDate'), contractEndDate: date(row, 'ContractEndDate', 'ContractEnd', 'EndofContractDate', 'EndOfContract'),
    probationEndDate: date(row, 'EndOfProbationDate', 'EndOfProbation', 'ProbationEndDate'),
    onProbation: ['true','yes','1'].includes(bool) ? 'Yes' : ['false','no','0'].includes(bool) ? 'No' : '',
    contractDuration: pick('ContractDuration') === '0' ? '' : pick('ContractDuration'), noticePeriod: pick('NoticePeriod'),
    supervisorNo: pick('SupervisorNo'), supervisorName: pick('SupervisorName'),
    actingJob: pick('ActingJob'), actingJobStartDate: date(row, 'ActingJobStartDate'), actingJobExpiryDate: date(row, 'ActingJobExpiryDate'),
    temporaryJob: pick('TemporaryJob'), temporaryJobExpiryDate: date(row, 'TemporaryJobExpiryDate'),
    dateOfLeaving: date(row, 'DateOfLeavingtheCompany', 'DateOfLeaving'), pensionSchemeJoin: date(row, 'PensionSchemeJoinDate', 'PensionSchemeJoin'), medicalSchemeJoin: date(row, 'MedicalSchemeJoinDate', 'MedicalSchemeJoin'),
  }
  if (values.personalEmail === values.email) values.personalEmail = ''
  if (values.homePhoneNumber === values.phoneNumber) values.homePhoneNumber = ''
  const cleanRows = (rows: ODataRecord[] | undefined, map: (row: ODataRecord) => Record<string,string>) => (rows ?? []).map(map).filter(row => Object.entries(row).some(([key,value]) => key !== 'id' && Boolean(value)))
  return {
    ...values,
    nextOfKin: cleanRows(sections.nextOfKin, r => ({
      id: profilePick(r,'SystemId','LineNo','No'), name: profilePick(r,'Name','FullName') || [profilePick(r,'SurName'),profilePick(r,'OtherNames')].filter(Boolean).join(' '),
      relationship: profilePick(r,'Relationship','Relationship2'), phone: profilePick(r,'Phone','PhoneNo','PhoneNumber','HomeTelNo'),
      workPhone: profilePick(r,'OfficeTelNo'), address: profilePick(r,'Address'), dateOfBirth: date(r,'DateOfBirth'), gender: profilePick(r,'Gender'), occupation: profilePick(r,'Occupation'), type: profilePick(r,'Type'),
    })).filter(r=>r.name || r.relationship || r.phone),
    qualifications: cleanRows(sections.qualifications, r=>({ id: profilePick(r,'SystemId','LineNo'), title: profilePick(r,'QualificationDescription','Description','Qualification','QualificationCode'), institution: profilePick(r,'InstitutionName','InstitutionCompany','Institution'), level: profilePick(r,'QualificationType','Level','Qualification'), year: profilePick(r,'Year','CompletionYear'), fromDate: date(r,'FromDate'), toDate: date(r,'ToDate'), grade: profilePick(r,'CourseGrade','Grade') })),
    employmentHistory: cleanRows(sections.employmentHistory, r=>({ id: profilePick(r,'SystemId','LineNo'), organisation: profilePick(r,'CompanyName','Employer','Organisation'), position: profilePick(r,'JobTitle','Position'), fromDate: date(r,'From','FromDate','StartDate'), toDate: date(r,'ToDate','EndDate'), type: profilePick(r,'Type'), experience: profilePick(r,'KeyExperience'), reasonForLeaving: profilePick(r,'ReasonForLeaving') })),
    assignedAssets: cleanRows(sections.assignedAssets, r=>({ tagNumber: profilePick(r,'FATagNumber','No'), description: profilePick(r,'Description'), assignedDate: date(r,'AssignedDate'), status: profilePick(r,'Status'), location: profilePick(r,'FALocationCode','LocationCode'), assetClass: profilePick(r,'FAClassCode'), serialNo: profilePick(r,'SerialNo') })),
  }
}

/** Modern JSON profile is deliberately allowlisted in AL; never expose the raw HR record. */
type ProfileServices = {
  soap: (method: string, params: Record<string, string>) => Promise<{returnValue?: unknown}>
  odata: (service: string, query: Record<string, string | number>) => Promise<ODataRecord[]>
}
export async function fetchPortalProfileDetails(employeeNo: string, services: ProfileServices = {soap: callSoapMethod, odata: fetchOData}) {
  if (!employeeNo.trim()) throw Object.assign(new Error('Employee identity is required.'), {status:401})
  try {
    const result = await services.soap('GetEmployeeProfileDetails', {employeeNo})
    const body = JSON.parse(String(result.returnValue ?? ''))
    if (!body.employee || profilePick(body.employee, 'No','EmployeeNo') !== employeeNo) throw new Error('Business Central returned an invalid profile identity.')
    for (const section of ['nextOfKin', 'qualifications', 'employmentHistory', 'assignedAssets']) {
      if (!Array.isArray(body[section]) || body[section].some((row: unknown) => !row || typeof row !== 'object' || Array.isArray(row))) {
        throw new Error('Business Central returned an invalid profile section.')
      }
    }
    const allowed = ['bio', 'contract', 'kin', 'qualifications', 'history', 'assets', 'details']
    return {...mapProfileDetails(body.employee, body), unavailableSections: Array.isArray(body.unavailableSections) ? body.unavailableSections.filter((value: unknown) => typeof value === 'string' && allowed.includes(value)) : []}
  } catch (error) {
    // Only an undeployed method can use the legacy contract. Outages and invalid
    // payloads must remain visible rather than becoming a successful empty profile.
    if (!(error instanceof Error) || !/GetEmployeeProfileDetails/i.test(error.message) || !/not.*(valid|found|exist|supported)|unknown|invalid.*method|method.*invalid|SOAPAction/i.test(error.message)) throw error
  }
  const filter = odataString(employeeNo)
  const results = await Promise.allSettled([
    services.odata('QyHREmployee', {$filter:`No eq '${filter}'`,$top:1}),
    services.soap('FnGetEmployeeProfile', {employeeNo}),
    services.odata('QyHREmployeeKin', {$filter:`EmployeeCode eq '${filter}'`}),
    services.odata('QyEmploymentHistory', {$filter:`Employee_No eq '${filter}'`}),
  ])
  const hr = results[0].status === 'fulfilled' ? results[0].value[0] : undefined
  const soap = results[1].status === 'fulfilled' ? parseLegacyProfile(results[1].value.returnValue) : {}
  if (!hr && !profilePick(soap,'FullName')) throw Object.assign(new Error('Could not load your employee profile from Business Central.'),{status:502})
  const unavailableSections = ['qualifications','assets','details']
  if (results[2].status === 'rejected') unavailableSections.push('kin')
  if (results[3].status === 'rejected') unavailableSections.push('history')
  if (results[0].status === 'rejected' || results[1].status === 'rejected') unavailableSections.push('bio','contract')
  return {...mapProfileDetails(mergeProfileRecords(hr ?? {},soap,{No:employeeNo}),{
    nextOfKin:results[2].status==='fulfilled'?results[2].value:[],
    employmentHistory:results[3].status==='fulfilled'?results[3].value:[],
  }),unavailableSections}
}
