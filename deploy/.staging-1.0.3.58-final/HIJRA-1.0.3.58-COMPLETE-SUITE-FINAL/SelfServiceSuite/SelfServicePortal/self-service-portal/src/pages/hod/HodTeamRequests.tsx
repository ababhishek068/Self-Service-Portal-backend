import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { Search } from 'lucide-react'
import { listHodDepartmentStaff, type HodDepartmentStaffRow } from '@/api/endpoints/hod'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Input } from '@/components/ui/input'
import { formatDate } from '@/utils/formatters'

const columns: DataTableColumn<HodDepartmentStaffRow>[] = [
  { id: 'employeeNo', header: 'Staff No.', cell: (row) => row.employeeNo },
  { id: 'employee', header: 'Name', cell: (row) => row.employee },
  { id: 'jobTitle', header: 'Job Title', cell: (row) => row.jobTitle || '—' },
  { id: 'department', header: 'Department', cell: (row) => row.department || '—' },
  { id: 'employmentDate', header: 'Joined', cell: (row) => formatDate(row.employmentDate) },
  { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status || 'Active'} /> },
]

export function HodTeamRequests() {
  const navigate = useNavigate()
  const [search, setSearch] = useState('')
  const query = useQuery({ queryKey: ['hod', 'department-staff'], queryFn: listHodDepartmentStaff })

  const filteredRows = useMemo(() => {
    const rows = query.data ?? []
    const term = search.trim().toLowerCase()
    if (!term) return rows
    return rows.filter((row) =>
      [row.employee, row.employeeNo, row.jobTitle, row.department, row.status].some((value) =>
        String(value).toLowerCase().includes(term),
      ),
    )
  }, [query.data, search])

  return (
    <PageWrapper
      title="Department Staff"
      description="Active employees verified against your Business Central department assignment."
    >
      <div className="mb-4 max-w-md">
        <div className="relative">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
          <Input
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Search department staff..."
            className="pl-9"
          />
        </div>
      </div>
      <DataTable
        rows={filteredRows}
        columns={columns}
        getRowId={(row) => row.id}
        onRowClick={(row) => navigate(`/hod/employee/${encodeURIComponent(row.employeeNo)}`)}
        emptyTitle={
          query.isLoading
            ? 'Loading department staff...'
            : query.isError
              ? 'Department staff could not be loaded.'
              : 'No active staff were found in your department.'
        }
      />
    </PageWrapper>
  )
}
