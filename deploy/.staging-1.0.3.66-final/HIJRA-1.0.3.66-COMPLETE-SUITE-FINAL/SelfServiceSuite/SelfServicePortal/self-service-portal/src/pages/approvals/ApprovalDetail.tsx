import { useEffect, useState } from 'react'
import { Link, Navigate, useParams, useSearchParams } from 'react-router-dom'
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
import { approvalDetailFields } from '@/data/approvalDetailFields'
import type { DetailFieldConfig } from '@/components/shared/RequestFormPage'
import { extractApplicationReason } from '@/utils/applicationReason'
import { formatCurrency, formatDateTime } from '@/utils/formatters'
import { formatLeaveTypeLabel } from '@/utils/leaveType'
import { isMakerAllowedToApprove } from '@/utils/validators'

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

function formatTransportType(value: unknown) {
  const text = String(value ?? '').trim()
  if (!text) return '—'
  if (text.toLowerCase() === 'trip') return 'Field Trip'
  return text
}

function getPathValue(source: unknown, path: string) {
  return path.split('.').reduce<unknown>((current, part) => {
    if (!current || typeof current !== 'object') return undefined
    if (Array.isArray(current)) return current[Number(part)]
    return (current as Record<string, unknown>)[part]
  }, source)
}

function formatApprovalDetailValue(
  requestType: string,
  field: DetailFieldConfig,
  value: unknown,
) {
  if (value === undefined || value === null || String(value).trim() === '') return '—'
  if (field.label === 'Request Type' && requestType === 'transport') {
    return formatTransportType(value)
  }
  if (field.format === 'currency') return formatCurrency(Number(value))
  if (field.format === 'date') {
    const text = String(value).trim()
    if (!text || ZERO_DATE.test(text)) return '—'
    const parsed = new Date(text)
    if (!Number.isNaN(parsed.getTime())) {
      return parsed.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' })
    }
  }
  if (field.format === 'status') return String(value)
  return String(value)
}

function resolveApprovalDetailFields(requestType: string, source: unknown) {
  const fields = approvalDetailFields[requestType]
  if (!fields?.length) return []
  return fields
    .map((field) => {
      let value: unknown
      for (const path of field.paths) {
        value = getPathValue(source, path)
        if (value !== undefined && value !== null && String(value).trim() !== '') break
      }
      return {
        label: field.label,
        value: formatApprovalDetailValue(requestType, field, value),
      }
    })
    .filter((entry) => entry.value !== '—')
}

function payloadValue(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = payload[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return value
  }
  return undefined
}

function formatLeaveDays(value: unknown) {
  const days = typeof value === 'number' ? value : Number(String(value ?? '').trim())
  if (!Number.isFinite(days)) return '—'

  const formatted = days.toLocaleString('en-US', { maximumFractionDigits: 2 })
  return `${formatted} ${days === 1 ? 'day' : 'days'}`
}

export function ApprovalDetail() {
  const { id } = useParams()
  const [searchParams] = useSearchParams()
  const { employee } = useAuth()
  const { canApprove: hasApproverRole } = usePermissions()
  const [comment, setComment] = useState('')
  const [decision, setDecision] = useState<'Approved' | 'Rejected' | null>(null)
  const detail = useApprovalDetail(id ?? '')
  const approval = useApprovalDecision(id ?? '')
  const request = detail.data
  const applicationReason = request ? extractApplicationReason(request.payload, request.title) : ''
  const queueType = searchParams.get('queue')
  const displayStatus = queueType === 'approved'
    ? 'Approved'
    : queueType === 'rejected'
      ? 'Rejected'
      : request?.status
  const isReadOnly =
    displayStatus === 'Approved' ||
    displayStatus === 'Rejected' ||
    displayStatus === 'Cancelled'
  const isNotMaker = request && employee ? isMakerAllowedToApprove(request.makerEmployeeNo, employee.employeeNo) : false
  const canApprove = hasApproverRole && isNotMaker && !isReadOnly
  const payload = request?.payload ?? {}
  const leaveDaysApplied = payloadValue(payload, [
    'DaysApplied',
    'Days_Applied',
    'daysApplied',
    'appliedDays',
    'NoofDays',
    'No_of_Days',
  ])
  const leaveType = formatLeaveTypeLabel(payload)
  const trainingNeed = payloadValue(payload, [
    'otherTrainingName',
    'trainingNeed',
    'CourseTitle',
    'Course_Title',
  ])
  const trainingDuration = payloadValue(payload, ['durationDays', 'Duration'])
  const trainingPeriodStart = payloadValue(payload, ['periodStart', 'PeriodStart', 'Period_Start'])
  const trainingPeriodEnd = payloadValue(payload, ['periodEnd', 'PeriodEnd', 'Period_End'])
  const trainingPeriod =
    trainingPeriodStart && trainingPeriodEnd
      ? `${trainingPeriodStart} — ${trainingPeriodEnd}`
      : trainingPeriodStart || trainingPeriodEnd || ''
  const trainingAssessmentFields = ([
    ['Department', payloadValue(payload, ['department', 'Department'])],
    ['Training Period', trainingPeriod],
    ['Training Type', payloadValue(payload, ['trainingType'])],
    ['Target Group', payloadValue(payload, ['targetGroup'])],
    ['No. of Participants', payloadValue(payload, ['participants'])],
    ['Quarter', payloadValue(payload, ['quarter'])],
    ['Priority', payloadValue(payload, ['priority'])],
    ['Recommended Vendor / Provider', payloadValue(payload, ['vendor'])],
    ['Estimated Budget', payloadValue(payload, ['estimatedBudget'])],
    ['Remark', payloadValue(payload, ['remark'])],
    ['Immediate Supervisor', payloadValue(payload, ['supervisorUserId'])],
  ] satisfies Array<[string, unknown]>).filter(
    (entry) => entry[1] !== undefined && String(entry[1]).trim() !== '' && entry[1] !== '—',
  )
  const lines = Array.isArray(payload.lines)
    ? (payload.lines as Record<string, unknown>[])
    : []
  const lineKeys = visibleLineKeys(lines)
  const approvalHeaderFields = request
    ? resolveApprovalDetailFields(request.requestType, { request, payload })
    : []

  useEffect(() => {
    if (request && applicationReason) {
      setComment(applicationReason)
    }
  }, [request?.id, applicationReason])

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
              <div className={`grid gap-4 ${request.requestType === 'leave' ? 'sm:grid-cols-2' : 'md:grid-cols-3'}`}>
                <div className="rounded-md bg-slate-50 p-3">
                  <p className="text-xs uppercase text-slate-500">Maker</p>
                  <p className="font-medium text-slate-900">{request.makerName}</p>
                </div>
                {request.requestType === 'leave' ? (
                  <div className="rounded-md bg-slate-50 p-3">
                    <p className="text-xs uppercase text-slate-500">Leave Type</p>
                    <p className="font-medium text-slate-900">{leaveType}</p>
                  </div>
                ) : null}
                {request.requestType === 'training' ? (
                  <div className="rounded-md bg-slate-50 p-3">
                    <p className="text-xs uppercase text-slate-500">Training Need</p>
                    <p className="font-medium text-slate-900">{String(trainingNeed ?? '—')}</p>
                  </div>
                ) : null}
                {request.requestType !== 'training' ? (
                  <div className="rounded-md bg-slate-50 p-3">
                  <p className="text-xs uppercase text-slate-500">
                    {request.requestType === 'leave' ? 'Leave Days Applied' : 'Amount / quantity'}
                  </p>
                  <p className="font-medium text-slate-900">
                    {request.requestType === 'leave'
                      ? formatLeaveDays(leaveDaysApplied)
                      : formatCurrency(request.amount)}
                  </p>
                  </div>
                ) : (
                  <div className="rounded-md bg-slate-50 p-3">
                    <p className="text-xs uppercase text-slate-500">Duration</p>
                    <p className="font-medium text-slate-900">{formatLeaveDays(trainingDuration)}</p>
                  </div>
                )}
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

              {request.requestType === 'training' && trainingAssessmentFields.length ? (
                <div className="grid gap-3 rounded-md border border-slate-200 bg-slate-50 p-4 sm:grid-cols-2">
                  {trainingAssessmentFields.map(([label, value]) => (
                    <div key={String(label)}>
                      <p className="text-xs uppercase text-slate-500">{label}</p>
                      <p className="mt-1 text-sm font-medium text-slate-900">{String(value)}</p>
                    </div>
                  ))}
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

              {approvalHeaderFields.length ? (
                <div className="grid gap-3 rounded-md border border-slate-200 bg-slate-50 p-4 sm:grid-cols-2">
                  {approvalHeaderFields.map((field) => (
                    <div key={field.label}>
                      <p className="text-xs uppercase text-slate-500">{field.label}</p>
                      <p className="mt-1 text-sm font-medium text-slate-900">{field.value}</p>
                    </div>
                  ))}
                </div>
              ) : null}

              {lines.length && lineKeys.length ? (
                <div className="border-t border-slate-200 pt-4">
                  <p className="mb-2 text-sm font-semibold text-slate-900">Document lines</p>
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
                    <p className="mb-2 text-sm font-semibold text-slate-900">Approval comment</p>
                    <Textarea
                      value={comment}
                      onChange={(event) => setComment(event.target.value)}
                      placeholder="Add approval note (pre-filled from application reason)"
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
        description="This action writes an approval decision against the source document and cannot be performed by the maker."
        confirmLabel={decision ?? 'Submit'}
        onCancel={() => setDecision(null)}
        onConfirm={() => {
          if (decision) approval.mutate({ decision, comment: comment.trim() || applicationReason })
          setDecision(null)
        }}
      />
    </PageWrapper>
  )
}
