import { useMemo } from 'react'
import { createSalaryAdvanceRequest, listSalaryAdvanceRequests } from '@/api/endpoints/salaryAdvance'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { useAuth } from '@/hooks/useAuth'
import { useEmployeeDefaults } from '@/hooks/useEmployeeDefaults'
import { salaryAdvanceSchema, type SalaryAdvanceForm } from '@/schemas/requestSchemas'

/** Purpose options by division family — ESSP Advance Request requirements. */
const PURPOSE_BY_DIVISION: Record<string, { value: string; label: string }[]> = {
  consulting: [
    { value: 'Research', label: 'Research' },
    { value: 'Surveys', label: 'Surveys' },
    { value: 'Field assessments', label: 'Field assessments' },
    { value: 'Project implementation', label: 'Project implementation' },
  ],
  workforce: [
    { value: 'Staff deployment', label: 'Staff deployment' },
    { value: 'Field supervision', label: 'Field supervision' },
    { value: 'Recruitment activities', label: 'Recruitment activities' },
  ],
  academy: [
    { value: 'Training', label: 'Training' },
    { value: 'Workshops', label: 'Workshops' },
    { value: 'Field-based learning', label: 'Field-based learning' },
  ],
  corporate: [
    { value: 'Procurement missions', label: 'Procurement missions' },
    { value: 'Administration', label: 'Administration' },
    { value: 'Logistics', label: 'Logistics' },
    { value: 'Operational assignments', label: 'Operational assignments' },
  ],
  general: [{ value: 'Other', label: 'Other (Specify)' }],
}

function divisionFamily(divisionOrDept: string) {
  const text = divisionOrDept.toLowerCase()
  if (text.includes('academy') || text.includes('training')) return 'academy'
  if (text.includes('workforce') || text.includes('hr') || text.includes('recruit')) return 'workforce'
  if (text.includes('consult') || text.includes('research') || text.includes('project')) return 'consulting'
  if (
    text.includes('finance') ||
    text.includes('admin') ||
    text.includes('corporate') ||
    text.includes('procure') ||
    text.includes('logistics') ||
    text.includes('it')
  ) {
    return 'corporate'
  }
  return 'general'
}

function buildPurposePayload(values: SalaryAdvanceForm) {
  const parts = [
    values.requestPurpose === 'Other' && values.otherPurposeDetails
      ? `Other: ${values.otherPurposeDetails.trim()}`
      : values.requestPurpose,
    values.justification?.trim() ? `Justification: ${values.justification.trim()}` : '',
    values.requiredAdvanceDate ? `Required advance date: ${values.requiredAdvanceDate}` : '',
    values.activityStartDate ? `Activity start: ${values.activityStartDate}` : '',
    values.activityEndDate ? `Activity end: ${values.activityEndDate}` : '',
    values.activityLocation?.trim() ? `Location: ${values.activityLocation.trim()}` : '',
    values.projectAssignment?.trim() ? `Project: ${values.projectAssignment.trim()}` : '',
  ].filter(Boolean)
  return parts.join(' | ').slice(0, 250)
}

export function SalaryAdvance() {
  const { employee } = useAuth()
  const { employeeAccountNumber } = useEmployeeDefaults()
  const family = divisionFamily(
    `${employee?.departmentCode ?? ''} ${employee?.placeOfDuty ?? ''} ${employee?.jobGrade ?? ''}`,
  )
  const purposeOptions = useMemo(() => {
    const specific = PURPOSE_BY_DIVISION[family] ?? PURPOSE_BY_DIVISION.corporate
    const merged = [...specific, ...PURPOSE_BY_DIVISION.general]
    const seen = new Set<string>()
    return merged.filter((option) => {
      if (seen.has(option.value)) return false
      seen.add(option.value)
      return true
    })
  }, [family])

  return (
    <RequestFormPage
      title="Advance Request"
      description="Request an advance before an approved business activity. Business Central owns approval; this form captures your request and shows status."
      schema={salaryAdvanceSchema}
      queryKey={['hr', 'salary-advance']}
      listRequests={listSalaryAdvanceRequests}
      createRequest={(values) => {
        const form = values as SalaryAdvanceForm
        return createSalaryAdvanceRequest(
          {
            ...form,
            purpose: buildPurposePayload(form),
          },
          employeeAccountNumber,
        )
      }}
      moduleConfig={{ module: 'salaryAdvance', entity: 'selfServiceSalaryAdvanceRequests' }}
      defaultValues={{
        requestPurpose: purposeOptions[0]?.value ?? 'Other',
        otherPurposeDetails: '',
        justification: '',
        requiredAdvanceDate: '',
        activityStartDate: '',
        activityEndDate: '',
        activityLocation: '',
        projectAssignment: '',
        percentageSalary: 0,
        purpose: '',
      }}
      fields={[
        {
          name: 'requestPurpose',
          label: 'Request Purpose',
          type: 'select',
          options: purposeOptions,
          valuePaths: ['payload.Purpose', 'payload.purpose', 'lines.0.Purpose'],
          hint: [
            employee?.displayName ? `Employee: ${employee.displayName}` : null,
            employee?.employeeNo ? `Staff No. ${employee.employeeNo}` : null,
            'Purpose list is filtered for your division. Choose Other to add details.',
          ]
            .filter(Boolean)
            .join(' · '),
        },
        {
          name: 'otherPurposeDetails',
          label: 'Other Purpose Details',
          type: 'textarea',
          fullWidth: true,
          maxLength: 200,
          visibleWhen: (values) => String(values.requestPurpose ?? '') === 'Other',
          placeholder: 'Describe the purpose when Other is selected',
        },
        {
          name: 'justification',
          label: 'Request Justification',
          type: 'textarea',
          fullWidth: true,
          maxLength: 500,
          placeholder: 'Explain why the advance is needed',
          valuePaths: ['payload.Justification'],
        },
        {
          name: 'requiredAdvanceDate',
          label: 'Required Advance Date',
          type: 'date',
          valuePaths: ['payload.PaymentReleaseDate', 'payload.Date', 'lines.0.DueDate'],
          hint: 'Date you need the funds',
        },
        {
          name: 'activityStartDate',
          label: 'Activity Start Date',
          type: 'date',
          valuePaths: ['payload.ActivityStartDate'],
        },
        {
          name: 'activityEndDate',
          label: 'Activity End Date',
          type: 'date',
          valuePaths: ['payload.ActivityEndDate'],
        },
        {
          name: 'activityLocation',
          label: 'Activity Location',
          type: 'text',
          placeholder: 'Where the activity will take place',
          valuePaths: ['payload.ActivityLocation'],
        },
        {
          name: 'projectAssignment',
          label: 'Project / Assignment',
          type: 'text',
          placeholder: 'Optional project or assignment reference',
          valuePaths: ['payload.Project', 'payload.OnBehalfOf'],
        },
        {
          name: 'percentageSalary',
          label: 'Percentage of salary (ETB)',
          type: 'number',
          valuePaths: ['PercentageofSalary', 'lines.0.PercentageofSalary', 'lines.0.PercentageOfSalary'],
          hint: 'Currency is ETB. Business Central calculates the amount as this % of your basic salary.',
        },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        { label: 'Requested Date', paths: ['payload.Date', 'payload.RequestedDate', 'request.createdAt'], format: 'date' },
        { label: 'Purpose', paths: ['payload.Purpose', 'payload.purpose'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
        { label: 'Amount', paths: ['request.amount', 'payload.TotalNetAmount', 'lines.0.Amount'], format: 'currency' },
      ]}
      detailLineLabel="Advance Line"
      detailLineColumns={[
        { label: 'Date Taken', paths: ['DateTaken', 'Date_Taken'], format: 'date' },
        { label: 'Type', paths: ['AdvanceType', 'Advance_Type'] },
        { label: 'Purpose', paths: ['Purpose', 'purpose'] },
        { label: 'Percentage of Salary', paths: ['PercentageofSalary', 'PercentageOfSalary', 'Percentage_of_Salary'], format: 'percentage' },
        { label: 'Amount', paths: ['Amount', 'resolvedAmount', 'amount'], format: 'currency' },
      ]}
    />
  )
}
