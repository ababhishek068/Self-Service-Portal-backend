import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useMemo, useState } from 'react'
import { Search } from 'lucide-react'
import {
  listAttendanceRecords,
  listTeamAttendanceRecords,
  signInAttendance,
  signOutAttendance,
} from '@/api/endpoints/attendance'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import type { AttendanceRow } from '@/api/endpoints/attendance'
import { usePermissions } from '@/hooks/usePermissions'
import { useToast } from '@/components/feedback/ToastProvider'
import { formatAttendanceClock, formatAttendanceMac, isRecordedAttendanceTime } from '@/utils/formatters'

function attendanceStatus(row: AttendanceRow) {
  if (row.status) return row.status
  if (isRecordedAttendanceTime(row.timeOut)) return 'Signed Out'
  if (isRecordedAttendanceTime(row.timeIn)) return 'Signed In'
  return 'Not Signed In'
}

function attendanceHours(value?: string) {
  const raw = String(value ?? '').trim()
  if (!raw) return '—'
  const numeric = Number(raw)
  return Number.isFinite(numeric) ? numeric.toFixed(2) : raw
}

export function Attendance() {
  const { isHOD } = usePermissions()
  const queryClient = useQueryClient()
  const [confirmSignOut, setConfirmSignOut] = useState(false)
  const [lastMacAddress, setLastMacAddress] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [teamSearch, setTeamSearch] = useState('')
  const toast = useToast()

  const attendanceQuery = useQuery({
    queryKey: ['attendance', 'mine'],
    queryFn: listAttendanceRecords,
  })
  const teamAttendanceQuery = useQuery({
    queryKey: ['attendance', 'team'],
    queryFn: listTeamAttendanceRecords,
    enabled: isHOD,
    staleTime: 15_000,
    refetchInterval: 60_000,
  })

  const rows = attendanceQuery.data ?? []
  const hodTeamRows = useMemo(
    () => teamAttendanceQuery.data ?? [],
    [teamAttendanceQuery.data],
  )
  const filteredTeamRows = useMemo(() => {
    const term = teamSearch.trim().toLowerCase()
    if (!term) return hodTeamRows
    return hodTeamRows.filter((row) =>
      [row.employeeNo, row.staffName, row.jobTitle, row.department, attendanceStatus(row)].some(
        (value) => String(value ?? '').toLowerCase().includes(term),
      ),
    )
  }, [hodTeamRows, teamSearch])
  const teamSummary = useMemo(
    () => ({
      total: hodTeamRows.length,
      signedIn: hodTeamRows.filter((row) => attendanceStatus(row) === 'Signed In').length,
      signedOut: hodTeamRows.filter((row) => attendanceStatus(row) === 'Signed Out').length,
      notSignedIn: hodTeamRows.filter((row) => attendanceStatus(row) === 'Not Signed In').length,
    }),
    [hodTeamRows],
  )
  const now = new Date()
  const todayKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
  const todayRecord = rows.find((row) => row.date.slice(0, 10) === todayKey)
  const signedInToday = isRecordedAttendanceTime(todayRecord?.timeIn)
  const signedOutToday = isRecordedAttendanceTime(todayRecord?.timeOut)

  const signIn = async () => {
    setSubmitting(true)
    try {
      const result = await signInAttendance()
      setLastMacAddress(result.macAddress || result.location || '')
      await queryClient.invalidateQueries({ queryKey: ['attendance'] })
      toast.success(result.comments || 'Attendance recorded successfully.', 'Signed in')
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Attendance sign-in failed.', 'Sign-in failed')
    } finally {
      setSubmitting(false)
    }
  }

  const signOut = async () => {
    setSubmitting(true)
    try {
      const result = await signOutAttendance()
      setLastMacAddress(result.macAddress || result.location || '')
      await queryClient.invalidateQueries({ queryKey: ['attendance'] })
      toast.success(result.comments || 'Attendance sign-out recorded.', 'Signed out')
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Attendance sign-out failed.', 'Sign-out failed')
    } finally {
      setSubmitting(false)
      setConfirmSignOut(false)
    }
  }

  const columns: DataTableColumn<AttendanceRow>[] = [
    { id: 'date', header: 'Date', cell: (row) => row.date },
    { id: 'staff', header: 'Staff Name', cell: (row) => row.staffName },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={attendanceStatus(row)} /> },
    { id: 'in', header: 'Time In', cell: (row) => formatAttendanceClock(row.timeIn) },
    { id: 'out', header: 'Time Out', cell: (row) => formatAttendanceClock(row.timeOut) },
    { id: 'hours', header: 'Hours Worked', cell: (row) => attendanceHours(row.hoursWorked) },
    {
      id: 'mac',
      header: 'MAC Address',
      cell: (row) => formatAttendanceMac(row.macAddress || row.location),
    },
    { id: 'comments', header: 'Comments', cell: (row) => row.comments },
  ]

  const teamColumns: DataTableColumn<AttendanceRow>[] = [
    { id: 'employeeNo', header: 'Staff No.', cell: (row) => row.employeeNo || '—' },
    {
      id: 'staff',
      header: 'Staff Member',
      cell: (row) => (
        <div>
          <p className="font-medium text-slate-900">{row.staffName}</p>
          <p className="text-xs text-slate-500">{row.jobTitle || row.department || '—'}</p>
        </div>
      ),
    },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={attendanceStatus(row)} /> },
    { id: 'in', header: 'Time In', cell: (row) => formatAttendanceClock(row.timeIn) },
    { id: 'out', header: 'Time Out', cell: (row) => formatAttendanceClock(row.timeOut) },
    {
      id: 'hours',
      header: 'Hours',
      cell: (row) => attendanceHours(row.hoursWorked),
    },
    {
      id: 'mac',
      header: 'MAC Address',
      cell: (row) => formatAttendanceMac(row.macAddress || row.location),
    },
    { id: 'comments', header: 'Comments', cell: (row) => row.comments || '—' },
  ]

  return (
    <PageWrapper
      title="Attendance"
      actions={
        <div className="flex flex-wrap gap-2">
          <Button
            type="button"
            variant="success"
            className="rounded-full px-5"
            onClick={() => void signIn()}
            disabled={submitting || signedInToday}
          >
            {submitting && !signedOutToday && !confirmSignOut
              ? 'Signing in…'
              : signedInToday
                ? `Signed in ${formatAttendanceClock(todayRecord?.timeIn)}`
                : 'Sign-in Today'}
          </Button>
          <Button
            type="button"
            variant="action"
            className="rounded-full px-5"
            disabled={submitting || !signedInToday || signedOutToday}
            onClick={() => setConfirmSignOut(true)}
          >
            {signedOutToday
              ? `Signed out ${formatAttendanceClock(todayRecord?.timeOut)}`
              : 'Sign-out Today'}
          </Button>
        </div>
      }
    >
      {lastMacAddress ? (
        <p className="mb-3 text-sm text-slate-600">
          MAC address: <span className="font-medium">{formatAttendanceMac(lastMacAddress)}</span>
        </p>
      ) : null}

      <DataTable
        rows={rows}
        columns={columns}
        getRowId={(row) => row.id}
        emptyTitle="No attendance records yet. Use Sign-in Today to record your attendance."
        selectedRowId={rows.find((row) => row.highlight)?.id}
      />

      {isHOD ? (
        <div className="mt-6">
          <div className="mb-3 flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <h3 className="text-sm font-semibold text-[var(--portal-navy)]">HOD — Department Attendance Today</h3>
              <p className="mt-1 text-sm text-slate-600">
                Every active department staff member is shown, including staff who have not signed in.
              </p>
            </div>
            <Button
              type="button"
              variant="outline"
              size="sm"
              disabled={teamAttendanceQuery.isFetching}
              onClick={() => void teamAttendanceQuery.refetch()}
            >
              {teamAttendanceQuery.isFetching ? 'Refreshing…' : 'Refresh attendance'}
            </Button>
          </div>

          <div className="mb-4 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
            {[
              ['Department Staff', teamSummary.total],
              ['Currently Signed In', teamSummary.signedIn],
              ['Completed / Signed Out', teamSummary.signedOut],
              ['Not Signed In', teamSummary.notSignedIn],
            ].map(([label, value]) => (
              <div key={String(label)} className="rounded-lg border border-slate-200 bg-white px-4 py-3 shadow-sm">
                <p className="text-xs font-medium uppercase tracking-wide text-slate-500">{label}</p>
                <p className="mt-1 text-xl font-semibold text-[var(--portal-navy)]">{value}</p>
              </div>
            ))}
          </div>

          <div className="mb-3 max-w-md">
            <div className="relative">
              <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
              <Input
                value={teamSearch}
                onChange={(event) => setTeamSearch(event.target.value)}
                placeholder="Search staff number, name, role, or status..."
                className="pl-9"
              />
            </div>
          </div>

          {teamAttendanceQuery.isError ? (
            <p className="mb-3 rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
              {teamAttendanceQuery.error instanceof Error
                ? teamAttendanceQuery.error.message
                : 'Department attendance could not be loaded.'}
            </p>
          ) : null}
          <DataTable
            rows={filteredTeamRows}
            columns={teamColumns}
            getRowId={(row) => row.id}
            compact
            emptyTitle={
              teamAttendanceQuery.isLoading
                ? 'Loading department attendance...'
                : teamSearch
                  ? 'No department staff match the search.'
                  : 'No active department staff were found for this HOD.'
            }
          />
        </div>
      ) : null}

      {confirmSignOut ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="w-full max-w-sm rounded-lg bg-white p-5 shadow-xl">
            <p className="text-sm font-medium text-slate-800">Confirm sign-out for today?</p>
            <div className="mt-4 flex justify-end gap-2">
              <Button type="button" variant="outline" onClick={() => setConfirmSignOut(false)}>
                Cancel
              </Button>
              <Button type="button" variant="action" disabled={submitting} onClick={() => void signOut()}>
                {submitting ? 'Signing out…' : 'Sign out'}
              </Button>
            </div>
          </div>
        </div>
      ) : null}
    </PageWrapper>
  )
}
