import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { format, parseISO } from 'date-fns'
import {
  ArrowLeft,
  CheckCircle2,
  Clock3,
  FileText,
  Info,
  Trash2,
} from 'lucide-react'
import { useMemo, useState } from 'react'
import {
  cancelHrServiceLetterRequest,
  fetchHrServiceLetterRequests,
  submitHrServiceLetterRequest,
  type HrServiceLetterRequest,
} from '@/api/endpoints/hrServiceLetters'
import { useToast } from '@/components/feedback/ToastProvider'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
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
  isHrLetterType,
  type HrLetterFieldConfig,
  type HrLetterType,
} from '@/data/hrServiceLetters'
import { cn } from '@/lib/utils'
import { Navigate, useParams } from 'react-router-dom'

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

function LetterProgress({ status }: { status: HrServiceLetterRequest['status'] }) {
  const steps = [
    { label: 'Request submitted', done: true },
    {
      label: 'HR review',
      done: ['Approved', 'Rejected', 'Ready for Collection', 'Completed'].includes(status),
    },
    {
      label: 'Letter ready',
      done: status === 'Ready for Collection' || status === 'Approved',
    },
  ]

  return (
    <div className="grid gap-2 rounded-2xl border border-blue-100 bg-gradient-to-r from-blue-50/80 to-white p-3 sm:grid-cols-3">
      {steps.map((step, index) => (
        <div
          key={step.label}
          className={cn(
            'flex items-center gap-3 rounded-xl border p-3',
            step.done ? 'border-emerald-200 bg-white' : 'border-transparent bg-white/60',
          )}
        >
          <span
            className={cn(
              'flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-sm font-semibold',
              step.done ? 'bg-emerald-100 text-emerald-700' : 'bg-slate-100 text-slate-400',
            )}
          >
            {step.done ? <CheckCircle2 className="h-4 w-4" /> : index + 1}
          </span>
          <div>
            <p className="text-sm font-semibold text-slate-900">{step.label}</p>
            <p className="text-xs text-slate-500">{step.done ? 'Complete' : 'Pending'}</p>
          </div>
        </div>
      ))}
    </div>
  )
}

function emptyDetails(letterType: HrLetterType | '') {
  if (!letterType) return {}
  return Object.fromEntries(HR_LETTER_FIELDS[letterType].map((field) => [field.name, '']))
}

export function HrServiceRequestLetters() {
  const { letterType: routeLetterType } = useParams<{ letterType?: string }>()
  const initialLetterType = isHrLetterType(routeLetterType) ? routeLetterType : ''
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const [mode, setMode] = useState<'list' | 'create' | 'detail'>(
    initialLetterType ? 'create' : 'list',
  )
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [letterType, setLetterType] = useState<HrLetterType | ''>(initialLetterType)
  const [details, setDetails] = useState<Record<string, string>>(
    emptyDetails(initialLetterType),
  )
  const [formError, setFormError] = useState<string | null>(null)

  const listQuery = useQuery({
    queryKey: QUERY_KEY,
    queryFn: fetchHrServiceLetterRequests,
  })

  const submitMutation = useMutation({
    mutationFn: submitHrServiceLetterRequest,
    onSuccess: (request) => {
      toast.success('Letter request submitted', `${request.requestNo} is pending HR review.`)
      void queryClient.invalidateQueries({ queryKey: QUERY_KEY })
      setMode('list')
      setLetterType('')
      setDetails({})
      setSelectedId(request.id)
      setMode('detail')
    },
    onError: (error) =>
      toast.error(
        error instanceof Error ? error.message : 'Please complete all required fields and try again.',
        'Submission failed',
      ),
  })

  const cancelMutation = useMutation({
    mutationFn: cancelHrServiceLetterRequest,
    onSuccess: () => {
      toast.info('Request cancelled')
      void queryClient.invalidateQueries({ queryKey: QUERY_KEY })
      setMode('list')
      setSelectedId(null)
    },
  })

  const rows = listQuery.data ?? []
  const selected = useMemo(
    () => rows.find((row) => row.id === selectedId) ?? null,
    [rows, selectedId],
  )

  const columns: DataTableColumn<HrServiceLetterRequest>[] = [
    { id: 'no', header: 'Request No.', cell: (row) => row.requestNo },
    { id: 'type', header: 'Letter type', cell: (row) => row.letterTypeLabel },
    { id: 'submitted', header: 'Submitted', cell: (row) => formatPretty(row.submittedAt) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
  ]

  const startCreate = () => {
    setMode('create')
    setLetterType('')
    setDetails({})
    setFormError(null)
    setSelectedId(null)
  }

  const selectLetterType = (value: HrLetterType) => {
    setLetterType(value)
    setDetails(emptyDetails(value))
    setFormError(null)
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

    return (
      <div key={field.name} className="space-y-1.5">
        <Label htmlFor={field.name}>
          {field.label}
          {field.required ? <span className="text-red-500"> *</span> : null}
        </Label>
        {field.type === 'textarea' ? (
          <Textarea
            id={field.name}
            rows={3}
            value={value}
            placeholder={field.placeholder}
            onChange={(event) => updateDetail(field.name, event.target.value)}
          />
        ) : field.type === 'select' ? (
          <Select
            id={field.name}
            value={value}
            placeholder={field.placeholder ?? 'Select'}
            options={field.options ?? []}
            onChange={(event) => updateDetail(field.name, event.target.value)}
          />
        ) : (
          <Input
            id={field.name}
            type={field.type}
            value={value}
            placeholder={field.placeholder}
            onChange={(event) => updateDetail(field.name, event.target.value)}
          />
        )}
      </div>
    )
  }

  if (routeLetterType && !isHrLetterType(routeLetterType)) {
    return <Navigate to="/hr/request-letters" replace />
  }

  return (
    <PageWrapper
      title="HR Service Request Letters"
      description="Request guarantee letters, experience letters, mortgage letters, and emergency staff loan letters from HR."
      actions={
        mode === 'list' ? (
          <PortalNewButton label="New letter request" onClick={startCreate} />
        ) : (
          <Button type="button" variant="outline" onClick={() => setMode('list')}>
            <ArrowLeft className="mr-2 h-4 w-4" />
            Back to list
          </Button>
        )
      }
    >
      {mode === 'list' ? (
        <div className="space-y-4">
          <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3">
            {HR_LETTER_TYPES.map((option) => {
              const Icon = option.icon
              return (
                <button
                  key={option.value}
                  type="button"
                  onClick={() => {
                    selectLetterType(option.value)
                    setMode('create')
                  }}
                  className="group rounded-2xl border border-slate-200 bg-white p-4 text-left shadow-sm transition hover:border-[var(--portal-orange)] hover:shadow-md"
                >
                  <span className="mb-3 flex h-10 w-10 items-center justify-center rounded-xl bg-orange-50 text-[var(--portal-orange)] transition group-hover:bg-[var(--portal-orange)] group-hover:text-white">
                    <Icon className="h-5 w-5" />
                  </span>
                  <p className="text-sm font-semibold text-slate-900">{option.shortLabel}</p>
                  <p className="mt-1 line-clamp-2 text-xs text-slate-500">{option.description}</p>
                  <p className="mt-2 flex items-center gap-1 text-xs font-medium text-emerald-700">
                    <Clock3 className="h-3.5 w-3.5" />
                    {option.turnaround}
                  </p>
                </button>
              )
            })}
          </div>

          <div className="portal-surface-card overflow-hidden rounded-2xl border border-slate-200 bg-white">
            <div className="border-b border-slate-100 px-4 py-3">
              <h2 className="text-sm font-semibold text-slate-900">My letter requests</h2>
            </div>
            {listQuery.isLoading ? (
              <div className="space-y-2 p-4">
                <Skeleton className="h-10 w-full" />
                <Skeleton className="h-10 w-full" />
              </div>
            ) : listQuery.isError ? (
              <div className="border-l-4 border-red-500 bg-red-50 p-4 text-sm text-red-700">
                {listQuery.error instanceof Error
                  ? listQuery.error.message
                  : 'Could not load HR document requests.'}
              </div>
            ) : (
              <DataTable<HrServiceLetterRequest>
                columns={columns}
                rows={rows}
                getRowId={(row) => row.id}
                emptyTitle="No letter requests yet. Start with New letter request."
                onRowClick={(row) => {
                  setSelectedId(row.id)
                  setMode('detail')
                }}
              />
            )}
          </div>
        </div>
      ) : null}

      {mode === 'create' ? (
        <form onSubmit={handleSubmit} className="space-y-4">
          <PortalFormCard title="New HR Service Letter Request">
            <div className="space-y-5">
              <div className="rounded-xl border border-blue-100 bg-blue-50/70 px-4 py-3 text-sm text-blue-900">
                <div className="flex items-start gap-2">
                  <Info className="mt-0.5 h-4 w-4 shrink-0" />
                  <p>Select the letter category required. HR will prepare the official document after review and approval.</p>
                </div>
              </div>

              <div className="space-y-2">
                <Label>Letter type</Label>
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

              {formError ? (
                <div className="rounded border-l-4 border-red-500 bg-red-50 px-3 py-2 text-sm text-red-700">
                  {formError}
                </div>
              ) : null}

              <div className="flex flex-wrap justify-end gap-2 border-t border-slate-100 pt-4">
                <Button type="button" variant="outline" onClick={() => setMode('list')}>
                  Cancel
                </Button>
                <Button type="submit" disabled={submitMutation.isPending || !letterType}>
                  {submitMutation.isPending ? 'Submitting…' : 'Submit for HR review'}
                </Button>
              </div>
            </div>
          </PortalFormCard>
        </form>
      ) : null}

      {mode === 'detail' && selected ? (
        <div className="space-y-4">
          <PortalFormCard title={`Letter request ${selected.requestNo}`}>
            <div className="space-y-5">
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Letter type</p>
                  <p className="text-base font-semibold text-slate-900">{selected.letterTypeLabel}</p>
                </div>
                <StatusBadge status={selected.status} />
              </div>

              <LetterProgress status={selected.status} />

              <div className="grid gap-3 sm:grid-cols-2">
                <div className="rounded-xl border border-slate-100 bg-slate-50 px-4 py-3">
                  <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Submitted</p>
                  <p className="mt-1 text-sm font-medium text-slate-900">{formatPretty(selected.submittedAt)}</p>
                </div>
                <div className="rounded-xl border border-slate-100 bg-slate-50 px-4 py-3">
                  <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Department</p>
                  <p className="mt-1 text-sm font-medium text-slate-900">{selected.departmentName}</p>
                </div>
              </div>

              <div className="space-y-3">
                <h3 className="flex items-center gap-2 text-sm font-semibold text-slate-900">
                  <FileText className="h-4 w-4 text-[var(--portal-orange)]" />
                  Request details
                </h3>
                <div className="grid gap-3 sm:grid-cols-2">
                  {Object.entries(selected.details).map(([key, value]) => (
                    <div key={key} className="rounded-xl border border-slate-100 px-4 py-3">
                      <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">{detailLabel(key)}</p>
                      <p className="mt-1 whitespace-pre-wrap text-sm text-slate-800">{value || '—'}</p>
                    </div>
                  ))}
                </div>
              </div>

              {['Submitted', 'In Progress'].includes(selected.status) ? (
                <div className="flex justify-end border-t border-slate-100 pt-4">
                  <Button
                    type="button"
                    variant="outline"
                    className="text-red-600 hover:text-red-700"
                    disabled={cancelMutation.isPending}
                    onClick={() => {
                      void confirm({
                        title: 'Cancel this letter request?',
                        message: 'HR will not process this request after cancellation.',
                        confirmLabel: 'Cancel request',
                        tone: 'danger',
                      }).then((ok) => {
                        if (ok) cancelMutation.mutate(selected.id)
                      })
                    }}
                  >
                    <Trash2 className="mr-2 h-4 w-4" />
                    Cancel request
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
