import { authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export type SettleableAdvance = {
  advanceNo: string
  purpose: string
  requestPurposeText: string
  amount: number
  date: string
  fullyPaid: boolean
  posted: boolean
}

export type AdvanceSettlementContext = {
  employeeNo: string
  settleableAdvances: SettleableAdvance[]
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
  lines: Array<Record<string, unknown>>
}

export async function fetchAdvanceSettlementContext(surrenderNo = '', employeeNo = '') {
  requireAuthApiUrl()
  const params = new URLSearchParams()
  if (surrenderNo) params.set('surrenderNo', surrenderNo)
  if (employeeNo) params.set('employeeNo', employeeNo)
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
}) {
  requireAuthApiUrl()
  return authPost<AdvanceSettlementContext>('/api/advance-settlement/save', payload)
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
