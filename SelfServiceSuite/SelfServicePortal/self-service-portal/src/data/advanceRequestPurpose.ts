import type { LookupOption } from '@/api/endpoints/lookups'

/** Offline / pre-BC-630 fallback — same codes as ABH Advance Purpose SeedDefaults. */
export const PURPOSE_BY_DIVISION: Record<string, LookupOption[]> = {
  consulting: [
    { value: 'AC-RES', label: 'Research', meta: { requiresOtherDetails: false } },
    { value: 'AC-SUR', label: 'Surveys', meta: { requiresOtherDetails: false } },
    { value: 'AC-FLD', label: 'Field Assessments', meta: { requiresOtherDetails: false } },
    { value: 'AC-PRJ', label: 'Project Implementation', meta: { requiresOtherDetails: false } },
  ],
  workforce: [
    { value: 'AW-DEP', label: 'Staff Deployment', meta: { requiresOtherDetails: false } },
    { value: 'AW-SUP', label: 'Field Supervision', meta: { requiresOtherDetails: false } },
    { value: 'AW-REC', label: 'Recruitment Activities', meta: { requiresOtherDetails: false } },
  ],
  academy: [
    { value: 'AA-TRN', label: 'Training', meta: { requiresOtherDetails: false } },
    { value: 'AA-WKS', label: 'Workshops', meta: { requiresOtherDetails: false } },
    { value: 'AA-FLD', label: 'Field-Based Learning', meta: { requiresOtherDetails: false } },
  ],
  corporate: [
    { value: 'CO-PRC', label: 'Procurement Missions', meta: { requiresOtherDetails: false } },
    { value: 'CO-ADM', label: 'Administration', meta: { requiresOtherDetails: false } },
    { value: 'CO-LOG', label: 'Logistics', meta: { requiresOtherDetails: false } },
    { value: 'CO-OPS', label: 'Operational Assignments', meta: { requiresOtherDetails: false } },
  ],
  general: [{ value: 'GN-OTH', label: 'Other (Specify)', meta: { requiresOtherDetails: true } }],
}

export function divisionFamily(divisionOrDept: string) {
  const text = divisionOrDept.toLowerCase()
  if (text.includes('acd') || text.includes('consult') || text.includes('research')) return 'consulting'
  if (text.includes('aws') || text.includes('workforce') || text.includes('recruit')) return 'workforce'
  if (text.includes('aad') || text.includes('academy') || text.includes('training')) return 'academy'
  return 'corporate'
}

/**
 * Activity / Purpose of Assignment (client, 16 Nov 2026): one list for every requester, in this order. BC 1.0.3.661
 * returns the same; this is the offline fallback.
 */
export function allAdvancePurposeOptions(): LookupOption[] {
  return [
    ...PURPOSE_BY_DIVISION.consulting,
    ...PURPOSE_BY_DIVISION.workforce,
    ...PURPOSE_BY_DIVISION.academy,
    ...PURPOSE_BY_DIVISION.corporate,
    ...PURPOSE_BY_DIVISION.general,
  ]
}

/** Before BC 1.0.3.661 (division-filtered purposes). */
export function purposeOptionsForDivision(divisionOrDept: string): LookupOption[] {
  const family = divisionFamily(divisionOrDept)
  const specific = PURPOSE_BY_DIVISION[family] ?? PURPOSE_BY_DIVISION.corporate
  const merged = [...specific, ...PURPOSE_BY_DIVISION.general]
  const seen = new Set<string>()
  return merged.filter((option) => {
    if (seen.has(option.value)) return false
    seen.add(option.value)
    return true
  })
}

export function purposeRequiresOtherDetails(
  purposeCode: string,
  options: LookupOption[] = [],
) {
  const code = purposeCode.trim()
  if (!code) return false
  const selected = options.find((option) => String(option.value) === code)
  if (selected) return Boolean(selected.meta?.requiresOtherDetails)
  const upper = code.toUpperCase()
  return (
    upper === 'GN-OTH' ||
    upper.endsWith('-OTH') ||
    upper === 'OTHER' ||
    code.toLowerCase() === 'other'
  )
}

export type AdvancePaymentPurposeRow = {
  code: string
  description: string
  purposeGroup?: string
  requiresOtherDetails?: boolean
  sortOrder?: number
}

/** True for an "Other (Specify)" entry, which always goes last in a dropdown (client, 16 Nov 2026). */
export function isOtherOption(option: { value?: unknown; label?: unknown; meta?: Record<string, unknown> }) {
  const code = String(option.value ?? '').trim().toUpperCase()
  return (
    option.meta?.requiresOtherDetails === true ||
    code === 'GN-OTH' ||
    code.endsWith('-OTH') ||
    code.endsWith('-OTHER') ||
    /^other\b/i.test(String(option.label ?? '').trim())
  )
}

/**
 * The client's order (Research … Operational Assignments), then any purpose HR added (in BC's order: group, then
 * sort order), and Other (Specify) last. BC 1.0.3.661 already sends that order; sorting by sort order alone mixed
 * the groups (Other ended up in the middle).
 */
export function mapAdvancePaymentPurposes(
  purposes: AdvancePaymentPurposeRow[] | undefined,
): LookupOption[] {
  if (!Array.isArray(purposes) || purposes.length === 0) return []
  const clientOrder = allAdvancePurposeOptions().map((option) => String(option.value))
  const rank = (row: AdvancePaymentPurposeRow, index: number) => {
    const code = String(row.code ?? '').trim().toUpperCase()
    if (isOtherOption({ value: code, label: row.description, meta: { requiresOtherDetails: row.requiresOtherDetails === true } })) {
      return 1_000_000 + index
    }
    const known = clientOrder.indexOf(code)
    return known >= 0 ? known : 1_000 + index
  }
  return purposes
    .map((row, index) => ({ row, order: rank(row, index) }))
    .sort((left, right) => left.order - right.order)
    .map(({ row }) => row)
    .map((row) => ({
      value: String(row.code ?? '').trim(),
      label: String(row.description ?? row.code ?? '').trim(),
      meta: {
        purposeGroup: row.purposeGroup ?? '',
        requiresOtherDetails: Boolean(row.requiresOtherDetails),
        sortOrder: row.sortOrder ?? 0,
      },
    }))
    .filter((row) => row.value)
}
