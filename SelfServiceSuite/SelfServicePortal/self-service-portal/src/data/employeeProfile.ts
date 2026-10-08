/**
 * Extended employee profile sections aligned with the HR UAT test cases:
 * job details, important dates, next of kin, employment history,
 * qualifications, assigned assets, and contract details.
 */
export interface NextOfKin extends Record<string, string> {
  name: string
  relationship: string
  phone: string
  address: string
}

export interface EmploymentRecord extends Record<string, string> {
  organisation: string
  position: string
  fromDate: string
  toDate: string
  type: string
}

export interface Qualification extends Record<string, string> {
  title: string
  institution: string
  year: string
  level: string
}

export interface AssignedAsset extends Record<string, string> {
  tagNumber: string
  description: string
  assignedDate: string
  status: string
}

export interface EmployeeProfileDetails {
  employeeNo?: string
  fullName?: string
  unavailableSections?: string[]
  employeeType?: string
  homePhoneNumber?: string
  personalEmail?: string
  extension?: string
  country?: string
  residentialAddress?: string
  city?: string
  postCode?: string
  region?: string
  placeOfDuty?: string
  noticePeriod?: string
  supervisorNo?: string
  supervisorName?: string
  actingJob?: string
  actingJobStartDate?: string
  actingJobExpiryDate?: string
  temporaryJob?: string
  temporaryJobExpiryDate?: string
  dateOfLeaving?: string
  pensionSchemeJoin?: string
  medicalSchemeJoin?: string
  jobTitle?: string
  jobGrade?: string
  jobId?: string
  monthlySalaryBase?: number
  sector: string
  division: string
  department?: string
  district: string
  branch?: string
  maritalStatus: string
  employmentType: string
  gender: string
  phoneNumber: string
  workPhoneNumber?: string
  email?: string
  idNumber?: string
  status?: string
  annualLeaveBalance?: string
  employeeAccountNo?: string
  responsibilityCenter?: string
  dateOfBirth?: string
  nationality?: string
  postalAddress?: string
  dateOfJoin: string
  contractStartDate: string
  contractEndDate: string
  probationEndDate: string
  onProbation?: string
  contractDuration?: string
  nextOfKin: NextOfKin[]
  employmentHistory: EmploymentRecord[]
  qualifications: Qualification[]
  assignedAssets: AssignedAsset[]
}

