import { useSearchParams } from 'react-router-dom'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { StoreOperationsPanel } from '@/components/facility/StoreOperationsPanel'
import { ProcurementProcessBanner } from '@/components/facility/ProcurementProcessBanner'
import {
  getStoreRequisitionOptions,
  listModuleRequests,
  type StoreRequisitionStore,
} from '@/api/endpoints/requestEndpoint'
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

function storeLabel(store: StoreRequisitionStore) {
  const name = store.name && store.name !== store.code ? `${store.code} — ${store.name}` : store.code
  return store.locationCode && store.locationCode !== store.code ? `${name} (location ${store.locationCode})` : name
}

function lineRoleLabel(value: unknown) {
  const text = String(value ?? '').trim().toLowerCase()
  if (text.includes('offer')) return 'Store offer'
  if (text.includes('request')) return 'Your request'
  return '—'
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
  return ['1', 'asset', 'minor asset', 'minor_asset', 'fixed asset', 'fixed_asset'].includes(value)
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
  // Store, project and unit-of-measure lists from Business Central (same lookups as the BC card).
  const optionsQuery = useQuery({
    queryKey: ['store-requisition', 'options'],
    queryFn: getStoreRequisitionOptions,
    staleTime: 5 * 60 * 1000,
    retry: false,
  })
  const bcStores = optionsQuery.data?.stores
  const bcProjects = optionsQuery.data?.projects
  const bcUnits = optionsQuery.data?.unitsOfMeasure
  // Is Project is saved by BC 1.0.3.544 (SetPortalStoreRequisitionDetails); hidden on older BC apps.
  const showProject = optionsQuery.data?.storesFromBc === true && Boolean(bcProjects)
  const storeOptions = (bcStores ?? []).map((store) => ({ value: store.code, label: storeLabel(store) }))
  const projectOptions = (bcProjects ?? []).map((project) => ({
    value: project.no,
    label: project.description ? `${project.no} — ${project.description}` : project.no,
  }))
  const uomOptions = bcUnits?.length
    ? bcUnits.map((unit) => ({
        value: unit.code,
        label: unit.description && unit.description.toUpperCase() !== unit.code ? `${unit.code} — ${unit.description}` : unit.code,
      }))
    : storeUomOptions
  const defaultUom = bcUnits?.length
    ? (bcUnits.find((unit) => unit.code === 'EACH') ?? bcUnits.find((unit) => unit.code === 'PCS') ?? bcUnits[0]).code
    : optionsQuery.isLoading
      ? ''
      : 'PCS'

  return (
    <MultiStepRequestPage
      title="Store Requisition"
      description="Choose the issuing store, describe what you need with the unit of measure and quantity, then send it for approval. The store offers the real item; you check the Item Borrowing Form and accept it, then confirm receipt."
      headerLabel="New Store Requisition"
      processBanner={storeProcessBanner}
      showProcessBannerOnList={false}
      detailActionsPlacement="bottom"
      cancelStatuses={['Pending Approval']}
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
      requiresAttachmentBeforeSubmit={false}
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
        storeCode: '',
        isProject: false,
        projectCode: '',
      }}
      headerOnValuesChange={(values, form) => {
        // A saved draft may carry only the issuing location (e.g. SU): show its store (SUP).
        const storeCode = String(values.storeCode ?? '').trim()
        if (storeCode && bcStores?.length && !bcStores.some((store) => store.code === storeCode)) {
          const byLocation = bcStores.find((store) => store.locationCode === storeCode)
          if (byLocation) form.setValue('storeCode', byLocation.code)
        }
        // BC fills Project Name from the project (Job) chosen here.
        if (values.isProject !== true && String(values.projectCode ?? '')) form.setValue('projectCode', '')
      }}
      headerSupplement={() => <FinanceEmployeeOrgBanner showJobGradeAndDistrict={false} />}
      buildHeaderPayload={(values) => {
        const justification = String(values.justification ?? '').trim()
        const isProject = values.isProject === true
        return {
          ...values,
          requestDate: values.dateRequired,
          requestDescription: justification.slice(0, 150),
          justification,
          title: justification.slice(0, 80) || 'Store Requisition',
          storeCode: String(values.storeCode ?? '').trim(),
          isProject,
          projectCode: isProject ? String(values.projectCode ?? '').trim() : '',
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
          // Consumable / Fixed Asset is chosen per line (Type), as on the BC lines; the header
          // keeps its saved value so older Fixed Asset drafts are not changed.
          visibleWhen: () => false,
          // BC Request Type: Consumable (Item) or Fixed Asset (Minor Asset).
          valueMap: {
            item: 'item',
            consumable: 'item',
            asset: 'asset',
            'minor asset': 'asset',
            minor_asset: 'asset',
            'fixed asset': 'asset',
            fixed_asset: 'asset',
          },
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
          name: 'storeCode',
          label: 'Issuing Store',
          type: 'select',
          options: storeOptions,
          placeholder: optionsQuery.isLoading ? 'Loading stores…' : 'Select the issuing store',
          valuePaths: ['StoreCode', 'Store_Code', 'IssuingStore', 'Issuing_Store'],
        },
        ...(showProject
          ? [
              {
                name: 'isProject',
                label: 'Is Project',
                type: 'checkbox' as const,
                valuePaths: ['IsProject', 'Is_Project'],
              },
              {
                name: 'projectCode',
                label: 'Project',
                type: 'select' as const,
                options: projectOptions,
                placeholder: optionsQuery.isLoading ? 'Loading projects…' : 'Select the project',
                visibleWhen: (values: Record<string, unknown>) => values.isProject === true,
                valuePaths: ['ProjectCode', 'Project_Code'],
              },
            ]
          : []),
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
        { label: 'Issuing Store', paths: ['payload.StoreName', 'payload.StoreCode', 'payload.IssuingStore', 'payload.Issuing_Store'] },
        {
          label: 'Is Project',
          paths: [],
          resolve: (request) => (request.payload?.IsProject === true ? 'Yes' : undefined),
        },
        {
          label: 'Project',
          paths: [],
          resolve: (request) => {
            const code = String(request.payload?.ProjectCode ?? request.payload?.Project_Code ?? '').trim()
            const name = String(request.payload?.ProjectName ?? request.payload?.Project_Name ?? '').trim()
            if (!code) return undefined
            return name && name !== code ? `${code} — ${name}` : code
          },
        },
        { label: 'Issue Stage', paths: ['payload.IssueStage', 'payload.Issue_Stage'] },
        {
          label: 'Requester Decision',
          paths: [],
          resolve: (request) => {
            const decision = String(request.payload?.RequesterDecision ?? '').trim()
            return /accept|declin/i.test(decision) ? decision : undefined
          },
        },
        { label: 'GIV / Store Issue No.', paths: ['payload.StoreIssueNo', 'payload.Store_Issue_No'] },
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
          uom: defaultUom,
          quantity: 1,
          preferredBrandModel: '',
        },
        defaultValuesFromRequest: (request) => ({
          type: isAssetRequestPayload(request.payload) ? '2' : '1',
        }),
        buildLinePayload: (values) => {
          const itemName = String(values.itemName ?? '').trim()
          return {
            ...values,
            item: '',
            itemNo: '',
            itemName,
            lineDescription: values.description,
            uom: values.uom || 'PCS',
            preferredBrandModel: values.preferredBrandModel,
            quantity: Number(values.quantity ?? 0),
          }
        },
        fields: [
          {
            // BC Store Requisition Line Type: Consumable or Fixed Asset, per line.
            name: 'type',
            label: 'Type',
            type: 'select',
            options: storeLineTypeOptions,
            hint: 'Consumable: used up, e.g. toner, paper. Fixed Asset: kept and tagged, e.g. laptop, chair.',
            valuePaths: ['type', 'Type'],
            valueMap: {
              item: '1',
              consumable: '1',
              asset: '2',
              'minor asset': '2',
              minor_asset: '2',
              'fixed asset': '2',
              fixed_asset: '2',
            },
          },
          {
            name: 'itemName',
            label: 'What do you need?',
            type: 'text',
            placeholder: 'Type the item or asset, for example All in one Desktop',
            valuePaths: ['itemName', 'ItemName', 'Description'],
          },
          {
            name: 'description',
            label: 'Additional specification (optional)',
            type: 'textarea',
            placeholder: 'Add extra detail if needed. Attach a file only when a spec document is required.',
            valuePaths: ['remarks', 'Remarks', 'lineDescription'],
          },
          {
            name: 'uom',
            label: 'UOM',
            type: 'select',
            options: uomOptions,
            placeholder: optionsQuery.isLoading ? 'Loading units…' : 'Select the unit of measure',
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
            format: (value) =>
              String(value) === '2' || /asset/i.test(String(value)) ? 'Fixed Asset' : 'Consumable',
          },
          {
            key: 'lineRole',
            header: 'Line Role',
            format: (value) => lineRoleLabel(value),
            visibleWhen: (lines) => lines.some((line) => /offer/i.test(String(line.lineRole ?? ''))),
          },
          {
            key: 'itemNo',
            header: 'Item / Asset No.',
            visibleWhen: (lines) => lines.some((line) => hasText(line.itemNo)),
          },
          { key: 'itemName', header: 'Requested item' },
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
