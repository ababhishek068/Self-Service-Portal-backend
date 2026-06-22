/** ESS only sends hospital category / medical amount for claim type MEDICAL. */
export function isMedicalClaimType(value: unknown) {
  const raw = String(value ?? '').trim().toUpperCase()
  return raw === 'MEDICAL' || raw.includes('MEDICAL')
}

export function stripNonMedicalClaimFields(values: Record<string, unknown>) {
  if (isMedicalClaimType(values.claimType)) return values
  return {
    ...values,
    hospitalCategory: 0,
    medicalAmount: 0,
  }
}
