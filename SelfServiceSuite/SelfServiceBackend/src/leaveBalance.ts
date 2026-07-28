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
  cardAnnualLeaveBalance: number | null
  earnedLeaveDays: number | null
  annualLeaveCode: string
  setupDays: number | null
  unlimitedDays: boolean | null
  maximumApplicationDays: number | null
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
    const numeric = Number(value)
    return Number.isFinite(numeric) ? numeric : null
  }
  return {
    cardAnnualLeaveBalance: toNumber(row.cardAnnualLeaveBalance),
    earnedLeaveDays: toNumber(row.earnedLeaveDays),
    annualLeaveCode: String(row.annualLeaveCode ?? '').trim(),
    setupDays: toNumber(row.setupDays),
    unlimitedDays: typeof row.unlimitedDays === 'boolean' ? row.unlimitedDays : null,
    maximumApplicationDays: toNumber(row.maximumApplicationDays),
    hasOpenEntries: row.hasOpenEntries === true,
    openNet: toNumber(row.openNet) ?? 0,
    hasCurrentPeriodEntries: row.hasCurrentPeriodEntries === true,
    currentPeriodNet: toNumber(row.currentPeriodNet) ?? 0,
  }
}

/**
 * Balance shown to the employee — mirrors BC CuPortalEmployeeData.GetLeaveBalance:
 * - Annual: employee-card "Annual Leave balance" FlowField (reduces when BC posts leave)
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
  hasCurrentPeriodEntries: boolean
  currentPeriodNet: number
  hasOpenEntries: boolean
  openNet: number
  ledgerNetDays: number
}) {
  if (input.isAnnual) {
    const earned = input.earnedLeaveDays ?? input.summary?.earnedLeaveDays ?? null

    if (
      input.summary &&
      input.summary.cardAnnualLeaveBalance !== null &&
      input.summary.cardAnnualLeaveBalance > 0
    ) {
      return input.summary.cardAnnualLeaveBalance
    }

    if (earned !== null && earned > 0) {
      return earned
    }

    if (input.summary && input.summary.cardAnnualLeaveBalance !== null) {
      return input.summary.cardAnnualLeaveBalance
    }

    if (input.summary) {
      if (input.summary.hasCurrentPeriodEntries) return Math.max(0, input.summary.currentPeriodNet)
      if (input.summary.hasOpenEntries) return Math.max(0, input.summary.openNet)
    }
    if (input.hasCurrentPeriodEntries) return Math.max(0, input.currentPeriodNet)
    if (input.hasOpenEntries) return Math.max(0, input.openNet)
    if (input.cardAnnualBalance !== null) return input.cardAnnualBalance
    const net = Number.isFinite(input.ledgerNetDays) ? input.ledgerNetDays : 0
    return Math.max(0, net)
  }

  const setupDays = input.summary?.setupDays ?? input.leaveTypeDays
  const unlimitedDays = input.summary?.unlimitedDays ?? input.leaveTypeUnlimitedDays ?? false
  const maximumApplicationDays =
    input.summary?.maximumApplicationDays ?? input.maximumApplicationDays
  const configuredBalance =
    unlimitedDays && maximumApplicationDays !== null && maximumApplicationDays !== undefined
      ? maximumApplicationDays
      : setupDays
  return Number.isFinite(configuredBalance) ? Math.max(0, configuredBalance) : 0
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
