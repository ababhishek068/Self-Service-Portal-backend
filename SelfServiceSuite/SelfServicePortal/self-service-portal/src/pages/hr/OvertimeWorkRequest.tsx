import { useMemo, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  ArrowLeft,
  CalendarDays,
  ClipboardList,
  MapPin,
  Plus,
  Printer,
  Save,
  Send,
  Trash2,
  Undo2,
  User,
} from 'lucide-react'
import { Link, useSearchParams } from 'react-router-dom'
import {
  deleteOvertimeWorkRequest,
  fetchOvertimeWorkRequests,
  saveOvertimeWorkRequest,
  withdrawOvertimeWorkRequest,
  type OvertimeWorkLine,
  type OvertimeWorkLocation,
  type OvertimeWorkRequest as OvertimeWorkRow,
} from '@/api/endpoints/overtimeWork'
import { fetchOvertimeContext, splitOvertimeHours, type OvertimeDayType } from '@/api/endpoints/overtime'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { ClockTimePicker } from '@/components/shared/ClockTimePicker'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { formatDateTime } from '@/utils/formatters'

const LIST_KEY = ['hr', 'overtime-work-requests'] as const
const CONTEXT_KEY = ['hr', 'overtime-context'] as const

const DAY_TYPES: Array<{ value: OvertimeDayType; label: string }> = [
  { value: 'working', label: 'Normal day hours (6 AM – 10 PM)' },
  { value: 'night', label: 'Night hours (10 PM – 6 AM)' },
  { value: 'restDay', label: 'Weekly rest day hours' },
  { value: 'holiday', label: 'Public holiday hours' },
]

const LOCATION_OPTIONS: Array<{ value: OvertimeWorkLocation; label: string }> = [
  { value: 'office', label: 'Office' },
  { value: 'field', label: 'Field' },
  { value: 'projectSite', label: 'Project Site' },
]

type WorkLineInput = {
  overtimeDate: string
  startTime: string
  endTime: string
  dayType: OvertimeDayType
  workLocation: OvertimeWorkLocation
  reason: string
}

type EntryDraft = {
  overtimeDate: string
  startTime: string
  endTime: string
  dayType: OvertimeDayType | ''
  workLocation: OvertimeWorkLocation | ''
  reason: string
}

function emptyEntry(): EntryDraft {
  return { overtimeDate: '', startTime: '', endTime: '', dayType: '', workLocation: '', reason: '' }
}

function sortLines(lines: WorkLineInput[]) {
  return [...lines].sort((a, b) => (a.overtimeDate + a.startTime).localeCompare(b.overtimeDate + b.startTime))
}

function locationLabel(value: OvertimeWorkLocation | string | undefined) {
  return LOCATION_OPTIONS.find((option) => option.value === value)?.label ?? value ?? '—'
}

function clockText(value: string) {
  const match = /^(\d{1,2}):(\d{2})$/.exec(value.trim())
  if (!match) return value
  const hour = Number(match[1])
  const minute = match[2]
  const meridiem = hour >= 12 ? 'PM' : 'AM'
  const twelve = hour % 12 || 12
  return `${twelve}:${minute} ${meridiem}`
}

function shortDate(value: string) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return value
  const [y, m, d] = value.split('-')
  return `${d}/${m}/${y}`
}

function dateRangeLabel(lines: OvertimeWorkLine[], fallback: string) {
  const dates = lines.map((line) => line.overtimeDate).filter(Boolean).sort()
  if (!dates.length) return fallback
  return dates[0] === dates[dates.length - 1] ? dates[0]! : `${dates[0]} – ${dates[dates.length - 1]}`
}

function printWorkRequest(work: OvertimeWorkRow) {
  const lines = work.lines?.length
    ? work.lines
    : [
        {
          overtimeDate: work.overtimeDate,
          startTime: work.overtimeFrom,
          endTime: work.overtimeTo,
          dayType: 'working' as OvertimeDayType,
          workLocation: work.workLocation || ('office' as OvertimeWorkLocation),
          reason: work.reason,
          totalHours: work.totalHours,
        },
      ]
  const esc = (value: string) =>
    value.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;')
  const rowsHtml = lines
    .map(
      (line) =>
        `<tr><td>${esc(line.overtimeDate)}</td><td>${esc(line.startTime)} – ${esc(line.endTime)}</td><td>${esc(String(line.dayType))}</td><td>${esc(locationLabel(line.workLocation))}</td><td>${Number(line.totalHours || 0).toFixed(2)}</td><td>${esc(line.reason || work.reason || '')}</td></tr>`,
    )
    .join('')
  const popup = window.open('', '_blank', 'noopener,noreferrer,width=900,height=700')
  if (!popup) return false
  popup.document.open()
  popup.document.write(`<!doctype html><html><head><meta charset="utf-8"/><title>${esc(work.requestNo)}</title>
<style>body{font-family:Georgia,serif;margin:2rem;color:#0f172a}table{width:100%;border-collapse:collapse;margin-top:.75rem}th,td{border:1px solid #cbd5e1;padding:.45rem .6rem;text-align:left}th{background:#f8fafc}dl{display:grid;grid-template-columns:11rem 1fr;gap:.35rem 1rem}dt{color:#64748b}dd{margin:0;font-weight:600}</style></head>
<body><h1>Overtime Work Request ${esc(work.requestNo)}</h1>
<p>Status: ${esc(work.status)} · Printed ${esc(new Date().toLocaleString())}</p>
<dl>
<dt>Employee</dt><dd>${esc(work.employeeName)} (${esc(work.employeeNo)})</dd>
<dt>Designation</dt><dd>${esc(work.designation || '—')}</dd>
<dt>Department</dt><dd>${esc(work.departmentName || work.departmentCode || '—')}</dd>
<dt>Total hours</dt><dd>${Number(work.totalHours || 0).toFixed(2)}</dd>
<dt>Justification</dt><dd>${esc(work.reason || '—')}</dd>
<dt>Expected deliverables</dt><dd>${esc(work.expectedDeliverables || '—')}</dd>
</dl>
<table><thead><tr><th>Date</th><th>Time</th><th>Category</th><th>Location</th><th>Hours</th><th>Reason</th></tr></thead><tbody>${rowsHtml}</tbody></table>
<script>window.onload=function(){window.print()}</script></body></html>`)
  popup.document.close()
  return true
}

export function OvertimeWorkRequest() {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const [searchParams, setSearchParams] = useSearchParams()
  const requestedNo = searchParams.get('request')
  const [mode, setMode] = useState<'list' | 'form' | 'detail'>(requestedNo ? 'detail' : 'list')
  const [selectedNo, setSelectedNo] = useState<string | null>(requestedNo)
  const [editingNo, setEditingNo] = useState<string | null>(null)
  const [lines, setLines] = useState<WorkLineInput[]>([])
  const [entry, setEntry] = useState<EntryDraft>(emptyEntry)
  const [entryOpen, setEntryOpen] = useState(false)
  const [editingLine, setEditingLine] = useState<number | null>(null)
  const [entryError, setEntryError] = useState<string | null>(null)
  const [reason, setReason] = useState('')
  const [expectedDeliverables, setExpectedDeliverables] = useState('')
  const [formError, setFormError] = useState<string | null>(null)

  const listQuery = useQuery({ queryKey: LIST_KEY, queryFn: fetchOvertimeWorkRequests })
  const contextQuery = useQuery({ queryKey: CONTEXT_KEY, queryFn: fetchOvertimeContext })
  const rows = listQuery.data ?? []
  const shown = useMemo(
    () => (selectedNo ? rows.find((row) => row.requestNo === selectedNo) ?? null : null),
    [rows, selectedNo],
  )
  const employee = contextQuery.data?.employee
  const entryHours = splitOvertimeHours(entry.startTime, entry.endTime, entry.dayType || 'working')
  const totalHours = lines.reduce(
    (sum, line) => sum + splitOvertimeHours(line.startTime, line.endTime, line.dayType).totalHours,
    0,
  )

  const [linkedNo, setLinkedNo] = useState(requestedNo)
  if (requestedNo !== linkedNo) {
    setLinkedNo(requestedNo)
    if (requestedNo && requestedNo !== selectedNo) {
      setSelectedNo(requestedNo)
      setMode('detail')
    }
  }

  const goTo = (next: 'list' | 'form' | 'detail', no?: string) => {
    setMode(next)
    setSelectedNo(no ?? null)
    setFormError(null)
    if (no) setSearchParams({ request: no }, { replace: true })
    else if (searchParams.get('request')) setSearchParams({}, { replace: true })
  }

  const resetForm = () => {
    setEditingNo(null)
    setLines([])
    setEntry(emptyEntry())
    setEntryOpen(false)
    setEditingLine(null)
    setEntryError(null)
    setReason('')
    setExpectedDeliverables('')
  }

  const startNew = () => {
    resetForm()
    goTo('form')
  }

  const startEdit = (row: OvertimeWorkRow) => {
    setEditingNo(row.requestNo)
    setLines(
      sortLines(
        (row.lines?.length
          ? row.lines
          : [
              {
                overtimeDate: row.overtimeDate,
                startTime: row.overtimeFrom,
                endTime: row.overtimeTo,
                dayType: 'working' as OvertimeDayType,
                workLocation: row.workLocation || ('office' as OvertimeWorkLocation),
                reason: row.reason,
                totalHours: row.totalHours,
              },
            ]
        ).map((line) => ({
          overtimeDate: line.overtimeDate,
          startTime: line.startTime,
          endTime: line.endTime,
          dayType: line.dayType,
          workLocation: line.workLocation || row.workLocation || 'office',
          reason: line.reason,
        })),
      ),
    )
    setReason(row.reason)
    setExpectedDeliverables(row.expectedDeliverables)
    setEntry(emptyEntry())
    setEntryOpen(false)
    setEditingLine(null)
    goTo('form')
  }

  const remember = (request: OvertimeWorkRow) => {
    queryClient.setQueryData<OvertimeWorkRow[]>(LIST_KEY, (current = []) => [
      request,
      ...current.filter((row) => row.requestNo !== request.requestNo),
    ])
    void queryClient.invalidateQueries({ queryKey: LIST_KEY })
    void queryClient.invalidateQueries({ queryKey: ['hr', 'overtime-work-approved'] })
  }

  const saveMutation = useMutation({
    mutationFn: saveOvertimeWorkRequest,
    onSuccess: (request, input) => {
      remember(request)
      toast.success(
        input.submit ? 'Overtime work request submitted' : 'Draft saved',
        input.submit
          ? `${request.requestNo} was sent for Superior → FAD approval (Stage 1 work authorization).`
          : `${request.requestNo} is saved as a draft.`,
      )
      setEditingNo(null)
      goTo('detail', request.requestNo)
    },
    onError: (error) => {
      setFormError(error instanceof Error ? error.message : 'Could not save the overtime work request.')
    },
  })

  const withdrawMutation = useMutation({
    mutationFn: withdrawOvertimeWorkRequest,
    onSuccess: (request) => {
      remember(request)
      toast.success('Withdrawn', `${request.requestNo} is a draft again.`)
      goTo('detail', request.requestNo)
    },
    onError: (error) => toast.error(error instanceof Error ? error.message : 'Withdraw failed'),
  })

  const deleteMutation = useMutation({
    mutationFn: deleteOvertimeWorkRequest,
    onSuccess: (_, requestNo) => {
      queryClient.setQueryData<OvertimeWorkRow[]>(LIST_KEY, (current = []) =>
        current.filter((row) => row.requestNo !== requestNo),
      )
      toast.success('Draft deleted')
      goTo('list')
    },
    onError: (error) => toast.error(error instanceof Error ? error.message : 'Delete failed'),
  })

  const lineProblem = (draft: EntryDraft, others: WorkLineInput[]) => {
    if (!draft.overtimeDate) return 'Choose the overtime date.'
    if (!draft.startTime) return 'Enter the start time.'
    if (!draft.endTime) return 'Enter the end time.'
    if (splitOvertimeHours(draft.startTime, draft.endTime, 'working').totalHours <= 0) {
      return 'The end time must be different from the start time.'
    }
    if (!draft.dayType) return 'Choose the overtime category.'
    if (!draft.workLocation) return 'Choose the work location.'
    const clash = others.find(
      (other) =>
        other.overtimeDate === draft.overtimeDate &&
        other.startTime < draft.endTime &&
        draft.startTime < other.endTime,
    )
    if (clash) {
      return `It overlaps ${shortDate(clash.overtimeDate)} ${clockText(clash.startTime)} – ${clockText(clash.endTime)}.`
    }
    return null
  }

  const saveLine = () => {
    const others = lines.filter((_, index) => index !== editingLine)
    const problem = lineProblem(entry, others)
    if (problem || !entry.dayType || !entry.workLocation) {
      setEntryError(problem ?? 'Choose the overtime category and work location.')
      return
    }
    // Line reason is not collected here — the single Justification section below covers it.
    const line: WorkLineInput = {
      overtimeDate: entry.overtimeDate,
      startTime: entry.startTime,
      endTime: entry.endTime,
      dayType: entry.dayType,
      workLocation: entry.workLocation,
      reason: reason.trim() || entry.reason.trim(),
    }
    setLines(sortLines(editingLine === null ? [...lines, line] : lines.map((item, i) => (i === editingLine ? line : item))))
    setEntry(emptyEntry())
    setEditingLine(null)
    setEntryOpen(false)
    setEntryError(null)
    setFormError(null)
  }

  const submit = (forApproval: boolean) => {
    setFormError(null)
    let all = lines
    if (entryOpen && (entry.overtimeDate || entry.startTime || entry.endTime || entry.dayType || entry.workLocation)) {
      const others = lines.filter((_, index) => index !== editingLine)
      const problem = lineProblem(entry, others)
      if (problem || !entry.dayType || !entry.workLocation) {
        setEntryError(problem ?? 'Choose the overtime category and work location.')
        setFormError('Save or cancel the overtime line you are entering first.')
        return
      }
      const savedLine: WorkLineInput = {
        overtimeDate: entry.overtimeDate,
        startTime: entry.startTime,
        endTime: entry.endTime,
        dayType: entry.dayType,
        workLocation: entry.workLocation,
        reason: reason.trim(),
      }
      all = sortLines(
        editingLine === null
          ? [...lines, savedLine]
          : lines.map((item, i) => (i === editingLine ? savedLine : item)),
      )
    }
    if (!all.length) {
      setFormError('Click Add Line to enter overtime: date, times, category, and work location, then Save.')
      return
    }
    if (forApproval && reason.trim().length < 5) {
      setFormError('Enter the reason / justification for overtime.')
      return
    }
    if (forApproval && expectedDeliverables.trim().length < 3) {
      setFormError('Enter the expected deliverables / outputs.')
      return
    }
    const overallReason = reason.trim()
    const sorted = sortLines(all)
    // BC 1.0.3.636: send period + daily lines together (Portal-Handoff-1.0.3.636).
    const periodStartDate = sorted[0]?.overtimeDate ?? ''
    const periodEndDate = sorted[sorted.length - 1]?.overtimeDate ?? ''
    saveMutation.mutate({
      requestNo: editingNo ?? undefined,
      details: {
        reason: overallReason,
        expectedDeliverables: expectedDeliverables.trim(),
        periodStartDate,
        periodEndDate,
        // Stamp the single justification onto each line for payment / approvals.
        lines: sorted.map((line) => ({ ...line, reason: overallReason || line.reason })),
      },
      submit: forApproval,
    })
  }

  const columns: DataTableColumn<OvertimeWorkRow>[] = [
    { id: 'no', header: 'No.', cell: (row) => row.requestNo },
    {
      id: 'date',
      header: 'OT date',
      cell: (row) => dateRangeLabel(row.lines ?? [], row.overtimeDate),
    },
    {
      id: 'hours',
      header: 'Hours',
      cell: (row) => `${row.totalHours}h${(row.lines?.length ?? 0) > 1 ? ` · ${row.lines.length} lines` : ''}`,
    },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
    { id: 'updated', header: 'Updated', cell: (row) => formatDateTime(row.submittedAt || row.createdAt) },
  ]

  const headerActions =
    mode === 'list' ? (
      <PortalNewButton label="New overtime request" onClick={startNew} />
    ) : (
      <div className="flex flex-wrap gap-2">
        {shown?.status === 'Draft' || shown?.status === 'Rejected' ? (
          <>
            <Button type="button" variant="outline" onClick={() => startEdit(shown)}>
              Edit
            </Button>
            <Button
              type="button"
              variant="outline"
              disabled={deleteMutation.isPending}
              onClick={async () => {
                const yes = await confirm({
                  title: `Delete draft ${shown.requestNo}?`,
                  message: 'This cannot be undone.',
                  confirmLabel: 'Delete',
                  tone: 'danger',
                })
                if (yes) deleteMutation.mutate(shown.requestNo)
              }}
            >
              <Trash2 className="mr-2 h-4 w-4" />
              Delete
            </Button>
          </>
        ) : null}
        {shown?.status === 'Pending Approval' ? (
          <Button
            type="button"
            variant="outline"
            disabled={withdrawMutation.isPending}
            onClick={async () => {
              const yes = await confirm({
                title: `Withdraw ${shown.requestNo}?`,
                message: 'It returns to draft so you can correct it.',
                confirmLabel: 'Withdraw',
              })
              if (yes) withdrawMutation.mutate(shown.requestNo)
            }}
          >
            <Undo2 className="mr-2 h-4 w-4" />
            Withdraw
          </Button>
        ) : null}
        {shown ? (
          <Button
            type="button"
            variant="outline"
            onClick={() => {
              if (!printWorkRequest(shown)) toast.error('Allow pop-ups to print this overtime work request.')
            }}
          >
            <Printer className="mr-2 h-4 w-4" />
            Print
          </Button>
        ) : null}
        <Button type="button" variant="outline" onClick={() => goTo('list')}>
          <ArrowLeft className="mr-2 h-4 w-4" />
          My requests
        </Button>
        <PortalNewButton label="New overtime request" onClick={startNew} />
      </div>
    )

  return (
    <PageWrapper
      title="Overtime Request"
      description="Stage 1 — work authorization. Approvers: Superior → FAD. Approved means you may work the overtime; hours are not on the overtime sheet yet. After the work is done, raise Stage 2 Overtime Payment Request."
      actions={headerActions}
    >
      <div className="mb-4 rounded-xl border border-teal-100 bg-teal-50/70 px-4 py-3 text-sm text-teal-950">
        <p className="font-semibold">Stage 1 (work authorization) → Stage 2 (payment)</p>
        <p className="mt-1 text-teal-900/90">
          Enter the overtime period and daily lines (date, start/end time). Superior then FAD approve the work.
          After completion, use{' '}
          <Link className="font-semibold underline-offset-2 hover:underline" to="/hr/overtime-request">
            Overtime Payment Request
          </Link>{' '}
          — Superior justification is required on Stage 2; only then are hours added to the overtime sheet.
        </p>
      </div>

      {mode === 'list' ? (
        <div className="portal-surface-card overflow-hidden rounded-2xl border border-slate-200 bg-white">
          <div className="border-b border-slate-100 px-4 py-3">
            <h2 className="text-sm font-semibold text-slate-900">My Overtime Requests</h2>
            <p className="mt-0.5 text-xs text-slate-500">Stage 1 work authorization — Superior, then FAD (Business Central).</p>
          </div>
          {listQuery.isLoading ? (
            <div className="space-y-2 p-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          ) : (
            <DataTable
              columns={columns}
              rows={rows}
              getRowId={(row) => row.requestNo}
              emptyTitle="No overtime work requests yet."
              onRowClick={(row) => goTo('detail', row.requestNo)}
            />
          )}
        </div>
      ) : null}

      {mode === 'detail' && shown ? (
        <div className="space-y-4">
          <div className="flex flex-wrap items-center gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3">
            <span className="text-sm font-semibold text-slate-900">{shown.requestNo}</span>
            <StatusBadge status={shown.status} />
            <span className="text-sm text-slate-600">
              {dateRangeLabel(shown.lines ?? [], shown.overtimeDate)} · {shown.totalHours} hrs
            </span>
            {shown.canRequestPayment ? (
              <Link
                className="ml-auto inline-flex items-center rounded-lg bg-teal-700 px-3 py-1.5 text-xs font-semibold text-white hover:bg-teal-800"
                to={`/hr/overtime-request?otRequestNo=${encodeURIComponent(shown.requestNo)}`}
              >
                Request overtime payment
              </Link>
            ) : null}
            {shown.status === 'Approved' && shown.linkedPaymentRequestNo ? (
              <Link
                className="ml-auto text-xs font-medium text-teal-800 underline-offset-2 hover:underline"
                to={`/hr/overtime-request?request=${encodeURIComponent(shown.linkedPaymentRequestNo)}`}
              >
                Payment {shown.linkedPaymentRequestNo}
                {shown.paymentApproved ? ' · approved' : ''}
              </Link>
            ) : null}
          </div>
          {shown.canRequestPayment ? (
            <div className="rounded-xl border border-teal-100 bg-teal-50/70 px-4 py-3 text-sm text-teal-950">
              Work authorized — submit an Overtime Payment Request after the work is done. Hours are added to the
              overtime sheet only after Stage 2 approval.
            </div>
          ) : null}
          <section className="rounded-2xl border border-slate-200 bg-white p-4">
            <h3 className="mb-3 flex items-center gap-2 text-sm font-semibold text-slate-900">
              <ClipboardList className="h-4 w-4" /> Overtime lines
            </h3>
            <ul className="space-y-2">
              {(shown.lines?.length
                ? shown.lines
                : [
                    {
                      overtimeDate: shown.overtimeDate,
                      startTime: shown.overtimeFrom,
                      endTime: shown.overtimeTo,
                      dayType: 'working' as OvertimeDayType,
                      workLocation: shown.workLocation || ('office' as OvertimeWorkLocation),
                      reason: shown.reason,
                      totalHours: shown.totalHours,
                    },
                  ]
              ).map((line, index) => (
                <li
                  key={`${line.overtimeDate}-${line.startTime}-${index}`}
                  className="grid gap-1 rounded-lg border border-slate-100 px-3 py-2 text-sm md:grid-cols-[7rem_1fr_7rem_5rem_auto]"
                >
                  <span className="font-medium">{shortDate(line.overtimeDate)}</span>
                  <span>
                    {clockText(line.startTime)} – {clockText(line.endTime)} ·{' '}
                    {DAY_TYPES.find((d) => d.value === line.dayType)?.label.split(' (')[0] ?? line.dayType}
                  </span>
                  <span className="inline-flex items-center gap-1 text-slate-600">
                    <MapPin className="h-3.5 w-3.5 shrink-0" />
                    {locationLabel(line.workLocation)}
                  </span>
                  <span className="tabular-nums text-slate-600">{line.totalHours}h</span>
                  <span className="truncate text-slate-500" title={line.reason}>
                    {line.reason || '—'}
                  </span>
                </li>
              ))}
            </ul>
            <dl className="mt-4 grid gap-3 text-sm md:grid-cols-2">
              <div>
                <dt className="text-xs text-slate-500">Overall justification</dt>
                <dd className="mt-0.5 whitespace-pre-wrap text-slate-900">{shown.reason || '—'}</dd>
              </div>
              <div>
                <dt className="text-xs text-slate-500">Expected deliverables</dt>
                <dd className="mt-0.5 whitespace-pre-wrap text-slate-900">{shown.expectedDeliverables || '—'}</dd>
              </div>
            </dl>
          </section>
          <section className="rounded-2xl border border-slate-200 bg-white p-4">
            <h3 className="mb-3 text-sm font-semibold text-slate-900">Approval chain</h3>
            <ol className="space-y-2">
              {shown.steps.map((step) => (
                <li
                  key={step.stage}
                  className="flex flex-wrap items-center justify-between gap-2 rounded-lg border border-slate-100 px-3 py-2 text-sm"
                >
                  <span>
                    {step.stage}. {step.label} — {step.approverName || step.approverUserId || 'Not set'}
                  </span>
                  <StatusBadge status={step.status === 'Pending' ? 'Pending Approval' : step.status} />
                </li>
              ))}
            </ol>
          </section>
        </div>
      ) : null}

      {mode === 'form' ? (
        <div className="space-y-4">
          {formError ? (
            <div className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{formError}</div>
          ) : null}

          <section className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
            <header className="flex items-center gap-2 bg-[var(--portal-navy)] px-4 py-2.5 text-sm font-semibold text-white">
              <User className="h-4 w-4" /> Employee Information
            </header>
            <div className="grid gap-3 p-4 md:grid-cols-2">
              <ReadField label="Employee Name" value={employee?.employeeName} />
              <ReadField label="Employee No." value={employee?.employeeNo} />
              <ReadField label="Designation" value={employee?.designation} />
              <ReadField label="Department" value={employee?.departmentName || employee?.departmentCode} />
            </div>
          </section>

          <section className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
            <header className="flex items-center justify-between gap-2 bg-[var(--portal-navy)] px-4 py-2.5 text-sm font-semibold text-white">
              <span className="inline-flex items-center gap-2">
                <CalendarDays className="h-4 w-4" /> Overtime Details (period + daily dates)
              </span>
              <span className="rounded-full bg-white/15 px-2.5 py-0.5 text-xs font-medium tabular-nums">
                {totalHours.toFixed(2)} hrs
              </span>
            </header>
            <div className="p-4">
              <p className="mb-3 text-sm text-slate-600">
                Add <span className="font-medium text-slate-800">one line per overtime day</span>. Use{' '}
                <span className="font-medium text-slate-800">Edit</span> on any saved line to change its{' '}
                <span className="font-medium text-slate-800">Overtime Date</span>, start/end time, category, or
                location. The request period is from the earliest to the latest line date
                {lines.length
                  ? ` (${shortDate(sortLines(lines)[0]!.overtimeDate)} → ${shortDate(sortLines(lines)[lines.length - 1]!.overtimeDate)})`
                  : ''}
                .
              </p>
              {lines.length ? (
                <ul className="mb-4 space-y-2">
                  {lines.map((line, index) => (
                    <li
                      key={`${line.overtimeDate}-${line.startTime}-${index}`}
                      className="flex flex-wrap items-center gap-2 rounded-lg border border-slate-100 bg-slate-50/80 px-3 py-2 text-sm"
                    >
                      <span className="font-medium text-slate-900">{shortDate(line.overtimeDate)}</span>
                      <span className="text-slate-600">
                        {clockText(line.startTime)} – {clockText(line.endTime)}
                      </span>
                      <span className="text-slate-600">
                        {DAY_TYPES.find((d) => d.value === line.dayType)?.label.split(' (')[0]}
                      </span>
                      <span className="inline-flex items-center gap-1 text-slate-600">
                        <MapPin className="h-3.5 w-3.5" />
                        {locationLabel(line.workLocation)}
                      </span>
                      <span className="tabular-nums text-slate-700">
                        {splitOvertimeHours(line.startTime, line.endTime, line.dayType).totalHours.toFixed(2)}h
                      </span>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => {
                          setEntry({
                            overtimeDate: line.overtimeDate,
                            startTime: line.startTime,
                            endTime: line.endTime,
                            dayType: line.dayType,
                            workLocation: line.workLocation,
                            reason: line.reason,
                          })
                          setEditingLine(index)
                          setEntryOpen(true)
                          setEntryError(null)
                        }}
                      >
                        Edit
                      </Button>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => {
                          setLines(lines.filter((_, i) => i !== index))
                          if (editingLine === index) {
                            setEntryOpen(false)
                            setEditingLine(null)
                          }
                        }}
                      >
                        Delete
                      </Button>
                    </li>
                  ))}
                </ul>
              ) : null}

              {entryOpen ? (
                <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
                  <p className="text-sm font-semibold text-slate-900">
                    {editingLine === null ? 'New Line' : `Edit Line ${editingLine + 1}`}
                  </p>
                  <div className="mt-4 grid gap-4 md:grid-cols-2">
                    <div className="space-y-1.5">
                      <Label htmlFor="otw-date">Overtime Date *</Label>
                      <Input
                        id="otw-date"
                        type="date"
                        value={entry.overtimeDate}
                        onChange={(event) => setEntry((current) => ({ ...current, overtimeDate: event.target.value }))}
                      />
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="otw-category">Overtime Category *</Label>
                      <Select
                        id="otw-category"
                        value={entry.dayType}
                        options={DAY_TYPES}
                        placeholder="Select category"
                        onChange={(event) =>
                          setEntry((current) => ({ ...current, dayType: event.target.value as OvertimeDayType }))
                        }
                      />
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="otw-start">Start Time *</Label>
                      <ClockTimePicker
                        id="otw-start"
                        value={entry.startTime}
                        title="Select start time"
                        defaultMeridiem="AM"
                        onChange={(value) => setEntry((current) => ({ ...current, startTime: value }))}
                      />
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="otw-end">End Time *</Label>
                      <ClockTimePicker
                        id="otw-end"
                        value={entry.endTime}
                        title="Select end time"
                        defaultMeridiem="PM"
                        onChange={(value) => setEntry((current) => ({ ...current, endTime: value }))}
                      />
                    </div>
                    <div className="space-y-1.5 md:col-span-2">
                      <Label htmlFor="otw-line-location" className="inline-flex items-center gap-1">
                        <MapPin className="h-3.5 w-3.5" /> Work location *
                      </Label>
                      <Select
                        id="otw-line-location"
                        value={entry.workLocation}
                        options={LOCATION_OPTIONS}
                        placeholder="Select location"
                        onChange={(event) =>
                          setEntry((current) => ({
                            ...current,
                            workLocation: event.target.value as OvertimeWorkLocation,
                          }))
                        }
                      />
                    </div>
                    <div className="md:col-span-2">
                      <p className="text-xs font-medium text-slate-600">Calculated Hours</p>
                      <p className="mt-1 text-xl font-bold tabular-nums text-slate-900">
                        {entryHours.totalHours.toFixed(2)} Hours
                      </p>
                      <p className="mt-1 text-xs text-slate-500">
                        Reason / justification is entered once below under Justification.
                      </p>
                    </div>
                  </div>
                  {entryError ? <p className="mt-3 text-sm text-red-700">{entryError}</p> : null}
                  <div className="mt-4 flex justify-end gap-2">
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => {
                        setEntry(emptyEntry())
                        setEntryOpen(false)
                        setEditingLine(null)
                        setEntryError(null)
                      }}
                    >
                      Cancel
                    </Button>
                    <Button type="button" className="bg-emerald-600 text-white hover:bg-emerald-700" onClick={saveLine}>
                      <Save className="mr-2 h-4 w-4" />
                      Save
                    </Button>
                  </div>
                </div>
              ) : (
                <button
                  type="button"
                  className="flex w-full items-center justify-center gap-2 rounded-full border border-slate-300 bg-white py-2.5 text-sm font-medium text-slate-800 transition hover:bg-slate-50"
                  onClick={() => {
                    setEntry(emptyEntry())
                    setEditingLine(null)
                    setEntryOpen(true)
                    setEntryError(null)
                  }}
                >
                  <Plus className="h-4 w-4" />
                  Add Line
                </button>
              )}
            </div>
          </section>

          <section className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
            <header className="flex items-center gap-2 bg-[var(--portal-navy)] px-4 py-2.5 text-sm font-semibold text-white">
              <ClipboardList className="h-4 w-4" /> Justification
            </header>
            <div className="grid gap-4 p-4">
              <div className="space-y-1.5">
                <Label htmlFor="otw-reason">Reason / justification for overtime *</Label>
                <Textarea
                  id="otw-reason"
                  rows={3}
                  value={reason}
                  placeholder="Why is this overtime needed?"
                  onChange={(event) => setReason(event.target.value)}
                />
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="otw-deliverables">Expected deliverables / outputs *</Label>
                <Textarea
                  id="otw-deliverables"
                  rows={3}
                  value={expectedDeliverables}
                  placeholder="What will be delivered from this overtime?"
                  onChange={(event) => setExpectedDeliverables(event.target.value)}
                />
              </div>
            </div>
          </section>

          <div className="flex flex-wrap gap-2">
            <Button type="button" variant="outline" disabled={saveMutation.isPending} onClick={() => submit(false)}>
              <Save className="mr-2 h-4 w-4" />
              Save draft
            </Button>
            <Button type="button" variant="gradient" disabled={saveMutation.isPending} onClick={() => submit(true)}>
              <Send className="mr-2 h-4 w-4" />
              Submit for approval
            </Button>
          </div>
        </div>
      ) : null}
    </PageWrapper>
  )
}

function ReadField({ label, value }: { label: string; value?: string }) {
  return (
    <div>
      <p className="text-xs text-slate-500">{label}</p>
      <p className="mt-0.5 rounded-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900">
        {value?.trim() || '—'}
      </p>
    </div>
  )
}
