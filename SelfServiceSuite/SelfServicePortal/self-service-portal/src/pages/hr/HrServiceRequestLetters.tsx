import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { format, parseISO } from 'date-fns'
import {
  ArrowLeft,
  Ban,
  FileText,
  Info,
  RefreshCw,
  Trash2,
} from 'lucide-react'
import { useMemo, useState } from 'react'
import { Navigate, useNavigate, useParams } from 'react-router-dom'
import {
  cancelHrServiceLetterRequest,
  deleteHrServiceLetterRequest,
  fetchHrServiceLetterRequests,
  fetchMonthlySalaryBase,
  submitHrServiceLetterRequest,
  type HrServiceLetterRequest,
} from '@/api/endpoints/hrServiceLetters'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useAuth } from '@/hooks/useAuth'
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
  HR_LETTER_FIELDS,
  HR_LETTER_TYPES,
  isRequestableHrLetterType,
  type HrLetterFieldConfig,
  type RequestableHrLetterType,
} from '@/data/hrServiceLetters'
import { cn } from '@/lib/utils'
import { formatCurrency } from '@/utils/formatters'

const QUERY_KEY = ['hr', 'service-request-letters'] as const

function formatPretty(iso: string) {
  try {
    return format(parseISO(iso), 'd MMM yyyy, h:mm a')
  } catch {
    return iso
  }
}

function detailLabel(key: string) {
  return key
    .replace(/([A-Z])/g, ' $1')
    .replace(/^./, (char) => char.toUpperCase())
}

function requestDetailLabel(letterType: HrServiceLetterRequest['letterType'], key: string) {
  const workbookEmployeeLabels: Record<string, string> = {
    employeeId: 'Employee ID',
    employeeName: 'Employee Name',
    employeeDepartment: 'Employee Department',
    monthlyBasicSalary: 'Monthly Basic Salary',
  }
  if (workbookEmployeeLabels[key]) return workbookEmployeeLabels[key]
  if (isRequestableHrLetterType(letterType)) {
    const configured = HR_LETTER_FIELDS[letterType].find((field) => field.name === key)
    if (configured) return configured.label.replace(/\s*\(optional\)$/i, '')
  }
  return detailLabel(key)
}

// Excel HR HB: no approval process — request goes to HR for processing/collection.
function employeeVisibleStatus(status: HrServiceLetterRequest['status']) {
  if (status === 'In Progress' || status === 'Submitted') return 'Submitted to HR'
  return status
}

// Business Central only permits an employee to withdraw a request HR has not yet finished.
const EMPLOYEE_CANCELLABLE: HrServiceLetterRequest['status'][] = ['Submitted', 'In Progress']

function canEmployeeCancel(status: HrServiceLetterRequest['status']) {
  return EMPLOYEE_CANCELLABLE.includes(status)
}

function canEmployeeDelete(status: HrServiceLetterRequest['status']) {
  return status === 'Cancelled'
}

// "Active" = still in HR's hands. Matches the one-active-per-type rule enforced in Business
// Central, so the portal blocks a duplicate before it is ever submitted.
const ACTIVE_LETTER_STATUSES: HrServiceLetterRequest['status'][] = [
  'Submitted',
  'In Progress',
  'Approved',
  'Ready for Collection',
]

function isActiveLetter(
  status: HrServiceLetterRequest['status'],
  letterType: HrServiceLetterRequest['letterType'],
) {
  if (letterType === 'emergency-staff-loan') {
    return status === 'Submitted' || status === 'In Progress'
  }
  return ACTIVE_LETTER_STATUSES.includes(status)
}

function emptyDetails(letterType: RequestableHrLetterType | '') {
  if (!letterType) return {}
  return Object.fromEntries(HR_LETTER_FIELDS[letterType].map((field) => [field.name, '']))
}

function localToday() {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

export function HrServiceRequestLetters() {
  const { letterType } = useParams<{ letterType?: string }>()
  if (letterType && !isRequestableHrLetterType(letterType)) {
    return <Navigate to="/hr/request-letters" replace />
  }
  const initialLetterType = isRequestableHrLetterType(letterType) ? letterType : ''
  return <RequestLettersPage key={initialLetterType || 'all-letters'} initialLetterType={initialLetterType} />
}

function RequestLettersPage({
  initialLetterType,
}: {
  initialLetterType: RequestableHrLetterType | ''
}) {
  const toast = useToast()
  const confirm = useConfirm()
  const { employee } = useAuth()
  const queryClient = useQueryClient()
  const navigate = useNavigate()
  const [mode, setMode] = useState<'list' | 'create' | 'detail'>(
    initialLetterType ? 'create' : 'list',
  )
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [letterType, setLetterType] = useState<RequestableHrLetterType | ''>(initialLetterType)
  const [details, setDetails] = useState<Record<string, string>>(
    emptyDetails(initialLetterType),
  )
  const [formError, setFormError] = useState<string | null>(null)

  const listQuery = useQuery({
    queryKey: QUERY_KEY,
    queryFn: () => fetchHrServiceLetterRequests(),
    // Keep the list in step with Business Central: re-pull whenever the employee returns to the
    // tab or the connection recovers, so an HR status change in BC shows up without a manual reload.
    refetchOnWindowFocus: true,
    refetchOnReconnect: true,
    // While the employee keeps this page open, pull HR's latest decision automatically so
    // Approved/Rejected and the decision reason appear without a manual refresh.
    refetchInterval: 15_000,
    staleTime: 15_000,
  })
  const salaryBaseQuery = useQuery({
    queryKey: ['hr', 'monthly-salary-base'],
    queryFn: fetchMonthlySalaryBase,
    enabled: mode === 'create' && letterType === 'emergency-staff-loan',
    staleTime: 5 * 60_000,
  })
  const monthlySalaryBase =
    Number(salaryBaseQuery.data ?? 0) > 0
      ? Number(salaryBaseQuery.data)
      : Number(employee?.monthlySalaryBase ?? 0)

  const submitMutation = useMutation({
    mutationFn: submitHrServiceLetterRequest,
    onSuccess: (request) => {
      const isEmergencyLoan = request.letterType === 'emergency-staff-loan'
      toast.success(
        isEmergencyLoan ? 'Emergency Staff Loan request sent to HR' : 'Letter request sent to HR',
        `${request.requestNo} was submitted to HR for processing. There is no approval step — HR will prepare the letter and update the status here.`,
      )
      queryClient.setQueryData<HrServiceLetterRequest[]>(QUERY_KEY, (current = []) => [
        request,
        ...current.filter((row) => row.id !== request.id),
      ])
      void queryClient.invalidateQueries({ queryKey: QUERY_KEY })
      setLetterType('')
      setDetails({})
      setSelectedId(request.id)
      setMode('detail')
    },
    onError: (error) => {
      const message = error instanceof Error
        ? error.message
        : 'Please complete all required fields and try again.'
      setFormError(message)
      toast.error('Submission failed', message)
    },
  })

  const cancelMutation = useMutation({
    mutationFn: cancelHrServiceLetterRequest,
    onSuccess: (updated) => {
      toast.success('Request cancelled', 'HR has been notified and will not process it.')
      // Reflect the cancellation immediately, then reconcile with the server.
      queryClient.setQueryData<HrServiceLetterRequest[]>(QUERY_KEY, (current = []) =>
        current.map((row) =>
          row.id === updated?.id ? { ...row, ...updated, status: 'Cancelled' } : row,
        ),
      )
      void queryClient.invalidateQueries({ queryKey: QUERY_KEY })
      navigate('/hr/request-letters')
      setMode('list')
      setLetterType('')
      setDetails({})
      setFormError(null)
      setSelectedId(null)
    },
    onError: (error) => {
      toast.error(
        'Cancellation failed',
        error instanceof Error ? error.message : 'Please try again.',
      )
    },
  })

  const deleteMutation = useMutation({
    mutationFn: deleteHrServiceLetterRequest,
    onSuccess: (_result, id) => {
      queryClient.setQueryData<HrServiceLetterRequest[]>(QUERY_KEY, (current = []) =>
        current.filter((row) => row.id !== id),
      )
      void queryClient.invalidateQueries({ queryKey: QUERY_KEY })
      toast.success('Request deleted', 'The cancelled request was permanently removed.')
      if (selectedId === id) {
        navigate('/hr/request-letters')
        setSelectedId(null)
        setMode('list')
      }
    },
    onError: (error) => {
      toast.error(
        'Deletion failed',
        error instanceof Error ? error.message : 'Please try again.',
      )
    },
  })

  const requestCancel = (id: string) => {
    if (cancelMutation.isPending) return
    void confirm({
      title: 'Cancel this HR service request?',
      message: 'HR will stop processing this request. This cannot be undone.',
      confirmLabel: 'Cancel request',
      cancelLabel: 'Keep request',
      tone: 'danger',
    }).then((ok) => {
      if (ok) cancelMutation.mutate(id)
    })
  }

  const requestDelete = (id: string) => {
    if (deleteMutation.isPending) return
    void confirm({
      title: 'Permanently delete this cancelled request?',
      message: 'This removes the request from Business Central and cannot be undone.',
      confirmLabel: 'Delete permanently',
      cancelLabel: 'Keep request',
      tone: 'danger',
    }).then((ok) => {
      if (ok) deleteMutation.mutate(id)
    })
  }

  const rows = useMemo(() => listQuery.data ?? [], [listQuery.data])
  const selected = useMemo(
    () => rows.find((row) => row.id === selectedId) ?? null,
    [rows, selectedId],
  )

  // Mirror the Business Central rule: one active request per letter type. Surfaced here so the
  // employee sees it while filling the form, not only as an error after pressing submit.
  const activeSameTypeRequest = useMemo(
    () =>
      letterType
        ? rows.find(
            (row) =>
              row.letterType === letterType && isActiveLetter(row.status, row.letterType),
          ) ?? null
        : null,
    [rows, letterType],
  )

  const columns: DataTableColumn<HrServiceLetterRequest>[] = [
    { id: 'no', header: 'Request No.', cell: (row) => row.requestNo },
    { id: 'type', header: 'Request type', cell: (row) => row.letterTypeLabel },
    { id: 'submitted', header: 'Submitted', cell: (row) => formatPretty(row.submittedAt) },
    {
      id: 'status',
      header: 'Status',
      cell: (row) => <StatusBadge status={employeeVisibleStatus(row.status)} />,
    },
    {
      id: 'actions',
      header: '',
      cell: (row) => {
        if (canEmployeeCancel(row.status)) return (
          <Button
            type="button"
            variant="outline"
            size="sm"
            className="text-red-600 hover:text-red-700"
            disabled={cancelMutation.isPending}
            onClick={(event) => {
              event.stopPropagation()
              requestCancel(row.id)
            }}
          >
            <Ban className="mr-1.5 h-3.5 w-3.5" />
            Cancel
          </Button>
        )
        if (canEmployeeDelete(row.status)) return (
          <Button
            type="button"
            variant="outline"
            size="sm"
            className="text-red-600 hover:text-red-700"
            disabled={deleteMutation.isPending}
            onClick={(event) => {
              event.stopPropagation()
              requestDelete(row.id)
            }}
          >
            <Trash2 className="mr-1.5 h-3.5 w-3.5" />
            Delete
          </Button>
        )
        return null
      },
    },
  ]

  const startCreate = () => {
    navigate('/hr/request-letters')
    setMode('create')
    setLetterType('')
    setDetails({})
    setFormError(null)
    setSelectedId(null)
  }

  const selectLetterType = (value: RequestableHrLetterType) => {
    navigate(`/hr/request-letters/${value}`)
    setLetterType(value)
    setDetails(emptyDetails(value))
    setFormError(null)
  }

  const showList = () => {
    navigate('/hr/request-letters')
    setMode('list')
    setLetterType('')
    setDetails({})
    setFormError(null)
    setSelectedId(null)
  }

  const updateDetail = (name: string, value: string) => {
    setDetails((current) => ({ ...current, [name]: value }))
  }

  const validateForm = () => {
    if (!letterType) {
      setFormError('Select a letter type to continue.')
      return false
    }
    const missing = HR_LETTER_FIELDS[letterType].filter(
      (field) => field.required && !String(details[field.name] ?? '').trim(),
    )
    if (missing.length > 0) {
      setFormError(`Please complete: ${missing.map((field) => field.label).join(', ')}`)
      return false
    }
    if (
      ['mortgage', 'emergency-staff-loan'].includes(letterType) &&
      (!Number.isFinite(Number(details.loanAmount)) || Number(details.loanAmount) <= 0)
    ) {
      setFormError('Loan amount must be greater than zero.')
      return false
    }
    if (
      letterType === 'embassy' &&
      details.travelStartDate &&
      details.travelEndDate &&
      details.travelEndDate < details.travelStartDate
    ) {
      setFormError('Travel end date must be on or after the travel start date.')
      return false
    }
    setFormError(null)
    return true
  }

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault()
    if (!validateForm() || !letterType) return
    submitMutation.mutate({
      letterType,
      details,
    })
  }

  const renderField = (field: HrLetterFieldConfig) => {
    const value = details[field.name] ?? ''
    const dateMinimum = field.name === 'travelEndDate'
      ? details.travelStartDate || localToday()
      : localToday()

    return (
      <div key={field.name} className="space-y-1.5">
        <Label htmlFor={field.name}>
          {field.label}
          {field.required ? <span className="text-red-500"> *</span> : null}
        </Label>
        {field.type === 'select' ? (
          <Select
            id={field.name}
            value={value}
            options={field.options ?? []}
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
            min={field.type === 'number' ? 0.01 : field.type === 'date' ? dateMinimum : undefined}
            step={field.type === 'number' ? 0.01 : undefined}
            maxLength={field.type === 'number' || field.type === 'date' ? undefined : 300}
            placeholder={field.placeholder}
            onChange={(event) => updateDetail(field.name, event.target.value)}
          />
        )}
      </div>
    )
  }

  return (
    <PageWrapper
      title="HR Service Requests"
      description="Submit HR letters and Emergency Staff Loan requests directly to HR and track the latest decision."
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
            <PortalNewButton label="New HR service request" onClick={startCreate} />
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
              <h2 className="text-sm font-semibold text-slate-900">My HR Service Requests</h2>
              <p className="mt-0.5 text-xs text-slate-500">
                Every request submitted to HR, newest first. Click a row to view its details and decision reason.
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
              {listQuery.error instanceof Error
                ? listQuery.error.message
                : 'Letter requests could not be loaded. Please try again.'}
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
                <p className="text-sm font-semibold text-slate-900">No HR service requests yet</p>
                <p className="mx-auto mt-1 max-w-xs text-xs text-slate-500">
                  Requests submitted to HR will appear here so you can track their status.
                </p>
              </div>
              <PortalNewButton label="New HR service request" onClick={startCreate} />
            </div>
          ) : (
            <DataTable<HrServiceLetterRequest>
              columns={columns}
              rows={rows}
              getRowId={(row) => row.id}
              emptyTitle="No HR service requests yet."
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
            title={
              HR_LETTER_TYPES.find((option) => option.value === letterType)?.label ??
              'New HR Service Request'
            }
          >
            <div className="space-y-5">
              <div className="rounded-xl border border-blue-100 bg-blue-50/70 px-4 py-3 text-sm text-blue-900">
                <div className="flex items-start gap-2">
                  <Info className="mt-0.5 h-4 w-4 shrink-0" />
                  <p>
                    {letterType === 'emergency-staff-loan'
                      ? 'Submit the Emergency Staff Loan request directly to HR for processing. There is no approval workflow — HR prepares the letter and updates status in My HR Service Requests.'
                      : 'Select the required letter and submit it directly to HR for processing. There is no approval workflow — HR prepares the letter and updates status in My HR Service Requests.'}
                  </p>
                </div>
              </div>

              <div className="space-y-2">
                <Label>Request type</Label>
                <div className="grid gap-3 md:grid-cols-2">
                  {HR_LETTER_TYPES.map((option) => {
                    const Icon = option.icon
                    const active = letterType === option.value
                    return (
                      <button
                        key={option.value}
                        type="button"
                        onClick={() => selectLetterType(option.value)}
                        className={cn(
                          'rounded-xl border p-4 text-left transition',
                          active
                            ? 'border-[var(--portal-orange)] bg-orange-50 shadow-sm ring-1 ring-[var(--portal-orange)]'
                            : 'border-slate-200 bg-white hover:border-slate-300',
                        )}
                      >
                        <div className="flex items-start gap-3">
                          <span
                            className={cn(
                              'flex h-10 w-10 shrink-0 items-center justify-center rounded-lg',
                              active ? 'bg-[var(--portal-orange)] text-white' : 'bg-slate-100 text-slate-600',
                            )}
                          >
                            <Icon className="h-5 w-5" />
                          </span>
                          <div>
                            <p className="text-sm font-semibold text-slate-900">{option.label}</p>
                            <p className="mt-1 text-xs text-slate-500">{option.turnaround}</p>
                          </div>
                        </div>
                      </button>
                    )
                  })}
                </div>
              </div>

              {letterType ? (
                <div className="grid gap-4 border-t border-slate-100 pt-4 sm:grid-cols-2">
                  {letterType === 'emergency-staff-loan' ? (
                    <>
                      {[
                        { name: 'employeeId', label: 'Employee ID', value: employee?.employeeNo ?? '' },
                        { name: 'employeeName', label: 'Employee Name', value: employee?.displayName ?? '' },
                        {
                          name: 'employeeDepartment',
                          label: 'Employee Department',
                          value: employee?.departmentName || employee?.departmentCode || '',
                        },
                        {
                          name: 'monthlyBasicSalary',
                          label: 'Monthly Basic Salary',
                          value: monthlySalaryBase > 0 ? formatCurrency(monthlySalaryBase) : '',
                        },
                      ].map((field) => (
                        <div key={field.name} className="space-y-1.5">
                          <Label htmlFor={field.name}>{field.label}</Label>
                          <Input
                            id={field.name}
                            value={field.value}
                            readOnly
                            placeholder={
                              field.name === 'monthlyBasicSalary'
                                ? salaryBaseQuery.isFetching
                                  ? 'Loading from Business Central…'
                                  : 'Not available in Business Central'
                                : 'Loaded from Business Central'
                            }
                            className="bg-slate-50"
                          />
                        </div>
                      ))}
                    </>
                  ) : null}
                  {HR_LETTER_FIELDS[letterType].map((field) => (
                    <div
                      key={field.name}
                      className={field.type === 'textarea' ? 'sm:col-span-2' : undefined}
                    >
                      {renderField(field)}
                    </div>
                  ))}
                </div>
              ) : null}

              {activeSameTypeRequest ? (
                <div className="flex items-start gap-2 rounded border-l-4 border-amber-500 bg-amber-50 px-3 py-2 text-sm text-amber-800">
                  <Info className="mt-0.5 h-4 w-4 shrink-0" />
                  <span>
                    You already have an active {activeSameTypeRequest.letterTypeLabel} request (
                    {activeSameTypeRequest.requestNo}). Wait until HR completes or cancels it, or
                    cancel it yourself, before requesting another of the same type.
                  </span>
                </div>
              ) : null}

              {formError ? (
                <div className="rounded border-l-4 border-red-500 bg-red-50 px-3 py-2 text-sm text-red-700">
                  {formError}
                </div>
              ) : null}

              <div className="flex flex-wrap justify-end gap-2 border-t border-slate-100 pt-4">
                <Button type="button" variant="outline" onClick={showList}>
                  Cancel
                </Button>
                <Button
                  type="submit"
                  disabled={submitMutation.isPending || !letterType || Boolean(activeSameTypeRequest)}
                >
                  {submitMutation.isPending ? 'Submitting…' : 'Submit request to HR'}
                </Button>
              </div>
            </div>
          </PortalFormCard>
        </form>
      ) : null}

      {mode === 'detail' && selected ? (
        <div className="space-y-4">
          <PortalFormCard title={`Request ${selected.requestNo}`}>
            <div className="space-y-5">
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Request type</p>
                  <p className="text-base font-semibold text-slate-900">{selected.letterTypeLabel}</p>
                </div>
                <StatusBadge status={employeeVisibleStatus(selected.status)} />
              </div>

              {selected.status === 'Rejected' && selected.hrRemarks ? (
                <div className="rounded border-l-4 border-red-500 bg-red-50 px-3 py-2 text-sm text-red-700">
                  <span className="font-semibold">HR rejected this request:</span> {selected.hrRemarks}
                </div>
              ) : null}
              {selected.status === 'Approved' && selected.hrRemarks ? (
                <div className="rounded border-l-4 border-emerald-500 bg-emerald-50 px-3 py-2 text-sm text-emerald-700">
                  <span className="font-semibold">HR approval reason:</span> {selected.hrRemarks}
                </div>
              ) : null}
              {selected.status === 'Ready for Collection' && selected.letterType !== 'emergency-staff-loan' ? (
                <div className="rounded border-l-4 border-emerald-500 bg-emerald-50 px-3 py-2 text-sm text-emerald-700">
                  Your letter is ready — please collect it from HR.
                </div>
              ) : null}

              <div className="grid gap-3 sm:grid-cols-2">
                <div className="rounded-xl border border-slate-100 bg-slate-50 px-4 py-3">
                  <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Submitted</p>
                  <p className="mt-1 text-sm font-medium text-slate-900">{formatPretty(selected.submittedAt)}</p>
                </div>
                <div className="rounded-xl border border-slate-100 bg-slate-50 px-4 py-3">
                  <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Department</p>
                  <p className="mt-1 text-sm font-medium text-slate-900">{selected.departmentName}</p>
                </div>
                {selected.hrDecisionAt ? (
                  <div className="rounded-xl border border-slate-100 bg-slate-50 px-4 py-3">
                    <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">HR decision</p>
                    <p className="mt-1 text-sm font-medium text-slate-900">{formatPretty(selected.hrDecisionAt)}</p>
                    {selected.hrDecisionBy ? <p className="mt-0.5 text-xs text-slate-500">By {selected.hrDecisionBy}</p> : null}
                  </div>
                ) : null}
              </div>

              <div className="space-y-3">
                <h3 className="flex items-center gap-2 text-sm font-semibold text-slate-900">
                  <FileText className="h-4 w-4 text-[var(--portal-orange)]" />
                  Request details
                </h3>
                <div className="grid gap-3 sm:grid-cols-2">
                  {Object.entries(selected.details).map(([key, value]) => (
                    <div key={key} className="rounded-xl border border-slate-100 px-4 py-3">
                      <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">{requestDetailLabel(selected.letterType, key)}</p>
                      <p className="mt-1 whitespace-pre-wrap text-sm text-slate-800">{value || '—'}</p>
                    </div>
                  ))}
                </div>
              </div>

              {canEmployeeCancel(selected.status) ? (
                <div className="flex justify-end border-t border-slate-100 pt-4">
                  <Button
                    type="button"
                    variant="outline"
                    className="text-red-600 hover:text-red-700"
                    disabled={cancelMutation.isPending}
                    onClick={() => requestCancel(selected.id)}
                  >
                    <Ban className="mr-2 h-4 w-4" />
                    {cancelMutation.isPending ? 'Cancelling…' : 'Cancel request'}
                  </Button>
                </div>
              ) : null}
              {canEmployeeDelete(selected.status) ? (
                <div className="flex justify-end border-t border-slate-100 pt-4">
                  <Button
                    type="button"
                    variant="outline"
                    className="text-red-600 hover:text-red-700"
                    disabled={deleteMutation.isPending}
                    onClick={() => requestDelete(selected.id)}
                  >
                    <Trash2 className="mr-2 h-4 w-4" />
                    {deleteMutation.isPending ? 'Deleting…' : 'Delete permanently'}
                  </Button>
                </div>
              ) : null}
            </div>
          </PortalFormCard>
        </div>
      ) : null}
    </PageWrapper>
  )
}
