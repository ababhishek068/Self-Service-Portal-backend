/** Newest documents first: higher document number, then later date. */

const DOC_NO_KEYS = [
  'requestNo',
  'ApplicationCode',
  'Application_Code',
  'No',
  'No_',
  'DocumentNo',
  'Document_No',
  'gatePassNo',
  'GatePassNo',
]

const DATE_KEYS = [
  'submittedAt',
  'createdAt',
  'ApplicationDate',
  'Application_Date',
  'DateTimeSentforApproval',
  'SystemCreatedAt',
  'StartDate',
  'Date',
]

function text(row: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = row[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return String(value).trim()
  }
  return ''
}

function dateValue(row: Record<string, unknown>) {
  const raw = text(row, DATE_KEYS)
  const parsed = Date.parse(raw)
  return Number.isFinite(parsed) ? parsed : 0
}

export function compareNewestFirst(left: unknown, right: unknown) {
  const a = (left ?? {}) as Record<string, unknown>
  const b = (right ?? {}) as Record<string, unknown>
  const noA = text(a, DOC_NO_KEYS)
  const noB = text(b, DOC_NO_KEYS)
  if (noA && noB && noA !== noB) {
    return noB.localeCompare(noA, undefined, { numeric: true, sensitivity: 'base' })
  }
  return dateValue(b) - dateValue(a)
}

export function sortNewestFirst<T>(rows: T[]) {
  return [...rows].sort(compareNewestFirst)
}
