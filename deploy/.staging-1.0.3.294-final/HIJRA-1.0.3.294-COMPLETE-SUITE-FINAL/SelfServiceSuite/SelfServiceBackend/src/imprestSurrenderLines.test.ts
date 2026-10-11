import assert from 'node:assert/strict'
import test from 'node:test'
import {
  prepareImprestSurrenderLinesForSave,
  imprestSurrenderLinesToPersist,
  isImprestSurrenderModule,
  imprestSurrenderLineActualSpent,
  normalizeImprestSurrenderCashReceiptNo,
  mergeImprestSurrenderODataRow,
  imprestSurrenderLinesHaveSpendReadback,
  imprestSurrenderLinePersistedMatches,
  imprestSurrenderLiteralActualSpent,
} from './imprestSurrenderLines.js'

test('derives actual spent from BC outstanding when Actual Spent is not on OData', () => {
  const line = { Amount: 12000, OutstandingAmount: 8000 }
  assert.equal(imprestSurrenderLineActualSpent(line), 4000)
})

test('normalizeImprestSurrenderCashReceiptNo strips receipt label', () => {
  assert.equal(normalizeImprestSurrenderCashReceiptNo('A00080 - SEADA IBR'), 'A00080')
})

test('isImprestSurrenderModule matches internal and portal module keys', () => {
  assert.equal(isImprestSurrenderModule('imprest-surrender'), true)
  assert.equal(isImprestSurrenderModule('imprestSurrender'), true)
  assert.equal(isImprestSurrenderModule('imprest'), false)
})

test('prepareImprestSurrenderLinesForSave clears zero-amount lines', () => {
  const existing = [
    { lineNo: 10000, AccountNo: '520330', Amount: 0, 'Actual Spent': 200 },
    { lineNo: 20000, AccountNo: '520331', Amount: 12000, 'Actual Spent': 0 },
  ]
  const incoming = [
    { lineNo: 10000, accountNo: '520330', amount: 0, actualSpent: 200 },
    { lineNo: 20000, accountNo: '520331', amount: 12000, actualSpent: 8000 },
  ]
  const saved = prepareImprestSurrenderLinesForSave(existing, incoming)
  assert.equal(saved.find((l) => l.lineNo === 10000)?.actualSpent, 0)
  assert.equal(saved.find((l) => l.lineNo === 20000)?.actualSpent, 8000)
})

test('prepareImprestSurrenderLinesForSave keeps spend on each account when lineNo collides', () => {
  const existing = [
    { lineNo: 10000, AccountNo: '520330', Amount: 500 },
    { lineNo: 10000, AccountNo: '520331', Amount: 16800 },
  ]
  const incoming = [
    { lineNo: 10000, accountNo: '520330', amount: 500, actualSpent: 200 },
    { lineNo: 10000, accountNo: '520331', amount: 16800, actualSpent: 10800 },
  ]
  const saved = prepareImprestSurrenderLinesForSave(existing, incoming)
  assert.equal(saved.find((line) => line.accountNo === '520330')?.actualSpent, 200)
  assert.equal(saved.find((line) => line.accountNo === '520331')?.actualSpent, 10800)
})

test('prepareImprestSurrenderLinesForSave matches incoming by account when lineNo differs', () => {
  const existing = [
    { EntryNo: 1, AccountNo: '520330', Amount: 0 },
    { EntryNo: 2, AccountNo: '520331', Amount: 12000 },
  ]
  const incoming = [{ lineNo: 20000, accountNo: '520331', amount: 12000, actualSpent: 8000 }]
  const saved = prepareImprestSurrenderLinesForSave(existing, incoming)
  assert.equal(saved.find((line) => line.accountNo === '520331')?.actualSpent, 8000)
})

test('imprestSurrenderLinesToPersist only returns settlement lines', () => {
  const lines = [
    { lineNo: 1, amount: 0, actualSpent: 0 },
    { lineNo: 2, amount: 12000, actualSpent: 8000 },
  ]
  assert.equal(imprestSurrenderLinesToPersist(lines).length, 1)
})

test('prepareImprestSurrenderLinesForSave moves misplaced spent to settlement line', () => {
  const existing = [
    { lineNo: 10000, AccountNo: '520330', Amount: 0 },
    { lineNo: 20000, AccountNo: '520331', Amount: 12000 },
  ]
  const incoming = [{ lineNo: 10000, accountNo: '520330', amount: 0, actualSpent: 8000 }]
  const saved = prepareImprestSurrenderLinesForSave(existing, incoming)
  assert.equal(saved.find((l) => l.lineNo === 10000)?.actualSpent, 0)
  assert.equal(saved.find((l) => l.lineNo === 20000)?.actualSpent, 8000)
})

test('mergeImprestSurrenderODataRow keeps Actual Spent from details query', () => {
  const base = { AccountNo: '520331', Amount: 12000 }
  const details = { AccountNo: '520331', ActualSpent: 1000, OutstandingAmount: 11000 }
  const merged = mergeImprestSurrenderODataRow(base, details)
  assert.equal(merged.ActualSpent, 1000)
  assert.equal(merged.OutstandingAmount, 11000)
  assert.equal(merged.Amount, 12000)
})

test('imprestSurrenderLinesHaveSpendReadback detects spend fields', () => {
  assert.equal(imprestSurrenderLinesHaveSpendReadback([{ Amount: 12000 }]), false)
  assert.equal(
    imprestSurrenderLinesHaveSpendReadback([{ Amount: 12000, ActualSpent: 1000 }]),
    true,
  )
  assert.equal(
    imprestSurrenderLinesHaveSpendReadback([{ Amount: 12000, OutstandingAmount: 10000 }]),
    true,
  )
})

test('imprestSurrenderLineActualSpent infers from outstanding when OData ActualSpent is 0', () => {
  const line = { Amount: 12000, ActualSpent: 0, OutstandingAmount: 11000 }
  assert.equal(imprestSurrenderLineActualSpent(line), 1000)
})

test('imprestSurrenderLinePersistedMatches via Outstanding and receipt', () => {
  const line = { Amount: 12000, OutstandingAmount: 10000, CashReceiptAmount: 1000 }
  assert.equal(imprestSurrenderLinePersistedMatches(line, 1000, 1000), true)
})
