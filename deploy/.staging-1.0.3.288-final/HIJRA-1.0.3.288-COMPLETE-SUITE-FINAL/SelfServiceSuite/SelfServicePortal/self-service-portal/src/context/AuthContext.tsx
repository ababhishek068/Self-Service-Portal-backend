import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react'
import { fetchCurrentUser, loginRequest, logoutRequest, registerRequest, type AuthProvider, type RegisterInput } from '@/api/endpoints/auth'
import { AuthContext, type AuthContextValue } from './authContextValue'
import { useIdleLogout } from '@/hooks/useIdleLogout'
import { IdleWarningDialog } from '@/components/shared/IdleWarningDialog'
import type { Employee } from '@/types/erp.types'

// 10 minutes idle → 2-minute warning → auto-logout.
// Matches the ERP session behaviour requested by the bank.
const IDLE_MS = 10 * 60 * 1000
const WARNING_MS = 2 * 60 * 1000

export function AuthProvider({ children }: { children: ReactNode }) {
  const [employee, setEmployee] = useState<Employee | null>(null)
  const [bootstrapped, setBootstrapped] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  /** On first paint, ask the backend whether we already have a valid session/token. */
  useEffect(() => {
    let cancelled = false
    fetchCurrentUser()
      .then((user) => {
        if (!cancelled) setEmployee(user)
      })
      .catch(() => {
        if (!cancelled) setEmployee(null)
      })
      .finally(() => {
        if (!cancelled) setBootstrapped(true)
      })
    return () => {
      cancelled = true
    }
  }, [])

  const login = useCallback(async (staffNo: string, password: string, provider: AuthProvider = 'application') => {
    setSubmitting(true)
    setError(null)
    try {
      const next = await loginRequest(staffNo, password, provider)
      setEmployee(next)
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Login failed'
      setError(message)
      throw err
    } finally {
      setSubmitting(false)
    }
  }, [])

  const register = useCallback(async (input: RegisterInput) => {
    setSubmitting(true)
    setError(null)
    try {
      const next = await registerRequest(input)
      setEmployee(next)
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Registration failed'
      setError(message)
      throw err
    } finally {
      setSubmitting(false)
    }
  }, [])

  const logout = useCallback(async () => {
    try {
      await logoutRequest()
    } finally {
      setEmployee(null)
    }
  }, [])

  // Idle auto-logout — only active while a user is logged in.
  const { showWarning, secondsLeft, stayLoggedIn } = useIdleLogout({
    idleMs: IDLE_MS,
    warningMs: WARNING_MS,
    onLogout: logout,
  })

  const value = useMemo<AuthContextValue>(
    () => ({
      employee,
      isAuthenticated: Boolean(employee),
      bootstrapped,
      submitting,
      error,
      login,
      register,
      logout,
    }),
    [employee, bootstrapped, submitting, error, login, register, logout],
  )

  return (
    <AuthContext.Provider value={value}>
      {children}
      {employee ? (
        <IdleWarningDialog
          open={showWarning}
          secondsLeft={secondsLeft}
          onStayLoggedIn={stayLoggedIn}
        />
      ) : null}
    </AuthContext.Provider>
  )
}
