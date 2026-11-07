import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { addDays, format, isValid, parseISO } from 'date-fns'
import {
  AlertTriangle,
  ArrowLeft,
  ArrowRight,
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
  { value: 'working', label: 'Normal day hours (6 AM – 10 PM)' },
  { value: 'night', label: 'Night hours (10 PM – 6 AM)' },
  { value: 'restDay', label: 'Rest day hours' },
  { value: 'holiday', label: 'Public holiday hours' },
]

type Mode = 'form' | 'list' | 'detail'

/** The line being entered: everything blank until the employee fills it in (category too). */
type EntryDraft = Omit<OvertimeLineInput, 'dayType'> & { dayType: OvertimeDayType | '' }

function emptyEntry(): EntryDraft {
  return { overtimeDate: '', startTime: '', endTime: '', dayType: '', reason: '' }
}

/** "17:05" -> 05:05 PM; blank when the value is not a time. */
function to12(value: string): { text: string; meridiem: 'AM' | 'PM' | null } {
  const match = /^(\d{1,2}):(\d{2})/.exec(value)
  if (!match) return { text: '', meridiem: null }
  const hour = Number(match[1])
  return { text: `${String(hour % 12 || 12).padStart(2, '0')}:${match[2]}`, meridiem: hour < 12 ? 'AM' : 'PM' }
}

/** "5", "5:30", "0530" or "530" with AM / PM -> "17:30"; blank when it is not a valid 12-hour time. */
function to24(text: string, meridiem: 'AM' | 'PM') {
  const match = /^(\d{1,2})(?::?(\d{2}))?$/.exec(text.trim())
  if (!match) return ''
  const hour = Number(match[1])
  const minute = Number(match[2] ?? '0')
  if (hour < 1 || hour > 12 || minute > 59) return ''
  return `${String((hour % 12) + (meridiem === 'PM' ? 12 : 0)).padStart(2, '0')}:${String(minute).padStart(2, '0')}`
}

/** HH:MM typed in 12-hour time, with AM / PM chosen next to it (the form keeps 24-hour time). */
function TimeField({
  id,
  label,
  value,
  defaultMeridiem,
  onChange,
}: {
  id: string
  label: string
  value: string
  defaultMeridiem: 'AM' | 'PM'
  onChange: (value: string) => void
}) {
  const initial = to12(value)
  const [text, setText] = useState(initial.text)
  const [meridiem, setMeridiem] = useState<'AM' | 'PM'>(initial.meridiem ?? defaultMeridiem)
  const invalid = text.trim() !== '' && !to24(text, meridiem)
  const update = (nextText: string, nextMeridiem: 'AM' | 'PM') => {
    setText(nextText)
    setMeridiem(nextMeridiem)
    onChange(to24(nextText, nextMeridiem))
  }
  return (
    <div className="space-y-1.5">
      <Label htmlFor={id} className="text-sm text-slate-700">
        {label}
        <span className="text-red-500"> *</span>
      </Label>
      <Input
        id={id}
        inputMode="numeric"
        placeholder="HH:MM"
        maxLength={5}
        value={text}
        aria-invalid={invalid}
        className={invalid ? 'border-red-400' : undefined}
        onChange={(event) => update(event.target.value.replace(/[^\d:]/g, ''), meridiem)}
        onBlur={() => {
          const value24 = to24(text, meridiem)
          if (value24) setText(to12(value24).text)
        }}
      />
      <div role="radiogroup" aria-label={`${label}: AM or PM`} className="flex gap-6 pt-0.5 text-sm text-slate-700">
        {(['AM', 'PM'] as const).map((option) => (
          <label key={option} className="flex cursor-pointer items-center gap-1.5">
            <input
              type="radio"
              name={`${id}-meridiem`}
              className="h-4 w-4 accent-[var(--portal-navy)]"
              checked={meridiem === option}
              onChange={() => update(text, option)}
            />
            {option}
          </label>
        ))}
      </div>
      {invalid ? <p className="text-xs text-red-600">Type the time as HH:MM, from 01:00 to 12:59 (for example 05:30).</p> : null}
    </div>
  )
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

function minutesOfClock(value: string) {
  const [hour = 0, minute = 0] = value.split(':').map(Number)
  return hour * 60 + minute
}

function clockOf(minutes: number) {
  const value = ((minutes % 1440) + 1440) % 1440
  return `${String(Math.floor(value / 60)).padStart(2, '0')}:${String(value % 60).padStart(2, '0')}`
}

function shiftDate(date: string, days: number) {
  const parsed = parseISO(date)
  return days && isValid(parsed) ? format(addDays(parsed, days), 'yyyy-MM-dd') : date
}

/** Normal day hours lie within 6 AM - 10 PM and night hours within 10 PM - 6 AM (BC checks the same). */
function categoryProblem(line: OvertimeLineInput) {
  if (line.dayType !== 'working' && line.dayType !== 'night') return ''
  const split = splitOvertimeHours(line.startTime, line.endTime, 'working')
  if (!split.totalHours) return ''
  if (line.dayType === 'working' && split.nightHours > 0) {
    return 'Normal day hours are between 6 AM and 10 PM. Put the hours after 10 PM (or before 6 AM) in a second line with Night hours.'
  }
  if (line.dayType === 'night' && split.normalHours > 0) {
    return 'Night hours are between 10 PM and 6 AM. Put the hours from 6 AM to 10 PM in a second line with Normal day hours.'
  }
  return ''
}

/** A line that crosses 6 AM or 10 PM, cut into normal day and night lines (the date moves on after midnight). */
function splitAtBands(line: OvertimeLineInput): OvertimeLineInput[] {
  if (line.dayType !== 'working' && line.dayType !== 'night') return []
  const split = splitOvertimeHours(line.startTime, line.endTime, 'working')
  if (!split.normalHours || !split.nightHours) return []
  const start = minutesOfClock(line.startTime)
  let end = minutesOfClock(line.endTime)
  if (end <= start) end += 1440
  const cuts = [start, ...[360, 1320, 1800, 2760].filter((point) => point > start && point < end), end]
  return cuts.slice(0, -1).map((from, index) => {
    const to = cuts[index + 1]!
    const normal = (from >= 360 && to <= 1320) || (from >= 1800 && to <= 2760)
    return {
      ...line,
      overtimeDate: shiftDate(line.overtimeDate, Math.floor(from / 1440)),
      startTime: clockOf(from),
      endTime: clockOf(to),
      dayType: normal ? ('working' as const) : ('night' as const),
    }
  })
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
  if (dayType === 'night') return `${rateText(rates.night)} (night)`
  if (dayType === 'restDay') return `${rateText(rates.restDay)} (weekly rest day)`
  if (dayType === 'holiday') return `${rateText(rates.holiday)} (public holiday)`
  if (hours.normalHours && hours.nightHours) {
    return `${rateText(rates.normal)} normal day + ${rateText(rates.night)} night`
  }
  if (hours.nightHours) return `${rateText(rates.night)} (night, 10 PM–6 AM)`
  return `${rateText(rates.normal)} (normal day)`
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

type TableLine = OvertimeLineInput & { hours: ReturnType<typeof splitOvertimeHours>; amount: number }

/** The saved overtime lines: date, category, hours, rate and amount (Edit / Delete while it is a draft). */
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
  const totalHours = lines.reduce((sum, line) => sum + line.hours.totalHours, 0)
  const totalAmount = lines.reduce((sum, line) => sum + line.amount, 0)
  return (
    <div className={cn('overflow-x-auto rounded-lg border border-slate-200', className)}>
      <table className="min-w-full border-collapse text-left text-sm">
        <thead className="border-b border-slate-200 bg-slate-50 text-xs font-semibold text-slate-600">
          <tr>
            <th className="whitespace-nowrap px-3 py-2.5">Date</th>
            <th className="px-3 py-2.5">Category</th>
            <th className="whitespace-nowrap px-3 py-2.5 text-right">Hours</th>
            <th className="whitespace-nowrap px-3 py-2.5">Rate</th>
            <th className="whitespace-nowrap px-3 py-2.5 text-right">Amount</th>
            {editable ? <th className="w-20 px-3 py-2.5"><span className="sr-only">Actions</span></th> : null}
          </tr>
        </thead>
        <tbody>
          {lines.map((line, index) => (
            <tr
              key={`${line.overtimeDate}-${line.startTime}-${index}`}
              className={cn('border-b border-slate-100 align-top last:border-0', editingIndex === index ? 'bg-amber-50' : 'hover:bg-slate-50/60')}
            >
              <td className="whitespace-nowrap px-3 py-2.5">
                <p className="font-medium text-slate-900">{shortDate(line.overtimeDate)}</p>
                <p className="text-xs text-slate-500">
                  {clockText(line.startTime)} – {clockText(line.endTime)}
                </p>
              </td>
              <td className="min-w-[12rem] px-3 py-2.5">
                <p className="text-slate-900">{DAY_TYPES.find((type) => type.value === line.dayType)?.label ?? line.dayType}</p>
                {line.reason ? <p className="text-xs text-slate-500">{line.reason}</p> : null}
              </td>
              <td className="whitespace-nowrap px-3 py-2.5 text-right tabular-nums">{line.hours.totalHours.toFixed(2)}</td>
              <td className="whitespace-nowrap px-3 py-2.5">{rateType(line.hours, line.dayType, rates)}</td>
              <td className="whitespace-nowrap px-3 py-2.5 text-right tabular-nums">{formatAmount(line.amount)}</td>
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
          ))}
        </tbody>
        {lines.length > 1 ? (
          <tfoot className="border-t border-slate-200 bg-slate-50 text-sm font-semibold text-slate-900">
            <tr>
              <td className="px-3 py-2.5" colSpan={2}>
                Total ({lines.length} lines)
              </td>
              <td className="px-3 py-2.5 text-right tabular-nums">{totalHours.toFixed(2)}</td>
              <td />
              <td className="px-3 py-2.5 text-right tabular-nums">{formatAmount(totalAmount)}</td>
              {editable ? <td /> : null}
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
  const [entry, setEntry] = useState<EntryDraft>(emptyEntry)
  const [lines, setLines] = useState<OvertimeLineInput[]>([])
  const [editingLine, setEditingLine] = useState<number | null>(null)
  // The New Line card opens with Add Line (or the pencil of a line) and closes with Save / Cancel.
  const [entryOpen, setEntryOpen] = useState(false)
  const [entryKey, setEntryKey] = useState(0)
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
    () => splitOvertimeHours(entry.startTime, entry.endTime, entry.dayType || 'working'),
    [entry.startTime, entry.endTime, entry.dayType],
  )
  // The summary counts the saved lines only: 0.00 hours until the first line is saved.
  const counted = lines
  const busiest = busiestMonth(rows, counted, editingNo ?? '')
  const limit = context?.maxHoursPerMonth ?? 0
  const dateObject = parseISO(entry.overtimeDate)
  const weekendHint =
    entry.dayType === 'working' && isValid(dateObject) && (dateObject.getDay() === 0 || dateObject.getDay() === 6)
      ? `${format(dateObject, 'EEEE')}: if it is your weekly rest day, choose Rest day hours.`
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
    setEntry(emptyEntry())
    setEntryOpen(false)
    setEditingLine(null)
    setEntryError(null)
    setProjectNo('')
    goTo('form')
  }

  const startEdit = (request: OvertimeRequestRow) => {
    setEditingNo(request.requestNo)
    setLines(sortLines(linesOf(request)))
    setEntry(emptyEntry())
    setEntryOpen(false)
    setEditingLine(null)
    setEntryError(null)
    setProjectNo(request.projectNo)
    goTo('form')
  }

  /** What is wrong with the line being entered (null when it can be saved). */
  const lineProblem = (draft: EntryDraft, others: OvertimeLineInput[]) => {
    if (!draft.overtimeDate) return 'Choose the overtime date.'
    if (!draft.startTime) return 'Enter the start time as HH:MM and choose AM or PM.'
    if (!draft.endTime) return 'Enter the end time as HH:MM and choose AM or PM.'
    if (splitOvertimeHours(draft.startTime, draft.endTime, 'working').totalHours <= 0) {
      return 'The end time must be different from the start time.'
    }
    if (!draft.dayType) return 'Choose the overtime category.'
    if (draft.reason.trim().length < 3) return 'Enter the reason / justification for the overtime.'
    const line: OvertimeLineInput = { ...draft, dayType: draft.dayType }
    const category = categoryProblem(line)
    if (category) return category
    const clash = others.find((other) => overlaps(line, other))
    if (clash) {
      return `It overlaps the line of ${shortDate(clash.overtimeDate)} ${clockText(clash.startTime)} – ${clockText(clash.endTime)}.`
    }
    return null
  }

  const openEntry = (draft: EntryDraft, index: number | null) => {
    setEntry(draft)
    setEditingLine(index)
    setEntryError(null)
    setEntryKey((key) => key + 1)
    setEntryOpen(true)
  }

  const openNewLine = () => openEntry(emptyEntry(), null)

  const editLine = (index: number) => {
    const line = lines[index]
    if (line) openEntry(line, index)
  }

  const cancelEntry = () => {
    setEntry(emptyEntry())
    setEditingLine(null)
    setEntryError(null)
    setEntryOpen(false)
  }

  /** Save: the line goes into the table and the card closes (Add Line opens it again). */
  const saveLine = () => {
    const others = lines.filter((_, index) => index !== editingLine)
    const problem = lineProblem(entry, others)
    if (problem || !entry.dayType) {
      setEntryError(problem ?? 'Choose the overtime category.')
      return
    }
    const line: OvertimeLineInput = { ...entry, dayType: entry.dayType, reason: entry.reason.trim() }
    setLines(sortLines(editingLine === null ? [...lines, line] : lines.map((item, index) => (index === editingLine ? line : item))))
    cancelEntry()
    setFormError(null)
  }

  /** One click: the entered line becomes a normal day line and a night line (or more), each checked. */
  const splitEntry = () => {
    if (!entry.dayType) return
    const parts = splitAtBands({ ...entry, dayType: entry.dayType })
    const others = lines.filter((_, index) => index !== editingLine)
    const added: OvertimeLineInput[] = []
    for (const part of parts) {
      const problem = lineProblem(part, [...others, ...added])
      if (problem) {
        setEntryError(problem)
        return
      }
      added.push({ ...part, reason: part.reason.trim() })
    }
    if (others.length + added.length > maxLines) {
      setEntryError(`A request can hold ${maxLines} lines. Make a second request for the other days.`)
      return
    }
    setLines(sortLines([...others, ...added]))
    cancelEntry()
    setFormError(null)
  }

  const deleteLine = (index: number) => {
    setLines(lines.filter((_, item) => item !== index))
    if (editingLine !== null) cancelEntry()
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
    let all = lines
    // A line filled in on the open card but not saved yet is saved for the employee.
    const entryStarted = entryOpen && Boolean(entry.overtimeDate || entry.startTime || entry.endTime || entry.dayType || entry.reason.trim())
    if (entryStarted) {
      const others = lines.filter((_, index) => index !== editingLine)
      const problem = lineProblem(entry, others)
      if (problem || !entry.dayType) {
        setEntryError(problem ?? 'Choose the overtime category.')
        setFormError(`Save or cancel the overtime line you are entering first. ${problem ?? ''}`.trim())
        return
      }
      if (editingLine === null && lines.length >= maxLines) {
        setFormError(`This request can hold ${maxLines} line${maxLines === 1 ? '' : 's'}. Cancel the line you are entering, or make a second request.`)
        return
      }
      const line: OvertimeLineInput = { ...entry, dayType: entry.dayType, reason: entry.reason.trim() }
      all = sortLines(editingLine === null ? [...lines, line] : lines.map((item, index) => (index === editingLine ? line : item)))
    }
    if (!all.length) {
      setFormError('Click Add Line to enter your overtime: the date, start and end time, category and reason, then Save.')
      return
    }
    setFormError(null)
    setEntryError(null)
    const first = all[0]!
    const reasons = [...new Set(all.map((line) => line.reason.trim()).filter(Boolean))]
    if (all !== lines) {
      setLines(all)
      cancelEntry()
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

          <div>
            <Section icon={<User className="h-4 w-4" />} title="Employee Information">
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
          </div>

          <Section icon={<CalendarDays className="h-4 w-4" />} title="Overtime Details">
            {shown || lines.length ? (
              <OvertimeLinesTable
                lines={
                  shown
                    ? shown.lines.map((line) => ({ ...line, hours: line, amount: line.estimatedAmount }))
                    : lines.map((line) => {
                        const hours = splitOvertimeHours(line.startTime, line.endTime, line.dayType)
                        return { ...line, hours, amount: estimateOvertimeAmount(hours, hourlyRate, rates) }
                      })
                }
                rates={rates}
                editingIndex={editingLine}
                onEdit={shown ? undefined : editLine}
                onDelete={shown ? undefined : deleteLine}
              />
            ) : null}

            {shown ? null : entryOpen ? (
              <div key={entryKey} className={cn('rounded-xl border border-slate-200 bg-white p-4 shadow-sm', lines.length ? 'mt-4' : '')}>
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <p className="text-sm font-semibold text-slate-900">
                    Overtime Details – {editingLine === null ? 'New Line' : `Edit Line ${editingLine + 1}`}
                  </p>
                  <span className="rounded-full bg-emerald-50 px-2.5 py-0.5 text-xs font-medium text-emerald-700 ring-1 ring-emerald-200">
                    {editingLine === null ? 'New Entry' : 'Editing'}
                  </span>
                </div>
                <div className="mt-4 grid gap-6 md:grid-cols-2">
                  <div className="space-y-4">
                    <p className="text-sm font-semibold text-slate-800">Date &amp; Time</p>
                    <div className="space-y-1.5">
                      <Label htmlFor="overtime-date" className="text-sm text-slate-700">
                        Overtime Date<span className="text-red-500"> *</span>
                      </Label>
                      <Input
                        id="overtime-date"
                        type="date"
                        value={entry.overtimeDate}
                        onChange={(event) => setEntry((current) => ({ ...current, overtimeDate: event.target.value }))}
                      />
                    </div>
                    <TimeField
                      id="overtime-start"
                      label="Start Time"
                      value={entry.startTime}
                      defaultMeridiem="AM"
                      onChange={(value) => setEntry((current) => ({ ...current, startTime: value }))}
                    />
                    <TimeField
                      id="overtime-end"
                      label="End Time"
                      value={entry.endTime}
                      defaultMeridiem="PM"
                      onChange={(value) => setEntry((current) => ({ ...current, endTime: value }))}
                    />
                    <div>
                      <p className="text-xs font-medium text-slate-600">Calculated Hours</p>
                      <p className="mt-1 text-xl font-bold tabular-nums text-slate-900">{entryHours.totalHours.toFixed(2)} Hours</p>
                      <p className="text-xs text-slate-500">Automatic calculation</p>
                    </div>
                  </div>
                  <div className="space-y-4">
                    <p className="text-sm font-semibold text-slate-800">Payment Details</p>
                    <div className="space-y-1.5">
                      <Label htmlFor="overtime-category" className="text-sm text-slate-700">
                        Overtime Category<span className="text-red-500"> *</span>
                      </Label>
                      <Select
                        id="overtime-category"
                        value={entry.dayType}
                        options={DAY_TYPES}
                        placeholder="Select category"
                        onChange={(event) =>
                          setEntry((current) => ({ ...current, dayType: event.target.value as OvertimeDayType | '' }))
                        }
                      />
                    </div>
                    <div>
                      <p className="text-xs font-medium text-slate-600">Rate</p>
                      <p className="mt-1 text-base font-semibold text-slate-900">
                        {entry.dayType ? rateType(entryHours, entry.dayType, rates) : 'Auto-filled'}
                      </p>
                      <p className="text-xs text-slate-500">Based on category</p>
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="overtime-reason" className="text-sm text-slate-700">
                        Reason / Justification<span className="text-red-500"> *</span>
                      </Label>
                      <Textarea
                        id="overtime-reason"
                        rows={4}
                        maxLength={250}
                        value={entry.reason}
                        placeholder="Enter reason or justification…"
                        onChange={(event) => setEntry((current) => ({ ...current, reason: event.target.value }))}
                      />
                    </div>
                  </div>
                </div>
                {weekendHint ? (
                  <p className="mt-3 flex items-center gap-2 text-xs text-amber-800">
                    <Info className="h-3.5 w-3.5" />
                    {weekendHint}
                  </p>
                ) : null}
                {(() => {
                  if (!entry.dayType || !entry.startTime || !entry.endTime || !entryHours.totalHours) return null
                  const line: OvertimeLineInput = { ...entry, dayType: entry.dayType }
                  const parts = splitAtBands(line)
                  const allNight = line.dayType === 'working' && !parts.length && Boolean(categoryProblem(line))
                  const allDay = line.dayType === 'night' && !parts.length && Boolean(categoryProblem(line))
                  if (!parts.length && !allNight && !allDay) return null
                  return (
                    <div className="mt-3 flex flex-wrap items-center gap-3 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-900">
                      <Info className="h-4 w-4 shrink-0" />
                      <span className="min-w-0 flex-1">
                        {parts.length
                          ? `${clockText(line.startTime)} – ${clockText(line.endTime)} has normal day and night hours, which are paid at different rates: they go on separate lines (${parts
                              .map((part) => `${clockText(part.startTime)} – ${clockText(part.endTime)} ${part.dayType === 'night' ? 'night' : 'normal day'}`)
                              .join(', ')}).`
                          : allNight
                            ? 'These hours are at night (10 PM – 6 AM): choose Night hours.'
                            : 'These hours are in the day (6 AM – 10 PM): choose Normal day hours.'}
                      </span>
                      <Button
                        type="button"
                        size="sm"
                        variant="outline"
                        className="border-amber-300 bg-white"
                        onClick={() =>
                          parts.length
                            ? splitEntry()
                            : setEntry((current) => ({ ...current, dayType: allNight ? 'night' : 'working' }))
                        }
                      >
                        {parts.length ? `Split into ${parts.length} lines` : allNight ? 'Use Night hours' : 'Use Normal day hours'}
                      </Button>
                    </div>
                  )
                })()}
                {entryError ? (
                  <p role="alert" className="mt-3 flex items-center gap-2 text-sm text-red-700">
                    <AlertTriangle className="h-4 w-4 shrink-0" />
                    {entryError}
                  </p>
                ) : null}
                <div className="mt-4 flex justify-end gap-2">
                  <Button type="button" variant="outline" className="rounded-full" disabled={busy} onClick={cancelEntry}>
                    Cancel
                  </Button>
                  <Button
                    type="button"
                    className="rounded-full bg-emerald-600 text-white hover:bg-emerald-700"
                    disabled={busy}
                    onClick={saveLine}
                  >
                    <Save className="mr-2 h-4 w-4" />
                    Save
                  </Button>
                </div>
              </div>
            ) : (
              <div className={lines.length ? 'mt-4' : ''}>
                <button
                  type="button"
                  className="flex w-full items-center justify-center gap-2 rounded-full border border-slate-300 bg-white py-2.5 text-sm font-medium text-slate-800 transition hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-50"
                  disabled={busy || lines.length >= maxLines}
                  onClick={openNewLine}
                >
                  <Plus className="h-4 w-4" />
                  Add Line
                </button>
                <p className="mt-2 text-xs text-slate-500">
                  {lines.length >= maxLines
                    ? maxLines === 1
                      ? 'Several dates in one request need Business Central package 1.0.3.612. Make one request per date for now.'
                      : `A request can hold ${maxLines} lines. Make a second request for the other days.`
                    : lines.length
                      ? 'Click Add Line to enter another overtime record.'
                      : 'Click Add Line to open the overtime entry form.'}
                </p>
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
