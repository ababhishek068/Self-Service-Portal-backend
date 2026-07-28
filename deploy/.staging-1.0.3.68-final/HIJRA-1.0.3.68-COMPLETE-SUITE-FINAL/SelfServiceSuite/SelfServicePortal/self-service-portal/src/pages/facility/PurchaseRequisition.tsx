import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { purchaseLineTypeOptions } from '@/data/essOptions'
import { purchaseHeaderSchema, purchaseLineSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'purchaseRequisition', entity: 'selfServicePurchaseRequisitions' } as const

export function PurchaseRequisition() {
  const locations = useLookupOptions('locations')
  const items = useLookupOptions('items')
  const assets = useLookupOptions('assets')
  const services = useLookupOptions('services')
  const departments = useLookupOptions('departments')
  // Mirror the BC lookup which lists department CODES (FACILTY, HC, OUT, ...).
  const departmentOptions = departments.options.map((option) => ({
    value: option.value,
    label: option.label && option.label !== option.value ? `${option.value} — ${option.label}` : option.value,
  }))

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
      headerDefaults={{ dateNeeded: today, description: '', requestingDepartment: '' }}
      buildHeaderPayload={(values) => ({
        ...values,
        orderDate: values.dateNeeded,
        postingDescription: values.description,
        reason: values.description,
        title: String(values.description || 'Purchase Requisition'),
      })}
      headerFields={[
        { name: 'dateNeeded', label: 'Needed By Date', type: 'date', valuePaths: ['Needed_By_Date', 'OrderDate', 'Order_Date'] },
        {
          name: 'requestingDepartment',
          label: 'Requesting Department',
          type: 'select',
          options: departmentOptions,
          valuePaths: ['RequestingDepartment', 'Requesting_Department', 'ShortcutDimension1Code'],
        },
        { name: 'description', label: 'Description', type: 'textarea', valuePaths: ['Posting_Description', 'PostingDescription'] },
      ]}
      detailFields={[
        { label: 'Requisition No.', paths: ['request.requestNo'] },
        { label: 'Needed By Date', paths: ['payload.Needed_By_Date', 'payload.OrderDate', 'payload.Order_Date'], format: 'date' },
        { label: 'Description', paths: ['payload.Posting_Description', 'payload.PostingDescription'] },
        { label: 'Department', paths: ['payload.RequestingDepartment', 'payload.Requesting_Department', 'request.departmentName', 'request.departmentCode', 'payload.ShortcutDimension2Code'] },
        { label: 'Responsibility Center', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Purchase Lines',
        addLabel: 'New Line',
        schema: purchaseLineSchema,
        defaultValues: { itemNo: '', location: '', reasonForRequest: '', specification: '', quantity: 1, type: '2' },
        buildLinePayload: (values) => ({
          ...values,
          whereNeeded: values.location,
          reason: values.reasonForRequest,
        }),
        fields: [
          { name: 'type', label: 'Type', type: 'select', options: purchaseLineTypeOptions },
          {
            name: 'itemNo',
            label: 'Item / Service No.',
            type: 'select',
            optionsByField: {
              field: 'type',
              options: { '1': services.options, '2': items.options, '4': assets.options },
            },
          },
          { name: 'location', label: 'Location (optional)', type: 'select', options: locations.options },
          { name: 'quantity', label: 'Quantity', type: 'number' },
          { name: 'specification', label: 'Specification', type: 'textarea' },
          { name: 'reasonForRequest', label: 'Reason for Request', type: 'textarea' },
        ],
        columns: [
          { key: 'type', header: 'Type' },
          { key: 'itemNo', header: 'No.' },
          { key: 'description', header: 'Description' },
          { key: 'specification', header: 'Specification' },
          { key: 'reasonForRequest', header: 'Purpose' },
          { key: 'quantity', header: 'Quantity' },
          { key: 'unitOfMeasure', header: 'Unit' },
          { key: 'location', header: 'Location' },
        ],
        emptyText: '*** No Purchase Lines Found ***',
        canEdit: false,
      }}
    />
  )
}
