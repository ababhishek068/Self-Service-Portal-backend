import { ArrowRightLeft, ClipboardList, UserMinus, type LucideIcon } from 'lucide-react'

export const EMPLOYEE_EXIT_REQUEST_TYPES = [
  'transfer',
  'resignation',
  'exit-interview',
] as const

export type EmployeeExitRequestType = (typeof EMPLOYEE_EXIT_REQUEST_TYPES)[number]
export type EmployeeExitRequestStatus =
  | 'Open'
  | 'Pending Approval'
  | 'Pending HR Approval'
  | 'Approved'
  | 'Rejected'
  | 'Cancellation Pending Approval'
  | 'Cancelled'
  | 'Completed'

export interface EmployeeExitTypeOption {
  value: EmployeeExitRequestType
  label: string
  shortLabel: string
  description: string
  icon: LucideIcon
}

export const EMPLOYEE_EXIT_TYPES: EmployeeExitTypeOption[] = [
  {
    value: 'transfer',
    label: 'Transfer Request',
    shortLabel: 'Transfer Request',
    description: 'Request a permanent or temporary transfer to another department, branch, or duty station.',
    icon: ArrowRightLeft,
  },
  {
    value: 'resignation',
    label: 'Resignation Application',
    shortLabel: 'Resignation',
    description: 'Submit a formal resignation application and proposed last working date.',
    icon: UserMinus,
  },
  {
    value: 'exit-interview',
    label: 'Employee Exit Form',
    shortLabel: 'Employee Exit',
    description: 'Submit the Employee Exit form directly to HR for information purposes only.',
    icon: ClipboardList,
  },
]

export function isEmployeeExitRequestType(value: unknown): value is EmployeeExitRequestType {
  return EMPLOYEE_EXIT_REQUEST_TYPES.includes(value as EmployeeExitRequestType)
}

export interface EmployeeExitFieldConfig {
  name: string
  label: string
  type: 'text' | 'textarea' | 'date' | 'select' | 'email' | 'tel' | 'multiselect'
  placeholder?: string
  required?: boolean
  options?: Array<{ label: string; value: string }>
  /** When set, the form fills this select's options from a live source (employee directory). */
  optionsSource?: 'employees' | 'departments' | 'divisions'
  /**
   * equals   — visible when the other field equals value (default)
   * includes — visible when the other field's comma-joined multiselect contains value
   * multiple — visible when the other field's multiselect has two or more selections
   */
  showWhen?: { field: string; value?: string; mode?: 'equals' | 'includes' | 'multiple' }
  /** Dates default to today-or-later; the contract termination date may be in the past. */
  allowPast?: boolean
}

const yesNoOptions = [
  { label: 'Yes', value: 'Yes' },
  { label: 'No', value: 'No' },
]

/**
 * Reasons (a)–(o) from Hijra Bank's Employee Exit material, plus "Other".
 * The form allows more than one reason to be selected.
 */
export const EXIT_LEAVING_REASONS = [
  'Dissatisfaction with salary',
  'Dissatisfaction with the type of work',
  'Dissatisfaction with supervisor',
  'Dissatisfaction with co-workers',
  'Dissatisfaction with working condition',
  'Dissatisfaction with benefits',
  'Dissatisfaction with assignment',
  'Unable to be promoted',
  'Family problem',
  'Health problem',
  'To further education',
  'To go abroad',
  'Retirement',
  'Disciplinary measure',
  'Death',
  'Other',
] as const

const reasonOptions = EXIT_LEAVING_REASONS.map((value) => ({ label: value, value }))

export const EMPLOYEE_EXIT_FIELDS: Record<EmployeeExitRequestType, EmployeeExitFieldConfig[]> = {
  transfer: [
    {
      name: 'typeOfTransfer',
      label: 'Type of transfer',
      type: 'select',
      required: true,
      options: [
        { label: 'Permanent', value: 'Permanent' },
        { label: 'Temporary', value: 'Temporary' },
        { label: 'Secondment', value: 'Secondment' },
      ],
    },
    { name: 'desiredDepartment', label: 'Requested department', type: 'select', optionsSource: 'departments', placeholder: 'Select an existing Business Central department', required: true },
    { name: 'desiredLocation', label: 'Requested branch / duty station', type: 'select', optionsSource: 'divisions', placeholder: 'Select an existing Business Central branch / duty station', required: true },
    { name: 'requestedEffectiveDate', label: 'Requested effective date', type: 'date', required: true },
    { name: 'reason', label: 'Reason for transfer', type: 'textarea', placeholder: 'Provide the business or personal justification for the transfer', required: true },
    { name: 'handoverPlan', label: 'Proposed handover plan', type: 'textarea', placeholder: 'Explain how current duties and open work will be handed over', required: true },
    { name: 'supportingInformation', label: 'Supporting information (optional)', type: 'textarea', placeholder: 'Add any relevant reference or supporting details' },
  ],
  resignation: [
    { name: 'lastWorkingDate', label: 'Proposed last working date', type: 'date', required: true },
    { name: 'resignationReason', label: 'Reason for resignation', type: 'textarea', placeholder: 'Provide a clear reason for the resignation', required: true },
    {
      name: 'noticePeriodAcknowledged',
      label: 'I acknowledge the contractual notice-period requirement',
      type: 'select',
      placeholder: 'Select Yes to confirm',
      required: true,
      options: yesNoOptions,
    },
    { name: 'handoverPlan', label: 'Proposed handover plan', type: 'textarea', placeholder: 'Explain how duties, files, assets, and open work will be handed over', required: true },
    { name: 'personalEmail', label: 'Personal email after exit', type: 'email', placeholder: 'name@example.com', required: true },
    { name: 'personalPhone', label: 'Personal phone after exit', type: 'tel', placeholder: 'Phone number HR can use after exit', required: true },
    { name: 'forwardingAddress', label: 'Forwarding address (optional)', type: 'textarea', placeholder: 'Postal or physical address after exit' },
    { name: 'companyPropertyNotes', label: 'Company property / clearance notes (optional)', type: 'textarea', placeholder: 'List assets, access cards, files, or other items requiring handover' },
  ],
  // Matches Hijra Bank's 17-07-2026 Employee Exit SSP template exactly.
  'exit-interview': [
    { name: 'supervisorName', label: 'Name of immediate supervisor at time of termination', type: 'select', optionsSource: 'employees', placeholder: 'Select your immediate supervisor', required: true },
    { name: 'contractTerminationDate', label: 'Date contract is terminated', type: 'date', required: true, allowPast: true },
    // UAT 22-07-2026 (HB): "transfer type should be removed" from the Exit Interview form.
    // Transfer type belongs to the Employee Transfer request, not the exit interview.
    { name: 'leavingReasons', label: 'Reason for leaving Hijra Bank (select all that apply)', type: 'multiselect', required: true, options: reasonOptions },
    { name: 'joiningAnotherCompany', label: 'Are you joining another company?', type: 'select', placeholder: 'Select Yes or No', required: true, options: yesNoOptions },
    { name: 'startOwnBusiness', label: 'Are you leaving to start your own business?', type: 'select', placeholder: 'Select Yes or No', required: true, options: yesNoOptions },
    { name: 'otherPlans', label: 'If other plans, please indicate (optional)', type: 'textarea', placeholder: 'Any other plans after leaving Hijra Bank' },
    {
      name: 'wouldReturn',
      label: 'Would you consider returning to Hijra Bank in the future?',
      type: 'select',
      placeholder: 'Select an answer',
      required: true,
      options: [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' },
        { label: 'Maybe', value: 'Maybe' },
      ],
    },
    { name: 'mostSatisfying', label: 'What did you find most satisfying during your stay in Hijra Bank?', type: 'textarea', placeholder: 'Share what you valued most', required: true },
    { name: 'mostFrustrating', label: 'What did you find most frustrating during your stay in Hijra Bank?', type: 'textarea', placeholder: 'Share what frustrated you most', required: true },
    { name: 'additionalComments', label: 'Additional comments (optional)', type: 'textarea', placeholder: 'Any other feedback you would like HR to consider' },
    {
      name: 'confidentialityAcknowledged',
      label: 'I confirm that the information provided is accurate and may be reviewed',
      type: 'select',
      placeholder: 'Select Yes to confirm',
      required: true,
      options: yesNoOptions,
    },
  ],
}
