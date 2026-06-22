import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { purchaseLineTypeLabel, purchaseLineTypeOptions } from '@/data/essOptions'
import { purchaseHeaderSchema, purchaseLineSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'purchaseRequisition', entity: 'selfServicePurchaseRequisitions' } as const

export function PurchaseRequisition() {
  const locations = useLookupOptions('locations')
  const items = useLookupOptions('items')
  const assets = useLookupOptions('assets')
  const services = useLookupOptions('services')

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
        { name: 'dateNeeded', label: 'Needed By Date', type: 'date', valuePaths: ['Needed_By_Date', 'OrderDate', 'Order_Date'] },
        { name: 'description', label: 'Posting Description', type: 'textarea', valuePaths: ['Posting_Description', 'PostingDescription'] },
        { name: 'requestedReceiptDate', label: 'Requested Receipt Date', type: 'date', valuePaths: ['RequestedReceiptDate', 'Requested_Receipt_Date'] },
        { name: 'responsibilityCenter', label: 'Responsibility Center', type: 'text', valuePaths: ['ResponsibilityCenter', 'Responsibility_Center'] },
        { name: 'department', label: 'Department', type: 'text', valuePaths: ['ShortcutDimension1Code', 'GlobalDimension1Code'] },
        { name: 'orderDate', label: 'Order Date', type: 'date', valuePaths: ['OrderDate', 'Order_Date'] },
        { name: 'documentDate', label: 'Document Date', type: 'date', valuePaths: ['DocumentDate', 'Document_Date'] },
      ]}
      line={{
        label: 'Purchase Lines',
        addLabel: 'New Line',
        schema: purchaseLineSchema,
        defaultValues: { itemNo: '', location: '', reasonForRequest: '', quantity: 1, type: '2' },
        buildLinePayload: (values) => ({
          ...values,
          type: values.type,
          whereNeeded: values.location,
          location: values.location,
          reason: values.reasonForRequest,
        }),
        fields: [
          {
            name: 'type',
            label: 'Type',
            type: 'select',
            options: purchaseLineTypeOptions,
            valuePaths: ['typeCode', 'Type', 'type'],
            valueMap: { service: '1', item: '2', asset: '4' },
          },
          {
            name: 'itemNo',
            label: 'Item / Service No.',
            type: 'select',
            valuePaths: ['No', 'itemNo', 'ItemNo', 'Item_No'],
            optionsByField: {
              field: 'type',
              options: { '1': services.options, '2': items.options, '4': assets.options },
            },
          },
          {
            name: 'location',
            label: 'Location',
            type: 'select',
            options: locations.options,
            valuePaths: ['Location_Code', 'LocationCode', 'location'],
          },
          { name: 'quantity', label: 'Quantity', type: 'number', valuePaths: ['Quantity', 'quantity'] },
          {
            name: 'reasonForRequest',
            label: 'Reason for Request',
            type: 'textarea',
            valuePaths: ['RequestSummary', 'Reason_for_Request', 'ReasonForRequest', 'reasonForRequest'],
          },
        ],
        columns: [
          {
            key: 'type',
            header: 'Type',
            format: (value) => purchaseLineTypeLabel(value),
          },
          { key: 'itemNo', header: 'No.' },
          { key: 'description', header: 'Description' },
          { key: 'reasonForRequest', header: 'Purpose' },
          { key: 'quantity', header: 'Quantity' },
          { key: 'unitOfMeasure', header: 'Unit' },
          { key: 'location', header: 'Location' },
        ],
        emptyText: '*** No Purchase Lines Found ***',
      }}
    />
  )
}
