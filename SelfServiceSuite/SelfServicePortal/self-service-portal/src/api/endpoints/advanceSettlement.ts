import { authDelete, authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import type { AdvanceOutstanding } from '@/api/endpoints/advanceOutstanding'

export type SettleableAdvance = {
  advanceNo: string
  purpose: string
  requestPurposeText: string
  amount: number
  date: string
  fullyPaid: boolean
  posted: boolean
}

/**
 * BC 1.0.3.653: a paid advance whose receipt the requester has not confirmed in ESSP yet. BC 1.0.3.662: any approved
 * one; `paid` is false until Finance's payment is in BC.
 */
export type AwaitingReceiptAdvance = {
  advanceNo: string
  purpose: string
  amount: number
  datePosted: string
  paid?: boolean
}

/** Client Pending issues (20 Nov 2026): Option 1 Full Settlement with Receipt, Option 2 Partial (with and without receipt). */
export type SettlementOption = 'option1' | 'option2'

/** Client specification (26 Nov 2026): Pay Now vs Pay Later (Pending Refund) under ETB 5,000 */
export type RefundSettlementOption = 'payNow' | 'payLater'

export type AdvanceSettlementContext = {
  employeeNo: string
  settleableAdvances: SettleableAdvance[]
  /** BC 1.0.3.667: advances not settled with their settle-by dates (the backend parses it); null on older BC. */
  outstanding?: AdvanceOutstanding | null
  /** BC 1.0.3.653: settlement only after the requester confirmed receipt (false on older BC). */
  supportsReceiptConfirmation?: boolean
  /** BC 1.0.3.662: receipt can be confirmed right after approval, before Finance's payment is in BC. */
  receiptAfterApproval?: boolean
  /** BC 1.0.3.663: expense entries can be changed and removed, with a receipt / reference no. */
  supportsExpenseEntries?: boolean
  /** BC 1.0.3.669: Option 1 (full with receipt) / Option 2 (with and without receipt) settlement. */
  supportsSettlementOptions?: boolean
  awaitingReceipt?: AwaitingReceiptAdvance[]
  surrenderNo: string
  status: string
  advanceNo: string
  totalAdvanceReceived: number
  totalActualExpenses: number
  settlementBalance: number
  settlementOutcome: 'fullySettled' | 'refundDue' | 'additionalClaim' | ''
  settlementOutcomeCaption: string
  refundAmount: number
  refundDate: string
  refundPaymentReference: string
  additionalClaimAmount: number
  additionalClaimJustification: string
  declarationConfirmed: boolean
  /** BC 1.0.3.669 */
  settlementOption?: SettlementOption
  receiptedAmount?: number
  nonReceiptedAmount?: number
  settlementReceiptNo?: string
  refundSettlementOption?: RefundSettlementOption
  pendingRepaymentAmount?: number
  remarks: string
  purpose: string
  advance?: {
    advanceNo: string
    employeeName: string
    purpose: string
    requestPurposeText: string
    amount: number
    paymentDate: string
  }
  lines: SettlementLine[]
}

/** One expense line of a settlement (PortalAdvanceSettlementContext `lines`; `lineNo` is BC's Entry No). */
export type SettlementLine = {
  lineNo?: number | string
  accountNo?: string
  accountName?: string
  expenseCategory?: string
  expenseDescription?: string
  issuedAmount?: number
  actualSpent?: number
  /** BC 1.0.3.663 */
  referenceNo?: string
  /** BC 1.0.3.663: added by the employee in ESSP (not copied from the advance). */
  esspEntry?: boolean
  [key: string]: unknown
}

export async function fetchAdvanceSettlementContext(surrenderNo = '') {
  requireAuthApiUrl()
  const params = new URLSearchParams()
  if (surrenderNo) params.set('surrenderNo', surrenderNo)
  const query = params.toString() ? `?${params}` : ''
  return authGet<AdvanceSettlementContext>(`/api/advance-settlement/context${query}`)
}

export async function saveAdvanceSettlementDetails(payload: {
  surrenderNo: string
  refundDateText?: string
  refundPaymentReference?: string
  additionalClaimJustification?: string
  declarationConfirmed: boolean
  settlementRemarks?: string
  refundSettlementOption?: RefundSettlementOption
  pendingRepaymentAmount?: number
}) {
  requireAuthApiUrl()
  return authPost<AdvanceSettlementContext>('/api/advance-settlement/save', payload)
}

/** BC 1.0.3.669: save the settlement option, its amounts (total = the advance) and the receipt / reference no. */
export async function saveAdvanceSettlementOption(payload: {
  surrenderNo: string
  settlementOption: SettlementOption
  receiptedAmount: number
  nonReceiptedAmount: number
  receiptNo: string
}) {
  requireAuthApiUrl()
  return authPost<AdvanceSettlementContext>('/api/advance-settlement/option', payload)
}

export async function addAdvanceSettlementExpense(payload: {
  surrenderNo: string
  expenseCategory: string
  expenseDescription: string
  expenseAmount: number
}) {
  requireAuthApiUrl()
  return authPost<{ lineNo: number; surrenderNo: string }>('/api/advance-settlement/expenses', payload)
}

/** BC 1.0.3.663: create (entryNo 0) or change an expense entry, with its receipt / reference no. */
export async function saveAdvanceSettlementExpense(payload: {
  surrenderNo: string
  entryNo: number
  expenseCategory: string
  expenseDescription: string
  expenseAmount: number
  referenceNo: string
}) {
  requireAuthApiUrl()
  return authPost<{ lineNo: number; entryNo: number; surrenderNo: string }>('/api/advance-settlement/expenses', payload)
}

/** BC 1.0.3.663: remove an expense entry the employee added. */
export async function deleteAdvanceSettlementExpense(surrenderNo: string, entryNo: number) {
  requireAuthApiUrl()
  return authDelete<{ ok: boolean }>(
    `/api/advance-settlement/expenses/${encodeURIComponent(String(entryNo))}?surrenderNo=${encodeURIComponent(surrenderNo)}`,
  )
}

/** BC 1.0.3.653: confirm receipt of the paid advance (`advanceNo` = IMP-…); settlement opens after it. */
export async function confirmAdvanceReceipt(advanceNo: string, remarks = '') {
  requireAuthApiUrl()
  return authPost<{ advanceNo: string; receiptConfirmed: boolean; receiptConfirmedOn: string; receivedAmount: number }>(
    `/api/advance-payment/${encodeURIComponent(advanceNo)}/confirm-receipt`,
    { remarks },
  )
}
