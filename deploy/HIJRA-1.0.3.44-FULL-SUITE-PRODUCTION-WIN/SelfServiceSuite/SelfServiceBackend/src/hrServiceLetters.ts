import {
  callSoapMethod,
  codeunitSoapNamespace,
  deriveCodeunitSoapUrl,
} from './bcClient.js'
import { config } from './config.js'

export const HR_LETTERS_SERVICE_NAME = 'CuPortalHrLetters'

const hrLettersSoapEndpoint = {
  url:
    config.BC_SOAP_LETTERS_CODEUNIT_URL ??
    deriveCodeunitSoapUrl(config.BC_SOAP_CODEUNIT_URL, HR_LETTERS_SERVICE_NAME),
  namespace:
    config.BC_SOAP_LETTERS_NAMESPACE ?? codeunitSoapNamespace(HR_LETTERS_SERVICE_NAME),
}

export const REQUESTABLE_HR_SERVICE_LETTER_TYPES = [
  'guarantee',
  'external-company',
  'experience',
  'mortgage',
  'emergency-staff-loan',
  'embassy',
] as const

/** The legacy combined type remains readable for requests created before this release. */
export const HR_SERVICE_LETTER_TYPES = [
  ...REQUESTABLE_HR_SERVICE_LETTER_TYPES,
  'guarantee-external',
] as const

export type HrServiceLetterType = (typeof HR_SERVICE_LETTER_TYPES)[number]
export type RequestableHrServiceLetterType =
  (typeof REQUESTABLE_HR_SERVICE_LETTER_TYPES)[number]
export type HrServiceLetterStatus =
  | 'Submitted'
  | 'In Progress'
  | 'Approved'
  | 'Rejected'
  | 'Ready for Collection'
  | 'Completed'
  | 'Cancelled'

export type HrServiceLetterRequest = {
  id: string
  requestNo: string
  letterType: HrServiceLetterType
  letterTypeLabel: string
  status: HrServiceLetterStatus
  submittedAt: string
  updatedAt: string
  employeeNo: string
  employeeName: string
  departmentName: string
  details: Record<string, string>
  hrRemarks?: string
  hrDecisionAt?: string
  hrDecisionBy?: string
  /** This request uses the dedicated HR decision queue rather than the generic BC approval entry. */
  approvalRequired: true
}

const LABELS: Record<HrServiceLetterType, string> = {
  guarantee: 'Guarantee Letter',
  'external-company': 'Letter for External Company',
  experience: 'Experience Letter',
  mortgage: 'Letter for Mortgage',
  'emergency-staff-loan': 'Emergency Staff Loan Request',
  embassy: 'Letter for Embassy',
  'guarantee-external': 'Guarantee & Other Letters for External Companies (Legacy)',
}

const REQUIRED_DETAILS: Record<RequestableHrServiceLetterType, string[]> = {
  guarantee: [
    'recipientOrganization',
    'recipientAddress',
    'addressedTo',
    'guaranteePurpose',
    'guaranteeDetails',
    'requiredByDate',
    'deliveryMethod',
  ],
  'external-company': [
    'externalCompanyName',
    'externalCompanyAddress',
    'contactPerson',
    'contactPhoneOrEmail',
    'purpose',
    'requiredContent',
    'requiredByDate',
    'deliveryMethod',
  ],
  experience: [
    'addressedTo',
    'purpose',
    'includeJobHistory',
    'includeSalary',
    'requiredByDate',
    'deliveryMethod',
  ],
  mortgage: [
    'bankName',
    'bankBranch',
    'bankAddress',
    'addressedTo',
    'loanAmount',
    'mortgagePurpose',
    'requiredByDate',
    'deliveryMethod',
  ],
  'emergency-staff-loan': [
    'addressedTo',
    'loanAmount',
    'loanPurpose',
    'urgentReason',
    'requestedDisbursementDate',
    'deliveryMethod',
  ],
  embassy: [
    'embassyName',
    'embassyCountry',
    'embassyAddress',
    'addressedTo',
    'passportNumber',
    'visaType',
    'destinationCountry',
    'purposeOfTravel',
    'travelStartDate',
    'travelEndDate',
    'requiredByDate',
    'deliveryMethod',
  ],
}

const FIELD_LABELS: Record<string, string> = {
  recipientOrganization: 'Recipient organization',
  recipientAddress: 'Recipient address',
  addressedTo: 'Addressed to',
  guaranteePurpose: 'Purpose of guarantee',
  guaranteePersonName: 'Guarantee person name',
  guaranteePersonId: 'Guarantee person ID',
  guaranteeDetails: 'Guarantee details',
  externalCompanyName: 'External company name',
  externalCompanyAddress: 'External company address',
  contactPerson: 'Contact person',
  contactPhoneOrEmail: 'Contact phone or email',
  purpose: 'Purpose',
  requiredContent: 'Required letter content',
  includeJobHistory: 'Include job history',
  includeSalary: 'Include salary',
  bankName: 'Bank or financial institution',
  bankBranch: 'Bank branch',
  bankAddress: 'Bank address',
  loanAmount: 'Loan amount',
  mortgagePurpose: 'Mortgage purpose',
  loanPurpose: 'Loan purpose',
  urgentReason: 'Reason for urgency',
  requestedDisbursementDate: 'Requested disbursement date',
  embassyName: 'Embassy or consulate name',
  embassyCountry: 'Embassy country',
  embassyAddress: 'Embassy address',
  passportNumber: 'Passport number',
  visaType: 'Visa type',
  destinationCountry: 'Destination country',
  purposeOfTravel: 'Purpose of travel',
  travelStartDate: 'Travel start date',
  travelEndDate: 'Travel end date',
  requiredByDate: 'Required by date',
  deliveryMethod: 'Delivery method',
  employeeId: 'Employee ID',
  employeeName: 'Employee Name',
  employeeDepartment: 'Employee Department',
  monthlyBasicSalary: 'Monthly Basic Salary',
}

const LETTER_DELIVERY_METHODS = new Set([
  'Printed copy',
  'Email / soft copy',
  'Both printed and email copies',
])
const EMERGENCY_LOAN_DELIVERY_METHODS = new Set([
  'Bank transfer',
  'Cash / cheque',
  'Other arrangement with HR',
])
const YES_NO_VALUES = new Set(['Yes', 'No'])
const DATE_FIELDS = [
  'requiredByDate',
  'requestedDisbursementDate',
  'travelStartDate',
  'travelEndDate',
] as const

function isIsoDate(value: string) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false
  const parsed = new Date(`${value}T00:00:00Z`)
  return !Number.isNaN(parsed.getTime()) && parsed.toISOString().slice(0, 10) === value
}

/**
 * BC answers an unpublished web service with "Service ... was not found", which is a deployment
 * problem, not a user error — say so instead of leaking the raw SOAP fault.
 */
function hrLettersCallError(error: unknown) {
  const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
  if (/was not found|could not be found|not found/i.test(message)) {
    return Object.assign(
      new Error(
        `The HR letters codeunit is not published in Business Central. Deploy the HR Letters extension and publish codeunit 52110 as the web service "${HR_LETTERS_SERVICE_NAME}".`,
      ),
      { status: 503, code: 'HR_LETTERS_SERVICE_MISSING' },
    )
  }
  return error
}

async function callLettersSoap(method: string, params: Record<string, unknown>) {
  try {
    return await callSoapMethod(method, params, hrLettersSoapEndpoint)
  } catch (error) {
    throw hrLettersCallError(error)
  }
}

function cleanDetails(details: Record<string, unknown>) {
  return Object.fromEntries(
    Object.entries(details)
      .slice(0, 30)
      .map(([key, value]) => [key.slice(0, 80), String(value ?? '').trim().slice(0, 4000)]),
  )
}

export function validateHrServiceLetterDetails(
  letterType: RequestableHrServiceLetterType,
  details: Record<string, string>,
) {
  const errors: string[] = []
  const missing = REQUIRED_DETAILS[letterType].filter((key) => !details[key]?.trim())
  if (missing.length > 0) {
    const fields = missing.map((key) => FIELD_LABELS[key] ?? key).join(', ')
    errors.push(`Complete the required fields: ${fields}.`)
  }

  if (['mortgage', 'emergency-staff-loan'].includes(letterType) && details.loanAmount?.trim()) {
    const amount = Number(details.loanAmount)
    if (!Number.isFinite(amount) || amount <= 0) {
      errors.push('Loan amount must be greater than zero.')
    }
  }

  if (letterType === 'embassy') {
    const start = details.travelStartDate?.slice(0, 10) ?? ''
    const end = details.travelEndDate?.slice(0, 10) ?? ''
    if (start && end && end < start) {
      errors.push('Travel end date must be on or after the travel start date.')
    }
  }

  for (const key of DATE_FIELDS) {
    const value = details[key]?.trim()
    if (value && !isIsoDate(value)) {
      errors.push(`${FIELD_LABELS[key] ?? key} must be a valid date.`)
    }
  }

  const validDeliveryMethods =
    letterType === 'emergency-staff-loan'
      ? EMERGENCY_LOAN_DELIVERY_METHODS
      : LETTER_DELIVERY_METHODS
  if (details.deliveryMethod && !validDeliveryMethods.has(details.deliveryMethod)) {
    errors.push('Select a valid delivery method.')
  }
  if (details.monthlyBasicSalary?.trim()) {
    const salary = Number(details.monthlyBasicSalary)
    if (!Number.isFinite(salary) || salary <= 0) {
      errors.push('Monthly basic salary must be greater than zero when provided.')
    }
  }
  for (const key of ['includeJobHistory', 'includeSalary']) {
    if (details[key] && !YES_NO_VALUES.has(details[key])) {
      errors.push(`${FIELD_LABELS[key] ?? key} must be Yes or No.`)
    }
  }

  return errors
}

/** Rows come back from BC as a JSON array from the codeunit. */
export function parseHrServiceLetterRows(value: unknown): HrServiceLetterRequest[] {
  if (!value) return []
  let parsed: unknown
  try {
    parsed = JSON.parse(String(value))
  } catch {
    throw Object.assign(new Error('Business Central returned invalid HR service request data.'), {
      status: 502,
    })
  }
  if (!Array.isArray(parsed)) return []
  return parsed
    .filter((row): row is HrServiceLetterRequest => {
      if (!row || typeof row !== 'object') return false
      const request = row as Partial<HrServiceLetterRequest>
      return Boolean(
        request.requestNo &&
          HR_SERVICE_LETTER_TYPES.includes(request.letterType as HrServiceLetterType),
      )
    })
    .map((row) => ({
      ...row,
      id: row.id || row.requestNo,
      letterTypeLabel:
        row.letterType === 'emergency-staff-loan'
          ? LABELS[row.letterType]
          : row.letterTypeLabel || LABELS[row.letterType],
      details: row.details ?? {},
      approvalRequired: true as const,
    }))
}

export async function listHrServiceLetterRequests(employeeNo: string) {
  const result = await callLettersSoap('GetHrLetterRequests', { employeeNo })
  return parseHrServiceLetterRows(result.returnValue).sort((left, right) =>
    right.submittedAt.localeCompare(left.submittedAt),
  )
}

export async function createHrServiceLetterRequest(input: {
  letterType: RequestableHrServiceLetterType
  employeeNo: string
  employeeName: string
  departmentName: string
  monthlySalaryBase?: number
  details: Record<string, unknown>
}) {
  const employeeDetails = {
    employeeId: input.employeeNo,
    employeeName: input.employeeName,
    employeeDepartment: input.departmentName,
    monthlyBasicSalary:
      input.monthlySalaryBase && input.monthlySalaryBase > 0
        ? String(input.monthlySalaryBase)
        : '',
  }
  // Identity and salary come from the authenticated Business Central session, never from
  // editable browser fields. Re-applying the values after the payload also prevents spoofing.
  const details = cleanDetails(
    input.letterType === 'emergency-staff-loan'
      ? { ...employeeDetails, ...input.details, ...employeeDetails }
      : input.details,
  )
  const errors = validateHrServiceLetterDetails(input.letterType, details)
  if (errors.length > 0) {
    throw Object.assign(new Error(errors.join(' ')), { status: 422 })
  }

  const saved = await callLettersSoap('SaveHrLetterRequest', {
    employeeNo: input.employeeNo,
    employeeName: input.employeeName,
    departmentName: input.departmentName,
    letterType: input.letterType,
    detailsJson: JSON.stringify(details),
  })
  const requestNo = String(saved.returnValue ?? '').trim()
  if (!requestNo) {
    throw Object.assign(
      new Error('Business Central did not return an HR service request number.'),
      { status: 502 },
    )
  }

  const request = (await listHrServiceLetterRequests(input.employeeNo)).find(
    (row) => row.requestNo === requestNo,
  )
  if (request) return request

  const now = new Date().toISOString()
  return {
    id: requestNo,
    requestNo,
    letterType: input.letterType,
    letterTypeLabel: LABELS[input.letterType],
    status: 'Submitted',
    submittedAt: now,
    updatedAt: now,
    employeeNo: input.employeeNo,
    employeeName: input.employeeName,
    departmentName: input.departmentName,
    details,
    approvalRequired: true,
  } satisfies HrServiceLetterRequest
}

export async function cancelHrServiceLetterRequest(id: string, employeeNo: string) {
  const result = await callLettersSoap('CancelHrLetterRequest', {
    employeeNo,
    requestNo: id,
  })
  if (!['true', '1', 'yes'].includes(String(result.returnValue ?? '').trim().toLowerCase())) {
    return null
  }
  return (
    (await listHrServiceLetterRequests(employeeNo)).find((row) => row.requestNo === id) ?? null
  )
}

/**
 * Approver side: letter requests (Submitted / In Progress) waiting for HR — returned only when
 * the logged-in user is the configured HR approver. Powers the "HR Letters" tab in Approvals.
 */
export async function listHrServiceLetterApprovals(approverUserIds: string) {
  if (!approverUserIds?.trim()) return []
  const result = await callLettersSoap('GetHrLetterApprovals', { approverUserIds })
  return parseHrServiceLetterRows(result.returnValue).sort((left, right) =>
    right.submittedAt.localeCompare(left.submittedAt),
  )
}

/**
 * Approve or reject a letter AS the logged-in HR approver. A reason is always required (the bank
 * flow shows it to the employee). The real approver id is validated in AL, not the SOAP session.
 */
export async function decideHrServiceLetterApproval(input: {
  approverUserId: string
  id: string
  approve: boolean
  remarks?: string
}) {
  const remarks = (input.remarks ?? '').trim()
  if (remarks.length < 3) {
    throw Object.assign(new Error('A reason is required to record the decision.'), { status: 422 })
  }
  const result = await callLettersSoap('DecideHrLetterApproval', {
    approverUserIds: input.approverUserId,
    requestNo: input.id,
    approve: input.approve ? 'true' : 'false',
    remarks,
  })
  if (!['true', '1', 'yes'].includes(String(result.returnValue ?? '').trim().toLowerCase())) {
    throw Object.assign(new Error('Business Central did not record the letter decision.'), {
      status: 422,
    })
  }
  return listHrServiceLetterApprovals(input.approverUserId)
}
