import { useEffect, useId, useState, type ReactNode } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { AlertTriangle, CheckCircle2, Coins, Info, Loader2, Save } from 'lucide-react'
import {
  saveAdvanceSettlementOption,
  type AdvanceSettlementContext,
  type SettlementOption,
} from '@/api/endpoints/advanceSettlement'
import { uploadRequestAttachment } from '@/api/endpoints/requestEndpoint'
import { useToast } from '@/components/feedback/ToastProvider'
import { DocumentList } from '@/components/finance/SettlementExpenseEntries'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  SETTLEMENT_QUERY_ROOT,
  rememberSettlementOptionDirty,
  sameAmount,
  settlementOptionTotal,
} from '@/hooks/useAdvanceSettlementContext'
import { cn } from '@/lib/utils'
import { formatAmount } from '@/utils/formatters'
import { readFileAsBase64 } from '@/utils/readFileAsBase64'
import type { PortalRequest } from '@/types/erp.types'

const OPTIONS: Array<{ value: SettlementOption; title: string; text: string }> = [
  {
    value: 'option1',
    title: 'Option 1: Full Settlement with Receipt',
    text: 'Enter one expense amount with its receipt. The document will go directly to Finance.',
  },
  {
    value: 'option2',
    title: 'Option 2: Partial Settlement (With and Without Receipt)',
    text: 'Enter two amounts: one with receipt and one without receipt. Requires approval again and will go to First Line Manager, then FAD.',
  },
]

function amountText(value: number) {
  return value > 0 ? String(value) : ''
}

function parseAmount(value: string) {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : 0
}

/**
 * Section 2 of the Advance Settlement with BC 1.0.3.669 (client Pending issues, 20 Nov 2026, settlement option sample):
 * Option 1 (default) — one expense entry: amount, receipt / reference no. and documents, straight to Finance.
 * Option 2 — an entry with receipt and one without, totalled automatically, approved by the First Line Manager then
 * FAD. Option 2's fields show only while it is chosen; can be fully settled, under-spent (refund due), or over-spent (claim).
 */
export function SettlementOptionForm({
  request,
  ctx,
  editable,
}: {
  request: PortalRequest
  ctx: AdvanceSettlementContext
  editable: boolean
}) {
  const toast = useToast()
  const queryClient = useQueryClient()
  const advance = ctx.totalAdvanceReceived
  const savedOption: SettlementOption = ctx.settlementOption ?? 'option1'
  const savedReceipted = ctx.receiptedAmount ?? 0
  const savedNonReceipted = ctx.nonReceiptedAmount ?? 0
  const savedReceiptNo = ctx.settlementReceiptNo ?? ''
  const saved = savedReceipted > 0

  const [option, setOption] = useState<SettlementOption>(savedOption)
  // Option 1's single amount defaults to the advance; Option 2 keeps its own two amounts.
  const [fullAmount, setFullAmount] = useState(amountText(saved && savedOption === 'option1' ? savedReceipted : advance))
  const [withReceipt, setWithReceipt] = useState(amountText(saved && savedOption === 'option2' ? savedReceipted : 0))
  const [withoutReceipt, setWithoutReceipt] = useState(amountText(saved && savedOption === 'option2' ? savedNonReceipted : 0))
  const [receiptNo, setReceiptNo] = useState(savedReceiptNo)
  const groupName = useId()

  const receipted = option === 'option1' ? parseAmount(fullAmount) : parseAmount(withReceipt)
  const nonReceipted = option === 'option2' ? parseAmount(withoutReceipt) : 0
  const total = settlementOptionTotal(option, receipted, nonReceipted)
  const matches = sameAmount(total, advance)
  const documents = request.attachments ?? []

  const dirty =
    editable &&
    (!saved ||
      option !== savedOption ||
      !sameAmount(receipted, savedReceipted) ||
      !sameAmount(nonReceipted, option === 'option2' ? savedNonReceipted : 0) ||
      receiptNo.trim() !== savedReceiptNo)
  useEffect(() => {
    rememberSettlementOptionDirty(ctx.surrenderNo, dirty)
  }, [ctx.surrenderNo, dirty])
  useEffect(() => () => rememberSettlementOptionDirty(ctx.surrenderNo, false), [ctx.surrenderNo])

  const problem = !(receipted > 0)
    ? option === 'option1'
      ? 'Enter the expense amount.'
      : 'Enter the expense amount with receipt.'
    : option === 'option2' && !(nonReceipted > 0)
      ? 'Enter the expense amount without receipt, or choose Option 1.'
      : !receiptNo.trim()
        ? 'Enter the receipt / reference number.'
        : ''

  const save = useMutation({
    mutationFn: () =>
      saveAdvanceSettlementOption({
        surrenderNo: ctx.surrenderNo,
        settlementOption: option,
        receiptedAmount: receipted,
        nonReceiptedAmount: nonReceipted,
        receiptNo: receiptNo.trim(),
      }),
    onSuccess: async () => {
      rememberSettlementOptionDirty(ctx.surrenderNo, false)
      await queryClient.invalidateQueries({ queryKey: [...SETTLEMENT_QUERY_ROOT] })
      toast.success(
        option === 'option1'
          ? 'Expense entry saved. After submission this settlement goes directly to Finance.'
          : 'Expense entries saved. After submission this settlement goes to the First Line Manager, then FAD.',
      )
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Business Central did not save the expense entry.', 'Not saved'),
  })

  const uploadReceipts = (files: File[]) =>
    Promise.all(
      files.map(async (file) =>
        uploadRequestAttachment(request.id, {
          fileName: file.name,
          fileType: file.type || 'application/octet-stream',
          size: file.size,
          contentBase64: await readFileAsBase64(file),
          description: `${receiptNo.trim() ? `Receipt ${receiptNo.trim()}: ` : 'Receipt: '}${file.name}`.slice(0, 250),
        }),
      ),
    )

  const supportingDocuments = (
    <div className="space-y-1">
      <p className="text-sm font-medium text-slate-700">Supporting Documents {editable ? <span className="text-rose-600">*</span> : null}</p>
      <DocumentList
        request={request}
        documents={documents}
        editable={editable}
        onFiles={uploadReceipts}
        uploadLabel="Upload receipt or supporting document"
      />
    </div>
  )

  const receiptField = (id: string) => (
    <div className="space-y-1.5">
      <Label htmlFor={id}>Receipt / Reference Number {editable ? <span className="text-rose-600">*</span> : null}</Label>
      {editable ? (
        <Input id={id} value={receiptNo} maxLength={50} placeholder="e.g. RCPT-2026-00123" onChange={(event) => setReceiptNo(event.target.value)} />
      ) : (
        <ReadOnlyValue>{savedReceiptNo || '—'}</ReadOnlyValue>
      )}
    </div>
  )

  const amountField = (id: string, label: string, value: string, onChange: (value: string) => void, readOnly: number) => (
    <div className="space-y-1.5">
      <Label htmlFor={id}>
        {label} {editable ? <span className="text-rose-600">*</span> : null}
      </Label>
      {editable ? (
        <Input id={id} type="number" min="0" step="0.01" inputMode="decimal" value={value} onChange={(event) => onChange(event.target.value)} />
      ) : (
        <ReadOnlyValue>{formatAmount(readOnly)}</ReadOnlyValue>
      )}
    </div>
  )

  const shownOption = editable ? option : savedOption

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-3 rounded-xl bg-sky-50 px-4 py-3 ring-1 ring-sky-100">
        <Coins className="h-7 w-7 shrink-0 text-[var(--portal-navy)]" aria-hidden="true" />
        <div>
          <p className="text-xs text-slate-600">Total Advance Amount</p>
          <p className="text-xl font-bold tabular-nums text-slate-950">{formatAmount(advance)}</p>
        </div>
      </div>

      <fieldset>
        <legend className="text-sm font-semibold text-slate-900">Select Settlement Option</legend>
        <div className="mt-2 grid gap-3 md:grid-cols-2">
          {OPTIONS.map((item) => {
            const active = shownOption === item.value
            return (
              <label
                key={item.value}
                className={cn(
                  'flex gap-3 rounded-xl border px-4 py-3 transition',
                  active ? 'border-[var(--portal-navy)] bg-teal-50/70 ring-1 ring-[var(--portal-navy)]' : 'border-slate-200 bg-white',
                  editable ? 'cursor-pointer hover:border-[var(--portal-navy)]' : 'cursor-default',
                  !editable && !active && 'opacity-60',
                )}
              >
                <input
                  type="radio"
                  name={groupName}
                  value={item.value}
                  checked={active}
                  disabled={!editable || save.isPending}
                  onChange={() => setOption(item.value)}
                  className="mt-1 h-4 w-4 shrink-0 accent-[var(--portal-navy)]"
                />
                <span>
                  <span className="block text-sm font-semibold text-slate-900">{item.title}</span>
                  <span className="mt-0.5 block text-xs text-slate-600">{item.text}</span>
                </span>
              </label>
            )
          })}
        </div>
      </fieldset>

      {shownOption === 'option1' ? (
        <section className="rounded-xl border border-slate-200 bg-white px-4 py-4" aria-label="Option 1: Full Settlement with Receipt">
          <span className="inline-flex items-center gap-1.5 rounded-full bg-emerald-600 px-2.5 py-0.5 text-xs font-semibold text-white">
            <CheckCircle2 className="h-3.5 w-3.5" /> Option 1 Selected
          </span>
          <h4 className="mt-2 text-base font-semibold text-slate-900">Full Settlement – With Receipt</h4>
          <div className="mt-3 space-y-4">
            {amountField('so-full-amount', 'Expense Amount (ETB)', fullAmount, setFullAmount, savedReceipted)}
            {receiptField('so-full-receipt')}
            {supportingDocuments}
          </div>
          <div className="mt-3 flex flex-wrap items-center justify-between gap-2">
            <MatchState matches={editable ? matches : sameAmount(savedReceipted, advance)} total={editable ? total : savedReceipted} advance={advance} />
            <p className="flex items-center gap-1.5 rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-xs font-medium text-emerald-800">
              <CheckCircle2 className="h-3.5 w-3.5" /> This option will go directly to Finance.
            </p>
          </div>
        </section>
      ) : (
        <section className="rounded-xl border border-slate-200 bg-white px-4 py-4" aria-label="Option 2: Partial Settlement (With and Without Receipt)">
          <span className="inline-flex items-center gap-1.5 rounded-full bg-sky-100 px-2.5 py-0.5 text-xs font-semibold text-sky-900 ring-1 ring-sky-200">
            <Info className="h-3.5 w-3.5" /> Option 2 Selected
          </span>
          <h4 className="mt-2 text-base font-semibold text-slate-900">Partial Settlement – With and Without Receipt</h4>
          <div className="mt-3 grid gap-4 lg:grid-cols-[1fr_1fr_0.9fr]">
            <div className="space-y-3">
              <p className="rounded-md bg-sky-50 px-3 py-1.5 text-sm font-semibold text-slate-900">Entry 1: Expense With Receipt</p>
              {amountField('so-with-amount', 'Expense Amount (ETB)', withReceipt, setWithReceipt, savedReceipted)}
              {receiptField('so-with-receipt')}
              {supportingDocuments}
            </div>
            <div className="space-y-3">
              <p className="rounded-md bg-sky-50 px-3 py-1.5 text-sm font-semibold text-slate-900">Entry 2: Expense Without Receipt</p>
              {amountField('so-without-amount', 'Expense Amount (ETB)', withoutReceipt, setWithoutReceipt, savedNonReceipted)}
              <p className="flex items-start gap-1.5 rounded-lg border border-sky-200 bg-sky-50 px-3 py-2 text-xs text-sky-900">
                <Info className="mt-0.5 h-3.5 w-3.5 shrink-0" /> No receipt number or attachment is required for this amount.
              </p>
            </div>
            <div className="rounded-xl border border-slate-200 bg-slate-50/70 px-3 py-3">
              <p className="text-sm font-semibold text-slate-900">Settlement Summary</p>
              <dl className="mt-2 space-y-1.5 text-sm">
                <div className="flex justify-between gap-2">
                  <dt className="text-slate-600">Receipted Amount</dt>
                  <dd className="tabular-nums">{formatAmount(editable ? receipted : savedReceipted)}</dd>
                </div>
                <div className="flex justify-between gap-2">
                  <dt className="text-slate-600">Non-Receipted Amount</dt>
                  <dd className="tabular-nums">{formatAmount(editable ? nonReceipted : savedNonReceipted)}</dd>
                </div>
                <div className="flex justify-between gap-2 border-t border-slate-200 pt-2">
                  <dt className="font-semibold text-slate-900">Total Settlement</dt>
                  <dd className="text-lg font-bold tabular-nums text-[var(--portal-navy)]">
                    {formatAmount(editable ? total : settlementOptionTotal('option2', savedReceipted, savedNonReceipted))}
                  </dd>
                </div>
              </dl>
              <div className="mt-2">
                <MatchState
                  matches={editable ? matches : sameAmount(settlementOptionTotal('option2', savedReceipted, savedNonReceipted), advance)}
                  total={editable ? total : settlementOptionTotal('option2', savedReceipted, savedNonReceipted)}
                  advance={advance}
                />
              </div>
            </div>
          </div>
          <p className="mt-3 flex items-center gap-1.5 rounded-lg border border-sky-200 bg-sky-50 px-3 py-2 text-xs text-sky-900">
            <Info className="h-3.5 w-3.5 shrink-0" /> This option will require approval again and will go to First Line Manager, then FAD.
          </p>
        </section>
      )}

      {editable ? (
        <div className="flex flex-wrap items-center justify-end gap-3">
          {problem ? (
            <p className="mr-auto flex items-center gap-1.5 text-xs font-medium text-amber-800" role="status">
              <AlertTriangle className="h-3.5 w-3.5 shrink-0" /> {problem}
            </p>
          ) : dirty ? (
            <p className="mr-auto text-xs text-slate-600">Save the expense entry before Submit for Processing.</p>
          ) : (
            <p className="mr-auto flex items-center gap-1.5 text-xs font-medium text-emerald-700">
              <CheckCircle2 className="h-3.5 w-3.5" /> Saved in Business Central.
            </p>
          )}
          <Button type="button" className="text-sm!" disabled={Boolean(problem) || !dirty || save.isPending} onClick={() => save.mutate()}>
            {save.isPending ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Save className="mr-2 h-4 w-4" />}
            {save.isPending ? 'Saving…' : 'Save expense entry'}
          </Button>
        </div>
      ) : null}
    </div>
  )
}

function MatchState({ matches, total, advance }: { matches: boolean; total: number; advance: number }) {
  if (matches) {
    return (
      <p className="flex items-center gap-1.5 rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-xs font-semibold text-emerald-800">
        <CheckCircle2 className="h-4 w-4" /> Matches Advance Amount (Fully Settled)
      </p>
    )
  }
  if (total < advance) {
    return (
      <p className="flex items-center gap-1.5 rounded-lg border border-amber-200 bg-amber-50 px-3 py-1.5 text-xs font-semibold text-amber-900" role="status">
        <AlertTriangle className="h-4 w-4" />
        {formatAmount(advance - total)} less than advance — Refund Due to Organization (Section 3)
      </p>
    )
  }
  return (
    <p className="flex items-center gap-1.5 rounded-lg border border-sky-200 bg-sky-50 px-3 py-1.5 text-xs font-semibold text-sky-900" role="status">
      <Info className="h-4 w-4" />
      {formatAmount(total - advance)} more than advance — Claim Due to Staff (Section 3)
    </p>
  )
}

function ReadOnlyValue({ children }: { children: ReactNode }) {
  return <p className="rounded-md border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-semibold tabular-nums text-slate-900">{children}</p>
}
