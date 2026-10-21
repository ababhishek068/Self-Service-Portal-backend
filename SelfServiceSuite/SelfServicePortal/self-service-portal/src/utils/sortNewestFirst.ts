/** Newest documents first: higher document number, then later date. */

const DOC_NO_KEYS = [
  'requestNo',
  'ApplicationCode',
  'Application_Code',
  'No',
  'No_',
  'DocumentNo',
  'gatePassNo',
  'GatePassNo',
  'id',
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
  'attendanceDate',
  'fromDate',
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

function looksLikeDocument(row: unknown, rowId: string) {
  const record = (row ?? {}) as Record<string, unknown>
  if (text(record, DOC_NO_KEYS.filter((key) => key !== 'id'))) return true
  if (text(record, DATE_KEYS)) return true
  return /[A-Za-z0-9]+-.+\d{3,}/.test(rowId)
}

export function sortNewestFirst<T>(rows: T[], getRowId?: (row: T) => string) {
  if (rows.length < 2) return rows
  const hits = rows.filter((row) => looksLikeDocument(row, getRowId?.(row) ?? '')).length
  if (hits < Math.ceil(rows.length / 2)) return rows
  return [...rows].sort((left, right) => {
    const byFields = compareNewestFirst(left, right)
    if (byFields !== 0) return byFields
    if (!getRowId) return 0
    return getRowId(right).localeCompare(getRowId(left), undefined, { numeric: true, sensitivity: 'base' })
  })
}
