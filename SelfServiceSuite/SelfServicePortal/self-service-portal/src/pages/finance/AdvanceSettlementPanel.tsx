import { useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { Link } from 'react-router-dom'
import {
  AlertTriangle,
  BadgeCheck,
  Check,
  CheckCircle2,
  HandCoins,
  Loader2,
  Plus,
  Save,
  Wallet,
} from 'lucide-react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  addAdvanceSettlementExpense,
  saveAdvanceSettlementDetails,
  type AdvanceSettlementContext,
} from '@/api/endpoints/advanceSettlement'
import { fetchPettyCashExpenseCategories } from '@/api/endpoints/pettyCashCategories'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import {
  SETTLEMENT_QUERY_ROOT,
  SETTLEMENT_SCENARIOS,
  rememberSettlementPanel,
  settlementMissing,
  useAdvanceSettlementContext,
} from '@/hooks/useAdvanceSettlementContext'
import { SettlementExpenseEntries } from '@/components/finance/SettlementExpenseEntries'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { cn } from '@/lib/utils'
import { formatAmount, formatDate } from '@/utils/formatters'
import type { PortalRequest } from '@/types/erp.types'

type Outcome = keyof typeof SETTLEMENT_SCENARIOS

/**
 * The Advance Settlement document in three sequential sections (client, 16 Nov 2026):
 * 1. Advance Summary — the advance received and its details;
 * 2. Expense Entries & Supporting Documents — the expense entries (purpose and amount) and the attachments;
 * 3. Expense Reconciliation & Settlement — Total Advance Received − Total Actual Expenses = Balance, the outcome
 *    (A Fully Settled / B Advance Surrender / C Additional Reimbursement) with its details, and the declaration.
 * Business Central calculates the figures (PortalAdvanceSettlementContext / Save / AddExpense, BC 1.0.3.636).
 */
export function AdvanceSettlementSections({
  request,
  details,
  lines,
  attachments,
}: {
  request: PortalRequest
  details: ReactNode
  lines: ReactNode
  attachments: ReactNode
}) {
  const isDraft = request.status === 'Draft'
  const contextQuery = useAdvanceSettlementContext(request)
  const ctx = contextQuery.data?.surrenderNo ? contextQuery.data : undefined
  const documents = request.attachments?.length ?? 0
  const expensesEntered = Boolean(ctx && ctx.totalActualExpenses > 0)
  const contextState = contextQuery.isLoading ? (
    <div className="flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-600">
      <Loader2 className="h-4 w-4 animate-spin" />
      Loading the settlement from Business Central…
    </div>
  ) : (
    <div className="rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
      {contextQuery.error instanceof Error
        ? contextQuery.error.message
        : 'Business Central did not return the settlement reconciliation (needs BC 1.0.3.636).'}
    </div>
  )

  // BC 1.0.3.663: one card per expense (client redesign); older BC keeps the line table and Add an expense entry.
  const entryCards = Boolean(ctx?.supportsExpenseEntries)

  return (
    <div className="space-y-5">
      <SettlementSection number={1} title="Advance Summary" hint="The approved advance and the amount received" done={Boolean(ctx)}>
        {ctx ? <AdvanceInformation ctx={ctx} request={request} /> : contextState}
        <details className="group mt-3 text-sm">
          <summary className="cursor-pointer select-none text-xs font-medium text-[var(--portal-navy)] hover:underline">
            More settlement details
          </summary>
          <div className="mt-3 border-t border-slate-200 pt-3">{details}</div>
        </details>
      </SettlementSection>

      <SettlementSection
        number={2}
        title="Expense Entries and Supporting Documents"
        hint={
          ctx
            ? `${formatAmount(ctx.totalActualExpenses)} entered · ${documents} ${documents === 1 ? 'document' : 'documents'}`
            : 'What you spent, with the receipts'
        }
        done={expensesEntered && documents > 0}
      >
        {entryCards && ctx ? (
          <SettlementExpenseEntries request={request} ctx={ctx} editable={isDraft} />
        ) : (
          <>
            <p className="text-sm text-slate-600">
              {isDraft
                ? 'Enter the actual amount spent on each advance line, add every other expense with its purpose and amount, then attach the receipts and supporting documents.'
                : 'The expenses and documents submitted with this settlement.'}
            </p>
            <div className="mt-4 space-y-5 [&>section:first-child]:border-t-0 [&>section:first-child]:pt-0">
              {lines}
              {isDraft && ctx ? <AddExpenseEntry surrenderNo={ctx.surrenderNo} /> : null}
              {attachments}
            </div>
          </>
        )}
      </SettlementSection>

      <SettlementSection
        number={3}
        title="Expense Reconciliation and Settlement"
        hint="Calculated automatically from the advance summary and the expense entries"
        done={Boolean(ctx) && settlementMissing(ctx!).length === 0}
      >
        {ctx ? <SettlementSummary key={`${ctx.surrenderNo}:${request.status}`} ctx={ctx} editable={isDraft} /> : contextState}
      </SettlementSection>
    </div>
  )
}

/** A numbered section of the settlement, styled like the Advance Request form's sections. */
function SettlementSection({
  number,
  title,
  hint,
  done,
  children,
}: {
  number: number
  title: string
  hint: string
  done: boolean
  children: ReactNode
}) {
  const id = `settlement-s${number}`
  return (
    <section id={id} className={cn('adv-section scroll-mt-24', done && 'is-done')} aria-labelledby={`${id}-title`}>
      <header className="adv-section-head">
        <span className={cn('adv-step', done && 'is-done')} aria-hidden="true">
          {done ? <Check className="h-3.5 w-3.5" strokeWidth={3} /> : number}
        </span>
        <div className="min-w-0">
          <h3 id={`${id}-title`} className="text-[0.95rem] font-semibold leading-tight">
            {number}. {title}
          </h3>
          <p className="text-xs text-white/70">{hint}</p>
        </div>
      </header>
      <div className="p-4 sm:p-5">{children}</div>
    </section>
  )
}

/** Section 1 (client sample): Advance Information, then Total Advance Received. */
function AdvanceInformation({ ctx, request }: { ctx: AdvanceSettlementContext; request: PortalRequest }) {
  const advanceNo = ctx.advanceNo || ctx.advance?.advanceNo || ''
  const purpose = ctx.advance?.requestPurposeText || ctx.advance?.purpose || ctx.purpose
  const payload = request.payload ?? {}
  const department =
    request.departmentName ||
    request.departmentCode ||
    String(payload.DepartmentName ?? payload.Department ?? payload.ShortcutDimension2Code ?? payload.GlobalDimension1Code ?? '')
  return (
    <div className="rounded-xl border border-slate-200 bg-white px-4 py-4">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <p className="text-sm font-semibold text-slate-900">Advance Information</p>
        <p className="flex items-center gap-2 text-xs text-slate-500">
          Settlement {request.requestNo}
          <StatusBadge status={request.status} />
        </p>
      </div>
      <dl className="mt-3 grid gap-x-8 gap-y-3 text-sm sm:grid-cols-2">
        <div className="min-w-0">
          <dt className="text-xs text-slate-500">Advance Request No.</dt>
          <dd className="font-semibold">
            {advanceNo ? (
              <Link
                to={`/finance/advance-request?open=${encodeURIComponent(`imprest-${advanceNo}`)}`}
                className="text-[var(--portal-navy)] underline-offset-2 hover:underline"
              >
                {advanceNo}
              </Link>
            ) : (
              '—'
            )}
          </dd>
        </div>
        <div className="min-w-0">
          <dt className="text-xs text-slate-500">Advance Date</dt>
          <dd className="font-semibold">{ctx.advance?.paymentDate ? formatDate(ctx.advance.paymentDate) : '—'}</dd>
        </div>
        <div className="min-w-0">
          <dt className="text-xs text-slate-500">Purpose</dt>
          <dd className="break-words font-semibold">{purpose || '—'}</dd>
        </div>
        <div className="min-w-0">
          <dt className="text-xs text-slate-500">Department</dt>
          <dd className="font-semibold">{department || '—'}</dd>
        </div>
      </dl>
      <div className="mt-4 rounded-lg bg-sky-50 px-4 py-3 ring-1 ring-sky-100">
        <p className="text-xs text-slate-600">Total Advance Received</p>
        <p className="mt-0.5 text-3xl font-bold tabular-nums tracking-tight text-slate-950">{formatAmount(ctx.totalAdvanceReceived)}</p>
      </div>
    </div>
  )
}

function SectionTitle({ children }: { children: ReactNode }) {
  return <h4 className="text-sm font-semibold text-[var(--portal-navy)]">{children}</h4>
}

function SettlementSummary({ ctx, editable }: { ctx: AdvanceSettlementContext; editable: boolean }) {
  const toast = useToast()
  const queryClient = useQueryClient()
  const [refundDate, setRefundDate] = useState(ctx.refundDate)
  const [refundReference, setRefundReference] = useState(ctx.refundPaymentReference)
  const [justification, setJustification] = useState(ctx.additionalClaimJustification)
  const [declared, setDeclared] = useState(ctx.declarationConfirmed)
  const outcome = (ctx.settlementOutcome || '') as Outcome | ''
  const missing = settlementMissing(ctx)
  const dirty =
    editable &&
    (declared !== ctx.declarationConfirmed ||
      (outcome === 'refundDue' && (refundDate !== ctx.refundDate || refundReference.trim() !== ctx.refundPaymentReference)) ||
      (outcome === 'additionalClaim' && justification.trim() !== ctx.additionalClaimJustification))

  // Submit for Processing reads this to stop before BC refuses the settlement.
  useEffect(() => {
    rememberSettlementPanel(ctx.surrenderNo, { missing: editable ? missing : [], dirty })
  })

  const save = useMutation({
    mutationFn: () =>
      saveAdvanceSettlementDetails({
        surrenderNo: ctx.surrenderNo,
        refundDateText: outcome === 'refundDue' ? refundDate : '',
        refundPaymentReference: outcome === 'refundDue' ? refundReference.trim() : '',
        additionalClaimJustification: outcome === 'additionalClaim' ? justification.trim() : '',
        declarationConfirmed: declared,
        // Blank keeps BC's remarks (PortalAdvanceSettlementSave only overwrites non-blank remarks).
        settlementRemarks: '',
      }),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: [...SETTLEMENT_QUERY_ROOT, 'detail', ctx.surrenderNo] })
      toast.success('Settlement details saved to Business Central.')
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Could not save the settlement details.', 'Save failed'),
  })

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    save.mutate()
  }

  return (
    <div className="space-y-4">
      {/* Financial Reconciliation (client sample): advance, expenses, remaining balance */}
      <section className="rounded-xl border border-slate-200 bg-white px-4 py-4">
        <SectionTitle>Financial Reconciliation</SectionTitle>
        <dl className="mt-3 space-y-2 text-sm">
          <div className="flex items-center justify-between gap-3">
            <dt className="text-slate-600">Total Advance Received</dt>
            <dd className="font-semibold tabular-nums text-slate-950">{formatAmount(ctx.totalAdvanceReceived)}</dd>
          </div>
          <div className="flex items-center justify-between gap-3">
            <dt className="text-slate-600">Total Actual Expenses</dt>
            <dd className="font-semibold tabular-nums text-slate-950">{formatAmount(ctx.totalActualExpenses)}</dd>
          </div>
          <div className="flex items-center justify-between gap-3 border-t border-slate-200 pt-3">
            <dt className="text-base font-semibold text-slate-900">Remaining Balance</dt>
            <dd
              className={cn(
                'text-2xl font-bold tabular-nums',
                outcome === 'additionalClaim' ? 'text-amber-700' : outcome === 'refundDue' ? 'text-emerald-700' : 'text-slate-900',
              )}
            >
              {ctx.settlementBalance < 0 ? '− ' : ''}
              {formatAmount(Math.abs(ctx.settlementBalance))}
            </dd>
          </div>
        </dl>

        <div className="mt-5">
          <SectionTitle>Settlement Outcome</SectionTitle>
          {outcome ? (
            <div
              className={cn(
                'mt-2 rounded-lg px-3 py-3',
                outcome === 'additionalClaim' ? 'bg-amber-50 ring-1 ring-amber-200' : 'bg-emerald-50 ring-1 ring-emerald-200',
              )}
            >
              <p className="flex items-center gap-2 text-sm font-semibold text-slate-900">
                <CheckCircle2 className={cn('h-4 w-4', outcome === 'additionalClaim' ? 'text-amber-700' : 'text-emerald-700')} />
                {SETTLEMENT_SCENARIOS[outcome].title}
              </p>
              <p className="mt-1 text-sm text-slate-700">{outcomeSentence(outcome, ctx)}</p>
            </div>
          ) : (
            <p className="mt-2 text-sm text-slate-500">Business Central has not calculated the outcome yet.</p>
          )}
          {outcome === 'refundDue' ? (
            <OutcomeDetails title="Additional information — Advance Surrender">
            <ReadOnlyAmount label="Amount to be returned" value={formatAmount(ctx.refundAmount || ctx.settlementBalance)} />
            {editable ? (
              <>
                <div className="space-y-1.5">
                  <Label htmlFor="asp-refund-date">Repayment date *</Label>
                  <Input id="asp-refund-date" type="date" value={refundDate} onChange={(event) => setRefundDate(event.target.value)} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="asp-refund-ref">Payment receipt / reference *</Label>
                  <Input
                    id="asp-refund-ref"
                    value={refundReference}
                    maxLength={100}
                    placeholder="Receipt or bank reference no."
                    onChange={(event) => setRefundReference(event.target.value)}
                  />
                </div>
              </>
            ) : (
              <>
                <ReadOnlyAmount label="Repayment date" value={ctx.refundDate ? formatDate(ctx.refundDate) : '—'} />
                <ReadOnlyAmount label="Payment receipt / reference" value={ctx.refundPaymentReference || '—'} />
              </>
            )}
            <p className="text-xs text-slate-500 md:col-span-3">Attach the payment receipt under Supporting Documents (section 2).</p>
          </OutcomeDetails>
        ) : null}

          {outcome === 'additionalClaim' ? (
            <OutcomeDetails title="Additional information — Additional Reimbursement">
            <ReadOnlyAmount label="Additional amount claimed" value={formatAmount(ctx.additionalClaimAmount || Math.abs(ctx.settlementBalance))} />
            <div className="space-y-1.5 md:col-span-2">
              <Label htmlFor="asp-claim">Justification for exceeding the advance {editable ? '*' : ''}</Label>
              {editable ? (
                <Textarea id="asp-claim" rows={3} maxLength={250} value={justification} onChange={(event) => setJustification(event.target.value)} />
              ) : (
                <p className="whitespace-pre-wrap text-sm text-slate-900">{ctx.additionalClaimJustification || '—'}</p>
              )}
            </div>
            <p className="text-xs text-slate-500 md:col-span-3">
              Attach the supporting documents for the extra expenses under Supporting Documents (section 2).
            </p>
          </OutcomeDetails>
        ) : null}
        </div>

        <div className="mt-5">
          <SectionTitle>Settlement Options</SectionTitle>
          <ul className="mt-2 space-y-1 text-sm">
            {(Object.keys(SETTLEMENT_SCENARIOS) as Outcome[]).map((key) => {
              const active = key === outcome
              const Icon = key === 'fullySettled' ? BadgeCheck : key === 'refundDue' ? HandCoins : Wallet
              return (
                <li key={key} aria-current={active ? 'true' : undefined} className={cn('flex items-center gap-2', active ? 'font-semibold text-slate-900' : 'text-slate-600')}>
                  <Icon className={cn('h-4 w-4', active ? 'text-teal-700' : 'text-slate-400')} />
                  {SETTLEMENT_SCENARIOS[key].title}
                  <span className="text-xs font-normal text-slate-500">· {SETTLEMENT_SCENARIOS[key].rule}</span>
                  {active ? <span className="rounded-full bg-teal-600 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide text-white">This settlement</span> : null}
                </li>
              )
            })}
          </ul>
          <p className="mt-2 text-xs text-slate-500">The system determines the outcome from the reconciliation balance.</p>
        </div>
      </section>

      {/* Step 5: declaration, then Submit for Processing (below) */}
      <section className="rounded-xl border border-slate-200 bg-white px-4 py-4">
        <SectionTitle>Declaration and Submission</SectionTitle>
        <div className="mt-2" />
        {editable ? (
          <form className="space-y-3" onSubmit={onSubmit}>
            {missing.length ? (
              <div className="flex items-start gap-2 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-900">
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
                <span>Before Submit for Processing, Business Central needs {missing.join(', ')}.</span>
              </div>
            ) : (
              <div className="flex items-center gap-2 rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
                <CheckCircle2 className="h-4 w-4" />
                {dirty
                  ? 'Save the settlement details, then press Submit for Processing below.'
                  : 'Settlement is complete. Press Submit for Processing below.'}
              </div>
            )}
            <label className="flex items-start gap-2 text-sm text-slate-800">
              <input
                type="checkbox"
                className="mt-0.5 h-4 w-4 rounded border-slate-300"
                checked={declared}
                onChange={(event) => setDeclared(event.target.checked)}
              />
              I confirm that the expenses submitted are actual expenses incurred for the approved purpose and that the
              attached supporting documents are genuine and accurate.
            </label>
            <Button type="submit" variant="outline" disabled={save.isPending}>
              {save.isPending ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Save className="mr-2 h-4 w-4" />}
              Save settlement details
            </Button>
          </form>
        ) : (
          <p className="flex items-center gap-2 text-sm text-slate-700">
            <CheckCircle2 className={cn('h-4 w-4', ctx.declarationConfirmed ? 'text-emerald-600' : 'text-slate-400')} />
            Employee declaration {ctx.declarationConfirmed ? 'confirmed' : 'not confirmed'}. The settlement is complete only
            after Finance finalizes the reconciliation in Business Central.
          </p>
        )}
      </section>
    </div>
  )
}

/** The outcome in one sentence, as in the client's sample. */
function outcomeSentence(outcome: Outcome, ctx: AdvanceSettlementContext) {
  if (outcome === 'refundDue') {
    return `Employee must return ${formatAmount(ctx.refundAmount || ctx.settlementBalance)} to the organization.`
  }
  if (outcome === 'additionalClaim') {
    return `The organization reimburses the employee ${formatAmount(ctx.additionalClaimAmount || Math.abs(ctx.settlementBalance))} (additional expenses).`
  }
  return 'The advance is fully accounted for; nothing is outstanding.'
}

function OutcomeDetails({ title, children }: { title: string; children: ReactNode }) {
  return (
    <div className="mt-3 rounded-xl border border-teal-200 bg-teal-50/50 px-3 py-3">
      <p className="text-sm font-semibold text-teal-900">{title}</p>
      <div className="mt-2 grid gap-3 md:grid-cols-3">{children}</div>
    </div>
  )
}

function ReadOnlyAmount({ label, value }: { label: string; value: string }) {
  return (
    <div className="space-y-1.5">
      <p className="text-sm font-medium text-slate-700">{label}</p>
      <p className="rounded-md border border-slate-200 bg-white px-3 py-2 text-sm font-semibold tabular-nums text-slate-900">{value}</p>
    </div>
  )
}

/** Spec rule 4: several expense entries — BC PortalAdvanceSettlementAddExpense (category with a G/L account). */
function AddExpenseEntry({ surrenderNo }: { surrenderNo: string }) {
  const toast = useToast()
  const queryClient = useQueryClient()
  const [category, setCategory] = useState('')
  const [description, setDescription] = useState('')
  const [amount, setAmount] = useState('')
  const categoriesQuery = useQuery({
    queryKey: ['finance', 'advance-settlement', 'expense-categories'],
    queryFn: fetchPettyCashExpenseCategories,
    staleTime: 5 * 60_000,
  })
  const options = (categoriesQuery.data?.rows ?? [])
    .filter((row) => String(row.meta?.accountNo ?? '').trim())
    .map((row) => ({ value: String(row.value), label: String(row.label) }))

  const add = useMutation({
    mutationFn: () =>
      addAdvanceSettlementExpense({
        surrenderNo,
        expenseCategory: category,
        expenseDescription: description.trim(),
        expenseAmount: Number(amount),
      }),
    onSuccess: async () => {
      setCategory('')
      setDescription('')
      setAmount('')
      // Refresh the reconciliation and the Actual Expenses lines.
      await queryClient.invalidateQueries({ queryKey: [...SETTLEMENT_QUERY_ROOT] })
      toast.success('Expense entry added. Business Central recalculated the settlement.')
    },
    onError: (error) => toast.error(error instanceof Error ? error.message : 'Could not add the expense.', 'Add expense failed'),
  })

  const problem = !category
    ? 'Choose the expense category.'
    : description.trim().length < 3
      ? 'Describe the expense (at least 3 characters).'
      : !(Number(amount) > 0)
        ? 'Enter an amount above 0.'
        : ''

  return (
    <div className="rounded-xl border border-dashed border-slate-300 bg-slate-50/60 px-4 py-3">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div>
          <p className="text-sm font-semibold text-slate-900">Add an expense entry</p>
          <p className="text-xs text-slate-500">
            Each expense with its purpose and amount, for example accommodation, transport or meals.
          </p>
        </div>
      </div>
      <div className="mt-3 grid gap-3 md:grid-cols-[1.2fr_2fr_1fr]">
          <div className="space-y-1.5">
            <Label htmlFor="asp-exp-cat">Expense category *</Label>
            <Select
              id="asp-exp-cat"
              value={category}
              options={options}
              placeholder={categoriesQuery.isLoading ? 'Loading categories…' : options.length ? 'Select category' : 'No categories with a G/L account'}
              onChange={(event) => setCategory(event.target.value)}
            />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="asp-exp-desc">Purpose / description *</Label>
            <Input id="asp-exp-desc" value={description} maxLength={250} onChange={(event) => setDescription(event.target.value)} />
          </div>
          <div className="space-y-1.5">
            <Label htmlFor="asp-exp-amt">Amount (ETB) *</Label>
            <Input id="asp-exp-amt" type="number" min="0" step="0.01" value={amount} onChange={(event) => setAmount(event.target.value)} />
          </div>
          <div className="flex flex-wrap items-center justify-end gap-2 md:col-span-3">
            {problem && (category || description || amount) ? <span className="mr-auto text-xs text-amber-800">{problem}</span> : null}
            {category || description || amount ? (
              <Button
                type="button"
                variant="outline"
                onClick={() => {
                  setCategory('')
                  setDescription('')
                  setAmount('')
                }}
              >
                Clear
              </Button>
            ) : null}
            <Button type="button" disabled={Boolean(problem) || add.isPending} onClick={() => add.mutate()}>
              {add.isPending ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Plus className="mr-2 h-4 w-4" />}
              Add expense
            </Button>
          </div>
        </div>
    </div>
  )
}
