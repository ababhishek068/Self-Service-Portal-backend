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
