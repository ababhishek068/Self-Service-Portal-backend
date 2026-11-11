import type { LookupOption } from '@/api/endpoints/lookups'

/** Offline / pre-BC-630 fallback — same codes as ABH Advance Purpose SeedDefaults. */
export const PURPOSE_BY_DIVISION: Record<string, LookupOption[]> = {
  consulting: [
    { value: 'AC-RES', label: 'Research', meta: { requiresOtherDetails: false } },
    { value: 'AC-SUR', label: 'Surveys', meta: { requiresOtherDetails: false } },
    { value: 'AC-FLD', label: 'Field assessments', meta: { requiresOtherDetails: false } },
    { value: 'AC-PRJ', label: 'Project implementation', meta: { requiresOtherDetails: false } },
  ],
  workforce: [
    { value: 'AW-DEP', label: 'Staff deployment', meta: { requiresOtherDetails: false } },
    { value: 'AW-SUP', label: 'Field supervision', meta: { requiresOtherDetails: false } },
    { value: 'AW-REC', label: 'Recruitment activities', meta: { requiresOtherDetails: false } },
  ],
  academy: [
    { value: 'AA-TRN', label: 'Training', meta: { requiresOtherDetails: false } },
    { value: 'AA-WKS', label: 'Workshops', meta: { requiresOtherDetails: false } },
    { value: 'AA-FLD', label: 'Field-based learning', meta: { requiresOtherDetails: false } },
  ],
  corporate: [
    { value: 'CO-PRC', label: 'Procurement missions', meta: { requiresOtherDetails: false } },
    { value: 'CO-ADM', label: 'Administration', meta: { requiresOtherDetails: false } },
    { value: 'CO-LOG', label: 'Logistics', meta: { requiresOtherDetails: false } },
    { value: 'CO-OPS', label: 'Operational assignments', meta: { requiresOtherDetails: false } },
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

export function mapAdvancePaymentPurposes(
  purposes: AdvancePaymentPurposeRow[] | undefined,
): LookupOption[] {
  if (!Array.isArray(purposes) || purposes.length === 0) return []
  return [...purposes]
    .sort((a, b) => Number(a.sortOrder ?? 0) - Number(b.sortOrder ?? 0) || a.code.localeCompare(b.code))
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
