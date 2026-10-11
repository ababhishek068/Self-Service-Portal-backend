import {
  Building2,
  FileBadge,
  Flag,
  Home,
  Landmark,
  ShieldCheck,
  type LucideIcon,
} from 'lucide-react'

export const HR_LETTER_TYPE_VALUES = [
  'guarantee',
  'external-company',
  'experience',
  'mortgage',
  'emergency-staff-loan',
  'embassy',
] as const

export const REQUESTABLE_HR_LETTER_TYPES = HR_LETTER_TYPE_VALUES

export type HrLetterType = (typeof HR_LETTER_TYPE_VALUES)[number]
export type RequestableHrLetterType = HrLetterType
export type HrLetterStatus =
  | 'Pending Approval'
  | 'Submitted'
  | 'In Progress'
  | 'Approved'
  | 'Rejected'
  | 'Ready for Collection'
  | 'Completed'
  | 'Cancelled'

export interface HrLetterTypeOption {
  value: HrLetterType
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
    description: 'Official guarantee letter addressed to a named recipient or organisation.',
    icon: ShieldCheck,
    turnaround: '3–5 working days',
  },
  {
    value: 'external-company',
    label: 'Letter for External Company',
    shortLabel: 'External Company',
    description: 'Employment, introduction, or confirmation letter for an external company.',
    icon: Building2,
    turnaround: '3–5 working days',
  },
  {
    value: 'experience',
    label: 'Experience Letter',
    shortLabel: 'Experience Letter',
    description: 'Confirmation of employment history, role, and service period.',
    icon: FileBadge,
    turnaround: '2–3 working days',
  },
  {
    value: 'mortgage',
    label: 'Letter for Mortgage',
    shortLabel: 'Mortgage Letter',
    description: 'Employment and salary confirmation for a mortgage application.',
    icon: Home,
    turnaround: '3–5 working days',
  },
  {
    value: 'emergency-staff-loan',
    label: 'Emergency Staff Loan Request',
    shortLabel: 'Emergency Staff Loan',
    description: 'Urgent staff loan request sent to HR for a recorded decision.',
    icon: Landmark,
    turnaround: 'HR decision with reason',
  },
  {
    value: 'embassy',
    label: 'Letter for Embassy',
    shortLabel: 'Embassy Letter',
    description: 'Employment confirmation for an embassy, consulate, or visa application.',
    icon: Flag,
    turnaround: '3–5 working days',
  },
]

export function isHrLetterType(value: unknown): value is HrLetterType {
  return HR_LETTER_TYPE_VALUES.includes(value as HrLetterType)
}

export function isRequestableHrLetterType(value: unknown): value is RequestableHrLetterType {
  return isHrLetterType(value)
}

export function hrLetterTypeLabel(value: HrLetterType) {
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

const deliveryOptions = [
  { label: 'Printed copy', value: 'Printed copy' },
  { label: 'Email / soft copy', value: 'Email / soft copy' },
  { label: 'Both printed and email copies', value: 'Both printed and email copies' },
]
const loanDeliveryOptions = [
  { label: 'Bank transfer', value: 'Bank transfer' },
  { label: 'Cash / cheque', value: 'Cash / cheque' },
  { label: 'Other arrangement with HR', value: 'Other arrangement with HR' },
]
const yesNoOptions = [
  { label: 'Yes', value: 'Yes' },
  { label: 'No', value: 'No' },
]
const requiredBy: HrLetterFieldConfig = {
  name: 'requiredByDate',
  label: 'Required by date',
  type: 'date',
  required: true,
}
const delivery: HrLetterFieldConfig = {
  name: 'deliveryMethod',
  label: 'Preferred delivery method',
  type: 'select',
  required: true,
  options: deliveryOptions,
}

export const HR_LETTER_FIELDS: Record<HrLetterType, HrLetterFieldConfig[]> = {
  guarantee: [
    { name: 'recipientOrganization', label: 'Recipient organisation', type: 'text', required: true },
    { name: 'recipientAddress', label: 'Recipient address', type: 'textarea', required: true },
    { name: 'addressedTo', label: 'Addressed to', type: 'text', required: true },
    { name: 'guaranteePurpose', label: 'Purpose of guarantee', type: 'textarea', required: true },
    { name: 'guaranteePersonName', label: 'Guarantee person name (optional)', type: 'text' },
    { name: 'guaranteePersonId', label: 'Guarantee person ID (optional)', type: 'text' },
    { name: 'guaranteeDetails', label: 'Guarantee details / required wording', type: 'textarea', required: true },
    requiredBy,
    delivery,
  ],
  'external-company': [
    { name: 'externalCompanyName', label: 'External company name', type: 'text', required: true },
    { name: 'externalCompanyAddress', label: 'External company address', type: 'textarea', required: true },
    { name: 'contactPerson', label: 'Contact person', type: 'text', required: true },
    { name: 'contactPhoneOrEmail', label: 'Contact phone or email', type: 'text', required: true },
    { name: 'purpose', label: 'Purpose of letter', type: 'textarea', required: true },
    { name: 'requiredContent', label: 'Required content / wording', type: 'textarea', required: true },
    requiredBy,
    delivery,
  ],
  experience: [
    { name: 'addressedTo', label: 'Addressed to', type: 'text', required: true },
    { name: 'purpose', label: 'Purpose', type: 'textarea', required: true },
    { name: 'includeJobHistory', label: 'Include job/position history?', type: 'select', required: true, options: yesNoOptions },
    { name: 'includeSalary', label: 'Include salary information?', type: 'select', required: true, options: yesNoOptions },
    requiredBy,
    delivery,
  ],
  mortgage: [
    { name: 'bankName', label: 'Bank / financial institution', type: 'text', required: true },
    { name: 'bankBranch', label: 'Branch', type: 'text', required: true },
    { name: 'bankAddress', label: 'Bank address', type: 'textarea', required: true },
    { name: 'addressedTo', label: 'Addressed to', type: 'text', required: true },
    { name: 'loanAmount', label: 'Requested mortgage amount (ETB)', type: 'number', required: true },
    { name: 'mortgagePurpose', label: 'Mortgage purpose', type: 'textarea', required: true },
    requiredBy,
    delivery,
  ],
  'emergency-staff-loan': [
    { name: 'addressedTo', label: 'Addressed to', type: 'text', required: true },
    { name: 'loanAmount', label: 'Requested loan amount (ETB)', type: 'number', required: true },
    { name: 'loanPurpose', label: 'Loan purpose', type: 'textarea', required: true },
    { name: 'urgentReason', label: 'Reason for urgency', type: 'textarea', required: true },
    { name: 'requestedDisbursementDate', label: 'Requested disbursement date', type: 'date', required: true },
    {
      name: 'deliveryMethod',
      label: 'Preferred delivery method',
      type: 'select',
      required: true,
      options: loanDeliveryOptions,
    },
  ],
  embassy: [
    { name: 'embassyName', label: 'Embassy / consulate name', type: 'text', required: true },
    { name: 'embassyCountry', label: 'Embassy country', type: 'text', required: true },
    { name: 'embassyAddress', label: 'Embassy address', type: 'textarea', required: true },
    { name: 'addressedTo', label: 'Addressed to', type: 'text', required: true },
    { name: 'passportNumber', label: 'Passport number', type: 'text', required: true },
    { name: 'visaType', label: 'Visa type', type: 'text', required: true },
    { name: 'destinationCountry', label: 'Destination country', type: 'text', required: true },
    { name: 'purposeOfTravel', label: 'Purpose of travel', type: 'textarea', required: true },
    { name: 'travelStartDate', label: 'Travel start date', type: 'date', required: true },
    { name: 'travelEndDate', label: 'Travel end date', type: 'date', required: true },
    requiredBy,
    delivery,
  ],
}
