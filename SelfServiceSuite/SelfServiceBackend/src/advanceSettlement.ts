import { callSoapMethod } from './bcClient.js'
import { parseSoapJson } from './localPurchaseFlow.js'

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
 * one (the requester confirms when the money reaches them); `paid` says whether Finance's payment is in BC.
 */
export type AwaitingReceiptAdvance = {
  advanceNo: string
  purpose: string
  amount: number
  datePosted: string
  paid: boolean
}

export type AdvanceSettlementContext = {
  employeeNo: string
  settleableAdvances: SettleableAdvance[]
  /** BC 1.0.3.653: settlement only after the requester confirmed receipt (false on older BC). */
  supportsReceiptConfirmation: boolean
  /** BC 1.0.3.662: receipt can be confirmed right after approval, before Finance's payment is in BC. */
  receiptAfterApproval: boolean
  awaitingReceipt: AwaitingReceiptAdvance[]
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

function str(value: unknown) {
  return value === undefined || value === null ? '' : String(value).trim()
}

function num(value: unknown) {
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : 0
}

function bool(value: unknown) {
  if (typeof value === 'boolean') return value
  const text = str(value).toLowerCase()
  return text === 'true' || text === '1' || text === 'yes'
}

function outcomeKey(value: unknown): AdvanceSettlementContext['settlementOutcome'] {
  const key = str(value)
  if (key === 'fullySettled' || key === 'refundDue' || key === 'additionalClaim') return key
  return ''
}

export function parseAdvanceSettlementContext(returnValue: unknown): AdvanceSettlementContext {
  const raw = parseSoapJson(returnValue)
  const advances = Array.isArray(raw.settleableAdvances) ? raw.settleableAdvances : []
  const settleableAdvances = advances
    .map((row) => {
      if (!row || typeof row !== 'object') return null
      const record = row as Record<string, unknown>
      const advanceNo = str(record.advanceNo ?? record.AdvanceNo)
      if (!advanceNo) return null
      return {
        advanceNo,
        purpose: str(record.purpose ?? record.Purpose),
        requestPurposeText: str(record.requestPurposeText ?? record.RequestPurposeText),
        amount: num(record.amount ?? record.Amount),
        date: str(record.date ?? record.Date ?? record.paymentDate),
        fullyPaid: bool(record.fullyPaid ?? record.FullyPaid),
        posted: bool(record.posted ?? record.Posted),
      }
    })
    .filter(Boolean) as SettleableAdvance[]

  const advanceRaw =
    raw.advance && typeof raw.advance === 'object' ? (raw.advance as Record<string, unknown>) : null

  const awaiting = Array.isArray(raw.awaitingReceipt) ? raw.awaitingReceipt : []
  const awaitingReceipt = awaiting
    .filter((row): row is Record<string, unknown> => Boolean(row) && typeof row === 'object')
    .map((record) => ({
      advanceNo: str(record.advanceNo),
      purpose: str(record.purpose),
      amount: num(record.amount),
      datePosted: str(record.datePosted),
      // Before BC 662 only paid advances were listed.
      paid: record.paid === undefined ? true : bool(record.paid),
    }))
    .filter((row) => row.advanceNo)

  return {
    employeeNo: str(raw.employeeNo),
    settleableAdvances,
    supportsReceiptConfirmation: bool(raw.supportsReceiptConfirmation),
    receiptAfterApproval: bool(raw.receiptAfterApproval),
    awaitingReceipt,
    surrenderNo: str(raw.surrenderNo),
    status: str(raw.status),
    advanceNo: str(raw.advanceNo),
    totalAdvanceReceived: num(raw.totalAdvanceReceived),
    totalActualExpenses: num(raw.totalActualExpenses),
    settlementBalance: num(raw.settlementBalance),
    settlementOutcome: outcomeKey(raw.settlementOutcome),
    settlementOutcomeCaption: str(raw.settlementOutcomeCaption),
    refundAmount: num(raw.refundAmount),
    refundDate: str(raw.refundDate),
    refundPaymentReference: str(raw.refundPaymentReference),
    additionalClaimAmount: num(raw.additionalClaimAmount),
    additionalClaimJustification: str(raw.additionalClaimJustification),
    declarationConfirmed: bool(raw.declarationConfirmed),
    remarks: str(raw.remarks),
    purpose: str(raw.purpose),
    advance: advanceRaw
      ? {
          advanceNo: str(advanceRaw.advanceNo),
          employeeName: str(advanceRaw.employeeName),
          purpose: str(advanceRaw.purpose),
          requestPurposeText: str(advanceRaw.requestPurposeText),
          amount: num(advanceRaw.amount),
          paymentDate: str(advanceRaw.paymentDate),
        }
      : undefined,
    lines: Array.isArray(raw.lines)
      ? (raw.lines.filter((row) => row && typeof row === 'object') as Array<Record<string, unknown>>)
      : [],
  }
}

export async function getAdvanceSettlementContext(employeeNo: string, surrenderNo = '') {
  const result = await callSoapMethod('PortalAdvanceSettlementContext', {
    employeeNo,
    surrenderNo,
  })
  return parseAdvanceSettlementContext(result.returnValue)
}

export async function saveAdvanceSettlementDetails(input: {
  surrenderNo: string
  refundDateText?: string
  refundPaymentReference?: string
  additionalClaimJustification?: string
  declarationConfirmed: boolean
  settlementRemarks?: string
}) {
  const result = await callSoapMethod('PortalAdvanceSettlementSave', {
    surrenderNo: input.surrenderNo,
    refundDateText: input.refundDateText ?? '',
    refundPaymentReference: input.refundPaymentReference ?? '',
    additionalClaimJustification: input.additionalClaimJustification ?? '',
    declarationConfirmed: input.declarationConfirmed,
    settlementRemarks: input.settlementRemarks ?? '',
  })
  return parseAdvanceSettlementContext(result.returnValue)
}

export async function addAdvanceSettlementExpense(input: {
  surrenderNo: string
  expenseCategory: string
  expenseDescription: string
  expenseAmount: number
}) {
  const result = await callSoapMethod('PortalAdvanceSettlementAddExpense', {
    surrenderNo: input.surrenderNo,
    expenseCategory: input.expenseCategory,
    expenseDescription: input.expenseDescription,
    expenseAmount: input.expenseAmount,
  })
  return Number(result.returnValue ?? 0)
}

/** BC 1.0.3.653: the requester confirms receipt of the paid advance; settlement is allowed only after it. */
export async function confirmAdvanceReceipt(employeeNo: string, advanceNo: string, remarks: string) {
  try {
    const result = await callSoapMethod('PortalAdvanceConfirmReceipt', {
      employeeNo,
      docNo: advanceNo,
      remarks: remarks.trim().slice(0, 250),
    })
    const raw = parseSoapJson(result.returnValue)
    return {
      advanceNo: str(raw.advanceNo) || advanceNo,
      receiptConfirmed: bool(raw.receiptConfirmed),
      receiptConfirmedOn: str(raw.receiptConfirmedOn),
      receivedAmount: num(raw.receivedAmount),
    }
  } catch (error) {
    const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
    if (/Method '?PortalAdvanceConfirmReceipt'? is invalid|PortalAdvanceConfirmReceipt.*(not found|not published)/i.test(message)) {
      throw Object.assign(
        new Error('Confirm Receipt needs Business Central 1.0.3.653. Ask the BC administrator to publish it.'),
        { status: 503 },
      )
    }
    throw error
  }
}
