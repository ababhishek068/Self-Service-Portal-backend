import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { format, isValid, parseISO } from 'date-fns'
import {
  AlertTriangle,
  ArrowLeft,
  CalendarDays,
  CheckCircle2,
  Clock,
  Eye,
  Flag,
  History,
  Info,
  Landmark,
  Network,
  Pencil,
  Printer,
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
import { useEffect, useMemo, useState, type ReactElement, type ReactNode } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { ProcessTracker } from '@/components/shared/ProcessTracker'
import { stageFromSteps } from '@/data/processStages'
import {
  estimateOvertimeAmount,
  fetchOvertimeContext,
  fetchOvertimeRequests,
  splitOvertimeHours,
  type OvertimeContext,
  type OvertimeDayType,
  type OvertimeLineInput,
  type OvertimeRequest as OvertimeRequestRow,
  type OvertimeStep,
} from '@/api/endpoints/overtime'
import {
  deleteOtPaymentRequest,
  fetchOtPaymentContext,
  fetchOtPaymentRequests,
  saveOtPaymentRequest,
  withdrawOtPaymentRequest,
  type OtPaymentRequest,
} from '@/api/endpoints/overtimePayments'
import { fetchOvertimeWorkRequests, type OvertimeWorkRequest as OvertimeWorkRow } from '@/api/endpoints/overtimeWork'
import { getLocalPurchaseProjects } from '@/api/endpoints/requestEndpoint'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { HistorySection } from '@/components/shared/HistorySection'
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

const LIST_KEY = ['hr', 'overtime-payments'] as const

function otPaymentAsListRow(row: OtPaymentRequest): OvertimeRequestRow {
  const stage1 = row.otRequest
  return {
    id: row.paymentNo,
    requestNo: row.paymentNo,
    status: row.status === 'Cancelled' ? 'Rejected' : row.status,
    stage: row.stage ?? 0,
    stageLabel: row.stageLabel || row.status,
    employeeNo: row.employeeNo,
    employeeName: row.employeeName,
    designation: row.designation ?? stage1?.designation ?? '',
    departmentCode: row.departmentCode ?? stage1?.departmentCode ?? '',
    departmentName: row.departmentName ?? stage1?.departmentName ?? '',
    costCentre: row.costCentre ?? stage1?.costCentre ?? '',
    projectNo: stage1?.projectNo ?? '',
    projectName: stage1?.projectName ?? '',
    overtimeDate: stage1?.overtimeDate || row.workCompletedOn,
    startTime: stage1?.startTime ?? '',
    endTime: stage1?.endTime ?? '',
    dayType: stage1?.dayType ?? 'working',
    dayTypeLabel: stage1?.dayTypeLabel ?? '',
    totalHours: row.totalHours || stage1?.totalHours || 0,
    normalHours: stage1?.normalHours ?? 0,
    nightHours: stage1?.nightHours ?? 0,
    restDayHours: stage1?.restDayHours ?? 0,
    holidayHours: stage1?.holidayHours ?? 0,
    hourlyRate: stage1?.hourlyRate ?? 0,
    estimatedAmount: row.estimatedAmount || stage1?.estimatedAmount || 0,
    reason: row.employeeRemarks || `Payment for ${row.otRequestNo}`,
    warnings: stage1?.warnings ?? '',
    requesterUserId: '',
    createdAt: row.createdAt,
    submittedAt: row.submittedAt,
    approvedAt: row.approvedAt,
    rejectedAtStage: row.rejectedAtStage ?? '',
    decisionRemarks: row.decisionRemarks || row.superiorJustification,
    sheetNo: stage1?.sheetNo ?? '',
    addedToSheet: row.addedToSheet,
    addedAt: stage1?.addedAt ?? '',
    sheetNote: stage1?.sheetNote ?? '',
    sheetStatus: stage1?.sheetStatus ?? '',
    payrollPeriodName: stage1?.payrollPeriodName ?? '',
    sentToPayroll: stage1?.sentToPayroll ?? false,
    sentToPayrollAt: stage1?.sentToPayrollAt ?? '',
    steps: row.steps ?? [],
    log: [],
    lines: stage1?.lines ?? [],
    linesFromBc: Boolean(stage1?.lines?.length),
    canRequestPayment: false,
    workAuthorized: true,
    paymentRequestNo: row.paymentNo,
    paymentApproved: row.status === 'Approved',
    otRequestNo: row.otRequestNo,
    workCompletedOn: row.workCompletedOn,
    employeeRemarks: row.employeeRemarks,
    superiorJustification: row.superiorJustification,
  }
}

/** Default "work completed on": the last overtime date, never in the future. */
function defaultWorkCompletedOn(lines: Array<{ overtimeDate: string }>) {
  const today = format(new Date(), 'yyyy-MM-dd')
  const last = lines.map((line) => line.overtimeDate).filter(Boolean).sort().at(-1) ?? ''
  return last && last <= today ? last : today
}

const CONTEXT_KEY = ['hr', 'overtime-context'] as const

const DAY_TYPES: Array<{ value: OvertimeDayType; label: string }> = [
  { value: 'working', label: 'Normal day hours (6 AM – 10 PM)' },
  { value: 'night', label: 'Night hours (10 PM – 6 AM)' },
  { value: 'restDay', label: 'Rest day hours' },
  { value: 'holiday', label: 'Public holiday hours' },
]

type Mode = 'form' | 'list' | 'detail'

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

/** Intended chain (1.0.3.623+): Line Manager → FD → HR (OT payment) → Finance (pays). */
function displayOtStepLabel(label: string): string {
  const role = label.trim().toLowerCase()
  // Old BC (pre-622) still returns "Director / COO" for the FD step.
  if (role === 'director / coo' || role === 'director' || role === 'coo') return 'FD'
  return label.trim() || label
}

/** The icon of a step by its role (BC 1.0.3.623: Line Manager, then FD, HR, Finance from the BC workflow). */
function stepIcon(label: string): ReactNode {
  const role = displayOtStepLabel(label).toLowerCase()
  if (role === 'line manager') return <Users className="h-5 w-5" />
  if (role === 'fd') return <UserCog className="h-5 w-5" />
  if (role === 'hr') return <ShieldCheck className="h-5 w-5" />
  if (role === 'finance') return <Landmark className="h-5 w-5" />
  return <UserCog className="h-5 w-5" />
}

function approverStep(step: OvertimeStep): StepView {
  const label = displayOtStepLabel(step.label)
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
    label,
    icon: stepIcon(label),
    person: step.approverName || step.approverUserId || 'Not set in BC',
    status: step.status === 'Not started' ? 'Not started' : step.status,
    tone,
    at: step.decidedAt,
    note: step.status === 'Skipped' ? step.skipReason : step.comment,
  }
}

/** Old Overtime Setup warning → the chain the business asked for. */
function overtimeRoutingMessage(raw: string): string {
  const text = raw.trim()
  if (!text) return ''
  if (/director\s*\/\s*coo|hr approver|overtime setup/i.test(text)) {
    return (
      'Overtime must go: Employee → Line Manager → FD (final approval) → HR (prepare OT payment) → Finance (pays). ' +
      'Business Central is still on the old Overtime Setup approvers (HR / Director·COO / Finance). ' +
      'HR must publish BC 1.0.3.623+ and enable an Overtime workflow whose Workflow User Group is ordered FD, then HR, then Finance.'
    )
  }
  return text
}

/** Old BC returned LM → HR → Director/COO → Finance. Show LM → FD → HR → Finance. */
function orderedOtApprovers(steps: OvertimeStep[]): OvertimeStep[] {
  const lm = steps.find((step) => displayOtStepLabel(step.label).toLowerCase() === 'line manager')
  const hr = steps.find((step) => displayOtStepLabel(step.label).toLowerCase() === 'hr')
  const fd = steps.find((step) => {
    const label = displayOtStepLabel(step.label).toLowerCase()
    return label === 'fd' || /director|coo/i.test(step.label)
  })
  const finance = steps.find((step) => displayOtStepLabel(step.label).toLowerCase() === 'finance')
  const usedOldDirectorOrder = Boolean(fd && hr && finance && /director|coo/i.test(fd.label))
  if (!usedOldDirectorOrder) return steps
  const picked = new Set([lm, fd, hr, finance].filter(Boolean))
  const rest = steps.filter((step) => !picked.has(step))
  return [...(lm ? [lm] : []), fd!, hr!, finance!, ...rest].map((step, index) => ({
    ...step,
    stage: index + 1,
    label: displayOtStepLabel(step.label),
  }))
}

type WorkflowPreview = { approvers: OvertimeStep[]; approvalWorkflow: string }

function workflowSteps(request: OvertimeRequestRow | null, context: WorkflowPreview | undefined, employeeName: string): StepView[] {
  // Before BC 1.0.3.622 a draft showed who it would go to; since then the BC workflow sets them on submit.
  const rawSteps =
    request && request.status !== 'Draft' && request.steps.length ? request.steps : (context?.approvers ?? [])
  const steps = orderedOtApprovers(rawSteps)
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
  // BC 1.0.3.622: the approvers come from the Business Central workflow (like Leave) when it is sent.
  const workflowPending: StepView = {
    key: 'approvers',
    label: 'Approvers',
    icon: <Users className="h-5 w-5" />,
    person: context?.approvalWorkflow || 'Business Central workflow',
    status: 'Set by HR in BC',
    tone: 'idle',
    at: '',
    note: submitted ? '' : 'Shown here once you submit',
  }
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
    // Only the line manager is known before sending when the BC workflow does not use a Workflow User Group.
    ...(steps.some((step) => step.label !== 'Line Manager') ? [] : [workflowPending]),
    payroll,
  ]
}

/** The overtime payment chain on the live Workflow Progress tracker; View details keeps each step's status, date and note. */
function WorkflowTracker({ steps }: { steps: StepView[] }) {
  const stage = stageFromSteps(
    steps.map((step) => ({
      state: step.tone === 'done' || step.tone === 'skipped' ? 'done' : step.tone === 'rejected' ? 'rejected' : 'open',
      caption: step.status,
    })),
  )
  return (
    <ProcessTracker
      title="Workflow Progress"
      stage={stage}
      steps={steps.map((step) => ({ key: step.key, heading: step.label, owner: step.person || '—', icon: step.icon as ReactElement }))}
      details={
        <ol className="space-y-1.5 pl-6 marker:font-semibold marker:text-slate-800">
          {steps.map((step) => (
            <li key={step.key} className="list-decimal pl-1 leading-relaxed">
              <span className="font-semibold text-slate-900">{step.label}</span>
              {step.person ? ` (${step.person})` : ''} — {step.status}
              {step.at ? ` · ${formatDateTime(step.at)}` : ''}
              {step.note ? <span className="block text-xs italic text-slate-600">{step.note}</span> : null}
            </li>
          ))}
        </ol>
      }
    />
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

function escapeHtml(value: string) {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
}

/** Printable copy of an approved OT work request for verification / audit. */
function printApprovedWorkRequest(work: OvertimeWorkRow) {
  const lines = work.lines?.length
    ? work.lines
    : [
        {
          overtimeDate: work.overtimeDate,
          startTime: work.overtimeFrom,
          endTime: work.overtimeTo,
          dayType: 'working',
          reason: work.reason,
          totalHours: work.totalHours,
        },
      ]
  const rows = lines
    .map(
      (line) =>
        `<tr>
          <td>${escapeHtml(line.overtimeDate)}</td>
          <td>${escapeHtml(line.startTime)} – ${escapeHtml(line.endTime)}</td>
          <td>${escapeHtml(String(line.dayType))}</td>
          <td>${Number(line.totalHours || 0).toFixed(2)}</td>
          <td>${escapeHtml(line.reason || work.reason || '')}</td>
        </tr>`,
    )
    .join('')
  const html = `<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <title>${escapeHtml(work.requestNo)} — Overtime Work Request</title>
  <style>
    body { font-family: Georgia, "Times New Roman", serif; color: #0f172a; margin: 2rem; }
    h1 { font-size: 1.35rem; margin: 0 0 0.25rem; }
    .meta { color: #475569; margin-bottom: 1.25rem; font-size: 0.95rem; }
    dl { display: grid; grid-template-columns: 11rem 1fr; gap: 0.35rem 1rem; margin: 0 0 1.25rem; }
    dt { color: #64748b; } dd { margin: 0; font-weight: 600; }
    table { width: 100%; border-collapse: collapse; margin-top: 0.75rem; }
    th, td { border: 1px solid #cbd5e1; padding: 0.45rem 0.6rem; text-align: left; font-size: 0.92rem; }
    th { background: #f8fafc; }
    .footer { margin-top: 1.5rem; font-size: 0.85rem; color: #64748b; }
    @media print { body { margin: 0.75rem; } }
  </style>
</head>
<body>
  <h1>Overtime Work Request ${escapeHtml(work.requestNo)}</h1>
  <p class="meta">Status: ${escapeHtml(work.status)} · Printed ${escapeHtml(new Date().toLocaleString())}</p>
  <dl>
    <dt>Employee</dt><dd>${escapeHtml(work.employeeName)} (${escapeHtml(work.employeeNo)})</dd>
    <dt>Designation</dt><dd>${escapeHtml(work.designation || '—')}</dd>
    <dt>Department</dt><dd>${escapeHtml(work.departmentName || work.departmentCode || '—')}</dd>
    <dt>Work location</dt><dd>${escapeHtml(work.workLocation || '—')}</dd>
    <dt>Normal hours</dt><dd>${escapeHtml(work.normalHoursFrom || '—')} – ${escapeHtml(work.normalHoursTo || '—')}</dd>
    <dt>Total hours</dt><dd>${Number(work.totalHours || 0).toFixed(2)}</dd>
    <dt>Justification</dt><dd>${escapeHtml(work.reason || '—')}</dd>
    <dt>Expected deliverables</dt><dd>${escapeHtml(work.expectedDeliverables || '—')}</dd>
  </dl>
  <h2 style="font-size:1.05rem;margin:0">Overtime lines</h2>
  <table>
    <thead><tr><th>Date</th><th>Time</th><th>Category</th><th>Hours</th><th>Reason</th></tr></thead>
    <tbody>${rows}</tbody>
  </table>
  <p class="footer">For verification, approval, record-keeping or audit. One approved work request may be linked to only one overtime payment claim.</p>
  <script>window.onload = function () { window.print(); }</script>
</body>
</html>`
  const popup = window.open('', '_blank', 'noopener,noreferrer,width=900,height=700')
  if (!popup) return false
  popup.document.open()
  popup.document.write(html)
  popup.document.close()
  return true
}

export function OvertimeRequest() {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const [searchParams, setSearchParams] = useSearchParams()
  const [mode, setMode] = useState<Mode>(
    searchParams.get('request') ? 'detail' : searchParams.get('otRequestNo') ? 'form' : 'list',
  )
  const [selectedNo, setSelectedNo] = useState<string | null>(searchParams.get('request'))
  const [editingNo, setEditingNo] = useState<string | null>(null)
  const [lines, setLines] = useState<OvertimeLineInput[]>([])
  const [projectNo, setProjectNo] = useState('')
  const [priorWorkRequestNo, setPriorWorkRequestNo] = useState(
    () => searchParams.get('otRequestNo')?.trim().toUpperCase() ?? '',
  )
  const [workCompletedOn, setWorkCompletedOn] = useState('')
  const [employeeRemarks, setEmployeeRemarks] = useState('')
  const [formError, setFormError] = useState<string | null>(null)

  const contextQuery = useQuery({ queryKey: CONTEXT_KEY, queryFn: fetchOvertimeContext, staleTime: 60_000 })
  const stage1PayableQuery = useQuery({
    queryKey: ['hr', 'overtime-stage1-payable'],
    queryFn: fetchOvertimeRequests,
    staleTime: 30_000,
  })
  const listQuery = useQuery({
    queryKey: LIST_KEY,
    queryFn: async () => (await fetchOtPaymentRequests()).map(otPaymentAsListRow),
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
  // Stage 2 can only pay a BC Stage 1 request that BC marks payable (approved, no payment yet).
  // While editing a draft payment, its own (already linked) Stage 1 request is the only choice.
  const payableStage1 = useMemo(
    () =>
      (stage1PayableQuery.data ?? [])
        .filter((row) => (editingNo ? row.requestNo === priorWorkRequestNo : row.canRequestPayment))
        .map((row) => ({
          id: row.requestNo,
          requestNo: row.requestNo,
          status: 'Approved' as const,
          employeeNo: row.employeeNo,
          employeeName: row.employeeName,
          designation: row.designation,
          departmentCode: row.departmentCode,
          departmentName: row.departmentName,
          overtimeDate: row.overtimeDate,
          normalHoursFrom: row.startTime,
          normalHoursTo: row.endTime,
          overtimeFrom: row.startTime,
          overtimeTo: row.endTime,
          totalHours: row.totalHours,
          overtimeType: 'weekday' as const,
          workLocation: 'office' as const,
          reason: row.reason,
          expectedDeliverables: '',
          lines: row.lines.map((line) => ({
            overtimeDate: line.overtimeDate,
            startTime: line.startTime,
            endTime: line.endTime,
            dayType: line.dayType,
            workLocation: 'office' as const,
            reason: line.reason,
            totalHours: line.totalHours,
          })),
          requesterUserId: row.requesterUserId,
          createdAt: row.createdAt,
          submittedAt: row.submittedAt,
          approvedAt: row.approvedAt,
          decisionRemarks: row.decisionRemarks,
          steps: [],
          linkedPaymentRequestNo: row.paymentRequestNo ?? '',
          linkedAt: '',
        })),
    [stage1PayableQuery.data, editingNo, priorWorkRequestNo],
  )
  const approvedWorkQuery = { data: payableStage1, isLoading: stage1PayableQuery.isLoading }
  // Stage 2 routing (Workflow User Group on the Stage 2 BC workflow, 1.0.3.649) for a new payment request.
  const paymentContextQuery = useQuery({
    queryKey: ['hr', 'overtime-payment-context', priorWorkRequestNo],
    queryFn: () => fetchOtPaymentContext(priorWorkRequestNo),
    enabled: mode === 'form' && !editingNo && Boolean(priorWorkRequestNo),
    staleTime: 30_000,
    retry: false,
  })
  // The Stage 1 Overtime Request (portal copy) behind the payment shown, for View / Print.
  const stage1WorkQuery = useQuery({
    queryKey: ['hr', 'overtime-work-for-payment'],
    queryFn: fetchOvertimeWorkRequests,
    staleTime: 30_000,
    enabled: mode === 'detail' && Boolean(selectedNo),
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
  // The summary counts the saved lines only: 0.00 hours until a work request is selected.
  const counted = lines
  const busiest = busiestMonth(rows, counted, editingNo ?? '')
  const limit = context?.maxHoursPerMonth ?? 0

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
    setProjectNo('')
    setPriorWorkRequestNo('')
    setWorkCompletedOn('')
    setEmployeeRemarks('')
    goTo('form')
  }

  const startEdit = (request: OvertimeRequestRow) => {
    setEditingNo(request.requestNo)
    setLines(sortLines(linesOf(request)))
    setProjectNo(request.projectNo)
    // A draft payment stays linked to its Stage 1 request (BC does not allow switching).
    setPriorWorkRequestNo(request.otRequestNo ?? '')
    setWorkCompletedOn(request.workCompletedOn ?? '')
    setEmployeeRemarks(request.employeeRemarks ?? '')
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
    mutationFn: saveOtPaymentRequest,
    onSuccess: (payment, input) => {
      rememberRow(otPaymentAsListRow(payment))
      void queryClient.invalidateQueries({ queryKey: ['hr', 'overtime-stage1-payable'] })
      void queryClient.invalidateQueries({ queryKey: LIST_KEY })
      if (input.submit) {
        toast.success(
          'Overtime payment submitted',
          `${payment.paymentNo} was sent to the Workflow User Group for approval. Hours are added to the overtime sheet only after Stage 2 approval.`,
        )
      } else {
        toast.success('Draft saved', `${payment.paymentNo} is saved. Submit it for approval when it is ready.`)
      }
      setEditingNo(null)
      goTo('detail', payment.paymentNo)
    },
    onError: (error) => {
      const message = error instanceof Error ? error.message : 'Please check the form and try again.'
      setFormError(message)
      toast.error('Overtime payment not saved', message)
    },
  })

  const withdrawMutation = useMutation({
    mutationFn: withdrawOtPaymentRequest,
    onSuccess: (payment) => {
      rememberRow(otPaymentAsListRow(payment))
      toast.success('Request withdrawn', `${payment.paymentNo} is a draft again. Change it and submit, or delete it.`)
    },
    onError: (error) => toast.error('Withdraw failed', error instanceof Error ? error.message : 'Please try again.'),
  })

  const deleteMutation = useMutation({
    mutationFn: deleteOtPaymentRequest,
    onSuccess: (_result, paymentNo) => {
      queryClient.setQueryData<OvertimeRequestRow[]>(LIST_KEY, (current = []) =>
        current.filter((row) => row.requestNo !== paymentNo),
      )
      void queryClient.invalidateQueries({ queryKey: LIST_KEY })
      void queryClient.invalidateQueries({ queryKey: ['hr', 'overtime-stage1-payable'] })
      toast.success('Draft deleted', `${paymentNo} was removed.`)
      goTo('list')
    },
    onError: (error) => toast.error('Delete failed', error instanceof Error ? error.message : 'Please try again.'),
  })

  const busy = saveMutation.isPending

  const send = (submit: boolean) => {
    if (!priorWorkRequestNo.trim()) {
      setFormError(
        'Select the approved Overtime Request (Stage 1 work authorization). Stage 2 payment links to that document.',
      )
      return
    }
    const firstDate = lines.map((line) => line.overtimeDate).filter(Boolean).sort()[0] ?? ''
    if (submit && !workCompletedOn) {
      setFormError('Enter the date the overtime work was completed.')
      return
    }
    if (workCompletedOn && workCompletedOn > format(new Date(), 'yyyy-MM-dd')) {
      setFormError('The work completed date cannot be in the future. Request payment after the work is done.')
      return
    }
    if (workCompletedOn && firstDate && workCompletedOn < firstDate) {
      setFormError(`The work completed date cannot be before the first overtime date (${firstDate}).`)
      return
    }
    setFormError(null)
    saveMutation.mutate({
      paymentNo: editingNo ?? undefined,
      otRequestNo: priorWorkRequestNo.trim().toUpperCase(),
      workCompletedOn,
      employeeRemarks: employeeRemarks.trim().slice(0, 250) || 'Work completed as approved',
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
  const paymentContext = paymentContextQuery.data
  const steps = workflowSteps(
    mode === 'form' && !editingNo ? null : shown ?? rows.find((row) => row.requestNo === editingNo) ?? null,
    paymentContext ? { approvers: paymentContext.approvers, approvalWorkflow: paymentContext.approvalWorkflow } : undefined,
    employeeName,
  )
  // Stage 2 routing only (the Stage 2 workflow's Workflow User Group).
  const routingProblem =
    mode === 'form' && !editingNo
      ? paymentContextQuery.error instanceof Error
        ? paymentContextQuery.error.message
        : overtimeRoutingMessage(paymentContext?.routingProblem ?? '')
      : ''
  const linkedWork = shown?.otRequestNo
    ? (stage1WorkQuery.data ?? []).find((row) => row.requestNo === shown.otRequestNo) ?? null
    : null

  // Payment has no Add Line: selecting an approved work request loads its hours.
  useEffect(() => {
    if (mode !== 'form' || shown) return
    const work = (approvedWorkQuery.data ?? []).find((row) => row.requestNo === priorWorkRequestNo)
    if (!work) {
      if (!editingNo) setLines([])
      return
    }
    const workLines = (work.lines?.length
      ? work.lines
      : [
          {
            overtimeDate: work.overtimeDate,
            startTime: work.overtimeFrom,
            endTime: work.overtimeTo,
            dayType: 'working' as OvertimeDayType,
            reason: work.reason,
          },
        ]
    ).map((line) => ({
      overtimeDate: line.overtimeDate,
      startTime: line.startTime,
      endTime: line.endTime,
      dayType: line.dayType,
      reason: line.reason || work.reason,
    }))
    setLines(sortLines(workLines))
    setWorkCompletedOn((current) => current || defaultWorkCompletedOn(workLines))
  }, [priorWorkRequestNo, approvedWorkQuery.data, mode, shown, editingNo])

  const headerActions =
    mode === 'list' ? (
      <div className="flex items-center gap-2">
        <Button type="button" variant="outline" size="sm" onClick={() => void listQuery.refetch()} disabled={listQuery.isFetching}>
          <RefreshCw className={cn('mr-2 h-4 w-4', listQuery.isFetching && 'animate-spin')} />
          {listQuery.isFetching ? 'Syncing…' : 'Refresh'}
        </Button>
        <PortalNewButton label="New payment request" onClick={startNew} />
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
        {linkedWork ? (
          <>
            <Button asChild type="button" variant="outline">
              <Link
                to={`/hr/overtime-work-request?request=${encodeURIComponent(linkedWork.requestNo)}`}
                target="_blank"
                rel="noreferrer"
              >
                <Eye className="mr-2 h-4 w-4" />
                View Overtime Request
              </Link>
            </Button>
            <Button
              type="button"
              variant="outline"
              onClick={() => {
                if (!printApprovedWorkRequest(linkedWork)) {
                  toast.error('Allow pop-ups to print the approved overtime request.')
                }
              }}
            >
              <Printer className="mr-2 h-4 w-4" />
              Print Overtime Request
            </Button>
          </>
        ) : null}
        <Button type="button" variant="outline" onClick={() => goTo('list')}>
          <ArrowLeft className="mr-2 h-4 w-4" />
          My requests
        </Button>
        <PortalNewButton label="New payment request" onClick={startNew} />
      </div>
    )

  const contextError = contextQuery.isError
    ? contextQuery.error instanceof Error
      ? contextQuery.error.message
      : 'Business Central did not answer.'
    : ''

  const selectedPriorWork = useMemo(
    () => (approvedWorkQuery.data ?? []).find((row) => row.requestNo === priorWorkRequestNo) ?? null,
    [approvedWorkQuery.data, priorWorkRequestNo],
  )

  const priorWorkOptions = useMemo(
    () => [
      { value: '', label: 'Select approved Overtime Request (Stage 1)…' },
      ...payableStage1.map((row) => ({
        value: row.requestNo,
        label: `${row.requestNo} · ${dateRange(row.lines, row.overtimeDate)} · ${row.totalHours}h`,
      })),
    ],
    [payableStage1],
  )

  return (
    <PageWrapper
      title="Overtime Payment Request"
      description="Stage 2 — after the overtime authorized by an approved Overtime Request (Stage 1) is worked, request payment for it. The Workflow User Group in Business Central approves it; only then are the hours added to the overtime sheet, which HR sends to payroll."
      actions={headerActions}
    >
      {contextError ? (
        <div className="mb-4 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{contextError}</div>
      ) : null}

      {mode === 'list' ? (
        <div className="portal-surface-card overflow-hidden rounded-2xl border border-slate-200 bg-white">
          <div className="flex items-center justify-between gap-3 border-b border-slate-100 px-4 py-3">
            <div>
              <h2 className="text-sm font-semibold text-slate-900">My Overtime Payment Requests</h2>
              <p className="mt-0.5 text-xs text-slate-500">
                Stage 2 payment for authorized overtime already worked. Approver: Workflow User Group → overtime sheet →
                payroll.
              </p>
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
              emptyTitle="No overtime payment requests yet."
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
            Overtime payment request {selectedNo} was not found among your requests.
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
              Editing draft {editingNo}. Save keeps it as a draft; Submit for Approval sends it to the Workflow User Group.
            </div>
          ) : null}

          <div className="rounded-xl border border-amber-200 bg-amber-50/80 px-4 py-3 text-sm text-amber-950">
            <p className="font-semibold">Select the approved Overtime Request (Stage 1) — no Add Line</p>
            <p className="mt-1">
              Hours are entered on the{' '}
              <Link className="font-semibold underline-offset-2 hover:underline" to="/hr/overtime-work-request">
                Overtime Request
              </Link>{' '}
              form and approved by the Workflow User Group. After the work is done, select it below, enter when the work
              was completed, and submit. The Workflow User Group approves it again; then the hours go to the overtime sheet.
            </p>
          </div>

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
                  {shown ? null : (
                    <Field label="Approved Overtime Request (Stage 1)" required htmlFor="overtime-prior-work">
                      <div className="space-y-2">
                        <Select
                          id="overtime-prior-work"
                          value={priorWorkRequestNo}
                          options={priorWorkOptions}
                          disabled={Boolean(editingNo)}
                          placeholder={
                            approvedWorkQuery.isLoading
                              ? 'Loading approved overtime requests…'
                              : priorWorkOptions.length <= 1
                                ? 'No approved overtime request waiting for payment'
                                : 'Select approved overtime request'
                          }
                          onChange={(event) => {
                            setPriorWorkRequestNo(event.target.value)
                            setWorkCompletedOn('')
                          }}
                        />
                        <p className="text-xs text-slate-500">
                          Only approved Overtime Requests (Stage 1) with no payment request yet are listed.
                        </p>
                        {priorWorkRequestNo ? (
                          <div className="flex flex-wrap gap-2">
                            <Button asChild type="button" variant="outline" size="sm">
                              <Link
                                to={`/hr/overtime-work-request?request=${encodeURIComponent(priorWorkRequestNo)}`}
                                target="_blank"
                                rel="noreferrer"
                              >
                                <Eye className="mr-2 h-4 w-4" />
                                View
                              </Link>
                            </Button>
                            <Button
                              type="button"
                              variant="outline"
                              size="sm"
                              disabled={!selectedPriorWork}
                              onClick={() => {
                                if (!selectedPriorWork) return
                                if (!printApprovedWorkRequest(selectedPriorWork)) {
                                  toast.error('Allow pop-ups to print the approved overtime work request.')
                                }
                              }}
                            >
                              <Printer className="mr-2 h-4 w-4" />
                              Print
                            </Button>
                          </div>
                        ) : null}
                      </div>
                    </Field>
                  )}
                </div>
              )}
            </Section>
          </div>

          <Section icon={<CalendarDays className="h-4 w-4" />} title="Overtime Details (from the approved Overtime Request)">
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
                editingIndex={null}
              />
            ) : (
              <p className="text-sm text-slate-500">
                {priorWorkRequestNo
                  ? 'The selected Overtime Request has no overtime lines.'
                  : 'Select an approved Overtime Request (Stage 1) above to load the hours to pay.'}
              </p>
            )}
            {shown || mode !== 'form' ? null : (
              <p className="mt-3 text-xs text-slate-500">
                These lines come from the approved Overtime Request (Stage 1) and cannot be changed here.
              </p>
            )}
          </Section>

          <Section icon={<Clock className="h-4 w-4" />} title="Payment Request">
            <div className="grid gap-3 md:grid-cols-2">
              <Field label="Work completed on" required htmlFor="ot-payment-completed">
                {shown ? (
                  <ReadValue value={shown.workCompletedOn} />
                ) : (
                  <Input
                    id="ot-payment-completed"
                    type="date"
                    value={workCompletedOn}
                    max={format(new Date(), 'yyyy-MM-dd')}
                    onChange={(event) => setWorkCompletedOn(event.target.value)}
                  />
                )}
              </Field>
              <Field label="Overtime Request" htmlFor="ot-payment-stage1">
                <ReadValue value={shown ? shown.otRequestNo : priorWorkRequestNo} placeholder="Select above" />
              </Field>
              <div className="md:col-span-2">
                <Field label="Employee remarks" htmlFor="ot-payment-remarks">
                  {shown ? (
                    <ReadValue value={shown.employeeRemarks} />
                  ) : (
                    <Textarea
                      id="ot-payment-remarks"
                      rows={2}
                      maxLength={250}
                      value={employeeRemarks}
                      placeholder="e.g. Work completed as approved"
                      onChange={(event) => setEmployeeRemarks(event.target.value)}
                    />
                  )}
                </Field>
              </div>
              {shown?.superiorJustification ? (
                <div className="md:col-span-2">
                  <Field label="Approval remarks">
                    <ReadValue value={shown.superiorJustification} />
                  </Field>
                </div>
              ) : null}
            </div>
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

          {/* History is the last section of the page, closed until View more. */}
          {shown?.log.length ? (
            <HistorySection
              count={shown.log.length}
              summary={(() => {
                const latest = shown.log[shown.log.length - 1]
                return `Latest: ${latest.stageLabel} · ${latest.action}${latest.userName ? ` — ${latest.userName}` : ''}`
              })()}
            >
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
            </HistorySection>
          ) : null}
        </div>
      ) : null}
    </PageWrapper>
  )
}
