import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { Search } from 'lucide-react'
import { listHodStaffOnLeave, type HodStaffLeaveRow } from '@/api/endpoints/hod'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { Input } from '@/components/ui/input'
import { formatDate } from '@/utils/formatters'

const columns: DataTableColumn<HodStaffLeaveRow>[] = [
  { id: 'employeeNo', header: 'Staff No.', cell: (row) => row.employeeNo },
  { id: 'employee', header: 'Name', cell: (row) => row.employee },
  { id: 'leaveType', header: 'Leave Type', cell: (row) => row.leaveType },
  { id: 'days', header: 'Days Applied', cell: (row) => row.daysApplied || '—' },
  { id: 'from', header: 'From', cell: (row) => formatDate(row.from) },
  { id: 'to', header: 'To', cell: (row) => formatDate(row.to) },
]

export function StaffOnLeave() {
  const navigate = useNavigate()
  const [search, setSearch] = useState('')
  const query = useQuery({ queryKey: ['hod', 'staff-on-leave'], queryFn: listHodStaffOnLeave })

  const filteredRows = useMemo(() => {
    const rows = query.data ?? []
    const term = search.trim().toLowerCase()
    if (!term) return rows
    return rows.filter((row) =>
      [row.employee, row.employeeNo, row.leaveType, row.daysApplied].some((value) =>
        String(value).toLowerCase().includes(term),
      ),
    )
  }, [query.data, search])

  return (
    <PageWrapper title="Staff on Leave" description="Department members currently on approved leave.">
      <div className="mb-4 max-w-md">
        <div className="relative">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
          <Input
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Search staff on leave..."
            className="pl-9"
          />
        </div>
      </div>
      <DataTable
        rows={filteredRows}
        columns={columns}
        getRowId={(row) => row.id}
        onRowClick={(row) => navigate(`/hod/employee/${encodeURIComponent(row.employeeNo)}`)}
        emptyTitle={query.isLoading ? 'Loading staff leave...' : '*** No staff found ***'}
        compact
      />
    </PageWrapper>
  )
}
