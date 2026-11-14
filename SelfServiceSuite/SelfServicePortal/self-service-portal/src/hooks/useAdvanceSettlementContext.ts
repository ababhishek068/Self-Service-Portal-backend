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

/** What BC's RequestImprestSurrenderApproval still rejects (ABH Advance Settlement Mgt.ValidateForSubmit). */
export function settlementMissing(ctx: AdvanceSettlementContext) {
  const missing: string[] = []
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

export function rememberSettlementPanel(surrenderNo: string, state: { missing: string[]; dirty: boolean }) {
  panelState.set(surrenderNo, state)
}

export function settlementSubmitProblem(surrenderNo: string) {
  const state = panelState.get(surrenderNo)
  if (!state) return null
  if (state.dirty) return 'Save the settlement details first (Save settlement details), then submit.'
  if (state.missing.length) return `Business Central still needs ${state.missing.join(', ')}.`
  return null
}
