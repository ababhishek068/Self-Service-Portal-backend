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
}

/** Store-requisition process actions added for the Local Purchase video flow. */
export const LOCAL_PURCHASE_STORE_ACTIONS = {
  REQUEST_FOR_LPR: { roles: ['operations'] as LocalPurchaseRole[] },
  ISSUE_AFTER_LPR: { roles: ['operations'] as LocalPurchaseRole[] },
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
