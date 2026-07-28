import { useEffect, useState } from 'react'
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
import { Textarea } from '@/components/ui/textarea'
import { Skeleton } from '@/components/ui/skeleton'
import { useApprovalDecision, useApprovalDetail } from '@/hooks/useApprovals'
import { useAuth } from '@/hooks/useAuth'
import { usePermissions } from '@/hooks/usePermissions'
import { approvalDetailFields } from '@/data/approvalDetailFields'
import { extractApplicationReason } from '@/utils/applicationReason'
import { formatCurrency, formatDate, formatDateTime } from '@/utils/formatters'
import { isMakerAllowedToApprove } from '@/utils/validators'
import { matchesSearchQuery } from '@/utils/tableSearch'

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

function lineFieldLabel(key: string) {
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
    return value
  }
  return undefined
}

function formatConfiguredDetail(value: unknown, field: DetailFieldConfig) {
  if (field.format === 'status') return <StatusBadge status={String(value ?? '—')} />
  if (field.format === 'date') return formatDate(value === undefined ? undefined : String(value))
  if (field.format === 'currency') return formatCurrency(Number(value ?? 0))
  if (field.format === 'percentage') return `${Number(value ?? 0)}%`
  if (field.format === 'returned') {
    const returned = value === true || ['true', 'yes', '1'].includes(String(value ?? '').toLowerCase())
    return returned ? 'Returned' : 'Not Returned'
  }
  return String(value ?? '—')
}

export function ApprovalDetail() {
  const { id } = useParams()
  const [searchParams] = useSearchParams()
  const { employee } = useAuth()
  const { canApprove: hasApproverRole } = usePermissions()
  const [comment, setComment] = useState('')
  const [decision, setDecision] = useState<'Approved' | 'Rejected' | null>(null)
  const [lineSearch, setLineSearch] = useState('')
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
    .filter((detail) => detail.value !== undefined)
  const isLeaveRequest = request?.requestType === 'leave'
  const requestMetricLabel = isLeaveRequest ? 'Leave quantity' : 'Amount / quantity'
  const requestMetricValue = isLeaveRequest
    ? `${request?.amount ?? 0} ${Number(request?.amount ?? 0) === 1 ? 'day' : 'days'}`
    : formatCurrency(request?.amount ?? 0)

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

              {lines.length && lineKeys.length ? (
                <div className="border-t border-slate-200 pt-4">
                  <p className="mb-2 text-sm font-semibold text-slate-900">Document lines</p>
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
                              {lineFieldLabel(key)}
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
