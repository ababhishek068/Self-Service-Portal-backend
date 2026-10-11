import { formatISO, isSameDay, parseISO } from 'date-fns'

export const workingDate = () => new Date()

/** Local calendar YYYY-MM-DD — recomputed every call (never cache at module load). */
export function todayIsoDate() {
  return formatISO(workingDate(), { representation: 'date' })
}

export function isErpWorkingDate(value: string) {
  const trimmed = String(value ?? '').trim()
  if (!trimmed) return false
  // Prefer direct YYYY-MM-DD compare so UTC parseISO midnight shifts cannot
  // mark "today" as yesterday near timezone boundaries.
  if (/^\d{4}-\d{2}-\d{2}$/.test(trimmed)) {
    return trimmed === todayIsoDate()
  }
  return isSameDay(parseISO(trimmed), workingDate())
}

export function buildFaTagNumber(
  departmentCode: string,
  categoryCode: string,
  itemCode: string,
  sequence: number,
  year = new Date().getFullYear(),
) {
  const seq = String(sequence).padStart(4, '0')
  return `FA/${departmentCode}/${categoryCode}/${itemCode}/${seq}/${year}`
}

export function isMakerAllowedToApprove(makerEmployeeNo: string, approverEmployeeNo: string) {
  return makerEmployeeNo !== approverEmployeeNo
}

export function isDuplicateWithin24Hours(existingDateIso: string, candidateDateIso: string) {
  const existing = parseISO(existingDateIso).getTime()
  const candidate = parseISO(candidateDateIso).getTime()
  return Math.abs(candidate - existing) <= 24 * 60 * 60 * 1000
}
