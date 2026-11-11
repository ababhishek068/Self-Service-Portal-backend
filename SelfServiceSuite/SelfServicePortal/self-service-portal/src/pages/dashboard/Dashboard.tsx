import type { MouseEvent, ReactNode } from 'react'
import { useQuery } from '@tanstack/react-query'
import { Link } from 'react-router-dom'
import {
  ArrowRight,
  ArrowUpRight,
  Banknote,
  CalendarDays,
  CalendarPlus,
  ChevronRight,
  CircleCheck,
  CircleX,
  ClipboardCheck,
  ClipboardList,
  Coins,
  CornerUpLeft,
  DoorOpen,
  Eye,
  Fingerprint,
  HeartPulse,
  Hourglass,
  LayoutGrid,
  Mail,
  Timer,
  PackageCheck,
  PackageOpen,
  Receipt,
  ReceiptText,
  ScrollText,
  ShieldCheck,
  ShoppingCart,
  Store,
  Wallet,
} from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import type { PortalNotificationKind } from '@/api/endpoints/notifications'
import { useNotifications } from '@/hooks/useNotifications'
import { notificationHref, requestPageHref } from '@/utils/requestLinks'
import { getToken, resolveApiBaseUrl } from '@/api/client/authClient'
import { BACKEND_NOT_CONFIGURED } from '@/api/requireBackend'
import { getDashboardSummary } from '@/api/endpoints/employee'
import { getMyStoreRoles } from '@/api/endpoints/requestEndpoint'
import {
  DocumentsByModuleChart,
  StockAvailabilityPanel,
  WorkflowStatusChart,
} from '@/components/dashboard/DashboardAnalytics'
import { PageWrapper } from '@/components/layout/PageWrapper'
import { DataTable, type DataTableColumn } from '@/components/shared/DataTable'
import { StatusBadge } from '@/components/shared/StatusBadge'
import { Skeleton } from '@/components/ui/skeleton'
import { useAuth } from '@/hooks/useAuth'
import { useCountUp } from '@/hooks/useCountUp'
import { usePermissions } from '@/hooks/usePermissions'
import { approverRoles, type PortalRole } from '@/config/roles'
import { formatAttendanceClock, formatCurrency, formatDate, formatDateTime, isRecordedAttendanceTime } from '@/utils/formatters'
import { listAttendanceRecords, type AttendanceRow } from '@/api/endpoints/attendance'
import type { PortalRequest } from '@/types/erp.types'
import { brand } from '@/config/brand'
import { cn } from '@/lib/utils'

/** Business-area accent (see `.tone-*` in index.css): teal approvals, lime HR, blue finance, indigo facility. */
type Tone = 'teal' | 'lime' | 'blue' | 'indigo'

interface DashboardTile {
  id: string
  label: string
  href: string
  icon: LucideIcon
  tone: Tone
  /** When set, only show this tile to users holding one of these roles. */
  roles?: PortalRole[]
  /** Show this tile when backend says the user can approve, even if their role is staff. */
  requiresApproval?: boolean
}

/** KPI tiles aligned to ABH UAT modules currently published in the sidebar. */
const tiles: DashboardTile[] = [
  {
    id: 'pendingApprovals',
    label: 'Pending Approval',
    href: '/approvals',
    icon: Hourglass,
    tone: 'teal',
    roles: approverRoles,
    requiresApproval: true,
  },
  {
    id: 'approvedDocuments',
    label: 'Approved Documents',
    href: '/approvals/approved',
    icon: ClipboardCheck,
    tone: 'teal',
    roles: approverRoles,
    requiresApproval: true,
  },
  {
    id: 'rejectedDocuments',
    label: 'Rejected Documents',
    href: '/approvals/rejected',
    icon: CircleX,
    tone: 'teal',
    roles: approverRoles,
    requiresApproval: true,
  },
  { id: 'leaveApplications', label: 'Leave Applications', href: '/hr/leave-request', icon: CalendarDays, tone: 'lime' },
  { id: 'staffClaims', label: 'Staff Claims', href: '/finance/staff-claim', icon: Receipt, tone: 'blue' },
  { id: 'imprestRequisitions', label: 'Advance Payments', href: '/finance/advance-payment', icon: Banknote, tone: 'blue' },
  { id: 'pettyCash', label: 'Petty Cash Request', href: '/finance/petty-cash', icon: Coins, tone: 'blue' },
  { id: 'imprestSurrenders', label: 'Advance Settlements', href: '/finance/advance-settlement', icon: ReceiptText, tone: 'blue' },
  {
    id: 'purchaseRequisitions',
    label: 'Local Purchase',
    href: '/facility/local-purchase-request',
    icon: ShoppingCart,
    tone: 'indigo',
  },
  { id: 'storeRequisitions', label: 'Store Requisitions', href: '/facility/store-requisition', icon: Store, tone: 'indigo' },
  { id: 'overtimeRequests', label: 'Overtime', href: '/hr/overtime-work-request', icon: Timer, tone: 'lime' },
]

/** Icon + area for each quick link (the role config only carries text). */
const QUICK_LINK_META: Record<string, { icon: LucideIcon; tone: Tone }> = {
  '/hr/leave-request': { icon: CalendarPlus, tone: 'lime' },
  '/hr/overtime-work-request': { icon: Timer, tone: 'lime' },
  '/hr/overtime-request': { icon: Timer, tone: 'lime' },
  '/hr/payslip': { icon: Wallet, tone: 'lime' },
  '/hr/attendance': { icon: Fingerprint, tone: 'lime' },
  '/hr/leave-statement': { icon: ScrollText, tone: 'lime' },
  '/hr/request-letters': { icon: Mail, tone: 'lime' },
  '/hr/employee-exit': { icon: DoorOpen, tone: 'lime' },
  '/approvals': { icon: ClipboardCheck, tone: 'teal' },
  '/finance/advance-payment': { icon: Banknote, tone: 'blue' },
  '/finance/imprest': { icon: Banknote, tone: 'blue' },
  '/finance/staff-claim': { icon: Receipt, tone: 'blue' },
  '/finance/medical-claim': { icon: HeartPulse, tone: 'blue' },
  '/finance/petty-cash': { icon: Coins, tone: 'blue' },
  '/finance/advance-settlement': { icon: ReceiptText, tone: 'blue' },
  '/finance/advance-surrender': { icon: ReceiptText, tone: 'blue' },
  '/finance/imprest-surrender': { icon: ReceiptText, tone: 'blue' },
  '/facility/local-purchase-request': { icon: ShoppingCart, tone: 'indigo' },
  '/facility/store-requisition': { icon: Store, tone: 'indigo' },
}

function quickLinkMeta(href: string): { icon: LucideIcon; tone: Tone } {
  const known = QUICK_LINK_META[href]
  if (known) return known
  if (href.startsWith('/finance')) return { icon: LayoutGrid, tone: 'blue' }
  if (href.startsWith('/facility')) return { icon: LayoutGrid, tone: 'indigo' }
  if (href.startsWith('/approvals')) return { icon: LayoutGrid, tone: 'teal' }
  return { icon: LayoutGrid, tone: 'lime' }
}

/** Recent Activity opens each request on its module page. */
function activityHref(row: PortalRequest) {
  return requestPageHref(row.requestType, row.id)
}

/** Dashboard banners besides the approval one: store hand-off steps and requests sent back. */
const BANNER_ICONS: Partial<Record<PortalNotificationKind, LucideIcon>> = {
  returned: CornerUpLeft,
  storeIssue: Store,
  storeAccept: PackageCheck,
  storeLpr: ShoppingCart,
  storeReceive: PackageOpen,
  localPurchase: ClipboardList,
}

function greetingFor(date: Date) {
  const hour = date.getHours()
  if (hour < 12) return 'Good morning'
  if (hour < 17) return 'Good afternoon'
  return 'Good evening'
}

/** Feeds the pointer position to the tile's spotlight (`--mx` / `--my`). */
function trackPointer(event: MouseEvent<HTMLElement>) {
  const el = event.currentTarget
  const rect = el.getBoundingClientRect()
  el.style.setProperty('--mx', `${event.clientX - rect.left}px`)
  el.style.setProperty('--my', `${event.clientY - rect.top}px`)
}

function CountUp({ value }: { value: number }) {
  const shown = useCountUp(value)
  const whole = Number.isInteger(value)
  return <>{whole ? Math.round(shown).toLocaleString() : shown.toFixed(1)}</>
}

function SectionHeader({ title, subtitle, action }: { title: string; subtitle?: string; action?: ReactNode }) {
  return (
    <div className="mb-3 flex items-end justify-between gap-3">
      <div className="min-w-0">
        <h2 className="text-[15px] font-semibold tracking-tight text-slate-900">{title}</h2>
        {subtitle ? <p className="mt-0.5 text-xs text-slate-500">{subtitle}</p> : null}
      </div>
      {action}
    </div>
  )
}

type PanelTone = 'teal' | 'orange' | 'lime' | 'blue' | 'indigo'

interface PanelItem {
  key: string
  icon: LucideIcon
  tone: PanelTone
  title: string
  detail?: string
  href: string
  count?: number
  /** Stronger amber callout for actionable approval rows. */
  highlight?: boolean
}

function PanelRow({ item }: { item: PanelItem }) {
  const Icon = item.icon
  return (
    <Link
      to={item.href}
      className={cn('portal-today-row group', item.highlight && 'portal-today-row--attention')}
    >
      <span className={cn('portal-today-icon', `portal-today-icon--${item.tone}`)}>
        <Icon className="h-4 w-4" />
      </span>
      <span className="min-w-0 flex-1">
        <span className="block truncate text-sm font-semibold text-white">{item.title}</span>
        {item.detail ? (
          <span
            className={cn(
              'block truncate text-xs',
              item.highlight ? 'text-amber-50/90' : 'text-white/60',
            )}
          >
            {item.detail}
          </span>
        ) : null}
      </span>
      {item.count && item.count > 1 ? (
        <span className="rounded-full bg-white/15 px-2 py-0.5 text-[11px] font-bold tabular-nums text-white">{item.count}</span>
      ) : null}
      <ChevronRight
        className={cn(
          'h-4 w-4 shrink-0 transition-transform duration-200 group-hover:translate-x-0.5 group-hover:text-white',
          item.highlight ? 'text-amber-100' : 'text-white/45',
        )}
      />
    </Link>
  )
}

/** "08:12:00" -> "08:12": seconds add nothing on a dashboard. */
function clock(value?: string | null) {
  return formatAttendanceClock(value).replace(/^(\d{1,2}:\d{2}):\d{2}(?=\D|$)/, '$1')
}

/** Today's attendance in one line, with the next step; signing in itself stays on the Attendance page. */
function AttendanceToday({ rows, loading, failed }: { rows: AttendanceRow[]; loading: boolean; failed: boolean }) {
  const now = new Date()
  const todayKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
  const todayRecord = rows.find((row) => row.date.slice(0, 10) === todayKey)
  // Same rules as the Attendance page: an open sign-in (today or earlier) must be signed out first.
  const openSignIn = rows.find((row) => isRecordedAttendanceTime(row.timeIn) && !isRecordedAttendanceTime(row.timeOut))
  const signedInToday = isRecordedAttendanceTime(todayRecord?.timeIn)
  const signedOutToday = isRecordedAttendanceTime(todayRecord?.timeOut)

  let label = 'Not signed in yet'
  let detail = 'Sign in when you start work'
  let action = 'Sign in'
  let primary = true
  if (loading) {
    label = 'Checking attendance…'
    detail = ''
    action = 'Open'
    primary = false
  } else if (failed) {
    label = 'Attendance'
    detail = 'Sign in and out for the day'
    action = 'Open'
    primary = false
  } else if (openSignIn && openSignIn.date.slice(0, 10) !== todayKey) {
    label = `Still signed in since ${formatDate(openSignIn.date)}`
    detail = 'Sign out to close that day'
    action = 'Sign out'
  } else if (signedInToday && !signedOutToday) {
    label = `Signed in at ${clock(todayRecord?.timeIn)}`
    detail = 'Remember to sign out when you leave'
    action = 'Sign out'
    primary = false
  } else if (signedInToday && signedOutToday) {
    label = `Signed out at ${clock(todayRecord?.timeOut)}`
    detail = todayRecord?.hoursWorked ? `${todayRecord.hoursWorked} worked today` : 'Day complete'
    action = 'View'
    primary = false
  }

  return (
    <div className="portal-today-attendance">
      <span className="portal-today-icon portal-today-icon--lime">
        <Fingerprint className="h-4 w-4" />
      </span>
      <div className="min-w-0 flex-1">
        <p className="text-[10.5px] font-semibold uppercase tracking-[0.1em] text-white/55">Attendance today</p>
        <p className={cn('truncate text-sm font-semibold text-white', loading && 'animate-pulse')}>{label}</p>
        {detail ? <p className="truncate text-xs text-white/60">{detail}</p> : null}
      </div>
      <Link
        to="/hr/attendance"
        className={cn(
          'portal-hero-cta shrink-0 rounded-lg px-3 py-1.5 text-xs font-bold',
          primary ? 'bg-[#d2d741] text-[#26225b] shadow-md shadow-black/20' : 'bg-white/12 text-white ring-1 ring-inset ring-white/25 hover:bg-white/20',
        )}
      >
        {action}
      </Link>
    </div>
  )
}

function KpiTile({ tile, value }: { tile: DashboardTile; value: number }) {
  const Icon = tile.icon
  return (
    <Link
      to={tile.href}
      data-kpi-tile
      onMouseMove={trackPointer}
      className={cn('portal-kpi group flex items-center gap-3.5 p-4 pr-5', `tone-${tile.tone}`)}
    >
      <span className="tone-chip h-12 w-12">
        <Icon className="h-[22px] w-[22px]" />
      </span>
      <div className="min-w-0 flex-1">
        <p
          className={cn(
            'text-[1.75rem] font-semibold leading-none tracking-tight tabular-nums',
            value === 0 ? 'text-slate-400' : 'text-slate-900',
          )}
        >
          <CountUp value={value} />
        </p>
        <p className="mt-1.5 text-[13px] font-medium leading-snug text-slate-600">{tile.label}</p>
      </div>
      <ArrowUpRight className="portal-kpi-arrow absolute right-3 top-3 h-4 w-4 text-slate-400" />
    </Link>
  )
}

function userLooksLikeStoreManager(employee: ReturnType<typeof useAuth>['employee']) {
  const assignment = [employee?.jobTitle, employee?.departmentName, employee?.departmentCode, ...(employee?.roles ?? [])]
    .map((value) => String(value ?? '').trim().toLowerCase())
    .join(' ')
  return /\bstore\s*manager\b|\bstores\s*manager\b|\bmain\s*store\b|\bstoremanager\b/.test(assignment)
}

export function Dashboard() {
  const { employee, isAuthenticated, bootstrapped } = useAuth()
  const { has, canApprove, primaryRoleLabel, quickLinks } = usePermissions()
  const apiBase = resolveApiBaseUrl()
  const canFetchSummary =
    bootstrapped && isAuthenticated && Boolean(apiBase) && Boolean(getToken())
  const summary = useQuery({
    queryKey: ['dashboard'],
    queryFn: getDashboardSummary,
    enabled: canFetchSummary,
  })
  // Stock Power BI panel is Store Manager only; module/workflow analytics stay for everyone.
  const storeRolesQuery = useQuery({
    queryKey: ['store-requisition', 'my-roles'],
    queryFn: getMyStoreRoles,
    enabled: canFetchSummary,
    staleTime: 60_000,
    retry: false,
  })
  const showStockPanel =
    userLooksLikeStoreManager(employee) || storeRolesQuery.data?.storeManager === true
  const firstName = employee?.displayName?.split(' ')[0] ?? 'there'
  const profileSubtitle = employee?.jobTitle?.trim() || primaryRoleLabel
  const data = summary.data ?? null
  const tileValues = (data ?? {}) as Record<string, number | undefined>
  const summaryError =
    summary.error instanceof Error
      ? summary.error.message
      : !apiBase
        ? BACKEND_NOT_CONFIGURED
        : null
  const visibleTiles = tiles.filter((tile) => {
    if (tile.requiresApproval) return canApprove
    return !tile.roles || has(tile.roles)
  })
  const approvalTiles = visibleTiles.filter((tile) => tile.requiresApproval)
  const requestTiles = visibleTiles.filter((tile) => !tile.requiresApproval)
  const pendingCount = tileValues.pendingApprovals ?? 0
  const notifications = useNotifications()
  const banners = (notifications.data?.items ?? []).filter((item) => item.kind !== 'approvals')
  const now = new Date()
  const today = now.toLocaleDateString(undefined, {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  })

  const attendance = useQuery({
    queryKey: ['dashboard', 'attendance'],
    queryFn: listAttendanceRecords,
    enabled: canFetchSummary,
    retry: false,
  })

  /** Things the user can act on now: approvals, requests sent back, store / purchase steps. */
  const noticeItems = notifications.data?.items ?? []
  const approvalNotice = noticeItems.find((item) => item.kind === 'approvals')
  const attention: PanelItem[] = []
  if (canApprove && pendingCount > 0) {
    attention.push({
      key: 'approvals',
      icon: Hourglass,
      tone: 'orange',
      title: `${pendingCount} document${pendingCount === 1 ? '' : 's'} to approve`,
      detail: approvalNotice?.description || 'Review and approve, send back or reject.',
      href: '/approvals',
      highlight: true,
    })
  } else if (approvalNotice) {
    attention.push({
      key: approvalNotice.id,
      icon: Hourglass,
      tone: 'orange',
      title: approvalNotice.title,
      detail: approvalNotice.description,
      href: notificationHref(approvalNotice),
      highlight: true,
    })
  }
  for (const item of banners) {
    attention.push({
      key: item.id,
      icon: BANNER_ICONS[item.kind] ?? Store,
      tone: item.kind === 'returned' ? 'orange' : 'indigo',
      title: item.title,
      detail: item.description,
      href: notificationHref(item),
      count: item.count,
    })
  }

  /** The user's own requests still with an approver. */
  const waiting: PanelItem[] = (data?.recentActivity ?? [])
    .filter((row) => /pending/i.test(String(row.status)))
    .map((row) => {
      const href = activityHref(row)
      const page = requestPageHref(row.requestType)
      return href
        ? {
            key: `waiting-${row.id}`,
            icon: page ? quickLinkMeta(page).icon : ClipboardList,
            tone: 'blue' as const,
            title: `${row.requestNo} · ${row.title}`,
            detail: `Waiting for approval · sent ${formatDate(row.createdAt)}`,
            href,
          }
        : null
    })
    .filter((item): item is NonNullable<typeof item> => item !== null)
    .slice(0, 2)
  const leaveBalance = tileValues.leaveBalance ?? 0

  const heroActions = quickLinks.slice(0, 2)

  const activityColumns: DataTableColumn<PortalRequest>[] = [
    {
      id: 'requestNo',
      header: 'No.',
      cell: (row) => {
        const href = activityHref(row)
        return href ? (
          <Link to={href} className="font-semibold text-[var(--portal-navy-dark)] underline-offset-2 hover:underline">
            {row.requestNo}
          </Link>
        ) : (
          row.requestNo
        )
      },
    },
    { id: 'title', header: 'Request', cell: (row) => row.title },
    { id: 'date', header: 'Date', cell: (row) => formatDateTime(row.createdAt) },
    { id: 'amount', header: 'Amount', cell: (row) => formatCurrency(row.amount) },
    { id: 'status', header: 'Status', cell: (row) => <StatusBadge status={row.status} /> },
    {
      id: 'view',
      header: 'View',
      cell: (row) => {
        const href = activityHref(row)
        return href ? (
          <Link
            to={href}
            aria-label={`View ${row.requestNo}`}
            className="inline-flex items-center gap-1 rounded-md px-2 py-1 text-xs font-semibold text-[var(--portal-navy-dark)] hover:bg-teal-50"
          >
            <Eye className="h-3.5 w-3.5" /> View
          </Link>
        ) : null
      },
    },
  ]

  return (
    <PageWrapper title="Dashboard">
      {!canFetchSummary && bootstrapped ? (
        <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
          {!apiBase
            ? BACKEND_NOT_CONFIGURED
            : 'Sign in again to load dashboard data from the server.'}
        </div>
      ) : null}

      {summary.isError ? (
        <div className="mb-4 rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-800">
          <p className="font-semibold">Dashboard could not load</p>
          <p className="mt-1">{summaryError ?? 'Request failed. Is the backend running?'}</p>
          {apiBase ? (
            <p className="mt-2 text-xs text-red-700">
              Expected API: <code className="rounded bg-red-100 px-1">{apiBase}/api/dashboard/summary</code>
            </p>
          ) : null}
        </div>
      ) : null}

      {summary.isLoading || (canFetchSummary && !summary.data && !summary.isError) ? (
        <div className="space-y-6">
          <Skeleton className="h-60 w-full rounded-3xl" />
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
            {Array.from({ length: 4 }, (_, index) => (
              <Skeleton key={index} className="h-36 rounded-2xl" />
            ))}
          </div>
        </div>
      ) : summary.data ? (
        <div className="space-y-4">
          {/* ---------- Hero ---------- */}
          <section className="portal-hero animate-page-in-subtle p-5 sm:p-6 lg:p-7">
            <div className="portal-hero-aurora" aria-hidden>
              <span />
              <span />
              <span />
            </div>
            <div className="portal-hero-grid" aria-hidden />

            <div className="grid grid-cols-[minmax(0,1fr)] items-center gap-6 lg:grid-cols-[minmax(0,1.15fr)_minmax(0,1fr)] lg:gap-10">
              <div className="min-w-0">
                <p className="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1 text-xs font-medium text-white/85 ring-1 ring-inset ring-white/15 backdrop-blur">
                  <span className="relative flex h-2 w-2" aria-hidden>
                    <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-[#d2d741] opacity-60" />
                    <span className="relative inline-flex h-2 w-2 rounded-full bg-[#d2d741]" />
                  </span>
                  {today}
                </p>
                <h2 className="mt-4 text-[1.75rem] font-semibold leading-tight tracking-tight sm:text-4xl">
                  {greetingFor(now)}, <span className="portal-hero-name">{firstName}</span>
                </h2>
                <div className="mt-2.5 flex flex-wrap items-center gap-2 text-sm text-white/70">
                  <span
                    className={cn(
                      'rounded-full bg-white/12 px-2.5 py-0.5 text-xs font-semibold text-white ring-1 ring-inset ring-white/20',
                      employee?.jobTitle?.trim() ? 'normal-case' : 'uppercase tracking-wide',
                    )}
                  >
                    {profileSubtitle}
                  </span>
                  <Link
                    to="/hr/leave-statement"
                    className="inline-flex items-center gap-1.5 rounded-full bg-[#d2d741]/15 px-2.5 py-0.5 text-xs font-semibold text-[#eef3b0] ring-1 ring-inset ring-[#d2d741]/30 transition-colors hover:bg-[#d2d741]/25"
                  >
                    <CalendarDays className="h-3.5 w-3.5" />
                    {leaveBalance % 1 === 0 ? leaveBalance : leaveBalance.toFixed(1)} days leave
                  </Link>
                  {employee?.departmentName ? <span className="truncate">{employee.departmentName}</span> : null}
                </div>
                {/* Sample data presentation instead of the long module list. */}
                <div className="portal-hero-data mt-4 hidden sm:block" aria-hidden>
                  <div className="mb-2 flex items-center justify-between gap-2">
                    <p className="text-xs font-semibold text-white/80">Your portal pulse</p>
                    <p className="text-[10px] text-white/50">Sample overview</p>
                  </div>
                  <div className="grid grid-cols-[1.1fr_0.9fr] gap-3">
                    <div className="portal-hero-stat p-3">
                      <svg viewBox="0 0 220 64" className="h-14 w-full" role="img" aria-label="Sample activity sparkline">
                        <defs>
                          <linearGradient id="heroSparkFill" x1="0" y1="0" x2="0" y2="1">
                            <stop offset="0%" stopColor="#9df2fc" stopOpacity="0.45" />
                            <stop offset="100%" stopColor="#9df2fc" stopOpacity="0" />
                          </linearGradient>
                        </defs>
                        <path
                          d="M0,48 L28,40 L56,44 L84,28 L112,34 L140,18 L168,24 L196,12 L220,16 L220,64 L0,64 Z"
                          fill="url(#heroSparkFill)"
                        />
                        <polyline
                          fill="none"
                          stroke="#9df2fc"
                          strokeWidth="2.25"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          points="0,48 28,40 56,44 84,28 112,34 140,18 168,24 196,12 220,16"
                        />
                      </svg>
                      <p className="mt-1 text-[11px] text-white/60">Requests this week</p>
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      {[
                        { label: 'Approvals', value: String(pendingCount) },
                        { label: 'Open', value: String(tileValues.openRequests ?? 0) },
                        { label: 'Leave bal.', value: leaveBalance % 1 === 0 ? String(leaveBalance) : leaveBalance.toFixed(1) },
                        { label: 'Attention', value: String(attention.length) },
                      ].map((stat) => (
                        <div key={stat.label} className="portal-hero-stat px-2.5 py-2">
                          <p className="text-[10px] uppercase tracking-wide text-white/55">{stat.label}</p>
                          <p className="mt-0.5 text-lg font-bold tabular-nums text-white">{stat.value}</p>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>

                {heroActions.length > 0 ? (
                  <div className="mt-5 flex flex-wrap gap-2.5">
                    {heroActions.map((link, index) => {
                      const Icon = quickLinkMeta(link.href).icon
                      return (
                        <Link
                          key={link.href}
                          to={link.href}
                          className={cn(
                            'portal-hero-cta inline-flex items-center gap-2 rounded-xl px-4 py-2.5 text-sm font-semibold',
                            index === 0
                              ? 'bg-[#fff] text-[#26225b] shadow-lg shadow-black/25 hover:shadow-xl'
                              : 'bg-white/10 text-white ring-1 ring-inset ring-white/25 backdrop-blur hover:bg-white/15',
                          )}
                        >
                          <Icon className="h-4 w-4" />
                          {link.label}
                          <ArrowRight className="h-4 w-4 opacity-70" />
                        </Link>
                      )
                    })}
                  </div>
                ) : null}
              </div>

              <div className="portal-today animate-page-in-subtle" style={{ animationDelay: '120ms' }}>
                <div className="flex items-center justify-between">
                  <p className="text-sm font-semibold text-white">Today</p>
                  <span className="text-xs text-white/55">
                    {now.toLocaleDateString(undefined, { weekday: 'short', day: 'numeric', month: 'short' })}
                  </span>
                </div>

                <AttendanceToday
                  rows={attendance.data ?? []}
                  loading={attendance.isLoading}
                  failed={attendance.isError}
                />

                <div className="portal-today-section">
                  <p className="portal-today-label">Needs your attention</p>
                  {attention.length > 0 ? (
                    <>
                      {attention.slice(0, 3).map((item) => (
                        <PanelRow key={item.key} item={item} />
                      ))}
                      {attention.length > 3 ? (
                        <p className="px-1 text-xs text-white/55">+{attention.length - 3} more under the bell</p>
                      ) : null}
                    </>
                  ) : (
                    <div className="flex items-center gap-3 px-1 py-1.5">
                      <span className="portal-today-icon portal-today-icon--teal">
                        <CircleCheck className="h-4 w-4" />
                      </span>
                      <span className="min-w-0">
                        <span className="block text-sm font-semibold text-white">You're all caught up</span>
                        <span className="block text-xs text-white/60">Nothing needs you right now.</span>
                      </span>
                    </div>
                  )}
                </div>

                {waiting.length > 0 ? (
                  <div className="portal-today-section">
                    <p className="portal-today-label">Waiting on others</p>
                    {waiting.map((item) => (
                      <PanelRow key={item.key} item={item} />
                    ))}
                  </div>
                ) : null}
              </div>
            </div>
          </section>

          {/* ---------- Tiles + activity + analytics | quick actions ---------- */}
          <div className="grid items-start gap-4 xl:grid-cols-[minmax(0,1fr)_20rem]">
            {/* Keep analytics in this column so it sits under Recent activity — not below the tall Quick actions rail. */}
            <div className="@container min-w-0 space-y-4">
              {approvalTiles.length > 0 ? (
                <section>
                  <SectionHeader title="Approvals" subtitle="Documents routed to you through Business Central" />
                  <div className="portal-stagger grid grid-cols-2 gap-3 @lg:grid-cols-3">
                    {approvalTiles.map((tile) => (
                      <KpiTile key={tile.id} tile={tile} value={tileValues[tile.id] ?? 0} />
                    ))}
                  </div>
                </section>
              ) : null}

              {requestTiles.length > 0 ? (
                <section>
                  <SectionHeader title="My requests" subtitle="Everything you have raised, by module" />
                  <div className="portal-stagger grid grid-cols-2 gap-3 @lg:grid-cols-3 @3xl:grid-cols-4">
                    {requestTiles.map((tile) => (
                      <KpiTile key={tile.id} tile={tile} value={tileValues[tile.id] ?? 0} />
                    ))}
                  </div>
                </section>
              ) : null}

              <section className="portal-panel animate-page-in-subtle p-3 sm:p-4" style={{ animationDelay: '120ms' }}>
                <SectionHeader title="Recent activity" subtitle="Your latest requests and where they are" />
                <DataTable
                  rows={summary.data?.recentActivity ?? []}
                  columns={activityColumns}
                  getRowId={(row) => row.id}
                  compact
                />
              </section>

              <section className="space-y-2.5">
                <SectionHeader
                  title={showStockPanel ? 'Analytics & stock' : 'Analytics'}
                  subtitle={
                    showStockPanel
                      ? 'Power BI–style insights from your documents and inventory'
                      : 'Power BI–style insights from your documents'
                  }
                />
                <div className="grid items-stretch gap-3 @lg:grid-cols-2">
                  <DocumentsByModuleChart
                    rows={
                      summary.data.documentsByModule ??
                      requestTiles.map((tile) => ({
                        key: tile.id,
                        label: tile.label,
                        count: tileValues[tile.id] ?? 0,
                      }))
                    }
                  />
                  <WorkflowStatusChart
                    rows={
                      summary.data.workflowStatus ?? [
                        { label: 'Posted', count: 0 },
                        { label: 'Pending', count: tileValues.openRequests ?? 0 },
                        { label: 'Draft', count: 0 },
                        { label: 'Returned', count: 0 },
                        { label: 'Rejected', count: tileValues.rejectedDocuments ?? 0 },
                      ]
                    }
                  />
                  {showStockPanel ? (
                    <div className="@lg:col-span-2">
                      <StockAvailabilityPanel stock={summary.data.stockAvailability} />
                    </div>
                  ) : null}
                </div>
              </section>
            </div>

            {/* Quick actions only on tablet / desktop: on a phone the list filled the screen (UAT); the menu has them. */}
            {quickLinks.length > 0 ? (
              <aside className="portal-panel hidden self-start p-3 sm:block sm:p-3.5 xl:sticky xl:top-4">
                <SectionHeader title="Quick actions" subtitle="Start a new request" />
                <div className="grid gap-0.5 sm:grid-cols-2 xl:grid-cols-1">
                  {quickLinks.map((link) => {
                    const meta = quickLinkMeta(link.href)
                    const Icon = meta.icon
                    return (
                      <Link key={link.href} to={link.href} className={cn('portal-qa', `tone-${meta.tone}`)}>
                        <span className="tone-chip h-9 w-9">
                          <Icon className="h-4 w-4" />
                        </span>
                        <span className="min-w-0 flex-1">
                          <span className="block truncate text-sm font-semibold text-slate-800">{link.label}</span>
                          <span className="block truncate text-xs text-slate-500" title={link.description}>
                            {link.description}
                          </span>
                        </span>
                        <ChevronRight className="portal-qa-arrow h-4 w-4 shrink-0 text-slate-400" />
                      </Link>
                    )
                  })}
                </div>
              </aside>
            ) : null}
          </div>

          <p className="flex flex-wrap items-center justify-center gap-x-2 gap-y-1 pb-2 text-center text-xs text-slate-500">
            <ShieldCheck className="h-4 w-4 text-[var(--portal-navy)]" />
            <span>Secure employee self-service connected to Business Central</span>
            <span aria-hidden>·</span>
            <span>
              Powered by <span className="font-semibold text-slate-600">{brand.vendor}</span>
            </span>
          </p>
        </div>
      ) : null}
    </PageWrapper>
  )
}
