import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { purchaseLineTypeOptions } from '@/data/essOptions'
import { purchaseHeaderSchema, purchaseLineSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { formatCurrency } from '@/utils/formatters'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'purchaseRequisition', entity: 'selfServicePurchaseRequisitions' } as const

export function PurchaseRequisition() {
  const locations = useLookupOptions('locations')
  const items = useLookupOptions('items')
  // A purchase Fixed Asset line must submit the BC Fixed Asset "No.". The
  // maintenance form uses the physical Asset Tag, so it has a separate lookup.
  const purchaseAssets = useLookupOptions('purchase-assets')
  const services = useLookupOptions('services')
  const departments = useLookupOptions('departments')
  // Backend already returns CODE — Name for departments; do not re-wrap labels.
  const departmentOptions = departments.options

  return (
    <MultiStepRequestPage
      title="Purchase Requisition"
      headerLabel="New Purchase Requisition"
      description="Create the purchase header, then add item lines with location and reason. Duplicate lines for the same item, quantity, and requester within 24 hours are blocked while another request is Open, Pending Approval, or Approved (Excel PR_07)."
      module={module}
      queryKey={['facility', 'purchase-requisition']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Request"
      listValueColumn={{
        id: 'amount',
        header: 'Total Value',
        cell: (row) => row.amount > 0 ? formatCurrency(row.amount) : 'Not costed',
      }}
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
          label: 'Requesting Department / District',
          type: 'select',
          options: departmentOptions,
          placeholder: departments.isLoading
            ? 'Loading department and district codes…'
            : departments.isError
              ? 'Could not load departments / districts from BC'
              : 'Select department or district code',
          valuePaths: [
            'RequestingDepartment',
            'Requesting_Department',
            'Department',
            'ShortcutDimension1Code',
          ],
        },
        { name: 'description', label: 'Description', type: 'textarea', valuePaths: ['Posting_Description', 'PostingDescription'] },
      ]}
      detailFields={[
        { label: 'Requisition No.', paths: ['request.requestNo'] },
        { label: 'Needed By Date', paths: ['payload.Needed_By_Date', 'payload.OrderDate', 'payload.Order_Date'], format: 'date' },
        { label: 'Description', paths: ['payload.Posting_Description', 'payload.PostingDescription'] },
        { label: 'Department / District', paths: ['payload.RequestingDepartment', 'payload.Requesting_Department', 'request.departmentName', 'request.departmentCode', 'payload.District', 'payload.DistrictName', 'payload.ShortcutDimension2Code'] },
        { label: 'Responsibility Center', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
        { label: 'Total Value', paths: ['request.amount', 'payload.TotalAmount', 'payload.AmountIncludingVAT'], format: 'currency' },
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
          {
            name: 'type',
            label: 'Type',
            type: 'select',
            options: purchaseLineTypeOptions,
            valuePaths: ['typeCode', 'type'],
            valueMap: { service: '1', item: '2', asset: '4' },
          },
          {
            name: 'itemNo',
            label: 'BC Item / Service / Fixed Asset No.',
            type: 'select',
            placeholder: 'Select the exact requested BC record',
            optionsByField: {
              field: 'type',
              options: { '1': services.options, '2': items.options, '4': purchaseAssets.options },
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
          { key: 'description', header: 'Specification / Description' },
          { key: 'reasonForRequest', header: 'Purpose' },
          { key: 'quantity', header: 'Quantity' },
          { key: 'unitOfMeasure', header: 'Unit' },
          { key: 'location', header: 'Location' },
          {
            key: 'directUnitCost',
            header: 'Unit Cost',
            format: (value) => Number(value ?? 0) > 0 ? formatCurrency(Number(value)) : 'Not costed',
          },
          {
            key: 'amount',
            header: 'Line Value',
            format: (value) => Number(value ?? 0) > 0 ? formatCurrency(Number(value)) : 'Not costed',
          },
        ],
        emptyText: '*** No Purchase Lines Found ***',
        canEdit: true,
      }}
    />
  )
}
