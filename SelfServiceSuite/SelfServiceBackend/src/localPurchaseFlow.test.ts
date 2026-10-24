import assert from 'node:assert/strict'
import { beforeEach, describe, it } from 'node:test'
import {
  assertLocalPurchaseActionAllowed,
  cachedLocalPurchaseAccess,
  clearLocalPurchaseAccessCache,
  hasBcLocalPurchaseRole,
  localPurchaseChainDocumentNos,
  localPurchaseCardEditable,
  localPurchaseEditing,
  localPurchaseNextActions,
  localPurchaseProgress,
  parseBcLocalPurchaseRoles,
  resolveLocalPurchaseAccess,
  LOCAL_PURCHASE_ACTIONS,
  type LocalPurchaseChain,
  type LocalPurchaseRole,
} from './localPurchaseFlow.js'

describe('assertLocalPurchaseActionAllowed', () => {
  it('allows each workflow action for the BC setup role that owns it', () => {
    assert.equal(assertLocalPurchaseActionAllowed(['projectProcurement'], 'SUBMIT_LPR_OPS'), 'SUBMIT_LPR_OPS')
    assert.equal(assertLocalPurchaseActionAllowed(['operationsManager'], 'APPROVE_LPR_OPS'), 'APPROVE_LPR_OPS')
    assert.equal(assertLocalPurchaseActionAllowed(['fad'], 'APPROVE_LPR_FAD'), 'APPROVE_LPR_FAD')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'CONVERT_TO_RFQ'), 'CONVERT_TO_RFQ')
    assert.equal(assertLocalPurchaseActionAllowed(['projectProcurement'], 'CONVERT_TO_RFQ'), 'CONVERT_TO_RFQ')
    assert.equal(assertLocalPurchaseActionAllowed(['operationsManager'], 'APPROVE_RFQ_OPS'), 'APPROVE_RFQ_OPS')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'UPSERT_VENDOR_QUOTE', '', true), 'UPSERT_VENDOR_QUOTE')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'AUTO_SELECT_WINNER'), 'AUTO_SELECT_WINNER')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'SEND_FOR_OPS_REVIEW'), 'SEND_FOR_OPS_REVIEW')
    assert.equal(assertLocalPurchaseActionAllowed(['operationsManager'], 'SEND_TO_TECHNICAL'), 'SEND_TO_TECHNICAL')
    assert.equal(assertLocalPurchaseActionAllowed(['technical'], 'SUBMIT_TECHNICAL_REVIEW', 'change vendor'), 'SUBMIT_TECHNICAL_REVIEW')
    assert.equal(assertLocalPurchaseActionAllowed(['fad'], 'APPROVE_WINNER_FAD_FINAL'), 'APPROVE_WINNER_FAD_FINAL')
    assert.equal(assertLocalPurchaseActionAllowed(['procurement'], 'CREATE_PO'), 'CREATE_PO')
    assert.equal(assertLocalPurchaseActionAllowed(['operationsManager'], 'APPROVE_PO_OPS'), 'APPROVE_PO_OPS')
    assert.equal(assertLocalPurchaseActionAllowed(['fad'], 'APPROVE_PO_FAD'), 'APPROVE_PO_FAD')
    assert.equal(assertLocalPurchaseActionAllowed(['operations'], 'POST_LOCAL_RECEIVE'), 'POST_LOCAL_RECEIVE')
    assert.equal(assertLocalPurchaseActionAllowed(['operationsManager'], 'APPROVE_INVOICE_OPS'), 'APPROVE_INVOICE_OPS')
    assert.equal(assertLocalPurchaseActionAllowed(['fad'], 'APPROVE_PAYMENT_FAD'), 'APPROVE_PAYMENT_FAD')
    assert.equal(
      assertLocalPurchaseActionAllowed(['financeChecker'], 'CLOSE_LPR_AFTER_PAYMENT', '', true),
      'CLOSE_LPR_AFTER_PAYMENT',
    )
  })

  it('rejects cross-role, a generic finance title, and missing comment/payload', () => {
    assert.throws(() => assertLocalPurchaseActionAllowed(['procurement'], 'APPROVE_LPR_FAD'), /not authorized/i)
    // A "finance" job title is not a BC setup role.
    assert.throws(() => assertLocalPurchaseActionAllowed(['finance'], 'APPROVE_LPR_FAD'), /not authorized/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['finance'], 'APPROVE_PAYMENT_FAD'), /not authorized/i)
    // Meeting 18 Oct: the PO and payment approvals moved off Finance Checker / CEO.
    assert.throws(() => assertLocalPurchaseActionAllowed(['financeChecker'], 'APPROVE_PO_OPS'), /not authorized/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['ceo'], 'APPROVE_PAYMENT_FAD'), /not authorized/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['procurement'], 'SEND_TO_TECHNICAL'), /not authorized/i)
    // Steps 20–21: the Store Keeper receives — Procurement no longer posts the GRN.
    assert.throws(() => assertLocalPurchaseActionAllowed(['procurement'], 'POST_LOCAL_RECEIVE'), /not authorized/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['operationsManager'], 'SUBMIT_LPR_OPS'), /not authorized/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['procurement'], 'UPSERT_VENDOR_QUOTE', '', false), /payload/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['financeChecker'], 'CLOSE_LPR_AFTER_PAYMENT', '', false), /payload/i)
    assert.throws(() => assertLocalPurchaseActionAllowed(['technical'], 'SUBMIT_TECHNICAL_REVIEW', ''), /comment/i)
  })

  it('covers every documented Local Purchase SOAP action', () => {
    const expected = [
      'SUBMIT_LPR_OPS',
      'UPDATE_LPR_LINE',
      'UPDATE_LPR_HEADER',
      'ADD_LPR_LINE',
      'DELETE_LPR_LINE',
      'UPDATE_RFQ_HEADER',
      'UPDATE_RFQ_LINE',
      'ADD_RFQ_LINE',
      'DELETE_RFQ_LINE',
      'DELETE_VENDOR_QUOTE',
      'UPDATE_PO_HEADER',
      'UPDATE_PO_LINE',
      'ADD_PO_LINE',
      'DELETE_PO_LINE',
      'UPDATE_PO_RECEIVE',
      'APPROVE_LPR_OPS',
      'APPROVE_LPR_FAD',
      'REJECT_LPR',
      'CONVERT_TO_RFQ',
      'APPROVE_RFQ_OPS',
      'UPSERT_VENDOR_QUOTE',
      'AUTO_SELECT_WINNER',
      'SEND_FOR_OPS_REVIEW',
      'SEND_TO_TECHNICAL',
      'SEND_FOR_FAD_APPROVAL',
      'SUBMIT_TECHNICAL_REVIEW',
      'SELECT_WINNER_FAD',
      'APPROVE_WINNER_FAD_FINAL',
      'CREATE_PO',
      'APPROVE_PO_OPS',
      'APPROVE_PO_FAD',
      'PREPARE_LOCAL_RECEIVE',
      'CREATE_LOCAL_INVOICE',
      'APPROVE_INVOICE_OPS',
      'VERIFY_PO_GRN_INVOICE',
      'APPROVE_PAYMENT_FAD',
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
  'operationsManager',
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

describe('localPurchaseNextActions — 26-step workflow (meeting 18 Oct)', () => {
  // Stage names are the BC captions (PortalLocalPurchaseChain sends Format(Flow Stage)).
  it('walks SR → LPR (Ops, FAD) → RFQ (Ops) → quotes → evaluation (Ops) → FAD Final → PO (Ops, FAD) → GRN → invoice (Ops, Finance) → F&A pay → close', () => {
    // 7 Procurement Officer prepares the LPR (Draft) and submits it to the Operations Manager
    let s = step(demoChain({ lprStatus: 'Draft', lprStage: 'LPR Draft' }), 'procurement')
    assert.deepEqual(s.mine, ['UPDATE_LPR_LINE@ABH-PQ000092', 'SUBMIT_LPR_OPS@ABH-PQ000092'])
    assert.deepEqual(s.others, [])
    assert.deepEqual(step(demoChain({ lprStatus: 'Draft', lprStage: 'LPR Draft' }), 'operationsManager').mine, [])

    // 8 Operations Manager approves the LPR
    s = step(demoChain({ lprStatus: 'Pending Operations Manager', lprStage: 'Pending Operations Manager' }), 'operationsManager')
    assert.deepEqual(s.mine, ['APPROVE_LPR_OPS@ABH-PQ000092', 'REJECT_LPR@ABH-PQ000092'])
    assert.deepEqual(s.others, [])
    assert.deepEqual(
      step(demoChain({ lprStatus: 'Pending Operations Manager', lprStage: 'Pending Operations Manager' }), 'fad').mine,
      [],
    )

    // 9 F&A approves the LPR
    s = step(demoChain({ lprStatus: 'Pending Finance & Admin', lprStage: 'Pending FAD' }), 'fad')
    assert.deepEqual(s.mine, ['APPROVE_LPR_FAD@ABH-PQ000092', 'REJECT_LPR@ABH-PQ000092'])
    assert.deepEqual(s.others, [])

    // 10 Procurement prepares the RFQ
    s = step(demoChain({ lprStatus: 'Approved', lprStage: 'Ready for RFQ' }), 'procurement')
    assert.deepEqual(s.mine, ['CONVERT_TO_RFQ@ABH-PQ000092'])

    // 11 Operations Manager approves the RFQ before quotations
    s = step(demoChain({ rfqStage: 'Pending Operations Manager RFQ' }), 'operationsManager')
    assert.deepEqual(s.mine, ['APPROVE_RFQ_OPS@ABH-PQ000093'])
    assert.deepEqual(step(demoChain({ rfqStage: 'Pending Operations Manager RFQ' }), 'procurement').mine, [])

    // 12–13 Procurement: quotes, evaluation (winner), send for Ops review
    s = step(demoChain({ rfqStage: 'RFQ Open' }), 'procurement')
    assert.deepEqual(s.mine, ['UPSERT_VENDOR_QUOTE@ABH-PQ000093', 'AUTO_SELECT_WINNER@ABH-PQ000093'])
    s = step(demoChain({ rfqStage: 'Winner Selected' }), 'procurement')
    assert.ok(s.mine.includes('SEND_FOR_OPS_REVIEW@ABH-PQ000093'))
    assert.ok(!s.mine.some((code) => code.startsWith('SEND_TO_TECHNICAL')), 'Technical routing is the Ops Manager')
    assert.ok(!s.mine.some((code) => code.startsWith('CREATE_PO')), 'no Create PO before FAD Final')

    // 14 Operations Manager: Technical if required, else FAD; or send back
    s = step(demoChain({ rfqStage: 'Pending Operations Manager Evaluation' }), 'operationsManager')
    assert.deepEqual(s.mine, [
      'SEND_TO_TECHNICAL@ABH-PQ000093',
      'SEND_FOR_FAD_APPROVAL@ABH-PQ000093',
      'SEND_BACK_RFQ@ABH-PQ000093',
    ])
    assert.deepEqual(step(demoChain({ rfqStage: 'Pending Operations Manager Evaluation' }), 'fad').mine, [])

    // 15 Technical (optional)
    s = step(demoChain({ rfqStage: 'Pending Technical' }), 'technical')
    assert.deepEqual(s.mine, ['SUBMIT_TECHNICAL_REVIEW@ABH-PQ000093'])

    // 16 FAD final supplier approval
    s = step(demoChain({ rfqStage: 'Pending FAD Final' }), 'fad')
    assert.ok(s.mine.includes('SELECT_WINNER_FAD@ABH-PQ000093'))
    assert.ok(s.mine.includes('APPROVE_WINNER_FAD_FINAL@ABH-PQ000093'))
    assert.ok(s.mine.includes('SEND_BACK_RFQ@ABH-PQ000093'))
    assert.deepEqual(step(demoChain({ rfqStage: 'Pending FAD Final' }), 'operationsManager').mine, [])

    // 17 Procurement prepares the PO
    s = step(demoChain({ rfqStage: 'Ready for PO' }), 'projectProcurement')
    assert.deepEqual(s.mine, ['CREATE_PO@ABH-PQ000093'])

    // 18 Operations Manager approves the PO, 19 then FAD
    s = step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending Operations Manager PO' }), 'operationsManager')
    assert.deepEqual(s.mine, ['APPROVE_PO_OPS@ABH-PO000008', 'SEND_BACK_PO@ABH-PO000008'])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending Finance PO' }), 'financeChecker').mine, [])
    s = step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending FAD PO' }), 'fad')
    assert.deepEqual(s.mine, ['APPROVE_PO_FAD@ABH-PO000008', 'SEND_BACK_PO@ABH-PO000008'])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending FAD PO' }), 'operationsManager').mine, [])

    // 20–21 Store Keeper receives and records the GRN
    s = step(demoChain({ rfqStage: 'PO Created', poStage: 'PO Released' }), 'operations')
    assert.deepEqual(s.mine, ['PREPARE_LOCAL_RECEIVE@ABH-PO000008', 'POST_LOCAL_RECEIVE@ABH-PO000008'])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'PO Released' }), 'procurement').mine, [
      'FIX_LOCAL_CURRENCY@ABH-PO000008',
    ])

    // Issue after LPR receive (Store Keeper) + 22 Procurement prepares the invoice
    s = step(demoChain({ rfqStage: 'PO Created', poStage: 'Goods Received' }), 'operations')
    assert.deepEqual(s.mine, ['ISSUE_AFTER_LPR@ABH-SR000159'])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Goods Received' }), 'procurement').mine, [
      'CREATE_LOCAL_INVOICE@ABH-PO000008',
    ])

    // 23 Operations Manager checks the invoice, 24 Finance verifies PO + GRN + Invoice
    assert.deepEqual(
      step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending Operations Manager Invoice' }), 'operationsManager').mine,
      ['APPROVE_INVOICE_OPS@ABH-PO000008'],
    )
    assert.deepEqual(
      step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending Operations Manager Invoice' }), 'financeChecker').mine,
      [],
    )
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending Invoice Check' }), 'financeChecker').mine, [
      'VERIFY_PO_GRN_INVOICE@ABH-PO000008',
    ])

    // 25 F&A approves payment, 26 Finance pays and closes
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending F&A Payment Approval' }), 'fad').mine, [
      'APPROVE_PAYMENT_FAD@ABH-PO000008',
    ])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending F&A Payment Approval' }), 'ceo').mine, [])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Payment Approved' }), 'financeChecker').mine, [
      'CLOSE_LPR_AFTER_PAYMENT@ABH-PO000008',
    ])
    const closed = localPurchaseNextActions(demoChain({ rfqStage: 'PO Created', poStage: 'LPR Closed' }), ALL_ROLES)
    assert.deepEqual(closed.map((action) => action.actionCode), ['ISSUE_AFTER_LPR'])
  })

  it('still maps BC member names (older captions) to the same steps', () => {
    assert.deepEqual(step(demoChain({ rfqStage: 'Pending Ops RFQ' }), 'operationsManager').mine, ['APPROVE_RFQ_OPS@ABH-PQ000093'])
    assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage: 'Pending CEO Payment' }), 'fad').mine, [
      'APPROVE_PAYMENT_FAD@ABH-PO000008',
    ])
    assert.deepEqual(step(demoChain({ lprStatus: 'Pending Operations', lprStage: 'Pending Operations' }), 'operationsManager').mine, [
      'APPROVE_LPR_OPS@ABH-PQ000092',
      'REJECT_LPR@ABH-PQ000092',
    ])
  })

  it('never lets the CEO or Technical run PO steps, nor the Store Keeper approve', () => {
    for (const poStage of ['Pending Operations Manager PO', 'Pending FAD PO', 'PO Released']) {
      for (const role of ['ceo', 'technical'] as LocalPurchaseRole[]) {
        assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage }), role).mine, [])
      }
    }
    for (const poStage of ['Pending Operations Manager PO', 'Pending FAD PO']) {
      assert.deepEqual(step(demoChain({ rfqStage: 'PO Created', poStage }), 'operations').mine, [])
    }
  })

  it('lists chain document numbers for the POST guard', () => {
    const nos = localPurchaseChainDocumentNos(demoChain({ rfqStage: 'PO Created', poStage: 'PO Released' }))
    assert.deepEqual([...new Set(nos)].sort(), ['ABH-PO000008', 'ABH-PQ000092', 'ABH-PQ000093'])
  })

  it('lets the LPR card be edited only where the BC card does', () => {
    const lpr = (lprStatus: string, status: string, createdRfqNo = '') => ({
      storeRequisitionNo: 'ABH-SR000210',
      lpr: { no: 'ABH-PQ000111', lprStatus, status, createdRfqNo },
    })
    assert.equal(localPurchaseCardEditable(lpr('Draft', 'Open')), true)
    assert.equal(localPurchaseCardEditable(lpr('Draft', 'Released')), false)
    assert.equal(localPurchaseCardEditable(lpr('Pending Operations Manager', 'Open')), false)
    assert.equal(localPurchaseCardEditable(lpr('Pending Finance & Admin', 'Open')), false)
    assert.equal(localPurchaseCardEditable(lpr('Approved', 'Released')), true)
    assert.equal(localPurchaseCardEditable(lpr('Approved', 'Released', 'ABH-PQ000112')), false)
    assert.equal(localPurchaseCardEditable(lpr('Converted to RFQ', 'Released', 'ABH-PQ000112')), false)
    assert.equal(localPurchaseCardEditable({}), false)
  })

  it('opens the Local RFQ, PO and receive edits only where BC does, for the owning role', () => {
    const chain = (rfqLocked: boolean | undefined, poStage = '', poLocked?: boolean): LocalPurchaseChain => ({
      lpr: { no: 'ABH-PQ000092', lprStatus: 'Converted to RFQ', status: 'Released', createdRfqNo: 'ABH-PQ000093' },
      rfq: { no: 'ABH-PQ000093', flowStage: 'RFQ Open', linesLocked: rfqLocked, ...(rfqLocked === undefined ? {} : { lines: [] }) },
      ...(poStage
        ? { po: { no: 'ABH-PO000008', flowStage: poStage, linesLocked: poLocked, ...(poLocked === undefined ? {} : { lines: [] }) } }
        : {}),
    })
    const procurement: LocalPurchaseRole[] = ['procurement']
    assert.deepEqual(localPurchaseEditing(chain(false), procurement), { lpr: false, rfq: true, po: false, receive: false })
    assert.equal(localPurchaseEditing(chain(true), procurement).rfq, false)
    // BC before 1.0.3.569 sends no lock state or lines: nothing opens.
    assert.equal(localPurchaseEditing(chain(undefined), procurement).rfq, false)
    assert.equal(localPurchaseEditing(chain(false), ['operationsManager']).rfq, false)
    assert.equal(localPurchaseEditing(chain(true, 'PO Created', false), procurement).po, true)
    assert.equal(localPurchaseEditing(chain(true, 'Pending FAD PO', true), procurement).po, false)
    assert.equal(localPurchaseEditing(chain(true, 'PO Released', true), ['operations']).receive, true)
    assert.equal(localPurchaseEditing(chain(true, 'PO Released', true), procurement).receive, false)
    assert.equal(localPurchaseEditing(chain(true, 'Goods Received', true), ['operations']).receive, false)
  })

  it('reports the BC step on the store requisition, and received only after the GRN', () => {
    const draft = demoChain({ lprStatus: 'Draft', lprStage: 'LPR Draft' })
    draft.lpr = {
      ...draft.lpr,
      processStep: '2. Procurement Officer prepares the LPR, then Submit to Operations Manager',
      assignedProcUserId: 'TSION_GEREMEW',
    }
    assert.deepEqual(localPurchaseProgress(draft), {
      lprNo: 'ABH-PQ000092',
      lprStatus: 'Draft',
      assignedProcUserId: 'TSION_GEREMEW',
      currentDocumentNo: 'ABH-PQ000092',
      flowStage: 'LPR Draft',
      processStep: '2. Procurement Officer prepares the LPR, then Submit to Operations Manager',
      received: false,
    })
    assert.equal(localPurchaseProgress(demoChain({ rfqStage: 'PO Created', poStage: 'PO Released' })).received, false)
    const received = localPurchaseProgress(demoChain({ rfqStage: 'PO Created', poStage: 'Goods Received' }))
    assert.equal(received.received, true)
    assert.equal(received.currentDocumentNo, 'ABH-PO000008')
  })
})

describe('Local Purchase access from Business Central', () => {
  beforeEach(() => clearLocalPurchaseAccessCache())
  const fadUser = { userID: 'ADMIN', jobTitle: 'Director' }
  const keeper = { userID: 'IT_KEEPER', jobTitle: 'Store Keeper' }

  it('parses the BC roles response and drops unknown names', () => {
    assert.deepEqual(parseBcLocalPurchaseRoles('{"roles":["fad","FinanceChecker","boss"]}'), ['fad', 'financeChecker'])
    assert.deepEqual(parseBcLocalPurchaseRoles('{"roles":["operationsManager","projectProcurement"]}'), [
      'operationsManager',
      'projectProcurement',
    ])
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
