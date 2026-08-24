/** District-line vs department-line display for finance request/approval details. */

export function looksLikeDistrictLabel(value: unknown) {
  return /district/i.test(String(value ?? '').trim())
}

export function financeOrgKindFromPayload(
  payload: Record<string, unknown> | undefined,
): 'department' | 'district' {
  const kind = String(payload?.FinanceOrgKind ?? '').trim().toLowerCase()
  if (kind === 'district' || kind === 'department') return kind
  const district = String(
    payload?.DistrictName ?? payload?.District_Name ?? payload?.District ?? '',
  ).trim()
  const division = String(
    payload?.DivisionName ?? payload?.Division_Name ?? payload?.Division ?? '',
  ).trim()
  const branch = String(
    payload?.BranchName ?? payload?.Branch_Name ?? payload?.BranchCode ?? '',
  ).trim()
  if (district || looksLikeDistrictLabel(division) || branch) return 'district'
  return 'department'
}

/** Department-line: Department + Division. District-line: District + Branch. */
export function shouldShowFinanceOrgDetailField(
  label: string,
  value: unknown,
  payload?: Record<string, unknown>,
) {
  const text = String(value ?? '').trim()
  if (!text || text === '—') return false
  const kind = financeOrgKindFromPayload(payload)
  if (label === 'Division') {
    if (kind === 'district') return false
    if (looksLikeDistrictLabel(text)) return false
    const district = String(
      payload?.DistrictName ?? payload?.District_Name ?? payload?.District ?? '',
    ).trim()
    if (district && text.toLowerCase() === district.toLowerCase()) return false
    return true
  }
  if (label === 'District' || label === 'Branch') return kind === 'district'
  if (label === 'Department') return kind === 'department'
  if (label === 'Sector') return true
  return true
}

export function matchesRequestListStatus(status: string | undefined, filter: string) {
  const normalized = String(status ?? '').toLowerCase()
  if (filter === 'all') return true
  if (filter === 'pending') return normalized.includes('pending')
  if (filter === 'approved') return normalized === 'approved' || normalized === 'posted'
  if (filter === 'rejected') return normalized.includes('reject')
  if (filter === 'draft') return normalized === 'draft' || normalized === 'open' || normalized === 'pending'
  return true
}
