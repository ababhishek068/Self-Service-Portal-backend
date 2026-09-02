import { useEffect, useState } from 'react'
import { Link, Navigate, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { AlertTriangle, Check, RefreshCw, X } from 'lucide-react'
import { ApprovalTimeline } from '@/components/shared/ApprovalTimeline'
import { RequestAttachments } from '@/components/shared/RequestAttachments'
import { ConfirmDialog } from '@/components/shared/ConfirmDialog'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Textarea } from '@/components/ui/textarea'
import { Skeleton } from '@/components/ui/skeleton'
import { useApprovalDecision, useApprovalDetail } from '@/hooks/useApprovals'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'
import { extractApplicationReason } from '@/utils/applicationReason'
import { formatCurrency, formatDateTime } from '@/utils/formatters'
import { isMakerAllowedToApprove } from '@/utils/validators'
import { useToast } from '@/components/feedback/ToastProvider'

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

function lineFieldLabel(key: string) {
  return key
    .replace(/([a-z0-9])([A-Z])/g, '$1 $2')
    .replaceAll('_', ' ')
    .replace(/\b\w/g, (character) => character.toUpperCase())
}

function numericValue(value: unknown) {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : 0
}

function firstPayloadNumber(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = payload[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') {
      return numericValue(value)
    }
  }
  return 0
}

function firstPayloadText(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = payload[key]
    if (value === undefined || value === null) continue
    const text = String(value).trim()
    if (text && !ZERO_DATE.test(text) && text !== '-') return text
  }
  return ''
}

function approvalHeaderFacts(
  requestType: string | undefined,
  payload: Record<string, unknown>,
): Array<{ label: string; value: string }> {
  if (requestType === 'leave') {
    const facts: Array<{ label: string; value: string }> = []
    const push = (label: string, keys: string[]) => {
      const value = firstPayloadText(payload, keys)
      if (value) facts.push({ label, value })
    }
    push('Leave type', ['LeaveType', 'Leave_Type'])
    push('Start date', ['StartDate', 'Start_Date'])
    push('End date', ['EndDate', 'End_Date'])
    push('Return date', ['ReturnDate', 'Return_Date'])
    push('Reliever', ['RelieverName', 'Reliever_Name', 'Reliever'])
    push('Application reason', ['reason', 'Reasonforleave', 'Reason_for_leave'])
    push('Current leave balance', ['CurrentLeaveBalance', 'Current_Leave_Balance'])
    push('Earned leave days', ['EarnedLeaveDays', 'Earned_Leave_Days'])
    return facts
  }
  if (requestType === 'employeeExit' || requestType === 'hrServiceLetter') {
    const facts = Array.isArray(payload.detailFacts)
      ? (payload.detailFacts as Array<{ label?: unknown; value?: unknown }>)
      : []
    return facts
      .map((fact) => ({ label: String(fact.label ?? '').trim(), value: String(fact.value ?? '').trim() }))
      .filter((fact) => fact.label && fact.value)
  }
  if (requestType !== 'purchaseRequisition' && requestType !== 'storeRequisition') return []
  const facts: Array<{ label: string; value: string }> = []
  const push = (label: string, keys: string[]) => {
    const value = firstPayloadText(payload, keys)
    if (value) facts.push({ label, value })
  }
  if (requestType === 'purchaseRequisition') {
    push('Required date', ['RequestedReceiptDate', 'Requested_Receipt_Date', 'OrderDate', 'Order_Date'])
    push('Department', ['Department', 'RequestingDepartment', 'ShortcutDimension2Code'])
    push('Cost center / project', ['ProjectCode', 'Project_Code'])
    push('Purchase type', ['PurchaseRequestType', 'Purchase_Request_Type'])
    push('Priority', ['Priority', 'priority'])
    push('Currency', ['CurrencyCode', 'Currency_Code'])
    push('Justification', ['Justification', 'PostingDescription', 'Posting_Description'])
  } else {
    push('Required date', ['RequiredDate', 'Required_Date', 'RequestDate'])
    push('Request type', ['StoreRequisitionType', 'Store_Requisition_Type'])
    push('Priority', ['Priority', 'priority'])
    push('Issuing store', ['IssuingStore', 'Issuing_Store'])
    push('Justification', ['Justification', 'justification', 'RequestDescription'])
  }
  return facts
}

/** Prefer stable columns for purchase/store lines instead of dumping every OData key. */
function preferredLineKeys(requestType: string | undefined, lines: Record<string, unknown>[]) {
  if (requestType === 'purchaseRequisition') {
    const preferred = [
      'type',
      'itemName',
      'description',
      'specification',
      'category',
      'quantity',
      'unitOfMeasure',
      'directUnitCost',
      'amount',
      'preferredBrandModel',
      'suggestedSupplier',
      'remarks',
      'requiredDate',
    ]
    const alwaysShow = new Set([
      'type',
      'itemName',
      'description',
      'specification',
      'quantity',
      'unitOfMeasure',
      'preferredBrandModel',
      'suggestedSupplier',
      'remarks',
    ])
    const present = preferred.filter(
      (key) => alwaysShow.has(key) || lines.some((line) => !isBlankLineValue(line[key])),
    )
    if (present.length) return present
  }
  if (requestType === 'storeRequisition') {
    const preferred = [
      'type',
      'itemNo',
      'description',
      'preferredBrandModel',
      'unitOfMeasure',
      'quantity',
      'lineAmount',
      'fulfillmentStatus',
    ]
    const present = preferred.filter((key) => lines.some((line) => !isBlankLineValue(line[key])))
    if (present.length) return present
  }
  return visibleLineKeys(lines)
}

function sumLineNumbers(lines: Record<string, unknown>[], keys: string[]) {
  return lines.reduce((total, line) => {
    for (const key of keys) {
      const value = line[key]
      if (value !== undefined && value !== null && String(value).trim() !== '') {
        return total + numericValue(value)
      }
    }
    return total
  }, 0)
}

function approvalMetric(
  requestType: string | undefined,
  amount: number,
  payload: Record<string, unknown>,
  lines: Record<string, unknown>[],
) {
  if (requestType === 'storeRequisition' || requestType === 'purchaseRequisition') {
    const quantity = sumLineNumbers(lines, [
      'quantityRequested',
      'quantity',
      'QuantityRequested',
      'Quantity_Requested',
      'Quantity',
    ])
    return { label: 'Quantity requested', value: String(quantity || amount || 0) }
  }
  if (requestType === 'leave') {
    const days = firstPayloadNumber(payload, ['daysApplied', 'DaysApplied', 'NoofDays', 'No_of_Days', 'NoOfDays'])
    return { label: 'Days requested', value: String(days || amount || 0) }
  }
  if (requestType === 'transport') {
    return { label: 'Passengers', value: String(lines.length || amount || 0) }
  }
  if (requestType === 'fuelRequest') {
    return { label: 'Quantity', value: String(amount || 0) }
  }
  if (requestType === 'employeeExit') {
    return { label: 'Stage', value: String(payload.pendingStageLabel || 'Approval') }
  }
  if (requestType === 'hrServiceLetter') {
    const loan = firstPayloadNumber(payload, ['loanAmount'])
    if (loan > 0) return { label: 'Amount', value: formatCurrency(loan) }
    return { label: 'Letter', value: String(payload.letterTypeLabel || 'HR letter') }
  }
  return { label: 'Amount', value: formatCurrency(amount) }
}

export function ApprovalDetail() {
  const { id } = useParams()
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const { employee } = useAuth()
  const { canApprove: hasApproverRole } = usePermissions()
  const [comment, setComment] = useState('')
  const [decision, setDecision] = useState<'Approved' | 'Rejected' | null>(null)
  const detail = useApprovalDetail(id ?? '')
  const approval = useApprovalDecision(id ?? '')
  const toast = useToast()
  const request = detail.data
  const applicationReason = request
    ? request.requestType === 'hrServiceLetter'
      ? ''
      : extractApplicationReason(request.payload, request.title)
    : ''
  const queueType = searchParams.get('queue')
  // Prefer the document outcome from BC. Do not force "Approved" from the queue
  // query when a later step rejected the same document.
  const displayStatus =
    request?.status === 'Rejected'
      ? 'Rejected'
      : request?.status === 'Approved'
        ? 'Approved'
        : queueType === 'approved'
          ? 'Approved'
          : queueType === 'rejected'
            ? 'Rejected'
            : request?.status
  const isReadOnly =
    displayStatus === 'Approved' ||
    displayStatus === 'Rejected' ||
    displayStatus === 'Cancelled'
  const isNotMaker = request && employee ? isMakerAllowedToApprove(request.makerEmployeeNo, employee.employeeNo) : false
  const assignedPendingApprover = Boolean(
    request &&
      employee &&
      (request.approvalSteps ?? []).some((step) => {
        if (step.status !== 'Pending Approval') return false
        const identities = [employee.userID, employee.employeeNo, employee.displayName]
          .map((value) => String(value ?? '').trim().toLowerCase())
          .filter(Boolean)
        const actor = [step.actorEmployeeNo, step.actorName]
          .map((value) => String(value ?? '').trim().toLowerCase())
          .filter(Boolean)
        return actor.some((id) => identities.includes(id))
      }),
  )
  const canApprove = (hasApproverRole || assignedPendingApprover) && isNotMaker && !isReadOnly
  const payload = request?.payload ?? {}
  const lines = Array.isArray(payload.lines)
    ? (payload.lines as Record<string, unknown>[])
    : []
  const lineKeys = preferredLineKeys(request?.requestType, lines)
  const metric = request ? approvalMetric(request.requestType, request.amount, payload, lines) : null
  const headerFacts = request ? approvalHeaderFacts(request.requestType, payload) : []

  useEffect(() => {
    // The requester's application reason is source-document context, not an
    // approver decision note. Starting blank prevents a rejection from being
    // recorded with the requester's own reason instead of a new explanation.
    setComment('')
  }, [request?.id])

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

  return (
    <PageWrapper
      title={isReadOnly ? 'Document View' : 'Approval Detail'}
      description={
        isReadOnly
          ? 'Review the submitted document and its approval workflow.'
          : 'Review source document, maker/checker audit trail, and approve or reject according to ERP workflow.'
      }
      actions={
        <Button asChild variant="outline">
          <Link to={backLink}>Back to queue</Link>
        </Button>
      }
    >
      {detail.isLoading || !request ? (
        <Skeleton className="h-96" />
      ) : (
        <div className="grid items-start gap-5 xl:grid-cols-[minmax(0,1fr)_340px]">
          <Card className="min-w-0 overflow-hidden">
            <CardHeader className="border-b border-slate-200/80 bg-gradient-to-r from-slate-50 to-white">
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <CardTitle>{request.title}</CardTitle>
                  <CardDescription>{request.requestNo}</CardDescription>
                </div>
                <StatusBadge status={displayStatus ?? request.status} />
              </div>
            </CardHeader>
            <CardContent className="space-y-6 p-5 sm:p-6">
              <div className="grid gap-3 md:grid-cols-3">
                <div className="rounded-lg border border-slate-200 bg-white p-3.5 shadow-sm">
                  <p className="text-[11px] font-semibold uppercase tracking-wide text-slate-500">Maker</p>
                  <p className="mt-1 font-semibold text-slate-900">{request.makerName}</p>
                </div>
                <div className="rounded-lg border border-slate-200 bg-white p-3.5 shadow-sm">
                  <p className="text-[11px] font-semibold uppercase tracking-wide text-slate-500">{metric?.label ?? 'Amount'}</p>
                  <p className="mt-1 font-semibold text-slate-900">{metric?.value ?? formatCurrency(request.amount)}</p>
                </div>
                <div className="rounded-lg border border-slate-200 bg-white p-3.5 shadow-sm">
                  <p className="text-[11px] font-semibold uppercase tracking-wide text-slate-500">Submitted</p>
                  <p className="mt-1 font-semibold text-slate-900">{formatDateTime(request.submittedAt)}</p>
                </div>
              </div>

              {request.requestType === 'employeeExit' || request.requestType === 'hrServiceLetter' ? (
                <div className="rounded-xl border border-emerald-200 bg-emerald-50/70 p-3 text-sm text-emerald-900">
                  {request.requestType === 'employeeExit'
                    ? `Hijra-style routing: Immediate Supervisor, then HR.${
                        payload.pendingStageLabel
                          ? ` This document is waiting on ${String(payload.pendingStageLabel)}.`
                          : ''
                      }`
                    : 'Hijra-style routing: submitted directly to HR. There is no supervisor step — record remarks and approve or reject.'}
                </div>
              ) : null}

              {applicationReason ? (
                <div className="rounded-lg border border-[var(--portal-navy)]/15 bg-[var(--portal-navy)]/[0.035] p-4">
                  <p className="text-[11px] font-semibold uppercase tracking-wide text-[var(--portal-navy-dark)]">Application reason</p>
                  <p className="mt-1 whitespace-pre-wrap text-sm text-slate-900">{applicationReason}</p>
                </div>
              ) : null}

              {headerFacts.length ? (
                <div className="border-t border-slate-200 pt-4">
                  <p className="mb-2 text-sm font-semibold text-slate-900">Request details</p>
                  <dl className="grid gap-3 sm:grid-cols-2">
                    {headerFacts.map((fact, index) => (
                      <div key={`${fact.label}-${index}`} className="rounded-md bg-slate-50 p-3">
                        <dt className="text-xs uppercase text-slate-500">{fact.label}</dt>
                        <dd className="mt-1 whitespace-pre-wrap text-sm font-medium text-slate-900">{fact.value}</dd>
                      </div>
                    ))}
                  </dl>
                </div>
              ) : null}

              {displayStatus === 'Rejected' &&
              (request.approvalSteps ?? []).some((step) => step.status === 'Approved') ? (
                <div className="rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-900">
                  This document was <strong>Rejected</strong> after one or more earlier approvals. Check the
                  Maker/checker timeline for the rejecting step and comment.
                </div>
              ) : null}

              {queueType && displayStatus !== request.status ? (
                <div className="rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-800">
                  The approval entry is <strong>{displayStatus}</strong>; the current Business Central source document is <strong>{request.status}</strong>.
                </div>
              ) : null}

              {payload.sourceDocumentAvailable === false &&
              request.requestType !== 'leave' &&
              payload.hideDocumentLines !== true ? (
                <div className="flex items-start gap-3 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
                  <AlertTriangle className="mt-0.5 h-5 w-5 shrink-0" />
                  <div>
                    <p className="font-semibold">Petty cash / source header could not be read from Business Central</p>
                    <p className="mt-1 text-amber-800">
                      {isReadOnly
                        ? 'The approval itself is valid. This screen is showing the approval entry because the published Payments Header query did not return this document number after it was approved.'
                        : 'The approval entry is still valid. You can Approve or Reject. Header and lines will appear once Business Central returns the source document.'}
                    </p>
                  </div>
                </div>
              ) : null}

              {lines.length && lineKeys.length ? (
                <div className="border-t border-slate-200 pt-4">
                  <p className="mb-2 text-sm font-semibold text-slate-900">Document lines</p>
                  <div className="overflow-x-auto rounded-lg border border-slate-200 shadow-sm">
                    <table className="min-w-full border-collapse text-left text-sm">
                      <thead className="border-b border-slate-200 bg-slate-50/90 text-xs uppercase tracking-wide text-slate-500">
                        <tr>
                          {lineKeys.map((key) => (
                            <th
                              key={key}
                              className={`whitespace-nowrap px-3 py-2 font-semibold align-middle ${
                                lines.every((line) => isBlankLineValue(line[key]) || isNumericLineValue(line[key])) ? 'text-right' : 'text-left'
                              }`}
                            >
                              {lineFieldLabel(key)}
                            </th>
                          ))}
                        </tr>
                      </thead>
                      <tbody>
                        {lines.map((line, index) => (
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
                      </tbody>
                    </table>
                  </div>
                </div>
              ) : request.requestType === 'leave' ||
                payload.sourceDocumentAvailable === false ||
                payload.hideDocumentLines === true ? null : (
                <div className="rounded-md border border-slate-200 bg-slate-50 p-3 text-sm text-slate-600">
                  No document lines were returned from Business Central for this request.
                </div>
              )}

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
                  <div className="border-t border-slate-200 pt-5">
                    <p className="mb-2 text-sm font-semibold text-slate-900">
                      {request.requestType === 'hrServiceLetter' ? 'HR remarks (required)' : 'Approval comment'}
                    </p>
                    <Textarea
                      value={comment}
                      onChange={(event) => setComment(event.target.value)}
                      placeholder={
                        request.requestType === 'hrServiceLetter'
                          ? 'Enter HR remarks (shown to the employee)'
                          : request.requestType === 'employeeExit'
                            ? 'Add a note. A reason is required to reject.'
                            : 'Add an approval note. A new reason is required to reject.'
                      }
                    />
                    {request.requestType === 'hrServiceLetter' ? (
                      <p className="mt-2 text-xs text-slate-500">
                        Remarks are required for both approve and reject, the same as Hijra letter processing.
                      </p>
                    ) : request.requestType === 'employeeExit' ? (
                      <p className="mt-2 text-xs text-slate-500">
                        Transfer and resignation go to the Immediate Supervisor first, then HR. Exit forms do not
                        appear here.
                      </p>
                    ) : (
                      <p className="mt-2 text-xs text-slate-500">
                        A rejection reason is required and will be visible to the requester in Approval History.
                      </p>
                    )}
                  </div>

                  {!canApprove ? (
                    <div className="rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-800">
                      {!hasApproverRole && !assignedPendingApprover
                        ? 'Your role does not have approval authority for this document.'
                        : 'Maker cannot approve own request.'}
                    </div>
                  ) : null}

                  <div className="flex flex-wrap gap-2 border-t border-slate-200 pt-5">
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

          <Card className="min-w-0 overflow-hidden xl:sticky xl:top-5">
            <CardHeader className="border-b border-slate-200/80 bg-gradient-to-r from-slate-50 to-white">
              <CardTitle>Maker/checker timeline</CardTitle>
              <CardDescription>Audit trail with timestamps.</CardDescription>
            </CardHeader>
            <CardContent className="p-5">
              <ApprovalTimeline steps={request.approvalSteps} />
            </CardContent>
          </Card>
        </div>
      )}

      <ConfirmDialog
        open={Boolean(decision)}
        title={`${decision ?? 'Submit'} request`}
        description="This action writes an approval decision against the source document and cannot be performed by the maker."
        confirmLabel={decision ?? 'Submit'}
        onCancel={() => setDecision(null)}
        onConfirm={() => {
          const chosen = decision
          if (!chosen) {
            setDecision(null)
            return
          }
          if (chosen === 'Rejected' && comment.trim().length < 3) {
            toast.error('Enter a reason of at least 3 characters to reject or return this request.')
            setDecision(null)
            return
          }
          const note = comment.trim()
          if (request?.requestType === 'hrServiceLetter' && note.length < 3) {
            toast.error('Enter HR remarks of at least 3 characters before recording the decision.')
            setDecision(null)
            return
          }
          approval.mutate(
            { decision: chosen, comment: note },
            {
              // Leave the detail page once BC has recorded the decision: the
              // document drops out of the pending-approval query straight
              // away, so staying here renders an unloadable blank screen.
              onSuccess: () => {
                navigate(chosen === 'Approved' ? '/approvals/approved' : '/approvals/rejected', {
                  replace: true,
                })
              },
            },
          )
          setDecision(null)
        }}
      />
    </PageWrapper>
  )
}
