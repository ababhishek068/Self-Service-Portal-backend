import { Building2, FileBadge, Home, Landmark, type LucideIcon } from 'lucide-react'

export type HrLetterType =
  | 'guarantee-external'
  | 'experience'
  | 'mortgage'
  | 'emergency-staff-loan'

export type HrLetterStatus =
  | 'Pending Approval'
  | 'Approved'
  | 'Ready for Collection'
  | 'Rejected'
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
    value: 'guarantee-external',
    label: 'Guarantee & Other Letters for External Companies',
    shortLabel: 'External / Guarantee',
    description: 'Official guarantee or introduction letters addressed to external organisations.',
    icon: Building2,
    turnaround: '3–5 working days',
  },
  {
    value: 'experience',
    label: 'Experience Letter',
    shortLabel: 'Experience',
    description: 'Confirmation of employment history, role, and service period.',
    icon: FileBadge,
    turnaround: '2–3 working days',
  },
  {
    value: 'mortgage',
    label: 'Letters Required for Mortgage',
    shortLabel: 'Mortgage',
    description: 'Employment and salary confirmation for bank mortgage applications.',
    icon: Home,
    turnaround: '3–5 working days',
  },
  {
    value: 'emergency-staff-loan',
    label: 'Letters Required for Emergency Staff Loan',
    shortLabel: 'Emergency Staff Loan',
    description: 'HR support letter for urgent internal or external staff loan requests.',
    icon: Landmark,
    turnaround: '1–2 working days',
  },
]

export function hrLetterTypeLabel(value: HrLetterType) {
  return HR_LETTER_TYPES.find((option) => option.value === value)?.label ?? value
}

export interface HrLetterFieldConfig {
  name: string
  label: string
  type: 'text' | 'textarea' | 'number' | 'date'
  placeholder?: string
  required?: boolean
}

export const HR_LETTER_FIELDS: Record<HrLetterType, HrLetterFieldConfig[]> = {
  'guarantee-external': [
    { name: 'externalCompanyName', label: 'External company name', type: 'text', placeholder: 'e.g. ABC Trading PLC', required: true },
    { name: 'externalCompanyAddress', label: 'Company address', type: 'textarea', placeholder: 'Full postal address of the recipient organisation', required: true },
    { name: 'contactPerson', label: 'Contact person', type: 'text', placeholder: 'Name of the recipient contact', required: true },
    { name: 'contactPhone', label: 'Contact phone / email', type: 'text', placeholder: 'Phone or email for correspondence', required: true },
    { name: 'purpose', label: 'Purpose of letter', type: 'textarea', placeholder: 'Explain why the guarantee or external letter is required', required: true },
  ],
  experience: [
    { name: 'addressedTo', label: 'Addressed to (optional)', type: 'text', placeholder: 'Embassy, institution, or “To Whom It May Concern”' },
    { name: 'purpose', label: 'Purpose', type: 'textarea', placeholder: 'e.g. Visa application, further studies, new employment', required: true },
    { name: 'includeSalary', label: 'Include salary on letter?', type: 'text', placeholder: 'Yes / No' },
  ],
  mortgage: [
    { name: 'bankName', label: 'Bank / financial institution', type: 'text', placeholder: 'Name of the mortgage lender', required: true },
    { name: 'bankBranch', label: 'Branch', type: 'text', placeholder: 'Branch name or location', required: true },
    { name: 'loanAmount', label: 'Loan amount (ETB)', type: 'number', placeholder: 'Requested mortgage amount', required: true },
    { name: 'purpose', label: 'Additional notes', type: 'textarea', placeholder: 'Any instructions for HR or the bank format', required: true },
  ],
  'emergency-staff-loan': [
    { name: 'loanAmount', label: 'Loan amount (ETB)', type: 'number', placeholder: 'Requested emergency loan amount', required: true },
    { name: 'loanPurpose', label: 'Loan purpose', type: 'textarea', placeholder: 'Brief description of why the loan is needed', required: true },
    { name: 'urgentReason', label: 'Reason for urgency', type: 'textarea', placeholder: 'Explain why this request is time-sensitive', required: true },
  ],
}
