import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { pettyCashHeaderSchema, pettyCashLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'pettyCash', entity: 'selfServicePettyCashRequests' } as const

export function PettyCash() {
  // Never fall back to hardcoded MOBILE/TRANSPORT seeds — BC Receipts & Payment Types
  // codes differ per tenant and Validate(Type) rejects unknown codes.
  const paymentTypes = useLookupOptions('petty-cash-types')

  return (
    <MultiStepRequestPage
      title="Petty Cash Settlement"
      headerLabel="New Petty Cash Settlement"
      description="Create a petty cash settlement header, then add settlement lines (type and amount) before requesting approval. Department float limits apply on Petty Cash Request (replenishment), not on settlement."
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
        { name: 'dateNeeded', label: 'Needed By Date', type: 'date', valuePaths: ['Needed_By_Date', 'RequiredDate', 'Required_Date', 'Date'] },
        { name: 'description', label: 'Petty Cash Description & Reason', type: 'textarea', valuePaths: ['PaymentNarration', 'Payment_Narration', 'Posting_Description', 'PostingDescription', 'Narration'] },
      ]}
      headerSupplement={() => <FinanceEmployeeOrgBanner />}
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
        {
          label: 'Employee No.',
          paths: ['payload.EmployeeNo', 'payload.Employee_No', 'request.makerEmployeeNo'],
        },
        {
          label: 'Payee / Employee Name',
          paths: ['payload.Payee', 'payload.EmployeeName', 'payload.Employee_Name', 'request.makerName'],
        },
        {
          label: 'Employee Account No.',
          paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.AccountNo'],
        },
        {
          label: 'Pay Mode',
          paths: ['payload.PayMode', 'payload.Pay_Mode', 'payload.PaymentMethod'],
        },
        ...financeOrgDetailFields,
        {
          label: 'Job Title',
          paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
        },
        {
          label: 'Job Grade',
          paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
        },
        {
          label: 'Place of Duty',
          paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.Place_of_Duty', 'payload.DutyArea'],
        },
        {
          label: 'Responsibility Center',
          paths: [
            'request.responsibleCenter',
            'payload.ResponsibilityCenter',
            'payload.Responsibility_Center',
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
        {
          label: 'Rejection Reason',
          paths: ['payload.RejectionReason', 'payload.rejectionReason', 'payload.Comment', 'payload.Comments'],
        },
      ]}
      line={{
        label: 'Petty Cash Lines',
        addLabel: 'Add Line',
        schema: pettyCashLineSchema,
        defaultValues: { type: '', name: '', amount: 0 },
        fields: [
          {
            name: 'type',
            label: 'Type',
            type: 'select',
            options: paymentTypes.options,
            placeholder: paymentTypes.isLoading
              ? 'Loading BC payment types…'
              : paymentTypes.isError
                ? 'Could not load Receipts & Payment Types from BC'
                : paymentTypes.options.length
                  ? 'Select BC payment type'
                  : 'No payment types published in BC',
          },
          { name: 'amount', label: 'Amount', type: 'number' },
        ],
        columns: [
          { key: 'type', header: 'Type' },
          { key: 'name', header: 'Account Name' },
          { key: 'accountNo', header: 'Account No.' },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
        ],
        emptyText: '*** No Petty Cash Lines Found ***',
      }}
    />
  )
}
