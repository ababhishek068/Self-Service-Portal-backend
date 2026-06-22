import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { pettyCashTypeOptions } from '@/data/essOptions'
import { pettyCashHeaderSchema, pettyCashLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'pettyCash', entity: 'selfServicePettyCashRequests' } as const

export function PettyCash() {
  const paymentTypes = useLookupOptions('petty-cash-types', pettyCashTypeOptions)

  return (
    <MultiStepRequestPage
      title="Petty Cash Request"
      headerLabel="New Petty Cash Requisition"
      description="Create a petty cash requisition header, then add requisition lines (type and amount) before requesting approval."
      module={module}
      queryKey={['finance', 'petty-cash']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Petty Cash Request"
      headerSchema={pettyCashHeaderSchema}
      headerDefaults={{ dateNeeded: today, description: '' }}
      buildHeaderPayload={(values) => ({ ...values, title: String(values.description || 'Petty Cash Request') })}
      headerFields={[
        { name: 'dateNeeded', label: 'Needed By Date', type: 'date', valuePaths: ['Needed_By_Date', 'RequiredDate', 'Required_Date'] },
        { name: 'description', label: 'Petty Cash Description & Reason', type: 'textarea', valuePaths: ['Posting_Description', 'PostingDescription', 'Narration'] },
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
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
        ],
        emptyText: '*** No Petty Cash Lines Found ***',
      }}
    />
  )
}
