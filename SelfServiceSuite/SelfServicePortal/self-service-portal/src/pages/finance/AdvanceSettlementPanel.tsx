import { useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { Link } from 'react-router-dom'
import {
  AlertTriangle,
  BadgeCheck,
  Check,
  CheckCircle2,
  Coins,
  HandCoins,
  Loader2,
  Plus,
  ReceiptText,
  Save,
  Scale,
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

  return (
    <div className="space-y-5">
      <SettlementSection number={1} title="Advance Summary" hint="The advance received, from Business Central" done={Boolean(ctx)}>
        {ctx ? <AdvanceReceived ctx={ctx} /> : contextState}
        <div className="mt-5 border-t border-slate-200 pt-4">{details}</div>
      </SettlementSection>

      <SettlementSection
        number={2}
        title="Expense Entries & Supporting Documents"
        hint={
          ctx
            ? `${formatAmount(ctx.totalActualExpenses)} entered · ${documents} ${documents === 1 ? 'document' : 'documents'}`
            : 'What you spent, with the receipts'
        }
        done={expensesEntered && documents > 0}
      >
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
      </SettlementSection>

      <SettlementSection
        number={3}
        title="Expense Reconciliation & Settlement"
        hint="Calculated automatically from the advance and the expenses"
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

/** Section 1: the advance this settlement accounts for. */
function AdvanceReceived({ ctx }: { ctx: AdvanceSettlementContext }) {
  const advanceNo = ctx.advanceNo || ctx.advance?.advanceNo || ''
  const purpose = ctx.advance?.requestPurposeText || ctx.advance?.purpose || ctx.purpose
  return (
    <div className="flex flex-wrap items-end justify-between gap-4 rounded-xl border border-sky-100 bg-sky-50/70 px-4 py-3">
      <div>
        <p className="text-xs font-medium text-slate-600">Total Advance Received</p>
        <p className="mt-0.5 text-2xl font-bold tabular-nums text-slate-950">{formatAmount(ctx.totalAdvanceReceived)}</p>
      </div>
      <dl className="grid min-w-0 flex-1 gap-x-6 gap-y-2 text-sm sm:grid-cols-3">
        <div className="min-w-0">
          <dt className="text-xs text-slate-500">Advance Request</dt>
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
          <dt className="text-xs text-slate-500">Paid on</dt>
          <dd className="font-semibold">{ctx.advance?.paymentDate ? formatDate(ctx.advance.paymentDate) : '—'}</dd>
        </div>
        <div className="min-w-0">
          <dt className="text-xs text-slate-500">Purpose</dt>
          <dd className="truncate font-semibold" title={purpose}>
            {purpose || '—'}
          </dd>
        </div>
      </dl>
    </div>
  )
}

function SectionTitle({ children }: { children: ReactNode }) {
  return <h4 className="text-sm font-semibold text-[var(--portal-navy)]">{children}</h4>
}

function Tile({ icon, label, hint, value, tone }: { icon: ReactNode; label: string; hint: string; value: string; tone?: string }) {
  return (
    <div className={cn('flex flex-1 flex-col items-center rounded-xl border px-3 py-3 text-center', tone ?? 'border-sky-100 bg-sky-50/70')}>
      <span className="text-sky-700">{icon}</span>
      <p className="mt-1 text-sm font-semibold text-slate-900">{label}</p>
      <p className="text-[11px] text-slate-500">{hint}</p>
      <p className="mt-1.5 text-lg font-bold tabular-nums text-slate-950">{value}</p>
    </div>
  )
}

function Operator({ children }: { children: ReactNode }) {
  return (
    <span className="flex items-center justify-center text-2xl font-bold text-[var(--portal-navy)]" aria-hidden="true">
      {children}
    </span>
  )
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

  const balanceLabel =
    outcome === 'refundDue'
      ? 'To be returned'
      : outcome === 'additionalClaim'
        ? 'Additional amount claimed'
        : 'No outstanding amount'

  return (
    <div className="space-y-4">
      {/* Reconciliation: the advance against the actual expenses */}
      <section>
        <SectionTitle>Reconciliation</SectionTitle>
        <p className="mt-0.5 text-xs text-slate-500">
          Calculated automatically by Business Central for advance {ctx.advanceNo || ctx.advance?.advanceNo || '—'}
          {ctx.advance?.paymentDate ? ` (paid ${formatDate(ctx.advance.paymentDate)})` : ''}.
        </p>
        <div className="mt-3 flex flex-col gap-2 sm:flex-row sm:items-stretch">
          <Tile icon={<Coins className="h-6 w-6" />} label="Total Advance Received" hint="From Business Central" value={formatAmount(ctx.totalAdvanceReceived)} />
          <Operator>−</Operator>
          <Tile icon={<ReceiptText className="h-6 w-6" />} label="Total Actual Expenses" hint="Sum of the expense entries" value={formatAmount(ctx.totalActualExpenses)} />
          <Operator>=</Operator>
          <Tile
            icon={<Scale className="h-6 w-6" />}
            label="Balance"
            hint={`Difference · ${balanceLabel}`}
            value={formatAmount(Math.abs(ctx.settlementBalance))}
            tone={
              outcome === 'refundDue'
                ? 'border-orange-200 bg-orange-50/80'
                : outcome === 'additionalClaim'
                  ? 'border-amber-200 bg-amber-50/80'
                  : 'border-emerald-200 bg-emerald-50/80'
            }
          />
        </div>
      </section>

      {/* Settlement outcome — the one BC calculated is highlighted */}
      <section className="border-t border-slate-200 pt-4">
        <SectionTitle>Settlement Outcome</SectionTitle>
        <div className="mt-3 grid gap-3 md:grid-cols-3">
          {(Object.keys(SETTLEMENT_SCENARIOS) as Outcome[]).map((key) => {
            const scenario = SETTLEMENT_SCENARIOS[key]
            const active = key === outcome
            const Icon = key === 'fullySettled' ? BadgeCheck : key === 'refundDue' ? HandCoins : Wallet
            return (
              <div
                key={key}
                aria-current={active ? 'true' : undefined}
                className={cn(
                  'rounded-xl border px-3 py-3 transition',
                  active
                    ? 'border-teal-400 bg-teal-50 shadow-sm ring-2 ring-teal-300/60'
                    : 'border-slate-200 bg-slate-50/60 opacity-60',
                )}
              >
                <p className="flex items-center gap-2 text-sm font-semibold text-slate-900">
                  <Icon className={cn('h-5 w-5', active ? 'text-teal-700' : 'text-slate-400')} />
                  {scenario.letter}. {scenario.title}
                  {active ? (
                    <span className="ml-auto rounded-full bg-teal-600 px-2 py-0.5 text-[10px] font-bold uppercase tracking-wide text-white">
                      Your outcome
                    </span>
                  ) : null}
                </p>
                <ul className="mt-1.5 list-disc space-y-0.5 pl-5 text-xs text-slate-700">
                  <li>{scenario.rule}</li>
                  <li>{scenario.action}</li>
                </ul>
                {key === 'fullySettled' && active ? (
                  <p className="mt-2 rounded-lg bg-emerald-100 px-2 py-1 text-center text-xs font-semibold text-emerald-800">
                    Advance is fully accounted for
                  </p>
                ) : null}
              </div>
            )
          })}
        </div>

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
      </section>

      {/* Declaration + save */}
      <section className="border-t border-slate-200 pt-4">
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
                {dirty ? 'Save the settlement details, then submit for processing.' : 'Settlement is complete. You can submit it for processing.'}
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
