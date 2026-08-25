import { authGet, authPost } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'
import { collectAttendanceMacHints } from '@/utils/clientMac'

export interface AttendanceRow {
  id: string
  date: string
  staffName: string
  employeeNo?: string
  jobTitle?: string
  department?: string
  status?: 'Signed In' | 'Signed Out' | 'Not Signed In'
  timeIn: string
  timeOut: string
  hoursWorked: string
  macAddress: string
  /** @deprecated Use macAddress */
  location: string
  comments: string
  highlight?: boolean
}

export interface WeeklyLateAttendanceSummary {
  weekStart: string
  throughDate: string
  lateCount: number
  threshold: number
  notify: boolean
  message: string
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

export async function getWeeklyLateAttendanceSummary(): Promise<WeeklyLateAttendanceSummary> {
  requireAuthApiUrl()
  return authGet<WeeklyLateAttendanceSummary>('/api/attendance/weekly-summary')
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
