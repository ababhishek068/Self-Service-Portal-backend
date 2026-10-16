/**
 * Local Purchase (LPR → RFQ → PO → pay) portal actions.
 * Mirrors the BC UAT recording + ABH Local Procurement procedures exposed via
 * SOAP PortalLocalPurchaseAction / PortalListVendorQuotes.
 */

export type LocalPurchaseRole =
  | 'operations'
  | 'procurement'
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

/** Actions that call PortalLocalPurchaseAction in Business Central. */
export const LOCAL_PURCHASE_ACTIONS: Record<
  string,
  { roles: LocalPurchaseRole[]; needsPayload?: boolean; commentRequired?: boolean }
> = {
  APPROVE_LPR_FAD: { roles: ['fad', 'finance'] },
  REJECT_LPR: { roles: ['fad', 'finance'], commentRequired: true },
  CONVERT_TO_RFQ: { roles: ['procurement'] },
  UPSERT_VENDOR_QUOTE: { roles: ['procurement'], needsPayload: true },
  AUTO_SELECT_WINNER: { roles: ['procurement'] },
  SEND_TO_TECHNICAL: { roles: ['procurement'] },
  SEND_FOR_FAD_APPROVAL: { roles: ['procurement'] },
  SUBMIT_TECHNICAL_REVIEW: { roles: ['technical'], commentRequired: true },
  SELECT_WINNER_FAD: { roles: ['fad', 'finance'] },
  APPROVE_WINNER_FAD_FINAL: { roles: ['fad', 'finance'] },
  CREATE_PO: { roles: ['procurement'] },
  APPROVE_PO_FINANCE_CHECKER: { roles: ['financeChecker', 'finance'] },
  APPROVE_PO_FAD: { roles: ['fad', 'finance'] },
  PREPARE_LOCAL_RECEIVE: { roles: ['procurement'] },
  CREATE_LOCAL_INVOICE: { roles: ['procurement'] },
  VERIFY_PO_GRN_INVOICE: { roles: ['financeChecker', 'finance'] },
  APPROVE_PAYMENT_CEO: { roles: ['ceo', 'finance'] },
  CLOSE_LPR_AFTER_PAYMENT: { roles: ['financeChecker', 'finance'] },
  FIX_LOCAL_CURRENCY: { roles: ['procurement', 'financeChecker', 'finance'] },
  POST_LOCAL_RECEIVE: { roles: ['procurement'] },
  SEND_BACK_RFQ: { roles: ['fad', 'finance'], commentRequired: true },
  SEND_BACK_PO: { roles: ['financeChecker', 'fad', 'finance'], commentRequired: true },
  RESUBMIT_PO: { roles: ['procurement'] },
}

/** BC captions from the UAT recording / Local RFQ steps ribbon. */
export const LOCAL_PURCHASE_ACTION_LABELS: Record<string, string> = {
  APPROVE_LPR_FAD: 'Approve (FAD)',
  REJECT_LPR: 'Reject LPR',
  CONVERT_TO_RFQ: 'Convert to RFQ',
  UPSERT_VENDOR_QUOTE: 'Vendor Quotes (Local RFQ)',
  AUTO_SELECT_WINNER: 'Auto Select Winner',
  SEND_TO_TECHNICAL: 'Send to Technical (optional)',
  SEND_FOR_FAD_APPROVAL: 'Send for FAD Approval (skip Technical)',
  SUBMIT_TECHNICAL_REVIEW: 'Submit Technical Review',
  SELECT_WINNER_FAD: 'Change Winner (FAD)',
  APPROVE_WINNER_FAD_FINAL: 'Approve Winner (FAD Final)',
  SEND_BACK_RFQ: 'Send back to Procurement',
  CREATE_PO: 'Create Purchase Order',
  APPROVE_PO_FINANCE_CHECKER: 'Approve Local PO (Finance Checker)',
  APPROVE_PO_FAD: 'Approve Local PO (FAD)',
  SEND_BACK_PO: 'Send back PO to Procurement',
  RESUBMIT_PO: 'Resubmit PO to Finance Checker',
  PREPARE_LOCAL_RECEIVE: 'Prepare Local Receive',
  POST_LOCAL_RECEIVE: 'Post Receive (GRN)',
  FIX_LOCAL_CURRENCY: 'Fix Local Currency',
  CREATE_LOCAL_INVOICE: 'Create Local Invoice',
  VERIFY_PO_GRN_INVOICE: 'Verify PO + GRN + Invoice',
  APPROVE_PAYMENT_CEO: 'Approve Payment (CEO)',
  CLOSE_LPR_AFTER_PAYMENT: 'Payment Voucher & Close LPR',
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

const RFQ_STAGE_ACTIONS: Record<string, string[]> = {
  'RFQ OPEN': ['UPSERT_VENDOR_QUOTE', 'AUTO_SELECT_WINNER'],
  'WINNER SELECTED': ['UPSERT_VENDOR_QUOTE', 'AUTO_SELECT_WINNER', 'SEND_TO_TECHNICAL', 'SEND_FOR_FAD_APPROVAL'],
  'PENDING TECHNICAL': ['SUBMIT_TECHNICAL_REVIEW'],
  'PENDING FAD FINAL': ['SELECT_WINNER_FAD', 'APPROVE_WINNER_FAD_FINAL', 'SEND_BACK_RFQ'],
  'READY FOR PO': ['CREATE_PO', 'SEND_BACK_RFQ'],
}

/** Finance Checker approves first, then FAD (BC ApproveLocalPurchaseOrder → ApprovePOAsFad). */
const PO_STAGE_ACTIONS: Record<string, string[]> = {
  'PO CREATED': ['APPROVE_PO_FINANCE_CHECKER', 'SEND_BACK_PO'],
  'PENDING FINANCE PO': ['APPROVE_PO_FINANCE_CHECKER', 'SEND_BACK_PO'],
  'PENDING FAD PO': ['APPROVE_PO_FAD', 'SEND_BACK_PO'],
  'RETURNED TO PROCUREMENT': ['RESUBMIT_PO', 'FIX_LOCAL_CURRENCY'],
  'PO RELEASED': ['PREPARE_LOCAL_RECEIVE', 'POST_LOCAL_RECEIVE', 'FIX_LOCAL_CURRENCY'],
  'GOODS RECEIVED': ['CREATE_LOCAL_INVOICE'],
  'INVOICE CREATED': ['VERIFY_PO_GRN_INVOICE'],
  'PENDING INVOICE CHECK': ['VERIFY_PO_GRN_INVOICE'],
  'PENDING CEO PAYMENT': ['APPROVE_PAYMENT_CEO'],
  'PAYMENT APPROVED': ['CLOSE_LPR_AFTER_PAYMENT'],
}

/** PO stages at which received stock exists for Store Keeper "Issue after LPR receive". */
const RECEIVED_PO_STAGES = new Set([
  'GOODS RECEIVED',
  'INVOICE CREATED',
  'PENDING INVOICE CHECK',
  'INVOICE VERIFIED',
  'PENDING CEO PAYMENT',
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
 * Next Local Purchase step(s) from BC Full Flow Stage. The current step lives on the
 * furthest document in the chain (PO, else RFQ, else LPR), matching the BC ribbon.
 */
export function localPurchaseNextActions(
  chain: LocalPurchaseChain,
  roles: LocalPurchaseRole[],
): LocalPurchaseNextAction[] {
  const codes: Array<{ code: string; target: LocalPurchaseNextAction['target']; documentNo: string }> = []
  const lprNo = chainText(chain.lpr?.no)
  const rfqNo = chainText(chain.rfq?.no) || chainText(chain.lpr?.createdRfqNo)
  const poNo = chainText(chain.po?.no) || chainText(chain.rfq?.createdPoNo)
  const poStage = stageKey(chain.po?.flowStage)

  if (poNo && chain.po) {
    for (const code of PO_STAGE_ACTIONS[poStage] ?? []) codes.push({ code, target: 'po', documentNo: poNo })
  } else if (rfqNo && chain.rfq) {
    for (const code of RFQ_STAGE_ACTIONS[stageKey(chain.rfq.flowStage)] ?? []) {
      codes.push({ code, target: 'rfq', documentNo: rfqNo })
    }
  } else if (lprNo && chain.lpr) {
    const lprStatus = stageKey(chain.lpr.lprStatus)
    const lprStage = stageKey(chain.lpr.flowStage)
    if (lprStatus === 'PENDING FINANCE' || lprStatus === 'PENDING FINANCE & ADMIN' || lprStage === 'PENDING FAD') {
      codes.push({ code: 'APPROVE_LPR_FAD', target: 'lpr', documentNo: lprNo })
      codes.push({ code: 'REJECT_LPR', target: 'lpr', documentNo: lprNo })
    } else if (!rfqNo && (lprStatus === 'APPROVED' || lprStage === 'READY FOR RFQ')) {
      codes.push({ code: 'CONVERT_TO_RFQ', target: 'lpr', documentNo: lprNo })
    }
  }

  const storeReqNo = chainText(chain.storeRequisitionNo)
  if (storeReqNo && RECEIVED_PO_STAGES.has(poStage)) {
    codes.push({ code: 'ISSUE_AFTER_LPR', target: 'storeRequisition', documentNo: storeReqNo })
  }

  return codes.map(({ code, target, documentNo }) => {
    const rule =
      code === 'ISSUE_AFTER_LPR' ? LOCAL_PURCHASE_STORE_ACTIONS.ISSUE_AFTER_LPR : LOCAL_PURCHASE_ACTIONS[code]
    const ownerRoles = rule?.roles ?? []
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

/** Store-requisition process actions added for the Local Purchase video flow. */
export const LOCAL_PURCHASE_STORE_ACTIONS = {
  REQUEST_FOR_LPR: { roles: ['operations'] as LocalPurchaseRole[] },
  ISSUE_AFTER_LPR: { roles: ['operations'] as LocalPurchaseRole[] },
}

const ROLE_NAMES = new Set<LocalPurchaseRole>([
  'operations',
  'procurement',
  'finance',
  'fad',
  'technical',
  'financeChecker',
  'ceo',
  'auditor',
])

/**
 * LOCAL_PURCHASE_ROLE_USERS="ADMIN:fad,LPR_PROCURE:procurement,IT_KEEPER:operations" — mirror the
 * user IDs in BC ABH Local Proc Setup (FAD User ID, Finance Checker User ID, …) when job titles do not say it.
 */
export function parseLocalPurchaseRoleUsers(raw: string | undefined) {
  const map = new Map<string, Set<LocalPurchaseRole>>()
  for (const part of String(raw ?? '').split(',')) {
    const separator = part.lastIndexOf(':')
    if (separator <= 0) continue
    const userId = part.slice(0, separator).trim().toUpperCase()
    const roleText = part.slice(separator + 1).trim()
    const role = [...ROLE_NAMES].find((name) => name.toLowerCase() === roleText.toLowerCase())
    if (!userId || !role) continue
    if (!map.has(userId)) map.set(userId, new Set())
    map.get(userId)!.add(role)
  }
  return map
}

let cachedRoleUsersRaw: string | undefined
let cachedRoleUsers = new Map<string, Set<LocalPurchaseRole>>()

function configuredRoleUsers() {
  const raw = process.env.LOCAL_PURCHASE_ROLE_USERS
  if (raw !== cachedRoleUsersRaw) {
    cachedRoleUsersRaw = raw
    cachedRoleUsers = parseLocalPurchaseRoleUsers(raw)
  }
  return cachedRoleUsers
}

export function localPurchaseRoles(authUser: LocalPurchaseAuth): LocalPurchaseRole[] {
  const roleText = (authUser.roles ?? [])
    .map((role) => String(role).trim().toLowerCase())
    .filter(Boolean)
  const assignment = [authUser.jobTitle, authUser.department, authUser.departmentName]
    .map((value) => String(value ?? '').trim().toLowerCase())
    .filter(Boolean)
    .join(' ')
  const allText = [...roleText, assignment, String(authUser.userID ?? '').toLowerCase()].join(' ')
  const resolved = new Set<LocalPurchaseRole>()

  if (/(^|[^a-z])(operations?|ops|store|storekeeper|warehouse|inventory)([^a-z]|$)/.test(allText)) {
    resolved.add('operations')
  }
  if (/(^|[^a-z])(procurement|proc|purchasing|lpr_procure)([^a-z]|$)/.test(allText)) {
    resolved.add('procurement')
  }
  if (
    /(^|[^a-z])(fad|finance\s*&?\s*admin|finance and admin|lpr_fad)([^a-z]|$)/.test(allText) ||
    /finance and administration/.test(allText)
  ) {
    resolved.add('fad')
  }
  if (/(^|[^a-z])(finance checker|fincheck|lpr_fincheck)([^a-z]|$)/.test(allText)) {
    resolved.add('financeChecker')
  }
  if (/(^|[^a-z])(finance|administration|accounts?|accounting|accountant)([^a-z]|$)/.test(allText)) {
    resolved.add('finance')
  }
  if (/(^|[^a-z])(technical|lpr_tech)([^a-z]|$)/.test(allText)) {
    resolved.add('technical')
  }
  if (/(^|[^a-z])(ceo|coo|lpr_ceo)([^a-z]|$)/.test(allText)) {
    resolved.add('ceo')
  }
  if (/(^|[^a-z])(auditor|audit)([^a-z]|$)/.test(allText)) {
    resolved.add('auditor')
  }
  const roleUsers = configuredRoleUsers()
  for (const id of [authUser.userID, authUser.employeeNo]) {
    for (const role of roleUsers.get(String(id ?? '').trim().toUpperCase()) ?? []) resolved.add(role)
  }
  return [...resolved]
}

export function assertLocalPurchaseActionAllowed(
  authUser: LocalPurchaseAuth,
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
  const roles = localPurchaseRoles(authUser)
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
