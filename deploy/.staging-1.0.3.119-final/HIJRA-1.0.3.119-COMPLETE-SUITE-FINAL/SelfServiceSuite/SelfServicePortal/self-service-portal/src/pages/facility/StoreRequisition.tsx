import { formatISO } from 'date-fns'
import { useSearchParams } from 'react-router-dom'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { storeLineTypeOptions } from '@/data/essOptions'
import { storeHeaderSchema, storeLineSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { formatCurrency, formatDate } from '@/utils/formatters'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'storeRequisition', entity: 'selfServiceStoreRequisitions' } as const

function hasText(value: unknown) {
  const text = String(value ?? '').trim()
  return Boolean(text && text !== '-' && !text.startsWith('0001-01-01'))
}

function hasPositiveNumber(value: unknown) {
  return Number(value ?? 0) > 0
}

export function StoreRequisition() {
  const [searchParams] = useSearchParams()
  const locations = useLookupOptions('locations')
  const items = useLookupOptions('items')
  const assets = useLookupOptions('assets')

  return (
    <MultiStepRequestPage
      title="Store Requisition"
      headerLabel="New Store Requisition"
      description="Track the complete store flow from request creation and approval through store issue and requester receipt confirmation."
      module={module}
      queryKey={['facility', 'store-requisition']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Request"
      listValueColumn={{
        id: 'amount',
        header: 'Total Value',
        cell: (row) => row.amount > 0 ? formatCurrency(row.amount) : 'Not costed',
      }}
      initialMode={searchParams.get('new') === '1' ? 'create' : 'list'}
      headerSchema={storeHeaderSchema}
      headerDefaults={{ dateRequired: today, description: '', issuingStore: '' }}
      buildHeaderPayload={(values) => ({
        ...values,
        requestDate: values.dateRequired,
        requestDescription: values.description,
        title: String(values.description || 'Store Requisition'),
      })}
      headerFields={[
        { name: 'dateRequired', label: 'Date Required', type: 'date', valuePaths: ['RequiredDate', 'Required_Date', 'RequestDate'] },
        { name: 'issuingStore', label: 'Issuing Store', type: 'select', options: locations.options, valuePaths: ['IssuingStore', 'Issuing_Store'] },
        { name: 'description', label: 'Request Description', type: 'textarea', valuePaths: ['RequestDescription', 'Request_Description'] },
      ]}
      detailFields={[
        { label: 'Requisition No.', paths: ['request.requestNo'] },
        { label: 'Requested By', paths: ['request.makerName', 'payload.RequesterName', 'payload.RequesterID'] },
        { label: 'Employee No.', paths: ['request.makerEmployeeNo', 'payload.EmployeeNo'] },
        { label: 'Job Title', paths: ['payload.RequesterJobTitle'] },
        { label: 'Branch / Place of Duty', paths: ['payload.RequesterPlaceOfDuty', 'payload.RequesterBranch'] },
        { label: 'Request Date', paths: ['payload.Requestdate', 'payload.RequestDate', 'request.createdAt'], format: 'date' },
        { label: 'Date Required', paths: ['payload.RequiredDate', 'payload.Required_Date', 'payload.RequestDate'], format: 'date' },
        { label: 'Issuing Store', paths: ['payload.IssuingStore', 'payload.Issuing_Store'] },
        { label: 'Description', paths: ['payload.RequestDescription', 'payload.Request_Description'] },
        { label: 'Justification', paths: ['payload.Justification'] },
        { label: 'Department / Cost Centre', paths: ['request.departmentName', 'request.departmentCode', 'payload.ShortcutDimension2Code'] },
        { label: 'Division', paths: ['payload.GlobalDimension1Code', 'payload.Global_Dimension_1_Code'] },
        { label: 'Responsibility Centre', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
        { label: 'Store Receipt No.', paths: ['payload.SRNNo', 'payload.SRN_No'] },
        { label: 'Issue Date', paths: ['payload.IssueDate', 'payload.Issue_Date'], format: 'date' },
        { label: 'Total Value', paths: ['payload.TotalAmount', 'request.amount'], format: 'currency' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Requisition Lines',
        addLabel: 'New Line',
        schema: storeLineSchema,
        defaultValues: { type: '1', issuingStore: '', itemNo: '', description: '', quantity: 1 },
        buildLinePayload: (values) => ({
          ...values,
          location: values.issuingStore,
          item: values.itemNo,
          quantity: values.type === '2' ? 0 : values.quantity,
        }),
        fields: [
          { name: 'type', label: 'Type', type: 'select', options: storeLineTypeOptions },
          { name: 'issuingStore', label: 'Issuing Store', type: 'select', options: locations.options },
          {
            name: 'itemNo',
            label: 'Item / Asset No.',
            type: 'select',
            optionsByField: {
              field: 'type',
              options: { '1': items.options, '2': assets.options },
            },
          },
          { name: 'description', label: 'Description', type: 'text' },
          {
            name: 'quantity',
            label: 'Quantity Requested',
            type: 'number',
            visibleWhen: (values) => String(values.type ?? '1') === '1',
          },
        ],
        columns: [
          {
            key: 'itemNo',
            header: 'Item / Asset',
            format: (value, row) =>
              `${String(row.type) === '2' ? 'Asset' : 'Item'} ${String(value ?? '').trim()}`.trim(),
          },
          { key: 'description', header: 'Description' },
          {
            key: 'unitOfMeasure',
            header: 'Unit',
            visibleWhen: (lines) => lines.some((line) => hasText(line.unitOfMeasure)),
          },
          { key: 'quantity', header: 'Requested' },
          {
            key: 'quantityIssued',
            header: 'Issued',
            visibleWhen: (lines) => lines.some((line) => hasPositiveNumber(line.quantityIssued)),
          },
          {
            key: 'quantityReceived',
            header: 'Received',
            visibleWhen: (lines) => lines.some((line) => hasPositiveNumber(line.quantityReceived)),
          },
          {
            key: 'lastIssueDate',
            header: 'Issued On',
            format: (value) => formatDate(String(value ?? '')),
            visibleWhen: (lines) => lines.some((line) => hasText(line.lastIssueDate)),
          },
          { key: 'fulfillmentStatus', header: 'Status' },
          {
            key: 'lineAmount',
            header: 'Line Value',
            format: (value) => formatCurrency(Number(value ?? 0)),
            visibleWhen: (lines) => lines.some((line) => hasPositiveNumber(line.lineAmount)),
          },
          {
            key: 'reasonForLessIssued',
            header: 'Issue Variance',
            visibleWhen: (lines) => lines.some((line) => hasText(line.reasonForLessIssued)),
          },
          {
            key: 'reason',
            header: 'Receipt Variance',
            visibleWhen: (lines) => lines.some((line) => hasText(line.reason)),
          },
          {
            key: 'remarks',
            header: 'Remarks',
            visibleWhen: (lines) => lines.some((line) => hasText(line.remarks)),
          },
        ],
        emptyText: '*** No Store Lines Found ***',
        canEdit: false,
      }}
    />
  )
}
