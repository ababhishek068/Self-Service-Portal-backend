import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { format, isValid, parseISO } from 'date-fns'
import {
  AlertTriangle,
  ArrowLeft,
  ArrowRight,
  BarChart3,
  CalendarDays,
  CheckCircle2,
  Clock,
  Flag,
  History,
  Info,
  Landmark,
  MinusCircle,
  Network,
  Pencil,
  RefreshCw,
  Save,
  Send,
  ShieldCheck,
  Trash2,
  Undo2,
  User,
  UserCog,
  Users,
  Wallet,
  XCircle,
} from 'lucide-react'
import { useMemo, useState, type ReactNode } from 'react'
import { useSearchParams } from 'react-router-dom'
import {
  deleteOvertimeRequest,
  estimateOvertimeAmount,
  fetchOvertimeContext,
  fetchOvertimeRequests,
  saveOvertimeRequest,
  splitOvertimeHours,
  withdrawOvertimeRequest,
  type OvertimeContext,
  type OvertimeDayType,
  type OvertimeDetails,
  type OvertimeRequest as OvertimeRequestRow,
  type OvertimeStep,
} from '@/api/endpoints/overtime'
import { getLocalPurchaseProjects } from '@/api/endpoints/requestEndpoint'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import { cn } from '@/lib/utils'
import { formatAmount, formatDateTime } from '@/utils/formatters'

const LIST_KEY = ['hr', 'overtime-requests'] as const
const CONTEXT_KEY = ['hr', 'overtime-context'] as const

const DAY_TYPES: Array<{ value: OvertimeDayType; label: string }> = [
  { value: 'working', label: 'Working day (normal day 6 AM–10 PM / night)' },
  { value: 'restDay', label: 'Weekly rest day' },
  { value: 'holiday', label: 'Public holiday' },
]

type Mode = 'form' | 'list' | 'detail'

function localToday() {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

function emptyDetails(): OvertimeDetails {
  return { overtimeDate: localToday(), startTime: '17:00', endTime: '21:00', dayType: 'working', reason: '', projectNo: '' }
}

function detailsOf(request: OvertimeRequestRow): OvertimeDetails {
  return {
    overtimeDate: request.overtimeDate,
    startTime: request.startTime,
    endTime: request.endTime,
    dayType: request.dayType,
    reason: request.reason,
    projectNo: request.projectNo,
  }
}

function prettyDate(value: string) {
  const parsed = parseISO(value)
  return value && isValid(parsed) ? format(parsed, 'd MMM yyyy') : value
}

function hoursText(value: number) {
  return `${Number(value.toFixed(2)).toFixed(2)} hrs`
}

function rateText(value: number) {
  return `${Number(value.toFixed(2))}x`
}

/** The rate(s) that apply, as the template's Rate Type. */
function rateType(hours: ReturnType<typeof splitOvertimeHours>, dayType: OvertimeDayType, rates: OvertimeContext['rates']) {
  if (dayType === 'restDay') return `${rateText(rates.restDay)} (weekly rest day)`
  if (dayType === 'holiday') return `${rateText(rates.holiday)} (public holiday)`
  if (hours.normalHours && hours.nightHours) {
    return `${rateText(rates.normal)} normal day + ${rateText(rates.night)} night`
  }
  if (hours.nightHours) return `${rateText(rates.night)} (night, 10 PM–6 AM)`
  return `${rateText(rates.normal)} (normal day)`
}

function bandsText(hours: ReturnType<typeof splitOvertimeHours>) {
  return [
    hours.normalHours ? `${hoursText(hours.normalHours)} normal day` : '',
    hours.nightHours ? `${hoursText(hours.nightHours)} night` : '',
    hours.restDayHours ? `${hoursText(hours.restDayHours)} rest day` : '',
    hours.holidayHours ? `${hoursText(hours.holidayHours)} public holiday` : '',
  ]
    .filter(Boolean)
    .join(' · ')
}

/** Pending and approved hours of the employee in the month of `date`, without `exceptNo`. */
function monthHours(rows: OvertimeRequestRow[], date: string, exceptNo: string) {
  const month = date.slice(0, 7)
  return rows
    .filter((row) => row.requestNo !== exceptNo && row.overtimeDate.slice(0, 7) === month)
    .filter((row) => row.status === 'Pending Approval' || row.status === 'Approved')
    .reduce((total, row) => total + row.totalHours, 0)
}

function waitingFor(row: OvertimeRequestRow) {
  if (row.status === 'Pending Approval') {
    const step = row.steps.find((item) => item.status === 'Pending')
    return step ? `${step.label} · ${step.approverName}` : row.stageLabel
  }
  if (row.status === 'Approved') {
    if (row.sentToPayroll) return `Payroll · ${row.payrollPeriodName || 'sent'}`
    if (row.addedToSheet) return `Payroll · on sheet ${row.sheetNo}`
    return 'Payroll · HR adds it to the overtime sheet'
  }
  if (row.status === 'Rejected') return row.rejectedAtStage ? `Rejected by ${row.rejectedAtStage}` : ''
  return 'Draft · not submitted'
}

function Section({ icon, title, children, className }: { icon: ReactNode; title: string; children: ReactNode; className?: string }) {
  return (
    <section className={cn('overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm', className)}>
      <header className="flex items-center gap-2 bg-[var(--portal-navy)] px-4 py-2.5 text-sm font-semibold text-white">
        {icon}
        {title}
      </header>
      <div className="p-4">{children}</div>
    </section>
  )
}

function Field({ label, required, children, htmlFor }: { label: string; required?: boolean; children: ReactNode; htmlFor?: string }) {
  return (
    <div className="grid gap-1.5 sm:grid-cols-[9.5rem_1fr] sm:items-center sm:gap-3">
      <Label htmlFor={htmlFor} className="text-sm text-slate-700">
        {label}
        {required ? <span className="text-red-500"> *</span> : null}
      </Label>
      <div className="min-w-0">{children}</div>
    </div>
  )
}

function ReadValue({ value, placeholder = '—' }: { value?: string; placeholder?: string }) {
  return (
    <div className="min-h-10 rounded-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900">
      {value?.trim() ? value : <span className="text-slate-400">{placeholder}</span>}
    </div>
  )
}

type StepView = { key: string; label: string; icon: ReactNode; person: string; status: string; tone: 'done' | 'pending' | 'rejected' | 'idle' | 'skipped' | 'info'; at: string; note: string }

const STEP_ICONS: Record<number, ReactNode> = {
  1: <Users className="h-5 w-5" />,
  2: <ShieldCheck className="h-5 w-5" />,
  3: <UserCog className="h-5 w-5" />,
  4: <Landmark className="h-5 w-5" />,
}

function approverStep(step: OvertimeStep): StepView {
  const tone: StepView['tone'] =
    step.status === 'Approved'
      ? 'done'
      : step.status === 'Pending'
        ? 'pending'
        : step.status === 'Rejected'
          ? 'rejected'
          : step.status === 'Skipped'
            ? 'skipped'
            : 'idle'
  return {
    key: `stage-${step.stage}`,
    label: step.label,
    icon: STEP_ICONS[step.stage] ?? <Users className="h-5 w-5" />,
    person: step.approverName || step.approverUserId || 'Not set in BC',
    status: step.status === 'Not started' ? 'Not started' : step.status,
    tone,
    at: step.decidedAt,
    note: step.status === 'Skipped' ? step.skipReason : step.comment,
  }
}

function workflowSteps(request: OvertimeRequestRow | null, context: OvertimeContext | undefined, employeeName: string): StepView[] {
  // A draft has no approvers yet: show who it would go to now (BC resolves them again on submit).
  const steps =
    request && request.status !== 'Draft' && request.steps.length ? request.steps : (context?.approvers ?? [])
  const submitted = request && request.status !== 'Draft'
  const payroll: StepView = (() => {
    if (request?.sentToPayroll) {
      return { key: 'payroll', label: 'Payroll', icon: <Flag className="h-5 w-5" />, person: request.payrollPeriodName, status: 'Sent to payroll', tone: 'done', at: request.sentToPayrollAt, note: request.sheetNo }
    }
    if (request?.addedToSheet) {
      return { key: 'payroll', label: 'Payroll', icon: <Flag className="h-5 w-5" />, person: request.payrollPeriodName, status: `On sheet ${request.sheetNo}`, tone: 'info', at: request.addedAt, note: 'HR sends the overtime sheet to payroll' }
    }
    if (request?.status === 'Approved') {
      return { key: 'payroll', label: 'Payroll', icon: <Flag className="h-5 w-5" />, person: 'HR', status: 'Waiting for HR', tone: 'pending', at: '', note: request.sheetNote }
    }
    return { key: 'payroll', label: 'Payroll', icon: <Flag className="h-5 w-5" />, person: 'Overtime sheet', status: 'Not started', tone: 'idle', at: '', note: '' }
  })()
  return [
    {
      key: 'employee',
      label: 'Employee',
      icon: <User className="h-5 w-5" />,
      person: request?.employeeName || employeeName,
      status: submitted ? 'Submitted' : 'Draft',
      tone: submitted ? 'done' : 'idle',
      at: submitted ? request.submittedAt : '',
      note: '',
    },
    ...steps.map(approverStep),
    payroll,
  ]
}

const TONE_STYLES: Record<StepView['tone'], { circle: string; pill: string; Icon: typeof CheckCircle2 }> = {
  done: { circle: 'bg-emerald-600 text-white', pill: 'bg-emerald-50 text-emerald-700 ring-emerald-200', Icon: CheckCircle2 },
  pending: { circle: 'bg-amber-500 text-white', pill: 'bg-amber-50 text-amber-800 ring-amber-200', Icon: Clock },
  rejected: { circle: 'bg-red-600 text-white', pill: 'bg-red-50 text-red-700 ring-red-200', Icon: XCircle },
  info: { circle: 'bg-[var(--portal-navy)] text-white', pill: 'bg-blue-50 text-blue-800 ring-blue-200', Icon: CheckCircle2 },
  skipped: { circle: 'bg-slate-300 text-white', pill: 'bg-slate-50 text-slate-500 ring-slate-200', Icon: MinusCircle },
  idle: { circle: 'bg-slate-200 text-slate-600', pill: 'bg-slate-50 text-slate-600 ring-slate-200', Icon: Clock },
}

function WorkflowTracker({ steps }: { steps: StepView[] }) {
  return (
    <ol className="grid gap-3 sm:grid-cols-3 lg:flex lg:items-start lg:gap-1">
      {steps.map((step, index) => {
        const style = TONE_STYLES[step.tone]
        return (
          <li key={step.key} className="flex min-w-0 items-start gap-1 lg:flex-1">
            <div className="flex min-w-0 flex-1 flex-col items-center text-center">
              <span className={cn('relative flex h-11 w-11 items-center justify-center rounded-full shadow-sm', style.circle)}>
                {step.icon}
                <span className="absolute -right-1 -top-1 flex h-5 w-5 items-center justify-center rounded-full bg-white text-[10px] font-bold text-[var(--portal-navy)] ring-1 ring-slate-200">
                  {index + 1}
                </span>
              </span>
              <p className="mt-2 text-sm font-semibold text-slate-900">{step.label}</p>
              <p className="max-w-full truncate text-xs text-slate-500" title={step.person}>{step.person || '—'}</p>
              <span className={cn('mt-1.5 inline-flex items-center gap-1 rounded-full px-2.5 py-0.5 text-xs font-medium ring-1', style.pill)}>
                <style.Icon className="h-3.5 w-3.5" />
                {step.status}
              </span>
              {step.at ? <p className="mt-1 text-[11px] text-slate-500">{formatDateTime(step.at)}</p> : null}
              {step.note ? <p className="mt-1 line-clamp-3 text-[11px] italic text-slate-500" title={step.note}>{step.note}</p> : null}
            </div>
            {index < steps.length - 1 ? (
              <ArrowRight className="mt-3 hidden h-5 w-5 shrink-0 text-slate-400 lg:block" aria-hidden />
            ) : null}
          </li>
        )
      })}
    </ol>
  )
}

function CheckRow({ ok, text, warn }: { ok: boolean; text: string; warn?: boolean }) {
  return (
    <li className="flex items-start gap-2 text-sm">
      {ok ? (
        <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0 text-emerald-600" />
      ) : (
        <AlertTriangle className={cn('mt-0.5 h-4 w-4 shrink-0', warn ? 'text-amber-600' : 'text-red-600')} />
      )}
      <span className={ok ? 'text-slate-800' : warn ? 'text-amber-900' : 'text-red-800'}>{text}</span>
    </li>
  )
}

export function OvertimeRequest() {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const [searchParams, setSearchParams] = useSearchParams()
  const [mode, setMode] = useState<Mode>(searchParams.get('request') ? 'detail' : 'form')
  const [selectedNo, setSelectedNo] = useState<string | null>(searchParams.get('request'))
  const [editingNo, setEditingNo] = useState<string | null>(null)
  const [details, setDetails] = useState<OvertimeDetails>(emptyDetails)
  const [formError, setFormError] = useState<string | null>(null)

  const contextQuery = useQuery({ queryKey: CONTEXT_KEY, queryFn: fetchOvertimeContext, staleTime: 60_000 })
  const listQuery = useQuery({
    queryKey: LIST_KEY,
    queryFn: fetchOvertimeRequests,
    refetchOnWindowFocus: true,
    refetchInterval: mode === 'form' ? false : 20_000,
    staleTime: 15_000,
  })
  const projectsQuery = useQuery({
    queryKey: ['local-purchase', 'projects'],
    queryFn: getLocalPurchaseProjects,
    staleTime: 10 * 60_000,
    enabled: mode === 'form',
  })

  const context = contextQuery.data
  const rows = useMemo(() => listQuery.data ?? [], [listQuery.data])
  const selected = useMemo(() => rows.find((row) => row.requestNo === selectedNo) ?? null, [rows, selectedNo])

  // A link to another request (e.g. from the bell) while the page is open shows that request.
  const requestedNo = searchParams.get('request')
  const [linkedNo, setLinkedNo] = useState(requestedNo)
  if (requestedNo !== linkedNo) {
    setLinkedNo(requestedNo)
    if (requestedNo && requestedNo !== selectedNo) {
      setSelectedNo(requestedNo)
      setMode('detail')
    }
  }

  const hours = useMemo(
    () => splitOvertimeHours(details.startTime, details.endTime, details.dayType),
    [details.startTime, details.endTime, details.dayType],
  )
  const rates = context?.rates ?? { normal: 1.5, night: 1.75, restDay: 2, holiday: 2.5 }
  const estimate = context ? estimateOvertimeAmount(hours, context.hourlyRate, rates) : 0
  const monthTotal = monthHours(rows, details.overtimeDate, editingNo ?? '') + hours.totalHours
  const limit = context?.maxHoursPerMonth ?? 0
  const dateObject = parseISO(details.overtimeDate)
  const weekendHint =
    details.dayType === 'working' && isValid(dateObject) && (dateObject.getDay() === 0 || dateObject.getDay() === 6)
      ? `${format(dateObject, 'EEEE')}: if it is your weekly rest day, choose Weekly rest day.`
      : ''

  const projectOptions = useMemo(
    () => [
      { value: '', label: 'No project' },
      ...(projectsQuery.data?.projects ?? []).map((project) => ({
        value: project.no,
        label: project.description ? `${project.no} · ${project.description}` : project.no,
      })),
    ],
    [projectsQuery.data],
  )

  const goTo = (next: Mode, requestNo: string | null = null) => {
    setMode(next)
    setSelectedNo(requestNo)
    setFormError(null)
    if (requestNo) setSearchParams({ request: requestNo }, { replace: true })
    else if (searchParams.get('request')) setSearchParams({}, { replace: true })
  }

  const startNew = () => {
    setEditingNo(null)
    setDetails(emptyDetails())
    goTo('form')
  }

  const startEdit = (request: OvertimeRequestRow) => {
    setEditingNo(request.requestNo)
    setDetails(detailsOf(request))
    goTo('form')
  }

  const rememberRow = (request: OvertimeRequestRow) => {
    queryClient.setQueryData<OvertimeRequestRow[]>(LIST_KEY, (current = []) => [
      request,
      ...current.filter((row) => row.requestNo !== request.requestNo),
    ])
    void queryClient.invalidateQueries({ queryKey: LIST_KEY })
  }

  const saveMutation = useMutation({
    mutationFn: saveOvertimeRequest,
    onSuccess: (request, input) => {
      rememberRow(request)
      if (input.submit) {
        const first = request.steps.find((step) => step.status === 'Pending')
        toast.success(
          'Overtime request submitted',
          request.status === 'Approved'
            ? `${request.requestNo} is approved and goes to the overtime sheet.`
            : `${request.requestNo} was sent to ${first ? `${first.label} (${first.approverName})` : 'approval'}.`,
        )
      } else {
        toast.success('Draft saved', `${request.requestNo} is saved. Submit it for approval when it is ready.`)
      }
      setEditingNo(null)
      goTo('detail', request.requestNo)
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : 'Please check the form and try again.'
      setFormError(message)
      toast.error('Overtime request not saved', message)
    },
  })

  const withdrawMutation = useMutation({
    mutationFn: withdrawOvertimeRequest,
    onSuccess: (request) => {
      rememberRow(request)
      toast.success('Request withdrawn', `${request.requestNo} is a draft again. Change it and submit, or delete it.`)
    },
    onError: (error) => toast.error('Withdraw failed', error instanceof Error ? error.message : 'Please try again.'),
  })

  const deleteMutation = useMutation({
    mutationFn: deleteOvertimeRequest,
    onSuccess: (_result, requestNo) => {
      queryClient.setQueryData<OvertimeRequestRow[]>(LIST_KEY, (current = []) =>
        current.filter((row) => row.requestNo !== requestNo),
      )
      void queryClient.invalidateQueries({ queryKey: LIST_KEY })
      toast.success('Draft deleted', `${requestNo} was removed.`)
      goTo('list')
    },
    onError: (error) => toast.error('Delete failed', error instanceof Error ? error.message : 'Please try again.'),
  })

  const busy = saveMutation.isPending

  const validate = (submit: boolean) => {
    if (!details.overtimeDate) return 'Enter the overtime date.'
    if (!details.startTime || !details.endTime) return 'Enter the start and end time.'
    if (hours.totalHours <= 0) return 'The end time must be different from the start time.'
    if (submit && details.reason.trim().length < 3) return 'Enter the reason / justification for the overtime.'
    return null
  }

  const send = (submit: boolean) => {
    const problem = validate(submit)
    if (problem) {
      setFormError(problem)
      return
    }
    setFormError(null)
    saveMutation.mutate({ requestNo: editingNo ?? undefined, details, submit })
  }

  const askWithdraw = (request: OvertimeRequestRow) => {
    void confirm({
      title: `Withdraw ${request.requestNo}?`,
      message: 'The approval stops and the request becomes a draft again, so you can change it and submit it again.',
      confirmLabel: 'Withdraw',
      cancelLabel: 'Keep it',
      tone: 'danger',
    }).then((ok) => {
      if (ok) withdrawMutation.mutate(request.requestNo)
    })
  }

  const askDelete = (request: OvertimeRequestRow) => {
    void confirm({
      title: `Delete draft ${request.requestNo}?`,
      message: 'The draft is removed from Business Central. This cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Keep it',
      tone: 'danger',
    }).then((ok) => {
      if (ok) deleteMutation.mutate(request.requestNo)
    })
  }

  const columns: DataTableColumn<OvertimeRequestRow>[] = [
    { id: 'no', header: 'Request No.', cell: (row) => row.requestNo },
    { id: 'date', header: 'Overtime date', cell: (row) => prettyDate(row.overtimeDate) },
    { id: 'time', header: 'Time', cell: (row) => `${row.startTime} – ${row.endTime}` },
    { id: 'category', header: 'Category', cell: (row) => DAY_TYPES.find((type) => type.value === row.dayType)?.label.split(' (')[0] ?? row.dayTypeLabel },
    { id: 'hours', header: 'Hours', cell: (row) => hoursText(row.totalHours) },
    { id: 'amount', header: 'Estimated amount', cell: (row) => formatAmount(row.estimatedAmount) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
    { id: 'waiting', header: 'Where it is', cell: (row) => <span className="text-xs text-slate-600">{waitingFor(row)}</span> },
  ]

  const employeeName = context?.employee.employeeName ?? ''
  const shown = mode === 'detail' ? selected : null
  const shownHours = shown
    ? { totalHours: shown.totalHours, normalHours: shown.normalHours, nightHours: shown.nightHours, restDayHours: shown.restDayHours, holidayHours: shown.holidayHours }
    : hours
  const shownDayType = shown?.dayType ?? details.dayType
  const shownAmount = shown ? shown.estimatedAmount : estimate
  const steps = workflowSteps(mode === 'form' && !editingNo ? null : shown ?? rows.find((row) => row.requestNo === editingNo) ?? null, context, employeeName)
  const routingProblem = context?.routingProblem ?? ''

  const headerActions =
    mode === 'list' ? (
      <div className="flex items-center gap-2">
        <Button type="button" variant="outline" size="sm" onClick={() => void listQuery.refetch()} disabled={listQuery.isFetching}>
          <RefreshCw className={cn('mr-2 h-4 w-4', listQuery.isFetching && 'animate-spin')} />
          {listQuery.isFetching ? 'Syncing…' : 'Refresh'}
        </Button>
        <PortalNewButton label="New overtime request" onClick={startNew} />
      </div>
    ) : mode === 'form' ? (
      <div className="flex flex-wrap items-center gap-2">
        <Button type="button" variant="default" disabled={busy} onClick={() => send(false)}>
          <Save className="mr-2 h-4 w-4" />
          Save
        </Button>
        <Button type="button" variant="gradient" disabled={busy || Boolean(routingProblem)} onClick={() => send(true)}>
          <Send className="mr-2 h-4 w-4" />
          {busy ? 'Sending…' : 'Submit for Approval'}
        </Button>
        <Button type="button" variant="outline" disabled={busy} onClick={editingNo ? () => goTo('detail', editingNo) : startNew}>
          <XCircle className="mr-2 h-4 w-4" />
          Cancel
        </Button>
        <span className="mx-1 hidden h-8 w-px bg-slate-300 sm:block" aria-hidden />
        <Button type="button" variant="outline" onClick={() => goTo('list')}>
          <History className="mr-2 h-4 w-4" />
          View History
        </Button>
      </div>
    ) : (
      <div className="flex flex-wrap items-center gap-2">
        {shown?.status === 'Draft' ? (
          <>
            <Button type="button" variant="gradient" onClick={() => startEdit(shown)}>
              <Pencil className="mr-2 h-4 w-4" />
              Edit and submit
            </Button>
            <Button type="button" variant="outline" className="text-red-600" disabled={deleteMutation.isPending} onClick={() => askDelete(shown)}>
              <Trash2 className="mr-2 h-4 w-4" />
              Delete
            </Button>
          </>
        ) : null}
        {shown?.status === 'Pending Approval' ? (
          <Button type="button" variant="outline" disabled={withdrawMutation.isPending} onClick={() => askWithdraw(shown)}>
            <Undo2 className="mr-2 h-4 w-4" />
            Withdraw
          </Button>
        ) : null}
        <Button type="button" variant="outline" onClick={() => goTo('list')}>
          <ArrowLeft className="mr-2 h-4 w-4" />
          My requests
        </Button>
        <PortalNewButton label="New overtime request" onClick={startNew} />
      </div>
    )

  const contextError = contextQuery.isError
    ? contextQuery.error instanceof Error
      ? contextQuery.error.message
      : 'Business Central did not answer.'
    : ''

  return (
    <PageWrapper
      title="Overtime Request"
      description="Overtime Entry — employee request form. Approved by the Line Manager, HR, the Director / COO and Finance, then paid through payroll."
      actions={headerActions}
    >
      {contextError ? (
        <div className="mb-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{contextError}</div>
      ) : null}

      {mode === 'list' ? (
        <div className="portal-surface-card overflow-hidden rounded-2xl border border-slate-200 bg-white">
          <div className="flex items-center justify-between gap-3 border-b border-slate-100 px-4 py-3">
            <div>
              <h2 className="text-sm font-semibold text-slate-900">My Overtime Requests</h2>
              <p className="mt-0.5 text-xs text-slate-500">Newest first. Click a request to see its approval workflow and history.</p>
            </div>
            {rows.length ? (
              <span className="shrink-0 rounded-full bg-slate-100 px-2.5 py-1 text-xs font-medium text-slate-600">{rows.length} total</span>
            ) : null}
          </div>
          {listQuery.isError ? (
            <div className="m-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
              {listQuery.error instanceof Error ? listQuery.error.message : 'Overtime requests could not be loaded.'}
            </div>
          ) : listQuery.isLoading ? (
            <div className="space-y-2 p-4">
              <Skeleton className="h-10 w-full" />
              <Skeleton className="h-10 w-full" />
            </div>
          ) : (
            <DataTable<OvertimeRequestRow>
              columns={columns}
              rows={rows}
              getRowId={(row) => row.requestNo}
              emptyTitle="No overtime requests yet."
              onRowClick={(row) => goTo('detail', row.requestNo)}
            />
          )}
        </div>
      ) : null}

      {mode === 'detail' && !shown ? (
        listQuery.isLoading ? (
          <Skeleton className="h-64 w-full" />
        ) : (
          <div className="rounded-lg border border-slate-200 bg-white p-6 text-sm text-slate-600">
            Overtime request {selectedNo} was not found among your requests.
          </div>
        )
      ) : null}

      {mode === 'form' || shown ? (
        <div className="space-y-4">
          {shown ? (
            <div className="flex flex-wrap items-center gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
              <span className="text-sm font-semibold text-slate-900">{shown.requestNo}</span>
              <StatusBadge status={shown.status} />
              <span className="text-sm text-slate-600">{waitingFor(shown)}</span>
              {shown.decisionRemarks && shown.status === 'Rejected' ? (
                <span className="text-sm text-red-700">Reason: {shown.decisionRemarks}</span>
              ) : null}
            </div>
          ) : editingNo ? (
            <div className="rounded-xl border border-blue-100 bg-blue-50/70 px-4 py-2.5 text-sm text-blue-900">
              Editing draft {editingNo}. Save keeps it as a draft; Submit for Approval sends it to your line manager.
            </div>
          ) : null}

          <div className="grid gap-4 lg:grid-cols-3">
            <Section icon={<User className="h-4 w-4" />} title="Employee Information" className="lg:col-span-2">
              {contextQuery.isLoading && !shown ? (
                <div className="grid gap-3 md:grid-cols-2">
                  {Array.from({ length: 6 }, (_, index) => (
                    <Skeleton key={index} className="h-10 w-full" />
                  ))}
                </div>
              ) : (
                <div className="grid gap-3 md:grid-cols-2">
                  <Field label="Employee Name" required>
                    <ReadValue value={shown?.employeeName ?? context?.employee.employeeName} />
                  </Field>
                  <Field label="Designation">
                    <ReadValue value={shown?.designation ?? context?.employee.designation} />
                  </Field>
                  <Field label="Employee No.">
                    <ReadValue value={shown?.employeeNo ?? context?.employee.employeeNo} />
                  </Field>
                  <Field label="Cost Centre">
                    <ReadValue value={shown?.costCentre ?? context?.employee.costCentre} />
                  </Field>
                  <Field label="Department">
                    <ReadValue value={shown ? shown.departmentName || shown.departmentCode : context?.employee.departmentName || context?.employee.departmentCode} />
                  </Field>
                  <Field label="Project (if any)" htmlFor="overtime-project">
                    {shown ? (
                      <ReadValue value={shown.projectNo ? [shown.projectNo, shown.projectName].filter(Boolean).join(' · ') : ''} placeholder="No project" />
                    ) : (
                      <Select
                        id="overtime-project"
                        value={details.projectNo}
                        options={projectOptions}
                        placeholder={projectsQuery.isLoading ? 'Loading projects…' : 'No project'}
                        onChange={(event) => setDetails((current) => ({ ...current, projectNo: event.target.value }))}
                      />
                    )}
                  </Field>
                </div>
              )}
            </Section>

            <Section icon={<BarChart3 className="h-4 w-4" />} title="Request Summary">
              <div className="space-y-3">
                <div className="flex items-center gap-3 rounded-lg border border-slate-200 bg-slate-50 p-3">
                  <Clock className="h-8 w-8 shrink-0 text-[var(--portal-navy)]" />
                  <div>
                    <p className="text-xs font-medium text-slate-600">Total Overtime Hours</p>
                    <p className="text-2xl font-bold tabular-nums text-[var(--portal-navy)]">{hoursText(shownHours.totalHours)}</p>
                    {bandsText(shownHours) ? <p className="text-[11px] text-slate-500">{bandsText(shownHours)}</p> : null}
                  </div>
                </div>
                <div className="flex items-center gap-3 rounded-lg border border-slate-200 bg-slate-50 p-3">
                  <Wallet className="h-8 w-8 shrink-0 text-emerald-600" />
                  <div>
                    <p className="text-xs font-medium text-slate-600">Estimated Amount</p>
                    <p className="text-2xl font-bold tabular-nums text-emerald-600">{formatAmount(shownAmount)}</p>
                    <p className="text-[11px] text-slate-500">Final amount is worked out on the overtime sheet in payroll.</p>
                  </div>
                </div>
              </div>
            </Section>
          </div>

          <div className="grid gap-4 lg:grid-cols-3">
            <Section icon={<CalendarDays className="h-4 w-4" />} title="Overtime Details" className="lg:col-span-2">
              <div className="grid gap-3 md:grid-cols-2">
                <div className="space-y-3">
                  <Field label="Overtime Date" required htmlFor="overtime-date">
                    {shown ? (
                      <ReadValue value={prettyDate(shown.overtimeDate)} />
                    ) : (
                      <Input
                        id="overtime-date"
                        type="date"
                        value={details.overtimeDate}
                        onChange={(event) => setDetails((current) => ({ ...current, overtimeDate: event.target.value }))}
                      />
                    )}
                  </Field>
                  <Field label="Start Time" required htmlFor="overtime-start">
                    {shown ? (
                      <ReadValue value={shown.startTime} />
                    ) : (
                      <Input
                        id="overtime-start"
                        type="time"
                        value={details.startTime}
                        onChange={(event) => setDetails((current) => ({ ...current, startTime: event.target.value }))}
                      />
                    )}
                  </Field>
                  <Field label="End Time" required htmlFor="overtime-end">
                    {shown ? (
                      <ReadValue value={shown.endTime} />
                    ) : (
                      <Input
                        id="overtime-end"
                        type="time"
                        value={details.endTime}
                        onChange={(event) => setDetails((current) => ({ ...current, endTime: event.target.value }))}
                      />
                    )}
                  </Field>
                  <Field label="Overtime Hours" required>
                    <div className="flex">
                      <div className="min-h-10 flex-1 rounded-l-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm tabular-nums text-slate-900">
                        {shownHours.totalHours.toFixed(2)}
                      </div>
                      <span className="rounded-r-md border border-l-0 border-slate-200 bg-slate-100 px-3 py-2 text-sm text-slate-600">hrs</span>
                    </div>
                  </Field>
                </div>
                <div className="space-y-3">
                  <Field label="Overtime Category" required htmlFor="overtime-category">
                    {shown ? (
                      <ReadValue value={DAY_TYPES.find((type) => type.value === shown.dayType)?.label ?? shown.dayTypeLabel} />
                    ) : (
                      <Select
                        id="overtime-category"
                        value={details.dayType}
                        options={DAY_TYPES}
                        onChange={(event) =>
                          setDetails((current) => ({ ...current, dayType: (event.target.value || 'working') as OvertimeDayType }))
                        }
                      />
                    )}
                  </Field>
                  <Field label="Rate Type">
                    <ReadValue value={rateType(shownHours, shownDayType, rates)} />
                  </Field>
                  <Field label="Reason / Justification" required htmlFor="overtime-reason">
                    {shown ? (
                      <div className="min-h-20 whitespace-pre-wrap rounded-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900">
                        {shown.reason || '—'}
                      </div>
                    ) : (
                      <Textarea
                        id="overtime-reason"
                        rows={3}
                        maxLength={500}
                        value={details.reason}
                        placeholder="Why is the overtime needed?"
                        onChange={(event) => setDetails((current) => ({ ...current, reason: event.target.value }))}
                      />
                    )}
                  </Field>
                </div>
              </div>
              {!shown && weekendHint ? (
                <p className="mt-3 flex items-center gap-2 text-xs text-amber-800">
                  <Info className="h-3.5 w-3.5" />
                  {weekendHint}
                </p>
              ) : null}
            </Section>

            <Section icon={<CheckCircle2 className="h-4 w-4" />} title="Attendance Check">
              {(() => {
                const active = context?.employee.active ?? true
                const allowed = context?.employee.allowOvertime ?? true
                const withinLimit = !limit || (shown ? !/limit/i.test(shown.warnings) : monthTotal <= limit)
                const passed = active && allowed && withinLimit
                return (
                  <div className={cn('rounded-lg border p-3', passed ? 'border-emerald-200 bg-emerald-50/70' : 'border-amber-200 bg-amber-50/70')}>
                    <p className={cn('flex items-center gap-2 text-base font-semibold', passed ? 'text-emerald-800' : 'text-amber-900')}>
                      {passed ? <CheckCircle2 className="h-6 w-6" /> : <AlertTriangle className="h-6 w-6" />}
                      {passed ? 'Attendance Check Passed' : 'Check before submitting'}
                    </p>
                    <ul className="mt-3 space-y-2">
                      <CheckRow ok={active} text={active ? 'Employee in active status' : 'Employee is not active in Business Central'} />
                      <CheckRow
                        ok={allowed}
                        warn
                        text={allowed ? 'Overtime allowed on the employee card' : 'Allow Overtime is No on your employee card — HR will check it'}
                      />
                      <CheckRow
                        ok={withinLimit}
                        warn
                        text={
                          limit
                            ? shown
                              ? withinLimit
                                ? `Within the monthly limit of ${limit} hours`
                                : shown.warnings
                              : `${Number(monthTotal.toFixed(2))} of ${limit} overtime hours this month${withinLimit ? '' : ' — above the limit'}`
                            : 'Compliant with policy'
                        }
                      />
                      {context && !context.employee.hasBasicPay ? (
                        <CheckRow ok={false} warn text="No basic pay on your salary card, so the amount cannot be estimated" />
                      ) : null}
                    </ul>
                  </div>
                )
              })()}
            </Section>
          </div>

          <Section icon={<Network className="h-4 w-4" />} title="Approval Workflow">
            {routingProblem && (!shown || shown.status === 'Draft') ? (
              <div className="mb-4 flex items-start gap-2 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-900">
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
                <span>{routingProblem}</span>
              </div>
            ) : null}
            <WorkflowTracker steps={steps} />
          </Section>

          {shown?.log.length ? (
            <div className="rounded-lg border border-amber-200 bg-amber-50/70 p-4">
              <p className="mb-3 text-sm font-semibold text-slate-900">Approval and Comment History</p>
              <ol className="space-y-2">
                {shown.log
                  .slice()
                  .reverse()
                  .map((entry, index) => (
                    <li key={`${entry.at}-${index}`} className="rounded-md bg-white/80 px-3 py-2 text-sm shadow-sm">
                      <div className="flex flex-wrap items-baseline justify-between gap-2">
                        <span className="font-medium text-slate-900">
                          {entry.stageLabel} · {entry.action}
                          {entry.userName ? <span className="font-normal text-slate-600"> — {entry.userName}</span> : null}
                        </span>
                        <span className="text-xs text-slate-500">{formatDateTime(entry.at)}</span>
                      </div>
                      {entry.comment ? <p className="mt-1 whitespace-pre-wrap text-slate-700">{entry.comment}</p> : null}
                    </li>
                  ))}
              </ol>
            </div>
          ) : null}

          {formError && mode === 'form' ? (
            <div className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{formError}</div>
          ) : null}

          <div className="flex flex-col gap-3 lg:flex-row lg:items-stretch">
            <div className="flex flex-1 items-start gap-3 rounded-xl border border-blue-100 bg-blue-50/70 px-4 py-3 text-sm text-blue-950">
              <Info className="mt-0.5 h-5 w-5 shrink-0 text-[var(--portal-navy)]" />
              <div>
                <p className="font-semibold">Notes:</p>
                <ul className="mt-1 list-disc space-y-0.5 pl-4">
                  <li>Only approved overtime will be processed for payroll.</li>
                  <li>Ensure compliance with ABH HR Policy and Ethiopian Labour Proclamation (1156/2019).</li>
                  <li>
                    Rates: normal day {rateText(rates.normal)}, night (10 PM–6 AM) {rateText(rates.night)}, weekly rest day{' '}
                    {rateText(rates.restDay)}, public holiday {rateText(rates.holiday)} of the hourly rate (basic pay ÷{' '}
                    {context?.monthlyHours ?? 208} hours).
                  </li>
                </ul>
              </div>
            </div>
            {mode === 'form' ? (
              <div className="flex flex-wrap items-center gap-3 lg:flex-col lg:items-stretch lg:justify-center">
                <Button type="button" variant="outline" size="lg" disabled={busy} onClick={() => send(false)}>
                  <Save className="mr-2 h-4 w-4" />
                  Save as Draft
                </Button>
                <Button type="button" variant="gradient" size="lg" disabled={busy || Boolean(routingProblem)} onClick={() => send(true)}>
                  <Send className="mr-2 h-4 w-4" />
                  {busy ? 'Sending…' : 'Submit for Approval'}
                </Button>
              </div>
            ) : null}
          </div>
        </div>
      ) : null}
    </PageWrapper>
  )
}
