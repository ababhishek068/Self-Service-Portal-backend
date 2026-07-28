import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { Search } from 'lucide-react'
import { listHodDepartmentStaff, type HodDepartmentStaffRow } from '@/api/endpoints/hod'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { Input } from '@/components/ui/input'

const columns: DataTableColumn<HodDepartmentStaffRow>[] = [
  { id: 'employeeNo', header: 'Staff No.', cell: (row) => row.employeeNo },
  { id: 'employee', header: 'Name', cell: (row) => row.employee },
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
      [row.employee, row.employeeNo, row.jobTitle].some((value) =>
        String(value).toLowerCase().includes(term),
      ),
    )
  }, [query.data, search])

  return (
    <PageWrapper title="Department Staff" description="Active employees in your department.">
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
        emptyTitle={query.isLoading ? 'Loading department staff...' : '*** No staff found ***'}
      />
    </PageWrapper>
  )
}
