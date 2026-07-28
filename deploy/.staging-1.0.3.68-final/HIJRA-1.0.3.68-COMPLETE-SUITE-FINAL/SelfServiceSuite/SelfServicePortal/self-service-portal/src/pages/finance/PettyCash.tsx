import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { pettyCashTypeOptions } from '@/data/essOptions'
import { pettyCashHeaderSchema, pettyCashLineSchema } from '@/schemas/requestSchemas'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'pettyCash', entity: 'selfServicePettyCashRequests' } as const

export function PettyCash() {
  const paymentTypes = useLookupOptions('petty-cash-types', pettyCashTypeOptions)

  return (
    <MultiStepRequestPage
      title="Petty Cash Settlement"
      headerLabel="New Petty Cash Settlement"
      description="Create a petty cash requisition header, then add requisition lines (type and amount) before requesting approval."
      module={module}
      queryKey={['finance', 'petty-cash']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      newButtonLabel="New Petty Cash Settlement"
      headerSchema={pettyCashHeaderSchema}
      headerDefaults={{ dateNeeded: today, description: '' }}
      buildHeaderPayload={(values) => ({ ...values, title: String(values.description || 'Petty Cash Settlement') })}
      headerFields={[
        // BC stores the needed-by date in "Date" and the description in "Payment Narration"
        // (see FnPettyCashHeader in the staff portal codeunit).
        { name: 'dateNeeded', label: 'Needed By Date', type: 'date', valuePaths: ['Needed_By_Date', 'RequiredDate', 'Required_Date', 'Date'] },
        { name: 'description', label: 'Petty Cash Description & Reason', type: 'textarea', valuePaths: ['PaymentNarration', 'Payment_Narration', 'Posting_Description', 'PostingDescription', 'Narration'] },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        {
          label: 'Needed By Date',
          paths: ['payload.Needed_By_Date', 'payload.RequiredDate', 'payload.Required_Date', 'payload.Date', 'request.createdAt'],
          format: 'date',
        },
        {
          label: 'Description',
          paths: [
            'payload.PaymentNarration',
            'payload.Payment_Narration',
            'payload.Posting_Description',
            'payload.PostingDescription',
            'payload.Narration',
          ],
        },
        { label: 'Duration', paths: ['payload.DurationDate'] },
        {
          label: 'Department',
          paths: [
            'request.departmentName',
            'request.departmentCode',
            'payload.DepartmentName',
            'payload.Department',
            'payload.GlobalDimension1Code',
          ],
        },
        {
          label: 'Responsibility Center',
          paths: [
            'request.responsibleCenter',
            'payload.ResponsibilityCenter',
            'payload.Responsibility_Center',
            'payload.JobTitle',
            'payload.Job_Title',
          ],
        },
        {
          label: 'Employee Account',
          paths: [
            'payload.EmployeeAccountNo',
            'payload.Employee_Account_No',
            'payload.CustomerNo',
            'payload.ImprestNo',
          ],
        },
        {
          label: 'Total Net Amount',
          paths: [
            'payload.TotalNetAmount',
            'payload.Total_Net_Amount',
            'payload.TotalPaymentAmount',
            'payload.Total_Payment_Amount',
            'payload.Amount',
            'request.amount',
          ],
          format: 'currency',
        },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Petty Cash Lines',
        addLabel: 'Add Line',
        schema: pettyCashLineSchema,
        defaultValues: { type: '', name: '', amount: 0 },
        fields: [
          { name: 'type', label: 'Type', type: 'select', options: paymentTypes.options },
          { name: 'amount', label: 'Amount', type: 'number' },
        ],
        columns: [
          { key: 'type', header: 'Type' },
          { key: 'name', header: 'Name' },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
        ],
        emptyText: '*** No Petty Cash Lines Found ***',
      }}
    />
  )
}
