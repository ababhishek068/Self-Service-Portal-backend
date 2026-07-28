import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import {
  addDays,
  eachDayOfInterval,
  endOfMonth,
  format,
  isSameDay,
  isSameMonth,
  isWithinInterval,
  parseISO,
  startOfMonth,
  startOfWeek,
} from 'date-fns'
import { ChevronLeft, ChevronRight, RefreshCw } from 'lucide-react'
import { fetchLeaveSchedule, type LeaveScheduleRow } from '@/api/endpoints/leave'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { PortalNewButton } from '@/components/shared/PortalNewButton'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Button } from '@/components/ui/button'
import { Select } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { cn } from '@/lib/utils'
import { usePermissions } from '@/hooks/usePermissions'

function parseDate(value: string) {
  if (!value || value.startsWith('0001-01-01')) return null
  const trimmed = value.trim().slice(0, 10)
  if (!trimmed) return null
  try {
    const parsed = parseISO(trimmed)
    return Number.isNaN(parsed.getTime()) ? null : parsed
  } catch {
    return null
  }
}

function leaveCoversDay(row: LeaveScheduleRow, day: Date) {
  const start = parseDate(row.startDate)
  const end = parseDate(row.endDate)
  if (!start || !end) return false
  return isWithinInterval(day, { start, end })
}

const weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']

export function LeavePlanner() {
  const navigate = useNavigate()
  const { isHOD } = usePermissions()
  const [month, setMonth] = useState(() => startOfMonth(new Date()))
  const [scope, setScope] = useState<'department' | 'self'>('self')
  const query = useQuery({
    queryKey: ['hr', 'leave-schedule', scope],
    queryFn: () => fetchLeaveSchedule(scope),
    staleTime: 30_000,
  })

  const monthDays = useMemo(() => {
    const start = startOfWeek(startOfMonth(month), { weekStartsOn: 1 })
    const end = addDays(endOfMonth(month), 6)
    return eachDayOfInterval({ start, end })
  }, [month])

  const rows = query.data ?? []
  const monthRows = useMemo(
    () =>
      rows.filter((row) => {
        const start = parseDate(row.startDate)
        const end = parseDate(row.endDate)
        if (!start || !end) return false
        return (
          isSameMonth(start, month) ||
          isSameMonth(end, month) ||
          (start < startOfMonth(month) && end > endOfMonth(month))
        )
      }),
    [month, rows],
  )

  const selectedDayRows = useMemo(() => {
    const map = new Map<string, LeaveScheduleRow[]>()
    for (const day of monthDays) {
      if (!isSameMonth(day, month)) continue
      const key = format(day, 'yyyy-MM-dd')
      map.set(
        key,
        monthRows.filter((row) => leaveCoversDay(row, day)),
      )
    }
    return map
  }, [month, monthDays, monthRows])

  return (
    <PageWrapper
      title="Leave Planner"
      description="View your team's leave schedule, then apply from Leave Requisition."
      actions={
        <PortalNewButton
          label="Apply for Leave"
          onClick={() => navigate('/hr/leave-request')}
        />
      }
    >
      <div className="mb-4 rounded-xl border border-blue-100 bg-blue-50/70 px-4 py-3 text-sm text-blue-900">
        This page shows who is on leave. To submit your own leave application, use{' '}
        <button
          type="button"
          className="font-semibold underline underline-offset-2"
          onClick={() => navigate('/hr/leave-request')}
        >
          Leave Requisition
        </button>
        .
      </div>

      <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <Button type="button" variant="outline" size="icon" onClick={() => setMonth((value) => addDays(startOfMonth(value), -1))}>
            <ChevronLeft className="h-4 w-4" />
          </Button>
          <p className="min-w-[10rem] text-center text-sm font-semibold text-slate-800">
            {format(month, 'MMMM yyyy')}
          </p>
          <Button type="button" variant="outline" size="icon" onClick={() => setMonth((value) => addDays(endOfMonth(value), 1))}>
            <ChevronRight className="h-4 w-4" />
          </Button>
        </div>
        <div className="flex items-center gap-2">
          <Button
            type="button"
            variant="outline"
            size="icon"
            onClick={() => query.refetch()}
            disabled={query.isFetching}
            title="Refresh schedule"
          >
            <RefreshCw className={cn('h-4 w-4', query.isFetching && 'animate-spin')} />
          </Button>
          <Select
            value={scope}
            onChange={(event) => setScope(event.target.value as 'department' | 'self')}
            options={[
              { value: 'self', label: 'My leave only' },
              { value: 'department', label: isHOD ? 'Department schedule' : 'Team schedule' },
            ]}
          />
        </div>
      </div>

      {query.isError ? (
        <p className="mb-4 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
          Could not load leave schedule. Try refresh, or check Leave Requisition for your applications.
        </p>
      ) : null}

      {query.isLoading ? (
        <Skeleton className="h-96 w-full" />
      ) : (
        <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
          <div className="grid grid-cols-7 border-b border-slate-200 bg-slate-50">
            {weekdayLabels.map((label) => (
              <div key={label} className="px-2 py-2 text-center text-xs font-semibold uppercase tracking-wide text-slate-500">
                {label}
              </div>
            ))}
          </div>
          <div className="grid grid-cols-7">
            {monthDays.map((day) => {
              const key = format(day, 'yyyy-MM-dd')
              const dayRows = selectedDayRows.get(key) ?? []
              const inMonth = isSameMonth(day, month)
              const isToday = isSameDay(day, new Date())
              return (
                <div
                  key={key}
                  className={cn(
                    'min-h-28 border-b border-r border-slate-100 p-2 align-top',
                    !inMonth && 'bg-slate-50/80 text-slate-400',
                  )}
                >
                  <div className="mb-1 flex items-center justify-between gap-1">
                    <span
                      className={cn(
                        'inline-flex h-6 w-6 items-center justify-center rounded-full text-xs font-semibold',
                        isToday && 'bg-[var(--portal-navy)] text-white',
                      )}
                    >
                      {format(day, 'd')}
                    </span>
                    {dayRows.length > 0 ? (
                      <span className="rounded-full bg-orange-100 px-1.5 py-0.5 text-[10px] font-semibold text-orange-700">
                        {dayRows.length}
                      </span>
                    ) : null}
                  </div>
                  <div className="space-y-1">
                    {dayRows.slice(0, 3).map((row) => (
                      <div
                        key={`${row.id}-${key}`}
                        className={cn(
                          'truncate rounded px-1.5 py-0.5 text-[10px] font-medium',
                          row.isSelf ? 'bg-blue-100 text-blue-800' : 'bg-emerald-50 text-emerald-800',
                        )}
                        title={`${row.employeeName}${row.jobTitle ? ` · ${row.jobTitle}` : ''} · ${row.leaveType}`}
                      >
                        {row.isSelf ? 'You' : row.employeeName.split(' ')[0]} · {row.leaveType}
                      </div>
                    ))}
                    {dayRows.length > 3 ? (
                      <p className="text-[10px] text-slate-500">+{dayRows.length - 3} more</p>
                    ) : null}
                  </div>
                </div>
              )
            })}
          </div>
        </div>
      )}

      <div className="mt-6">
        <h2 className="mb-3 text-base font-semibold text-slate-900">Scheduled leave this month</h2>
        {monthRows.length === 0 ? (
          <p className="rounded-xl border border-dashed border-slate-200 bg-slate-50 px-4 py-8 text-center text-sm text-slate-500">
            No leave scheduled for {format(month, 'MMMM yyyy')}.
            {scope === 'department' ? ' Try switching to My leave only.' : ' Apply from Leave Requisition if you have not yet.'}
          </p>
        ) : (
          <div className="space-y-2">
            {monthRows.map((row) => (
              <div
                key={row.id}
                className="flex flex-wrap items-center justify-between gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3 shadow-sm"
              >
                <div className="min-w-0">
                  <p className="font-medium text-slate-900">
                    {row.isSelf ? 'You' : row.employeeName}
                    {row.jobTitle ? <span className="font-normal text-slate-500"> · {row.jobTitle}</span> : null}
                  </p>
                  <p className="text-sm text-slate-600">
                    {row.leaveType} · {format(parseDate(row.startDate) ?? new Date(), 'd MMM')} –{' '}
                    {format(parseDate(row.endDate) ?? new Date(), 'd MMM yyyy')}
                  </p>
                </div>
                <StatusBadge status={row.status} />
              </div>
            ))}
          </div>
        )}
      </div>
    </PageWrapper>
  )
}
