import { authGet } from '@/api/client/authClient'
import { requireAuthApiUrl } from '@/api/requireBackend'

export interface HodDepartmentStaffRow {
  id: string
  employee: string
  employeeNo: string
  jobTitle: string
  department: string
  employmentDate: string
  status: string
}

export interface HodStaffLeaveRow {
  id: string
  employee: string
  employeeNo: string
  leaveType: string
  daysApplied: string
  from: string
  to: string
  returnDate: string
  status: string
}

export interface HodEmployeeDetail {
  employeeNo: string
  firstName: string
  middleName: string
  lastName: string
  phoneNumber: string
  email: string
  idNumber: string
  gender: string
  contractType: string
  jobTitle: string
  department: string
  employmentDate: string
}

export async function listHodDepartmentStaff(): Promise<HodDepartmentStaffRow[]> {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: HodDepartmentStaffRow[] }>('/api/hod/department-staff')
  return rows
}

/** @deprecated Use listHodDepartmentStaff */
export async function listHodTeamRequests(): Promise<HodDepartmentStaffRow[]> {
  return listHodDepartmentStaff()
}

export async function listHodStaffOnLeave(): Promise<HodStaffLeaveRow[]> {
  requireAuthApiUrl()
  const { rows } = await authGet<{ rows: HodStaffLeaveRow[] }>('/api/hod/staff-on-leave')
  return rows
}

export async function getHodEmployeeDetail(employeeNo: string): Promise<HodEmployeeDetail> {
  requireAuthApiUrl()
  return authGet<HodEmployeeDetail>(`/api/hod/employee/${encodeURIComponent(employeeNo)}`)
}
