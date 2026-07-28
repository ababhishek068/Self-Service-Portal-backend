import { useQuery } from '@tanstack/react-query'
import { getEmployeeProfileDetails } from '@/api/endpoints/profile'
import { useAuth } from '@/hooks/useAuth'

function orgValue(...values: Array<string | undefined | null>) {
  for (const value of values) {
    const text = String(value ?? '').trim()
    if (text) return text
  }
  return '—'
}

/**
 * Read-only org context for finance headers.
 * BC stamps Division, Department, District and Branch from the employee card
 * on Validate("Employee No") — the portal must not let users override these.
 */
export function FinanceEmployeeOrgBanner() {
  const { employee } = useAuth()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const profile = profileQuery.data

  const division = orgValue(profile?.division, employee?.departmentName)
  const department = orgValue(profile?.departmentName, employee?.departmentName, employee?.departmentCode)
  const district = orgValue(profile?.district)
  const branch = orgValue(profile?.branchName, employee?.branchName, employee?.branchCode)

  return (
    <div className="rounded-lg border border-slate-200 bg-slate-50 p-3 text-sm text-slate-800">
      <p className="mb-2 font-medium text-slate-900">Organisation (from your Business Central employee record)</p>
      <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-4">
        <div>
          <span className="text-slate-500">Division</span>
          <p className="font-medium">{division}</p>
        </div>
        <div>
          <span className="text-slate-500">Department</span>
          <p className="font-medium">{department}</p>
        </div>
        <div>
          <span className="text-slate-500">District</span>
          <p className="font-medium">{district}</p>
        </div>
        <div>
          <span className="text-slate-500">Branch</span>
          <p className="font-medium">{branch}</p>
        </div>
      </div>
      <p className="mt-2 text-xs text-slate-500">
        These values are applied automatically when the request is created in Business Central.
      </p>
    </div>
  )
}
