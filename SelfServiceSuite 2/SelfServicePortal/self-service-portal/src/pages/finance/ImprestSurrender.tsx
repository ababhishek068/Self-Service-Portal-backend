import { useQuery } from '@tanstack/react-query'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { imprestSurrenderHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const module = { module: 'imprestSurrender', entity: 'selfServiceImprestSurrenders' } as const
const imprestModule = { module: 'imprest', entity: 'selfServiceImprestRequests' } as const

export function ImprestSurrender() {
  const receipts = useLookupOptions('posted-receipts')
  // ESS lets you surrender against a posted/approved imprest. Offer those as the picker source.
  const imprestQuery = useQuery({
    queryKey: ['finance', 'imprest', 'for-surrender'],
    queryFn: () => listModuleRequests(imprestModule),
  })

  const imprestOptions = (imprestQuery.data ?? [])
    .filter((row) => row.status === 'Posted')
    .map((row) => ({
      label: `${row.requestNo} — ${row.title}`,
      value: row.requestNo,
    }))

  return (
    <MultiStepRequestPage
      title="Imprest Surrender"
      headerLabel="New Imprest Surrender"
      description="Select the imprest to surrender. Surrender lines are generated from the imprest; enter the actual spent and cash receipt details, then request approval."
      module={module}
      queryKey={['finance', 'imprest-surrender']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Imprest Surrender"
      headerSchema={imprestSurrenderHeaderSchema}
      headerDefaults={{ imprest: '' }}
      buildHeaderPayload={(values) => ({ imprest: values.imprest, title: `Surrender for ${values.imprest}` })}
      headerFields={[
        {
          name: 'imprest',
          label: 'Imprest to Surrender',
          type: 'select',
          options: imprestOptions,
          placeholder: imprestQuery.isLoading ? 'Loading imprests…' : 'Select imprest',
        },
      ]}
      line={{
        label: 'Imprest Surrender Lines',
        schema: imprestSurrenderHeaderSchema,
        defaultValues: {},
        canAdd: false,
        fields: [],
        editableFields: [
          { name: 'actualSpent', label: 'Actual Spent', type: 'number' },
          { name: 'cashReceiptNo', label: 'Cash Receipt No.', type: 'select', options: receipts.options },
          { name: 'cashReceiptAmount', label: 'Cash Receipt Amount', type: 'number' },
        ],
        columns: [
          { key: 'accountNo', header: 'Account No.' },
          { key: 'surrenderDocNo', header: 'Surrender Doc No' },
          { key: 'accountName', header: 'Account Name' },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'actualSpent', header: 'Actual Spent' },
          { key: 'cashReceiptNo', header: 'Cash Receipt No.' },
          { key: 'cashReceiptAmount', header: 'Cash Receipt Amount' },
        ],
        emptyText: '*** No surrender lines ***',
      }}
      businessRules={[
        'Surrender lines are generated from the selected imprest.',
        'Enter the actual spent and cash receipt details, then Save before requesting approval.',
      ]}
    />
  )
}
