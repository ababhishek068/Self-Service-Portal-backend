import { createSalaryAdvanceRequest, listSalaryAdvanceRequests } from '@/api/endpoints/salaryAdvance'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { salaryAdvanceSchema, type SalaryAdvanceForm } from '@/schemas/requestSchemas'

export function SalaryAdvance() {
  return (
    <RequestFormPage
      title="Salary Advance"
      description="Request an advance against salary with repayment schedule and approval workflow."
      schema={salaryAdvanceSchema}
      queryKey={['hr', 'salary-advance']}
      listRequests={listSalaryAdvanceRequests}
      createRequest={(values) => createSalaryAdvanceRequest(values as SalaryAdvanceForm)}
      moduleConfig={{ module: 'salaryAdvance', entity: 'selfServiceSalaryAdvanceRequests' }}
      defaultValues={{ purpose: '', percentageSalary: 0 }}
      fields={[
        { name: 'purpose', label: 'Purpose', type: 'textarea', placeholder: 'State the purpose of the advance' },
        { name: 'percentageSalary', label: 'Percentage of salary', type: 'number' },
      ]}
      businessRules={[
        'The percentage cannot exceed 100 percent of salary.',
        'Advance routes through payroll approval workflow.',
        'Repayment terms are calculated in Business Central.',
      ]}
    />
  )
}
