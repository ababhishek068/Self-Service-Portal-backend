/** Extract the applicant's reason/description from a request payload. */
export function extractApplicationReason(
  payload: Record<string, unknown> | undefined,
  title?: string,
): string {
  if (!payload) return usableApplicationReasonTitle(title)

  const keys = [
    'Posting_Description',
    'PostingDescription',
    'RequestDescription',
    'Request_Description',
    'reason',
    'description',
    'justification',
    'purpose',
    'issueDescription',
    'IssueDescription',
    'comments',
    'notes',
    'remarks',
  ]

  for (const key of keys) {
    const value = payload[key]
    if (typeof value === 'string' && value.trim()) {
      const cleaned = usableApplicationReasonTitle(value)
      if (cleaned) return cleaned
    }
  }

  for (const [key, value] of Object.entries(payload)) {
    if (
      typeof value === 'string' &&
      value.trim() &&
      /description|reason|justification|purpose|narration/i.test(key)
    ) {
      const cleaned = usableApplicationReasonTitle(value)
      if (cleaned) return cleaned
    }
  }

  return usableApplicationReasonTitle(title)
}

/** Document-type labels are not the applicant's written reason. */
function usableApplicationReasonTitle(value?: string) {
  const trimmed = value?.trim() ?? ''
  if (!trimmed) return ''
  if (/^(store|purchase)\s+requisition$/i.test(trimmed)) return ''
  if (/^(order|quote)$/i.test(trimmed)) return ''
  return trimmed
}
