import { useQuery } from '@tanstack/react-query'
import { fetchAdvanceSettlementContext, type AdvanceSettlementContext } from '@/api/endpoints/advanceSettlement'
import type { PortalRequest } from '@/types/erp.types'

/** Changes whenever an expense line or its actual spend changes, so BC's reconciliation is read again. */
export function settlementLineSignature(request: PortalRequest | null | undefined) {
  const lines = Array.isArray(request?.payload?.lines) ? (request.payload.lines as Record<string, unknown>[]) : []
  const spent = lines.reduce((sum, line) => sum + (Number(line.actualSpent ?? line.ActualSpent ?? 0) || 0), 0)
  return `${lines.length}:${spent}`
}

export const SETTLEMENT_QUERY_ROOT = ['finance', 'advance-settlement'] as const

/** BC's reconciliation for one settlement (PortalAdvanceSettlementContext, BC 1.0.3.636). */
export function useAdvanceSettlementContext(request: PortalRequest | null | undefined) {
  const surrenderNo = String(request?.requestNo ?? '').trim()
  return useQuery({
    queryKey: [...SETTLEMENT_QUERY_ROOT, 'detail', surrenderNo, request?.status ?? '', settlementLineSignature(request)],
    queryFn: () => fetchAdvanceSettlementContext(surrenderNo),
    enabled: Boolean(surrenderNo),
    staleTime: 15_000,
  })
}

/** ESSP spec section 4: the three settlement scenarios, named as ABH names them. */
export const SETTLEMENT_SCENARIOS = {
  fullySettled: { letter: 'A', title: 'Fully Settled', rule: 'Actual expenses = Advance', action: 'No outstanding amount' },
  refundDue: { letter: 'B', title: 'Advance Surrender', rule: 'Actual expenses < Advance', action: 'Return unused balance' },
  additionalClaim: {
    letter: 'C',
    title: 'Additional Reimbursement',
    rule: 'Actual expenses > Advance',
    action: 'Claim additional amount',
  },
} as const

/** The settlement total of the chosen option: the amount with receipt plus, for Option 2, the amount without. */
export function settlementOptionTotal(option: string, receipted: number, nonReceipted: number) {
  return Math.round(((receipted || 0) + (option === 'option2' ? nonReceipted || 0 : 0)) * 100) / 100
}

export function sameAmount(left: number, right: number) {
  return Math.abs((left || 0) - (right || 0)) < 0.005
}

/**
 * What BC's RequestImprestSurrenderApproval still rejects (ABH Advance Settlement Mgt.ValidateForSubmit). With BC
 * 1.0.3.669 settlement options: the saved option, its amounts equal to the advance, the receipt no. and a document.
 */
export function settlementMissing(ctx: AdvanceSettlementContext, documents?: number) {
  const missing: string[] = []
  if (ctx.supportsSettlementOptions) {
    const option = ctx.settlementOption ?? 'option1'
    const receipted = ctx.receiptedAmount ?? 0
    const nonReceipted = ctx.nonReceiptedAmount ?? 0
    if (!(receipted > 0)) missing.push('the saved expense entry of the settlement option')
    else if (option === 'option2' && !(nonReceipted > 0)) missing.push('the expense amount without receipt')
    if (!String(ctx.settlementReceiptNo ?? '').trim()) missing.push('the receipt / reference number')
    if (documents !== undefined && documents < 1) missing.push('the receipt or supporting document')
    if (ctx.settlementOutcome === 'refundDue') {
      if (!ctx.refundDate) missing.push('the repayment date')
      if (!ctx.refundPaymentReference.trim()) missing.push('the payment receipt / reference')
    }
    if (ctx.settlementOutcome === 'additionalClaim' && ctx.additionalClaimJustification.trim().length < 3) {
      missing.push('the justification for exceeding the advance')
    }
    if (!ctx.declarationConfirmed) missing.push('the employee declaration')
    return missing
  }
  if (!(ctx.totalActualExpenses > 0)) missing.push('at least one actual expense amount')
  if (ctx.settlementOutcome === 'refundDue') {
    if (!ctx.refundDate) missing.push('the repayment date')
    if (!ctx.refundPaymentReference.trim()) missing.push('the payment receipt / reference')
  }
  if (ctx.settlementOutcome === 'additionalClaim' && ctx.additionalClaimJustification.trim().length < 3) {
    missing.push('the justification for exceeding the advance')
  }
  if (!ctx.declarationConfirmed) missing.push('the employee declaration')
  return missing
}

/**
 * The open settlement's latest state as the detail panel sees it (BC values plus unsaved edits),
 * so Submit for Processing can stop before BC refuses it.
 */
const panelState = new Map<string, { missing: string[]; dirty: boolean }>()
/** BC 1.0.3.669: the settlement option form has changes not saved to Business Central yet. */
const optionDirty = new Map<string, boolean>()

export function rememberSettlementPanel(surrenderNo: string, state: { missing: string[]; dirty: boolean }) {
  panelState.set(surrenderNo, state)
}

export function rememberSettlementOptionDirty(surrenderNo: string, dirty: boolean) {
  optionDirty.set(surrenderNo, dirty)
}

export function settlementSubmitProblem(surrenderNo: string) {
  if (optionDirty.get(surrenderNo)) return 'Save the expense entry of the settlement option first (Save expense entry), then submit.'
  const state = panelState.get(surrenderNo)
  if (!state) return null
  if (state.dirty) return 'Save the settlement details first (Save settlement details), then submit.'
  if (state.missing.length) return `Business Central still needs ${state.missing.join(', ')}.`
  return null
}
