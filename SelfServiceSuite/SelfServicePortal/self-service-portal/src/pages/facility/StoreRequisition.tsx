import { useSearchParams } from 'react-router-dom'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { StoreOperationsPanel } from '@/components/facility/StoreOperationsPanel'
import { ProcurementProcessBanner } from '@/components/facility/ProcurementProcessBanner'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { useAuth } from '@/hooks/useAuth'
import { useQuery } from '@tanstack/react-query'
import { getEmployeeProfileDetails } from '@/api/endpoints/profile'
import {
  storeAttachmentCategories,
  storeLineTypeOptions,
  storePriorityOptions,
  storeRequestTypeOptions,
  storeUomOptions,
} from '@/data/essOptions'
import { storeHeaderSchema, storeLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { todayIsoDate } from '@/utils/validators'
import { isEmployeeIdentifier, requesterDisplayName } from '@/utils/requesterDisplayName'
import {
  ABH_STORE_REQUISITION_PROCESS_FLOWS,
  ABH_STORE_REQUISITION_PROCESS_TITLE,
  storeRequisitionProcess,
} from '@/data/procurementProcessFlows'

const today = todayIsoDate()
const module = { module: 'storeRequisition', entity: 'selfServiceStoreRequisitions' } as const

function hasText(value: unknown) {
  const text = String(value ?? '').trim()
  return Boolean(text && text !== '-' && !text.startsWith('0001-01-01'))
}

function hasPositiveNumber(value: unknown) {
  return Number(value ?? 0) > 0
}

function isAssetRequestPayload(payload: Record<string, unknown> | undefined) {
  const value = String(
    payload?.StoreRequisitionType ??
      payload?.Store_Requisition_Type ??
      payload?.requestType ??
      '',
  )
    .trim()
    .toLowerCase()
  return value === '1' || value === 'asset' || value === 'minor asset'
}

const storeProcessBanner = (
  <ProcurementProcessBanner
    title={ABH_STORE_REQUISITION_PROCESS_TITLE}
    steps={storeRequisitionProcess}
    flows={[...ABH_STORE_REQUISITION_PROCESS_FLOWS]}
  />
)

export function StoreRequisition() {
  const [searchParams] = useSearchParams()
  const { employee } = useAuth()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const employeeNo = String(employee?.employeeNo ?? '').trim()
  const rawDisplayName = String(employee?.displayName ?? '').trim()
  const requestedBy = isEmployeeIdentifier(rawDisplayName, employeeNo) ? '' : rawDisplayName
  const division = String(profileQuery.data?.division ?? '').trim()
  const department = String(
    profileQuery.data?.department || employee?.departmentName || employee?.departmentCode || '',
  ).trim()

  return (
    <MultiStepRequestPage
      title="Store Requisition"
      headerLabel="New Store Requisition"
      processBanner={storeProcessBanner}
      showProcessBannerOnList={false}
      detailActionsPlacement="bottom"
      module={module}
      queryKey={['facility', 'store-requisition']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Store Requisition"
      listValueColumn={{
        id: 'amount',
        header: 'Total Value',
        cell: (row) => row.amount > 0 ? formatCurrency(row.amount) : 'Not costed',
      }}
      attachmentCategoryOptions={storeAttachmentCategories}
      attachmentCategoryHint="Supporting documents are optional. Add a specification, drawing, or reference when useful, and describe each uploaded file."
      detailSupplement={({ request }) => <StoreOperationsPanel request={request} />}
      initialMode={searchParams.get('new') === '1' ? 'create' : 'list'}
      headerSchema={storeHeaderSchema}
      headerDefaults={{
        requestDate: today,
        dateRequired: today,
        requestedBy,
        division,
        department,
        requestType: 'item',
        priority: 'normal',
        justification: '',
      }}
      headerSupplement={() => <FinanceEmployeeOrgBanner showJobGradeAndDistrict={false} />}
      buildHeaderPayload={(values) => {
        const justification = String(values.justification ?? '').trim()
        return {
          ...values,
          requestDate: values.dateRequired,
          requestDescription: justification.slice(0, 150),
          justification,
          title: justification.slice(0, 80) || 'Store Requisition',
        }
      }}
      headerFields={[
        {
          name: 'requestDate',
          label: 'Request Date',
          type: 'date',
          readOnly: true,
          valuePaths: ['Requestdate', 'RequestDate', 'Request_date'],
        },
        {
          name: 'requestedBy',
          label: 'Requested By',
          type: 'text',
          readOnly: true,
          valuePaths: ['RequesterName', 'RequestedByName', 'RequestorName'],
        },
        {
          name: 'division',
          label: 'Division',
          type: 'text',
          readOnly: true,
          valuePaths: ['FunctionName', 'GlobalDimension1Code', 'Global_Dimension_1_Code'],
        },
        {
          name: 'department',
          label: 'Department',
          type: 'text',
          readOnly: true,
          valuePaths: ['BudgetCenterName', 'DepartmentName', 'ShortcutDimension2Code', 'Shortcut_Dimension_2_Code'],
        },
        {
          name: 'requestType',
          label: 'Request Type',
          type: 'select',
          options: storeRequestTypeOptions,
          valuePaths: ['StoreRequisitionType', 'Store_Requisition_Type', 'requestType'],
          valueMap: { item: 'item', asset: 'asset', 'minor asset': 'asset' },
        },
        {
          name: 'dateRequired',
          label: 'Required Date',
          type: 'date',
          valuePaths: ['RequiredDate', 'Required_Date', 'RequestDate'],
        },
        {
          name: 'priority',
          label: 'Priority',
          type: 'select',
          options: storePriorityOptions,
          valuePaths: ['Priority', 'priority'],
          valueMap: {
            '0': 'low',
            '1': 'normal',
            '2': 'high',
            '3': 'urgent',
            low: 'low',
            normal: 'normal',
            high: 'high',
            urgent: 'urgent',
          },
        },
        {
          name: 'justification',
          label: 'Purpose / Justification',
          type: 'textarea',
          valuePaths: ['Justification', 'justification'],
        },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        {
          label: 'Requested By',
          paths: ['payload.RequesterName', 'payload.RequestedByName', 'payload.RequestorName'],
          resolve: (request) =>
            requesterDisplayName(
              request,
              employeeNo,
              rawDisplayName,
            ),
        },
        { label: 'Employee No.', paths: ['request.makerEmployeeNo', 'payload.EmployeeNo'] },
        { label: 'Request Date', paths: ['payload.Requestdate', 'payload.RequestDate', 'request.createdAt'], format: 'date' },
        { label: 'Required Date', paths: ['payload.RequiredDate', 'payload.Required_Date', 'payload.RequestDate'], format: 'date' },
        { label: 'Division', paths: ['payload.FunctionName', 'payload.GlobalDimension1Code', 'payload.Global_Dimension_1_Code'] },
        { label: 'Department', paths: ['payload.BudgetCenterName', 'payload.DepartmentName', 'payload.ShortcutDimension2Code', 'payload.Shortcut_Dimension_2_Code'] },
        { label: 'Assigned Store', paths: ['payload.IssuingStore', 'payload.Issuing_Store', 'payload.issuingStore'] },
        { label: 'Request Type', paths: ['payload.StoreRequisitionType', 'payload.Store_Requisition_Type'] },
        { label: 'Priority', paths: ['payload.Priority', 'payload.priority'], format: 'storePriority' },
        { label: 'Purpose / Justification', paths: ['payload.Justification', 'payload.justification'] },
        { label: 'Store Receipt No.', paths: ['payload.SRNNo', 'payload.SRN_No'] },
        { label: 'Issue Date', paths: ['payload.IssueDate', 'payload.Issue_Date'], format: 'date' },
        { label: 'Total Value', paths: ['payload.TotalAmount', 'request.amount'], format: 'currency' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Request Details',
        addLabel: 'Add Item / Asset Line',
        schema: storeLineSchema,
        defaultValues: {
          type: '1',
          itemNo: '',
          itemName: '',
          description: '',
          uom: 'PCS',
          quantity: 1,
          preferredBrandModel: '',
        },
        defaultValuesFromRequest: (request) => ({
          type: isAssetRequestPayload(request.payload) ? '2' : '1',
        }),
        buildLinePayload: (values) => ({
          ...values,
          item: values.itemNo,
          itemName: values.itemName,
          lineDescription: values.description,
          uom: values.uom,
          preferredBrandModel: values.preferredBrandModel,
          quantity: values.type === '2' ? Number(values.quantity ?? 1) : values.quantity,
        }),
        fields: [
          {
            name: 'type',
            label: 'Line Type',
            type: 'select',
            options: storeLineTypeOptions,
            visibleWhen: () => false,
          },
          {
            name: 'itemName',
            label: 'Requested Item / Asset',
            type: 'text',
            placeholder: 'Enter what is required (stock availability is checked internally)',
            valuePaths: ['itemName', 'ItemName', 'Description'],
          },
          {
            name: 'description',
            label: 'Specification / Description',
            type: 'textarea',
            valuePaths: ['description', 'Remarks', 'remarks'],
          },
          {
            name: 'uom',
            label: 'UOM',
            type: 'select',
            options: storeUomOptions,
            valuePaths: ['uom', 'unitOfMeasure', 'UnitofMeasure'],
          },
          { name: 'quantity', label: 'Quantity', type: 'number' },
          {
            name: 'preferredBrandModel',
            label: 'Preferred Brand / Model (optional)',
            type: 'text',
            valuePaths: ['preferredBrandModel', 'Description2', 'Description_2'],
          },
        ],
        columns: [
          {
            key: 'type',
            header: 'Type',
            format: (value) => (String(value) === '2' || String(value).toLowerCase() === 'asset' ? 'Asset' : 'Item'),
          },
          { key: 'itemName', header: 'Item / Asset' },
          {
            key: 'description',
            header: 'Description',
            visibleWhen: (lines) => lines.some((line) => hasText(line.description) && String(line.description) !== String(line.itemName ?? '')),
          },
          {
            key: 'preferredBrandModel',
            header: 'Preferred Brand / Model',
            visibleWhen: (lines) => lines.some((line) => hasText(line.preferredBrandModel)),
          },
          {
            key: 'unitOfMeasure',
            header: 'UOM',
            format: (value) => {
              const text = String(value ?? '').trim()
              return text || '—'
            },
          },
          { key: 'quantity', header: 'Qty' },
          {
            key: 'lineAmount',
            header: 'Line Amount',
            format: (value) => (Number(value ?? 0) > 0 ? formatCurrency(Number(value)) : '—'),
            visibleWhen: (lines) => lines.some((line) => hasPositiveNumber(line.lineAmount)),
          },
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
        ],
        emptyText: '*** No request lines yet ***',
        canEdit: true,
      }}
    />
  )
}
