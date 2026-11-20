import assert from 'node:assert/strict'
import test from 'node:test'
import { parseAdvanceSettlementContext } from './advanceSettlement.js'

test('BC 1.0.3.669 settlement option fields are parsed', () => {
  const ctx = parseAdvanceSettlementContext(
    JSON.stringify({
      supportsSettlementOptions: true,
      surrenderNo: 'IMPS-0001',
      totalAdvanceReceived: 10000,
      settlementOption: 'option2',
      receiptedAmount: 7500,
      nonReceiptedAmount: 2500,
      settlementReceiptNo: 'RCPT-1',
    }),
  )
  assert.equal(ctx.supportsSettlementOptions, true)
  assert.equal(ctx.settlementOption, 'option2')
  assert.equal(ctx.receiptedAmount, 7500)
  assert.equal(ctx.nonReceiptedAmount, 2500)
  assert.equal(ctx.settlementReceiptNo, 'RCPT-1')
})

test('older BC context defaults to Option 1 without option support', () => {
  const ctx = parseAdvanceSettlementContext(JSON.stringify({ surrenderNo: 'IMPS-0002' }))
  assert.equal(ctx.supportsSettlementOptions, false)
  assert.equal(ctx.settlementOption, 'option1')
  assert.equal(ctx.receiptedAmount, 0)
})
