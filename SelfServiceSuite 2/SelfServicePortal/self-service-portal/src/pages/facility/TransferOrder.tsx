import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { transferOrderHeaderSchema, transferOrderLineSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'transferOrder', entity: 'selfServiceTransferOrders' } as const

export function TransferOrder() {
  const locations = useLookupOptions('regular-locations')
  const inTransitLocations = useLookupOptions('in-transit-locations')
  const shippingAgents = useLookupOptions('shipping-agents')
  const items = useLookupOptions('items')

  return (
    <MultiStepRequestPage
      title="Transfer Order"
      headerLabel="New Transfer Order (Header)"
      description="Create the transfer order header, then add item lines before requesting approval."
      module={module}
      queryKey={['facility', 'transfer-order']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Request"
      headerSchema={transferOrderHeaderSchema}
      headerDefaults={{
        from: '',
        to: '',
        inTransit: '',
        truckNo: '',
        postingDate: today,
        driverName: '',
      }}
      buildHeaderPayload={(values) => ({
        ...values,
        fromCode: values.from,
        toCode: values.to,
        title: `Transfer ${values.from || ''} → ${values.to || ''}`,
      })}
      headerFields={[
        { name: 'from', label: 'From', type: 'select', options: locations.options },
        { name: 'to', label: 'To', type: 'select', options: locations.options },
        { name: 'inTransit', label: 'In Transit Code', type: 'select', options: inTransitLocations.options },
        { name: 'truckNo', label: 'Truck No.', type: 'select', options: shippingAgents.options },
        { name: 'postingDate', label: 'Posting Date', type: 'date' },
        { name: 'driverName', label: 'Driver Name', type: 'text' },
      ]}
      line={{
        label: 'Requisition Lines',
        addLabel: 'New Line',
        schema: transferOrderLineSchema,
        defaultValues: { itemNo: '', quantity: 1 },
        buildLinePayload: (values) => ({ ...values, item: values.itemNo }),
        fields: [
          { name: 'itemNo', label: 'Item No.', type: 'select', options: items.options },
          { name: 'quantity', label: 'Quantity', type: 'number' },
        ],
        columns: [
          { key: 'itemNo', header: 'Item No' },
          { key: 'description', header: 'Description' },
          { key: 'quantity', header: 'Quantity' },
          { key: 'unitOfMeasure', header: 'Unit of Measure' },
          { key: 'quantityShipped', header: 'Quantity Shipped' },
          { key: 'quantityReceived', header: 'Quantity Received' },
          { key: 'shipmentDate', header: 'Shipment Date' },
          { key: 'receiptDate', header: 'Receipt Date' },
        ],
        emptyText: '*** No Transfer Lines Found ***',
      }}
      businessRules={[
        'Locations and items must exist in Business Central.',
        'Create the header first, then add transfer lines.',
        'Request approval once all lines are captured.',
      ]}
    />
  )
}
