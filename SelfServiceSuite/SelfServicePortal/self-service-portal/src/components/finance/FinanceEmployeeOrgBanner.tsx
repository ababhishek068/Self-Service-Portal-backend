import { useQuery } from '@tanstack/react-query'
import { getEmployeeMedicalBalances, getEmployeeProfileDetails } from '@/api/endpoints/profile'
import { useAuth } from '@/hooks/useAuth'

function orgValue(...values: Array<string | undefined | null>) {
  for (const value of values) {
    const text = String(value ?? '').trim()
    if (text) return text
  }
  return 'Not configured on Employee Card'
}

function medicalBalanceValue(value: number | undefined) {
  if (value === undefined || !Number.isFinite(value)) return '—'
  return new Intl.NumberFormat('en-ET', {
    style: 'currency',
    currency: 'ETB',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(value)
}

interface FinanceEmployeeOrgBannerProps {
  showMedicalBalances?: boolean
  showJobGradeAndDistrict?: boolean
}

/** Read-only organisation context sourced from the ABH employee profile. */
export function FinanceEmployeeOrgBanner({
  showMedicalBalances = false,
  showJobGradeAndDistrict = false,
}: FinanceEmployeeOrgBannerProps) {
  const { employee } = useAuth()
  const profileQuery = useQuery({
    queryKey: ['profile', 'details'],
    queryFn: getEmployeeProfileDetails,
    staleTime: 5 * 60 * 1000,
  })
  const medicalBalancesQuery = useQuery({
    queryKey: ['profile', 'medical-balances'],
    queryFn: getEmployeeMedicalBalances,
    enabled: showMedicalBalances,
    staleTime: 60 * 1000,
  })
  const profile = profileQuery.data

  return (
    <div className="rounded-lg border border-slate-200 bg-slate-50 p-3 text-sm text-slate-800">
      <p className="mb-2 font-medium text-slate-900">Organisation (from your employee profile)</p>
      <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-3">
        <div><span className="text-slate-500">Employee</span><p className="font-medium">{orgValue(employee?.displayName)}</p></div>
        <div><span className="text-slate-500">Job Title</span><p className="font-medium">{orgValue(profile?.jobTitle, employee?.jobTitle)}</p></div>
        {showJobGradeAndDistrict ? (
          <div><span className="text-slate-500">Job Grade</span><p className="font-medium">{orgValue(profile?.jobGrade, employee?.jobGrade)}</p></div>
        ) : null}
        <div><span className="text-slate-500">Division</span><p className="font-medium">{orgValue(profile?.division)}</p></div>
        <div><span className="text-slate-500">Department</span><p className="font-medium">{orgValue(profile?.department, employee?.departmentName, employee?.departmentCode)}</p></div>
        {showJobGradeAndDistrict ? (
          <div><span className="text-slate-500">District</span><p className="font-medium">{orgValue(profile?.district)}</p></div>
        ) : null}
        <div><span className="text-slate-500">Branch</span><p className="font-medium">{orgValue(profile?.branch, employee?.branchName, employee?.branchCode)}</p></div>
      </div>
      {showMedicalBalances ? (
        <div className="mt-3 grid gap-2 border-t border-slate-200 pt-3 sm:grid-cols-2">
          <div>
            <span className="text-slate-500">Medical Claim Balance — Self</span>
            <p className="font-semibold text-teal-700">{medicalBalanceValue(medicalBalancesQuery.data?.self)}</p>
          </div>
          <div>
            <span className="text-slate-500">Medical Claim Balance — Dependant</span>
            <p className="font-semibold text-teal-700">{medicalBalanceValue(medicalBalancesQuery.data?.dependant)}</p>
          </div>
          {medicalBalancesQuery.isError ? (
            <p className="text-xs text-red-600 sm:col-span-2">Medical balances are temporarily unavailable from Business Central.</p>
          ) : null}
        </div>
      ) : null}
      {profileQuery.isError ? (
        <p className="mt-2 text-xs font-medium text-red-700">
          Employee Card details could not be loaded from Business Central. Refresh before creating the request.
        </p>
      ) : null}
      <p className="mt-2 text-xs text-slate-500">These values are applied automatically in Business Central.</p>
    </div>
  )
}
