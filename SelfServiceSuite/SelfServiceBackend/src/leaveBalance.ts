import type { ODataRecord } from './bcClient.js'

const ANNUAL_LEAVE_BALANCE_KEYS = [
  'AnnualLeaveBalance',
  'Annual_Leave_Balance',
  'Annual_Leave_balance',
  'AnnualLeave_Balance',
  'AnnualLeavebalance',
  'Annual_Leave_Bala',
  'AnnualLeaveBal',
  'Annual_Leave_Bal',
  'TotalLeaveBalance',
  'Total_Leave_Balance',
] as const

function normalizeODataKey(key: string) {
  return key.replace(/[^a-zA-Z0-9]/g, '').toLowerCase()
}

function parseNumeric(value: unknown) {
  if (value === null || value === undefined || value === '') return null
  const numeric = Number(String(value).replaceAll(',', ''))
  return Number.isFinite(numeric) ? numeric : null
}

function fieldNumber(row: ODataRecord | null | undefined, keys: readonly string[]) {
  if (!row) return null
  for (const key of keys) {
    const numeric = parseNumeric(row[key])
    if (numeric !== null) return numeric
  }
  return null
}

function isAnnualBalanceKey(key: string) {
  const normalized = normalizeODataKey(key)
  if (normalized.includes('worked') || normalized.includes('birr') || normalized.includes('receipt')) {
    return false
  }
  if (normalized.includes('annual') && (normalized.includes('balance') || normalized.includes('bala'))) {
    return true
  }
  return (
    normalized === 'annualleavebalance' ||
    normalized === 'annualleavebala' ||
    normalized === 'annualleavebal' ||
    normalized.endsWith('annualleavebalance')
  )
}

export function discoverAnnualLeaveBalance(row: ODataRecord | null | undefined) {
  if (!row) return null

  let best: number | null = null
  for (const [key, value] of Object.entries(row)) {
    if (!isAnnualBalanceKey(key)) continue
    const numeric = parseNumeric(value)
    if (numeric === null || numeric <= 0) continue
    if (best === null || numeric > best) best = numeric
  }
  return best
}

/** Read the BC employee-card annual leave balance, never the generic LeaveBalance (-31). */
export function employeeAnnualLeaveBalance(row: ODataRecord | null | undefined) {
  const explicit = fieldNumber(row, ANNUAL_LEAVE_BALANCE_KEYS)
  if (explicit !== null && explicit > 0) return explicit

  const discovered = discoverAnnualLeaveBalance(row)
  if (discovered !== null) return discovered

  const genericBalance = fieldNumber(row, ['LeaveBalance', 'Leave_Balance'])
  if (genericBalance !== null && genericBalance > 0) return genericBalance

  return null
}

export function positiveSessionAnnualBalance(value: unknown) {
  const numeric = Number(value)
  if (!Number.isFinite(numeric) || numeric <= 0) return null
  return numeric
}

export function resolveAnnualLeaveBalance(
  metrics: { annualLeaveBalance: number | null; earnedLeaveDays: number | null },
  ledgerNet: number,
  leaveTypeDays: number,
) {
  if (metrics.annualLeaveBalance !== null && metrics.annualLeaveBalance > 0) {
    return metrics.annualLeaveBalance
  }
  if (ledgerNet > 0) return ledgerNet
  if (leaveTypeDays > 0) return leaveTypeDays
  if (metrics.earnedLeaveDays !== null && metrics.earnedLeaveDays > 0) {
    return metrics.earnedLeaveDays
  }
  return Math.max(0, ledgerNet)
}

export function resolveAnnualLeaveEntitlement(
  metrics: { annualLeaveBalance: number | null; earnedLeaveDays: number | null },
  leaveTypeDays: number,
) {
  if (metrics.annualLeaveBalance !== null && metrics.annualLeaveBalance > 0) {
    return metrics.annualLeaveBalance
  }
  if (leaveTypeDays > 0) return leaveTypeDays
  if (metrics.earnedLeaveDays !== null && metrics.earnedLeaveDays > 0) {
    return metrics.earnedLeaveDays
  }
  return leaveTypeDays
}

export function employeeLeaveMetrics(
  row: ODataRecord | null | undefined,
  sessionLeaveBalance: unknown,
) {
  return {
    annualLeaveBalance:
      employeeAnnualLeaveBalance(row) ?? positiveSessionAnnualBalance(sessionLeaveBalance),
    leaveBalance: fieldNumber(row, ['LeaveBalance', 'Leave_Balance']),
    earnedLeaveDays: fieldNumber(row, [
      'EarnedLeaveDays',
      'Earned_Leave_Days',
      'EarnedLeave',
      'Earned_Leave',
    ]),
  }
}

export function leaveBalanceFieldSnapshot(row: ODataRecord | null | undefined) {
  if (!row) return {}
  const snapshot: Record<string, number> = {}
  for (const [key, value] of Object.entries(row)) {
    const normalized = normalizeODataKey(key)
    if (!normalized.includes('leave') && !normalized.includes('annual') && !normalized.includes('earn')) {
      continue
    }
    const numeric = parseNumeric(value)
    if (numeric === null) continue
    snapshot[key] = numeric
  }
  return snapshot
}

export type BcLeaveSummary = {
  /** Canonical employee-facing entitlement supplied by newer BC builds. */
  leaveEntitlement: number | null
  /** Original carry-forward amount shown on the Employee Card. */
  carryForward: number | null
  /** Balance before leave taken is deducted (entitlement + carry forward + reimbursements). */
  totalAvailableLeaveBalance: number | null
  /** The only balance an employee may apply against. */
  availableLeaveBalance: number | null
  totalLeaveTakenToDate: number | null
  cardAnnualLeaveBalance: number | null
  /** BC's own netted (allocated + reimbursed - taken) balance for the requested
   * leave type — computed server-side by GetLeaveBalance for BOTH annual and
   * non-annual types. Prefer this over `setupDays` for non-annual types so the
   * balance actually reduces as leave is taken, instead of always equalling
   * the raw configured entitlement. */
  currentLeaveBalance: number | null
  earnedLeaveDays: number | null
  /** Leave Accrued To-Date (carry forward + accrued). Preferred over earnedLeaveDays. */
  leaveAccruedToDate: number | null
  /** Period Accrued Days only (BC field "Earned Leave Days"). */
  accruedDays: number | null
  annualLeaveCode: string
  setupDays: number | null
  unlimitedDays: boolean | null
  maximumApplicationDays: number | null
  allocatedDays: number | null
  reimbursedDays: number | null
  carryForwardBalanceForType: number | null
  currentTotalLeaveTaken: number | null
  carryForwardBalance: number | null
  hasOpenEntries: boolean
  openNet: number
  hasCurrentPeriodEntries: boolean
  currentPeriodNet: number
}

/** Parse JSON from CuPortalEmployeeData.GetLeaveBalance (PortalEmployeeDataMgt.Codeunit.al). */
export function parseBcLeaveSummary(rawValue: unknown): BcLeaveSummary | null {
  const raw = String(rawValue ?? '').trim()
  if (!raw) return null
  let parsed: unknown
  try {
    parsed = JSON.parse(raw)
  } catch {
    return null
  }
  if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) return null
  const row = parsed as Record<string, unknown>
  const toNumber = (value: unknown) => {
    if (value === null || value === undefined || String(value).trim() === '') return null
    const numeric = Number(value)
    return Number.isFinite(numeric) ? numeric : null
  }
  return {
    leaveEntitlement: toNumber(row.leaveEntitlement),
    carryForward: toNumber(row.carryForward),
    totalAvailableLeaveBalance: toNumber(row.totalAvailableLeaveBalance),
    availableLeaveBalance: toNumber(row.availableLeaveBalance),
    totalLeaveTakenToDate: toNumber(row.totalLeaveTakenToDate),
    cardAnnualLeaveBalance: toNumber(row.cardAnnualLeaveBalance),
    currentLeaveBalance: toNumber(row.currentLeaveBalance),
    earnedLeaveDays: toNumber(row.earnedLeaveDays),
    leaveAccruedToDate: toNumber(row.leaveAccruedToDate),
    accruedDays: toNumber(row.accruedDays),
    annualLeaveCode: String(row.annualLeaveCode ?? '').trim(),
    setupDays: toNumber(row.setupDays),
    unlimitedDays: typeof row.unlimitedDays === 'boolean' ? row.unlimitedDays : null,
    maximumApplicationDays: toNumber(row.maximumApplicationDays),
    allocatedDays: toNumber(row.allocatedDays),
    reimbursedDays: toNumber(row.reimbursedDays),
    carryForwardBalanceForType: toNumber(row.carryForwardBalanceForType),
    currentTotalLeaveTaken: toNumber(row.currentTotalLeaveTaken),
    carryForwardBalance: toNumber(row.carryForwardBalance),
    hasOpenEntries: row.hasOpenEntries === true,
    openNet: toNumber(row.openNet) ?? 0,
    hasCurrentPeriodEntries: row.hasCurrentPeriodEntries === true,
    currentPeriodNet: toNumber(row.currentPeriodNet) ?? 0,
  }
}

export type LeaveBalanceBreakdown = {
  leaveEntitlement: number
  carryForward: number
  totalAvailableLeaveBalance: number
  leaveAccruedToDate: number | null
  totalLeaveTakenToDate: number
  availableLeaveBalance: number
}

function roundedLeaveValue(value: number) {
  return Math.round(value * 100) / 100
}

/**
 * Present the six leave figures requested by ABH without mixing their meanings.
 *
 * `totalAvailableLeaveBalance` is the remaining full-year entitlement after
 * leave taken. It is informational, not an application limit.
 * `availableLeaveBalance` is the lower of that total and the Employee Card's
 * accrued-to-date figure, and is the only value used to validate a request.
 */
export function resolveLeaveBalanceBreakdown(input: {
  summary: BcLeaveSummary | null
  entitlement: number
  carryForward: number | null
  leaveAccruedToDate: number | null
  totalLeaveTakenToDate: number
  availableLeaveBalance: number
}): LeaveBalanceBreakdown {
  const summary = input.summary
  const leaveEntitlement = roundedLeaveValue(
    summary?.leaveEntitlement ?? summary?.allocatedDays ?? input.entitlement,
  )
  const carryForward = roundedLeaveValue(
    summary?.carryForward ??
      summary?.carryForwardBalanceForType ??
      input.carryForward ??
      0,
  )
  const reimbursements = summary?.reimbursedDays ?? 0
  const totalLeaveTakenToDate = roundedLeaveValue(
    summary?.totalLeaveTakenToDate ??
      summary?.currentTotalLeaveTaken ??
      input.totalLeaveTakenToDate,
  )
  const totalAvailableLeaveBalance = roundedLeaveValue(
    summary?.totalAvailableLeaveBalance ??
      Math.max(0, leaveEntitlement + carryForward + reimbursements - totalLeaveTakenToDate),
  )
  const availableLeaveBalance = roundedLeaveValue(
    summary?.availableLeaveBalance ??
      input.availableLeaveBalance,
  )
  const leaveAccruedToDate =
    summary?.leaveAccruedToDate ?? input.leaveAccruedToDate

  return {
    leaveEntitlement,
    carryForward,
    totalAvailableLeaveBalance,
    leaveAccruedToDate:
      leaveAccruedToDate === null ? null : roundedLeaveValue(leaveAccruedToDate),
    totalLeaveTakenToDate,
    availableLeaveBalance,
  }
}

export function leaveApplicationExceedsAvailableBalance(
  appliedDays: number,
  availableLeaveBalance: number | null,
) {
  if (!Number.isFinite(appliedDays) || appliedDays <= 0) return true
  if (availableLeaveBalance === null || !Number.isFinite(availableLeaveBalance)) return true
  return appliedDays - availableLeaveBalance > 0.0001
}

/**
 * Annual leave may only use what has accrued so far. Older BC builds exposed
 * `currentLeaveBalance` as the full-year entitlement balance; that value is
 * intentionally ignored here because it can include leave not yet accrued.
 */
export function resolveAnnualAvailableLeaveBalance(input: {
  summary: BcLeaveSummary | null
  leaveEntitlement?: number | null
  carryForward?: number | null
  leaveAccruedToDate?: number | null
  totalLeaveTakenToDate?: number | null
}) {
  const explicit = input.summary?.availableLeaveBalance
  if (explicit !== null && explicit !== undefined && Number.isFinite(explicit)) {
    return roundedLeaveValue(Math.max(0, explicit))
  }
  const summary = input.summary
  const accrued = summary?.leaveAccruedToDate ?? input.leaveAccruedToDate ?? null
  const taken =
    summary?.totalLeaveTakenToDate ??
    summary?.currentTotalLeaveTaken ??
    input.totalLeaveTakenToDate ??
    null
  const entitlement =
    summary?.leaveEntitlement ?? summary?.allocatedDays ?? input.leaveEntitlement ?? null
  const carryForward =
    summary?.carryForward ??
    summary?.carryForwardBalanceForType ??
    input.carryForward ??
    null
  const totalAvailable =
    summary?.totalAvailableLeaveBalance ??
    (entitlement === null || carryForward === null || taken === null
      ? null
      : entitlement + carryForward + (summary?.reimbursedDays ?? 0) - taken)
  if (
    accrued === null ||
    totalAvailable === null ||
    !Number.isFinite(accrued) ||
    !Number.isFinite(totalAvailable)
  ) {
    return 0
  }
  return roundedLeaveValue(Math.max(0, Math.min(totalAvailable, accrued)))
}

/**
 * Balance shown to the employee:
 * - Annual: explicit Available Leave Balance, or the lower of accrued-to-date
 *   and the remaining full-year entitlement
 * - Other types: HR Leave Types Days or Maximum Application Days when Unlimited Days
 */
export function resolveBcLeaveBalance(input: {
  isAnnual: boolean
  leaveTypeDays: number
  leaveTypeUnlimitedDays?: boolean
  maximumApplicationDays?: number | null
  summary: BcLeaveSummary | null
  cardAnnualBalance: number | null
  earnedLeaveDays?: number | null
  leaveAccruedToDate?: number | null
  totalLeaveTakenToDate?: number | null
  hasCurrentPeriodEntries: boolean
  currentPeriodNet: number
  hasOpenEntries: boolean
  openNet: number
  ledgerNetDays: number
}) {
  if (input.isAnnual) {
    return resolveAnnualAvailableLeaveBalance({
      summary: input.summary,
      leaveAccruedToDate:
        input.leaveAccruedToDate ?? input.summary?.leaveAccruedToDate ?? null,
      totalLeaveTakenToDate:
        input.totalLeaveTakenToDate ??
        input.summary?.totalLeaveTakenToDate ??
        input.summary?.currentTotalLeaveTaken ??
        null,
    })
  }

  const unlimitedDays = input.summary?.unlimitedDays ?? input.leaveTypeUnlimitedDays ?? false
  const maximumApplicationDays =
    input.summary?.maximumApplicationDays ?? input.maximumApplicationDays
  if (unlimitedDays && maximumApplicationDays !== null && maximumApplicationDays !== undefined) {
    return Number.isFinite(maximumApplicationDays) ? Math.max(0, maximumApplicationDays) : 0
  }
  // Prefer the type-specific netted balance from GetLeaveBalance. Do not fall back
  // to availableLeaveBalance when that field still carries the annual card figure
  // from older BC builds — currentLeaveBalance / applicationLimit are type-correct.
  if (input.summary && input.summary.currentLeaveBalance !== null) {
    return input.summary.currentLeaveBalance
  }
  if (input.summary && input.summary.availableLeaveBalance !== null) {
    return input.summary.availableLeaveBalance
  }
  const setupDays = input.summary?.setupDays ?? input.leaveTypeDays
  return Number.isFinite(setupDays) ? setupDays : 0
}

export type LeaveCardBalances = {
  allocatedDays: number | null
  currentLeaveBalance: number | null
  earnedLeaveDays: number | null
  annualLeaveBalance: number | null
  employeeEarnedLeaveDays: number | null
}

function discoverLeaveFieldNumber(
  row: ODataRecord | null | undefined,
  matchers: Array<(normalizedKey: string) => boolean>,
) {
  if (!row) return null
  for (const [key, value] of Object.entries(row)) {
    if (value === undefined || value === null || String(value).trim() === '') continue
    const normalized = normalizeODataKey(key)
    if (!matchers.some((match) => match(normalized))) continue
    const parsed = parseNumeric(value)
    if (parsed !== null) return parsed
  }
  return null
}

export function parseEmployeeLeaveBalancesReturn(rawValue: unknown): LeaveCardBalances {
  const values = new Map<string, number>()
  for (const segment of String(rawValue ?? '').split('#')) {
    const separator = segment.indexOf('=')
    if (separator < 1) continue
    const key = segment.slice(0, separator).trim().toLowerCase()
    const value = Number(segment.slice(separator + 1).trim().replaceAll(',', ''))
    if (Number.isFinite(value)) values.set(key, value)
  }
  return {
    allocatedDays: null,
    currentLeaveBalance: null,
    earnedLeaveDays: null,
    annualLeaveBalance: values.get('annualleavebalance') ?? null,
    employeeEarnedLeaveDays: values.get('earnedleavedays') ?? null,
  }
}

export function leaveCardBalancesFromRecord(row: ODataRecord | null | undefined): LeaveCardBalances {
  return {
    allocatedDays:
      fieldNumber(row, ['AllocatedDays', 'Allocated_Days', 'Allocated']) ??
      discoverLeaveFieldNumber(row, [(key) => key === 'allocateddays']),
    currentLeaveBalance:
      fieldNumber(row, ['CurrentLeaveBalance', 'Current_Leave_Balance']) ??
      discoverLeaveFieldNumber(row, [
        (key) => key === 'currentleavebalance',
      ]),
    earnedLeaveDays:
      fieldNumber(row, ['EarnedLeaveDays', 'Earned_Leave_Days', 'EarnedLeave', 'Earned_Leave']) ??
      discoverLeaveFieldNumber(row, [
        (key) => key === 'earnedleavedays' || key === 'earnedleave',
      ]),
    annualLeaveBalance:
      fieldNumber(row, ANNUAL_LEAVE_BALANCE_KEYS) ??
      discoverLeaveFieldNumber(row, [(key) => key.includes('annualleavebalance')]),
    employeeEarnedLeaveDays: null,
  }
}

/** Employee card is authoritative for annual balance — never use generic LeaveBalance (-31). */
export function employeeCardLeaveBalances(row: ODataRecord | null | undefined): LeaveCardBalances {
  if (!row) {
    return {
      allocatedDays: null,
      currentLeaveBalance: null,
      earnedLeaveDays: null,
      annualLeaveBalance: null,
      employeeEarnedLeaveDays: null,
    }
  }
  const card = leaveCardBalancesFromRecord(row)
  return {
    allocatedDays: null,
    currentLeaveBalance: null,
    earnedLeaveDays: null,
    annualLeaveBalance: card.annualLeaveBalance,
    employeeEarnedLeaveDays: card.earnedLeaveDays,
  }
}

export function mergeLeaveCardBalances(...sets: LeaveCardBalances[]): LeaveCardBalances {
  const pick = (key: keyof LeaveCardBalances) => {
    for (const set of sets) {
      const value = set[key]
      if (value !== null && value !== undefined) return value
    }
    return null
  }
  return {
    allocatedDays: pick('allocatedDays'),
    currentLeaveBalance: pick('currentLeaveBalance'),
    earnedLeaveDays: pick('earnedLeaveDays'),
    annualLeaveBalance: pick('annualLeaveBalance'),
    employeeEarnedLeaveDays: pick('employeeEarnedLeaveDays'),
  }
}
