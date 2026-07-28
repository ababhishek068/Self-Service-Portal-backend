import {
  Building2,
  FileBadge,
  Flag,
  Home,
  Landmark,
  ShieldCheck,
  type LucideIcon,
} from 'lucide-react'

export const REQUESTABLE_HR_LETTER_TYPES = [
  'guarantee',
  'external-company',
  'experience',
  'mortgage',
  'emergency-staff-loan',
  'embassy',
] as const

export type RequestableHrLetterType = (typeof REQUESTABLE_HR_LETTER_TYPES)[number]
export type HrLetterType = RequestableHrLetterType | 'guarantee-external'

export type HrLetterStatus =
  | 'Submitted'
  | 'In Progress'
  | 'Approved'
  | 'Rejected'
  | 'Ready for Collection'
  | 'Completed'
  | 'Cancelled'

export interface HrLetterTypeOption {
  value: RequestableHrLetterType
  label: string
  shortLabel: string
  description: string
  icon: LucideIcon
  turnaround: string
}

export const HR_LETTER_TYPES: HrLetterTypeOption[] = [
  {
    value: 'guarantee',
    label: 'Guarantee Letter',
    shortLabel: 'Guarantee Letter',
    description: 'Request an official guarantee letter addressed to a named recipient or organisation.',
    icon: ShieldCheck,
    turnaround: '3–5 working days',
  },
  {
    value: 'external-company',
    label: 'Letter for External Company',
    shortLabel: 'External Company',
    description: 'Request an employment, introduction, or confirmation letter for an external company.',
    icon: Building2,
    turnaround: '3–5 working days',
  },
  {
    value: 'experience',
    label: 'Experience Letter',
    shortLabel: 'Experience Letter',
    description: 'Request confirmation of employment history, role, and service period.',
    icon: FileBadge,
    turnaround: '2–3 working days',
  },
  {
    value: 'mortgage',
    label: 'Letter for Mortgage',
    shortLabel: 'Mortgage Letter',
    description: 'Request employment and salary confirmation for a mortgage application.',
    icon: Home,
    turnaround: '3–5 working days',
  },
  {
    value: 'emergency-staff-loan',
    label: 'Emergency Staff Loan Request',
    shortLabel: 'Emergency Staff Loan',
    description: 'Submit an urgent staff loan request directly to HR for approval or rejection.',
    icon: Landmark,
    turnaround: 'HR decision with reason',
  },
  {
    value: 'embassy',
    label: 'Letter for Embassy',
    shortLabel: 'Embassy Letter',
    description: 'Request an employment confirmation letter for an embassy, consulate, or visa application.',
    icon: Flag,
    turnaround: '3–5 working days',
  },
]

export function isRequestableHrLetterType(value: unknown): value is RequestableHrLetterType {
  return REQUESTABLE_HR_LETTER_TYPES.includes(value as RequestableHrLetterType)
}

export function hrLetterTypeLabel(value: HrLetterType) {
  if (value === 'guarantee-external') {
    return 'Guarantee & Other Letters for External Companies (Legacy)'
  }
  return HR_LETTER_TYPES.find((option) => option.value === value)?.label ?? value
}

export interface HrLetterFieldConfig {
  name: string
  label: string
  type: 'text' | 'textarea' | 'number' | 'date' | 'select'
  placeholder?: string
  required?: boolean
  options?: Array<{ label: string; value: string }>
}

const deliveryField: HrLetterFieldConfig = {
  name: 'deliveryMethod',
  label: 'Preferred delivery method',
  type: 'select',
  placeholder: 'Select delivery method',
  required: true,
  options: [
    { label: 'Printed copy', value: 'Printed copy' },
    { label: 'Email / soft copy', value: 'Email / soft copy' },
    { label: 'Both printed and email copies', value: 'Both printed and email copies' },
  ],
}

const requiredByField: HrLetterFieldConfig = {
  name: 'requiredByDate',
  label: 'Required by date',
  type: 'date',
  required: true,
}

const emergencyLoanDeliveryField: HrLetterFieldConfig = {
  name: 'deliveryMethod',
  label: 'Preferred delivery method',
  type: 'select',
  placeholder: 'Select delivery method',
  required: true,
  options: [
    { label: 'Bank transfer', value: 'Bank transfer' },
    { label: 'Cash / cheque', value: 'Cash / cheque' },
    { label: 'Other arrangement with HR', value: 'Other arrangement with HR' },
  ],
}

const yesNoOptions = [
  { label: 'Yes', value: 'Yes' },
  { label: 'No', value: 'No' },
]

export const HR_LETTER_FIELDS: Record<RequestableHrLetterType, HrLetterFieldConfig[]> = {
  guarantee: [
    { name: 'recipientOrganization', label: 'Recipient organisation', type: 'text', placeholder: 'Organisation receiving the guarantee letter', required: true },
    { name: 'recipientAddress', label: 'Recipient address', type: 'textarea', placeholder: 'Full postal or physical address', required: true },
    { name: 'addressedTo', label: 'Addressed to', type: 'text', placeholder: 'Recipient name and title', required: true },
    { name: 'guaranteePurpose', label: 'Purpose of guarantee', type: 'textarea', placeholder: 'Explain why the guarantee letter is required', required: true },
    // Per the bank's SSP template (17-07-2026): the person being guaranteed, both optional.
    { name: 'guaranteePersonName', label: 'Guarantee person name (optional)', type: 'text', placeholder: 'Full name of the person the guarantee covers' },
    { name: 'guaranteePersonId', label: 'Guarantee person ID (optional)', type: 'text', placeholder: 'National ID / passport number of the guarantee person' },
    { name: 'guaranteeDetails', label: 'Guarantee details / required wording', type: 'textarea', placeholder: 'State the commitment or wording the recipient requires', required: true },
    { name: 'supportingReference', label: 'Reference number (optional)', type: 'text', placeholder: 'Tender, application, or recipient reference number' },
    requiredByField,
    deliveryField,
  ],
  'external-company': [
    { name: 'externalCompanyName', label: 'External company name', type: 'text', placeholder: 'Registered name of the recipient company', required: true },
    { name: 'externalCompanyAddress', label: 'External company address', type: 'textarea', placeholder: 'Full postal or physical address', required: true },
    { name: 'contactPerson', label: 'Contact person', type: 'text', placeholder: 'Recipient contact name and title', required: true },
    { name: 'contactPhoneOrEmail', label: 'Contact phone or email', type: 'text', placeholder: 'Official contact information', required: true },
    { name: 'purpose', label: 'Purpose of letter', type: 'textarea', placeholder: 'Explain why the external company requires the letter', required: true },
    { name: 'requiredContent', label: 'Required content / wording', type: 'textarea', placeholder: 'List facts or wording that HR should include', required: true },
    requiredByField,
    deliveryField,
  ],
  experience: [
    { name: 'recipientOrganization', label: 'Recipient organisation (optional)', type: 'text', placeholder: 'Organisation receiving the experience letter' },
    { name: 'addressedTo', label: 'Addressed to', type: 'text', placeholder: 'Recipient name/title or “To Whom It May Concern”', required: true },
    { name: 'purpose', label: 'Purpose', type: 'textarea', placeholder: 'Visa, further studies, new employment, professional registration, etc.', required: true },
    { name: 'includeJobHistory', label: 'Include job/position history?', type: 'select', placeholder: 'Select Yes or No', required: true, options: yesNoOptions },
    { name: 'includeSalary', label: 'Include salary information?', type: 'select', placeholder: 'Select Yes or No', required: true, options: yesNoOptions },
    { name: 'additionalInstructions', label: 'Additional instructions (optional)', type: 'textarea', placeholder: 'Any special content or format requested by the recipient' },
    requiredByField,
    deliveryField,
  ],
  mortgage: [
    { name: 'bankName', label: 'Bank / financial institution', type: 'text', placeholder: 'Name of the mortgage lender', required: true },
    { name: 'bankBranch', label: 'Branch', type: 'text', placeholder: 'Branch name or location', required: true },
    { name: 'bankAddress', label: 'Bank address', type: 'textarea', placeholder: 'Full postal or physical address', required: true },
    { name: 'addressedTo', label: 'Addressed to', type: 'text', placeholder: 'Bank contact name/title or department', required: true },
    { name: 'loanAmount', label: 'Requested mortgage amount (ETB)', type: 'number', placeholder: 'Enter an amount greater than zero', required: true },
    { name: 'mortgagePurpose', label: 'Mortgage purpose', type: 'textarea', placeholder: 'Property purchase, construction, refinancing, etc.', required: true },
    { name: 'applicationReference', label: 'Application/reference number (optional)', type: 'text', placeholder: 'Bank application or customer reference' },
    requiredByField,
    deliveryField,
  ],
  'emergency-staff-loan': [
    { name: 'addressedTo', label: 'Addressed to', type: 'text', placeholder: 'Staff Loan Committee, HR, or named recipient', required: true },
    { name: 'loanAmount', label: 'Requested loan amount (ETB)', type: 'number', placeholder: 'Enter an amount greater than zero', required: true },
    { name: 'loanPurpose', label: 'Loan purpose', type: 'textarea', placeholder: 'Explain what the emergency loan will cover', required: true },
    { name: 'urgentReason', label: 'Reason for urgency', type: 'textarea', placeholder: 'Explain why urgent processing is required', required: true },
    { name: 'requestedDisbursementDate', label: 'Requested disbursement date', type: 'date', required: true },
    emergencyLoanDeliveryField,
  ],
  embassy: [
    { name: 'embassyName', label: 'Embassy / consulate name', type: 'text', placeholder: 'Official name of the embassy or consulate', required: true },
    { name: 'embassyCountry', label: 'Embassy country', type: 'text', placeholder: 'Country represented by the embassy', required: true },
    { name: 'embassyAddress', label: 'Embassy address', type: 'textarea', placeholder: 'Full embassy or consulate address', required: true },
    { name: 'addressedTo', label: 'Addressed to', type: 'text', placeholder: 'Consular section, visa officer, or named recipient', required: true },
    { name: 'passportNumber', label: 'Passport number', type: 'text', placeholder: 'Passport number as printed on the passport', required: true },
    { name: 'visaType', label: 'Visa type', type: 'text', placeholder: 'Tourist, business, study, family visit, etc.', required: true },
    { name: 'destinationCountry', label: 'Destination country', type: 'text', placeholder: 'Primary country of travel', required: true },
    { name: 'purposeOfTravel', label: 'Purpose of travel', type: 'textarea', placeholder: 'Explain the purpose of the trip', required: true },
    { name: 'travelStartDate', label: 'Travel start date', type: 'date', required: true },
    { name: 'travelEndDate', label: 'Travel end date', type: 'date', required: true },
    requiredByField,
    deliveryField,
  ],
}
