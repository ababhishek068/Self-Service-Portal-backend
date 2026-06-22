import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { purchaseLineTypeOptions } from '@/data/essOptions'
import { purchaseHeaderSchema, purchaseLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'purchaseRequisition', entity: 'selfServicePurchaseRequisitions' } as const

export function PurchaseRequisition() {
  const locations = useLookupOptions('locations')
  const items = useLookupOptions('items')
  const assets = useLookupOptions('assets')
  const services = useLookupOptions('services')
  const purchasableOptions = [...services.options, ...items.options, ...assets.options]

  return (
    <MultiStepRequestPage
      title="Purchase Requisition"
      headerLabel="New Purchase Requisition"
      description="Create the purchase header, then add item lines with location and reason before requesting approval."
      module={module}
      queryKey={['facility', 'purchase-requisition']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Request"
      headerSchema={purchaseHeaderSchema}
      headerDefaults={{ dateNeeded: today, description: '' }}
      buildHeaderPayload={(values) => ({
        ...values,
        orderDate: values.dateNeeded,
        postingDescription: values.description,
        reason: values.description,
        title: String(values.description || 'Purchase Requisition'),
      })}
      headerFields={[
        { name: 'dateNeeded', label: 'Needed By Date', type: 'date' },
        { name: 'description', label: 'Description', type: 'textarea' },
      ]}
      line={{
        label: 'Purchase Lines',
        addLabel: 'New Line',
        schema: purchaseLineSchema,
        defaultValues: { itemNo: '', location: '', reasonForRequest: '', quantity: 1, type: '2' },
        buildLinePayload: (values) => ({
          ...values,
          whereNeeded: values.location,
          reason: values.reasonForRequest,
        }),
        fields: [
          { name: 'type', label: 'Type', type: 'select', options: purchaseLineTypeOptions },
          { name: 'itemNo', label: 'Item / Service No.', type: 'select', options: purchasableOptions },
          { name: 'location', label: 'Location', type: 'select', options: locations.options },
          { name: 'quantity', label: 'Quantity', type: 'number' },
          { name: 'reasonForRequest', label: 'Reason for Request', type: 'textarea' },
        ],
        columns: [
          { key: 'type', header: 'Type' },
          { key: 'itemNo', header: 'Item No.' },
          { key: 'location', header: 'Location' },
          { key: 'quantity', header: 'Quantity' },
          { key: 'reasonForRequest', header: 'Reason' },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
        ],
        emptyText: '*** No Purchase Lines Found ***',
      }}
      businessRules={[
        'Create the header with needed-by date and description.',
        'Each line requires item number, location and reason for request.',
        'Attach specifications, then request approval.',
      ]}
    />
  )
}
