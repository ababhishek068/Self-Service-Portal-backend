import { useMemo, useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  ArrowLeft,
  BadgeCheck,
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
  UserCheck,
  UserRound,
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
import { ProcessTracker } from '@/components/shared/ProcessTracker'
import { stageFromSteps } from '@/data/processStages'
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

/**
 * One entry on the form covers a period: Start Date → End Date on the chosen days of the week
 * (for example a driver's daily pick-up at the same time). BC keeps one line per overtime day
 * (ABH Overtime Request Line, at most 31), so the entry is split into daily lines when saved.
 */
type EntryDraft = {
  startDate: string
  endDate: string
  /** Days of the week the period applies to (0 = Sunday … 6 = Saturday). */
  weekdays: number[]
  /** Single dates taken out of the period (for example a public holiday). */
  excluded: string[]
  startTime: string
  endTime: string
  dayType: OvertimeDayType | ''
  workLocation: OvertimeWorkLocation | ''
  reason: string
}

/** BC 1.0.3.636 MaxLines: one overtime request holds at most 31 daily lines. */
const MAX_OVERTIME_DAYS = 31
const ALL_WEEKDAYS = [0, 1, 2, 3, 4, 5, 6]
const WEEKDAY_CHIPS: Array<{ value: number; short: string }> = [
  { value: 1, short: 'Mon' },
  { value: 2, short: 'Tue' },
  { value: 3, short: 'Wed' },
  { value: 4, short: 'Thu' },
  { value: 5, short: 'Fri' },
  { value: 6, short: 'Sat' },
  { value: 0, short: 'Sun' },
]
const ISO_DATE = /^\d{4}-\d{2}-\d{2}$/
const DAY_MS = 86_400_000

function emptyEntry(): EntryDraft {
  return {
    startDate: '',
    endDate: '',
    weekdays: [...ALL_WEEKDAYS],
    excluded: [],
    startTime: '',
    endTime: '',
    dayType: '',
    workLocation: '',
    reason: '',
  }
}

function sortLines(lines: WorkLineInput[]) {
  return [...lines].sort((a, b) => (a.overtimeDate + a.startTime).localeCompare(b.overtimeDate + b.startTime))
}

function dayIndex(date: string) {
  return Date.UTC(Number(date.slice(0, 4)), Number(date.slice(5, 7)) - 1, Number(date.slice(8, 10))) / DAY_MS
}

function weekdayOf(date: string) {
  return new Date(dayIndex(date) * DAY_MS).getUTCDay()
}

function weekdayShort(date: string) {
  return WEEKDAY_CHIPS.find((chip) => chip.value === weekdayOf(date))?.short ?? ''
}

/** Calendar days from start to end inclusive (0 when either date is missing or end is before start). */
function periodSpan(start: string, end: string) {
  if (!ISO_DATE.test(start) || !ISO_DATE.test(end)) return 0
  const span = dayIndex(end) - dayIndex(start) + 1
  return span > 0 ? span : 0
}

/** Every date from start to end (inclusive) that falls on one of the weekdays. */
function periodDates(start: string, end: string, weekdays: number[]) {
  const span = periodSpan(start, end)
  if (!span || span > 366) return []
  const first = dayIndex(start)
  const dates: string[] = []
  for (let day = first; day < first + span; day += 1) {
    const date = new Date(day * DAY_MS)
    if (weekdays.includes(date.getUTCDay())) dates.push(date.toISOString().slice(0, 10))
  }
  return dates
}

function entryEnd(entry: Pick<EntryDraft, 'startDate' | 'endDate'>) {
  return entry.endDate || entry.startDate
}

function entryDates(entry: EntryDraft) {
  return periodDates(entry.startDate, entryEnd(entry), entry.weekdays).filter((date) => !entry.excluded.includes(date))
}

function lineKey(line: Pick<WorkLineInput, 'startTime' | 'endTime' | 'dayType' | 'workLocation'>) {
  return [line.startTime, line.endTime, line.dayType, line.workLocation].join('|')
}

/** Saved daily lines with the same time, category and location, shown (and edited) as one period. */
type LineGroup = { key: string; line: WorkLineInput; dates: string[] }

function groupLines(lines: WorkLineInput[]): LineGroup[] {
  const groups = new Map<string, LineGroup>()
  for (const line of lines) {
    const key = lineKey(line)
    const group = groups.get(key)
    if (group) group.dates.push(line.overtimeDate)
    else groups.set(key, { key, line, dates: [line.overtimeDate] })
  }
  return [...groups.values()]
    .map((group) => ({ ...group, dates: [...group.dates].sort() }))
    .sort((a, b) => (a.dates[0]! + a.line.startTime).localeCompare(b.dates[0]! + b.line.startTime))
}

/**
 * The weekdays a saved period runs on: every weekday except those that fall inside the
 * period but were never worked (a 3-day period keeps all seven, so it can still be extended).
 */
function groupWeekdays(dates: string[]) {
  if (dates.length < 2) return [...ALL_WEEKDAYS]
  const span = periodDates(dates[0]!, dates[dates.length - 1]!, ALL_WEEKDAYS)
  const worked = new Set(dates.map(weekdayOf))
  const skipped = new Set(span.map(weekdayOf).filter((day) => !worked.has(day)))
  return ALL_WEEKDAYS.filter((day) => !skipped.has(day))
}

function entryFromGroup(group: LineGroup): EntryDraft {
  const startDate = group.dates[0]!
  const endDate = group.dates[group.dates.length - 1]!
  const weekdays = groupWeekdays(group.dates)
  return {
    startDate,
    endDate,
    weekdays,
    excluded: periodDates(startDate, endDate, weekdays).filter((date) => !group.dates.includes(date)),
    startTime: group.line.startTime,
    endTime: group.line.endTime,
    dayType: group.line.dayType,
    workLocation: group.line.workLocation,
    reason: group.line.reason,
  }
}

/** "Mon–Fri", "Sat, Sun" or "Mon, Wed, Fri" for the weekdays a period was worked on. */
function weekdaySummary(dates: string[]) {
  const worked = new Set(dates.map(weekdayOf))
  const runs: string[][] = []
  for (const chip of WEEKDAY_CHIPS) {
    if (!worked.has(chip.value)) runs.push([])
    else (runs[runs.length - 1] ?? runs[runs.push([]) - 1]!).push(chip.short)
  }
  return runs
    .filter((run) => run.length)
    .map((run) => (run.length > 2 ? `${run[0]}–${run[run.length - 1]}` : run.join(', ')))
    .join(', ')
}

/** Minutes covered by a line counted from 1 Jan 1970; an end before the start runs into the next morning. */
function lineSlot(date: string, startTime: string, endTime: string) {
  const minutes = (value: string) => {
    const [hours, mins] = value.split(':').map(Number)
    return (hours || 0) * 60 + (mins || 0)
  }
  const start = minutes(startTime)
  let end = minutes(endTime)
  if (end <= start) end += 1440
  const base = dayIndex(date) * 1440
  return { start: base + start, end: base + end }
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

/** Stage 1 on the live Workflow Progress tracker: the employee, each BC approver (Superior, FAD), then work authorized. */
function OvertimeWorkProgress({ request }: { request: OvertimeWorkRow }) {
  const submitted = request.status !== 'Draft'
  const rows = [
    { key: 'employee', heading: 'Employee', owner: request.employeeName || 'You', icon: UserRound, state: submitted ? 'done' : 'open', caption: 'Draft' },
    ...request.steps.map((step) => ({
      key: `stage-${step.stage}`,
      heading: step.label || `Approver ${step.stage}`,
      owner: step.approverName || step.approverUserId || 'Set by BC',
      icon: UserCheck,
      state: step.status === 'Approved' || step.status === 'Skipped' ? 'done' : step.status === 'Rejected' ? 'rejected' : 'open',
      caption: step.status === 'Pending' ? 'Pending approval' : step.status,
    })),
    {
      key: 'authorized',
      heading: 'Work authorized',
      owner: 'Then request payment',
      icon: BadgeCheck,
      state: request.status === 'Approved' ? 'done' : request.status === 'Cancelled' ? 'rejected' : 'open',
      caption: request.status === 'Cancelled' ? 'Cancelled' : 'Waiting for approval',
    },
  ] as const
  const steps = rows.map((row) => ({ state: row.state, caption: row.caption }))
  return (
    <ProcessTracker
      title="Workflow Progress"
      steps={rows.map(({ key, heading, owner, icon }) => ({ key, heading, owner, icon }))}
      stage={stageFromSteps(steps as Array<{ state: 'done' | 'rejected' | 'open'; caption?: string }>)}
    />
  )
}

/**
 * The same Workflow Progress tracker on the new / edit form: the employee is at step 1 until the
 * request is submitted; Superior and FAD (Stage 1 in BC) follow, named from the BC routing.
 */
function OvertimeWorkFormProgress({
  approvers,
  employeeName,
  lineCount,
  hasReason,
}: {
  approvers: Array<{ label?: string; approverName?: string; approverUserId?: string }>
  employeeName?: string
  lineCount: number
  hasReason: boolean
}) {
  const named = (pattern: RegExp, index: number) =>
    approvers.find((step) => pattern.test(step.label ?? '')) ?? approvers[index]
  const superior = named(/superior|line manager/i, 0)
  const fad = named(/fad|fd|finance|director|authori[sz]ed/i, 1)
  const caption = !lineCount ? 'Add the overtime lines' : !hasReason ? 'Add the justification' : 'Ready · Submit for approval'
  return (
    <ProcessTracker
      title="Workflow Progress"
      steps={[
        { key: 'employee', heading: 'Employee', owner: employeeName || 'You', icon: UserRound },
        { key: 'superior', heading: 'Superior', owner: superior?.approverName || superior?.approverUserId || 'Set by BC', icon: UserCheck },
        { key: 'fad', heading: 'FAD', owner: fad?.approverName || fad?.approverUserId || 'Set by BC', icon: UserCheck },
        { key: 'authorized', heading: 'Work authorized', owner: 'Then request payment', icon: BadgeCheck },
      ]}
      stage={{ index: 0, state: 'active', caption }}
    />
  )
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
  /** lineKey of the saved period being edited (null for a new one). */
  const [editingLine, setEditingLine] = useState<string | null>(null)
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
  const entryDays = entryDates(entry)
  const entryPeriodDates = periodDates(entry.startDate, entryEnd(entry), entry.weekdays)
  const entrySpan = periodSpan(entry.startDate, entryEnd(entry))
  const lineGroups = groupLines(lines)
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

  /** The saved lines plus the open entry split into one line per day, or the reason it cannot be saved. */
  const mergeEntry = (draft: EntryDraft): { lines: WorkLineInput[] } | { problem: string } => {
    const end = entryEnd(draft)
    if (!draft.startDate) return { problem: 'Choose the start date.' }
    if (end < draft.startDate) return { problem: 'The end date must be on or after the start date.' }
    if (periodSpan(draft.startDate, end) > MAX_OVERTIME_DAYS) {
      return { problem: `A period can cover at most ${MAX_OVERTIME_DAYS} days. Make a second request for the other days.` }
    }
    if (!draft.startTime) return { problem: 'Enter the start time.' }
    if (!draft.endTime) return { problem: 'Enter the end time.' }
    if (splitOvertimeHours(draft.startTime, draft.endTime, 'working').totalHours <= 0) {
      return { problem: 'The end time must be different from the start time.' }
    }
    if (!draft.dayType) return { problem: 'Choose the overtime category.' }
    if (!draft.workLocation) return { problem: 'Choose the work location.' }
    const dates = entryDates(draft)
    if (!dates.length) return { problem: 'No days are left in this period. Tick at least one day of the week.' }
    const others = editingLine === null ? lines : lines.filter((line) => lineKey(line) !== editingLine)
    if (others.length + dates.length > MAX_OVERTIME_DAYS) {
      return {
        problem: `One overtime request holds at most ${MAX_OVERTIME_DAYS} daily lines; this would make ${others.length + dates.length}. Shorten the period or make a second request for the other days.`,
      }
    }
    for (const date of dates) {
      const slot = lineSlot(date, draft.startTime, draft.endTime)
      const clash = others.find((other) => {
        const taken = lineSlot(other.overtimeDate, other.startTime, other.endTime)
        return taken.start < slot.end && slot.start < taken.end
      })
      if (clash) {
        return {
          problem: `${shortDate(date)} overlaps the saved line ${shortDate(clash.overtimeDate)} ${clockText(clash.startTime)} – ${clockText(clash.endTime)}.`,
        }
      }
    }
    // Line reason is not collected here — the single Justification section below covers it.
    const added = dates.map<WorkLineInput>((overtimeDate) => ({
      overtimeDate,
      startTime: draft.startTime,
      endTime: draft.endTime,
      dayType: draft.dayType as OvertimeDayType,
      workLocation: draft.workLocation as OvertimeWorkLocation,
      reason: reason.trim() || draft.reason.trim(),
    }))
    return { lines: sortLines([...others, ...added]) }
  }

  const closeEntry = () => {
    setEntry(emptyEntry())
    setEditingLine(null)
    setEntryOpen(false)
    setEntryError(null)
  }

  const saveLine = () => {
    const merged = mergeEntry(entry)
    if ('problem' in merged) {
      setEntryError(merged.problem)
      return
    }
    setLines(merged.lines)
    closeEntry()
    setFormError(null)
  }

  const submit = (forApproval: boolean) => {
    setFormError(null)
    let all = lines
    if (entryOpen && (entry.startDate || entry.startTime || entry.endTime || entry.dayType || entry.workLocation)) {
      const merged = mergeEntry(entry)
      if ('problem' in merged) {
        setEntryError(merged.problem)
        setFormError('Save or cancel the overtime line you are entering first.')
        return
      }
      all = merged.lines
    }
    if (!all.length) {
      setFormError('Click Add Line to enter overtime: start and end date, times, category, and work location, then Save.')
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
          Enter the overtime lines: a start and end date (one day, or a period worked at the same time every
          day) and the start/end time. Superior then FAD approve the work.
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
        <div className="portal-rise-children space-y-4">
          <OvertimeWorkProgress request={shown} />
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
          <OvertimeWorkFormProgress
            approvers={contextQuery.data?.approvers ?? []}
            employeeName={employee?.employeeName}
            lineCount={lines.length}
            hasReason={reason.trim().length >= 5 && expectedDeliverables.trim().length >= 3}
          />
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
                Each line has a <span className="font-medium text-slate-800">Start Date</span> and{' '}
                <span className="font-medium text-slate-800">End Date</span>: pick the same date for one day, or a
                period when the overtime repeats at the same time (for example a driver&apos;s daily pick-up). For a
                period, untick the days of the week not worked or remove single dates such as a holiday. The portal
                saves one line per day in Business Central (at most {MAX_OVERTIME_DAYS} days per request). The
                request period is from the earliest to the latest date
                {lines.length
                  ? ` (${shortDate(sortLines(lines)[0]!.overtimeDate)} → ${shortDate(sortLines(lines)[lines.length - 1]!.overtimeDate)})`
                  : ''}
                .
              </p>
              {lineGroups.length ? (
                <ul className="mb-4 space-y-2">
                  {lineGroups.map((group, index) => {
                    const first = group.dates[0]!
                    const last = group.dates[group.dates.length - 1]!
                    const perDay = splitOvertimeHours(group.line.startTime, group.line.endTime, group.line.dayType).totalHours
                    const consecutive = periodSpan(first, last) === group.dates.length
                    return (
                      <li
                        key={group.key}
                        className={`flex flex-wrap items-center gap-2 rounded-lg border px-3 py-2 text-sm ${
                          editingLine === group.key ? 'border-teal-300 bg-teal-50/60' : 'border-slate-100 bg-slate-50/80'
                        }`}
                      >
                        <span className="text-xs font-semibold text-slate-400 tabular-nums">{index + 1}.</span>
                        <span className="font-medium text-slate-900">
                          {first === last ? shortDate(first) : `${shortDate(first)} → ${shortDate(last)}`}
                        </span>
                        {group.dates.length > 1 ? (
                          <span
                            className="rounded-full bg-teal-100 px-2 py-0.5 text-xs font-semibold text-teal-800"
                            title={group.dates.map(shortDate).join(', ')}
                          >
                            {group.dates.length} days{consecutive ? '' : ` · ${weekdaySummary(group.dates)}`}
                          </span>
                        ) : (
                          <span className="text-xs text-slate-500">{weekdayShort(first)}</span>
                        )}
                        <span className="text-slate-600">
                          {clockText(group.line.startTime)} – {clockText(group.line.endTime)}
                        </span>
                        <span className="text-slate-600">
                          {DAY_TYPES.find((d) => d.value === group.line.dayType)?.label.split(' (')[0]}
                        </span>
                        <span className="inline-flex items-center gap-1 text-slate-600">
                          <MapPin className="h-3.5 w-3.5" />
                          {locationLabel(group.line.workLocation)}
                        </span>
                        <span className="tabular-nums text-slate-700">
                          {group.dates.length > 1
                            ? `${perDay.toFixed(2)}h × ${group.dates.length} = ${(perDay * group.dates.length).toFixed(2)}h`
                            : `${perDay.toFixed(2)}h`}
                        </span>
                        <span className="ml-auto flex gap-1">
                          <Button
                            type="button"
                            variant="ghost"
                            size="sm"
                            onClick={() => {
                              setEntry(entryFromGroup(group))
                              setEditingLine(group.key)
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
                              setLines(lines.filter((line) => lineKey(line) !== group.key))
                              if (editingLine === group.key) closeEntry()
                            }}
                          >
                            Delete
                          </Button>
                        </span>
                      </li>
                    )
                  })}
                </ul>
              ) : null}

              {entryOpen ? (
                <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
                  <p className="text-sm font-semibold text-slate-900">
                    {editingLine === null
                      ? 'New Line'
                      : `Edit Line ${lineGroups.findIndex((group) => group.key === editingLine) + 1}`}
                  </p>
                  <div className="mt-4 grid gap-4 md:grid-cols-2">
                    <div className="space-y-1.5">
                      <Label htmlFor="otw-start-date">Start Date *</Label>
                      <Input
                        id="otw-start-date"
                        type="date"
                        value={entry.startDate}
                        onChange={(event) => {
                          const startDate = event.target.value
                          // One day by default: the end date follows until it is set to a later date.
                          setEntry((current) => ({
                            ...current,
                            startDate,
                            endDate: !current.endDate || current.endDate < startDate ? startDate : current.endDate,
                          }))
                        }}
                      />
                    </div>
                    <div className="space-y-1.5">
                      <Label htmlFor="otw-end-date">End Date *</Label>
                      <Input
                        id="otw-end-date"
                        type="date"
                        value={entry.endDate}
                        min={entry.startDate || undefined}
                        onChange={(event) => setEntry((current) => ({ ...current, endDate: event.target.value }))}
                      />
                    </div>
                    {entrySpan > 1 ? (
                      <div className="space-y-2 rounded-lg border border-teal-100 bg-teal-50/50 p-3 md:col-span-2">
                        <div className="flex flex-wrap items-center gap-2">
                          <span className="text-xs font-medium text-slate-700">Days worked</span>
                          {WEEKDAY_CHIPS.map((chip) => {
                            const on = entry.weekdays.includes(chip.value)
                            return (
                              <button
                                key={chip.value}
                                type="button"
                                aria-pressed={on}
                                className={`rounded-full border px-2.5 py-0.5 text-xs font-semibold transition ${
                                  on
                                    ? 'border-teal-600 bg-teal-600 text-white hover:bg-teal-700'
                                    : 'border-slate-300 bg-white text-slate-500 line-through hover:border-slate-400'
                                }`}
                                onClick={() =>
                                  setEntry((current) => ({
                                    ...current,
                                    weekdays: on
                                      ? current.weekdays.filter((day) => day !== chip.value)
                                      : [...current.weekdays, chip.value],
                                  }))
                                }
                              >
                                {chip.short}
                              </button>
                            )
                          })}
                        </div>
                        {entryPeriodDates.length ? (
                          <div className="flex flex-wrap gap-1.5">
                            {entryPeriodDates.map((date) => {
                              const removed = entry.excluded.includes(date)
                              return (
                                <button
                                  key={date}
                                  type="button"
                                  title={removed ? 'Add this day back' : 'Remove this day (for example a holiday)'}
                                  className={`inline-flex items-center gap-1 rounded-md border px-1.5 py-0.5 text-[11px] tabular-nums transition ${
                                    removed
                                      ? 'border-dashed border-slate-300 bg-white text-slate-400 line-through'
                                      : 'border-teal-200 bg-white text-teal-900 hover:border-rose-300 hover:text-rose-700'
                                  }`}
                                  onClick={() =>
                                    setEntry((current) => ({
                                      ...current,
                                      excluded: removed
                                        ? current.excluded.filter((item) => item !== date)
                                        : [...current.excluded, date],
                                    }))
                                  }
                                >
                                  {weekdayShort(date)} {shortDate(date).slice(0, 5)}
                                  <span aria-hidden="true">{removed ? '+' : '×'}</span>
                                </button>
                              )
                            })}
                          </div>
                        ) : null}
                        <p className="text-xs text-slate-600">
                          {entryDays.length} overtime day{entryDays.length === 1 ? '' : 's'} in this period
                          {entrySpan > MAX_OVERTIME_DAYS ? ` — a period can cover at most ${MAX_OVERTIME_DAYS} days` : ''}
                          . Click a date to remove it, click it again to add it back.
                        </p>
                      </div>
                    ) : null}
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
                      <p className="text-xs font-medium text-slate-600">Calculated Days</p>
                      <p className="mt-1 text-xl font-bold tabular-nums text-slate-900">
                        {entryDays.length} {entryDays.length === 1 ? 'Day' : 'Days'}
                      </p>
                      {entryDays.length > 1 ? (
                        <p className="text-xs tabular-nums text-slate-600">
                          {shortDate(entryDays[0]!)} → {shortDate(entryDays[entryDays.length - 1]!)}
                          {entryDays.length < entrySpan ? ` · ${entrySpan - entryDays.length} day(s) not worked` : ''}
                        </p>
                      ) : null}
                    </div>
                    <div className="md:col-span-2">
                      <p className="text-xs font-medium text-slate-600">Calculated Hours</p>
                      <p className="mt-1 text-xl font-bold tabular-nums text-slate-900">
                        {entryDays.length > 1
                          ? `${(entryHours.totalHours * entryDays.length).toFixed(2)} Hours`
                          : `${entryHours.totalHours.toFixed(2)} Hours`}
                      </p>
                      {entryDays.length > 1 ? (
                        <p className="text-xs tabular-nums text-slate-600">
                          {entryHours.totalHours.toFixed(2)} h per day × {entryDays.length} days
                        </p>
                      ) : null}
                      <p className="mt-1 text-xs text-slate-500">
                        Reason / justification is entered once below under Justification.
                      </p>
                    </div>
                  </div>
                  {entryError ? <p className="mt-3 text-sm text-red-700">{entryError}</p> : null}
                  <div className="mt-4 flex justify-end gap-2">
                    <Button type="button" variant="outline" onClick={closeEntry}>
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
