function payloadValue(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = payload[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return value
  }
  return undefined
}

/** Show the BC leave type name — never the raw code like 0001. */
export function formatLeaveTypeLabel(payload: Record<string, unknown>) {
  const description = payloadValue(payload, [
    'LeaveTypeDescription',
    'Leave_Type_Description',
    'leaveTypeDescription',
    'LeaveDescription',
    'Description',
  ])
  if (description) return String(description)

  const maybeName = payloadValue(payload, ['LeaveType', 'Leave_Type', 'LeaveTypeCode', 'Leave_Type_Code'])
  const text = String(maybeName ?? '').trim()
  if (!text) return '—'
  if (/^\d+$/.test(text)) return '—'
  return text
}

export function leaveTypeCodeFromPayload(payload: Record<string, unknown>) {
  return String(
    payloadValue(payload, ['LeaveTypeCode', 'Leave_Type_Code', 'LeaveType', 'Leave_Type', 'leaveType']) ?? '',
  ).trim()
}
