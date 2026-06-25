import { useQuery } from '@tanstack/react-query'
import { Link, useParams } from 'react-router-dom'
import { getHodEmployeeDetail } from '@/api/endpoints/hod'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { formatDate } from '@/utils/formatters'

function DetailField({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <dt className="text-xs font-medium uppercase tracking-wide text-slate-500">{label}</dt>
      <dd className="mt-1 text-sm text-slate-900">{value || '—'}</dd>
    </div>
  )
}

export function HodEmployeeDetail() {
  const { employeeNo = '' } = useParams()
  const query = useQuery({
    queryKey: ['hod', 'employee', employeeNo],
    queryFn: () => getHodEmployeeDetail(employeeNo),
    enabled: Boolean(employeeNo),
  })

  const employee = query.data
  const fullName = employee
    ? [employee.firstName, employee.middleName, employee.lastName].filter(Boolean).join(' ')
    : ''

  return (
    <PageWrapper
      title="Staff Details"
      description="Department employee profile."
      actions={(
        <Button asChild variant="outline">
          <Link to="/hod/department-staff">Back to Department Staff</Link>
        </Button>
      )}
    >
      {query.isLoading ? (
        <div className="grid gap-4 sm:grid-cols-2">
          {Array.from({ length: 8 }).map((_, index) => (
            <Skeleton key={index} className="h-14 rounded-md" />
          ))}
        </div>
      ) : query.isError || !employee ? (
        <p className="text-sm text-red-600">Employee details not found.</p>
      ) : (
        <div className="mx-auto max-w-3xl rounded-lg border bg-white p-6 shadow-sm">
          <div className="mb-6 text-center">
            <div className="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-[var(--portal-navy)]/10 text-xl font-semibold text-[var(--portal-navy)]">
              {employee.firstName.slice(0, 1) || employee.employeeNo.slice(0, 1)}
            </div>
            <h2 className="mt-3 text-lg font-semibold text-slate-900">{fullName || employee.employeeNo}</h2>
            <p className="text-sm text-slate-600">{employee.jobTitle || employee.department}</p>
          </div>
          <dl className="grid gap-4 sm:grid-cols-2">
            <DetailField label="Employee No." value={employee.employeeNo} />
            <DetailField label="First Name" value={employee.firstName} />
            <DetailField label="Middle Name" value={employee.middleName} />
            <DetailField label="Last Name" value={employee.lastName} />
            <DetailField label="Phone No." value={employee.phoneNumber} />
            <DetailField label="Email" value={employee.email} />
            <DetailField label="ID Number" value={employee.idNumber} />
            <DetailField label="Gender" value={employee.gender} />
            <DetailField label="Job Mode" value={employee.contractType} />
            <DetailField label="Job Title" value={employee.jobTitle} />
            <DetailField label="Department" value={employee.department} />
            <DetailField label="Employment Date" value={formatDate(employee.employmentDate)} />
          </dl>
        </div>
      )}
    </PageWrapper>
  )
}
