import { useSearchParams } from 'react-router-dom'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { PurchaseOperationsPanel } from '@/components/facility/PurchaseOperationsPanel'
import { ProcurementProcessBanner } from '@/components/facility/ProcurementProcessBanner'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { useAuth } from '@/hooks/useAuth'
import { useQuery } from '@tanstack/react-query'
import { getEmployeeProfileDetails } from '@/api/endpoints/profile'
import {
  purchaseAttachmentCategories,
  purchaseBudgetTypeOptions,
  purchaseCategoryOptions,
  purchaseLineTypeOptions,
  purchasePriorityOptions,
  purchaseRequestTypeOptions,
  storeUomOptions,
} from '@/data/essOptions'
import { purchaseHeaderSchema, purchaseLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { todayIsoDate } from '@/utils/validators'
import { isEmployeeIdentifier, requesterDisplayName } from '@/utils/requesterDisplayName'
import {
  ABH_PURCHASE_REQUEST_PROCESS_TITLE,
  purchaseRequisitionProcess,
} from '@/data/procurementProcessFlows'

const today = todayIsoDate()
const module = { module: 'purchaseRequisition', entity: 'selfServicePurchaseRequisitions' } as const

function hasText(value: unknown) {
  const text = String(value ?? '').trim()
  return Boolean(text && text !== '-' && !text.startsWith('0001-01-01'))
}

function hasPositiveNumber(value: unknown) {
  return Number(value ?? 0) > 0
}

function defaultLineTypeForPurchaseType(purchaseRequestType: unknown) {
  const value = String(purchaseRequestType ?? 'goods').toLowerCase()
  if (value === 'service' || value === 'services' || value === 'consultancy' || value === '1' || value === '3') return '1'
  if (value === 'asset' || value === '2' || value === '4') return '4'
  return '2'
}

function syncLinePricing(
  values: FieldValues,
  form: UseFormReturn<FieldValues>,
) {
  const qty = Number(values.quantity ?? 0)
  const unit = Number(values.estimatedUnitPrice ?? 0)
  const total = Number.isFinite(qty * unit) ? qty * unit : 0
  if (Number(values.estimatedTotalPrice ?? 0) !== total) {
    form.setValue('estimatedTotalPrice', total, { shouldValidate: false })
  }
}

const purchaseProcessBanner = (
  <ProcurementProcessBanner
    title={ABH_PURCHASE_REQUEST_PROCESS_TITLE}
    steps={purchaseRequisitionProcess}
  />
)

export function PurchaseRequisition() {
  const [searchParams] = useSearchParams()
  const { employee } = useAuth()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const employeeNo = employee?.employeeNo || ''
  const rawDisplayName = String(employee?.displayName ?? '').trim()
  const requestedBy = isEmployeeIdentifier(rawDisplayName, employeeNo) ? '' : rawDisplayName
  const division = String(profileQuery.data?.division ?? '').trim()
  const defaultDepartment = String(
    profileQuery.data?.department || employee?.departmentCode || employee?.departmentName || '',
  ).trim()
  const title = 'Local Purchase'

  return (
    <MultiStepRequestPage
      title={title}
      headerLabel={`New ${title}`}
      processBanner={purchaseProcessBanner}
      showProcessBannerOnList={false}
      module={module}
      queryKey={['facility', 'purchase-requisition']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Local Purchase"
      listValueColumn={{
        id: 'amount',
        header: 'Total Value',
        cell: (row) => (row.amount > 0 ? formatCurrency(row.amount) : 'Not costed'),
      }}
      attachmentCategoryOptions={purchaseAttachmentCategories}
      attachmentCategoryHint="Supporting documents are optional. Add a Technical Specification, TOR / Scope of Work, BOQ, drawing, photo, or quotation when it helps Procurement. Enter a description for every uploaded file."
      detailSupplement={({ request }) => <PurchaseOperationsPanel request={request} />}
      initialMode={searchParams.get('new') === '1' ? 'create' : 'list'}
      headerSchema={purchaseHeaderSchema}
      headerDefaults={{
        requestDate: today,
        requestedBy,
        employeeNo,
        division,
        dateNeeded: today,
        purchaseMode: 'local',
        budgetType: 'nonProject',
        purchaseRequestType: 'goods',
        otherPurchaseType: '',
        priority: 'normal',
        requestingDepartment: defaultDepartment,
        projectCode: '',
        justification: '',
        technicalRequirement: '',
        scopeOfWork: '',
        otherRequirements: '',
      }}
      headerOnValuesChange={(values, form) => {
        const currentRequestedBy = String(values.requestedBy ?? '').trim()
        if (isEmployeeIdentifier(currentRequestedBy, employeeNo) && requestedBy) {
          form.setValue('requestedBy', requestedBy, { shouldValidate: false })
        }
      }}
      buildHeaderPayload={(values) => {
        const justification = String(values.justification ?? '').trim()
        const projectCode = values.budgetType === 'project' ? String(values.projectCode ?? '').trim() : ''
        const purchaseRequestType = String(values.purchaseRequestType ?? '').trim()
        return {
          ...values,
          projectCode,
          otherPurchaseType:
            purchaseRequestType === 'other' ? String(values.otherPurchaseType ?? '').trim() : '',
          purchaseMode: 'local',
          orderDate: values.dateNeeded,
          postingDescription: justification.slice(0, 100),
          reason: justification,
          justification,
          technicalRequirement:
            purchaseRequestType === 'goods' ? String(values.technicalRequirement ?? '').trim() : '',
          scopeOfWork: ['service', 'consultancy'].includes(purchaseRequestType)
            ? String(values.scopeOfWork ?? '').trim()
            : '',
          otherRequirements: String(values.otherRequirements ?? '').trim(),
          title: justification.slice(0, 80) || 'Purchase Request',
        }
      }}
      headerFields={[
        {
          name: 'requestDate',
          label: 'Request Date',
          type: 'date',
          readOnly: true,
          valuePaths: ['DocumentDate', 'Document_Date'],
        },
        {
          name: 'requestedBy',
          label: 'Requested By',
          type: 'text',
          readOnly: true,
          valuePaths: [
            'RequestorName',
            'Requestor_Name',
            'RequestedByName',
            'Requested_By_Name',
            'RequesterName',
            'EmployeeName',
          ],
        },
        {
          name: 'employeeNo',
          label: 'Employee No.',
          type: 'text',
          readOnly: true,
          valuePaths: ['EmployeeNo', 'Employee_No', 'RequestorEmployeeNo'],
        },
        {
          name: 'division',
          label: 'Division',
          type: 'text',
          readOnly: true,
          valuePaths: ['ShortcutDimension1Code', 'GlobalDimension1Code'],
        },
        {
          name: 'requestingDepartment',
          label: 'Department',
          type: 'text',
          readOnly: true,
          valuePaths: [
            'Department',
            'RequestingDepartment',
            'Requesting_Department',
            'ShortcutDimension2Code',
          ],
        },
        {
          name: 'budgetType',
          label: 'Budget Type',
          type: 'select',
          options: purchaseBudgetTypeOptions,
          valuePaths: ['BudgetType', 'Budget_Type'],
          valueMap: {
            project: 'project',
            'non-project': 'nonProject',
            nonproject: 'nonProject',
          },
        },
        {
          name: 'projectCode',
          label: 'Project Name / Code',
          type: 'text',
          valuePaths: ['ProjectCode', 'Project_Code'],
          visibleWhen: (values) => values.budgetType === 'project',
        },
        {
          name: 'purchaseRequestType',
          label: 'Purchase Type',
          type: 'select',
          options: purchaseRequestTypeOptions,
          valuePaths: ['PurchaseRequestType', 'Purchase_Request_Type', 'purchaseRequestType'],
          valueMap: {
            '0': 'goods',
            '1': 'service',
            '2': 'goods',
            '3': 'consultancy',
            '4': 'other',
            goods: 'goods',
            service: 'service',
            services: 'service',
            asset: 'goods',
            consultancy: 'consultancy',
            other: 'other',
          },
        },
        {
          name: 'otherPurchaseType',
          label: 'Specify Purchase Type',
          type: 'text',
          valuePaths: ['OtherPurchaseType', 'Other_Purchase_Type', 'otherPurchaseType'],
          visibleWhen: (values) => String(values.purchaseRequestType ?? '') === 'other',
        },
        {
          name: 'dateNeeded',
          label: 'Required Date',
          type: 'date',
          valuePaths: ['RequestedReceiptDate', 'Requested_Receipt_Date', 'OrderDate', 'Order_Date', 'Needed_By_Date'],
        },
        {
          name: 'priority',
          label: 'Priority',
          type: 'select',
          options: purchasePriorityOptions,
          valuePaths: ['Priority', 'priority'],
          valueMap: {
            '0': 'normal',
            '1': 'normal',
            '2': 'critical',
            '3': 'urgent',
            normal: 'normal',
            urgent: 'urgent',
            critical: 'critical',
            low: 'normal',
            high: 'critical',
          },
        },
        {
          name: 'justification',
          label: 'Purpose / Justification',
          type: 'textarea',
          valuePaths: ['Justification', 'justification', 'PostingDescription', 'Posting_Description'],
        },
        {
          name: 'technicalRequirement',
          label: 'Technical Requirement / Specification (optional)',
          type: 'textarea',
          valuePaths: ['TechnicalRequirement', 'Technical_Requirement'],
          visibleWhen: (values) => String(values.purchaseRequestType ?? '') === 'goods',
        },
        {
          name: 'scopeOfWork',
          label: 'Scope of Work / TOR (optional)',
          type: 'textarea',
          valuePaths: ['ScopeOfWork', 'Scope_of_Work', 'scopeOfWork'],
          visibleWhen: (values) => ['service', 'consultancy'].includes(String(values.purchaseRequestType ?? '')),
        },
        {
          name: 'otherRequirements',
          label: 'Other Requirements / Remarks (optional)',
          type: 'textarea',
          valuePaths: ['OtherRequirements', 'Other_Requirements'],
        },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        {
          label: 'Requested By',
          paths: ['payload.RequestorName'],
          resolve: (request) =>
            requesterDisplayName(
              request,
              String(employee?.employeeNo ?? '').trim(),
              String(employee?.displayName ?? '').trim(),
            ),
        },
        { label: 'Employee No.', paths: ['request.makerEmployeeNo', 'payload.EmployeeNo', 'payload.Employee_No'] },
        { label: 'Request Date', paths: ['payload.DocumentDate', 'payload.Document_Date', 'request.createdAt'], format: 'date' },
        { label: 'Required Date', paths: ['payload.RequestedReceiptDate', 'payload.OrderDate', 'payload.Order_Date'], format: 'date' },
        { label: 'Division', paths: ['payload.ShortcutDimension1Code', 'payload.GlobalDimension1Code'] },
        { label: 'Department', paths: ['payload.Department', 'payload.ShortcutDimension2Code', 'request.departmentName'] },
        { label: 'Budget Type', paths: ['payload.BudgetType', 'payload.Budget_Type'] },
        { label: 'Project Name / Code', paths: ['payload.ProjectCode', 'payload.Project_Code'] },
        { label: 'Purchase Type', paths: ['payload.PurchaseRequestType', 'payload.Purchase_Request_Type'], format: 'purchaseRequestType' },
        { label: 'Specified Purchase Type', paths: ['payload.OtherPurchaseType', 'payload.Other_Purchase_Type', 'payload.otherPurchaseType'] },
        { label: 'Priority', paths: ['payload.Priority', 'payload.priority'], format: 'purchasePriority' },
        { label: 'Purpose / Justification', paths: ['payload.Justification', 'payload.PostingDescription', 'payload.Posting_Description'] },
        { label: 'Technical Requirement', paths: ['payload.TechnicalRequirement', 'payload.Technical_Requirement'] },
        { label: 'Scope of Work / TOR', paths: ['payload.ScopeOfWork', 'payload.Scope_of_Work'] },
        { label: 'Other Requirements', paths: ['payload.OtherRequirements', 'payload.Other_Requirements'] },
        { label: 'Total Value', paths: ['request.amount', 'payload.TotalAmount', 'payload.AmountIncludingVAT'], format: 'currency' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Requested Items / Services',
        addLabel: 'Add Line',
        schema: purchaseLineSchema,
        defaultValues: {
          type: '2',
          itemNo: '',
          itemName: '',
          category: '',
          description: '',
          specification: '',
          quantity: 1,
          uom: 'PCS',
          estimatedUnitPrice: 0,
          estimatedTotalPrice: 0,
          preferredBrandModel: '',
          requiredDate: today,
          suggestedSupplier: '',
          remarks: '',
        },
        defaultValuesFromRequest: (request) => ({
          type: defaultLineTypeForPurchaseType(
            request.payload?.PurchaseRequestType ??
              request.payload?.Purchase_Request_Type ??
              request.payload?.purchaseRequestType,
          ),
          requiredDate: String(
            request.payload?.RequestedReceiptDate ??
              request.payload?.OrderDate ??
              request.payload?.Order_Date ??
              today,
          ).slice(0, 10),
        }),
        onValuesChange: (values, form) => {
          syncLinePricing(values, form)
        },
        buildLinePayload: (values) => {
          const qty = Number(values.quantity ?? 0)
          const unit = Number(values.estimatedUnitPrice ?? 0)
          return {
            ...values,
            whereNeeded: '',
            item: '',
            itemNo: '',
            itemName: values.itemName,
            reasonForRequest: values.description,
            reason: values.description,
            specification: values.specification,
            uom: values.uom,
            unitOfMeasure: values.uom,
            estimatedUnitPrice: unit,
            preferredBrandModel: values.preferredBrandModel,
            suggestedSupplier: values.suggestedSupplier,
            remarks: values.remarks,
            category: values.category,
            requiredDate: values.requiredDate,
            estimatedTotalPrice: qty * unit,
          }
        },
        fields: [
          {
            name: 'type',
            label: 'Line Type',
            type: 'select',
            options: purchaseLineTypeOptions,
            valuePaths: ['typeCode', 'type'],
            valueMap: { service: '1', item: '2', asset: '4' },
          },
          {
            name: 'category',
            label: 'Category',
            type: 'select',
            options: purchaseCategoryOptions,
            valuePaths: ['category', 'RequestCategory', 'requestCategory'],
          },
          {
            name: 'itemName',
            label: 'Item / Service Name',
            type: 'text',
            placeholder: 'Example: Laptop, audit service, office chair',
            valuePaths: ['itemName'],
          },
          { name: 'description', label: 'Description', type: 'textarea' },
          { name: 'specification', label: 'Specification', type: 'textarea' },
          {
            name: 'uom',
            label: 'UOM',
            type: 'select',
            options: storeUomOptions,
            valuePaths: ['uom', 'unitOfMeasure', 'UnitOfMeasureCode', 'Unit_of_Measure_Code'],
          },
          { name: 'quantity', label: 'Quantity', type: 'number' },
          {
            name: 'estimatedUnitPrice',
            label: 'Estimated Unit Price (optional)',
            type: 'number',
            valuePaths: ['directUnitCost', 'estimatedUnitPrice'],
          },
          {
            name: 'estimatedTotalPrice',
            label: 'Estimated Total Price (optional, auto)',
            type: 'number',
            readOnly: true,
            valuePaths: ['amount', 'estimatedTotalPrice'],
          },
          {
            name: 'preferredBrandModel',
            label: 'Preferred Brand / Model (optional)',
            type: 'text',
            valuePaths: ['preferredBrandModel', 'PreferredBrandModel', 'RFQRemarks'],
          },
          {
            name: 'requiredDate',
            label: 'Line Required Date',
            type: 'date',
            valuePaths: ['requiredDate', 'ExpectedReceiptDate', 'Expected_Receipt_Date'],
          },
          {
            name: 'suggestedSupplier',
            label: 'Suggested Supplier (optional)',
            type: 'text',
            valuePaths: ['suggestedSupplier', 'SuggestedSupplier'],
          },
          {
            name: 'remarks',
            label: 'Remarks (optional)',
            type: 'text',
            valuePaths: ['remarks', 'ExtendedDescription', 'extendedDescription'],
          },
        ],
        columns: [
          {
            key: 'type',
            header: 'Type',
            format: (value) => {
              const text = String(value ?? '').trim()
              if (!text) return 'Item'
              if (text === '1') return 'Service'
              if (text === '2') return 'Item'
              if (text === '4') return 'Asset'
              return text
            },
          },
          { key: 'itemName', header: 'Item / Service Name' },
          { key: 'description', header: 'Description' },
          {
            key: 'category',
            header: 'Category',
            visibleWhen: (lines) => lines.some((line) => hasText(line.category)),
          },
          {
            key: 'specification',
            header: 'Specification',
            visibleWhen: (lines) => lines.some((line) => hasText(line.specification ?? line.reasonForRequest)),
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
            key: 'directUnitCost',
            header: 'Est. Unit',
            format: (value) => (Number(value ?? 0) > 0 ? formatCurrency(Number(value)) : '—'),
            visibleWhen: (lines) => lines.some((line) => hasPositiveNumber(line.directUnitCost)),
          },
          {
            key: 'amount',
            header: 'Est. Total',
            format: (value) => (Number(value ?? 0) > 0 ? formatCurrency(Number(value)) : '—'),
            visibleWhen: (lines) => lines.some((line) => hasPositiveNumber(line.amount)),
          },
          {
            key: 'preferredBrandModel',
            header: 'Brand / Model',
            visibleWhen: (lines) => lines.some((line) => hasText(line.preferredBrandModel)),
          },
          {
            key: 'suggestedSupplier',
            header: 'Supplier',
            visibleWhen: (lines) => lines.some((line) => hasText(line.suggestedSupplier)),
          },
          {
            key: 'requiredDate',
            header: 'Required',
            visibleWhen: (lines) => lines.some((line) => hasText(line.requiredDate)),
          },
          {
            key: 'remarks',
            header: 'Remarks',
            visibleWhen: (lines) => lines.some((line) => hasText(line.remarks)),
          },
        ],
        emptyText: '*** No Purchase Lines Found ***',
        canEdit: true,
      }}
    />
  )
}
