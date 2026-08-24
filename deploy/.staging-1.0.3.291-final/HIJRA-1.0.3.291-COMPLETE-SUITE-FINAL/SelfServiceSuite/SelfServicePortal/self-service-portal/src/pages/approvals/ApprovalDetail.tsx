import { useState } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { Link, Navigate, useParams, useSearchParams } from 'react-router-dom'
import { AlertTriangle, Check, RefreshCw, X } from 'lucide-react'
import { ApprovalTimeline } from '@/components/shared/ApprovalTimeline'
import { RequestAttachments } from '@/components/shared/RequestAttachments'
import { ConfirmDialog } from '@/components/shared/ConfirmDialog'
import { ListSearch } from '@/components/shared/ListSearch'
import type { DetailFieldConfig } from '@/components/shared/RequestFormPage'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { Skeleton } from '@/components/ui/skeleton'
import { useAssignApprovalVehicle, useApprovalDecision, useApprovalDetail } from '@/hooks/useApprovals'
import { useAuth } from '@/hooks/useAuth'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { usePermissions } from '@/hooks/usePermissions'
import { approvalDetailFields } from '@/data/approvalDetailFields'
import { MaintenanceWorkflowActions } from '@/pages/facility/MaintenanceRequest'
import { extractApplicationReason } from '@/utils/applicationReason'
import { formatCurrency, formatDate, formatDateTime } from '@/utils/formatters'
import { isMakerAllowedToApprove } from '@/utils/validators'
import { matchesSearchQuery } from '@/utils/tableSearch'
import { shouldShowFinanceOrgDetailField } from '@/utils/financeOrgDisplay'
import { useToast } from '@/components/feedback/ToastProvider'

function pendingLikeStatus(status?: string) {
  const normalized = String(status ?? '').trim().toLowerCase()
  return normalized === 'pending approval' || normalized === 'open' || normalized === 'submitted'
}

const hiddenLineFields = new Set([
  'id',
  'recid',
  'systemid',
  'systemcreatedat',
  'systemcreatedby',
  'systemmodifiedat',
  'systemmodifiedby',
  'odataetag',
  'lineno',
  'select',
  'externalpassname',
  'externalpassorganization',
])

/** BC uses 0001-01-01 as its "blank" date — treat it as empty. */
const ZERO_DATE = /^0001-01-01/

function isBlankLineValue(value: unknown) {
  if (value === undefined || value === null) return true
  if (typeof value === 'boolean') return value === false
  const text = String(value).trim()
  return !text || ZERO_DATE.test(text)
}

function visibleLineKeys(lines: Record<string, unknown>[]) {
  const first = lines[0] ?? {}
  return Object.keys(first).filter((key) => {
    const normalized = key.replace(/[^a-z0-9]/gi, '').toLowerCase()
    if (hiddenLineFields.has(normalized) || normalized.startsWith('system')) return false
    // Hide columns that carry no information on any line (blank, zero-date, false).
    return lines.some((line) => !isBlankLineValue(line[key]))
  })
}

function formatLineValue(value: unknown) {
  if (value === undefined || value === null) return '—'
  if (typeof value === 'boolean') return value ? 'Yes' : 'No'
  const text = String(value).trim()
  if (!text || ZERO_DATE.test(text)) return '—'
  if (/^\d{4}-\d{2}-\d{2}(T|$)/.test(text)) {
    const parsed = new Date(text)
    if (!Number.isNaN(parsed.getTime())) {
      return parsed.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' })
    }
  }
  return text
}

function isNumericLineValue(value: unknown) {
  if (typeof value === 'number') return true
  return typeof value === 'string' && /^-?\d+(\.\d+)?$/.test(value.trim())
}

const purchaseLineFieldLabels: Record<string, string> = {
  description: 'Specification',
  reasonForRequest: 'Reason for Request',
  masterDescription: 'Item Master Description',
  itemNo: 'Item / Service / FA No.',
  directUnitCost: 'Unit Cost',
  unitOfMeasure: 'Unit of Measure',
  lineAmount: 'Line Amount',
  amountIncludingVat: 'Amount Incl. VAT',
}

const assetTransferLineFieldLabels: Record<string, string> = {
  vehicleRegistrationNo: 'Vehicle Registration No.',
  toolDescription: 'Tool / Accessory',
  toolCode: 'Tool Code',
  vehicleNo: 'Vehicle No.',
  quantity: 'Quantity',
  serialNo: 'Serial No.',
  condition: 'Condition',
  remarks: 'Remarks',
}

const gatePassLineFieldLabels: Record<string, string> = {
  type: 'Type',
  issuingStore: 'Issuing Store',
  itemNo: 'FA / Item No.',
  description: 'Description',
  tagNo: 'Tag No.',
  quantity: 'Quantity',
  quantityIssued: 'Quantity Issued',
  quantityRequested: 'Quantity Requested',
  quantityToIssue: 'Quantity To Issue',
  availableStock: 'Available Stock',
  unitOfMeasure: 'Unit of Measure',
}

const staffClaimLineFieldLabels: Record<string, string> = {
  medicalAmount: 'Medical Bill Amount',
  coveragePercent: 'Coverage %',
  amountToRefund: 'Refund Amount',
  amount: 'Net Claim Amount',
  netClaimAmount: 'Net Claim Amount',
  hospitalCategory: 'Hospital Category',
  accountNo: 'G/L Account No.',
  accountName: 'G/L Account Name',
  claimType: 'Claim Type',
  expenditureDescription: 'Expenditure Description',
  claimReceiptNo: 'Claim Receipt No.',
}

const storeRequisitionLineFieldLabels: Record<string, string> = {
  budgetBalance: 'Budget Balance',
  budgetName: 'Budget Name',
  currentMonthBudget: 'Current Month Budget',
  totalBudget: 'Total Budget',
  lineAmount: 'Line Amount',
  voteAccount: 'Vote Account',
  tagNo: 'Tag No.',
  quantityIssued: 'Quantity Issued',
  fulfillmentStatus: 'Fulfillment Status',
}

function lineFieldLabel(key: string, requestType?: string) {
  if (requestType === 'purchaseRequisition' && purchaseLineFieldLabels[key]) {
    return purchaseLineFieldLabels[key]
  }
  if (requestType === 'assetTransfer' && assetTransferLineFieldLabels[key]) {
    return assetTransferLineFieldLabels[key]
  }
  if (requestType === 'staffClaim' && staffClaimLineFieldLabels[key]) {
    return staffClaimLineFieldLabels[key]
  }
  if (requestType === 'storeRequisition' && storeRequisitionLineFieldLabels[key]) {
    return storeRequisitionLineFieldLabels[key]
  }
  if (requestType === 'gatePass' && gatePassLineFieldLabels[key]) {
    return gatePassLineFieldLabels[key]
  }
  return key
    .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
    .replaceAll('_', ' ')
    .replace(/\b\w/g, (character) => character.toUpperCase())
}

function detailPathValue(source: unknown, path: string) {
  return path.split('.').reduce<unknown>((current, part) => {
    if (!current || typeof current !== 'object') return undefined
    return (current as Record<string, unknown>)[part]
  }, source)
}

function configuredDetailValue(source: unknown, field: DetailFieldConfig) {
  for (const path of field.paths) {
    const value = detailPathValue(source, path)
    if (isBlankLineValue(value)) continue
    if (field.hideZero && Number.isFinite(Number(value)) && Number(value) === 0) continue
    if (field.format === 'km' && Number.isFinite(Number(value)) && Number(value) <= 0) continue
    if (field.format === 'currency' && Number(value) === 0) continue
    if (field.format === 'date' && ZERO_DATE.test(String(value).trim())) continue
    return value
  }
  return undefined
}

function formatConfiguredDetail(value: unknown, field: DetailFieldConfig) {
  if (field.format === 'status') return <StatusBadge status={String(value ?? '—')} />
  if (field.format === 'date') return formatDate(value === undefined ? undefined : String(value))
  if (field.format === 'currency') return formatCurrency(Number(value ?? 0))
  if (field.format === 'percentage') return `${Number(value ?? 0)}%`
  if (field.format === 'km') {
    const reading = Number(value)
    if (!Number.isFinite(reading) || reading <= 0) return 'Not recorded'
    return `${reading.toLocaleString()} km`
  }
  if (field.format === 'returned') {
    const returned = value === true || ['true', 'yes', '1'].includes(String(value ?? '').toLowerCase())
    return returned ? 'Returned' : 'Not Returned'
  }
  return String(value ?? '—')
}

export function ApprovalDetail() {
  const { id } = useParams()
  const [searchParams] = useSearchParams()
  const queryClient = useQueryClient()
  const { employee } = useAuth()
  const { canApprove: hasApproverRole } = usePermissions()
  const [comment, setComment] = useState('')
  const [decision, setDecision] = useState<'Approved' | 'Rejected' | null>(null)
  const [resolvedStatus, setResolvedStatus] = useState<'Approved' | 'Rejected' | null>(null)
  const [lineSearch, setLineSearch] = useState('')
  const [selectedVehicle, setSelectedVehicle] = useState('')
  const detail = useApprovalDetail(id ?? '')
  const approval = useApprovalDecision(id ?? '')
  const assignVehicle = useAssignApprovalVehicle(id ?? '')
  const toast = useToast()
  const vehicles = useLookupOptions('vehicles')
  const request = detail.data
  const applicationReason = request ? extractApplicationReason(request.payload, request.title) : ''
  const queueType = searchParams.get('queue')
  const displayStatus = resolvedStatus
    ?? (queueType === 'approved'
      ? 'Approved'
      : queueType === 'rejected'
        ? 'Rejected'
        : request?.status)
  const hasPendingApprovalStep = Boolean(
    request?.approvalSteps?.some((step) => step.status === 'Pending Approval'),
  )
  const isReadOnly =
    Boolean(resolvedStatus) ||
    queueType === 'approved' ||
    queueType === 'rejected' ||
    (!pendingLikeStatus(displayStatus) &&
      !pendingLikeStatus(request?.status) &&
      !hasPendingApprovalStep)
  const isNotMaker = request && employee ? isMakerAllowedToApprove(request.makerEmployeeNo, employee.employeeNo) : false
  const canApprove = hasApproverRole && isNotMaker && !isReadOnly
  const payload = request?.payload ?? {}
  const lines = Array.isArray(payload.lines)
    ? (payload.lines as Record<string, unknown>[])
    : []
  const filteredLines = lines.filter((line) => matchesSearchQuery(line, lineSearch))
  const lineKeys = visibleLineKeys(lines)
  const documentDetails = (approvalDetailFields[request?.requestType ?? ''] ?? [])
    .map((field) => ({
      field,
      value: configuredDetailValue({ request, payload }, field),
    }))
    .filter((detail) => {
      if (detail.value === undefined) return false
      return shouldShowFinanceOrgDetailField(
        detail.field.label,
        detail.value,
        payload as Record<string, unknown>,
      )
    })
  const isLeaveRequest = request?.requestType === 'leave'
  const isMaintenanceRequest = request?.requestType === 'maintenance'
  const isTransportRequest = request?.requestType === 'transport'
  const isAssetTransferRequest = request?.requestType === 'assetTransfer'
  const assignedVehicle = String(payload.Vehicle_Allocated ?? payload.VehicleAllocated ?? '').trim()
  const assignVehicleHandler = async () => {
    if (!selectedVehicle) return
    try {
      // Dropdown value is Registration No.; transport assign needs FLT Vehicle "No." (FA).
      const selected = vehicles.options.find((option) => option.value === selectedVehicle)
      const vehiclePrimaryNo = String(selected?.meta?.assetNo ?? '').trim()
      await assignVehicle.mutateAsync(
        vehiclePrimaryNo
          ? { vehicleNo: selectedVehicle, vehiclePrimaryNo }
          : { vehicleNo: selectedVehicle },
      )
      toast.success(`Vehicle ${selectedVehicle} assigned`, 'Vehicle assigned')
      setSelectedVehicle('')
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Vehicle assignment failed', 'Assignment failed')
    }
  }
  const requestMetricLabel = isLeaveRequest
    ? 'Leave quantity'
    : isMaintenanceRequest
      ? 'Quantity'
      : 'Amount / quantity'
  const requestMetricValue = isLeaveRequest
    ? `${request?.amount ?? 0} ${Number(request?.amount ?? 0) === 1 ? 'day' : 'days'}`
    : isMaintenanceRequest
      ? String(payload.Quantity ?? payload.quantity ?? 0)
      : formatCurrency(request?.amount ?? 0)

  if (!id) return <Navigate to="/approvals" replace />

  if (detail.isError) {
    return (
      <PageWrapper title="Document unavailable" description="The approval entry exists, but its source document could not be loaded from Business Central.">
        <Card className="mx-auto max-w-2xl">
          <CardContent className="flex flex-col items-center gap-4 py-10 text-center">
            <span className="flex h-12 w-12 items-center justify-center rounded-full bg-amber-100 text-amber-700">
              <AlertTriangle className="h-6 w-6" />
            </span>
            <div>
              <p className="font-semibold text-slate-900">Could not load this document</p>
              <p className="mt-1 text-sm text-slate-600">{detail.error instanceof Error ? detail.error.message : 'Business Central did not return the source document.'}</p>
            </div>
            <div className="flex flex-wrap justify-center gap-2">
              <Button type="button" onClick={() => void detail.refetch()}>
                <RefreshCw className="h-4 w-4" />
                Retry
              </Button>
              <Button asChild variant="outline"><Link to="/approvals">Back to queue</Link></Button>
            </div>
          </CardContent>
        </Card>
      </PageWrapper>
    )
  }

  const backLink =
    queueType === 'approved' || request?.status === 'Approved'
      ? '/approvals/approved'
      : queueType === 'rejected' || request?.status === 'Rejected'
        ? '/approvals/rejected'
        : '/approvals'

  const submitDecision = (nextDecision: 'Approved' | 'Rejected') => {
    const approvalComment = comment.trim()
    if (nextDecision === 'Rejected' && approvalComment.length < 3) return
    approval.mutate(
      { decision: nextDecision, comment: approvalComment },
      {
        onSuccess: async () => {
          setDecision(null)
          setResolvedStatus(nextDecision)
          setComment('')
          toast.success(
            nextDecision === 'Approved'
              ? 'The document was approved. Status updated below.'
              : 'The document was rejected. Status updated below.',
            nextDecision === 'Approved' ? 'Approved' : 'Rejected',
          )
          await detail.refetch()
        },
        onError: (error) => {
          toast.error(
            error instanceof Error ? error.message : 'The approval action could not be completed.',
            'Approval failed',
          )
        },
      },
    )
  }

  return (
    <PageWrapper
      title={isReadOnly ? 'Document View' : 'Approval Detail'}
      description={
        isReadOnly
          ? 'Review the submitted document and its approval workflow.'
          : 'Review source document, maker/checker audit trail, and approve or reject according to ERP workflow.'
      }
      actions={
        <div className="flex flex-wrap items-center gap-2">
          {canApprove ? (
            <>
              <Button
                disabled={approval.isPending}
                onClick={() => setDecision('Approved')}
              >
                <Check className="h-4 w-4" />
                Approve
              </Button>
              <Button
                variant="destructive"
                disabled={approval.isPending}
                onClick={() => setDecision('Rejected')}
              >
                <X className="h-4 w-4" />
                Reject
              </Button>
            </>
          ) : null}
          <Button asChild variant="outline">
            <Link to={backLink}>Back to queue</Link>
          </Button>
        </div>
      }
    >
      {detail.isLoading || !request ? (
        <Skeleton className="h-96" />
      ) : (
        <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
          <Card className="min-w-0">
            <CardHeader>
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <CardTitle>{request.title}</CardTitle>
                  <CardDescription>{request.requestNo}</CardDescription>
                </div>
                <StatusBadge status={displayStatus ?? request.status} />
              </div>
            </CardHeader>
            <CardContent className="space-y-5">
              <div className="grid gap-4 md:grid-cols-3">
                <div className="rounded-md bg-slate-50 p-3">
                  <p className="text-xs uppercase text-slate-500">Maker</p>
                  <p className="font-medium text-slate-900">{request.makerName}</p>
                </div>
                <div className="rounded-md bg-slate-50 p-3">
                  <p className="text-xs uppercase text-slate-500">{requestMetricLabel}</p>
                  <p className="font-medium text-slate-900">{requestMetricValue}</p>
                </div>
                <div className="rounded-md bg-slate-50 p-3">
                  <p className="text-xs uppercase text-slate-500">Submitted</p>
                  <p className="font-medium text-slate-900">{formatDateTime(request.submittedAt)}</p>
                </div>
              </div>

              {applicationReason ? (
                <div className="rounded-md border border-slate-200 bg-slate-50 p-3">
                  <p className="text-xs uppercase text-slate-500">Application reason</p>
                  <p className="mt-1 whitespace-pre-wrap text-sm text-slate-900">{applicationReason}</p>
                </div>
              ) : null}

              {documentDetails.length ? (
                <div className="border-t border-slate-200 pt-4">
                  <p className="mb-3 text-sm font-semibold text-slate-900">Request details</p>
                  <dl className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                    {documentDetails.map(({ field, value }) => (
                      <div key={field.label}>
                        <dt className="text-xs uppercase tracking-wide text-slate-500">{field.label}</dt>
                        <dd className="mt-1 break-words font-medium text-slate-900">
                          {formatConfiguredDetail(value, field)}
                        </dd>
                      </div>
                    ))}
                  </dl>
                </div>
              ) : null}

              {resolvedStatus ? (
                <div className="rounded-md border border-emerald-200 bg-emerald-50 p-3 text-sm text-emerald-900">
                  Document marked as <strong>{resolvedStatus}</strong>. You can review the updated timeline below or return to the pending queue.
                </div>
              ) : null}

              {queueType && displayStatus !== request.status ? (
                <div className="rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-800">
                  The approval entry is <strong>{displayStatus}</strong>; the current Business Central source document is <strong>{request.status}</strong>.
                </div>
              ) : null}

              {payload.sourceDocumentAvailable === false ? (
                <div className="flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
                  <AlertTriangle className="mt-0.5 h-5 w-5 shrink-0" />
                  <div>
                    <p className="font-semibold">Source document is no longer published by Business Central</p>
                    <p className="mt-1 text-amber-800">The approval entry and its audit trail are still available. Open entries can still be approved or rejected using the Business Central approval entry number.</p>
                  </div>
                </div>
              ) : null}

              {request.requestType === 'purchaseRequisition' && payload.sourceDocumentAvailable !== false && lines.length === 0 ? (
                <div className="flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
                  <AlertTriangle className="mt-0.5 h-5 w-5 shrink-0" />
                  <div>
                    <p className="font-semibold">Purchase lines could not be loaded</p>
                    <p className="mt-1 text-amber-800">
                      Line items for this requisition are not available right now. Refresh the page. If they still
                      do not appear, ask an administrator to check Business Central.
                    </p>
                  </div>
                </div>
              ) : null}

              {lines.length && lineKeys.length ? (
                <div className="border-t border-slate-200 pt-4">
                  <p className="mb-2 text-sm font-semibold text-slate-900">
                    {isAssetTransferRequest
                      ? 'Vehicle tools / accessories to hand over'
                      : 'Document lines'}
                  </p>
                  <div className="mb-3">
                    <ListSearch
                      value={lineSearch}
                      onChange={setLineSearch}
                      total={lines.length}
                      shown={filteredLines.length}
                      placeholder="Search document lines..."
                      ariaLabel="Search document lines"
                    />
                  </div>
                  <div className="overflow-x-auto rounded-md border border-slate-200">
                    <table className="min-w-full border-collapse text-left text-sm">
                      <thead className="border-b border-slate-200 bg-slate-50 text-xs uppercase tracking-wide text-slate-500">
                        <tr>
                          {lineKeys.map((key) => (
                            <th
                              key={key}
                              className={`whitespace-nowrap px-3 py-2 font-semibold align-middle ${
                                lines.every((line) => isBlankLineValue(line[key]) || isNumericLineValue(line[key])) ? 'text-right' : 'text-left'
                              }`}
                            >
                              {lineFieldLabel(key, request.requestType)}
                            </th>
                          ))}
                        </tr>
                      </thead>
                      <tbody>
                        {filteredLines.map((line, index) => (
                          <tr key={String(line.id ?? line.lineNo ?? index)} className="border-b border-slate-100 last:border-0 hover:bg-slate-50/60">
                            {lineKeys.map((key) => (
                              <td
                                key={key}
                                className={`whitespace-nowrap px-3 py-2 align-middle tabular-nums ${
                                  lines.every((row) => isBlankLineValue(row[key]) || isNumericLineValue(row[key])) ? 'text-right' : 'text-left'
                                }`}
                              >
                                {formatLineValue(line[key])}
                              </td>
                            ))}
                          </tr>
                        ))}
                        {filteredLines.length === 0 ? (
                          <tr>
                            <td colSpan={lineKeys.length} className="px-3 py-6 text-center text-slate-500">
                              No document lines match &quot;{lineSearch.trim()}&quot;.
                            </td>
                          </tr>
                        ) : null}
                      </tbody>
                    </table>
                  </div>
                </div>
              ) : null}

              {isTransportRequest && !isReadOnly ? (
                <div className="border-t border-slate-200 pt-4">
                  <p className="mb-2 text-sm font-semibold text-slate-900">Vehicle assignment</p>
                  {assignedVehicle ? (
                    <p className="mb-3 text-sm text-slate-600">
                      Currently allocated: <span className="font-medium text-slate-900">{assignedVehicle}</span>
                    </p>
                  ) : (
                    <p className="mb-3 text-sm text-amber-700">No vehicle is allocated to this trip yet.</p>
                  )}
                  <div className="flex flex-wrap items-end gap-2">
                    <div className="min-w-[220px] flex-1">
                      <Select
                        value={selectedVehicle}
                        onChange={(event) => setSelectedVehicle(event.target.value)}
                        placeholder={vehicles.isLoading ? 'Loading vehicles…' : '--select vehicle--'}
                        options={vehicles.options}
                      />
                    </div>
                    <Button
                      type="button"
                      variant="outline"
                      disabled={!selectedVehicle || assignVehicle.isPending}
                      onClick={() => void assignVehicleHandler()}
                    >
                      {assignVehicle.isPending ? 'Assigning…' : assignedVehicle ? 'Reassign Vehicle' : 'Assign Vehicle'}
                    </Button>
                  </div>
                </div>
              ) : null}

              {isMaintenanceRequest ? (
                <div className="border-t border-slate-200 pt-4">
                  <MaintenanceWorkflowActions
                    request={request}
                    onChanged={async () => {
                      await detail.refetch()
                      await queryClient.invalidateQueries({ queryKey: ['approvals'] })
                    }}
                  />
                </div>
              ) : null}

              <RequestAttachments
                requestId={request.id}
                attachments={request.attachments}
                canUpload={false}
                canDelete={false}
                onUpdated={() => {}}
              />

              {isReadOnly ? (
                <div className="rounded-md border border-slate-200 bg-slate-50 p-3 text-sm text-slate-600">
                  This document is {(displayStatus ?? request.status).toLowerCase()}. Use the workflow timeline on the right to review
                  maker/checker steps and any approval comments.
                </div>
              ) : (
                <>
                  <div>
                    <p className="mb-2 text-sm font-semibold text-slate-900">
                      Approval comment
                      <span className="font-normal text-slate-500"> (required when rejecting)</span>
                    </p>
                    <Textarea
                      value={comment}
                      onChange={(event) => setComment(event.target.value)}
                      placeholder="Enter an approval note or rejection reason"
                    />
                  </div>

                  {!canApprove ? (
                    <div className="rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-800">
                      {!hasApproverRole
                        ? 'Your role does not have approval authority for this document.'
                        : 'Maker cannot approve own request.'}
                    </div>
                  ) : null}

                  <div className="flex flex-wrap gap-2">
                    <Button disabled={!canApprove || approval.isPending} onClick={() => setDecision('Approved')}>
                      <Check className="h-4 w-4" />
                      Approve
                    </Button>
                    <Button
                      variant="destructive"
                      disabled={!canApprove || approval.isPending}
                      onClick={() => setDecision('Rejected')}
                    >
                      <X className="h-4 w-4" />
                      Reject
                    </Button>
                  </div>
                </>
              )}
            </CardContent>
          </Card>

          <Card className="min-w-0">
            <CardHeader>
              <CardTitle>Maker/checker timeline</CardTitle>
              <CardDescription>Audit trail with timestamps.</CardDescription>
            </CardHeader>
            <CardContent>
              <ApprovalTimeline steps={request.approvalSteps} />
            </CardContent>
          </Card>
        </div>
      )}

      <ConfirmDialog
        open={Boolean(decision)}
        title={`${decision ?? 'Submit'} request`}
        description={
          decision === 'Rejected'
            ? 'Enter the rejection reason below. It will be saved in Business Central and shown to the requester.'
            : 'This action writes an approval decision against the source document and cannot be performed by the maker.'
        }
        confirmLabel={decision ?? 'Submit'}
        confirmVariant={decision === 'Rejected' ? 'destructive' : 'default'}
        confirmDisabled={(decision === 'Rejected' && comment.trim().length < 3) || approval.isPending}
        onCancel={() => setDecision(null)}
        onConfirm={() => {
          if (!decision || approval.isPending) return
          submitDecision(decision)
        }}
      >
        {decision === 'Rejected' ? (
          <div>
            <label htmlFor="rejection-reason" className="mb-2 block text-sm font-semibold text-slate-900">
              Rejection reason <span className="text-red-600">*</span>
            </label>
            <Textarea
              id="rejection-reason"
              autoFocus
              value={comment}
              onChange={(event) => setComment(event.target.value)}
              placeholder="Type at least 3 characters"
            />
            <p className="mt-1 text-xs text-slate-500">The Reject button is enabled after a reason is entered.</p>
          </div>
        ) : null}
      </ConfirmDialog>
    </PageWrapper>
  )
}
