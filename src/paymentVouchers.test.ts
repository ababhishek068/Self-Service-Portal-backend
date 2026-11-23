import assert from 'node:assert/strict'
import { test } from 'node:test'
import {
  calculateVoucherTotals,
  createOrUpdatePaymentVoucher,
  deletePaymentVoucher,
  generateNextPvNo,
  loadPaymentVouchers,
  numberToWords,
  submitPaymentVoucher,
  approvePaymentVoucher,
  rejectPaymentVoucher,
} from './paymentVouchers.js'

test('numberToWords converts ETB currency amounts accurately', () => {
  assert.equal(numberToWords(0), 'Zero Ethiopian Birr Only')
  assert.equal(numberToWords(100), 'One Hundred Ethiopian Birr Only')
  assert.equal(numberToWords(1540), 'One Thousand Five Hundred Forty Ethiopian Birr Only')
  assert.equal(
    numberToWords(54805),
    'Fifty-Four Thousand Eight Hundred Five Ethiopian Birr Only',
  )
  assert.equal(
    numberToWords(125000.75),
    'One Hundred Twenty-Five Thousand Ethiopian Birr and 75/100 Cents Only',
  )
})

test('calculateVoucherTotals calculates 15% VAT, 2% WHT, and Net Payable', () => {
  const result = calculateVoucherTotals([
    {
      grossAmount: 10000,
      vatRate: 15,
      whtRate: 2,
    },
    {
      grossAmount: 20000,
      vatRate: 0,
      whtRate: 30,
    },
  ])

  // Line 1: Gross 10,000, VAT 15% = 1,500, WHT 2% = 200, Net = 10000 + 1500 - 200 = 11300
  // Line 2: Gross 20,000, VAT 0% = 0, WHT 30% = 6,000, Net = 20000 + 0 - 6000 = 14000
  assert.equal(result.totalGross, 30000)
  assert.equal(result.totalVat, 1500)
  assert.equal(result.totalWht, 6200)
  assert.equal(result.totalNet, 25300)
  assert.equal(result.lines[0]?.netAmount, 11300)
  assert.equal(result.lines[1]?.netAmount, 14000)
  assert.equal(
    result.amountInWords,
    'Twenty-Five Thousand Three Hundred Ethiopian Birr Only',
  )
})

test('Payment Voucher lifecycle: create, submit, check, approve, reject, delete', () => {
  // 1. Create Draft
  const draft = createOrUpdatePaymentVoucher(
    {
      payeeName: 'Test Vendor PLC',
      payeeTin: '0011223344',
      paymentMode: 'Bank Transfer',
      bankAccountName: 'Commercial Bank of Ethiopia',
      description: 'Test Office Maintenance',
      lines: [
        {
          description: 'Server room air conditioning service',
          glAccountNo: '52100',
          glAccountName: 'Repairs and Maintenance',
          grossAmount: 5000,
          vatRate: 15,
          whtRate: 2,
        },
      ],
    },
    { name: 'Leah Worku', title: 'Finance Officer' },
  )

  assert.ok(draft.id.startsWith('PV-'))
  assert.equal(draft.status, 'Draft')
  assert.equal(draft.totalGross, 5000)
  assert.equal(draft.totalVat, 750)
  assert.equal(draft.totalWht, 100)
  assert.equal(draft.totalNet, 5650)
  assert.equal(draft.preparedBy.name, 'Leah Worku')

  // 2. Submit for Approval
  const submitted = submitPaymentVoucher(draft.id, {
    name: 'Leah Worku',
    title: 'Finance Officer',
  })
  assert.equal(submitted.status, 'Submitted')

  // Cannot delete submitted voucher
  assert.throws(() => deletePaymentVoucher(draft.id), /Only Draft or Rejected/)

  // 3. Checked by Yohannes (Senior Finance Specialist)
  const checked = approvePaymentVoucher(draft.id, {
    name: 'Yohannes Haile',
    title: 'Senior Finance Specialist',
    step: 'check',
    comments: 'Budget and accounts verified.',
  })
  assert.equal(checked.status, 'Under Review')
  assert.equal(checked.checkedBy?.name, 'Yohannes Haile')

  // 4. Approved by Tesfaye (FAD)
  const approved = approvePaymentVoucher(draft.id, {
    name: 'Tesfaye Abebe',
    title: 'Finance & Administration Director',
    comments: 'Approved for disbursement.',
  })
  assert.equal(approved.status, 'Approved')
  assert.equal(approved.approvedBy?.name, 'Tesfaye Abebe')

  // 5. Reject scenario test
  const draft2 = createOrUpdatePaymentVoucher(
    {
      payeeName: 'Reject Vendor',
      lines: [{ grossAmount: 1000, vatRate: 15, whtRate: 2 }],
    },
    { name: 'Leah Worku', title: 'Finance Officer' },
  )
  submitPaymentVoucher(draft2.id, { name: 'Leah Worku', title: 'Finance Officer' })
  const rejected = rejectPaymentVoucher(draft2.id, {
    name: 'Tesfaye Abebe',
    title: 'FAD',
    reason: 'Invoice copy missing supporting receipt',
  })
  assert.equal(rejected.status, 'Rejected')
  assert.equal(rejected.rejectionReason, 'Invoice copy missing supporting receipt')

  // Can delete rejected voucher
  const deleted = deletePaymentVoucher(draft2.id)
  assert.equal(deleted, true)

  // Reset status to Draft in store so we can clean up
  createOrUpdatePaymentVoucher({ id: draft.id, status: 'Draft' }, { name: 'Admin', title: 'Admin' })
  deletePaymentVoucher(draft.id)
})
