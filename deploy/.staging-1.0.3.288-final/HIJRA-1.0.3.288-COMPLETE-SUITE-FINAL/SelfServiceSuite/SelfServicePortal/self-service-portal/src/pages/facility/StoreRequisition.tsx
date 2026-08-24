import { formatISO } from 'date-fns'
import { useMemo } from 'react'
import { useSearchParams } from 'react-router-dom'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { storeLineTypeOptions } from '@/data/essOptions'
import { storeHeaderSchema, storeLineSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { useAuth } from '@/hooks/useAuth'
import { formatDate } from '@/utils/formatters'
import type { LookupOption } from '@/api/endpoints/lookups'
import type { PortalRequest } from '@/types/erp.types'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'storeRequisition', entity: 'selfServiceStoreRequisitions' } as const

function hasText(value: unknown) {
  const text = String(value ?? '').trim()
  return Boolean(text && text !== '-' && !text.startsWith('0001-01-01'))
}

function matchLocationCode(hint: string, locations: LookupOption[]) {
  const needle = hint.trim().toLowerCase()
  if (!needle || !locations.length) return ''
  const exact = locations.find(
    (option) =>
      option.value.toLowerCase() === needle ||
      option.label.toLowerCase() === needle ||
      option.label.toLowerCase().startsWith(`${needle} `) ||
      option.label.toLowerCase().includes(`· ${needle}`) ||
      option.label.toLowerCase().includes(`- ${needle}`),
  )
  if (exact) return exact.value
  const partial = locations.find(
    (option) =>
      option.label.toLowerCase().includes(needle) || needle.includes(option.value.toLowerCase()),
  )
  return partial?.value ?? ''
}

function optionDescription(option: LookupOption | undefined) {
  if (!option) return ''
  const fromMeta = String(option.meta?.description ?? option.meta?.name ?? '').trim()
  if (fromMeta) return fromMeta
  const label = String(option.label ?? '').trim()
  if (!label) return ''
  // Labels are usually "Description · CODE" or "Description (CODE)".
  return label.split(/\s*[·|]\s*/)[0]?.replace(/\s*\([^)]*\)\s*$/, '').trim() || label
}

function headerIssuingStore(request: PortalRequest | undefined) {
  const payload = (request?.payload ?? {}) as Record<string, unknown>
  return String(payload.IssuingStore ?? payload.Issuing_Store ?? payload.issuingStore ?? '').trim()
}

function StoreHowItWorks() {
  return (
    <div className="mb-4 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-700">
      <p className="font-semibold text-[var(--portal-navy)]">How this works</p>
      <ol className="mt-2 list-decimal space-y-1 pl-5 text-xs text-slate-600 sm:text-sm">
        <li>Create a draft with the date needed, issuing store, and a short description.</li>
        <li>Add one or more item or fixed-asset lines from the store catalogue.</li>
        <li>Request approval — budget is checked in Business Central before approval.</li>
        <li>After approval, store staff issue stock in BC. You then confirm receipt here.</li>
      </ol>
      <p className="mt-2 text-xs text-slate-500">
        Tip: the same item cannot be requested again while another of your requests is still Open,
        Pending Approval, or Approved. Rejected or Cancelled documents free the item.
      </p>
    </div>
  )
}

function StoreDetailGuide({
  request,
  lines,
}: {
  request: PortalRequest
  lines: Record<string, unknown>[]
}) {
  const status = request.status.trim().toLowerCase()
  const issued = lines.some(
    (line) => Number(line.quantityIssued ?? 0) > 0 || Number(line.lastQuantityIssued ?? 0) > 0,
  )
  const needsReceipt = lines.some((line) => {
    const issuedQty = Number(line.quantityIssued ?? 0) || Number(line.lastQuantityIssued ?? 0)
    return issuedQty > 0 && Number(line.quantityReceived ?? 0) < issuedQty
  })
  const approvalDone = ['approved', 'posted', 'released'].includes(status)
  const pending = status === 'pending approval' || status === 'submitted'

  let message =
    'Add at least one line, then click Request Approval when the details look correct.'
  if (status === 'draft' || status === 'open') {
    message =
      lines.length === 0
        ? 'Next: add the items or assets you need, then request approval.'
        : 'Next: review the lines, then click Request Approval.'
  } else if (pending) {
    message = 'Waiting for an approver. You will see progress update when it is approved or rejected.'
  } else if (status === 'rejected' || status === 'cancelled') {
    message = `This request is ${status}. Create a new requisition if you still need the items.`
  } else if (approvalDone && !issued) {
    message =
      'Approved. Store staff will issue the stock in Business Central. Receipt confirmation appears after issue.'
  } else if (needsReceipt) {
    message =
      'Store has issued stock. Confirm receipt on each line (or use Receive all) when the items are in your hands.'
  } else if (issued) {
    message = 'All issued quantities are receipt-confirmed. This store requisition is complete.'
  }

  return (
    <div className="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-700">
      <p className="font-semibold text-[var(--portal-navy)]">What to do next</p>
      <p className="mt-1 text-xs text-slate-600 sm:text-sm">{message}</p>
    </div>
  )
}

export function StoreRequisition() {
  const [searchParams] = useSearchParams()
  const { employee } = useAuth()
  const locations = useLookupOptions('locations')
  const items = useLookupOptions('items')
  const assets = useLookupOptions('assets')

  const defaultIssuingStore = useMemo(() => {
    const hint = String(
      employee?.placeOfDuty || employee?.branchName || employee?.departmentName || '',
    ).trim()
    return matchLocationCode(hint, locations.options)
  }, [employee?.placeOfDuty, employee?.branchName, employee?.departmentName, locations.options])

  const lookupBusy = locations.isLoading || items.isLoading || assets.isLoading
  const lookupError = locations.isError || items.isError || assets.isError

  return (
    <MultiStepRequestPage
      title="Store Requisition"
      headerLabel="New store requisition"
      description="Request stock or a fixed asset from the store. Follow the steps from draft → approval → store issue → your receipt confirmation."
      module={module}
      queryKey={['facility', 'store-requisition']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New store request"
      listValueColumn={{
        id: 'status',
        header: 'Status',
        cell: (row) => String(row.status ?? 'Open'),
      }}
      initialMode={searchParams.get('new') === '1' ? 'create' : 'list'}
      headerSchema={storeHeaderSchema}
      headerDefaults={{
        dateRequired: today,
        description: '',
        issuingStore: defaultIssuingStore,
      }}
      headerPreface={
        <>
          <StoreHowItWorks />
          {lookupBusy ? (
            <p className="mb-4 text-xs text-slate-500">
              Loading stores, items, and assets from Business Central…
            </p>
          ) : null}
          {lookupError ? (
            <p className="mb-4 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-900">
              Some Business Central lists failed to load. Refresh if a dropdown is empty.
            </p>
          ) : null}
        </>
      }
      headerOnValuesChange={(values, form) => {
        if (!String(values.issuingStore ?? '').trim() && defaultIssuingStore) {
          form.setValue('issuingStore', defaultIssuingStore, { shouldValidate: false })
        }
      }}
      buildHeaderPayload={(values) => ({
        ...values,
        requestDate: values.dateRequired,
        requestDescription: values.description,
        title: String(values.description || 'Store Requisition'),
      })}
      headerFields={[
        {
          name: 'dateRequired',
          label: 'Date needed',
          type: 'date',
          valuePaths: ['RequiredDate', 'Required_Date', 'RequestDate'],
          hint: 'When do you need the items? Defaults to today.',
        },
        {
          name: 'issuingStore',
          label: 'Issuing store',
          type: 'select',
          options: locations.options,
          valuePaths: ['IssuingStore', 'Issuing_Store'],
          placeholder: locations.isLoading
            ? 'Loading stores…'
            : locations.isError
              ? 'Could not load stores from Business Central'
              : 'Select the store that will issue stock…',
          hint: locations.isError
            ? 'Refresh the page if the store list is empty.'
            : 'All lines use this store. Prefills from your place of duty when possible.',
        },
        {
          name: 'description',
          label: 'What is this for?',
          type: 'textarea',
          valuePaths: ['RequestDescription', 'Request_Description'],
          placeholder: 'e.g. Stationery for HQ admin / spare parts for printer repair',
          hint: 'Short description shown in your request list and to approvers.',
          fullWidth: true,
        },
      ]}
      detailGuide={({ request, lines }) => <StoreDetailGuide request={request} lines={lines} />}
      detailFields={[
        { label: 'Requisition No.', paths: ['request.requestNo'] },
        {
          label: 'Requested by',
          paths: ['request.makerName', 'payload.RequesterName', 'payload.RequesterID'],
        },
        { label: 'Employee No.', paths: ['request.makerEmployeeNo', 'payload.EmployeeNo'] },
        { label: 'Job title', paths: ['payload.RequesterJobTitle'] },
        {
          label: 'Branch / place of duty',
          paths: ['payload.RequesterPlaceOfDuty', 'payload.RequesterBranch'],
        },
        {
          label: 'Request date',
          paths: ['payload.Requestdate', 'payload.RequestDate', 'request.createdAt'],
          format: 'date',
        },
        {
          label: 'Date needed',
          paths: ['payload.RequiredDate', 'payload.Required_Date', 'payload.RequestDate'],
          format: 'date',
        },
        { label: 'Issuing store', paths: ['payload.IssuingStore', 'payload.Issuing_Store'] },
        {
          label: 'Description',
          paths: ['payload.RequestDescription', 'payload.Request_Description'],
        },
        { label: 'Justification', paths: ['payload.Justification'] },
        {
          label: 'Department / cost centre',
          paths: [
            'request.departmentName',
            'request.departmentCode',
            'payload.ShortcutDimension2Code',
          ],
        },
        {
          label: 'Division',
          paths: ['payload.GlobalDimension1Code', 'payload.Global_Dimension_1_Code'],
        },
        {
          label: 'Responsibility centre',
          paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'],
        },
        { label: 'Store receipt No.', paths: ['payload.SRNNo', 'payload.SRN_No'] },
        { label: 'Issue date', paths: ['payload.IssueDate', 'payload.Issue_Date'], format: 'date' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Requested items',
        addLabel: 'Add item / asset',
        schema: storeLineSchema,
        defaultValues: {
          type: '1',
          issuingStore: defaultIssuingStore,
          itemNo: '',
          description: '',
          quantity: 1,
        },
        defaultValuesFromRequest: (request) => {
          const store = headerIssuingStore(request) || defaultIssuingStore
          return { issuingStore: store, type: '1', quantity: 1 }
        },
        requiredMessage: 'Add at least one item or fixed asset before requesting approval.',
        emptyText: 'No lines yet — click Add item / asset to start.',
        canEdit: false,
        onValuesChange: (values, form) => {
          const type = String(values.type ?? '1')
          const itemNo = String(values.itemNo ?? '')
          const catalogue = type === '2' ? assets.options : items.options
          const selected = catalogue.find((option) => option.value === itemNo)
          const nextDescription = optionDescription(selected)
          if (itemNo && nextDescription && !String(values.description ?? '').trim()) {
            form.setValue('description', nextDescription, { shouldValidate: false })
          }
          if (type === '1' && (!values.quantity || Number(values.quantity) <= 0)) {
            form.setValue('quantity', 1, { shouldValidate: false })
          }
        },
        buildLinePayload: (values) => ({
          ...values,
          location: values.issuingStore,
          item: values.itemNo,
          quantity: values.type === '2' ? 0 : values.quantity,
        }),
        fields: [
          {
            name: 'type',
            label: 'Line type',
            type: 'select',
            options: storeLineTypeOptions,
            hint: 'Choose Item for consumables. Choose Fixed asset for equipment from the FA list.',
          },
          {
            name: 'issuingStore',
            label: 'Issuing store',
            type: 'select',
            options: locations.options,
            placeholder: 'Same store as the header…',
            hint: 'Should match the header issuing store so the line appears in Business Central.',
          },
          {
            name: 'itemNo',
            label: 'Item / asset',
            type: 'select',
            optionsByField: {
              field: 'type',
              options: { '1': items.options, '2': assets.options },
            },
            placeholder: items.isLoading || assets.isLoading
              ? 'Loading catalogue…'
              : 'Search by description or number…',
            hint:
              items.isError || assets.isError
                ? 'Could not load the catalogue. Refresh and try again.'
                : 'Pick from Business Central. Description fills automatically.',
          },
          {
            name: 'description',
            label: 'Description',
            type: 'text',
            placeholder: 'Filled from the selected item — edit if needed',
            hint: 'Shown on the requisition line for approvers and store staff.',
          },
          {
            name: 'quantity',
            label: 'Quantity needed',
            type: 'number',
            visibleWhen: (values) => String(values.type ?? '1') === '1',
            hint: 'How many units you need. Store may issue less if stock is short.',
          },
        ],
        columns: [
          {
            key: 'itemNo',
            header: 'Item / asset',
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
          { key: 'quantityIssued', header: 'Issued' },
          { key: 'quantityReceived', header: 'Received' },
          {
            key: 'lastIssueDate',
            header: 'Issued on',
            format: (value) => formatDate(String(value ?? '')),
            visibleWhen: (lines) => lines.some((line) => hasText(line.lastIssueDate)),
          },
          { key: 'fulfillmentStatus', header: 'Status' },
          {
            key: 'reasonForLessIssued',
            header: 'Issue variance',
            visibleWhen: (lines) => lines.some((line) => hasText(line.reasonForLessIssued)),
          },
          {
            key: 'reason',
            header: 'Receipt variance',
            visibleWhen: (lines) => lines.some((line) => hasText(line.reason)),
          },
          {
            key: 'remarks',
            header: 'Remarks',
            visibleWhen: (lines) => lines.some((line) => hasText(line.remarks)),
          },
        ],
      }}
    />
  )
}
