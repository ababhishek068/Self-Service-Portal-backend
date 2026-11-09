import { createSalaryAdvanceRequest, listSalaryAdvanceRequests } from '@/api/endpoints/salaryAdvance'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { useEmployeeDefaults } from '@/hooks/useEmployeeDefaults'
import { salaryAdvanceSchema, type SalaryAdvanceForm } from '@/schemas/requestSchemas'

export function SalaryAdvance() {
  const { employeeAccountNumber } = useEmployeeDefaults()

  return (
    <RequestFormPage
      title="Salary Advance Request"
      description="Request an advance against salary with repayment schedule and approval workflow."
      schema={salaryAdvanceSchema}
      queryKey={['hr', 'salary-advance']}
      listRequests={listSalaryAdvanceRequests}
      createRequest={(values) =>
        createSalaryAdvanceRequest(values as SalaryAdvanceForm, employeeAccountNumber)
      }
      moduleConfig={{ module: 'salaryAdvance', entity: 'selfServiceSalaryAdvanceRequests' }}
      listContent={<FinanceEmployeeOrgBanner showJobGradeAndDistrict />}
      formHeader={<FinanceEmployeeOrgBanner showJobGradeAndDistrict />}
      defaultValues={{ purpose: '', percentageSalary: 0 }}
      fields={[
        {
          name: 'purpose',
          label: 'Purpose',
          type: 'textarea',
          placeholder: 'State the purpose of the advance',
          valuePaths: ['Purpose'],
        },
        {
          name: 'percentageSalary',
          label: 'Percentage of salary',
          type: 'number',
          valuePaths: ['PercentageofSalary', 'lines.0.PercentageofSalary', 'lines.0.PercentageOfSalary'],
          hint: 'Currency is ETB. Business Central calculates the advance amount as this percentage of your basic salary.',
        },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        { label: 'Requested Date', paths: ['payload.Date', 'payload.RequestedDate', 'request.createdAt'], format: 'date' },
        { label: 'Purpose', paths: ['payload.Purpose', 'payload.purpose'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
        { label: 'Amount (ETB)', paths: ['request.amount', 'payload.TotalNetAmount', 'lines.0.Amount'], format: 'currency' },
      ]}
      detailLineLabel="Salary Advance Line"
      detailLineColumns={[
        { label: 'Date Taken', paths: ['DateTaken', 'Date_Taken'], format: 'date' },
        { label: 'Type', paths: ['AdvanceType', 'Advance_Type'] },
        { label: 'Purpose', paths: ['Purpose', 'purpose'] },
        { label: 'Percentage of Salary', paths: ['PercentageofSalary', 'PercentageOfSalary', 'Percentage_of_Salary'], format: 'percentage' },
        { label: 'Amount (ETB)', paths: ['Amount', 'resolvedAmount', 'amount'], format: 'currency' },
      ]}
    />
  )
}
