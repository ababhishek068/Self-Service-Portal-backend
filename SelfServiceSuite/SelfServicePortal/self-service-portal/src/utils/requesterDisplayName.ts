import type { PortalRequest } from '@/types/erp.types'

export function isEmployeeIdentifier(value: unknown, employeeNo = '') {
  const text = String(value ?? '').trim()
  const normalized = text.replace(/[\s/_-]/g, '').toLowerCase()
  const normalizedEmployeeNo = employeeNo.replace(/[\s/_-]/g, '').toLowerCase()
  return Boolean(
    normalized &&
      (normalized === normalizedEmployeeNo || /^[a-z]{2,8}\d{2,}$/i.test(normalized)),
  )
}

function requestEmployeeNo(request: PortalRequest) {
  return String(
    request.makerEmployeeNo ??
      request.payload?.EmployeeNo ??
      request.payload?.Employee_No ??
      request.payload?.RequestorEmployeeNo ??
      '',
  ).trim()
}

/** Resolve a human Employee Card name and never expose an employee/user ID. */
export function requesterDisplayName(
  request: PortalRequest,
  currentEmployeeNo: string,
  currentDisplayName: string,
) {
  const employeeNo = requestEmployeeNo(request)
  if (
    employeeNo &&
    currentEmployeeNo &&
    employeeNo.toLowerCase() === currentEmployeeNo.toLowerCase() &&
    currentDisplayName &&
    !isEmployeeIdentifier(currentDisplayName, employeeNo)
  ) {
    return currentDisplayName
  }

  const payload = request.payload ?? {}
  const candidates = [
    payload.RequestorName,
    payload.Requestor_Name,
    payload.RequestedByName,
    payload.Requested_By_Name,
    payload.RequesterName,
    payload.EmployeeName,
    request.makerName,
  ]
  for (const candidate of candidates) {
    const value = String(candidate ?? '').trim()
    if (value && !isEmployeeIdentifier(value, employeeNo)) return value
  }
  return 'Employee name unavailable'
}
