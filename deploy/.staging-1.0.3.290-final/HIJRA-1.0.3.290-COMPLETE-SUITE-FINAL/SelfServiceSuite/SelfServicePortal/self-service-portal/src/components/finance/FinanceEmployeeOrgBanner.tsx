import { useQuery } from '@tanstack/react-query'
import { getEmployeeProfileDetails } from '@/api/endpoints/profile'
import { useAuth } from '@/hooks/useAuth'

function orgValue(...values: Array<string | undefined | null>) {
  for (const value of values) {
    const text = String(value ?? '').trim()
    if (text && text !== '—') return text
  }
  return '—'
}

/**
 * Read-only org context for finance headers.
 * Organogram: Sector → Department or District → Division or Branch.
 */
export function FinanceEmployeeOrgBanner() {
  const { employee } = useAuth()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const profile = profileQuery.data

  const employeeName = orgValue(employee?.displayName)
  const jobTitle = orgValue(profile?.jobTitle, employee?.jobTitle)
  const jobGrade = orgValue(profile?.jobGrade, employee?.jobGrade)
  const sector = orgValue(profile?.sector)
  const orgKind = profile?.orgKind === 'district' ? 'district' : 'department'
  const departmentOrDistrict =
    orgKind === 'district'
      ? orgValue(profile?.district, employee?.departmentName)
      : orgValue(profile?.departmentName, employee?.departmentName)
  const divisionOrBranch =
    orgKind === 'district'
      ? orgValue(profile?.branchName, employee?.branchName, profile?.branchCode)
      : orgValue(profile?.division, (profile as { divisionCode?: string } | undefined)?.divisionCode)

  return (
    <div className="rounded-lg border border-slate-200 bg-slate-50 p-3 text-sm text-slate-800">
      <p className="mb-2 font-medium text-slate-900">Organisation (from your employee profile)</p>
      <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-3">
        <div>
          <span className="text-slate-500">Employee</span>
          <p className="font-medium">{employeeName}</p>
        </div>
        <div>
          <span className="text-slate-500">Job Title</span>
          <p className="font-medium">{jobTitle}</p>
        </div>
        <div>
          <span className="text-slate-500">Job Grade</span>
          <p className="font-medium">{jobGrade}</p>
        </div>
        {sector !== '—' ? (
          <div>
            <span className="text-slate-500">Sector</span>
            <p className="font-medium">{sector}</p>
          </div>
        ) : null}
        {departmentOrDistrict !== '—' ? (
          <div>
            <span className="text-slate-500">{orgKind === 'district' ? 'District' : 'Department'}</span>
            <p className="font-medium">{departmentOrDistrict}</p>
          </div>
        ) : null}
        {divisionOrBranch !== '—' ? (
          <div>
            <span className="text-slate-500">{orgKind === 'district' ? 'Branch' : 'Division'}</span>
            <p className="font-medium">{divisionOrBranch}</p>
          </div>
        ) : null}
      </div>
      <p className="mt-2 text-xs text-slate-500">
        Taken from your employee card. Empty org fields are omitted — we do not invent HQ
        or put a district in Division.
      </p>
    </div>
  )
}
