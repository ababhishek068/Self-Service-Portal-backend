import { useQueries, useQuery } from '@tanstack/react-query'
import { useMemo, useRef, useState } from 'react'
import { CheckCircle2, Download, Eye, FileText, Printer } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { downloadLeaveStatement, fetchLeaveTypes, getLeaveBalance, listLeaveRequests } from '@/api/endpoints/leave'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { PortalFormCard } from '@/components/shared/PortalFormCard'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Button } from '@/components/ui/button'
import { useAuth } from '@/hooks/useAuth'
import { formatDate } from '@/utils/formatters'
import { useToast } from '@/components/feedback/ToastProvider'

/** Round leave-day counts for display (e.g. 5.638356164383562 -> "5.64"), trimming trailing zeros. */
function formatDays(value: unknown) {
  const num = Number(value)
  if (!Number.isFinite(num)) return '—'
  return Number.isInteger(num) ? String(num) : num.toFixed(2).replace(/\.?0+$/, '')
}

interface StatementRow {
  id: string
  leaveType: string
  leaveTypeCode?: string
  startDate: string
  endDate: string
  days: number
  balance: number
  status: string
}

function resolveTypeCode(
  row: { LeaveTypeCode?: string; LeaveType?: string },
  types: Array<{ code: string; description: string }>,
) {
  const code = String(row.LeaveTypeCode ?? '').trim()
  if (code) return code
  const description = String(row.LeaveType ?? '').trim()
  const match = types.find(
    (type) =>
      type.description === description ||
      type.code === description ||
      type.description.toLowerCase() === description.toLowerCase(),
  )
  return match?.code ?? description
}

export function LeaveStatement() {
  const { employee } = useAuth()
  const navigate = useNavigate()
  const printRef = useRef<HTMLDivElement>(null)
  const [leaveType, setLeaveType] = useState('')
  const [downloading, setDownloading] = useState(false)
  const [downloadError, setDownloadError] = useState('')
  const [downloadProgress, setDownloadProgress] = useState(0)
  const toast = useToast()
  const leaveQuery = useQuery({ queryKey: ['hr', 'leave-list'], queryFn: listLeaveRequests })
  const leaveTypesQuery = useQuery({ queryKey: ['hr', 'leave-types'], queryFn: fetchLeaveTypes })
  const balanceQuery = useQuery({
    queryKey: ['hr', 'leave-balance', leaveType],
    queryFn: () => getLeaveBalance(leaveType),
    enabled: Boolean(leaveType),
  })

  const leaveTypes = leaveTypesQuery.data ?? []

  const typeCodes = useMemo(() => {
    const codes = new Set<string>()
    for (const row of leaveQuery.data ?? []) {
      const code = resolveTypeCode(row, leaveTypes)
      if (code) codes.add(code)
    }
    if (leaveType) codes.add(leaveType)
    return [...codes]
  }, [leaveQuery.data, leaveTypes, leaveType])

  const balanceQueries = useQueries({
    queries: typeCodes.map((code) => ({
      queryKey: ['hr', 'leave-balance', code],
      queryFn: () => getLeaveBalance(code),
      enabled: Boolean(code),
    })),
  })

  const balanceByType = useMemo(() => {
    const map: Record<string, number> = {}
    typeCodes.forEach((code, index) => {
      const data = balanceQueries[index]?.data
      map[code] = data?.currentLeaveBalance ?? data?.balance ?? 0
    })
    return map
  }, [typeCodes, balanceQueries])

  const columns: DataTableColumn<StatementRow>[] = [
    { id: 'type', header: 'Leave Type', cell: (row) => row.leaveType },
    { id: 'start', header: 'Start Date', cell: (row) => formatDate(row.startDate) },
    { id: 'end', header: 'End Date', cell: (row) => formatDate(row.endDate) },
    { id: 'days', header: 'Days', cell: (row) => formatDays(row.days) },
    { id: 'balance', header: 'Balance (this type)', cell: (row) => formatDays(row.balance) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
    {
      id: 'actions',
      header: 'Actions',
      cell: (row) => (
        <Button
          type="button"
          variant="ghost"
          size="sm"
          onClick={() =>
            navigate(`/hr/leave-request?application=${encodeURIComponent(row.id)}`)
          }
        >
          <Eye className="h-4 w-4" />
          View
        </Button>
      ),
    },
  ]

  const liveRows: StatementRow[] =
    leaveQuery.data?.map((row) => {
      const leaveTypeCode = resolveTypeCode(row, leaveTypes)
      return {
        id: row.ApplicationCode,
        leaveType: row.LeaveType,
        leaveTypeCode,
        startDate: row.StartDate ?? '',
        endDate: row.EndDate ?? row.StartDate ?? '',
        days: Number(row.DaysApplied) > 0 ? row.DaysApplied ?? 0 : 0,
        balance: balanceByType[leaveTypeCode] ?? 0,
        status: row.Status,
      }
    }) ?? []

  const rows = liveRows.filter(
    (row) => !leaveType || row.leaveTypeCode === leaveType || row.leaveType === leaveType,
  )

  const selectedBalance = leaveType ? balanceByType[leaveType] : undefined

  const generate = async () => {
    if (!leaveType) {
      setDownloadError('Select a leave type first.')
      return
    }
    // Reserve a tab during the click (before any await) so the PDF can be shown
    // without the browser blocking it as a popup.
    const viewer = window.open('', '_blank')
    if (viewer) {
      viewer.document.write(
        '<!doctype html><title>Leave statement</title><body style="font:16px sans-serif;padding:24px;color:#334155">Preparing your leave statement…</body>',
      )
    }
    setDownloading(true)
    setDownloadProgress(12)
    setDownloadError('')
    try {
      window.setTimeout(() => setDownloadProgress((value) => Math.max(value, 38)), 250)
      await downloadLeaveStatement(leaveType, setDownloadProgress, viewer)
      setDownloadProgress(100)
      toast.success('Your leave statement opened in a new tab and was saved to Downloads.', 'PDF ready')
      await new Promise((resolve) => window.setTimeout(resolve, 450))
    } catch (reason) {
      if (viewer && !viewer.closed) viewer.close()
      setDownloadError(reason instanceof Error ? reason.message : 'Leave statement generation failed.')
      setDownloadProgress(0)
    } finally {
      setDownloading(false)
    }
  }

  const printStatement = () => {
    window.print()
  }

  return (
    <PageWrapper title="Leave Statement" showPageHeading={false}>
      <PortalFormCard title="Leave Statement">
        <div className="space-y-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <div className="space-y-1.5">
              <Label htmlFor="leaveType">Leave Type</Label>
              <Select
                id="leaveType"
                value={leaveType}
                onChange={(event) => setLeaveType(event.target.value)}
                placeholder="Select leave type"
                menuPosition="inline"
                options={leaveTypes.map((type) => ({
                  label: type.description,
                  value: type.code,
                }))}
              />
            </div>
            <div className="space-y-1.5">
              <Label>Employee</Label>
              <p className="flex h-10 items-center text-sm font-medium text-slate-700">
                {employee?.employeeNo} — {employee?.displayName}
              </p>
            </div>
          </div>
          {leaveType && balanceQuery.data ? (
            <div className="grid gap-3 rounded-lg border border-slate-200 bg-slate-50 p-4 sm:grid-cols-3">
              <div>
                <p className="text-xs font-semibold uppercase text-slate-500">Available balance</p>
                <p className="text-lg font-bold text-[var(--portal-navy)]">
                  {formatDays(balanceQuery.data.currentLeaveBalance ?? balanceQuery.data.balance ?? 0)}
                </p>
              </div>
              <div>
                <p className="text-xs font-semibold uppercase text-slate-500">Entitlement</p>
                <p className="text-lg font-semibold text-slate-800">
                  {formatDays(balanceQuery.data.entitlement ?? balanceQuery.data.allocatedDays)}
                </p>
              </div>
              <div>
                <p className="text-xs font-semibold uppercase text-slate-500">Earned leave days</p>
                <p className="text-lg font-semibold text-slate-800">
                  {formatDays(balanceQuery.data.earnedLeaveDays)}
                </p>
              </div>
            </div>
          ) : null}
          <div className="flex flex-wrap justify-center gap-2">
            <Button type="button" disabled={downloading} onClick={() => void generate()}>
              <Download className="h-4 w-4" />
              {downloading ? 'Generating...' : 'Generate PDF'}
            </Button>
            <Button type="button" variant="outline" disabled={!rows.length} onClick={printStatement}>
              <Printer className="h-4 w-4" />
              Print Statement
            </Button>
          </div>
          {downloading || downloadProgress === 100 ? (
            <div className="mx-auto w-full max-w-xl rounded-xl border border-blue-100 bg-gradient-to-r from-blue-50 to-slate-50 p-4 shadow-sm" role="status" aria-live="polite">
              <div className="mb-2 flex items-center gap-3">
                <span className="flex h-9 w-9 items-center justify-center rounded-lg bg-[var(--portal-navy)] text-white">
                  {downloadProgress === 100 ? <CheckCircle2 className="h-5 w-5" /> : <FileText className="h-5 w-5 animate-pulse" />}
                </span>
                <div className="min-w-0 flex-1">
                  <p className="text-sm font-semibold text-slate-900">
                    {downloadProgress === 100 ? 'Download ready' : 'Preparing your leave statement'}
                  </p>
                  <p className="text-xs text-slate-500">{downloadProgress}% complete</p>
                </div>
              </div>
              <div className="h-2 overflow-hidden rounded-full bg-blue-100">
                <div className="h-full rounded-full bg-gradient-to-r from-[var(--portal-navy)] via-blue-500 to-[var(--portal-orange)] transition-[width] duration-500 ease-out" style={{ width: `${downloadProgress}%` }} />
              </div>
            </div>
          ) : null}
          {downloadError ? <p className="text-center text-sm text-red-600">{downloadError}</p> : null}
        </div>
      </PortalFormCard>

      <div ref={printRef} className="leave-statement-print mt-6 print:p-4">
        <div className="mb-3 flex flex-wrap items-end justify-between gap-2">
          <h2 className="portal-page-title text-base font-semibold">
            Leave Statement {leaveType ? `— ${leaveTypes.find((t) => t.code === leaveType)?.description ?? leaveType}` : ''}
          </h2>
          {selectedBalance !== undefined ? (
            <p className="text-sm text-slate-600">
              Current balance: <span className="font-semibold text-slate-900">{formatDays(selectedBalance)}</span>
            </p>
          ) : null}
        </div>
        <DataTable
          rows={rows}
          columns={columns}
          getRowId={(row) => row.id}
          compact
          emptyTitle={leaveQuery.isLoading ? 'Loading leave statement...' : 'No leave statement records found'}
        />
        {liveRows.length > 0 ? (
          <p className="mt-2 text-xs text-slate-500 print:text-black">
            {liveRows.length} record(s). Balances are calculated per leave type from Business Central.
          </p>
        ) : null}
      </div>
    </PageWrapper>
  )
}
