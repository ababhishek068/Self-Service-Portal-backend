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
  sameAmount,
  settlementMissing,
  settlementOptionTotal,
  useAdvanceSettlementContext,
} from '@/hooks/useAdvanceSettlementContext'
import { SettlementExpenseEntries } from '@/components/finance/SettlementExpenseEntries'
import { SettlementOptionForm } from '@/components/finance/SettlementOptionForm'
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
  // BC 1.0.3.669 (client Pending issues, 20 Nov 2026): Option 1 / Option 2 settlement replaces the expense cards.
  const options = Boolean(ctx?.supportsSettlementOptions)
  const section2Done = options ? Boolean(ctx && (ctx.receiptedAmount ?? 0) > 0) && documents > 0 : expensesEntered && documents > 0

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
            ? `${formatAmount(ctx.totalAdvanceReceived)} advance · ${documents} ${documents === 1 ? 'document' : 'documents'}`
            : 'What you spent, with the receipts'
        }
        done={section2Done}
      >
        {options && ctx ? (
          <SettlementOptionForm key={`${ctx.surrenderNo}:${request.status}`} request={request} ctx={ctx} editable={isDraft} />
        ) : entryCards && ctx ? (
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
        done={Boolean(ctx) && settlementMissing(ctx!, options ? documents : undefined).length === 0}
      >
        {ctx ? (
          <SettlementSummary key={`${ctx.surrenderNo}:${request.status}`} ctx={ctx} editable={isDraft} documents={documents} />
        ) : (
          contextState
        )}
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

function SettlementSummary({ ctx, editable, documents }: { ctx: AdvanceSettlementContext; editable: boolean; documents: number }) {
  const options = Boolean(ctx.supportsSettlementOptions)
  const toast = useToast()
  const queryClient = useQueryClient()
  const [refundDate, setRefundDate] = useState(ctx.refundDate)
  const [refundReference, setRefundReference] = useState(ctx.refundPaymentReference)
  const [justification, setJustification] = useState(ctx.additionalClaimJustification)
  const [declared, setDeclared] = useState(ctx.declarationConfirmed)

  const option = ctx.settlementOption ?? 'option1'
  const receipted = ctx.receiptedAmount ?? 0
  const nonReceipted = option === 'option2' ? ctx.nonReceiptedAmount ?? 0 : 0
  const total = settlementOptionTotal(option, receipted, nonReceipted)
  const balance = Math.round((ctx.totalAdvanceReceived - total) * 100) / 100

  const refundAmt = ctx.refundAmount || Math.abs(balance) || ctx.settlementBalance
  const canPayLater = refundAmt > 0 && refundAmt < 5000
  const isInitialPayLater =
    ctx.refundSettlementOption === 'payLater' || ctx.refundPaymentReference === 'PENDING_REPAYMENT'
  const [refundOption, setRefundOption] = useState<'payNow' | 'payLater'>(
    canPayLater && isInitialPayLater ? 'payLater' : 'payNow',
  )

  // Keep state synced when ctx updates
  useEffect(() => {
    if (ctx.refundDate) setRefundDate(ctx.refundDate)
    if (ctx.refundPaymentReference) setRefundReference(ctx.refundPaymentReference)
    if (ctx.additionalClaimJustification) setJustification(ctx.additionalClaimJustification)
    if (ctx.declarationConfirmed !== undefined) setDeclared(ctx.declarationConfirmed)
    if (canPayLater) {
      setRefundOption(
        ctx.refundSettlementOption === 'payLater' || ctx.refundPaymentReference === 'PENDING_REPAYMENT'
          ? 'payLater'
          : 'payNow',
      )
    }
  }, [
    ctx.refundDate,
    ctx.refundPaymentReference,
    ctx.additionalClaimJustification,
    ctx.declarationConfirmed,
    ctx.refundSettlementOption,
    canPayLater,
  ])

  const effectiveOutcome: Outcome | '' =
    (ctx.settlementOutcome as Outcome) ||
    (options && receipted > 0
      ? balance > 0.005
        ? 'refundDue'
        : balance < -0.005
          ? 'additionalClaim'
          : 'fullySettled'
      : (ctx.settlementBalance > 0.005 ? 'refundDue' : ctx.settlementBalance < -0.005 ? 'additionalClaim' : 'fullySettled'))

  const outcome = effectiveOutcome
  const missing = settlementMissing(ctx, options ? documents : undefined)
  const dirty =
    editable &&
    (declared !== ctx.declarationConfirmed ||
      (outcome === 'refundDue' &&
        ((canPayLater && refundOption !== (isInitialPayLater ? 'payLater' : 'payNow')) ||
          (refundOption === 'payNow' &&
            (refundDate !== ctx.refundDate || refundReference.trim() !== ctx.refundPaymentReference)))) ||
      (outcome === 'additionalClaim' && justification.trim() !== ctx.additionalClaimJustification))

  // Submit for Processing reads this to stop before BC refuses the settlement.
  useEffect(() => {
    rememberSettlementPanel(ctx.surrenderNo, { missing: editable ? missing : [], dirty })
  })

  const save = useMutation({
    mutationFn: () =>
      saveAdvanceSettlementDetails({
        surrenderNo: ctx.surrenderNo,
        refundDateText: outcome === 'refundDue' ? (refundOption === 'payLater' ? '' : refundDate) : '',
        refundPaymentReference:
          outcome === 'refundDue'
            ? refundOption === 'payLater'
              ? 'PENDING_REPAYMENT'
              : refundReference.trim()
            : '',
        additionalClaimJustification: outcome === 'additionalClaim' ? justification.trim() : '',
        declarationConfirmed: declared,
        // Blank keeps BC's remarks (PortalAdvanceSettlementSave only overwrites non-blank remarks).
        settlementRemarks: '',
        refundSettlementOption: outcome === 'refundDue' && canPayLater ? refundOption : 'payNow',
        pendingRepaymentAmount: outcome === 'refundDue' && refundOption === 'payLater' ? refundAmt : 0,
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
      {options ? (
        <OptionReconciliation ctx={ctx} />
      ) : (
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
        </section>
      )}

      {/* Settlement Outcome details (Refund Due or Additional Claim) */}
      <section className="rounded-xl border border-slate-200 bg-white px-4 py-4">
        <SectionTitle>Settlement Outcome & Reconciliation</SectionTitle>
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
            <p className="mt-1 text-sm text-slate-700">{outcomeSentence(outcome, ctx, balance)}</p>
          </div>
        ) : (
          <p className="mt-2 text-sm text-slate-500">Business Central has not calculated the outcome yet.</p>
        )}
        {outcome === 'refundDue' ? (
          <OutcomeDetails title="Additional information — Advance Surrender (Refund Due)">
            <ReadOnlyAmount label="Amount to be returned" value={formatAmount(refundAmt)} />
            {canPayLater ? (
              <div className="space-y-2 md:col-span-3">
                <Label className="text-sm font-semibold text-slate-900">
                  How would you like to settle the outstanding amount?
                </Label>
                <div className="grid gap-2 sm:grid-cols-2">
                  <label
                    className={cn(
                      'flex cursor-pointer items-start gap-3 rounded-lg border p-3 transition',
                      refundOption === 'payNow'
                        ? 'border-[var(--portal-navy)] bg-teal-50/70 ring-1 ring-[var(--portal-navy)]'
                        : 'border-slate-200 bg-white hover:border-slate-300',
                      !editable && 'cursor-default pointer-events-none',
                    )}
                  >
                    <input
                      type="radio"
                      name="refundOption"
                      value="payNow"
                      checked={refundOption === 'payNow'}
                      disabled={!editable}
                      onChange={() => setRefundOption('payNow')}
                      className="mt-0.5 h-4 w-4 text-[var(--portal-navy)]"
                    />
                    <div>
                      <span className="block text-sm font-medium text-slate-900">Pay now</span>
                      <span className="block text-xs text-slate-500">Complete repayment details.</span>
                    </div>
                  </label>
                  <label
                    className={cn(
                      'flex cursor-pointer items-start gap-3 rounded-lg border p-3 transition',
                      refundOption === 'payLater'
                        ? 'border-amber-500 bg-amber-50/70 ring-1 ring-amber-500'
                        : 'border-slate-200 bg-white hover:border-slate-300',
                      !editable && 'cursor-default pointer-events-none',
                    )}
                  >
                    <input
                      type="radio"
                      name="refundOption"
                      value="payLater"
                      checked={refundOption === 'payLater'}
                      disabled={!editable}
                      onChange={() => setRefundOption('payLater')}
                      className="mt-0.5 h-4 w-4 text-amber-600"
                    />
                    <div>
                      <span className="block text-sm font-medium text-slate-900">Pay later</span>
                      <span className="block text-xs text-slate-500">Record as pending repayment.</span>
                    </div>
                  </label>
                </div>
              </div>
            ) : null}

            {refundOption === 'payLater' ? (
              <div className="rounded-xl border border-amber-200 bg-amber-50/80 p-4 md:col-span-3">
                <div className="flex items-center justify-between gap-4">
                  <div>
                    <p className="text-xs font-semibold uppercase tracking-wider text-amber-800">Pending Repayment</p>
                    <span className="mt-1 inline-flex items-center rounded-full bg-amber-200 px-2.5 py-0.5 text-xs font-bold text-amber-900 ring-1 ring-inset ring-amber-500/30">
                      {ctx.status === 'Posted' && ctx.pendingRepaymentAmount === 0 ? 'Repaid' : 'Pending'}
                    </span>
                  </div>
                  <div className="text-right">
                    <p className="text-xs text-amber-700">Outstanding balance</p>
                    <p className="text-2xl font-bold tabular-nums text-amber-950">
                      {formatAmount(ctx.pendingRepaymentAmount ?? refundAmt)}
                    </p>
                  </div>
                </div>
                <p className="mt-2 text-xs text-amber-900">
                  {ctx.status === 'Posted' && ctx.pendingRepaymentAmount === 0
                    ? 'Repayment has been completed and recorded.'
                    : 'This amount will remain outstanding until repayment is completed and recorded.'}
                </p>
              </div>
            ) : editable ? (
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
                <p className="text-xs text-slate-500 md:col-span-3">Attach the payment receipt under Supporting Documents (section 2).</p>
              </>
            ) : (
              <>
                <ReadOnlyAmount label="Repayment date" value={ctx.refundDate ? formatDate(ctx.refundDate) : '—'} />
                <ReadOnlyAmount label="Payment receipt / reference" value={ctx.refundPaymentReference || '—'} />
              </>
            )}
          </OutcomeDetails>
        ) : null}

        {outcome === 'additionalClaim' ? (
          <OutcomeDetails title="Additional information — Additional Reimbursement (Claim Due)">
            <ReadOnlyAmount label="Additional amount claimed" value={formatAmount(ctx.additionalClaimAmount || Math.abs(balance) || Math.abs(ctx.settlementBalance))} />
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

        {!options ? (
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
        ) : null}
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

/**
 * BC 1.0.3.669 / 1.0.3.672: reconciliation of the settlement option — supports full settlement,
 * refund due to organization (when spend < advance), and claim due to staff (when spend > advance).
 * Where the settlement goes: Option 1 directly to Finance, Option 2 to the First Line Manager, then FAD.
 */
function OptionReconciliation({ ctx }: { ctx: AdvanceSettlementContext }) {
  const option = ctx.settlementOption ?? 'option1'
  const receipted = ctx.receiptedAmount ?? 0
  const nonReceipted = option === 'option2' ? ctx.nonReceiptedAmount ?? 0 : 0
  const total = settlementOptionTotal(option, receipted, nonReceipted)
  const saved = receipted > 0
  const balance = Math.round((ctx.totalAdvanceReceived - total) * 100) / 100
  const isMatch = sameAmount(balance, 0)
  const isRefund = balance > 0.005
  const isClaim = balance < -0.005

  return (
    <section className="rounded-xl border border-slate-200 bg-white px-4 py-4 space-y-4">
      <div>
        <SectionTitle>Financial Reconciliation</SectionTitle>
        <dl className="mt-3 space-y-2 text-sm">
          <div className="flex items-center justify-between gap-3">
            <dt className="text-slate-600">Total Advance Received</dt>
            <dd className="font-semibold tabular-nums text-slate-950">{formatAmount(ctx.totalAdvanceReceived)}</dd>
          </div>
          <div className="flex items-center justify-between gap-3">
            <dt className="text-slate-600">Supported Expenses (with receipt)</dt>
            <dd className="font-semibold tabular-nums text-slate-950">{formatAmount(receipted)}</dd>
          </div>
          {option === 'option2' ? (
            <div className="flex items-center justify-between gap-3">
              <dt className="text-slate-600">Unsupported Expenses (without receipt)</dt>
              <dd className="font-semibold tabular-nums text-slate-950">{formatAmount(nonReceipted)}</dd>
            </div>
          ) : null}
          <div className="flex items-center justify-between gap-3 border-t border-slate-200 pt-2 font-medium">
            <dt className="text-slate-700">Total Actual Expenditure</dt>
            <dd className="font-bold tabular-nums text-slate-950">{formatAmount(total)}</dd>
          </div>
          <div className="flex items-center justify-between gap-3 border-t border-slate-200 pt-3">
            <dt className="text-base font-semibold text-slate-900">
              {isRefund ? 'Refund Due to Organization' : isClaim ? 'Additional Claim Due to Staff' : 'Remaining Balance'}
            </dt>
            <dd className={cn('text-2xl font-bold tabular-nums', isMatch ? 'text-emerald-700' : isRefund ? 'text-amber-700' : 'text-sky-700')}>
              {saved ? formatAmount(Math.abs(balance)) : '—'}
            </dd>
          </div>
          {isRefund && saved ? (
            <div className="mt-2 rounded-lg border border-amber-200 bg-amber-50/70 p-3 text-xs space-y-1.5">
              <div className="flex justify-between">
                <span className="text-slate-600">Amount Recovered / Returned:</span>
                <span className="font-semibold text-slate-900 tabular-nums">
                  {ctx.refundPaymentReference ? formatAmount(Math.abs(balance)) : formatAmount(0)}
                </span>
              </div>
              <div className="flex justify-between border-t border-amber-200/60 pt-1">
                <span className="text-slate-600">Remaining Outstanding Balance:</span>
                <span className={cn('font-bold tabular-nums', ctx.refundPaymentReference ? 'text-emerald-700' : 'text-rose-700')}>
                  {ctx.refundPaymentReference ? formatAmount(0) : formatAmount(Math.abs(balance))}
                </span>
              </div>
              <p className="pt-1 text-[11px] text-amber-900 font-medium">
                {ctx.refundPaymentReference
                  ? `✓ Payment reference recorded: ${ctx.refundPaymentReference}. Transaction pending final Finance posting closure.`
                  : '⚠ Refund pending. Enter the repayment date and reference below in Section 3 to record recovery.'}
              </p>
            </div>
          ) : null}
        </dl>
      </div>

      {/* Checklist Section D Scenarios Visualizer */}
      <div className="rounded-xl border border-sky-200/80 bg-sky-50/40 p-3.5 text-xs">
        <p className="font-semibold text-slate-900 flex items-center justify-between">
          <span>End-to-End Checklist Verification (Section D Scenarios)</span>
          <span className="rounded-full bg-sky-100 px-2.5 py-0.5 text-[10px] font-bold uppercase tracking-wider text-sky-800">
            {option === 'option2' && nonReceipted > 0 ? 'Scenario 5 + ' : ''}
            {isRefund ? 'Scenario 1 & 3' : isClaim ? 'Scenario 4' : 'Scenario 2'}
          </span>
        </p>
        <div className="mt-2.5 grid gap-2 sm:grid-cols-2">
          <div className="rounded-lg border border-slate-200 bg-white p-2.5 space-y-1">
            <p className="font-semibold text-slate-800">
              {isRefund ? 'Scenario 1 & 3: Refund & Balance Recovery' : isClaim ? 'Scenario 4: Additional Claim' : 'Scenario 2: Zero Balance'}
            </p>
            <p className="text-slate-600 text-[11px]">
              {isRefund
                ? `Approved advance (${formatAmount(ctx.totalAdvanceReceived)}) > Expenditure (${formatAmount(total)}). Unspent balance (${formatAmount(Math.abs(balance))}) is recorded as refundable.`
                : isClaim
                  ? `Approved expenditure (${formatAmount(total)}) > Advance (${formatAmount(ctx.totalAdvanceReceived)}). Additional reimbursement (${formatAmount(Math.abs(balance))}) initiated.`
                  : `Advance (${formatAmount(ctx.totalAdvanceReceived)}) is fully utilized. Zero balance remaining.`}
            </p>
          </div>
          {option === 'option2' ? (
            <div className="rounded-lg border border-amber-200 bg-amber-50/60 p-2.5 space-y-1">
              <p className="font-semibold text-amber-950">Scenario 5: Unsupported / Disallowed Expenditure</p>
              <p className="text-amber-900 text-[11px]">
                {formatAmount(receipted)} supported + {formatAmount(nonReceipted)} unsupported. Routed to First Line Manager & FAD review. Disallowed amounts become recoverable.
              </p>
            </div>
          ) : (
            <div className="rounded-lg border border-emerald-200 bg-emerald-50/60 p-2.5 space-y-1">
              <p className="font-semibold text-emerald-950">Option 1: Full Settlement with Receipt</p>
              <p className="text-emerald-900 text-[11px]">
                100% supported by receipts. Direct routing to Finance without secondary management approval.
              </p>
            </div>
          )}
        </div>
      </div>

      <div className="rounded-lg bg-slate-50 px-3 py-3 ring-1 ring-slate-200">
        <p className="text-sm font-semibold text-slate-900">
          {option === 'option1' ? 'Option 1: Full Settlement with Receipt' : 'Option 2: Partial Settlement (With and Without Receipt)'}
        </p>
        <p className="mt-1 text-sm text-slate-700">
          {option === 'option1'
            ? 'After Submit for Processing the settlement goes directly to Finance.'
            : 'After Submit for Processing the settlement is approved by the First Line Manager, then FAD, and then goes to Finance.'}
        </p>
        <p className="mt-1 text-xs text-slate-500">
          Total expenses can be fully settled, under-spent (with refund to organization in Section 3), or over-spent (recorded as a claim in Section 3).
        </p>
      </div>
    </section>
  )
}

/** The outcome in one sentence, as in the client's sample. */
function outcomeSentence(outcome: Outcome, ctx: AdvanceSettlementContext, balance?: number) {
  const refundAmt = ctx.refundAmount || (balance !== undefined && balance > 0 ? balance : Math.abs(ctx.settlementBalance))
  const claimAmt = ctx.additionalClaimAmount || (balance !== undefined && balance < 0 ? Math.abs(balance) : Math.abs(ctx.settlementBalance))
  if (outcome === 'refundDue') {
    return `Employee must return ${formatAmount(refundAmt)} to the organization.`
  }
  if (outcome === 'additionalClaim') {
    return `The organization reimburses the employee ${formatAmount(claimAmt)} (additional expenses).`
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
