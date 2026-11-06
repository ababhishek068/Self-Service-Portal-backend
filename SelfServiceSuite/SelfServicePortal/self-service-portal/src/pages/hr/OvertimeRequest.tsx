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
  Plus,
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
  type OvertimeLineInput,
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

/** A new request starts with today evening filled in; after Add Line the entry is cleared. */
function firstEntry(): OvertimeLineInput {
  return { overtimeDate: localToday(), startTime: '17:00', endTime: '21:00', dayType: 'working', reason: '' }
}

function clearedEntry(dayType: OvertimeDayType): OvertimeLineInput {
  return { overtimeDate: '', startTime: '', endTime: '', dayType, reason: '' }
}

function linesOf(request: OvertimeRequestRow): OvertimeLineInput[] {
  return request.lines.map((line) => ({
    overtimeDate: line.overtimeDate,
    startTime: line.startTime,
    endTime: line.endTime,
    dayType: line.dayType,
    reason: line.reason,
  }))
}

function sortLines(lines: OvertimeLineInput[]) {
  return [...lines].sort((left, right) => (left.overtimeDate + left.startTime).localeCompare(right.overtimeDate + right.startTime))
}

/** Minutes a line covers from 1 January 1970 (an end before the start is the next morning). */
function slotOf(line: OvertimeLineInput) {
  const [startHour = 0, startMinute = 0] = line.startTime.split(':').map(Number)
  const [endHour = 0, endMinute = 0] = line.endTime.split(':').map(Number)
  const start = startHour * 60 + startMinute
  let end = endHour * 60 + endMinute
  if (end <= start) end += 1440
  const base = (Date.parse(`${line.overtimeDate}T00:00:00Z`) / 60_000) || 0
  return { start: base + start, end: base + end }
}

function overlaps(left: OvertimeLineInput, right: OvertimeLineInput) {
  const a = slotOf(left)
  const b = slotOf(right)
  return Math.min(a.end, b.end) > Math.max(a.start, b.start)
}

/** "11/06/2026", as on the manager form. */
function shortDate(value: string) {
  const parsed = parseISO(value)
  return value && isValid(parsed) ? format(parsed, 'dd/MM/yyyy') : value || '—'
}

/** "05:00 PM" */
function clockText(value: string) {
  const match = /^(\d{1,2}):(\d{2})/.exec(value)
  if (!match) return value || '—'
  const hour = Number(match[1])
  return `${String(hour % 12 || 12).padStart(2, '0')}:${match[2]} ${hour < 12 ? 'AM' : 'PM'}`
}

function dateRange(lines: Array<{ overtimeDate: string }>, fallback: string) {
  const dates = lines.map((line) => line.overtimeDate).filter(Boolean).sort()
  if (!dates.length) return prettyDate(fallback)
  const first = dates[0]!
  const last = dates[dates.length - 1]!
  return first === last ? prettyDate(first) : `${prettyDate(first)} – ${prettyDate(last)}`
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

/**
 * The busiest month of this request: its hours plus the employee's other pending and approved
 * overtime in that month (BC checks the same limit month by month).
 */
function busiestMonth(rows: OvertimeRequestRow[], lines: OvertimeLineInput[], exceptNo: string) {
  const months = new Map<string, number>()
  for (const line of lines) {
    if (!line.overtimeDate) continue
    const month = line.overtimeDate.slice(0, 7)
    months.set(month, (months.get(month) ?? 0) + splitOvertimeHours(line.startTime, line.endTime, line.dayType).totalHours)
  }
  let worst = { month: '', hours: 0 }
  for (const [month, own] of months) {
    const others = rows
      .filter((row) => row.requestNo !== exceptNo && (row.status === 'Pending Approval' || row.status === 'Approved'))
      .flatMap((row) => row.lines)
      .filter((line) => line.overtimeDate.slice(0, 7) === month)
      .reduce((total, line) => total + line.totalHours, 0)
    if (own + others > worst.hours) worst = { month, hours: own + others }
  }
  return worst
}

function monthLabel(month: string) {
  const parsed = parseISO(`${month}-01`)
  return isValid(parsed) ? format(parsed, 'MMMM yyyy') : 'this month'
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

type TableLine = OvertimeLineInput & { hours: ReturnType<typeof splitOvertimeHours> }

/** The request's overtime lines, as on the manager form (with Edit / Delete while it is a draft). */
function OvertimeLinesTable({
  lines,
  rates,
  editingIndex,
  onEdit,
  onDelete,
  className,
}: {
  lines: TableLine[]
  rates: OvertimeContext['rates']
  editingIndex: number | null
  onEdit?: (index: number) => void
  onDelete?: (index: number) => void
  className?: string
}) {
  const editable = Boolean(onEdit || onDelete)
  const total = lines.reduce((sum, line) => sum + line.hours.totalHours, 0)
  return (
    <div className={cn('overflow-x-auto rounded-lg border border-slate-200', className)}>
      <table className="min-w-full border-collapse text-left text-sm">
        <thead className="border-b border-slate-200 bg-slate-50 text-xs font-semibold text-slate-600">
          <tr>
            <th className="whitespace-nowrap px-3 py-2.5">Date</th>
            <th className="whitespace-nowrap px-3 py-2.5">Start Time</th>
            <th className="whitespace-nowrap px-3 py-2.5">End Time</th>
            <th className="whitespace-nowrap px-3 py-2.5 text-right">Overtime Hours</th>
            <th className="whitespace-nowrap px-3 py-2.5">Category</th>
            <th className="whitespace-nowrap px-3 py-2.5">Rate Type</th>
            <th className="min-w-[12rem] px-3 py-2.5">Reason / Justification</th>
            {editable ? <th className="w-20 px-3 py-2.5"><span className="sr-only">Actions</span></th> : null}
          </tr>
        </thead>
        <tbody>
          {lines.length === 0 ? (
            <tr>
              <td colSpan={editable ? 8 : 7} className="px-3 py-6 text-center text-sm text-slate-500">
                No overtime lines yet. Fill in the details above and click Add Line.
              </td>
            </tr>
          ) : (
            lines.map((line, index) => (
              <tr
                key={`${line.overtimeDate}-${line.startTime}-${index}`}
                className={cn('border-b border-slate-100 last:border-0', editingIndex === index ? 'bg-amber-50' : 'hover:bg-slate-50/60')}
              >
                <td className="whitespace-nowrap px-3 py-2.5">{shortDate(line.overtimeDate)}</td>
                <td className="whitespace-nowrap px-3 py-2.5">{clockText(line.startTime)}</td>
                <td className="whitespace-nowrap px-3 py-2.5">{clockText(line.endTime)}</td>
                <td className="whitespace-nowrap px-3 py-2.5 text-right tabular-nums">{line.hours.totalHours.toFixed(2)}</td>
                <td className="whitespace-nowrap px-3 py-2.5">{DAY_TYPES.find((type) => type.value === line.dayType)?.label ?? line.dayType}</td>
                <td className="whitespace-nowrap px-3 py-2.5">{rateType(line.hours, line.dayType, rates)}</td>
                <td className="px-3 py-2.5">{line.reason || '—'}</td>
                {editable ? (
                  <td className="whitespace-nowrap px-2 py-1.5 text-right">
                    {onEdit ? (
                      <Button type="button" variant="ghost" size="sm" aria-label={`Edit the line of ${shortDate(line.overtimeDate)}`} onClick={() => onEdit(index)}>
                        <Pencil className="h-4 w-4" />
                      </Button>
                    ) : null}
                    {onDelete ? (
                      <Button type="button" variant="ghost" size="sm" aria-label={`Delete the line of ${shortDate(line.overtimeDate)}`} onClick={() => onDelete(index)}>
                        <Trash2 className="h-4 w-4 text-red-600" />
                      </Button>
                    ) : null}
                  </td>
                ) : null}
              </tr>
            ))
          )}
        </tbody>
        {lines.length > 1 ? (
          <tfoot className="border-t border-slate-200 bg-slate-50 text-sm font-semibold text-slate-900">
            <tr>
              <td className="px-3 py-2.5" colSpan={3}>
                Total ({lines.length} lines)
              </td>
              <td className="px-3 py-2.5 text-right tabular-nums">{total.toFixed(2)}</td>
              <td colSpan={editable ? 4 : 3} />
            </tr>
          </tfoot>
        ) : null}
      </table>
    </div>
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
  const [entry, setEntry] = useState<OvertimeLineInput>(firstEntry)
  const [lines, setLines] = useState<OvertimeLineInput[]>([])
  const [editingLine, setEditingLine] = useState<number | null>(null)
  const [projectNo, setProjectNo] = useState('')
  const [entryError, setEntryError] = useState<string | null>(null)
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

  const rates = context?.rates ?? { normal: 1.5, night: 1.75, restDay: 2, holiday: 2.5 }
  const hourlyRate = context?.hourlyRate ?? 0
  const maxLines = context?.maxLines ?? 1
  const entryHours = useMemo(
    () => splitOvertimeHours(entry.startTime, entry.endTime, entry.dayType),
    [entry.startTime, entry.endTime, entry.dayType],
  )
  // The request's lines; a new request with no line yet counts the entry, so the summary is never empty.
  const counted = lines.length || editingLine !== null ? lines : entryHours.totalHours ? [entry] : []
  const formHours = counted.reduce(
    (total, line) => {
      const split = splitOvertimeHours(line.startTime, line.endTime, line.dayType)
      return {
        totalHours: total.totalHours + split.totalHours,
        normalHours: total.normalHours + split.normalHours,
        nightHours: total.nightHours + split.nightHours,
        restDayHours: total.restDayHours + split.restDayHours,
        holidayHours: total.holidayHours + split.holidayHours,
      }
    },
    { totalHours: 0, normalHours: 0, nightHours: 0, restDayHours: 0, holidayHours: 0 },
  )
  const formAmount = counted.reduce(
    (total, line) => total + estimateOvertimeAmount(splitOvertimeHours(line.startTime, line.endTime, line.dayType), hourlyRate, rates),
    0,
  )
  const busiest = busiestMonth(rows, counted, editingNo ?? '')
  const limit = context?.maxHoursPerMonth ?? 0
  const dateObject = parseISO(entry.overtimeDate)
  const weekendHint =
    entry.dayType === 'working' && isValid(dateObject) && (dateObject.getDay() === 0 || dateObject.getDay() === 6)
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
    setLines([])
    setEntry(firstEntry())
    setEditingLine(null)
    setEntryError(null)
    setProjectNo('')
    goTo('form')
  }

  const startEdit = (request: OvertimeRequestRow) => {
    const existing = sortLines(linesOf(request))
    setEditingNo(request.requestNo)
    setLines(existing)
    setEntry(clearedEntry(existing[0]?.dayType ?? 'working'))
    setEditingLine(null)
    setEntryError(null)
    setProjectNo(request.projectNo)
    goTo('form')
  }

  /** What is wrong with a line before it goes into the table (null when it is fine). */
  const lineProblem = (line: OvertimeLineInput, others: OvertimeLineInput[]) => {
    if (!line.overtimeDate) return 'Enter the overtime date.'
    if (!line.startTime || !line.endTime) return 'Enter the start and end time.'
    if (splitOvertimeHours(line.startTime, line.endTime, line.dayType).totalHours <= 0) {
      return 'The end time must be different from the start time.'
    }
    if (line.reason.trim().length < 3) return 'Enter the reason / justification for the overtime.'
    const clash = others.find((other) => overlaps(line, other))
    if (clash) {
      return `It overlaps the line of ${shortDate(clash.overtimeDate)} ${clockText(clash.startTime)} – ${clockText(clash.endTime)}.`
    }
    return null
  }

  const addLine = () => {
    const others = lines.filter((_, index) => index !== editingLine)
    const problem = lineProblem(entry, others)
    if (problem) {
      setEntryError(problem)
      return
    }
    const line = { ...entry, reason: entry.reason.trim() }
    setLines(sortLines(editingLine === null ? [...lines, line] : lines.map((item, index) => (index === editingLine ? line : item))))
    setEntry(clearedEntry(entry.dayType))
    setEditingLine(null)
    setEntryError(null)
    setFormError(null)
  }

  const editLine = (index: number) => {
    const line = lines[index]
    if (!line) return
    setEntry(line)
    setEditingLine(index)
    setEntryError(null)
  }

  const cancelLineEdit = () => {
    setEntry(clearedEntry(entry.dayType))
    setEditingLine(null)
    setEntryError(null)
  }

  const deleteLine = (index: number) => {
    setLines(lines.filter((_, item) => item !== index))
    if (editingLine !== null) cancelLineEdit()
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

  const send = (submit: boolean) => {
    if (editingLine !== null) {
      setFormError('Click Update Line to keep your change to the line, or Cancel to leave it as it was.')
      return
    }
    let all = lines
    // A line filled in but not added with Add Line yet is added for the employee.
    if (entry.overtimeDate || entry.startTime || entry.endTime) {
      const problem = lineProblem(entry, lines)
      if (problem) {
        setEntryError(problem)
        setFormError(lines.length ? `Finish the line you are entering and click Add Line, or clear it. ${problem}` : problem)
        return
      }
      if (lines.length >= maxLines) {
        setFormError(`This request can hold ${maxLines} line${maxLines === 1 ? '' : 's'}. Clear the line you are entering, or make a second request.`)
        return
      }
      all = sortLines([...lines, { ...entry, reason: entry.reason.trim() }])
    }
    if (!all.length) {
      setFormError('Add at least one overtime line: the date, start and end time, category and reason, then Add Line.')
      return
    }
    setFormError(null)
    setEntryError(null)
    const first = all[0]!
    const reasons = [...new Set(all.map((line) => line.reason.trim()).filter(Boolean))]
    if (all !== lines) {
      setLines(all)
      setEntry(clearedEntry(entry.dayType))
    }
    saveMutation.mutate({
      requestNo: editingNo ?? undefined,
      details: { ...first, reason: reasons.join('; ').slice(0, 500), projectNo, lines: all },
      submit,
    })
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
    { id: 'date', header: 'Overtime date', cell: (row) => dateRange(row.lines, row.overtimeDate) },
    {
      id: 'time',
      header: 'Time',
      cell: (row) => (row.lines.length > 1 ? `${row.lines.length} lines` : `${clockText(row.startTime)} – ${clockText(row.endTime)}`),
    },
    {
      id: 'category',
      header: 'Category',
      cell: (row) =>
        new Set(row.lines.map((line) => line.dayType)).size > 1
          ? 'Mixed'
          : (DAY_TYPES.find((type) => type.value === row.dayType)?.label.split(' (')[0] ?? row.dayTypeLabel),
    },
    { id: 'hours', header: 'Hours', cell: (row) => hoursText(row.totalHours) },
    { id: 'amount', header: 'Estimated amount', cell: (row) => formatAmount(row.estimatedAmount) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
    { id: 'waiting', header: 'Where it is', cell: (row) => <span className="text-xs text-slate-600">{waitingFor(row)}</span> },
  ]

  const employeeName = context?.employee.employeeName ?? ''
  const shown = mode === 'detail' ? selected : null
  const shownHours = shown
    ? { totalHours: shown.totalHours, normalHours: shown.normalHours, nightHours: shown.nightHours, restDayHours: shown.restDayHours, holidayHours: shown.holidayHours }
    : formHours
  const shownAmount = shown ? shown.estimatedAmount : formAmount
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
                        value={projectNo}
                        options={projectOptions}
                        placeholder={projectsQuery.isLoading ? 'Loading projects…' : 'No project'}
                        onChange={(event) => setProjectNo(event.target.value)}
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

          <Section icon={<CalendarDays className="h-4 w-4" />} title="Overtime Details">
            {shown ? null : (
              <div className={cn('rounded-lg', editingLine !== null ? 'bg-amber-50/60 p-3 ring-1 ring-amber-200' : '')}>
                {editingLine !== null ? (
                  <p className="mb-3 text-xs font-medium text-amber-900">Editing line {editingLine + 1}. Click Update Line to keep the change.</p>
                ) : null}
                <div className="grid gap-3 md:grid-cols-2">
                  <div className="space-y-3">
                    <Field label="Overtime Date" required htmlFor="overtime-date">
                      <Input
                        id="overtime-date"
                        type="date"
                        value={entry.overtimeDate}
                        onChange={(event) => setEntry((current) => ({ ...current, overtimeDate: event.target.value }))}
                      />
                    </Field>
                    <Field label="Start Time" required htmlFor="overtime-start">
                      <Input
                        id="overtime-start"
                        type="time"
                        value={entry.startTime}
                        onChange={(event) => setEntry((current) => ({ ...current, startTime: event.target.value }))}
                      />
                    </Field>
                    <Field label="End Time" required htmlFor="overtime-end">
                      <Input
                        id="overtime-end"
                        type="time"
                        value={entry.endTime}
                        onChange={(event) => setEntry((current) => ({ ...current, endTime: event.target.value }))}
                      />
                    </Field>
                    <Field label="Overtime Hours" required>
                      <div className="flex">
                        <div className="min-h-10 flex-1 rounded-l-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm tabular-nums text-slate-900">
                          {entryHours.totalHours.toFixed(2)}
                        </div>
                        <span className="rounded-r-md border border-l-0 border-slate-200 bg-slate-100 px-3 py-2 text-sm text-slate-600">hrs</span>
                      </div>
                    </Field>
                  </div>
                  <div className="space-y-3">
                    <Field label="Overtime Category" required htmlFor="overtime-category">
                      <Select
                        id="overtime-category"
                        value={entry.dayType}
                        options={DAY_TYPES}
                        onChange={(event) =>
                          setEntry((current) => ({ ...current, dayType: (event.target.value || 'working') as OvertimeDayType }))
                        }
                      />
                    </Field>
                    <Field label="Rate Type">
                      <ReadValue value={entryHours.totalHours ? rateType(entryHours, entry.dayType, rates) : ''} />
                    </Field>
                    <Field label="Reason / Justification" required htmlFor="overtime-reason">
                      <Textarea
                        id="overtime-reason"
                        rows={3}
                        maxLength={250}
                        value={entry.reason}
                        placeholder="Why is the overtime needed?"
                        onChange={(event) => setEntry((current) => ({ ...current, reason: event.target.value }))}
                      />
                    </Field>
                  </div>
                </div>
                {weekendHint ? (
                  <p className="mt-3 flex items-center gap-2 text-xs text-amber-800">
                    <Info className="h-3.5 w-3.5" />
                    {weekendHint}
                  </p>
                ) : null}
                {entryError ? (
                  <p role="alert" className="mt-3 flex items-center gap-2 text-sm text-red-700">
                    <AlertTriangle className="h-4 w-4 shrink-0" />
                    {entryError}
                  </p>
                ) : null}
              </div>
            )}

            <OvertimeLinesTable
              className={shown ? '' : 'mt-4'}
              lines={
                shown
                  ? shown.lines.map((line) => ({ ...line, hours: line }))
                  : lines.map((line) => ({ ...line, hours: splitOvertimeHours(line.startTime, line.endTime, line.dayType) }))
              }
              rates={rates}
              editingIndex={editingLine}
              onEdit={shown ? undefined : editLine}
              onDelete={shown ? undefined : deleteLine}
            />

            {shown ? null : (
              <div className="mt-3 flex flex-wrap items-center gap-2">
                <Button
                  type="button"
                  variant="outline"
                  className="border-[var(--portal-navy)]/40 text-[var(--portal-navy)]"
                  disabled={busy || (editingLine === null && lines.length >= maxLines)}
                  onClick={addLine}
                >
                  {editingLine === null ? <Plus className="mr-2 h-4 w-4" /> : <CheckCircle2 className="mr-2 h-4 w-4" />}
                  {editingLine === null ? 'Add Line' : 'Update Line'}
                </Button>
                {editingLine !== null ? (
                  <Button type="button" variant="ghost" onClick={cancelLineEdit}>
                    Cancel
                  </Button>
                ) : null}
                {editingLine === null && lines.length >= maxLines ? (
                  <span className="text-xs text-slate-500">
                    {maxLines === 1
                      ? 'Several dates in one request need Business Central package 1.0.3.612. Make one request per date for now.'
                      : `A request can hold ${maxLines} lines. Make a second request for the other days.`}
                  </span>
                ) : (
                  <span className="text-xs text-slate-500">
                    Fill in the date, times, category and reason, then Add Line. Add a line for each day you work overtime.
                  </span>
                )}
              </div>
            )}
          </Section>

          <div className="grid gap-4 lg:grid-cols-3">
            <Section icon={<CheckCircle2 className="h-4 w-4" />} title="Attendance Check">
              {(() => {
                const active = context?.employee.active ?? true
                const allowed = context?.employee.allowOvertime ?? true
                const withinLimit = !limit || (shown ? !/limit/i.test(shown.warnings) : busiest.hours <= limit)
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
                              : busiest.month
                                ? `${Number(busiest.hours.toFixed(2))} of ${limit} overtime hours in ${monthLabel(busiest.month)}${withinLimit ? '' : ' — above the limit'}`
                                : `Monthly limit ${limit} hours`
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

            <Section icon={<Network className="h-4 w-4" />} title="Approval Workflow" className="lg:col-span-2">
              {routingProblem && (!shown || shown.status === 'Draft') ? (
                <div className="mb-4 flex items-start gap-2 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-900">
                  <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
                  <span>{routingProblem}</span>
                </div>
              ) : null}
              <WorkflowTracker steps={steps} />
            </Section>
          </div>

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
