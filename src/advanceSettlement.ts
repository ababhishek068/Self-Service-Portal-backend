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

  return {
    employeeNo: str(raw.employeeNo),
    settleableAdvances,
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
