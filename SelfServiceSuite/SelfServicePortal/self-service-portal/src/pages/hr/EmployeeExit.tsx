import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { format, parseISO } from 'date-fns'
import { ArrowLeft, CheckCircle2, FileText, RefreshCw, XCircle } from 'lucide-react'
import { useMemo, useState } from 'react'
import { Navigate, useNavigate, useParams } from 'react-router-dom'
import {
  cancelEmployeeExitRequest,
  fetchEmployeeExitRequests,
  requestEmployeeExitCancellation,
  submitEmployeeExitRequest,
  type EmployeeExitRequest,
} from '@/api/endpoints/employeeExit'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { PortalFormCard } from '@/components/shared/PortalFormCard'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import {
  EMPLOYEE_EXIT_FIELDS,
  EMPLOYEE_EXIT_TYPES,
  isEmployeeExitRequestType,
  type EmployeeExitFieldConfig,
  type EmployeeExitRequestType,
} from '@/data/employeeExit'
import { fetchRelievers } from '@/api/endpoints/leave'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { cn } from '@/lib/utils'

const QUERY_KEY = ['hr', 'employee-exit'] as const

function formatPretty(iso: string) {
  try {
    return format(parseISO(iso), 'd MMM yyyy, h:mm a')
  } catch {
    return iso
  }
}

function detailLabel(requestType: EmployeeExitRequestType, key: string) {
  return EMPLOYEE_EXIT_FIELDS[requestType].find((field) => field.name === key)?.label
    ?? key.replace(/([A-Z])/g, ' $1').replace(/^./, (character) => character.toUpperCase())
}

function displayRequestStatus(request: EmployeeExitRequest) {
  if (
    request.status === 'Pending Approval'
    && ['transfer', 'resignation'].includes(request.requestType)
  ) {
    return 'Pending Supervisor Approval'
  }
  return request.status
}

function localToday() {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

function emptyDetails(requestType: EmployeeExitRequestType | '') {
  if (!requestType) return {}
  return Object.fromEntries(EMPLOYEE_EXIT_FIELDS[requestType].map((field) => [field.name, '']))
}

/** Multiselect values are stored as a comma-joined string (option labels contain no commas). */
function splitMultiValue(value: string | undefined) {
  return (value ?? '')
    .split(',')
    .map((part) => part.trim())
    .filter(Boolean)
}

function fieldIsVisible(field: EmployeeExitFieldConfig, details: Record<string, string>) {
  if (!field.showWhen) return true
  const current = details[field.showWhen.field] ?? ''
  switch (field.showWhen.mode) {
    case 'includes':
      return splitMultiValue(current).includes(field.showWhen.value ?? '')
    case 'multiple':
      return splitMultiValue(current).length >= 2
    default:
      return current === field.showWhen.value
  }
}

function WorkflowProgress({ request }: { request: EmployeeExitRequest }) {
  const cancellationFlow = ['Cancellation Pending Approval', 'Cancelled'].includes(request.status)

  // Per ABH Partners' SSP template the Employee Exit form goes directly to HR for information only.
  if (request.requestType === 'exit-interview' && !cancellationFlow) {
    return (
      <div className="rounded-2xl border border-emerald-200 bg-emerald-50/70 p-3 text-sm text-emerald-800">
        Submitted directly to HR for information purposes only — no approval action is required.
      </div>
    )
  }

  // Transfer / Resignation: two approval stages — immediate supervisor first, then HR.
  const rejectedAtSupervisor = request.status === 'Rejected' && request.rejectedAtStage === 'Immediate Supervisor'
  const rejectedAtHr = request.status === 'Rejected' && request.rejectedAtStage === 'HR'
  const supervisorDone = ['Pending HR Approval', 'Approved', 'Completed'].includes(request.status)
    || rejectedAtSupervisor
    || rejectedAtHr
  const hrDone = ['Approved', 'Completed'].includes(request.status) || rejectedAtHr
  const steps = [
    {
      label: cancellationFlow ? 'Cancellation recorded' : 'Request recorded',
      done: true,
      detail: 'Submitted from SSP',
    },
    {
      label: 'Immediate Supervisor',
      done: supervisorDone,
      detail: supervisorDone
        ? `${rejectedAtSupervisor ? 'Rejected' : 'Approved'} by ${request.supervisorDecisionBy || request.supervisorUserId || 'Supervisor'}`
        : `Awaiting ${request.supervisorUserId || 'assigned supervisor'}`,
    },
    {
      label: 'HR approval',
      done: hrDone,
      detail: rejectedAtSupervisor
        ? 'Not reached'
        : hrDone
          ? `${rejectedAtHr ? 'Rejected' : 'Approved'} by ${request.hrDecisionBy || request.hrApproverUserId || 'HR'}`
          : supervisorDone
            ? `Awaiting ${request.hrApproverUserId || 'HR'}`
            : 'Starts after supervisor approval',
    },
  ]
  return (
    <div className="grid gap-2 rounded-2xl border border-emerald-200 bg-emerald-50/70 p-3 sm:grid-cols-3">
      {steps.map((step, index) => (
        <div key={step.label} className="flex items-center gap-3 rounded-xl border border-white bg-white/90 p-3">
          <span className={cn(
            'flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-sm font-semibold',
            step.done ? 'bg-emerald-100 text-emerald-700' : 'bg-blue-100 text-blue-700',
          )}>
            {step.done ? <CheckCircle2 className="h-4 w-4" /> : index + 1}
          </span>
          <div>
            <p className="text-sm font-semibold text-slate-900">{step.label}</p>
            <p className="text-xs text-slate-500">{step.detail}</p>
          </div>
        </div>
      ))}
    </div>
  )
}

function FinalDecisionNotice({ request }: { request: EmployeeExitRequest }) {
  if (!['transfer', 'resignation'].includes(request.requestType)) return null
  if (!['Approved', 'Rejected'].includes(request.status)) return null

  const approved = request.status === 'Approved'
  const decisionBy = approved
    ? request.hrDecisionBy || request.hrApproverUserId || 'HR'
    : request.rejectedAtStage === 'Immediate Supervisor'
      ? request.supervisorDecisionBy || request.supervisorUserId || 'Immediate Supervisor'
      : request.hrDecisionBy || request.hrApproverUserId || 'HR'
  const decisionAt = approved
    ? request.hrDecisionAt
    : request.rejectedAtStage === 'Immediate Supervisor'
      ? request.supervisorDecisionAt
      : request.hrDecisionAt

  return (
    <div className={cn(
      'rounded-xl border px-4 py-3 text-sm',
      approved
        ? 'border-emerald-200 bg-emerald-50 text-emerald-900'
        : 'border-red-200 bg-red-50 text-red-900',
    )}>
      <p className="font-semibold">Final status: {request.status}</p>
      <p className="mt-1 text-xs">
        {approved ? 'Approved by HR' : `Rejected at ${request.rejectedAtStage || 'approval'} stage`}
        {' '}by {decisionBy}{decisionAt ? ` on ${formatPretty(decisionAt)}` : ''}.
      </p>
      {!approved && request.decisionRemarks?.trim() ? (
        <p className="mt-2 rounded-md border-l-4 border-red-500 bg-white/70 px-3 py-2 text-sm">
          <span className="font-semibold">Rejection reason: </span>
          {request.decisionRemarks}
        </p>
      ) : null}
    </div>
  )
}

export function EmployeeExit() {
  const { requestType } = useParams<{ requestType?: string }>()
  if (requestType && !isEmployeeExitRequestType(requestType)) {
    return <Navigate to="/hr/employee-exit" replace />
  }
  const initialRequestType = isEmployeeExitRequestType(requestType) ? requestType : ''
  return <EmployeeExitPage key={initialRequestType || 'all-exit-requests'} initialRequestType={initialRequestType} />
}

function EmployeeExitPage({ initialRequestType }: { initialRequestType: EmployeeExitRequestType | '' }) {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const navigate = useNavigate()
  const [mode, setMode] = useState<'list' | 'create' | 'detail'>(initialRequestType ? 'create' : 'list')
  const [requestType, setRequestType] = useState<EmployeeExitRequestType | ''>(initialRequestType)
  const [details, setDetails] = useState<Record<string, string>>(emptyDetails(initialRequestType))
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [formError, setFormError] = useState<string | null>(null)
  const [cancellationReason, setCancellationReason] = useState('')
  const [showCancellation, setShowCancellation] = useState(false)

  // Employee directory that backs the "immediate supervisor" dropdown on the exit-interview form.
  const employeesQuery = useQuery({
    queryKey: ['exit', 'employee-directory'],
    queryFn: fetchRelievers,
  })
  const departments = useLookupOptions('departments')
  const divisions = useLookupOptions('divisions')

  const listQuery = useQuery({
    queryKey: QUERY_KEY,
    queryFn: fetchEmployeeExitRequests,
    // Stay in step with Business Central — re-pull when the tab regains focus or the connection
    // recovers, so HR approvals/rejections in BC appear without a manual reload.
    refetchOnWindowFocus: true,
    refetchOnReconnect: true,
    refetchInterval: 15_000,
    staleTime: 15_000,
  })
  const rows = useMemo(() => listQuery.data ?? [], [listQuery.data])
  const selected = useMemo(() => rows.find((row) => row.id === selectedId) ?? null, [rows, selectedId])

  const submitMutation = useMutation({
    mutationFn: submitEmployeeExitRequest,
    onSuccess: (request) => {
      queryClient.setQueryData<EmployeeExitRequest[]>(QUERY_KEY, (current = []) => [
        request,
        ...current.filter((row) => row.id !== request.id),
      ])
      void queryClient.invalidateQueries({ queryKey: QUERY_KEY })
      setSelectedId(request.id)
      setMode('detail')
      setRequestType('')
      setDetails({})
      setFormError(null)
      toast.success(
        request.requestType === 'transfer'
          ? 'Employee Transfer submitted'
          : request.requestType === 'resignation'
            ? 'Employee Resignation submitted'
            : 'Employee Exit form submitted to HR',
        request.requestType === 'exit-interview'
          ? `${request.requestNo} was sent directly to HR for information purposes only.`
          : `${request.requestNo} was created in Business Central and sent to your immediate supervisor for approval.`,
      )
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : 'The request could not be submitted.'
      setFormError(message)
      toast.error('Submission failed', message)
    },
  })

  const cancellationMutation = useMutation({
    mutationFn: ({ id, reason }: { id: string; reason: string }) =>
      requestEmployeeExitCancellation(id, reason),
    onSuccess: (request) => {
      queryClient.setQueryData<EmployeeExitRequest[]>(QUERY_KEY, (current = []) =>
        current.map((row) => (row.id === request.id ? request : row)),
      )
      void queryClient.invalidateQueries({ queryKey: QUERY_KEY })
      setCancellationReason('')
      setShowCancellation(false)
      toast.info('Cancellation submitted', 'The cancellation request was sent through Business Central approval.')
    },
    onError: (error) => {
      toast.error(
        'Cancellation request failed',
        error instanceof Error ? error.message : 'Please try again.',
      )
    },
  })

  const withdrawMutation = useMutation({
    mutationFn: (id: string) => cancelEmployeeExitRequest(id),
    onSuccess: (request) => {
      queryClient.setQueryData<EmployeeExitRequest[]>(QUERY_KEY, (current = []) =>
        current.map((row) => (row.id === request.id ? request : row)),
      )
      void queryClient.invalidateQueries({ queryKey: QUERY_KEY })
      toast.success('Request withdrawn', 'You can now raise a new request of this type.')
    },
    onError: (error) => {
      toast.error(
        'Withdrawal failed',
        error instanceof Error ? error.message : 'Please try again.',
      )
    },
  })

  const withdrawRequest = (id: string) => {
    if (withdrawMutation.isPending) return
    void confirm({
      title: 'Withdraw this request?',
      message:
        'The request will be cancelled and removed from HR review. You can submit a new one afterwards.',
      confirmLabel: 'Withdraw request',
      cancelLabel: 'Keep request',
      tone: 'danger',
    }).then((ok) => {
      if (ok) withdrawMutation.mutate(id)
    })
  }

  const columns: DataTableColumn<EmployeeExitRequest>[] = [
    { id: 'no', header: 'Request No.', cell: (row) => row.requestNo },
    { id: 'type', header: 'Request type', cell: (row) => row.requestTypeLabel },
    { id: 'submitted', header: 'Submitted', cell: (row) => formatPretty(row.submittedAt) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={displayRequestStatus(row)} /> },
  ]

  const showList = () => {
    navigate('/hr/employee-exit')
    setMode('list')
    setRequestType('')
    setDetails({})
    setSelectedId(null)
    setFormError(null)
    setShowCancellation(false)
    setCancellationReason('')
  }

  const startCreate = () => {
    navigate('/hr/employee-exit')
    setMode('create')
    setRequestType('')
    setDetails({})
    setSelectedId(null)
    setFormError(null)
  }

  const selectRequestType = (value: EmployeeExitRequestType) => {
    navigate(`/hr/employee-exit/${value}`)
    setRequestType(value)
    setDetails(emptyDetails(value))
    setMode('create')
    setFormError(null)
    setSelectedId(null)
  }

  const updateDetail = (name: string, value: string) => {
    setDetails((current) => ({ ...current, [name]: value }))
  }

  const toggleMultiValue = (field: EmployeeExitFieldConfig, option: string) => {
    const selected = splitMultiValue(details[field.name])
    const next = selected.includes(option)
      ? selected.filter((item) => item !== option)
      : [...selected, option]
    // Join in the option order defined by the form so the stored value is stable.
    const ordered = (field.options ?? [])
      .map((item) => item.value)
      .filter((value) => next.includes(value))
    updateDetail(field.name, ordered.join(', '))
  }

  const validateForm = () => {
    if (!requestType) {
      setFormError('Select an employee exit request type.')
      return false
    }
    const visibleFields = EMPLOYEE_EXIT_FIELDS[requestType].filter((field) => fieldIsVisible(field, details))
    const missing = visibleFields.filter((field) => field.required && !details[field.name]?.trim())
    if (missing.length > 0) {
      setFormError(`Please complete: ${missing.map((field) => field.label).join(', ')}`)
      return false
    }
    if (requestType === 'resignation' && details.noticePeriodAcknowledged !== 'Yes') {
      setFormError('You must acknowledge the contractual notice-period requirement.')
      return false
    }
    if (requestType === 'exit-interview' && details.confidentialityAcknowledged !== 'Yes') {
      setFormError('You must confirm that the Employee Exit information is accurate and may be reviewed.')
      return false
    }
    setFormError(null)
    return true
  }

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault()
    if (!validateForm() || !requestType) return
    submitMutation.mutate({ requestType, details })
  }

  const renderField = (field: EmployeeExitFieldConfig) => {
    if (!fieldIsVisible(field, details)) return null
    const value = details[field.name] ?? ''
    const selectOptions =
      field.optionsSource === 'employees'
        ? employeesQuery.data ?? []
        : field.optionsSource === 'departments'
          ? departments.options
          : field.optionsSource === 'divisions'
            ? divisions.options
            : field.options ?? []
    if (field.type === 'heading') {
      return (
        <div key={field.name} className="pt-3 sm:col-span-2">
          <h3 className="text-sm font-semibold text-[var(--portal-navy)]">{field.label}</h3>
          <div className="mt-1 h-px bg-slate-200" />
        </div>
      )
    }
    return (
      <div key={field.name} className="space-y-1.5">
        <Label htmlFor={field.name}>
          {field.label}
          {field.required ? <span className="text-red-500"> *</span> : null}
        </Label>
        {field.type === 'multiselect' ? (
          <div className="grid gap-2 rounded-xl border border-slate-200 bg-slate-50/60 p-3 sm:grid-cols-2">
            {(field.options ?? []).map((option) => {
              const checked = splitMultiValue(value).includes(option.value)
              return (
                <label
                  key={option.value}
                  className={cn(
                    'flex cursor-pointer items-center gap-2.5 rounded-lg border px-3 py-2 text-sm transition',
                    checked
                      ? 'border-[var(--portal-orange)] bg-orange-50 font-medium text-slate-900'
                      : 'border-slate-200 bg-white text-slate-700 hover:border-slate-300',
                  )}
                >
                  <input
                    type="checkbox"
                    className="h-4 w-4 accent-[var(--portal-orange)]"
                    checked={checked}
                    onChange={() => toggleMultiValue(field, option.value)}
                  />
                  {option.label}
                </label>
              )
            })}
          </div>
        ) : field.type === 'select' ? (
          <Select
            id={field.name}
            value={value}
            options={selectOptions}
            placeholder={field.placeholder}
            onChange={(event) => updateDetail(field.name, event.target.value)}
          />
        ) : field.type === 'textarea' ? (
          <Textarea
            id={field.name}
            rows={3}
            value={value}
            required={field.required}
            maxLength={4000}
            placeholder={field.placeholder}
            onChange={(event) => updateDetail(field.name, event.target.value)}
          />
        ) : (
          <Input
            id={field.name}
            type={field.type}
            value={value}
            required={field.required}
            min={field.type === 'date' && !field.allowPast ? localToday() : undefined}
            maxLength={field.type === 'date' ? undefined : 300}
            placeholder={field.placeholder}
            onChange={(event) => updateDetail(field.name, event.target.value)}
          />
        )}
      </div>
    )
  }

  const activePageType = requestType || selected?.requestType || initialRequestType
  const pageTitle = activePageType === 'transfer'
    ? 'Employee Transfer'
    : activePageType === 'resignation'
      ? 'Employee Resignation'
      : activePageType === 'exit-interview'
        ? 'Employee Exit'
        : 'Employee Exit'
  const pageDescription = activePageType === 'transfer'
    ? 'Submit an Employee Transfer request to your Immediate Supervisor, followed by HR approval.'
    : activePageType === 'resignation'
      ? 'Submit your resignation to your Immediate Supervisor. HR receives it only after Supervisor approval, and your final status appears here after the HR decision.'
      : activePageType === 'exit-interview'
        ? 'Complete the Employee Exit form and submit it directly to HR for information purposes only. No approval is required.'
        : 'Submit transfer, resignation, and exit interview requests through Business Central.'

  return (
    <PageWrapper
      title={pageTitle}
      description={pageDescription}
      actions={
        mode === 'list' ? (
          <div className="flex items-center gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => void listQuery.refetch()}
              disabled={listQuery.isFetching}
              title="Refresh from Business Central"
            >
              <RefreshCw className={cn('mr-2 h-4 w-4', listQuery.isFetching && 'animate-spin')} />
              {listQuery.isFetching ? 'Syncing…' : 'Refresh'}
            </Button>
            <PortalNewButton label="New employee exit request" onClick={startCreate} />
          </div>
        ) : (
          <Button type="button" variant="outline" onClick={showList}>
            <ArrowLeft className="mr-2 h-4 w-4" />
            Back to list
          </Button>
        )
      }
    >
      {mode === 'list' ? (
        <div className="portal-surface-card overflow-hidden rounded-2xl border border-slate-200 bg-white">
          <div className="flex items-center justify-between gap-3 border-b border-slate-100 px-4 py-3">
            <div>
              <h2 className="text-sm font-semibold text-slate-900">My Exit Requests</h2>
              <p className="mt-0.5 text-xs text-slate-500">
                Every transfer, resignation and Employee Exit form you have submitted. Click a row for details.
              </p>
            </div>
            {rows.length > 0 ? (
              <span className="shrink-0 rounded-full bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-600">
                {rows.length} total
              </span>
            ) : null}
          </div>
          {listQuery.isError ? (
            <div className="m-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
              {listQuery.error instanceof Error ? listQuery.error.message : 'Employee exit requests could not be loaded.'}
            </div>
          ) : listQuery.isLoading ? (
            <div className="space-y-2 p-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          ) : rows.length === 0 ? (
            <div className="flex flex-col items-center justify-center gap-3 px-4 py-14 text-center">
              <span className="flex h-14 w-14 items-center justify-center rounded-full bg-orange-50 text-[var(--portal-orange)]">
                <FileText className="h-7 w-7" />
              </span>
              <div>
                <p className="text-sm font-semibold text-slate-900">No exit requests yet</p>
                <p className="mx-auto mt-1 max-w-xs text-xs text-slate-500">
                  Any transfer, resignation or Employee Exit form you submit will appear here so you can track its status.
                </p>
              </div>
              <PortalNewButton label="New employee exit request" onClick={startCreate} />
            </div>
          ) : (
            <DataTable
              columns={columns}
              rows={rows}
              getRowId={(row) => row.id}
              emptyTitle="No employee exit requests have been recorded."
              onRowClick={(row) => {
                setSelectedId(row.id)
                setMode('detail')
              }}
            />
          )}
        </div>
      ) : null}

      {mode === 'create' ? (
        <form onSubmit={handleSubmit} className="space-y-4">
          <PortalFormCard
            title={EMPLOYEE_EXIT_TYPES.find((option) => option.value === requestType)?.label ?? 'New Employee Exit Request'}
          >
            <div className="space-y-5">
              <div className="space-y-2">
                <Label>Request type</Label>
                <div className="grid gap-3 md:grid-cols-3">
                  {EMPLOYEE_EXIT_TYPES.map((option) => {
                    const Icon = option.icon
                    const active = requestType === option.value
                    return (
                      <button
                        key={option.value}
                        type="button"
                        onClick={() => selectRequestType(option.value)}
                        className={cn(
                          'rounded-xl border p-4 text-left transition',
                          active
                            ? 'border-[var(--portal-orange)] bg-orange-50 shadow-sm ring-1 ring-[var(--portal-orange)]'
                            : 'border-slate-200 bg-white hover:border-slate-300',
                        )}
                      >
                        <div className="flex items-start gap-3">
                          <span className={cn(
                            'flex h-10 w-10 shrink-0 items-center justify-center rounded-lg',
                            active ? 'bg-[var(--portal-orange)] text-white' : 'bg-slate-100 text-slate-600',
                          )}>
                            <Icon className="h-5 w-5" />
                          </span>
                          <p className="text-sm font-semibold text-slate-900">{option.label}</p>
                        </div>
                      </button>
                    )
                  })}
                </div>
              </div>

              {requestType ? (
                <div className="grid gap-4 border-t border-slate-100 pt-4 sm:grid-cols-2">
                  {EMPLOYEE_EXIT_FIELDS[requestType]
                    .filter((field) => fieldIsVisible(field, details))
                    .map((field) => (
                    <div
                      key={field.name}
                      className={
                        field.type === 'textarea' || field.type === 'multiselect' || field.type === 'heading'
                          ? 'sm:col-span-2'
                          : undefined
                      }
                    >
                      {renderField(field)}
                    </div>
                    ))}
                </div>
              ) : null}

              {requestType === 'exit-interview' ? (
                <p className="rounded-lg border border-blue-200 bg-blue-50 px-3 py-2 text-sm text-blue-800">
                  This form follows ABH Partners’s Employee Exit SSP template and is sent directly to HR in Business Central for information purposes only.
                </p>
              ) : null}

              {formError ? (
                <div className="rounded border-l-4 border-red-500 bg-red-50 px-3 py-2 text-sm text-red-700">
                  {formError}
                </div>
              ) : null}

              <div className="flex justify-end gap-2 border-t border-slate-100 pt-4">
                <Button type="button" variant="outline" onClick={showList}>Cancel</Button>
                <Button type="submit" disabled={submitMutation.isPending || !requestType}>
                  {submitMutation.isPending ? 'Submitting…' : requestType === 'exit-interview' ? 'Submit to HR' : 'Submit for approval'}
                </Button>
              </div>
            </div>
          </PortalFormCard>
        </form>
      ) : null}

      {mode === 'detail' && selected ? (
        <div className="space-y-4">
          <PortalFormCard title={`${selected.requestTypeLabel} ${selected.requestNo}`}>
            <div className="space-y-5">
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Recorded</p>
                  <p className="text-sm font-medium text-slate-900">{formatPretty(selected.submittedAt)}</p>
                </div>
                <StatusBadge status={displayRequestStatus(selected)} />
              </div>

              <WorkflowProgress request={selected} />
              <FinalDecisionNotice request={selected} />

              <div className="space-y-3">
                <h3 className="flex items-center gap-2 text-sm font-semibold text-slate-900">
                  <FileText className="h-4 w-4 text-[var(--portal-orange)]" /> Request details
                </h3>
                <div className="grid gap-3 sm:grid-cols-2">
                  {Object.entries(selected.details).filter(([, value]) => value).map(([key, value]) => (
                    <div key={key} className="rounded-xl border border-slate-100 px-4 py-3">
                      <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">{detailLabel(selected.requestType, key)}</p>
                      <p className="mt-1 whitespace-pre-wrap text-sm text-slate-800">{value}</p>
                    </div>
                  ))}
                </div>
              </div>

              {selected.cancellationReason ? (
                <div className="rounded-xl border border-red-200 bg-red-50 px-4 py-3">
                  <p className="text-xs font-semibold uppercase tracking-wide text-red-700">Cancellation reason</p>
                  <p className="mt-1 whitespace-pre-wrap text-sm text-red-900">{selected.cancellationReason}</p>
                </div>
              ) : null}

              {['Open', 'Pending Approval', 'Pending HR Approval'].includes(selected.status) ? (
                <div className="flex justify-end border-t border-slate-100 pt-4">
                  <Button
                    type="button"
                    variant="outline"
                    className="text-red-600 hover:text-red-700"
                    disabled={withdrawMutation.isPending}
                    onClick={() => withdrawRequest(selected.id)}
                  >
                    <XCircle className="mr-2 h-4 w-4" />
                    {withdrawMutation.isPending ? 'Withdrawing…' : 'Withdraw request'}
                  </Button>
                </div>
              ) : null}

              {['transfer', 'resignation'].includes(selected.requestType) && selected.status === 'Approved' ? (
                <div className="border-t border-slate-100 pt-4">
                  {showCancellation ? (
                    <div className="space-y-3 rounded-xl border border-red-200 bg-red-50 p-4">
                      <div>
                        <Label htmlFor="cancellationReason">Cancellation reason *</Label>
                        <Textarea
                          id="cancellationReason"
                          rows={3}
                          value={cancellationReason}
                          maxLength={2000}
                          placeholder="Explain why this request should be cancelled (minimum 10 characters)"
                          onChange={(event) => setCancellationReason(event.target.value)}
                        />
                      </div>
                      <div className="flex justify-end gap-2">
                        <Button type="button" variant="outline" onClick={() => setShowCancellation(false)}>Keep request</Button>
                        <Button
                          type="button"
                          variant="destructive"
                          disabled={cancellationMutation.isPending || cancellationReason.trim().length < 10}
                          onClick={() => {
                            void confirm({
                              title: 'Request cancellation?',
                              message:
                                'The cancellation goes to your approver in Business Central. The request stays approved until they action it.',
                              confirmLabel: 'Send cancellation request',
                              tone: 'danger',
                            }).then((confirmed) => {
                              if (confirmed) cancellationMutation.mutate({ id: selected.id, reason: cancellationReason })
                            })
                          }}
                        >
                          {cancellationMutation.isPending ? 'Recording…' : 'Record cancellation request'}
                        </Button>
                      </div>
                    </div>
                  ) : (
                    <div className="flex justify-end">
                      <Button type="button" variant="outline" className="text-red-600" onClick={() => setShowCancellation(true)}>
                        <XCircle className="mr-2 h-4 w-4" /> Request cancellation
                      </Button>
                    </div>
                  )}
                </div>
              ) : null}
            </div>
          </PortalFormCard>
        </div>
      ) : null}
    </PageWrapper>
  )
}
