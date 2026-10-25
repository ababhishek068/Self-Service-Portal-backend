/**
 * Local Purchase (LPR → RFQ → PO → pay) portal actions.
 * Mirrors the BC UAT recording + ABH Local Procurement procedures exposed via
 * SOAP PortalLocalPurchaseAction / PortalListVendorQuotes.
 */

export type LocalPurchaseRole =
  | 'operations'
  | 'operationsManager'
  | 'procurement'
  | 'projectProcurement'
  | 'finance'
  | 'fad'
  | 'technical'
  | 'financeChecker'
  | 'ceo'
  | 'auditor'

export type LocalPurchaseAuth = {
  roles?: string[]
  jobTitle?: string
  department?: string
  departmentName?: string
  userID?: string
  employeeNo?: string
}

const PROCUREMENT: LocalPurchaseRole[] = ['procurement', 'projectProcurement']

/** Actions that call PortalLocalPurchaseAction in Business Central. */
export const LOCAL_PURCHASE_ACTIONS: Record<
  string,
  { roles: LocalPurchaseRole[]; needsPayload?: boolean; commentRequired?: boolean }
> = {
  // Owners mirror ABH Local Procurement's TestIs* checks (ABH Local Proc Setup user IDs).
  // Workflow per "ERP & BC – Staff Item-Asset Request to Payment Workflow" (meeting 18 Oct).
  SUBMIT_LPR_OPS: { roles: PROCUREMENT },
  /** Step 7: a Purchase Requisition Subform line (BC 1.0.3.568: every subform column). */
  UPDATE_LPR_LINE: { roles: PROCUREMENT, needsPayload: true },
  /** BC 1.0.3.568: Purchase Requisition Card General fields, New Line and Delete Line. */
  UPDATE_LPR_HEADER: { roles: PROCUREMENT, needsPayload: true },
  ADD_LPR_LINE: { roles: PROCUREMENT, needsPayload: true },
  DELETE_LPR_LINE: { roles: PROCUREMENT, needsPayload: true },
  /** BC 1.0.3.569: Local RFQ card and lines, vendor quote delete, Local PO card and lines, receive quantities. */
  UPDATE_RFQ_HEADER: { roles: PROCUREMENT, needsPayload: true },
  UPDATE_RFQ_LINE: { roles: PROCUREMENT, needsPayload: true },
  ADD_RFQ_LINE: { roles: PROCUREMENT, needsPayload: true },
  DELETE_RFQ_LINE: { roles: PROCUREMENT, needsPayload: true },
  DELETE_VENDOR_QUOTE: { roles: PROCUREMENT, needsPayload: true },
  UPDATE_PO_HEADER: { roles: PROCUREMENT, needsPayload: true },
  UPDATE_PO_LINE: { roles: PROCUREMENT, needsPayload: true },
  ADD_PO_LINE: { roles: PROCUREMENT, needsPayload: true },
  DELETE_PO_LINE: { roles: PROCUREMENT, needsPayload: true },
  UPDATE_PO_RECEIVE: { roles: ['operations'], needsPayload: true },
  APPROVE_LPR_OPS: { roles: ['operationsManager'] },
  APPROVE_LPR_FAD: { roles: ['fad'] },
  REJECT_LPR: { roles: ['operationsManager', 'fad'], commentRequired: true },
  CONVERT_TO_RFQ: { roles: PROCUREMENT },
  APPROVE_RFQ_OPS: { roles: ['operationsManager'] },
  UPSERT_VENDOR_QUOTE: { roles: PROCUREMENT, needsPayload: true },
  AUTO_SELECT_WINNER: { roles: PROCUREMENT },
  SEND_FOR_OPS_REVIEW: { roles: PROCUREMENT },
  SEND_TO_TECHNICAL: { roles: ['operationsManager'] },
  SEND_FOR_FAD_APPROVAL: { roles: ['operationsManager'] },
  SUBMIT_TECHNICAL_REVIEW: { roles: ['technical'], commentRequired: true },
  SELECT_WINNER_FAD: { roles: ['fad'] },
  APPROVE_WINNER_FAD_FINAL: { roles: ['fad'] },
  CREATE_PO: { roles: PROCUREMENT },
  APPROVE_PO_OPS: { roles: ['operationsManager'] },
  APPROVE_PO_FAD: { roles: ['fad'] },
  // Steps 20–21: the Store Keeper receives the goods and records the GRN.
  PREPARE_LOCAL_RECEIVE: { roles: ['operations'] },
  POST_LOCAL_RECEIVE: { roles: ['operations'] },
  CREATE_LOCAL_INVOICE: { roles: PROCUREMENT },
  APPROVE_INVOICE_OPS: { roles: ['operationsManager'] },
  VERIFY_PO_GRN_INVOICE: { roles: ['financeChecker'] },
  APPROVE_PAYMENT_FAD: { roles: ['fad'] },
  CLOSE_LPR_AFTER_PAYMENT: { roles: ['financeChecker'], needsPayload: true },
  FIX_LOCAL_CURRENCY: { roles: [...PROCUREMENT, 'financeChecker'] },
  SEND_BACK_RFQ: { roles: ['operationsManager', 'fad'], commentRequired: true },
  SEND_BACK_PO: { roles: ['operationsManager', 'fad'], commentRequired: true },
  RESUBMIT_PO: { roles: PROCUREMENT },
}

/** BC captions from the Local RFQ / Purchase Order ribbons. */
export const LOCAL_PURCHASE_ACTION_LABELS: Record<string, string> = {
  SUBMIT_LPR_OPS: 'Submit to Operations Manager',
  UPDATE_LPR_LINE: 'Save LPR line',
  UPDATE_LPR_HEADER: 'Save LPR card',
  ADD_LPR_LINE: 'Add LPR line',
  DELETE_LPR_LINE: 'Delete LPR line',
  UPDATE_RFQ_HEADER: 'Save Local RFQ',
  UPDATE_RFQ_LINE: 'Save RFQ line',
  ADD_RFQ_LINE: 'Add RFQ line',
  DELETE_RFQ_LINE: 'Delete RFQ line',
  DELETE_VENDOR_QUOTE: 'Delete vendor quote',
  UPDATE_PO_HEADER: 'Save Purchase Order',
  UPDATE_PO_LINE: 'Save PO line',
  ADD_PO_LINE: 'Add PO line',
  DELETE_PO_LINE: 'Delete PO line',
  UPDATE_PO_RECEIVE: 'Save receive quantities',
  APPROVE_LPR_OPS: 'Approve (Operations Manager)',
  APPROVE_LPR_FAD: 'Approve (FAD)',
  REJECT_LPR: 'Reject LPR',
  CONVERT_TO_RFQ: 'Convert to RFQ',
  APPROVE_RFQ_OPS: 'Approve RFQ (Operations Manager)',
  UPSERT_VENDOR_QUOTE: 'Vendor Quotes (Local RFQ)',
  AUTO_SELECT_WINNER: 'Auto Select Winner',
  SEND_FOR_OPS_REVIEW: 'Send for Operations Manager Review',
  SEND_TO_TECHNICAL: 'Send to Technical (Operations Manager)',
  SEND_FOR_FAD_APPROVAL: 'Send for FAD Approval (no Technical)',
  SUBMIT_TECHNICAL_REVIEW: 'Submit Technical Review',
  SELECT_WINNER_FAD: 'Change Winner (FAD)',
  APPROVE_WINNER_FAD_FINAL: 'Approve Winner (FAD Final)',
  SEND_BACK_RFQ: 'Send back to Procurement',
  CREATE_PO: 'Create Purchase Order',
  APPROVE_PO_OPS: 'Approve Local PO (Operations Manager)',
  APPROVE_PO_FAD: 'Approve Local PO (FAD)',
  SEND_BACK_PO: 'Send back PO to Procurement',
  RESUBMIT_PO: 'Resubmit PO to Operations Manager',
  PREPARE_LOCAL_RECEIVE: 'Prepare Local Receive',
  POST_LOCAL_RECEIVE: 'Post Receive (GRN)',
  FIX_LOCAL_CURRENCY: 'Fix Local Currency',
  CREATE_LOCAL_INVOICE: 'Create Local Invoice',
  APPROVE_INVOICE_OPS: 'Approve Invoice (Operations Manager)',
  VERIFY_PO_GRN_INVOICE: 'Verify PO + GRN + Invoice',
  APPROVE_PAYMENT_FAD: 'Approve Payment (F&A)',
  CLOSE_LPR_AFTER_PAYMENT: 'Pay Vendor & Close LPR',
  ISSUE_AFTER_LPR: 'Issue after LPR receive',
}

type ChainDoc = { no?: unknown; flowStage?: unknown; lprStatus?: unknown; createdRfqNo?: unknown; createdPoNo?: unknown }

/** Shape returned by BC PortalLocalPurchaseChain (Portal Procurement Mgt. GetLocalPurchaseChain). */
export type LocalPurchaseChain = {
  documentNo?: string
  storeRequisitionNo?: string
  lpr?: ChainDoc & Record<string, unknown>
  rfq?: ChainDoc & Record<string, unknown>
  po?: ChainDoc & Record<string, unknown>
  receipts?: Array<Record<string, unknown>>
}

export type LocalPurchaseNextAction = {
  actionCode: string
  label: string
  /** Which document in the chain the action runs on. */
  target: 'lpr' | 'rfq' | 'po' | 'storeRequisition'
  documentNo: string
  /** True when the signed-in user owns this step. */
  allowed: boolean
  ownerRoles: LocalPurchaseRole[]
  commentRequired?: boolean
}

type StageAction = string | { code: string; roles: LocalPurchaseRole[] }

/**
 * Keyed by BC Flow Stage. BC sends the caption (Format), so both the member name and the
 * caption are listed (e.g. "Pending Ops RFQ" / "Pending Operations Manager RFQ").
 */
const RFQ_STAGE_ACTIONS: Record<string, StageAction[]> = {
  'PENDING OPS RFQ': ['APPROVE_RFQ_OPS'],
  'PENDING OPERATIONS MANAGER RFQ': ['APPROVE_RFQ_OPS'],
  'RFQ OPEN': ['UPSERT_VENDOR_QUOTE', 'AUTO_SELECT_WINNER'],
  'WINNER SELECTED': ['UPSERT_VENDOR_QUOTE', 'AUTO_SELECT_WINNER', 'SEND_FOR_OPS_REVIEW'],
  'PENDING OPS EVALUATION': [
    'SEND_TO_TECHNICAL',
    'SEND_FOR_FAD_APPROVAL',
    { code: 'SEND_BACK_RFQ', roles: ['operationsManager'] },
  ],
  'PENDING OPERATIONS MANAGER EVALUATION': [
    'SEND_TO_TECHNICAL',
    'SEND_FOR_FAD_APPROVAL',
    { code: 'SEND_BACK_RFQ', roles: ['operationsManager'] },
  ],
  'PENDING TECHNICAL': ['SUBMIT_TECHNICAL_REVIEW'],
  'PENDING FAD FINAL': ['SELECT_WINNER_FAD', 'APPROVE_WINNER_FAD_FINAL', { code: 'SEND_BACK_RFQ', roles: ['fad'] }],
  'READY FOR PO': ['CREATE_PO', { code: 'SEND_BACK_RFQ', roles: ['fad'] }],
}

/** Operations Manager approves first, then FAD (BC ApproveLocalPurchaseOrder → ApprovePOAsFad). */
const PO_STAGE_ACTIONS: Record<string, StageAction[]> = {
  'PO CREATED': ['APPROVE_PO_OPS', 'SEND_BACK_PO'],
  'PENDING FINANCE PO': ['APPROVE_PO_OPS', 'SEND_BACK_PO'],
  'PENDING OPERATIONS MANAGER PO': ['APPROVE_PO_OPS', 'SEND_BACK_PO'],
  'PENDING FAD PO': ['APPROVE_PO_FAD', { code: 'SEND_BACK_PO', roles: ['fad'] }],
  'RETURNED TO PROCUREMENT': ['RESUBMIT_PO', 'FIX_LOCAL_CURRENCY'],
  'PO RELEASED': ['PREPARE_LOCAL_RECEIVE', 'POST_LOCAL_RECEIVE', 'FIX_LOCAL_CURRENCY'],
  'GOODS RECEIVED': ['CREATE_LOCAL_INVOICE'],
  'PENDING OPS INVOICE': ['APPROVE_INVOICE_OPS'],
  'PENDING OPERATIONS MANAGER INVOICE': ['APPROVE_INVOICE_OPS'],
  'PENDING INVOICE CHECK': ['VERIFY_PO_GRN_INVOICE'],
  'PENDING CEO PAYMENT': ['APPROVE_PAYMENT_FAD'],
  'PENDING F&A PAYMENT APPROVAL': ['APPROVE_PAYMENT_FAD'],
  'PAYMENT APPROVED': ['CLOSE_LPR_AFTER_PAYMENT'],
}

/** PO stages at which received stock exists for Store Keeper "Issue after LPR receive". */
const RECEIVED_PO_STAGES = new Set([
  'GOODS RECEIVED',
  'PENDING OPS INVOICE',
  'PENDING OPERATIONS MANAGER INVOICE',
  'INVOICE CREATED',
  'PENDING INVOICE CHECK',
  'INVOICE VERIFIED',
  'PENDING CEO PAYMENT',
  'PENDING F&A PAYMENT APPROVAL',
  'PAYMENT APPROVED',
  'LPR CLOSED',
])

function chainText(value: unknown) {
  return String(value ?? '').trim()
}

function stageKey(value: unknown) {
  return chainText(value).toUpperCase().replace(/\s+/g, ' ')
}

/**
 * Whether the LPR card (General and lines) can be edited now — the BC card's rule (Internal
 * Requisitions U, UpdateControls): Draft while Open, or after approval until the RFQ exists.
 * BC also checks that the user is the assigned Procurement Officer.
 */
export function localPurchaseCardEditable(chain: LocalPurchaseChain) {
  const lpr = chain.lpr
  if (!lpr) return false
  const lprStatus = stageKey(lpr.lprStatus)
  const status = stageKey((lpr as Record<string, unknown>).status)
  if (lprStatus === 'DRAFT') return status === '' || status === 'OPEN'
  return (lprStatus === 'APPROVED' || status === 'RELEASED') && !chainText(lpr.createdRfqNo) && !chain.rfq
}

/**
 * Which cards in the chain the signed-in user may edit now, by BC's rule for each card: the LPR
 * (localPurchaseCardEditable), the Local RFQ and the Local PO while BC reports their lines unlocked
 * (BC 1.0.3.569 sends linesLocked; older apps never unlock), and the receive quantities at PO Released.
 * Procurement edits the documents; the Store Keeper enters what is received. BC checks again on save.
 */
export function localPurchaseEditing(chain: LocalPurchaseChain, roles: LocalPurchaseRole[]) {
  const procurement = roles.some((role) => PROCUREMENT.includes(role))
  const unlocked = (doc: Record<string, unknown> | undefined) =>
    Boolean(doc) && String(doc?.linesLocked ?? '').toLowerCase() === 'false' && Array.isArray(doc?.lines)
  return {
    lpr: procurement && localPurchaseCardEditable(chain),
    rfq: procurement && unlocked(chain.rfq) && !chainText(chain.rfq?.createdPoNo),
    po: procurement && unlocked(chain.po),
    receive: roles.includes('operations') && stageKey(chain.po?.flowStage) === 'PO RELEASED' && Array.isArray(chain.po?.lines),
  }
}

/** True once the Local PO's goods are received (GRN posted), so the store can issue them. */
export function localPurchaseReceived(chain: LocalPurchaseChain) {
  return RECEIVED_PO_STAGES.has(stageKey(chain.po?.flowStage))
}

/**
 * Where a store requisition's LPR is now, as on the BC Purchase Requisition Card: LPR Status,
 * Process Step (from template) and the furthest document in the chain (PO, else RFQ, else LPR).
 */
export function localPurchaseProgress(chain: LocalPurchaseChain) {
  const current = chain.po ?? chain.rfq ?? chain.lpr
  return {
    lprNo: chainText(chain.lpr?.no),
    lprStatus: chainText(chain.lpr?.lprStatus),
    assignedProcUserId: chainText(chain.lpr?.assignedProcUserId),
    currentDocumentNo: chainText(current?.no),
    flowStage: chainText(current?.flowStage),
    processStep: chainText(current?.processStep) || chainText(chain.lpr?.processStep),
    received: localPurchaseReceived(chain),
  }
}

/**
 * Next Local Purchase step(s) from BC Full Flow Stage. The current step lives on the
 * furthest document in the chain (PO, else RFQ, else LPR), matching the BC ribbon.
 */
export function localPurchaseNextActions(
  chain: LocalPurchaseChain,
  roles: LocalPurchaseRole[],
): LocalPurchaseNextAction[] {
  const codes: Array<{
    code: string
    target: LocalPurchaseNextAction['target']
    documentNo: string
    roles?: LocalPurchaseRole[]
  }> = []
  const push = (action: StageAction, target: LocalPurchaseNextAction['target'], documentNo: string) =>
    codes.push(typeof action === 'string' ? { code: action, target, documentNo } : { ...action, target, documentNo })
  const lprNo = chainText(chain.lpr?.no)
  const rfqNo = chainText(chain.rfq?.no) || chainText(chain.lpr?.createdRfqNo)
  const poNo = chainText(chain.po?.no) || chainText(chain.rfq?.createdPoNo)
  const poStage = stageKey(chain.po?.flowStage)

  if (poNo && chain.po) {
    for (const action of PO_STAGE_ACTIONS[poStage] ?? []) push(action, 'po', poNo)
  } else if (rfqNo && chain.rfq) {
    for (const action of RFQ_STAGE_ACTIONS[stageKey(chain.rfq.flowStage)] ?? []) push(action, 'rfq', rfqNo)
  } else if (lprNo && chain.lpr) {
    const lprStatus = stageKey(chain.lpr.lprStatus)
    const lprStage = stageKey(chain.lpr.flowStage)
    if (lprStatus === 'DRAFT' || lprStage === 'LPR DRAFT') {
      // Step 7: the assigned Procurement Officer prepares the LPR, then sends it to the Operations Manager.
      push('UPDATE_LPR_LINE', 'lpr', lprNo)
      push('SUBMIT_LPR_OPS', 'lpr', lprNo)
    } else if (
      lprStatus === 'PENDING OPERATIONS' ||
      lprStatus === 'PENDING OPERATIONS MANAGER' ||
      lprStage === 'PENDING OPERATIONS' ||
      lprStage === 'PENDING OPERATIONS MANAGER'
    ) {
      push('APPROVE_LPR_OPS', 'lpr', lprNo)
      push({ code: 'REJECT_LPR', roles: ['operationsManager'] }, 'lpr', lprNo)
    } else if (lprStatus === 'PENDING FINANCE' || lprStatus === 'PENDING FINANCE & ADMIN' || lprStage === 'PENDING FAD') {
      push('APPROVE_LPR_FAD', 'lpr', lprNo)
      push({ code: 'REJECT_LPR', roles: ['fad'] }, 'lpr', lprNo)
    } else if (!rfqNo && (lprStatus === 'APPROVED' || lprStage === 'READY FOR RFQ')) {
      codes.push({ code: 'CONVERT_TO_RFQ', target: 'lpr', documentNo: lprNo })
    }
  }

  const storeReqNo = chainText(chain.storeRequisitionNo)
  if (storeReqNo && localPurchaseReceived(chain)) {
    codes.push({ code: 'ISSUE_AFTER_LPR', target: 'storeRequisition', documentNo: storeReqNo })
  }

  return codes.map(({ code, target, documentNo, roles: stageRoles }) => {
    const rule =
      code === 'ISSUE_AFTER_LPR' ? LOCAL_PURCHASE_STORE_ACTIONS.ISSUE_AFTER_LPR : LOCAL_PURCHASE_ACTIONS[code]
    const ownerRoles = stageRoles ?? rule?.roles ?? []
    return {
      actionCode: code,
      label: LOCAL_PURCHASE_ACTION_LABELS[code] ?? code,
      target,
      documentNo,
      ownerRoles,
      allowed: ownerRoles.some((role) => roles.includes(role)),
      commentRequired: Boolean((rule as { commentRequired?: boolean } | undefined)?.commentRequired),
    }
  })
}

/** Document numbers that belong to the chain (guards POST documentNo against unrelated docs). */
export function localPurchaseChainDocumentNos(chain: LocalPurchaseChain): string[] {
  return [chain.lpr?.no, chain.rfq?.no, chain.po?.no, chain.lpr?.createdRfqNo, chain.rfq?.createdPoNo]
    .map((value) => chainText(value).toUpperCase())
    .filter(Boolean)
}

/**
 * Store-requisition process actions for Local Purchase: the Store Keeper confirms the item is
 * unavailable (step 5), the Store Manager starts the LPR with the project (step 6).
 */
export const LOCAL_PURCHASE_STORE_ACTIONS = {
  REQUEST_FOR_LPR: { roles: ['operations'] as LocalPurchaseRole[] },
  START_LPR: { roles: ['operations'] as LocalPurchaseRole[] },
  ISSUE_AFTER_LPR: { roles: ['operations'] as LocalPurchaseRole[] },
}

const BC_ROLE_NAMES = new Set<LocalPurchaseRole>([
  'operationsManager',
  'procurement',
  'projectProcurement',
  'fad',
  'technical',
  'financeChecker',
  'ceo',
  'auditor',
])

/** Store Keeper detection — the same rule 382 uses for store-process actions. */
export function isStoreOperator(authUser: LocalPurchaseAuth) {
  const text = [...(authUser.roles ?? []), authUser.jobTitle, authUser.department, authUser.departmentName]
    .map((value) => String(value ?? '').trim().toLowerCase())
    .filter(Boolean)
    .join(' ')
  return /(^|[^a-z])(operations?|ops|store|storekeeper|warehouse|inventory)([^a-z]|$)/.test(text)
}

/** Parse BC PortalLocalPurchaseRoles: {"roles":["fad",...]} — unknown names are dropped. */
export function parseBcLocalPurchaseRoles(returnValue: unknown): LocalPurchaseRole[] {
  const roles = parseSoapJson(returnValue).roles
  if (!Array.isArray(roles)) {
    throw Object.assign(new Error('Business Central returned an invalid Local Purchase roles response.'), {
      status: 502,
      code: 'LPR_ROLES_INVALID',
    })
  }
  const known = [...BC_ROLE_NAMES]
  return [...new Set(roles.map((role) => known.find((name) => name.toLowerCase() === String(role).trim().toLowerCase())))].filter(
    (role): role is LocalPurchaseRole => Boolean(role),
  )
}

export type LocalPurchaseAccess = {
  /** False when the installed BC app has no Local Purchase portal methods (e.g. 1.0.3.310). */
  enabled: boolean
  /** BC ABH Local Proc Setup roles + 'operations' for Store Keepers. */
  roles: LocalPurchaseRole[]
  reason?: string
}

type SoapCall = (method: string, params: Record<string, unknown>) => Promise<{ returnValue?: unknown }>

const ACCESS_TTL_MS = 60_000
const accessCache = new Map<string, { at: number; access: LocalPurchaseAccess }>()

/**
 * Whether Local Purchase is live in BC and which LPR roles BC grants this user. BC is the
 * authority (ABH Local Proc Setup); the portal never infers LPR roles from job titles.
 * Any failure keeps Local Purchase off, so the portal behaves exactly as 1.0.3.382.
 */
export async function resolveLocalPurchaseAccess(
  authUser: LocalPurchaseAuth,
  soap: SoapCall,
  now = Date.now(),
): Promise<LocalPurchaseAccess> {
  const userId = String(authUser.userID ?? '').trim()
  const key = userId.toUpperCase()
  const cached = accessCache.get(key)
  if (cached && now - cached.at < ACCESS_TTL_MS) return withStoreRole(cached.access, authUser)
  let access: LocalPurchaseAccess
  if (!userId) {
    access = { enabled: false, roles: [], reason: 'No Business Central user is linked to this employee.' }
  } else {
    try {
      const result = await soap('PortalLocalPurchaseRoles', { actorUserID: userId })
      access = { enabled: true, roles: parseBcLocalPurchaseRoles(result.returnValue) }
    } catch (error) {
      access = {
        enabled: false,
        roles: [],
        reason: error instanceof Error ? error.message : String(error),
      }
    }
  }
  accessCache.set(key, { at: now, access })
  return withStoreRole(access, authUser)
}

/** Last resolved access without calling BC (list filters); null when not resolved yet. */
export function cachedLocalPurchaseAccess(authUser: LocalPurchaseAuth, now = Date.now()) {
  const cached = accessCache.get(String(authUser.userID ?? '').trim().toUpperCase())
  if (!cached || now - cached.at >= ACCESS_TTL_MS) return null
  return withStoreRole(cached.access, authUser)
}

export function clearLocalPurchaseAccessCache() {
  accessCache.clear()
}

function withStoreRole(access: LocalPurchaseAccess, authUser: LocalPurchaseAuth): LocalPurchaseAccess {
  if (!access.enabled || !isStoreOperator(authUser) || access.roles.includes('operations')) return access
  return { ...access, roles: [...access.roles, 'operations'] }
}

/** True when BC grants this user any LPR role (Operations Manager, Procurement, FAD, Technical, Finance Checker, CEO, Auditor). */
export function hasBcLocalPurchaseRole(access: LocalPurchaseAccess | null) {
  return Boolean(access?.enabled && access.roles.some((role) => BC_ROLE_NAMES.has(role)))
}

export function assertLocalPurchaseActionAllowed(
  roles: LocalPurchaseRole[],
  actionCode: string,
  actionComment = '',
  hasPayload = false,
) {
  const action = actionCode.trim().toUpperCase()
  const rule = LOCAL_PURCHASE_ACTIONS[action]
  if (!rule) {
    throw Object.assign(new Error(`Unknown Local Purchase action ${action}.`), {
      status: 422,
      code: 'UNKNOWN_LPR_ACTION',
    })
  }
  if (!rule.roles.some((role) => roles.includes(role))) {
    throw Object.assign(
      new Error(`Your role is not authorized to perform ${action}.`),
      { status: 403, code: 'LPR_ACTION_FORBIDDEN' },
    )
  }
  if (rule.commentRequired && !actionComment.trim()) {
    throw Object.assign(new Error(`A comment is required for ${action}.`), {
      status: 422,
      code: 'LPR_ACTION_COMMENT_REQUIRED',
    })
  }
  if (rule.needsPayload && !hasPayload) {
    throw Object.assign(new Error(`payload is required for ${action}.`), {
      status: 422,
      code: 'LPR_ACTION_PAYLOAD_REQUIRED',
    })
  }
  return action
}

export function parseSoapJson(returnValue: unknown): Record<string, unknown> {
  if (returnValue && typeof returnValue === 'object' && !Array.isArray(returnValue)) {
    return returnValue as Record<string, unknown>
  }
  const raw = String(returnValue ?? '').trim()
  if (!raw) return {}
  try {
    return JSON.parse(raw) as Record<string, unknown>
  } catch {
    return { raw }
  }
}

/** BC vendors for the vendor-quote Vendor No. lookup: codeunit rows ({no, name}) or OData rows ({No, Name}). */
export function normalizeLprVendors(rows: unknown): Array<{ no: string; name: string }> {
  const seen = new Set<string>()
  const vendors: Array<{ no: string; name: string }> = []
  for (const row of Array.isArray(rows) ? rows : []) {
    if (!row || typeof row !== 'object') continue
    const record = row as Record<string, unknown>
    const no = String(record.no ?? record.No ?? '').trim()
    if (!no || seen.has(no.toUpperCase())) continue
    seen.add(no.toUpperCase())
    vendors.push({ no, name: String(record.name ?? record.Name ?? '').trim() })
  }
  return vendors
}
