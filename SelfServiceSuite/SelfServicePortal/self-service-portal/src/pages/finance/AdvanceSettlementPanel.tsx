import { useState, type FormEvent } from 'react'
import { AlertTriangle, CheckCircle2, Loader2, Save } from 'lucide-react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import {
  fetchAdvanceSettlementContext,
  saveAdvanceSettlementDetails,
  type AdvanceSettlementContext,
} from '@/api/endpoints/advanceSettlement'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { cn } from '@/lib/utils'
import { formatAmount, formatDate } from '@/utils/formatters'
import type { PortalRequest } from '@/types/erp.types'

const OUTCOME_LABEL: Record<string, { text: string; tone: string }> = {
  fullySettled: { text: 'Fully Settled', tone: 'bg-emerald-100 text-emerald-800' },
  refundDue: { text: 'Refund due to organization', tone: 'bg-orange-100 text-orange-800' },
  additionalClaim: { text: 'Additional Reimbursement Claim', tone: 'bg-amber-100 text-amber-900' },
}

/** What BC's RequestImprestSurrenderApproval will still reject (ABH Advance Settlement Mgt.ValidateForSubmit). */
function missingForSubmit(ctx: AdvanceSettlementContext) {
  const missing: string[] = []
  if (!(ctx.totalActualExpenses > 0)) missing.push('at least one actual expense amount')
  if (!ctx.declarationConfirmed) missing.push('the employee declaration')
  if (ctx.settlementOutcome === 'refundDue') {
    if (!ctx.refundDate) missing.push('the refund / repayment date')
    if (!ctx.refundPaymentReference.trim()) missing.push('the refund payment reference')
  }
  if (ctx.settlementOutcome === 'additionalClaim' && ctx.additionalClaimJustification.trim().length < 3) {
    missing.push('the justification for exceeding the advance')
  }
  return missing
}

function lineSignature(request: PortalRequest) {
  const lines = Array.isArray(request.payload?.lines) ? (request.payload.lines as Record<string, unknown>[]) : []
  const spent = lines.reduce((sum, line) => sum + (Number(line.actualSpent ?? line.ActualSpent ?? 0) || 0), 0)
  return `${lines.length}:${spent}`
}

/**
 * Advance Settlement detail: BC's reconciliation (PortalAdvanceSettlementContext) and, on a draft,
 * the refund / additional-claim / declaration fields BC requires before Request Approval
 * (PortalAdvanceSettlementSave).
 */
export function AdvanceSettlementPanel({ request }: { request: PortalRequest }) {
  const surrenderNo = String(request.requestNo ?? '').trim()
  const isDraft = request.status === 'Draft'
  const contextQuery = useQuery({
    queryKey: ['finance', 'advance-settlement', 'detail', surrenderNo, request.status, lineSignature(request)],
    queryFn: () => fetchAdvanceSettlementContext(surrenderNo),
    enabled: Boolean(surrenderNo),
    staleTime: 15_000,
  })

  if (!surrenderNo) return null
  if (contextQuery.isLoading) {
    return (
      <div className="flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-600">
        <Loader2 className="h-4 w-4 animate-spin" />
        Loading settlement reconciliation from Business Central…
      </div>
    )
  }
  if (contextQuery.isError || !contextQuery.data?.surrenderNo) {
    return (
      <div className="rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
        {contextQuery.error instanceof Error
          ? contextQuery.error.message
          : 'Business Central did not return the settlement reconciliation (needs BC 1.0.3.636).'}
      </div>
    )
  }
  return <SettlementSummary key={`${surrenderNo}:${request.status}`} ctx={contextQuery.data} editable={isDraft} />
}

function SettlementSummary({ ctx, editable }: { ctx: AdvanceSettlementContext; editable: boolean }) {
  const toast = useToast()
  const queryClient = useQueryClient()
  const [refundDate, setRefundDate] = useState(ctx.refundDate)
  const [refundReference, setRefundReference] = useState(ctx.refundPaymentReference)
  const [justification, setJustification] = useState(ctx.additionalClaimJustification)
  const [declared, setDeclared] = useState(ctx.declarationConfirmed)
  const outcome = OUTCOME_LABEL[ctx.settlementOutcome]
  const missing = missingForSubmit(ctx)

  const save = useMutation({
    mutationFn: () =>
      saveAdvanceSettlementDetails({
        surrenderNo: ctx.surrenderNo,
        refundDateText: ctx.settlementOutcome === 'refundDue' ? refundDate : '',
        refundPaymentReference: ctx.settlementOutcome === 'refundDue' ? refundReference.trim() : '',
        additionalClaimJustification: ctx.settlementOutcome === 'additionalClaim' ? justification.trim() : '',
        declarationConfirmed: declared,
        // Blank keeps BC's remarks (PortalAdvanceSettlementSave only overwrites non-blank remarks).
        settlementRemarks: '',
      }),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['finance', 'advance-settlement', 'detail', ctx.surrenderNo] })
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
    <section className="rounded-xl border border-slate-200 bg-white px-4 py-4 sm:px-5">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <h3 className="text-base font-semibold text-slate-900">Financial Reconciliation</h3>
        {outcome ? (
          <span className={cn('inline-flex rounded-full px-2.5 py-1 text-xs font-semibold', outcome.tone)}>{outcome.text}</span>
        ) : null}
      </div>
      <p className="mt-0.5 text-xs text-slate-500">
        Calculated by Business Central for advance {ctx.advanceNo || ctx.advance?.advanceNo || '—'}.
      </p>
      <dl className="mt-3 grid gap-2 text-sm sm:grid-cols-3">
        <div className="rounded-lg bg-slate-50 px-3 py-2">
          <dt className="text-xs text-slate-500">Total advance received</dt>
          <dd className="font-semibold text-slate-900">{formatAmount(ctx.totalAdvanceReceived)}</dd>
        </div>
        <div className="rounded-lg bg-slate-50 px-3 py-2">
          <dt className="text-xs text-slate-500">Total actual expenses</dt>
          <dd className="font-semibold text-slate-900">{formatAmount(ctx.totalActualExpenses)}</dd>
        </div>
        <div className="rounded-lg bg-slate-50 px-3 py-2">
          <dt className="text-xs text-slate-500">
            {ctx.settlementOutcome === 'refundDue'
              ? 'Amount to refund'
              : ctx.settlementOutcome === 'additionalClaim'
                ? 'Additional amount claimed'
                : 'Settlement balance'}
          </dt>
          <dd className="font-semibold text-slate-900">
            {formatAmount(
              ctx.settlementOutcome === 'refundDue'
                ? ctx.refundAmount
                : ctx.settlementOutcome === 'additionalClaim'
                  ? ctx.additionalClaimAmount
                  : Math.abs(ctx.settlementBalance),
            )}
          </dd>
        </div>
      </dl>

      {!editable ? (
        <dl className="mt-3 grid gap-2 text-sm sm:grid-cols-2">
          {ctx.settlementOutcome === 'refundDue' ? (
            <>
              <div>
                <dt className="text-xs text-slate-500">Refund date</dt>
                <dd className="text-slate-900">{ctx.refundDate ? formatDate(ctx.refundDate) : '—'}</dd>
              </div>
              <div>
                <dt className="text-xs text-slate-500">Refund payment reference</dt>
                <dd className="text-slate-900">{ctx.refundPaymentReference || '—'}</dd>
              </div>
            </>
          ) : null}
          {ctx.settlementOutcome === 'additionalClaim' ? (
            <div className="sm:col-span-2">
              <dt className="text-xs text-slate-500">Justification for exceeding the advance</dt>
              <dd className="whitespace-pre-wrap text-slate-900">{ctx.additionalClaimJustification || '—'}</dd>
            </div>
          ) : null}
          <div>
            <dt className="text-xs text-slate-500">Employee declaration</dt>
            <dd className="text-slate-900">{ctx.declarationConfirmed ? 'Confirmed' : 'Not confirmed'}</dd>
          </div>
        </dl>
      ) : (
        <form className="mt-4 space-y-3" onSubmit={onSubmit}>
          {missing.length ? (
            <div className="flex items-start gap-2 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-900">
              <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
              <span>Before Request Approval, Business Central needs {missing.join(', ')}.</span>
            </div>
          ) : (
            <div className="flex items-center gap-2 rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
              <CheckCircle2 className="h-4 w-4" />
              Settlement is complete. You can request approval.
            </div>
          )}
          {ctx.settlementOutcome === 'refundDue' ? (
            <div className="grid gap-3 sm:grid-cols-2">
              <div className="space-y-1.5">
                <Label htmlFor="asp-refund-date">Repayment date *</Label>
                <Input id="asp-refund-date" type="date" value={refundDate} onChange={(event) => setRefundDate(event.target.value)} />
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="asp-refund-ref">Refund payment reference *</Label>
                <Input
                  id="asp-refund-ref"
                  value={refundReference}
                  maxLength={100}
                  placeholder="Receipt / reference no."
                  onChange={(event) => setRefundReference(event.target.value)}
                />
              </div>
              <p className="text-xs text-slate-500 sm:col-span-2">Attach the refund receipt below under Attachments.</p>
            </div>
          ) : null}
          {ctx.settlementOutcome === 'additionalClaim' ? (
            <div className="space-y-1.5">
              <Label htmlFor="asp-claim">Justification for exceeding the advance *</Label>
              <Textarea
                id="asp-claim"
                rows={3}
                maxLength={250}
                value={justification}
                onChange={(event) => setJustification(event.target.value)}
              />
            </div>
          ) : null}
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
      )}
    </section>
  )
}
