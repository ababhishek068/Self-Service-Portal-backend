/** Issued imprest amount on a surrender line (portal-mapped or raw OData). */
export function imprestSurrenderLineAmount(line: Record<string, unknown>): number {
  const raw = line.amount ?? line.Amount
  const value = Number(raw ?? 0)
  return Number.isFinite(value) ? value : 0
}

export function imprestSurrenderLineNo(line: Record<string, unknown>, index = 0): number {
  const keys = [
    'lineNo',
    'LineNo',
    'Line_No',
    'EntryNo',
    'Entry_No',
    'Entry No',
    'Entry_No_',
    'id',
  ]
  for (const key of keys) {
    const raw = line[key]
    if (raw === undefined || raw === null || String(raw).trim() === '') continue
    const value = Number(raw)
    if (Number.isFinite(value) && value > 0) return value
  }
  return (index + 1) * 10000
}

export function imprestSurrenderAccountNo(line: Record<string, unknown>): string {
  return String(
    line.accountNo ??
      line.AccountNo ??
      line.Account_No ??
      line['Account No:'] ??
      line['Account No'] ??
      '',
  ).trim()
}

export function filterImprestSurrenderSettlementLines(lines: Record<string, unknown>[]) {
  return lines.filter((line) => imprestSurrenderLineAmount(line) > 0)
}

/**
 * Merge portal line edits with every BC line on the document.
 * - Zero-amount lines (e.g. TRANSPORTATION-EX with ETB 0) are always cleared.
 * - Actual spent entered on a zero line is moved to the main settlement line.
 */
export function prepareImprestSurrenderLinesForSave(
  existingLines: Record<string, unknown>[],
  incomingLines: Record<string, unknown>[],
): Record<string, unknown>[] {
  const incomingByLineNo = new Map<number, Record<string, unknown>>()
  const incomingByAccount = new Map<string, Record<string, unknown>>()
  for (const line of incomingLines) {
    incomingByLineNo.set(imprestSurrenderLineNo(line), line)
    const accountNo = imprestSurrenderAccountNo(line)
    if (accountNo) incomingByAccount.set(accountNo, line)
  }

  let misplacedSpent = 0
  let misplacedReceiptNo = ''
  let misplacedReceiptAmount = 0
  const settlementIncomingSpent = incomingLines
    .filter((line) => imprestSurrenderLineAmount(line) > 0)
    .reduce((sum, line) => sum + Number(line.actualSpent ?? line.ActualSpent ?? 0), 0)

  if (settlementIncomingSpent === 0) {
    for (const line of incomingLines) {
      const amount = imprestSurrenderLineAmount(line)
      const spent = Number(line.actualSpent ?? line.ActualSpent ?? 0)
      if (amount <= 0 && spent > 0) {
        misplacedSpent += spent
        const receiptNo = String(line.cashReceiptNo ?? line['Cash Receipt No'] ?? '').trim()
        if (receiptNo) misplacedReceiptNo = receiptNo
        misplacedReceiptAmount += Number(line.cashReceiptAmount ?? line['Cash Receipt Amount'] ?? 0)
      }
    }
  }

  const resolveIncoming = (
    lineNo: number,
    accountNo: string,
  ): Record<string, unknown> | undefined =>
    incomingByLineNo.get(lineNo) ?? (accountNo ? incomingByAccount.get(accountNo) : undefined)

  const prepared = existingLines.map((existing, index) => {
    const lineNo = imprestSurrenderLineNo(existing, index)
    const accountNo = imprestSurrenderAccountNo(existing)
    const incoming = resolveIncoming(lineNo, accountNo)
    const amount = imprestSurrenderLineAmount(existing)

    if (amount <= 0) {
      return {
        lineNo,
        accountNo,
        amount,
        actualSpent: 0,
        cashReceiptNo: '',
        cashReceiptAmount: 0,
      }
    }

    return {
      lineNo,
      accountNo,
      amount,
      actualSpent: Number(
        incoming?.actualSpent ??
          incoming?.ActualSpent ??
          existing.actualSpent ??
          existing.ActualSpent ??
          existing['Actual Spent'] ??
          0,
      ),
      cashReceiptNo: normalizeImprestSurrenderCashReceiptNo(
        incoming?.cashReceiptNo ??
          incoming?.CashReceiptNo ??
          existing.cashReceiptNo ??
          existing.CashReceiptNo ??
          existing['Cash Receipt No'] ??
          '',
      ),
      cashReceiptAmount: Number(
        incoming?.cashReceiptAmount ??
          incoming?.CashReceiptAmount ??
          existing.cashReceiptAmount ??
          existing.CashReceiptAmount ??
          existing['Cash Receipt Amount'] ??
          0,
      ),
    }
  })

  if (misplacedSpent > 0 && prepared.length > 0) {
    const primary = prepared
      .filter((line) => line.amount > 0)
      .sort((a, b) => b.amount - a.amount)[0]
    if (primary) {
      const currentSpent = Number(primary.actualSpent ?? 0)
      primary.actualSpent = currentSpent > 0 ? currentSpent + misplacedSpent : misplacedSpent
      if (misplacedReceiptNo && !String(primary.cashReceiptNo ?? '').trim()) {
        primary.cashReceiptNo = misplacedReceiptNo
      }
      if (misplacedReceiptAmount > 0) {
        primary.cashReceiptAmount =
          Number(primary.cashReceiptAmount ?? 0) + misplacedReceiptAmount
      }
    }
  }

  return prepared
}

/** Only lines that must be written back to BC (settlement lines). */
export function imprestSurrenderLinesToPersist(
  preparedLines: Record<string, unknown>[],
): Record<string, unknown>[] {
  return preparedLines.filter((line) => Number(line.amount ?? 0) > 0)
}

export function imprestSurrenderLineCashReceiptAmount(line: Record<string, unknown>): number {
  const keys = [
    'cashReceiptAmount',
    'CashReceiptAmount',
    'Cash_Receipt_Amount',
    'Cash Receipt Amount',
  ]
  for (const key of keys) {
    if (key in line && line[key] !== undefined && line[key] !== null) {
      const value = Number(line[key])
      if (Number.isFinite(value)) return value
    }
  }
  return 0
}

export function imprestSurrenderLineOutstanding(line: Record<string, unknown>): number | undefined {
  const keys = [
    'outstandingAmount',
    'OutstandingAmount',
    'Outstanding_Amount',
    'Outstanding Amount',
    'OutstandingAmt',
    'Outstanding_Amt',
    'Balance',
    'Remaining',
    'RemainingAmount',
    'Remaining_Amount',
  ]
  for (const key of keys) {
    if (key in line && line[key] !== undefined && line[key] !== null) {
      const value = Number(line[key])
      if (Number.isFinite(value)) return value
    }
  }
  return undefined
}

export function normalizeImprestSurrenderCashReceiptNo(value: unknown): string {
  const text = String(value ?? '').trim()
  if (!text) return ''
  const dash = text.indexOf(' - ')
  return dash > 0 ? text.slice(0, dash).trim() : text
}

export function imprestSurrenderLiteralActualSpent(line: Record<string, unknown>): number | undefined {
  for (const key of ['actualSpent', 'ActualSpent', 'Actual_Spent', 'Actual Spent']) {
    if (key in line && line[key] !== undefined && line[key] !== null) {
      const value = Number(line[key])
      if (Number.isFinite(value)) return value
    }
  }
  return undefined
}

export function imprestSurrenderLineActualSpent(line: Record<string, unknown>): number {
  const amount = imprestSurrenderLineAmount(line)
  const receipt = imprestSurrenderLineCashReceiptAmount(line)
  const outstanding = imprestSurrenderLineOutstanding(line)
  const literal = imprestSurrenderLiteralActualSpent(line)

  if (amount > 0 && outstanding !== undefined) {
    const inferred = Math.max(0, amount - outstanding - receipt)
    if (literal !== undefined && literal > 0) return literal
    if (inferred > 0 && inferred <= amount) return inferred
    if (literal !== undefined) return literal
    return inferred
  }

  if (literal !== undefined) return literal
  return 0
}

export function odataSupportsSurrenderSpendReadback(line: Record<string, unknown>): boolean {
  const spentKeys = ['actualSpent', 'ActualSpent', 'Actual_Spent', 'Actual Spent']
  if (spentKeys.some((key) => key in line && line[key] !== undefined && line[key] !== null)) {
    return true
  }
  return imprestSurrenderLineOutstanding(line) !== undefined
}

const SURRENDER_SPEND_MERGE_KEYS = [
  'actualSpent',
  'ActualSpent',
  'Actual_Spent',
  'Actual Spent',
  'outstandingAmount',
  'OutstandingAmount',
  'Outstanding_Amount',
  'Outstanding Amount',
  'cashReceiptAmount',
  'CashReceiptAmount',
  'Cash_Receipt_Amount',
  'Cash Receipt Amount',
  'cashReceiptNo',
  'CashReceiptNo',
  'Cash_Receipt_No',
  'Cash Receipt No',
  'EntryNo',
  'Entry_No',
  'Entry No',
]

function surrenderODataFieldPresent(value: unknown) {
  return value !== undefined && value !== null && String(value).trim() !== ''
}

/** Merge BC surrender line OData rows without losing spend fields from the details query. */
export function mergeImprestSurrenderODataRow(
  existing: Record<string, unknown> | undefined,
  row: Record<string, unknown>,
): Record<string, unknown> {
  if (!existing) return { ...row }
  const merged: Record<string, unknown> = { ...existing, ...row }
  for (const key of SURRENDER_SPEND_MERGE_KEYS) {
    if (surrenderODataFieldPresent(row[key])) merged[key] = row[key]
    else if (surrenderODataFieldPresent(existing[key])) merged[key] = existing[key]
  }
  return merged
}

export function imprestSurrenderLinesHaveSpendReadback(lines: Record<string, unknown>[]): boolean {
  return lines.some((line) => imprestSurrenderODataCanVerifySpend(line))
}

export function imprestSurrenderODataCanVerifySpend(line: Record<string, unknown>): boolean {
  if (imprestSurrenderLiteralActualSpent(line) !== undefined) return true
  const amount = imprestSurrenderLineAmount(line)
  return amount > 0 && imprestSurrenderLineOutstanding(line) !== undefined
}

/** Compare portal save to BC using Actual Spent or Outstanding Amount + cash receipt. */
export function imprestSurrenderLinePersistedMatches(
  odataLine: Record<string, unknown>,
  expectedSpent: number,
  expectedReceiptAmount: number,
): boolean {
  const amount = imprestSurrenderLineAmount(odataLine)
  if (amount <= 0) return expectedSpent <= 0

  const literal = imprestSurrenderLiteralActualSpent(odataLine)
  if (literal !== undefined && literal > 0) return literal === expectedSpent

  const outstanding = imprestSurrenderLineOutstanding(odataLine)
  if (outstanding !== undefined) {
    const receiptOnLine = imprestSurrenderLineCashReceiptAmount(odataLine)
    const receipt = receiptOnLine > 0 ? receiptOnLine : expectedReceiptAmount
    const expectedOutstanding = Math.max(0, amount - expectedSpent - receipt)
    if (outstanding === expectedOutstanding) return true
    if (literal === 0 && outstanding < amount) {
      return Math.max(0, amount - outstanding - receipt) === expectedSpent
    }
  }

  return imprestSurrenderLineActualSpent(odataLine) === expectedSpent
}

export function isImprestSurrenderModule(module: string) {
  return module === 'imprest-surrender' || module === 'imprestSurrender'
}
