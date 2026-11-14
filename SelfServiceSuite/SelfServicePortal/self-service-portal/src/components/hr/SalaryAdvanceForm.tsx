import { useMemo, useRef, useState, type ReactNode } from 'react'
import { useMutation, useQuery } from '@tanstack/react-query'
import { format } from 'date-fns'
import {
  AlertTriangle,
  Banknote,
  CalendarClock,
  CheckCircle2,
  Clock,
  FileSignature,
  Save,
  Scale,
  Send,
  ShieldCheck,
  User,
  XCircle,
} from 'lucide-react'
import { AuthApiError } from '@/api/client/authClient'
import {
  createModuleRequest,
  getModuleRequest,
  submitModuleRequest,
  updateRequestHeader,
} from '@/api/endpoints/requestEndpoint'
import {
  fetchSalaryAdvanceContext,
  salaryAdvanceModule,
  type SalaryAdvanceContext,
  type SalaryAdvanceFormPayload,
} from '@/api/endpoints/salaryAdvance'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { RequestProgress } from '@/components/shared/RequestProgress'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { SALARY_ADVANCE_AFTER_APPROVAL, SALARY_ADVANCE_APPROVERS } from '@/data/processStages'
import { useAuth } from '@/hooks/useAuth'
import { cn } from '@/lib/utils'
import type { PortalRequest } from '@/types/erp.types'
import { SALARY_ADVANCE_DECLARATION, SALARY_ADVANCE_POLICY_NOTES } from '@/utils/salaryAdvanceText'
import {
  addMonths,
  amountInWords,
  dayLabel,
  etb,
  maxRepaymentMonths,
  monthKey,
  monthLabel,
  monthlyDeduction,
  salaryAdvanceChecks,
  salaryAdvancePlanErrors,
  type SalaryAdvanceCheck,
  type SalaryAdvanceFacts,
  type SalaryAdvancePlan,
} from '@/utils/salaryAdvancePolicy'

/** The client's colour for the Salary Advance form sections (ESSP screenshot, Nov 2026). */
const SECTION_BLUE = '#2b5fb2'

const NO_FACTS: SalaryAdvanceFacts = {
  monthlyGrossSalary: 0,
  monthlyNetSalary: 0,
  probationEndDate: '',
  onProbation: null,
  dateOfEmployment: '',
  permanent: null,
  employmentType: '',
  contractEndDate: '',
  outstandingBalance: null,
  openSalaryAdvances: null,
}

function newRequestId() {
  // crypto.randomUUID needs a secure context; the portal also runs on plain http inside the LAN.
  return `sal-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 10)}`
}

function payloadText(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = String(payload[key] ?? '').trim()
    if (value && !value.startsWith('0001-01-01')) return value
  }
  return ''
}

export function SalarySection({
  icon,
  title,
  aside,
  children,
}: {
  icon: ReactNode
  title: string
  aside?: ReactNode
  children: ReactNode
}) {
  return (
    <section className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
      <header
        className="flex items-center gap-2 px-4 py-2.5 text-sm font-semibold text-white"
        style={{ backgroundColor: SECTION_BLUE }}
      >
        {icon}
        <span className="min-w-0 flex-1">{title}</span>
        {aside}
      </header>
      <div className="p-4">{children}</div>
    </section>
  )
}

export function SalaryReadField({ label, value, hint }: { label: string; value?: string; hint?: string }) {
  return (
    <div>
      <p className="text-xs text-slate-500">{label}</p>
      <p className="mt-0.5 rounded-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm text-slate-900">
        {value?.trim() || '—'}
      </p>
      {hint ? <p className="mt-1 text-[11px] text-slate-500">{hint}</p> : null}
    </div>
  )
}

function FieldBlock({ label, required, htmlFor, hint, children }: { label: string; required?: boolean; htmlFor?: string; hint?: ReactNode; children: ReactNode }) {
  return (
    <div className="space-y-1">
      <Label htmlFor={htmlFor} className="text-xs font-normal text-slate-600">
        {label}
        {required ? <span className="text-red-600"> *</span> : null}
      </Label>
      {children}
      {hint ? <p className="text-[11px] leading-4 text-slate-500">{hint}</p> : null}
    </div>
  )
}

export function CheckRow({ check }: { check: SalaryAdvanceCheck }) {
  const tone =
    check.state === 'pass'
      ? { icon: <CheckCircle2 className="h-4 w-4 text-emerald-600" />, badge: 'Met', badgeClass: 'bg-emerald-50 text-emerald-800 ring-emerald-200' }
      : check.state === 'fail'
        ? { icon: <XCircle className="h-4 w-4 text-red-600" />, badge: 'Not met', badgeClass: 'bg-red-50 text-red-800 ring-red-200' }
        : { icon: <Clock className="h-4 w-4 text-amber-600" />, badge: 'HR verifies', badgeClass: 'bg-amber-50 text-amber-900 ring-amber-200' }
  return (
    <li className="flex items-start gap-3 rounded-lg border border-slate-100 px-3 py-2.5">
      <span className="mt-0.5 shrink-0">{tone.icon}</span>
      <div className="min-w-0 flex-1">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <span className="text-sm font-medium text-slate-900">{check.label}</span>
          <span className={cn('rounded-full px-2 py-0.5 text-[11px] font-semibold ring-1', tone.badgeClass)}>{tone.badge}</span>
        </div>
        <p className="mt-0.5 text-xs leading-5 text-slate-600">{check.detail}</p>
      </div>
    </li>
  )
}

/**
 * ESSP Staff Salary Advance form (ABH Partners PLC Staff Salary Advance Request Form, sections 1, 2, 4 and
 * 7, with the live eligibility checks of section 3). New request, or edit of a draft (`request`).
 */
export function SalaryAdvanceForm({
  request,
  onSaved,
  onCancel,
}: {
  request?: PortalRequest
  onSaved: (request: PortalRequest) => void
  onCancel: () => void
}) {
  const toast = useToast()
  const confirm = useConfirm()
  const { employee } = useAuth()
  const docNo = request?.requestNo ?? ''
  const contextQuery = useQuery({
    queryKey: ['salary-advance', 'context', docNo],
    queryFn: () => fetchSalaryAdvanceContext(docNo),
    staleTime: 60_000,
  })
  const context: SalaryAdvanceContext | undefined = contextQuery.data
  const today = useMemo(() => format(new Date(), 'yyyy-MM-dd'), [])
  const thisMonth = monthKey(today)
  const clientRequestId = useRef(newRequestId())

  const payload = (request?.payload ?? {}) as Record<string, unknown>
  const [amountText, setAmountText] = useState(() => {
    const saved = Number(payload.RequestedAmount ?? 0)
    return saved > 0 ? String(saved) : ''
  })
  const [reason, setReason] = useState(() => (request ? payloadText(payload, ['Purpose', 'purpose']).split(' | ETB ')[0]! : ''))
  const [dateNeeded, setDateNeeded] = useState(() => {
    const saved = payloadText(payload, ['DateNeeded', 'Date_Needed']).slice(0, 10)
    return saved && saved >= today ? saved : today
  })
  const [months, setMonths] = useState(() => {
    const saved = Number(payload.RepaymentMonths ?? 0)
    return saved >= 1 && saved <= 3 ? saved : 3
  })
  const [startMonth, setStartMonth] = useState(() => {
    const saved = monthKey(payloadText(payload, ['DeductionStartMonth', 'Deduction_Start_Month']))
    return saved && saved >= thisMonth ? saved : addMonths(thisMonth, 1)
  })
  const [declared, setDeclared] = useState(() => payload.DeclarationAccepted === true)
  const [formError, setFormError] = useState<string | null>(null)
  const [showErrors, setShowErrors] = useState(false)

  const amount = Number(amountText) > 0 ? Math.round(Number(amountText) * 100) / 100 : 0
  const maxMonths = maxRepaymentMonths(context)
  const plan: SalaryAdvancePlan = { requestedAmount: amount, repaymentMonths: months, deductionStartMonth: startMonth, dateNeeded }
  const monthly = monthlyDeduction(amount, months)
  const checks = salaryAdvanceChecks(context ?? NO_FACTS, plan, today)
  const failed = checks.filter((check) => check.state === 'fail')
  const draftErrors = salaryAdvancePlanErrors(plan, { reason, declarationAccepted: declared, forSubmit: false, today, maxMonths })
  const submitErrors = salaryAdvancePlanErrors(plan, { reason, declarationAccepted: declared, forSubmit: true, today, maxMonths })
  const schedule = Array.from({ length: months }, (_, index) => {
    const isLast = index === months - 1
    // The last installment takes the rounding so the total is exactly the amount.
    const value = isLast ? Math.round((amount - monthly * (months - 1)) * 100) / 100 : monthly
    return { month: addMonths(startMonth, index), value }
  })
  const startOptions = Array.from({ length: 4 }, (_, index) => {
    const key = addMonths(thisMonth, index)
    return { value: key, label: monthLabel(key) }
  })
  const employeeName = context?.employeeName || employee?.displayName || ''
  const salarySource = context?.salaryPeriod
    ? `From the ${monthLabel(context.salaryPeriod)} payroll`
    : context && (context.monthlyGrossSalary > 0 || context.monthlyNetSalary > 0)
      ? 'From your employee card'
      : 'Not available from Business Central: HR verifies'

  const save = useMutation({
    mutationFn: async ({ submit }: { submit: boolean }) => {
      const body: SalaryAdvanceFormPayload & Record<string, unknown> = {
        requestedAmount: amount,
        repaymentMonths: months,
        deductionStartMonth: startMonth,
        dateNeeded,
        reason: reason.trim(),
        purpose: reason.trim(),
        declarationAccepted: declared,
        title: `Salary advance ${etb(amount)} — ${reason.trim().slice(0, 40)}`,
      }
      if (request) {
        await updateRequestHeader(request.id, body)
        if (submit) await submitModuleRequest(salaryAdvanceModule, request.id)
        return getModuleRequest(salaryAdvanceModule, request.id)
      }
      return createModuleRequest(
        salaryAdvanceModule,
        { ...body, submit, clientRequestId: clientRequestId.current },
        { timeout: 120_000 },
      )
    },
    onSuccess: (saved, { submit }) => {
      toast.success(
        submit
          ? `${saved.requestNo} is with Business Central for approval: Line Manager, then HR Manager, then the Chief Financial Officer.`
          : `${saved.requestNo} is saved as a draft. It is not sent for approval until you submit it.`,
        submit ? 'Submitted for approval' : 'Saved as draft',
      )
      onSaved(saved)
    },
    onError: async (error) => {
      const message = error instanceof Error ? error.message : 'The salary advance could not be saved.'
      const documentNo = error instanceof AuthApiError ? error.documentNo : undefined
      if (documentNo && !request) {
        // BC saved the draft but a later step failed: open the draft and say it was not submitted.
        toast.error(`${message} Open draft ${documentNo}, correct it and submit it again.`, `Saved as draft ${documentNo}, not submitted`)
        try {
          onSaved(await getModuleRequest(salaryAdvanceModule, `${salaryAdvanceModule.module}-${documentNo}`))
        } catch {
          setFormError(`Draft ${documentNo} was saved but could not be opened. Find it in My Salary Advance Requests.`)
        }
        return
      }
      setFormError(message)
    },
  })
  const busy = save.isPending

  const saveDraft = () => {
    setShowErrors(true)
    if (draftErrors.length) {
      setFormError(draftErrors[0]!)
      return
    }
    setFormError(null)
    save.mutate({ submit: false })
  }

  const submit = async () => {
    setShowErrors(true)
    if (submitErrors.length) {
      setFormError(submitErrors[0]!)
      return
    }
    if (failed.length) {
      setFormError(`Not eligible yet: ${failed.map((check) => check.label.toLowerCase()).join('; ')}. See the Eligibility Check.`)
      document.getElementById('salary-eligibility')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
      return
    }
    setFormError(null)
    const ok = await confirm({
      title: 'Submit the salary advance for approval?',
      message: `${etb(amount)}, repaid in ${months} monthly deduction${months > 1 ? 's' : ''} of about ${etb(monthly)} from ${monthLabel(startMonth)}. It goes to your Line Manager, then the HR Manager, then the Chief Financial Officer.`,
      confirmLabel: 'Submit for Approval',
    })
    if (ok) save.mutate({ submit: true })
  }

  const fieldError = (show: boolean) => (showErrors && show ? 'border-red-300 focus-visible:ring-red-300' : '')

  return (
    <div className="space-y-4">
      <RequestProgress
        status="Draft"
        creating={request ? 'edit' : 'new'}
        requiresLines={false}
        expectedApprovers={SALARY_ADVANCE_APPROVERS}
        afterApproval={SALARY_ADVANCE_AFTER_APPROVAL}
      />

      {request ? (
        <div className="rounded-xl border border-blue-100 bg-blue-50/70 px-4 py-2.5 text-sm text-blue-900">
          Editing draft {request.requestNo}. Save as Draft keeps it; Submit for Approval sends it to your Line Manager.
        </div>
      ) : null}

      <SalarySection icon={<User className="h-4 w-4" />} title="1. Employee Details">
        {contextQuery.isError ? (
          <p className="mb-3 rounded-md border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-900">
            Your details could not be loaded from Business Central:{' '}
            {contextQuery.error instanceof Error ? contextQuery.error.message : 'unknown error'}. HR verifies them after you submit.
          </p>
        ) : null}
        <div className="grid gap-3 md:grid-cols-2">
          <SalaryReadField label="Full Name" value={employeeName} />
          <SalaryReadField label="Employee ID" value={context?.employeeNo || employee?.employeeNo} />
          <SalaryReadField label="Position / Job Title" value={context?.jobTitle || employee?.jobTitle} />
          <SalaryReadField
            label="Business Line / Department"
            value={[context?.divisionName, context?.departmentName || employee?.departmentName].filter(Boolean).join(' / ')}
          />
          <SalaryReadField label="Date of Employment" value={context?.dateOfEmployment ? dayLabel(context.dateOfEmployment) : ''} />
          <SalaryReadField label="Employment Type" value={context?.employmentType} />
          <SalaryReadField
            label="Monthly Gross Salary (ETB)"
            value={context?.monthlyGrossSalary ? etb(context.monthlyGrossSalary) : contextQuery.isLoading ? 'Loading…' : ''}
            hint={salarySource}
          />
          <SalaryReadField
            label="Monthly Net Salary (ETB)"
            value={context?.monthlyNetSalary ? etb(context.monthlyNetSalary) : contextQuery.isLoading ? 'Loading…' : ''}
            hint={salarySource}
          />
          <SalaryReadField label="Date of Request" value={dayLabel(today)} hint="System generated" />
        </div>
      </SalarySection>

      <SalarySection
        icon={<Banknote className="h-4 w-4" />}
        title="2. Advance Request"
        aside={amount > 0 ? <span className="rounded-full bg-white/20 px-2 py-0.5 text-xs">{etb(amount)}</span> : null}
      >
        <div className="grid gap-4 md:grid-cols-2">
          <FieldBlock label="Amount Requested (ETB)" required htmlFor="sa-amount" hint="At most one month's net salary.">
            <div className="relative">
              <span className="pointer-events-none absolute inset-y-0 left-3 flex items-center text-sm text-slate-500">ETB</span>
              <Input
                id="sa-amount"
                type="number"
                inputMode="decimal"
                min={0}
                step="0.01"
                value={amountText}
                onChange={(event) => setAmountText(event.target.value)}
                className={cn('pl-12 tabular-nums', fieldError(!(amount > 0)))}
                placeholder="0.00"
              />
            </div>
          </FieldBlock>
          <SalaryReadField label="Amount in Words" value={amountInWords(amount)} />
          <div className="md:col-span-2">
            <FieldBlock label="Reason for Advance" required htmlFor="sa-reason" hint={`${reason.trim().length}/250 · a genuine personal or emergency need`}>
              <Textarea
                id="sa-reason"
                rows={3}
                maxLength={250}
                value={reason}
                onChange={(event) => setReason(event.target.value)}
                className={fieldError(reason.trim().length < 5)}
                placeholder="Why do you need the advance?"
              />
            </FieldBlock>
          </div>
          <FieldBlock label="Date Needed" required htmlFor="sa-date-needed">
            <Input
              id="sa-date-needed"
              type="date"
              min={today}
              value={dateNeeded}
              onChange={(event) => setDateNeeded(event.target.value)}
              className={fieldError(!dateNeeded || dateNeeded < today)}
            />
          </FieldBlock>
          <FieldBlock label="Preferred Repayment Period (months)" required hint={`Equal monthly payroll deductions, at most ${maxMonths} months.`}>
            <div className="grid grid-cols-3 gap-2" role="radiogroup" aria-label="Preferred repayment period">
              {Array.from({ length: maxMonths }, (_, index) => index + 1).map((value) => (
                <button
                  key={value}
                  type="button"
                  role="radio"
                  aria-checked={months === value}
                  onClick={() => setMonths(value)}
                  className={cn(
                    'rounded-md border px-3 py-2 text-sm font-medium transition-colors',
                    months === value
                      ? 'border-transparent text-white shadow-sm'
                      : 'border-slate-200 bg-white text-slate-700 hover:border-slate-300 hover:bg-slate-50',
                  )}
                  style={months === value ? { backgroundColor: SECTION_BLUE } : undefined}
                >
                  {value} month{value > 1 ? 's' : ''}
                </button>
              ))}
            </div>
          </FieldBlock>
          <SalaryReadField
            label="Monthly Deduction (ETB)"
            value={monthly > 0 ? `${etb(monthly)} × ${months} month${months > 1 ? 's' : ''}` : ''}
            hint="Calculated: amount ÷ repayment period"
          />
          <FieldBlock label="Deduction Start Month" required htmlFor="sa-start-month">
            <Select
              id="sa-start-month"
              value={startMonth}
              onChange={(event) => setStartMonth(event.target.value)}
              options={startOptions}
            />
          </FieldBlock>
          {amount > 0 ? (
            <div className="md:col-span-2">
              <p className="mb-1.5 flex items-center gap-1.5 text-xs text-slate-600">
                <CalendarClock className="h-3.5 w-3.5" /> Repayment schedule (payroll deductions)
              </p>
              <ol className="grid gap-2 sm:grid-cols-3">
                {schedule.map((item, index) => (
                  <li key={item.month} className="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2">
                    <p className="text-[11px] uppercase tracking-wide text-slate-500">Installment {index + 1}</p>
                    <p className="text-sm font-semibold text-slate-900">{monthLabel(item.month)}</p>
                    <p className="text-sm tabular-nums text-slate-700">{etb(item.value)}</p>
                  </li>
                ))}
              </ol>
            </div>
          ) : null}
        </div>
      </SalarySection>

      <div id="salary-eligibility" className="scroll-mt-24">
        <SalarySection
          icon={<ShieldCheck className="h-4 w-4" />}
          title="3. Eligibility Check"
          aside={
            <span className="rounded-full bg-white/20 px-2 py-0.5 text-xs">
              {failed.length ? `${failed.length} not met` : 'Ready'}
            </span>
          }
        >
          <p className="mb-3 text-xs text-slate-600">
            Checked live against Business Central. HR verifies each item again (HR Verification) after you submit.
          </p>
          <ul className="space-y-2">
            {checks.map((check) => (
              <CheckRow key={check.key} check={check} />
            ))}
          </ul>
        </SalarySection>
      </div>

      <SalarySection icon={<Scale className="h-4 w-4" />} title="Policy Notes">
        <ol className="space-y-1.5 text-sm text-slate-700">
          {SALARY_ADVANCE_POLICY_NOTES.map((note, index) => (
            <li key={note} className="flex gap-2">
              <span
                className="mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full text-[11px] font-semibold text-white"
                style={{ backgroundColor: SECTION_BLUE }}
              >
                {index + 1}
              </span>
              <span>{note}</span>
            </li>
          ))}
        </ol>
        <p className="mt-2 text-[11px] text-slate-500">Proposed policy, to be confirmed by management.</p>
      </SalarySection>

      <SalarySection icon={<FileSignature className="h-4 w-4" />} title="4. Employee Declaration and Deduction Authorization">
        <p className="text-sm leading-6 text-slate-700">{SALARY_ADVANCE_DECLARATION}</p>
        <label
          className={cn(
            'mt-3 flex cursor-pointer items-start gap-3 rounded-lg border px-3 py-2.5 text-sm',
            declared ? 'border-emerald-200 bg-emerald-50/70' : showErrors ? 'border-red-200 bg-red-50/60' : 'border-slate-200',
          )}
        >
          <input
            type="checkbox"
            className="mt-0.5 h-4 w-4 accent-[#2b5fb2]"
            checked={declared}
            onChange={(event) => setDeclared(event.target.checked)}
          />
          <span>
            <span className="font-medium text-slate-900">I confirm and authorize the payroll deductions.</span>
            <span className="block text-xs text-slate-600">
              Accepted electronically by {employeeName || 'you'} when you submit ({dayLabel(today)}).
            </span>
          </span>
        </label>
      </SalarySection>

      {formError ? (
        <div className="flex items-start gap-2 rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700" role="alert">
          <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
          <span>{formError}</span>
        </div>
      ) : null}

      <div className="flex flex-wrap items-center justify-end gap-2">
        <Button type="button" variant="outline" disabled={busy} onClick={onCancel}>
          Cancel
        </Button>
        <Button type="button" variant="outline" disabled={busy} onClick={saveDraft}>
          <Save className="mr-2 h-4 w-4" />
          {busy && !save.variables?.submit ? 'Saving…' : 'Save as Draft'}
        </Button>
        <Button
          type="button"
          disabled={busy}
          onClick={() => void submit()}
          className="text-white hover:opacity-95"
          style={{ backgroundColor: SECTION_BLUE }}
        >
          <Send className="mr-2 h-4 w-4" />
          {busy && save.variables?.submit ? 'Submitting…' : 'Submit for Approval'}
        </Button>
      </div>
    </div>
  )
}
