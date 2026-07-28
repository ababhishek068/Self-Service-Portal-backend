import type { FieldValues } from 'react-hook-form'
import { createSalaryAdvanceRequest, listSalaryAdvanceRequests } from '@/api/endpoints/salaryAdvance'
import { RequestFormPage } from '@/components/shared/RequestFormPage'
import { useAuth } from '@/hooks/useAuth'
import { useEmployeeDefaults } from '@/hooks/useEmployeeDefaults'
import { salaryAdvanceSchema, type SalaryAdvanceForm } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'

function salaryAdvanceAmountPreview(values: FieldValues, monthlySalaryBase: number) {
  const percentage = Number(values.percentageSalary ?? 0)
  if (!Number.isFinite(percentage) || percentage <= 0) {
    return (
      <div className="rounded-md border border-slate-200 bg-slate-50 p-3 text-sm text-slate-600">
        Enter the percentage of salary to preview the advance amount from Business Central.
      </div>
    )
  }
  if (monthlySalaryBase <= 0) {
    return (
      <div className="rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-800">
        Monthly salary base is not available from ERP yet. The advance amount will be calculated in
        Business Central when the request is saved.
      </div>
    )
  }
  const amount = Math.round(((monthlySalaryBase * percentage) / 100) * 100) / 100
  return (
    <div className="grid gap-3 rounded-md border border-slate-200 bg-slate-50 p-3 text-sm sm:grid-cols-2">
      <div>
        <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Monthly salary base</p>
        <p className="mt-1 font-semibold text-slate-950">{formatCurrency(monthlySalaryBase)}</p>
      </div>
      <div>
        <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Advance amount</p>
        <p className="mt-1 font-semibold text-slate-950">{formatCurrency(amount)}</p>
      </div>
    </div>
  )
}

export function SalaryAdvance() {
  const { employee } = useAuth()
  const { employeeAccountNumber } = useEmployeeDefaults()
  const monthlySalaryBase = Number(employee?.monthlySalaryBase ?? 0)

  return (
    <RequestFormPage
      title="Salary Advance"
      description="Request an advance against salary with repayment schedule and approval workflow."
      schema={salaryAdvanceSchema}
      queryKey={['hr', 'salary-advance']}
      listRequests={listSalaryAdvanceRequests}
      createRequest={(values) =>
        createSalaryAdvanceRequest(values as SalaryAdvanceForm, employeeAccountNumber)
      }
      moduleConfig={{ module: 'salaryAdvance', entity: 'selfServiceSalaryAdvanceRequests' }}
      defaultValues={{ purpose: '', percentageSalary: 0 }}
      createSupplement={(values) => salaryAdvanceAmountPreview(values, monthlySalaryBase)}
      fields={[
        { name: 'purpose', label: 'Purpose', type: 'textarea', placeholder: 'State the purpose of the advance', valuePaths: ['Purpose'] },
        { name: 'percentageSalary', label: 'Percentage of salary', type: 'number', valuePaths: ['PercentageofSalary', 'lines.0.PercentageofSalary', 'lines.0.PercentageOfSalary'] },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        { label: 'Requested Date', paths: ['payload.Date', 'payload.RequestedDate', 'request.createdAt'], format: 'date' },
        { label: 'Purpose', paths: ['payload.Purpose', 'payload.purpose'] },
        { label: 'Monthly Salary Base', paths: ['payload.monthlySalaryBase', 'payload.Basic_Salary', 'payload.MonthlySalary'], format: 'currency' },
        { label: 'Advance Amount', paths: ['request.amount', 'payload.Amount', 'payload.AdvanceAmount', 'payload.Advance_Amount'], format: 'currency' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      detailLineLabel="Salary Advance Line"
      detailLineColumns={[
        { label: 'Date Taken', paths: ['DateTaken', 'Date_Taken'], format: 'date' },
        { label: 'Type', paths: ['AdvanceType', 'Advance_Type'] },
        { label: 'Purpose', paths: ['Purpose', 'purpose'] },
        { label: 'Percentage of Salary', paths: ['PercentageofSalary', 'PercentageOfSalary', 'Percentage_of_Salary'], format: 'percentage' },
        { label: 'Amount', paths: ['Amount', 'AdvanceAmount', 'Advance_Amount', 'resolvedAmount'], format: 'currency' },
      ]}
      hideDetailAttachments
    />
  )
}
