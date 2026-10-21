/** Extract the applicant's reason/description from a request payload. */
export function extractApplicationReason(
  payload: Record<string, unknown> | undefined,
  title?: string,
): string {
  if (!payload) return title?.trim() ?? ''

  const keys = [
    'reason',
    'PostingDescription',
    'Posting_Description',
    'postingDescription',
    'description',
    'Description',
    'justification',
    'purpose',
    'Purpose',
    'issueDescription',
    'comments',
    'notes',
    'remarks',
  ]

  for (const key of keys) {
    const value = payload[key]
    if (typeof value === 'string' && value.trim()) {
      const trimmed = value.trim()
      // BC Document Type "Quote" is not an application reason.
      if (/^quote$/i.test(trimmed)) continue
      return trimmed
    }
  }

  const fallback = title?.trim() ?? ''
  return /^quote$/i.test(fallback) ? '' : fallback
}
