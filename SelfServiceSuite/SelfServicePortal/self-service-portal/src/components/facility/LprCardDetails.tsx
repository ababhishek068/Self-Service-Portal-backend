import { useQuery } from '@tanstack/react-query'
import { ChevronDown } from 'lucide-react'
import { useState, type ReactNode } from 'react'
import { Button } from '@/components/ui/button'
import { getLocalPurchaseState } from '@/api/endpoints/requestEndpoint'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import { CardSection, type CardField } from '@/components/facility/BcCard'
import { dateTimeValue, dateValue, pick, text } from '@/components/facility/bcCardValues'
import { StoreRequisitionCardDialog } from '@/components/facility/StoreRequisitionCardDialog'
import { storeRequestFromRequisition, useLprStoreRequisition } from '@/components/facility/lprStoreRequisition'
import type { PortalRequest } from '@/types/erp.types'

type Row = Record<string, unknown>

function payloadValue(payload: Row, ...keys: string[]) {
  return pick(...keys.map((key) => payload[key]))
}

function yesNo(value: unknown) {
  const raw = text(value).toLowerCase()
  return raw === 'true' || raw === 'yes' ? 'Yes' : 'No'
}

/**
 * Purchase Requisition (LPR) details laid out like the BC Purchase Requisition Card: Store Request
 * (review before Approve) and General, in the same field order. Other purchase requests keep the
 * standard detail grid (`fallback`).
 */
export function LprCardDetails({ request, fallback }: { request: PortalRequest; fallback: ReactNode }) {
  const access = useLocalPurchaseAccess()
  const [showAll, setShowAll] = useState(false)
  const [storeCardOpen, setStoreCardOpen] = useState(false)
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
  const chainStoreReqNo = pick(chain?.storeRequisitionNo, lpr.storeRequisitionNo)
  // BC apps without the chain's storeRequest: read the store requisition itself.
  const storeQuery = useLprStoreRequisition(request.id, access.enabled && isThisLpr && Boolean(chainStoreReqNo) && !chain?.storeRequest)
  if (!access.enabled || !isThisLpr) return <>{fallback}</>

  const payload = (request.payload ?? {}) as Row
  const store = (chain?.storeRequest ??
    (storeQuery.data ? storeRequestFromRequisition(storeQuery.data.request, storeQuery.data.process as Row | null) : {})) as Row
  const storeReqNo = pick(chainStoreReqNo, store.no)
  const hasStoreDetails = Boolean(chain?.storeRequest || storeQuery.data)
  const officer = pick(lpr.assignedProcUserId)
  const legacyOfficer = pick(lpr.assignedProcurementOfficer, payloadValue(payload, 'AssignedProcurementOfficer'))

  const storeFields: CardField[] = [
    {
      label: 'Store Requisition No.',
      key: true,
      emphasis: 'user',
      value: storeReqNo ? (
        <button
          type="button"
          onClick={() => setStoreCardOpen(true)}
          className="font-semibold text-teal-700 underline-offset-2 hover:underline"
          title="Open Store Requisition"
        >
          {storeReqNo}
        </button>
      ) : (
        ''
      ),
    },
    { label: 'Request Date', value: dateValue(pick(store.requestDate)) },
    { label: 'Required Date', value: dateValue(pick(store.requiredDate)) },
    { label: 'Division Code', value: pick(store.divisionCode) },
    { label: 'Department Code', value: pick(store.departmentCode) },
    { label: 'Request Description', key: true, value: pick(store.requestDescription) },
    { label: 'Purpose / Justification', value: pick(store.purpose), emphasis: 'strong' },
    { label: 'Requester ID', key: true, value: pick(store.requesterId), emphasis: 'user' },
    { label: 'Employee No', value: pick(store.employeeNo) },
    { label: 'LPR Requested By', value: pick(store.lprRequestedBy) },
    { label: 'Issue Stage', key: true, value: pick(store.issueStage) },
    { label: 'Issuing Store', key: true, value: pick(store.issuingStore) },
    { label: 'Approver 1', key: true, value: pick(store.approver1), emphasis: 'user' },
    { label: 'Approver 1 Date', value: dateTimeValue(pick(store.approver1Date)) },
    { label: 'Approver 2', key: true, value: pick(store.approver2), emphasis: 'user' },
    { label: 'Approver 2 Date', value: dateTimeValue(pick(store.approver2Date)) },
  ]

  const generalFields: CardField[] = [
    { label: 'No.', key: true, value: request.requestNo },
    { label: 'Process Step', key: true, value: pick(lpr.processStep), emphasis: 'strong' },
    { label: 'LPR Status', key: true, value: pick(lpr.lprStatus) },
    { label: 'Procurement Source', key: true, value: pick(lpr.procurementSource) },
    { label: 'Assigned Procurement Officer', key: true, value: officer, emphasis: 'user' },
    { label: 'Procurement Officer Type', value: pick(lpr.procOfficerType) },
    { label: 'LPR Project No.', value: pick(lpr.projectNo) },
    { label: 'LPR Project Name', value: pick(lpr.projectName) },
    { label: 'Priority', key: true, value: pick(lpr.priority, payloadValue(payload, 'Priority')) },
    { label: 'Destination Store', value: pick(lpr.destinationStore) },
    { label: 'Created RFQ No.', key: true, value: pick(lpr.createdRfqNo) },
    { label: 'Quote Due Date', value: dateValue(pick(lpr.quoteDueDate)) },
    { label: 'Minimum Quotes Required', value: pick(lpr.minQuotesRequired) || '0' },
    { label: 'Document Date', value: dateValue(pick(lpr.documentDate, payloadValue(payload, 'DocumentDate', 'Document_Date'))) },
    {
      label: 'Required By Date', key: true,
      value: dateValue(pick(lpr.requiredByDate, payloadValue(payload, 'RequestedReceiptDate', 'Requested_Receipt_Date'))),
    },
    { label: 'Request Summary', value: pick(lpr.requestSummary, payloadValue(payload, 'PostingDescription', 'Posting_Description')) },
    { label: 'Purpose / Justification', key: true, value: pick(lpr.justification, payloadValue(payload, 'Justification')) },
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
    { label: 'Status', key: true, value: <StatusBadge status={request.status} /> },
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

  // Store Request shows in full, as on the BC card; General opens with Show all details.
  const hiddenCount = generalFields.filter((field) => !field.key).length

  return (
    <div className="space-y-6">
      {storeReqNo ? (
        <CardSection
          title="Store Request (review before Approve)"
          intro="Same details as Store Req Header Approved. The assigned Procurement Officer prepares the LPR and submits it; the Operations Manager, then FAD, review requester, purpose and lines and approve. RFQ starts only after FAD approval."
          // Until the store requisition loads, only its number.
          fields={hasStoreDetails ? storeFields : storeFields.slice(0, 1)}
          showAll
        />
      ) : null}
      <CardSection title="General" fields={generalFields} showAll={showAll} />
      <div className="flex justify-center">
        <Button type="button" variant="outline" size="sm" className="rounded-full" onClick={() => setShowAll((open) => !open)} aria-expanded={showAll}>
          {showAll ? 'Show fewer details' : `Show all details (${hiddenCount} more)`}
          <ChevronDown className={`h-4 w-4 transition-transform ${showAll ? 'rotate-180' : ''}`} />
        </Button>
      </div>
      {storeCardOpen && storeReqNo ? (
        <StoreRequisitionCardDialog
          lprRequestId={request.id}
          storeRequisitionNo={storeReqNo}
          storeRequest={chain?.storeRequest as Row | undefined}
          onClose={() => setStoreCardOpen(false)}
        />
      ) : null}
    </div>
  )
}
