import { useQuery } from '@tanstack/react-query'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { fetchSalaryAdvanceContext, salaryAdvanceModule } from '@/api/endpoints/salaryAdvance'
import { SalaryAdvanceDocument } from '@/components/hr/SalaryAdvanceDocument'
import { SalaryAdvanceForm } from '@/components/hr/SalaryAdvanceForm'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { SALARY_ADVANCE_AFTER_APPROVAL, SALARY_ADVANCE_APPROVERS } from '@/data/processStages'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { salaryAdvanceSchema } from '@/schemas/requestSchemas'
import { isEsspSalaryAdvance } from '@/utils/salaryAdvanceText'

/**
 * ESSP Staff Salary Advance Request (ABH Partners PLC Staff Salary Advance Request Form and the ESSP
 * infographic; BC 1.0.3.652): request, verify, approve, and recover through payroll.
 */
export function SalaryAdvance() {
  // BC 1.0.3.652 keeps the form on the document; then a draft from the old form must be completed first.
  const contextQuery = useQuery({
    queryKey: ['salary-advance', 'context', ''],
    queryFn: () => fetchSalaryAdvanceContext(),
    staleTime: 60_000,
  })
  const supportsForm = contextQuery.data?.supportsDetails === true

  return (
    <MultiStepRequestPage
      title="Salary Advance Request"
      headerLabel="New Salary Advance Request"
      description="Request a salary advance for a genuine personal or emergency need. It is interest-free, at most one month's net salary, and repaid through equal monthly payroll deductions within three months. Approval: Line Manager (recommends), HR Manager (verifies eligibility), Chief Financial Officer (approves). Finance then pays it and sets up the payroll deduction."
      module={salaryAdvanceModule}
      queryKey={['hr', 'salary-advance']}
      listRequests={() => listModuleRequests(salaryAdvanceModule)}
      listStatusFilter
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      newButtonLabel="New Salary Advance"
      headerSchema={salaryAdvanceSchema}
      headerDefaults={{ purpose: '', percentageSalary: 0 }}
      headerFields={[]}
      customCreate={({ onCreated, onCancel }) => <SalaryAdvanceForm onSaved={onCreated} onCancel={onCancel} />}
      customEdit={({ request, onSaved, onCancel }) => (
        <SalaryAdvanceForm request={request} onSaved={() => onSaved()} onCancel={onCancel} />
      )}
      progressApprovers={SALARY_ADVANCE_APPROVERS}
      progressAfterApproval={() => SALARY_ADVANCE_AFTER_APPROVAL}
      submitButtonLabel="Submit for Approval"
      submitConfirmTitle="Submit the salary advance for approval?"
      submitConfirmMessage="It goes to your Line Manager, then the HR Manager, then the Chief Financial Officer."
      validateBeforeSubmit={(request) => {
        const payload = request.payload ?? {}
        if (isEsspSalaryAdvance(request)) {
          const accepted = payload.DeclarationAccepted === true || String(payload.DeclarationAccepted ?? '').toLowerCase() === 'true'
          return accepted ? null : 'Click Edit and accept the employee declaration and deduction authorization before submitting.'
        }
        return supportsForm
          ? 'Click Edit and complete the Salary Advance form (amount, repayment period, declaration) before submitting.'
          : null
      }}
      detailOverride={({ request, details }) => (isEsspSalaryAdvance(request) ? <SalaryAdvanceDocument request={request} /> : details)}
      // Requests made before the ESSP form (percentage of salary).
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        { label: 'Requested Date', paths: ['payload.Date', 'payload.RequestedDate', 'request.createdAt'], format: 'date' },
        { label: 'Purpose', paths: ['payload.Purpose', 'payload.purpose'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
        { label: 'Amount (ETB)', paths: ['request.amount', 'payload.TotalNetAmount', 'lines.0.Amount'], format: 'currency' },
      ]}
    />
  )
}
