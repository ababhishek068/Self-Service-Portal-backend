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
  /** Advance Request spec: Employee Number and Employment Status in the auto-filled employee block. */
  showEmployeeNoAndStatus?: boolean
}

/** Read-only organisation context sourced from the ABH employee profile. */
export function FinanceEmployeeOrgBanner({
  showMedicalBalances = false,
  showJobGradeAndDistrict = false,
  showEmployeeNoAndStatus = false,
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
    // BC 1.0.3.648 lowers the balance when the Finance Manager posts the claim's payment voucher,
    // outside the portal: read it fresh each time the Medical Claim form opens.
    staleTime: 0,
    refetchOnMount: 'always',
  })
  const profile = profileQuery.data

  return (
    <div className="rounded-lg border border-slate-200 bg-slate-50 p-3 text-sm text-slate-800">
      <p className="mb-2 font-medium text-slate-900">Organisation (from your employee profile)</p>
      <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-3">
        <div><span className="text-slate-500">Employee</span><p className="font-medium">{orgValue(employee?.displayName)}</p></div>
        {showEmployeeNoAndStatus ? (
          <div><span className="text-slate-500">Employee No.</span><p className="font-medium">{orgValue(profile?.employeeNo, employee?.employeeNo)}</p></div>
        ) : null}
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
        {showEmployeeNoAndStatus ? (
          <div><span className="text-slate-500">Employment Status</span><p className="font-medium">{orgValue(profile?.status, profile?.employmentType)}</p></div>
        ) : null}
      </div>
      {showMedicalBalances ? (
        <div className="mt-3 space-y-2 border-t border-slate-200 pt-3">
          <p className="text-xs text-slate-600">
            Policy: annual entitlement = Basic × 12 × 20% (Self 50% / Dependants 50%). Company reimburses{' '}
            <span className="font-semibold text-slate-800">80%</span> of accepted medical receipts, capped by the
            remaining available budget (includes submitted drafts reserved in BC 1.0.3.642+).
          </p>
          <div className="grid gap-2 sm:grid-cols-2 lg:grid-cols-4">
            <div>
              <span className="text-slate-500">Available — Self</span>
              <p className="font-semibold text-teal-700">{medicalBalanceValue(medicalBalancesQuery.data?.self)}</p>
            </div>
            <div>
              <span className="text-slate-500">Available — Dependants</span>
              <p className="font-semibold text-teal-700">{medicalBalanceValue(medicalBalancesQuery.data?.dependant)}</p>
            </div>
            <div>
              <span className="text-slate-500">Allocation — Self</span>
              <p className="font-medium text-slate-800">
                {medicalBalanceValue(medicalBalancesQuery.data?.selfAllocation)}
              </p>
            </div>
            <div>
              <span className="text-slate-500">Allocation — Dependants</span>
              <p className="font-medium text-slate-800">
                {medicalBalanceValue(medicalBalancesQuery.data?.dependantAllocation)}
              </p>
            </div>
          </div>
          {medicalBalancesQuery.isError ? (
            <p className="text-xs text-red-600">Medical balances are temporarily unavailable from Business Central.</p>
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
