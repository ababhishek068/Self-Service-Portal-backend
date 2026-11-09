import { useEffect, useState, type FormEvent } from 'react'
import { Building2, Cloud, Download, ExternalLink, Eye, EyeOff, Loader2, TrendingUp, Users } from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { signInModeOptions, type SignInMode } from '@/config/signInModes'
import { useAuth } from '@/hooks/useAuth'
import { brand, brandCopyright } from '@/config/brand'
import { BrandLogo } from '@/components/brand/BrandLogo'
import { ThemeToggle } from '@/components/layout/ThemeToggle'
import { cn } from '@/lib/utils'

const modeIcons: Record<SignInMode, LucideIcon> = {
  application: Building2,
  ad: Users,
  bc365: Cloud,
}

/** Decorative sample metrics for the brand panel (not live data). */
const sampleKpis = [
  { label: 'Pending', value: '12', hint: 'Approvals' },
  { label: 'Open', value: '28', hint: 'Requests' },
  { label: 'Avg.', value: '1.4d', hint: 'Turnaround' },
] as const

const sampleBars = [
  { label: 'Mon', value: 42 },
  { label: 'Tue', value: 58 },
  { label: 'Wed', value: 36 },
  { label: 'Thu', value: 74 },
  { label: 'Fri', value: 51 },
  { label: 'Sat', value: 22 },
  { label: 'Sun', value: 18 },
] as const

const sampleMix = [
  { label: 'Leave', value: 38, color: '#5ee7ef' },
  { label: 'Claims', value: 27, color: '#d2d741' },
  { label: 'Store', value: 21, color: '#8fb4ff' },
  { label: 'Finance', value: 14, color: '#ffb86b' },
] as const

const linePoints = [
  [8, 78],
  [52, 62],
  [96, 70],
  [140, 40],
  [184, 48],
  [228, 24],
  [272, 32],
  [312, 16],
] as const

function signInButtonLabel(mode: SignInMode) {
  if (mode === 'ad') return 'Continue with AD'
  if (mode === 'bc365') return 'Continue with BC365'
  return 'Sign in'
}

function modeTitle(mode: SignInMode) {
  if (mode === 'ad') return 'AD User'
  if (mode === 'bc365') return 'BC365 User'
  return 'Application User'
}

function BrandDataSample() {
  const line = linePoints.map(([x, y]) => `${x},${y}`).join(' ')
  const area = `M ${linePoints.map(([x, y]) => `${x},${y}`).join(' L ')} L 312,110 L 8,110 Z`
  const maxBar = Math.max(...sampleBars.map((bar) => bar.value))

  return (
    <div className="portal-auth-data-panel">
      <div className="flex items-start justify-between gap-3">
        <div>
          <p className="text-[11px] font-semibold uppercase tracking-[0.16em] text-white/55">Sample analytics</p>
          <p className="mt-1 text-sm font-semibold text-white">ESSP activity at a glance</p>
        </div>
        <span className="inline-flex items-center gap-1 rounded-full bg-[#d2d741]/15 px-2.5 py-1 text-[11px] font-semibold text-[#eef3b0] ring-1 ring-inset ring-[#d2d741]/30">
          <TrendingUp className="h-3 w-3" />
          Demo
        </span>
      </div>

      <div className="mt-4 grid grid-cols-3 gap-2">
        {sampleKpis.map((kpi) => (
          <div key={kpi.label} className="portal-hero-stat px-2.5 py-2.5">
            <p className="text-[10px] font-medium uppercase tracking-wide text-white/55">{kpi.label}</p>
            <p className="mt-1 text-xl font-bold tabular-nums tracking-tight text-white">{kpi.value}</p>
            <p className="mt-0.5 text-[10px] text-white/60">{kpi.hint}</p>
          </div>
        ))}
      </div>

      <div className="portal-auth-chart mt-4">
        <div className="mb-2 flex items-end justify-between gap-2">
          <p className="text-xs font-semibold text-white">Weekly requests</p>
          <p className="text-[10px] text-white/50">Trend · 7 days</p>
        </div>
        <svg viewBox="0 0 320 110" className="h-[7.25rem] w-full" role="img" aria-label="Sample weekly requests chart">
          <defs>
            <linearGradient id="loginChartFill" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="#5ee7ef" stopOpacity="0.5" />
              <stop offset="100%" stopColor="#5ee7ef" stopOpacity="0" />
            </linearGradient>
          </defs>
          {[28, 55, 82].map((y) => (
            <line key={y} x1="0" x2="320" y1={y} y2={y} stroke="rgba(255,255,255,0.1)" strokeWidth="1" />
          ))}
          <path d={area} fill="url(#loginChartFill)" />
          <polyline
            fill="none"
            stroke="#9df2fc"
            strokeWidth="2.75"
            strokeLinecap="round"
            strokeLinejoin="round"
            points={line}
          />
          {linePoints.map(([x, y], index) => (
            <circle
              key={`${x}-${y}`}
              cx={x}
              cy={y}
              r={index === linePoints.length - 1 ? 4 : 2.4}
              fill={index === linePoints.length - 1 ? '#d2d741' : '#fff'}
            />
          ))}
        </svg>
      </div>

      <div className="mt-4 grid grid-cols-7 items-end gap-1.5">
        {sampleBars.map((bar) => (
          <div key={bar.label} className="flex flex-col items-center gap-1.5">
            <div className="flex h-16 w-full items-end rounded-md bg-white/5 px-0.5 pb-0.5">
              <div
                className="w-full rounded-sm bg-gradient-to-t from-[#3fc9d0] to-[#9df2fc]"
                style={{ height: `${Math.max(12, (bar.value / maxBar) * 100)}%` }}
              />
            </div>
            <span className="text-[10px] font-medium text-white/55">{bar.label}</span>
          </div>
        ))}
      </div>

      <div className="mt-4 space-y-2 border-t border-white/10 pt-3">
        <p className="text-xs font-semibold text-white/85">Module mix</p>
        {sampleMix.map((row) => (
          <div key={row.label} className="grid grid-cols-[3.75rem_1fr_2.25rem] items-center gap-2">
            <span className="text-[11px] text-white/65">{row.label}</span>
            <div className="h-1.5 overflow-hidden rounded-full bg-white/10">
              <div className="h-full rounded-full" style={{ width: `${row.value}%`, background: row.color }} />
            </div>
            <span className="text-right text-[11px] tabular-nums text-white/75">{row.value}%</span>
          </div>
        ))}
      </div>
    </div>
  )
}

export function Login() {
  const navigate = useNavigate()
  const location = useLocation()
  const { isAuthenticated, bootstrapped, login, submitting, error } = useAuth()
  const [staffNo, setStaffNo] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [localError, setLocalError] = useState<string | null>(null)
  const [selectedMode, setSelectedMode] = useState<SignInMode>('bc365')

  useEffect(() => {
    if (bootstrapped && isAuthenticated) {
      navigate('/', { replace: true })
    }
  }, [bootstrapped, isAuthenticated, navigate])

  const runSignIn = async (mode: SignInMode) => {
    setSelectedMode(mode)
    setLocalError(null)

    if (mode === 'ad') {
      setLocalError('Active Directory sign-in is not configured yet. Choose BC365 User.')
      return
    }

    try {
      await login(staffNo.trim(), password, mode === 'bc365' ? 'bc365' : 'application')
    } catch {
      /* auth context displays the error */
    }
  }

  const handleFormSubmit = (event: FormEvent) => {
    event.preventDefault()
    setLocalError(null)

    if (!staffNo.trim() || !password) {
      setLocalError('Staff number and password are required.')
      return
    }

    void runSignIn(selectedMode)
  }

  const displayError = localError ?? error
  const passwordResetMessage =
    (location.state as { passwordResetMessage?: string } | null)?.passwordResetMessage

  if (!bootstrapped || isAuthenticated) {
    return (
      <main className="portal-login-bg portal-safe-pt portal-safe-pb flex min-h-dvh items-center justify-center px-4">
        <div className="flex items-center gap-2 text-sm text-slate-600">
          <Loader2 className="h-4 w-4 animate-spin" aria-hidden />
          {bootstrapped ? 'Redirecting…' : 'Restoring your session…'}
        </div>
      </main>
    )
  }

  return (
    <main className="portal-auth-page relative flex h-dvh min-h-0 overflow-hidden">
      <ThemeToggle className="absolute right-3 top-3 z-30 bg-[var(--portal-surface)] shadow-sm ring-1 ring-[var(--portal-card-border)] backdrop-blur sm:right-5 sm:top-5" />

      {/* Exact same palette / aurora / grid as the dashboard hero */}
      <aside className="portal-hero portal-auth-brand-pane relative hidden h-full w-[46%] min-w-[22rem] max-w-[36rem] shrink-0 flex-col overflow-hidden px-9 py-8 text-white lg:flex xl:px-12">
        <div className="portal-hero-aurora" aria-hidden>
          <span />
          <span />
          <span />
        </div>
        <div className="portal-hero-grid" aria-hidden />
        <p className="portal-auth-watermark" aria-hidden>
          ESSP
        </p>

        <div className="relative z-10 flex h-full min-h-0 flex-col">
          <div className="portal-auth-rise shrink-0">
            <BrandLogo variant="login" className="!w-[12rem] bg-transparent p-0 shadow-none" />
            <p className="mt-5 text-[11px] font-semibold uppercase tracking-[0.22em] text-white/65">
              {brand.company}
            </p>
            <h1 className="mt-2 text-[2.35rem] font-bold leading-[1.02] tracking-tight xl:text-[2.65rem]">
              Smart <span className="portal-hero-name">ESSP</span>
            </h1>
            <p className="mt-2 max-w-md text-sm font-medium text-white/85">{brand.loginSubtitle}</p>
          </div>

          <div
            className="portal-auth-rise relative z-10 mt-5 min-h-0 flex-1 overflow-y-auto pr-1"
            style={{ animationDelay: '80ms' }}
          >
            <BrandDataSample />
          </div>

          <div className="portal-auth-rise relative z-10 mt-5 shrink-0 space-y-3" style={{ animationDelay: '130ms' }}>
            <p className="text-xs leading-relaxed text-white/65">{brand.tagline}</p>
            <nav className="flex flex-wrap items-center gap-2" aria-label="Related systems">
              <a
                href={brand.links.businessCentral.href}
                target="_blank"
                rel="noopener noreferrer"
                className="portal-auth-linkchip"
              >
                {brand.links.businessCentral.label}
                <ExternalLink className="h-3 w-3 opacity-80" />
              </a>
              <a
                href={brand.links.sspApk.href}
                target="_blank"
                rel="noopener noreferrer"
                className="portal-auth-linkchip"
              >
                {brand.links.sspApk.description}
                <Download className="h-3 w-3 opacity-80" />
              </a>
            </nav>
          </div>
        </div>
      </aside>

      <section className="portal-auth-form relative flex min-h-0 min-w-0 flex-1 flex-col overflow-y-auto">
        <div className="portal-auth-form-deco" aria-hidden />
        <div className="relative z-10 mx-auto flex w-full max-w-[32rem] flex-1 flex-col justify-center px-5 py-6 sm:px-8 lg:px-10 lg:py-8">
          <div className="mb-5 text-center lg:hidden">
            <div className="mx-auto mb-2.5 flex justify-center">
              <BrandLogo variant="auth" />
            </div>
            <h1 className="text-xl font-bold tracking-tight text-[var(--portal-text)]">{brand.productShort}</h1>
            <p className="mt-0.5 text-xs text-[var(--portal-muted)]">{brand.loginSubtitle}</p>
          </div>

          <div className="portal-login-card portal-auth-rise w-full" style={{ animationDelay: '60ms' }}>
            <div className="portal-login-card-accent" aria-hidden />
            <form className="space-y-4 p-5 sm:p-7" onSubmit={handleFormSubmit}>
              <div>
                <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-[var(--portal-navy)]">
                  Welcome back
                </p>
                <h2 className="mt-1 text-xl font-bold tracking-tight text-[var(--portal-text)] sm:text-2xl">
                  Sign in to ESSP
                </h2>
                <p className="mt-1 text-sm text-[var(--portal-muted)]">
                  Enter your staff number and password, then choose how you sign in.
                </p>
              </div>

              {passwordResetMessage ? (
                <div
                  className="rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm text-emerald-800"
                  role="status"
                >
                  {passwordResetMessage}
                </div>
              ) : null}
              {displayError ? (
                <div
                  className="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700"
                  role="alert"
                >
                  {displayError}
                </div>
              ) : null}

              <div className="space-y-4">
                <div className="space-y-1.5">
                  <Label htmlFor="staffNo">Staff No.</Label>
                  <Input
                    id="staffNo"
                    autoComplete="username"
                    inputMode="text"
                    value={staffNo}
                    onChange={(event) => setStaffNo(event.target.value)}
                    disabled={submitting}
                    required
                    className="h-11 rounded-xl"
                  />
                </div>

                <div className="space-y-1.5">
                  <div className="flex items-center justify-between gap-3">
                    <Label htmlFor="password">Password</Label>
                    <Link
                      to="/forgot-password"
                      className="text-xs font-semibold text-[var(--portal-navy)] hover:underline"
                    >
                      Forgot password?
                    </Link>
                  </div>
                  <div className="relative">
                    <Input
                      id="password"
                      type={showPassword ? 'text' : 'password'}
                      autoComplete="current-password"
                      value={password}
                      onChange={(event) => setPassword(event.target.value)}
                      disabled={submitting}
                      required
                      className="h-11 rounded-xl pr-11"
                    />
                    <button
                      type="button"
                      tabIndex={-1}
                      aria-label={showPassword ? 'Hide password' : 'Show password'}
                      onClick={() => setShowPassword((value) => !value)}
                      className="absolute inset-y-0 right-0 flex w-11 items-center justify-center text-[var(--portal-muted)] hover:text-[var(--portal-navy)]"
                    >
                      {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                    </button>
                  </div>
                </div>
              </div>

              <div className="space-y-2.5">
                <p className="text-sm font-semibold text-[var(--portal-text)]">Choose sign-in method</p>
                <div className="space-y-2.5" role="radiogroup" aria-label="Choose sign-in method">
                  {signInModeOptions.map((option) => {
                    const Icon = modeIcons[option.id]
                    const active = selectedMode === option.id
                    return (
                      <button
                        key={option.id}
                        type="button"
                        role="radio"
                        aria-checked={active}
                        disabled={submitting}
                        onClick={() => setSelectedMode(option.id)}
                        className={cn(
                          'portal-login-mode-option flex w-full items-center gap-3.5 rounded-xl border px-3.5 py-3.5 text-left transition disabled:cursor-not-allowed disabled:opacity-60',
                          active
                            ? 'border-[var(--portal-orange)] bg-orange-50/80 shadow-sm'
                            : 'border-slate-200 bg-[var(--portal-surface)] hover:border-slate-300 hover:bg-slate-50',
                        )}
                      >
                        <span
                          className={cn(
                            'flex h-10 w-10 shrink-0 items-center justify-center rounded-xl',
                            active
                              ? 'bg-[var(--portal-orange)]/15 text-[var(--portal-orange)]'
                              : 'bg-[var(--portal-navy)]/10 text-[var(--portal-navy)]',
                          )}
                        >
                          <Icon className="h-[1.125rem] w-[1.125rem]" />
                        </span>
                        <span className="min-w-0 flex-1">
                          <span className="block text-sm font-semibold text-[var(--portal-text)]">
                            {modeTitle(option.id)}
                          </span>
                          <span className="mt-0.5 block text-xs leading-relaxed text-[var(--portal-muted)]">
                            {option.description}
                          </span>
                        </span>
                      </button>
                    )
                  })}
                </div>
              </div>

              <Button
                type="submit"
                variant="gradient"
                className="h-11 w-full rounded-xl text-sm font-semibold tracking-wide"
                disabled={submitting}
              >
                {submitting ? (
                  <>
                    <Loader2 className="h-4 w-4 animate-spin" />
                    Signing in…
                  </>
                ) : (
                  signInButtonLabel(selectedMode)
                )}
              </Button>
            </form>
          </div>

          <footer className="portal-auth-rise mt-5 space-y-2.5 pb-1 text-center" style={{ animationDelay: '120ms' }}>
            <nav
              className="flex flex-wrap items-center justify-center gap-x-3 gap-y-1 text-xs text-[var(--portal-muted)] lg:hidden"
              aria-label="Related systems"
            >
              <a
                href={brand.links.businessCentral.href}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1 font-medium text-[var(--portal-navy)] hover:underline"
              >
                {brand.links.businessCentral.label}
                <ExternalLink className="h-3 w-3 opacity-60" />
              </a>
              <span className="opacity-40" aria-hidden>
                ·
              </span>
              <a
                href={brand.links.sspApk.href}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1 font-medium text-[var(--portal-navy)] hover:underline"
              >
                {brand.links.sspApk.description}
                <Download className="h-3 w-3 opacity-60" />
              </a>
            </nav>
            <p className="text-[11px] text-[var(--portal-muted)]">{brandCopyright()}</p>
          </footer>
        </div>
      </section>
    </main>
  )
}
