/** Purpose options by division family — ESSP Advance Request requirements. */
export const PURPOSE_BY_DIVISION: Record<string, { value: string; label: string }[]> = {
  consulting: [
    { value: 'Research', label: 'Research' },
    { value: 'Surveys', label: 'Surveys' },
    { value: 'Field assessments', label: 'Field assessments' },
    { value: 'Project implementation', label: 'Project implementation' },
  ],
  workforce: [
    { value: 'Staff deployment', label: 'Staff deployment' },
    { value: 'Field supervision', label: 'Field supervision' },
    { value: 'Recruitment activities', label: 'Recruitment activities' },
  ],
  academy: [
    { value: 'Training', label: 'Training' },
    { value: 'Workshops', label: 'Workshops' },
    { value: 'Field-based learning', label: 'Field-based learning' },
  ],
  corporate: [
    { value: 'Procurement missions', label: 'Procurement missions' },
    { value: 'Administration', label: 'Administration' },
    { value: 'Logistics', label: 'Logistics' },
    { value: 'Operational assignments', label: 'Operational assignments' },
  ],
  general: [{ value: 'Other', label: 'Other (Specify)' }],
}

export function divisionFamily(divisionOrDept: string) {
  const text = divisionOrDept.toLowerCase()
  if (text.includes('academy') || text.includes('training')) return 'academy'
  if (text.includes('workforce') || text.includes('hr') || text.includes('recruit')) return 'workforce'
  if (text.includes('consult') || text.includes('research') || text.includes('project')) return 'consulting'
  if (
    text.includes('finance') ||
    text.includes('admin') ||
    text.includes('corporate') ||
    text.includes('procure') ||
    text.includes('logistics') ||
    text.includes('it')
  ) {
    return 'corporate'
  }
  return 'general'
}

export function purposeOptionsForDivision(divisionOrDept: string) {
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

export function buildAdvancePurposePayload(values: {
  requestPurpose?: string
  otherPurposeDetails?: string
  justification?: string
  purpose?: string
}) {
  if (String(values.purpose ?? '').trim()) {
    return String(values.purpose).trim().slice(0, 250)
  }
  const purposeLabel =
    values.requestPurpose === 'Other' && values.otherPurposeDetails
      ? `Other: ${String(values.otherPurposeDetails).trim()}`
      : String(values.requestPurpose ?? '').trim()
  const parts = [
    purposeLabel,
    values.justification?.trim() ? `Justification: ${values.justification.trim()}` : '',
  ].filter(Boolean)
  return parts.join(' | ').slice(0, 250)
}
