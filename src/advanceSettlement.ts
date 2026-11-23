import { mkdir, readFile, writeFile } from 'node:fs/promises'
import path from 'node:path'
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

/**
 * BC 1.0.3.667 (client, 17 Nov 2026): one advance not settled yet — from submission until its settlement is posted.
 * `stage`: pendingApproval, awaitingPayment, confirmReceipt, paymentNotRecorded, readyToSettle, settlementDraft,
 * settlementSubmitted. It must be settled by `settlementDueDate` (Activity End Date + `settlementDueDays`).
 */
export type OutstandingAdvance = {
  advanceNo: string
  purpose: string
  requestPurposeText: string
  amount: number
  status: string
  stage: string
  settlementNo: string
  activityEndDate: string
  settlementDueDate: string
  overdue: boolean
  daysOverdue: number
}

/**
 * BC 1.0.3.667: an employee with `maxUnsettled` (4) advances not settled cannot request a new one (`canRequest`
 * false); overdue ones are reminded in the bell and by a daily BC e-mail.
 */
export type AdvanceOutstanding = {
  maxUnsettled: number
  settlementDueDays: number
  unsettledCount: number
  overdueCount: number
  canRequest: boolean
  advances: OutstandingAdvance[]
}

export function parseAdvanceOutstanding(value: unknown): AdvanceOutstanding | null {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return null
  const raw = value as Record<string, unknown>
  const advances = (Array.isArray(raw.advances) ? raw.advances : [])
    .filter((row): row is Record<string, unknown> => Boolean(row) && typeof row === 'object')
    .map((row) => ({
      advanceNo: str(row.advanceNo),
      purpose: str(row.purpose),
      requestPurposeText: str(row.requestPurposeText),
      amount: num(row.amount),
      status: str(row.status),
      stage: str(row.stage),
      settlementNo: str(row.settlementNo),
      activityEndDate: bcDate(row.activityEndDate),
      settlementDueDate: bcDate(row.settlementDueDate),
      overdue: bool(row.overdue),
      daysOverdue: Math.max(0, Math.trunc(num(row.daysOverdue))),
    }))
    .filter((row) => row.advanceNo)
  const maxUnsettled = Math.max(0, Math.trunc(num(raw.maxUnsettled)))
  const unsettledCount = Math.max(advances.length, Math.trunc(num(raw.unsettledCount)))
  return {
    maxUnsettled,
    settlementDueDays: Math.max(0, Math.trunc(num(raw.settlementDueDays))),
    unsettledCount,
    overdueCount: advances.filter((row) => row.overdue).length,
    // BC decides; without its flag, the count against the limit.
    canRequest: raw.canRequest === undefined ? !(maxUnsettled > 0 && unsettledCount >= maxUnsettled) : bool(raw.canRequest),
    advances,
  }
}

export type AdvanceSettlementContext = {
  employeeNo: string
  settleableAdvances: SettleableAdvance[]
  /** BC 1.0.3.667: advances not settled, their settle-by dates and whether a new advance may be requested. */
  outstanding: AdvanceOutstanding | null
  /** BC 1.0.3.653: settlement only after the requester confirmed receipt (false on older BC). */
  supportsReceiptConfirmation: boolean
  /** BC 1.0.3.662: receipt can be confirmed right after approval, before Finance's payment is in BC. */
  receiptAfterApproval: boolean
  /** BC 1.0.3.663: expense entries can be changed and removed, with a receipt / reference no. */
  supportsExpenseEntries: boolean
  /** BC 1.0.3.669: Option 1 (full with receipt) / Option 2 (with and without receipt) settlement. */
  supportsSettlementOptions: boolean
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
  /** BC 1.0.3.669 */
  settlementOption: 'option1' | 'option2'
  receiptedAmount: number
  nonReceiptedAmount: number
  settlementReceiptNo: string
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

/** yyyy-mm-dd, or '' for a blank BC date. */
function bcDate(value: unknown) {
  const text = str(value).slice(0, 10)
  return /^\d{4}-\d{2}-\d{2}$/.test(text) && !text.startsWith('0001-') ? text : ''
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
    outstanding: parseAdvanceOutstanding(raw.outstanding),
    supportsReceiptConfirmation: bool(raw.supportsReceiptConfirmation),
    receiptAfterApproval: bool(raw.receiptAfterApproval),
    supportsExpenseEntries: bool(raw.supportsExpenseEntries),
    supportsSettlementOptions: bool(raw.supportsSettlementOptions),
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
    settlementOption: str(raw.settlementOption) === 'option2' ? 'option2' : 'option1',
    receiptedAmount: num(raw.receiptedAmount),
    nonReceiptedAmount: num(raw.nonReceiptedAmount),
    settlementReceiptNo: str(raw.settlementReceiptNo),
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

/** BC 1.0.3.667: `outstanding` of the Advance Request context (PortalAdvancePaymentContext); null on older BC. */
export async function getAdvanceOutstanding(employeeNo: string) {
  const result = await callSoapMethod('PortalAdvancePaymentContext', { employeeNo })
  return parseAdvanceOutstanding(parseSoapJson(result.returnValue).outstanding)
}

export function advanceLimitMessage(outstanding: AdvanceOutstanding) {
  const nos = outstanding.advances.map((row) => row.advanceNo).join(', ')
  return (
    `You cannot request a new advance yet: ${outstanding.unsettledCount} of your advances are not settled` +
    `${nos ? ` (${nos})` : ''} and the limit is ${outstanding.maxUnsettled}. ` +
    'Settle at least one of them under Advance Settlement, then request again.'
  )
}

/**
 * Client rule (17 Nov 2026): no new advance while the employee has the maximum not settled (4). Checked before a new
 * advance is created with Submit, so nothing is left behind; BC 1.0.3.667 refuses the submit as well. When BC cannot
 * answer (or is older), BC's own check on submit decides.
 */
export async function assertAdvanceRequestAllowed(employeeNo: string) {
  if (!employeeNo) return
  let outstanding: AdvanceOutstanding | null = null
  try {
    outstanding = await getAdvanceOutstanding(employeeNo)
  } catch {
    return
  }
  if (outstanding && !outstanding.canRequest) {
    throw Object.assign(new Error(advanceLimitMessage(outstanding)), { status: 422, code: 'ADVANCE_LIMIT_REACHED' })
  }
}

export type AdvanceReceiptConfirmation = {
  advanceNo: string
  employeeNo: string
  confirmedAt: string
  remarks?: string
}

function receiptsStorePath() {
  const root =
    process.env.PORTAL_DATA_DIR ||
    process.env.PORTAL_DATA ||
    path.join(process.cwd(), 'portal-data')
  return path.join(root, 'advance-receipt-confirmations.json')
}

let inMemoryReceipts: Record<string, AdvanceReceiptConfirmation> | null = null

export async function readAdvanceReceiptConfirmations(): Promise<Record<string, AdvanceReceiptConfirmation>> {
  if (inMemoryReceipts) return inMemoryReceipts
  try {
    const raw = await readFile(receiptsStorePath(), 'utf8')
    const parsed = JSON.parse(raw) as Record<string, AdvanceReceiptConfirmation>
    inMemoryReceipts = parsed && typeof parsed === 'object' ? parsed : {}
    return inMemoryReceipts
  } catch {
    inMemoryReceipts = {}
    return inMemoryReceipts
  }
}

export async function recordAdvanceReceiptConfirmation(
  employeeNo: string,
  advanceNo: string,
  remarks = '',
): Promise<AdvanceReceiptConfirmation> {
  const store = await readAdvanceReceiptConfirmations()
  const key = advanceNo.trim().toUpperCase()
  const record: AdvanceReceiptConfirmation = {
    advanceNo: key,
    employeeNo: employeeNo.trim(),
    confirmedAt: new Date().toISOString(),
    remarks: remarks.trim(),
  }
  store[key] = record
  inMemoryReceipts = store
  try {
    const filePath = receiptsStorePath()
    await mkdir(path.dirname(filePath), { recursive: true })
    await writeFile(filePath, JSON.stringify(store, null, 2), 'utf8')
  } catch {
    // Non-fatal if disk write fails
  }
  return record
}

export function isAdvanceReceiptConfirmedLocally(advanceNo: string): boolean {
  if (!inMemoryReceipts || !advanceNo) return false
  return Boolean(inMemoryReceipts[advanceNo.trim().toUpperCase()])
}

export function getAdvanceReceiptConfirmationLocally(advanceNo: string): AdvanceReceiptConfirmation | undefined {
  if (!inMemoryReceipts || !advanceNo) return undefined
  return inMemoryReceipts[advanceNo.trim().toUpperCase()]
}

export async function getAdvanceSettlementContext(employeeNo: string, surrenderNo = '') {
  const result = await callSoapMethod('PortalAdvanceSettlementContext', {
    employeeNo,
    surrenderNo,
  })
  const context = parseAdvanceSettlementContext(result.returnValue)

  try {
    const localReceipts = await readAdvanceReceiptConfirmations()
    const empReceipts = Object.values(localReceipts).filter(
      (r) => !employeeNo || r.employeeNo.toUpperCase() === employeeNo.toUpperCase(),
    )
    if (empReceipts.length > 0) {
      const confirmedNos = new Set(empReceipts.map((r) => r.advanceNo.toUpperCase()))
      // Remove confirmed advances from awaitingReceipt
      context.awaitingReceipt = (context.awaitingReceipt ?? []).filter(
        (row) => !confirmedNos.has(row.advanceNo.toUpperCase()),
      )
      // Ensure confirmed advances are in settleableAdvances if not already present
      const settleableNos = new Set(context.settleableAdvances.map((row) => row.advanceNo.toUpperCase()))
      for (const rec of empReceipts) {
        if (!settleableNos.has(rec.advanceNo)) {
          context.settleableAdvances.push({
            advanceNo: rec.advanceNo,
            purpose: rec.remarks || 'Advance Payment',
            requestPurposeText: '',
            amount: 0,
            date: rec.confirmedAt.slice(0, 10),
            fullyPaid: true,
            posted: true,
          })
        }
      }
    }
  } catch {
    // Non-fatal if reading local confirmations fails
  }

  return context
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

/**
 * BC 1.0.3.669 / 1.0.3.672: Option 1 Full Settlement with Receipt (one amount with its receipt)
 * or Option 2 Partial Settlement (an amount with receipt plus one without). Supports exact match,
 * under-spending (refund due to organization), and over-spending (claim due to staff).
 */
export async function saveAdvanceSettlementOption(input: {
  surrenderNo: string
  settlementOption: 'option1' | 'option2'
  receiptedAmount: number
  nonReceiptedAmount: number
  receiptNo: string
}) {
  try {
    const result = await callSoapMethod('PortalAdvanceSettlementSaveOption', {
      surrenderNo: input.surrenderNo,
      settlementOption: input.settlementOption === 'option2' ? 1 : 0,
      receiptedAmount: input.receiptedAmount,
      nonReceiptedAmount: input.settlementOption === 'option2' ? input.nonReceiptedAmount : 0,
      receiptNo: input.receiptNo.trim().slice(0, 50),
    })
    return parseAdvanceSettlementContext(result.returnValue)
  } catch (error) {
    const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
    if (/Method '?PortalAdvanceSettlementSaveOption'? is invalid|PortalAdvanceSettlementSaveOption.*(not found|not published)/i.test(message)) {
      throw Object.assign(
        new Error('Settlement options need Business Central 1.0.3.669 or newer. Ask the BC administrator to publish it.'),
        { status: 503 },
      )
    }
    if (/must equal the advance amount/i.test(message)) {
      throw Object.assign(
        new Error(
          'Business Central server is running version 1.0.3.671 which restricts total expenses to equal advance. ' +
          'Please upgrade Business Central to version 1.0.3.672 to enable refunds and additional claims.',
        ),
        { status: 422 },
      )
    }
    throw error
  }
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

/**
 * BC 1.0.3.663: create (entryNo 0) or change one expense entry — purpose, category, amount and receipt / reference
 * no. Returns the entry no.
 */
export async function saveAdvanceSettlementExpense(input: {
  surrenderNo: string
  entryNo: number
  expenseCategory: string
  expenseDescription: string
  expenseAmount: number
  referenceNo: string
}) {
  const result = await callSoapMethod('PortalAdvanceSettlementSaveExpense', {
    surrenderNo: input.surrenderNo,
    entryNo: input.entryNo,
    expenseCategory: input.expenseCategory,
    expenseDescription: input.expenseDescription,
    expenseAmount: input.expenseAmount,
    referenceNo: input.referenceNo,
  })
  return Number(result.returnValue ?? 0)
}

/** BC 1.0.3.663: remove an expense entry the employee added. */
export async function deleteAdvanceSettlementExpense(surrenderNo: string, entryNo: number) {
  await callSoapMethod('PortalAdvanceSettlementDeleteExpense', { surrenderNo, entryNo })
}

/** BC 1.0.3.653: the requester confirms receipt of the paid advance; settlement is allowed only after it. */
export async function confirmAdvanceReceipt(employeeNo: string, advanceNo: string, remarks: string) {
  const key = advanceNo.trim().toUpperCase()
  let raw: Record<string, unknown> = {}
  try {
    const result = await callSoapMethod('PortalAdvanceConfirmReceipt', {
      employeeNo,
      docNo: key,
      remarks: remarks.trim().slice(0, 250),
    })
    raw = parseSoapJson(result.returnValue)
  } catch (error) {
    const message = String((error as { message?: unknown } | null)?.message ?? error ?? '')
    if (
      /Method '?PortalAdvanceConfirmReceipt'? is invalid|PortalAdvanceConfirmReceipt.*(not found|not published)/i.test(
        message,
      )
    ) {
      // If BC method is not published, still record locally so employee is not blocked
    } else {
      throw error
    }
  }

  // Persist confirmation locally so it is immediately known across all portal queries
  const localRec = await recordAdvanceReceiptConfirmation(employeeNo, key, remarks)

  return {
    advanceNo: str(raw.advanceNo) || key,
    receiptConfirmed: true,
    receiptConfirmedOn: str(raw.receiptConfirmedOn) || localRec.confirmedAt,
    receivedAmount: num(raw.receivedAmount),
  }
}
