import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { pettyCashTypeOptions } from '@/data/essOptions'
import { pettyCashHeaderSchema, pettyCashLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'pettyCash', entity: 'selfServicePettyCashRequests' } as const

export function PettyCash() {
  const paymentTypes = useLookupOptions('petty-cash-types', pettyCashTypeOptions)

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
      requiresAttachmentBeforeSubmit
      requiredAttachmentMessage="Attach at least one supporting document before requesting approval for petty cash."
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

