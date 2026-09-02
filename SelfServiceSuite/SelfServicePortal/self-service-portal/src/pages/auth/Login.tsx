import { useEffect, useState, type FormEvent } from 'react'
import { Building2, Cloud, Loader2, Users } from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { signInModeOptions, type SignInMode } from '@/config/signInModes'
import { useAuth } from '@/hooks/useAuth'
import { brand, brandCopyright } from '@/config/brand'
import { BrandLogo } from '@/components/brand/BrandLogo'
import { cn } from '@/lib/utils'

const modeIcons: Record<SignInMode, LucideIcon> = {
  application: Building2,
  ad: Users,
  bc365: Cloud,
}

function signInButtonLabel(mode: SignInMode) {
  if (mode === 'ad') return 'Sign in with AD User'
  if (mode === 'bc365') return 'Sign in with BC365 User'
  return 'Sign in with Application User'
}

export function Login() {
  const navigate = useNavigate()
  const location = useLocation()
  const { isAuthenticated, bootstrapped, login, submitting, error } = useAuth()
  const [staffNo, setStaffNo] = useState('')
  const [password, setPassword] = useState('')
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
      setLocalError('Active Directory sign-in is not configured yet. Choose Application User or BC365 User.')
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
  const selectedLabel =
    signInModeOptions.find((option) => option.id === selectedMode)?.label ?? signInModeOptions[0].label

  if (!bootstrapped || isAuthenticated) {
    return (
      <main className="portal-login-bg portal-safe-pt portal-safe-pb flex min-h-screen items-center justify-center px-4">
        <div className="flex items-center gap-2 text-sm text-slate-600">
          <Loader2 className="h-4 w-4 animate-spin" aria-hidden />
          {bootstrapped ? 'Redirecting…' : 'Restoring your session…'}
        </div>
      </main>
    )
  }

  return (
    <main className="portal-login-bg portal-safe-pt portal-safe-pb portal-safe-px relative flex min-h-screen flex-col items-center justify-center overflow-x-hidden overflow-y-auto px-4 py-6 sm:p-4">
      <div className="portal-ambient pointer-events-none absolute inset-0" aria-hidden>
        <span className="portal-orb portal-orb-navy opacity-45" />
        <span className="portal-orb portal-orb-green opacity-35" />
      </div>

      <div className="relative z-10 flex w-full max-w-md flex-col items-center">
        <div className="animate-page-in-subtle mb-6 text-center sm:mb-8">
          <div className="portal-logo-float mx-auto mb-3 flex justify-center sm:mb-4">
            <BrandLogo variant="login" />
          </div>
          <h1 className="portal-page-title text-lg font-bold uppercase sm:text-xl">{brand.company}</h1>
          <p className="mt-1.5 text-base font-semibold tracking-wide text-[var(--portal-navy)] sm:mt-2 sm:text-lg">
            <span className="font-bold">{brand.productShort}</span>
            <span className="mx-1.5 text-slate-400" aria-hidden>|</span>
            <span>Employee Self-Service Portal</span>
          </p>
        </div>

        <div className="portal-form-card animate-page-in-subtle w-full" style={{ animationDelay: '80ms' }}>
          <div className="portal-form-card-header relative px-4 py-3 text-center text-sm font-semibold tracking-wide text-white sm:text-base">
            Sign In
          </div>

          <form className="space-y-4 p-4 sm:p-6" onSubmit={handleFormSubmit}>
            {passwordResetMessage ? (
              <div className="rounded border-l-4 border-emerald-500 bg-emerald-50 px-3 py-2 text-sm text-emerald-700" role="status">
                {passwordResetMessage}
              </div>
            ) : null}
            {displayError ? (
              <div className="rounded border-l-4 border-red-500 bg-red-50 px-3 py-2 text-sm text-red-700" role="alert">
                {displayError}
              </div>
            ) : null}

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
              />
            </div>

            <div className="space-y-1.5">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                autoComplete="current-password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                disabled={submitting}
                required
              />
            </div>

            <div className="space-y-2">
              <p className="text-sm font-semibold text-[var(--portal-navy)]">Choose sign-in method</p>
              <div className="space-y-2" role="radiogroup" aria-label="Choose sign-in method">
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
                        'flex w-full items-start gap-3 rounded-xl border px-3 py-3 text-left transition-colors disabled:cursor-not-allowed disabled:opacity-60',
                        active
                          ? 'border-[var(--portal-orange)] bg-orange-50/80 shadow-sm'
                          : 'border-slate-200 bg-white hover:border-slate-300 hover:bg-slate-50',
                      )}
                    >
                      <span
                        className={cn(
                          'mt-0.5 flex h-9 w-9 shrink-0 items-center justify-center rounded-lg',
                          active
                            ? 'bg-[var(--portal-orange)]/15 text-[var(--portal-orange)]'
                            : 'bg-[var(--portal-navy)]/10 text-[var(--portal-navy)]',
                        )}
                      >
                        <Icon className="h-4 w-4" />
                      </span>
                      <span className="min-w-0 flex-1">
                        <p className="text-sm font-semibold text-[var(--portal-navy)]">{option.label}</p>
                        <p className="mt-0.5 text-xs leading-relaxed text-slate-500">{option.description}</p>
                      </span>
                    </button>
                  )
                })}
              </div>
            </div>

            <Button
              type="submit"
              variant="gradient"
              className="h-11 w-full rounded-full text-sm sm:text-base"
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

            <p className="text-center text-[11px] text-slate-500">Selected: {selectedLabel}</p>

            <p className="text-center text-sm text-slate-600">
              <Link to="/forgot-password" className="font-semibold text-[var(--portal-navy)] hover:underline">
                Forgot or change your password?
              </Link>
            </p>
          </form>
        </div>

        <p className="mt-5 text-center text-[11px] text-slate-500 sm:mt-6 sm:text-xs">
          {brandCopyright()}
        </p>
      </div>
    </main>
  )
}
