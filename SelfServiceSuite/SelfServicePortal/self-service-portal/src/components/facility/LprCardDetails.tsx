import { useQuery } from '@tanstack/react-query'
import type { ReactNode } from 'react'
import { getLocalPurchaseState } from '@/api/endpoints/requestEndpoint'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import { formatDate } from '@/utils/formatters'
import type { PortalRequest } from '@/types/erp.types'

type Row = Record<string, unknown>

function text(value: unknown) {
  const raw = String(value ?? '').trim()
  return raw.startsWith('0001-01-01') || raw === '0' || raw === '_' ? '' : raw
}

/** First non-blank value: the LPR chain from BC first, then the purchase header payload. */
function pick(...values: unknown[]) {
  for (const value of values) {
    const found = text(value)
    if (found) return found
  }
  return ''
}

function payloadValue(payload: Row, ...keys: string[]) {
  return pick(...keys.map((key) => payload[key]))
}

function dateValue(value: string) {
  return value ? formatDate(value.slice(0, 10)) : ''
}

function dateTimeValue(value: string) {
  if (!value) return ''
  const parsed = new Date(value)
  return Number.isNaN(parsed.getTime())
    ? value
    : parsed.toLocaleString(undefined, { dateStyle: 'medium', timeStyle: 'short' })
}

function yesNo(value: unknown) {
  const raw = text(value).toLowerCase()
  return raw === 'true' || raw === 'yes' ? 'Yes' : 'No'
}

type CardField = { label: string; value: ReactNode; emphasis?: 'user' | 'strong' }

/** One BC card field: label, dotted leader, value box (blank values keep an empty box, as in BC). */
function CardRow({ label, value, emphasis }: CardField) {
  const empty = value === '' || value === null || value === undefined
  return (
    <div className="flex min-w-0 items-center gap-2 py-1">
      <span className="flex min-w-0 shrink-0 basis-[45%] items-center gap-1 text-sm text-slate-600">
        <span className="truncate">{label}</span>
        <span className="mb-1 h-px min-w-3 flex-1 border-b border-dotted border-slate-300" aria-hidden="true" />
      </span>
      <span
        className={`min-h-[2rem] min-w-0 flex-1 truncate rounded bg-slate-100 px-2.5 py-1.5 text-sm ${
          emphasis === 'user'
            ? 'font-semibold text-teal-700'
            : emphasis === 'strong'
              ? 'font-semibold text-slate-900'
              : 'text-slate-800'
        }`}
        title={typeof value === 'string' ? value : undefined}
      >
        {empty ? '' : value}
      </span>
    </div>
  )
}

function CardSection({ title, intro, fields }: { title: string; intro?: string; fields: CardField[] }) {
  return (
    <section>
      <h3 className="border-b-2 border-slate-700/80 pb-1.5 text-base font-semibold text-slate-900">{title}</h3>
      {intro ? <p className="mt-3 max-w-3xl text-sm text-slate-600">{intro}</p> : null}
      <div className="mt-2 grid gap-x-10 md:grid-cols-2 xl:grid-cols-3">
        {fields.map((field) => (
          <CardRow key={field.label} {...field} />
        ))}
      </div>
    </section>
  )
}

/**
 * Purchase Requisition (LPR) details laid out like the BC Purchase Requisition Card: Store Request
 * (review before Approve) and General, in the same field order. Other purchase requests keep the
 * standard detail grid (`fallback`).
 */
export function LprCardDetails({ request, fallback }: { request: PortalRequest; fallback: ReactNode }) {
  const access = useLocalPurchaseAccess()
  // Same query as the Local Purchase panel, so BC is called once.
  const stateQuery = useQuery({
    queryKey: ['local-purchase', request.id],
    queryFn: () => getLocalPurchaseState(request.id),
    enabled: access.enabled,
    retry: false,
  })
  const chain = stateQuery.data?.chain
  const lpr = (chain?.lpr ?? {}) as Row
  const isThisLpr = Boolean(chain?.lpr) && text(lpr.no).toUpperCase() === request.requestNo.trim().toUpperCase()
  if (!access.enabled || !isThisLpr) return <>{fallback}</>

  const payload = (request.payload ?? {}) as Row
  const store = (chain?.storeRequest ?? {}) as Row
  const storeReqNo = pick(chain?.storeRequisitionNo, store.no, lpr.storeRequisitionNo)
  const officer = pick(lpr.assignedProcUserId)
  const legacyOfficer = pick(lpr.assignedProcurementOfficer, payloadValue(payload, 'AssignedProcurementOfficer'))

  const storeFields: CardField[] = [
    { label: 'Store Requisition No.', value: storeReqNo, emphasis: 'user' },
    { label: 'Request Date', value: dateValue(pick(store.requestDate)) },
    { label: 'Required Date', value: dateValue(pick(store.requiredDate)) },
    { label: 'Division Code', value: pick(store.divisionCode) },
    { label: 'Department Code', value: pick(store.departmentCode) },
    { label: 'Request Description', value: pick(store.requestDescription) },
    { label: 'Purpose / Justification', value: pick(store.purpose), emphasis: 'strong' },
    { label: 'Requester ID', value: pick(store.requesterId), emphasis: 'user' },
    { label: 'Employee No', value: pick(store.employeeNo) },
    { label: 'LPR Requested By', value: pick(store.lprRequestedBy) },
    { label: 'Issue Stage', value: pick(store.issueStage) },
    { label: 'Issuing Store', value: pick(store.issuingStore) },
    { label: 'Approver 1', value: pick(store.approver1), emphasis: 'user' },
    { label: 'Approver 1 Date', value: dateTimeValue(pick(store.approver1Date)) },
    { label: 'Approver 2', value: pick(store.approver2), emphasis: 'user' },
    { label: 'Approver 2 Date', value: dateTimeValue(pick(store.approver2Date)) },
  ]

  const generalFields: CardField[] = [
    { label: 'No.', value: request.requestNo },
    { label: 'Process Step', value: pick(lpr.processStep), emphasis: 'strong' },
    { label: 'LPR Status', value: pick(lpr.lprStatus) },
    { label: 'Procurement Source', value: pick(lpr.procurementSource) },
    { label: 'Assigned Procurement Officer', value: officer, emphasis: 'user' },
    { label: 'Procurement Officer Type', value: pick(lpr.procOfficerType) },
    { label: 'LPR Project No.', value: pick(lpr.projectNo) },
    { label: 'LPR Project Name', value: pick(lpr.projectName) },
    { label: 'Priority', value: pick(lpr.priority, payloadValue(payload, 'Priority')) },
    { label: 'Destination Store', value: pick(lpr.destinationStore) },
    { label: 'Created RFQ No.', value: pick(lpr.createdRfqNo) },
    { label: 'Quote Due Date', value: dateValue(pick(lpr.quoteDueDate)) },
    { label: 'Minimum Quotes Required', value: pick(lpr.minQuotesRequired) || '0' },
    { label: 'Document Date', value: dateValue(pick(lpr.documentDate, payloadValue(payload, 'DocumentDate', 'Document_Date'))) },
    {
      label: 'Required By Date',
      value: dateValue(pick(lpr.requiredByDate, payloadValue(payload, 'RequestedReceiptDate', 'Requested_Receipt_Date'))),
    },
    { label: 'Request Summary', value: pick(lpr.requestSummary, payloadValue(payload, 'PostingDescription', 'Posting_Description')) },
    { label: 'Purpose / Justification', value: pick(lpr.justification, payloadValue(payload, 'Justification')) },
    {
      label: 'Technical Requirement',
      value: pick(lpr.technicalRequirement, payloadValue(payload, 'TechnicalRequirement', 'Technical_Requirement')),
    },
    {
      label: 'Other Requirements / Notes',
      value: pick(lpr.otherRequirements, payloadValue(payload, 'OtherRequirements', 'Other_Requirements')),
    },
    { label: 'Approval Comments', value: pick(lpr.approvalComments) },
    { label: 'Rejection Reason', value: pick(lpr.rejectionReason) },
    { label: 'Cancellation Reason', value: pick(lpr.cancellationReason) },
    {
      label: 'Dept Head Approved By',
      value: pick(lpr.deptHeadApprovedBy, payloadValue(payload, 'AdminApprovedBy', 'Admin_Approved_By')),
      emphasis: 'user',
    },
    {
      label: 'Dept Head Approved Date',
      value: dateValue(pick(lpr.deptHeadApprovedDate, payloadValue(payload, 'AdminApprovedDate', 'Admin_Approved_Date'))),
    },
    { label: 'Operations Manager Approved By', value: pick(lpr.opsApprovedBy), emphasis: 'user' },
    { label: 'Operations Manager Approved Date', value: dateValue(pick(lpr.opsApprovedDate)) },
    {
      label: 'FAD Approved By',
      value: pick(lpr.fadApprovedBy, payloadValue(payload, 'FinanceApprovedBy', 'Finance_Approved_By')),
      emphasis: 'user',
    },
    {
      label: 'FAD Approved Date',
      value: dateValue(pick(lpr.fadApprovalDate, payloadValue(payload, 'FinanceApprovalDate', 'Finance_Approval_Date'))),
    },
    {
      label: 'Responsibility Center',
      value: pick(lpr.responsibilityCenter, payloadValue(payload, 'ResponsibilityCenter', 'Responsibility_Center')),
    },
    {
      label: 'Division Code',
      value: pick(lpr.divisionCode, payloadValue(payload, 'ShortcutDimension1Code', 'Shortcut_Dimension_1_Code')),
    },
    {
      label: 'Department Code',
      value: pick(lpr.departmentCode, payloadValue(payload, 'ShortcutDimension2Code', 'Shortcut_Dimension_2_Code')),
    },
    {
      label: 'Department',
      value: pick(lpr.department, payloadValue(payload, 'ShortcutDimension3Code', 'Shortcut_Dimension_3_Code')),
    },
    ...(legacyOfficer && legacyOfficer !== officer
      ? [{ label: 'Procurement Officer (Requisition)', value: legacyOfficer, emphasis: 'user' as const }]
      : []),
    { label: 'Requisition No.', value: pick(lpr.requisitionNo, payloadValue(payload, 'RequisitionNo', 'Requisition_No')) },
    {
      label: 'Requestor ID',
      value: pick(lpr.requestorId, payloadValue(payload, 'RequestorName', 'Requestor_Name')),
      emphasis: 'user',
    },
    { label: 'Employee No.', value: pick(lpr.employeeNo, payloadValue(payload, 'EmployeeNo', 'Employee_No')) },
    { label: 'Imprest Memo No', value: pick(lpr.imprestMemoNo, payloadValue(payload, 'ImprestMemoNo', 'Imprest_Memo_No')) },
    { label: 'Status', value: <StatusBadge status={request.status} /> },
    { label: 'Currency Code', value: pick(lpr.currencyCode, payloadValue(payload, 'CurrencyCode', 'Currency_Code')) },
    {
      label: 'Currency Factor',
      value: pick(lpr.currencyFactor, payloadValue(payload, 'CurrencyFactor', 'Currency_Factor')) || '0',
    },
    {
      label: 'Prices Including Tax',
      value: yesNo(lpr.pricesIncludingVat ?? payload.PricesIncludingVAT ?? payload.Prices_Including_VAT),
    },
  ]

  return (
    <div className="space-y-6">
      {storeReqNo ? (
        <CardSection
          title="Store Request (review before Approve)"
          intro="Same details as Store Req Header Approved. The assigned Procurement Officer prepares the LPR and submits it; the Operations Manager, then FAD, review requester, purpose and lines and approve. RFQ starts only after FAD approval."
          // Older BC apps send only the store requisition number.
          fields={chain?.storeRequest ? storeFields : storeFields.slice(0, 1)}
        />
      ) : null}
      <CardSection title="General" fields={generalFields} />
    </div>
  )
}
