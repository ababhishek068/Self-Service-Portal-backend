import { authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import { collectAttendanceMacHints } from '@/utils/clientMac'

export interface AttendanceRow {
  id: string
  date: string
  staffName: string
  employeeNo?: string
  timeIn: string
  timeOut: string
  hoursWorked: string
  macAddress: string
  /** @deprecated Use macAddress */
  location: string
  comments: string
  highlight?: boolean
}

export async function listAttendanceRecords(): Promise<AttendanceRow[]> {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: AttendanceRow[] }>('/api/attendance')
  return rows
}

export async function listTeamAttendanceRecords(): Promise<AttendanceRow[]> {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: AttendanceRow[] }>('/api/attendance/team')
  return rows
}

export async function signInAttendance(): Promise<AttendanceRow> {
  requireAuthApiUrl()
  const hints = await collectAttendanceMacHints()
  return authPost<AttendanceRow>('/api/attendance/sign-in', hints)
}

export async function signOutAttendance(): Promise<AttendanceRow> {
  requireAuthApiUrl()
  const hints = await collectAttendanceMacHints()
  return authPost<AttendanceRow>('/api/attendance/sign-out', hints)
}
