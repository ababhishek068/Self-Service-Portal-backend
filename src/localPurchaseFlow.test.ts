import assert from 'node:assert/strict'
import { describe, it } from 'node:test'
import {
  assertLocalPurchaseActionAllowed,
  localPurchaseRoles,
  LOCAL_PURCHASE_ACTIONS,
} from './localPurchaseFlow.js'

describe('localPurchaseRoles', () => {
  it('maps FAD / procurement / finance checker / technical / CEO from titles and user IDs', () => {
    assert.deepEqual(
      localPurchaseRoles({ roles: [], jobTitle: 'Finance and Admin Director', department: '', departmentName: '' }),
      ['fad', 'finance'],
    )
    assert.ok(localPurchaseRoles({ roles: [], jobTitle: '', department: '', departmentName: '', userID: 'LPR_PROCURE' }).includes('procurement'))
    assert.ok(localPurchaseRoles({ roles: [], jobTitle: 'Finance Checker', department: '', departmentName: '' }).includes('financeChecker'))
    assert.ok(localPurchaseRoles({ roles: [], jobTitle: '', department: '', departmentName: '', userID: 'LPR_TECH' }).includes('technical'))
    assert.ok(localPurchaseRoles({ roles: ['ceo'], jobTitle: '', department: '', departmentName: '' }).includes('ceo'))
  })
})

describe('assertLocalPurchaseActionAllowed', () => {
  it('allows the video-flow actions for the owning roles', () => {
    const fad = { roles: [], jobTitle: 'FAD', department: 'Finance & Administration', departmentName: '' }
    const procure = { roles: ['procurement'], jobTitle: '', department: '', departmentName: '' }
    const tech = { roles: [], jobTitle: '', department: '', departmentName: '', userID: 'LPR_TECH' }
    const finCheck = { roles: [], jobTitle: 'Finance Checker', department: '', departmentName: '' }
    const ceo = { roles: ['ceo'], jobTitle: '', department: '', departmentName: '' }

    assert.equal(assertLocalPurchaseActionAllowed(fad, 'APPROVE_LPR_FAD'), 'APPROVE_LPR_FAD')
    assert.equal(assertLocalPurchaseActionAllowed(procure, 'CONVERT_TO_RFQ'), 'CONVERT_TO_RFQ')
    assert.equal(
      assertLocalPurchaseActionAllowed(procure, 'UPSERT_VENDOR_QUOTE', '', true),
      'UPSERT_VENDOR_QUOTE',
    )
    assert.equal(assertLocalPurchaseActionAllowed(procure, 'AUTO_SELECT_WINNER'), 'AUTO_SELECT_WINNER')
    assert.equal(
      assertLocalPurchaseActionAllowed(tech, 'SUBMIT_TECHNICAL_REVIEW', 'change vendor'),
      'SUBMIT_TECHNICAL_REVIEW',
    )
    assert.equal(assertLocalPurchaseActionAllowed(fad, 'APPROVE_WINNER_FAD_FINAL'), 'APPROVE_WINNER_FAD_FINAL')
    assert.equal(assertLocalPurchaseActionAllowed(procure, 'CREATE_PO'), 'CREATE_PO')
    assert.equal(assertLocalPurchaseActionAllowed(finCheck, 'APPROVE_PO_FINANCE_CHECKER'), 'APPROVE_PO_FINANCE_CHECKER')
    assert.equal(assertLocalPurchaseActionAllowed(fad, 'APPROVE_PO_FAD'), 'APPROVE_PO_FAD')
    assert.equal(assertLocalPurchaseActionAllowed(ceo, 'APPROVE_PAYMENT_CEO'), 'APPROVE_PAYMENT_CEO')
  })

  it('rejects cross-role and missing comment/payload', () => {
    const procure = { roles: ['procurement'], jobTitle: '', department: '', departmentName: '' }
    assert.throws(() => assertLocalPurchaseActionAllowed(procure, 'APPROVE_LPR_FAD'), /not authorized/i)
    assert.throws(
      () => assertLocalPurchaseActionAllowed(procure, 'UPSERT_VENDOR_QUOTE', '', false),
      /payload/i,
    )
    assert.throws(
      () =>
        assertLocalPurchaseActionAllowed(
          { roles: [], jobTitle: '', department: '', departmentName: '', userID: 'LPR_TECH' },
          'SUBMIT_TECHNICAL_REVIEW',
          '',
        ),
      /comment/i,
    )
  })

  it('covers every documented Local Purchase SOAP action', () => {
    const expected = [
      'APPROVE_LPR_FAD',
      'REJECT_LPR',
      'CONVERT_TO_RFQ',
      'UPSERT_VENDOR_QUOTE',
      'AUTO_SELECT_WINNER',
      'SEND_TO_TECHNICAL',
      'SEND_FOR_FAD_APPROVAL',
      'SUBMIT_TECHNICAL_REVIEW',
      'SELECT_WINNER_FAD',
      'APPROVE_WINNER_FAD_FINAL',
      'CREATE_PO',
      'APPROVE_PO_FINANCE_CHECKER',
      'APPROVE_PO_FAD',
      'PREPARE_LOCAL_RECEIVE',
      'CREATE_LOCAL_INVOICE',
      'VERIFY_PO_GRN_INVOICE',
      'APPROVE_PAYMENT_CEO',
      'CLOSE_LPR_AFTER_PAYMENT',
      'FIX_LOCAL_CURRENCY',
    ]
    for (const action of expected) {
      assert.ok(LOCAL_PURCHASE_ACTIONS[action], `missing ${action}`)
    }
  })
})
