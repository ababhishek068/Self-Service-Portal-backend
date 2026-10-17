import assert from 'node:assert/strict'
import { beforeEach, describe, it } from 'node:test'
import {
  assertLocalPurchaseActionAllowed,
  cachedLocalPurchaseAccess,
  clearLocalPurchaseAccessCache,
  hasBcLocalPurchaseRole,
  localPurchaseChainDocumentNos,
  localPurchaseNextActions,
  parseBcLocalPurchaseRoles,
  resolveLocalPurchaseAccess,
  LOCAL_PURCHASE_ACTIONS,
  type LocalPurchaseChain,
  type LocalPurchaseRole,
} from './localPurchaseFlow.js'

describe('assertLocalPurchaseActionAllowed', () => {
  it('allows the video-flow actions for the BC setup role that owns them', () => {
    assert.equal(assertLocalPurchaseActionAllowed(['fad'], 'APPROVE_LPR_FAD'), 'APPROVE_LPR_FAD')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'CONVERT_TO_RFQ'), 'CONVERT_TO_RFQ')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'UPSERT_VENDOR_QUOTE', '', true), 'UPSERT_VENDOR_QUOTE')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'AUTO_SELECT_WINNER'), 'AUTO_SELECT_WINNER')
    assert.equal(assertLocalPurchaseActionAllowed(['technical'], 'SUBMIT_TECHNICAL_REVIEW', 'change vendor'), 'SUBMIT_TECHNICAL_REVIEW')
    assert.equal(assertLocalPurchaseActionAllowed(['fad'], 'APPROVE_WINNER_FAD_FINAL'), 'APPROVE_WINNER_FAD_FINAL')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'CREATE_PO'), 'CREATE_PO')
    assert.equal(assertLocalPurchaseActionAllowed(['financeChecker'], 'APPROVE_PO_FINANCE_CHECKER'), 'APPROVE_PO_FINANCE_CHECKER')
    assert.equal(assertLocalPurchaseActionAllowed(['fad'], 'APPROVE_PO_FAD'), 'APPROVE_PO_FAD')
    assert.equal(assertLocalPurchaseActionAllowed(['ceo'], 'APPROVE_PAYMENT_CEO'), 'APPROVE_PAYMENT_CEO')
  })

  it('rejects cross-role, a generic finance title, and missing comment/payload', () => {
    assert.throws(() => assertLocalPurchaseActionAllowed(['procurement'], 'APPROVE_LPR_FAD'), /not authorized/i)
    // A "finance" job title is not a BC setup role — it can no longer approve as FAD or pay as CEO.
    assert.throws(() => assertLocalPurchaseActionAllowed(['finance'], 'APPROVE_LPR_FAD'), /not authorized/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['finance'], 'APPROVE_PAYMENT_CEO'), /not authorized/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['procurement'], 'UPSERT_VENDOR_QUOTE', '', false), /payload/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['technical'], 'SUBMIT_TECHNICAL_REVIEW', ''), /comment/i)
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
      'POST_LOCAL_RECEIVE',
      'SEND_BACK_RFQ',
      'SEND_BACK_PO',
      'RESUBMIT_PO',
    ]
    for (const action of expected) {
      assert.ok(LOCAL_PURCHASE_ACTIONS[action], `missing ${action}`)
    }
  })
})

/** Demo chain from the UAT recording: ABH-SR000159 → ABH-PQ000092 → ABH-PQ000093 → PO. */
function demoChain(stage: {
  lprStatus?: string
  lprStage?: string
  rfqStage?: string
  poStage?: string
}): LocalPurchaseChain {
  const chain: LocalPurchaseChain = {
    storeRequisitionNo: 'ABH-SR000159',
    lpr: {
      no: 'ABH-PQ000092',
      lprStatus: stage.lprStatus ?? 'Converted to RFQ',
      flowStage: stage.lprStage ?? stage.poStage ?? stage.rfqStage ?? '',
      createdRfqNo: stage.rfqStage ? 'ABH-PQ000093' : '',
    },
  }
  if (stage.rfqStage) {
    chain.rfq = {
      no: 'ABH-PQ000093',
      flowStage: stage.rfqStage,
      createdPoNo: stage.poStage ? 'ABH-PO000008' : '',
    }
  }
  if (stage.poStage) chain.po = { no: 'ABH-PO000008', flowStage: stage.poStage }
  return chain
}

const ALL_ROLES: LocalPurchaseRole[] = [
  'operations',
  'procurement',
  'fad',
  'technical',
  'financeChecker',
  'ceo',
]

function step(chain: LocalPurchaseChain, role: LocalPurchaseRole) {
  const actions = localPurchaseNextActions(chain, [role])
  const mine = actions.filter((action) => action.allowed).map((action) => `${action.actionCode}@${action.documentNo}`)
  const others = ALL_ROLES.filter((other) => other !== role).flatMap((other) =>
    localPurchaseNextActions(chain, [other])
      .filter((action) => action.allowed && !action.ownerRoles.includes(role))
      .map((action) => action.actionCode),
  )
  return { mine, others }
}

describe('localPurchaseNextActions — full recording path', () => {
  it('walks SR → LPR → RFQ → quotes → winner → FAD Final → PO → receive → issue → invoice → pay → close', () => {
    // 9–10 FAD: Pending LPR → Approve (FAD)
    let s = step(demoChain({ lprStatus: 'Pending Finance & Admin', lprStage: 'Pending FAD' }), 'fad')
    assert.deepEqual(s.mine, ['APPROVE_LPR_FAD@ABH-PQ000092', 'REJECT_LPR@ABH-PQ000092'])
    assert.deepEqual(s.others, [])

    // 11 Procurement: Convert to RFQ
    s = step(demoChain({ lprStatus: 'Approved', lprStage: 'Ready for RFQ' }), 'procurement')
    assert.deepEqual(s.mine, ['CONVERT_TO_RFQ@ABH-PQ000092'])

    // 12–13 Procurement: quotes + Auto Select Winner on the RFQ, never on the LPR
    s = step(demoChain({ rfqStage: 'RFQ Open' }), 'procurement')
    assert.deepEqual(s.mine, ['UPSERT_VENDOR_QUOTE@ABH-PQ000093', 'AUTO_SELECT_WINNER@ABH-PQ000093'])
    s = step(demoChain({ rfqStage: 'Winner Selected' }), 'procurement')
    assert.ok(s.mine.includes('SEND_TO_TECHNICAL@ABH-PQ000093'))
    assert.ok(s.mine.includes('SEND_FOR_FAD_APPROVAL@ABH-PQ000093'))
    assert.ok(!s.mine.some((code) => code.startsWith('CREATE_PO')), 'no Create PO before FAD Final')

    // 14 Technical (optional)
    s = step(demoChain({ rfqStage: 'Pending Technical' }), 'technical')
    assert.deepEqual(s.mine, ['SUBMIT_TECHNICAL_REVIEW@ABH-PQ000093'])
    assert.deepEqual(step(demoChain({ rfqStage: 'Pending Technical' }), 'fad').mine, [])

    // 15 FAD: Change Winner (FAD) / Approve Winner (FAD Final)
    s = step(demoChain({ rfqStage: 'Pending FAD Final' }), 'fad')
    assert.ok(s.mine.includes('SELECT_WINNER_FAD@ABH-PQ000093'))
    assert.ok(s.mine.includes('APPROVE_WINNER_FAD_FINAL@ABH-PQ000093'))
    assert.deepEqual(step(demoChain({ rfqStage: 'Pending FAD Final' }), 'procurement').mine, [])

    // 16 Procurement: Create Purchase Order (from winner)
    s = step(demoChain({ rfqStage: 'Ready for PO' }), 'procurement')
    assert.deepEqual(s.mine, ['CREATE_PO@ABH-PQ000093'])

    // 17–18 Finance Checker first, then FAD (BC order)
    s = step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending Finance PO' }), 'financeChecker')
    assert.ok(s.mine.includes('APPROVE_PO_FINANCE_CHECKER@ABH-PO000008'))
    assert.ok(!step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending Finance PO' }), 'fad').mine.includes('APPROVE_PO_FAD@ABH-PO000008'))
    s = step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending FAD PO' }), 'fad')
    assert.ok(s.mine.includes('APPROVE_PO_FAD@ABH-PO000008'))

    // 19 Procurement: Prepare Local Receive → Post Receive
    s = step(demoChain({ rfqStage: 'PO Created', poStage: 'PO Released' }), 'procurement')
    assert.ok(s.mine.includes('PREPARE_LOCAL_RECEIVE@ABH-PO000008'))
    assert.ok(s.mine.includes('POST_LOCAL_RECEIVE@ABH-PO000008'))

    // 20 Store Keeper: Issue after LPR receive (on the original Store Req) + 21 invoice
    s = step(demoChain({ rfqStage: 'PO Created', poStage: 'Goods Received' }), 'operations')
    assert.deepEqual(s.mine, ['ISSUE_AFTER_LPR@ABH-SR000159'])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Goods Received' }), 'procurement').mine, [
      'CREATE_LOCAL_INVOICE@ABH-PO000008',
    ])

    // 21 Finance Checker verify → CEO Approve Payment → Finance Checker Payment Voucher / Close LPR
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending Invoice Check' }), 'financeChecker').mine, [
      'VERIFY_PO_GRN_INVOICE@ABH-PO000008',
    ])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending CEO Payment' }), 'ceo').mine, [
      'APPROVE_PAYMENT_CEO@ABH-PO000008',
    ])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Payment Approved' }), 'financeChecker').mine, [
      'CLOSE_LPR_AFTER_PAYMENT@ABH-PO000008',
    ])
    const closed = localPurchaseNextActions(demoChain({ rfqStage: 'PO Created', poStage: 'LPR Closed' }), ALL_ROLES)
    assert.deepEqual(closed.map((action) => action.actionCode), ['ISSUE_AFTER_LPR'])
  })

  it('never lets the CEO, Technical or Store Keeper run PO / winner steps', () => {
    for (const poStage of ['Pending Finance PO', 'Pending FAD PO', 'PO Released']) {
      for (const role of ['ceo', 'technical', 'operations'] as LocalPurchaseRole[]) {
        assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage }), role).mine, [])
      }
    }
  })

  it('lists chain document numbers for the POST guard', () => {
    const nos = localPurchaseChainDocumentNos(demoChain({ rfqStage: 'PO Created', poStage: 'PO Released' }))
    assert.deepEqual([...new Set(nos)].sort(), ['ABH-PO000008', 'ABH-PQ000092', 'ABH-PQ000093'])
  })
})

describe('Local Purchase access from Business Central', () => {
  beforeEach(() => clearLocalPurchaseAccessCache())
  const fadUser = { userID: 'ADMIN', jobTitle: 'Director' }
  const keeper = { userID: 'IT_KEEPER', jobTitle: 'Store Keeper' }

  it('parses the BC roles response and drops unknown names', () => {
    assert.deepEqual(parseBcLocalPurchaseRoles('{"roles":["fad","FinanceChecker","boss"]}'), ['fad', 'financeChecker'])
    assert.throws(() => parseBcLocalPurchaseRoles('{"nope":1}'), /invalid/i)
  })

  it('is enabled with BC setup roles when BC has PortalLocalPurchaseRoles', async () => {
    const calls: Array<Record<string, unknown>> = []
    const soap = async (_method: string, params: Record<string, unknown>) => {
      calls.push(params)
      return { returnValue: '{"roles":["fad"]}' }
    }
    const access = await resolveLocalPurchaseAccess(fadUser, soap, 1_000)
    assert.deepEqual(access, { enabled: true, roles: ['fad'] })
    assert.deepEqual(calls, [{ actorUserID: 'ADMIN' }])
    assert.equal(hasBcLocalPurchaseRole(cachedLocalPurchaseAccess(fadUser, 2_000)), true)
  })

  it('stays off (382 behaviour) when BC 1.0.3.310 lacks the method, and caches for a minute', async () => {
    let calls = 0
    const soap = async () => {
      calls += 1
      throw new Error('Business Central SOAP fault: method PortalLocalPurchaseRoles not found')
    }
    const first = await resolveLocalPurchaseAccess(fadUser, soap, 1_000)
    assert.equal(first.enabled, false)
    assert.deepEqual(first.roles, [])
    await resolveLocalPurchaseAccess(fadUser, soap, 30_000)
    assert.equal(calls, 1)
    await resolveLocalPurchaseAccess(fadUser, soap, 70_000)
    assert.equal(calls, 2)
    assert.equal(hasBcLocalPurchaseRole(cachedLocalPurchaseAccess(fadUser, 70_500)), false)
  })

  it('adds the Store Keeper role only while Local Purchase is enabled', async () => {
    const on = await resolveLocalPurchaseAccess(keeper, async () => ({ returnValue: '{"roles":[]}' }), 1_000)
    assert.deepEqual(on.roles, ['operations'])
    assert.equal(hasBcLocalPurchaseRole(on), false)
    clearLocalPurchaseAccessCache()
    const off = await resolveLocalPurchaseAccess(keeper, async () => { throw new Error('missing') }, 1_000)
    assert.deepEqual(off.roles, [])
  })

  it('never asks BC without a linked BC user id', async () => {
    let called = false
    const access = await resolveLocalPurchaseAccess({ userID: '' }, async () => { called = true; return {} }, 1_000)
    assert.equal(access.enabled, false)
    assert.equal(called, false)
  })
})
