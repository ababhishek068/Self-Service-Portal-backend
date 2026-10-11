import { useCallback, useEffect, useRef, useState } from 'react'

/** Events that count as user activity. */
const ACTIVITY_EVENTS: (keyof DocumentEventMap)[] = [
  'mousemove',
  'mousedown',
  'keydown',
  'touchstart',
  'scroll',
  'click',
]

export interface UseIdleLogoutOptions {
  /** Total idle time (ms) before auto-logout fires. Default: 10 minutes. */
  idleMs?: number
  /** How many ms before logout to show the warning dialog. Default: 2 minutes. */
  warningMs?: number
  /** Called when idle timeout expires and the user should be logged out. */
  onLogout: () => void
}

export interface UseIdleLogoutReturn {
  /** True when the warning dialog should be shown. */
  showWarning: boolean
  /** Seconds remaining until auto-logout (only meaningful when showWarning=true). */
  secondsLeft: number
  /** Call this to dismiss the warning and reset the idle timer. */
  stayLoggedIn: () => void
}

const DEFAULT_IDLE_MS = 10 * 60 * 1000   // 10 minutes
const DEFAULT_WARNING_MS = 2 * 60 * 1000  // 2 minutes warning before logout

export function useIdleLogout({
  idleMs = DEFAULT_IDLE_MS,
  warningMs = DEFAULT_WARNING_MS,
  onLogout,
}: UseIdleLogoutOptions): UseIdleLogoutReturn {
  const [showWarning, setShowWarning] = useState(false)
  const [secondsLeft, setSecondsLeft] = useState(0)

  const logoutTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const warningTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const countdownRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const onLogoutRef = useRef(onLogout)
  onLogoutRef.current = onLogout

  const clearAllTimers = useCallback(() => {
    if (logoutTimerRef.current) clearTimeout(logoutTimerRef.current)
    if (warningTimerRef.current) clearTimeout(warningTimerRef.current)
    if (countdownRef.current) clearInterval(countdownRef.current)
    logoutTimerRef.current = null
    warningTimerRef.current = null
    countdownRef.current = null
  }, [])

  const startCountdown = useCallback(() => {
    let secs = Math.ceil(warningMs / 1000)
    setSecondsLeft(secs)
    if (countdownRef.current) clearInterval(countdownRef.current)
    countdownRef.current = setInterval(() => {
      secs -= 1
      setSecondsLeft(secs)
      if (secs <= 0) {
        if (countdownRef.current) clearInterval(countdownRef.current)
      }
    }, 1000)
  }, [warningMs])

  const resetTimers = useCallback(() => {
    clearAllTimers()
    setShowWarning(false)
    setSecondsLeft(0)

    // Schedule the warning dialog
    warningTimerRef.current = setTimeout(() => {
      setShowWarning(true)
      startCountdown()

      // Schedule the actual logout after the warning period
      logoutTimerRef.current = setTimeout(() => {
        setShowWarning(false)
        onLogoutRef.current()
      }, warningMs)
    }, idleMs - warningMs)
  }, [clearAllTimers, idleMs, warningMs, startCountdown])

  const stayLoggedIn = useCallback(() => {
    resetTimers()
  }, [resetTimers])

  useEffect(() => {
    // Start the timers on mount
    resetTimers()

    const handleActivity = () => {
      // Only reset if the warning is not showing — once warning is visible
      // the user must explicitly click "Stay logged in".
      if (!showWarning) {
        resetTimers()
      }
    }

    ACTIVITY_EVENTS.forEach((event) => {
      document.addEventListener(event, handleActivity, { passive: true })
    })

    return () => {
      clearAllTimers()
      ACTIVITY_EVENTS.forEach((event) => {
        document.removeEventListener(event, handleActivity)
      })
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [showWarning])

  return { showWarning, secondsLeft, stayLoggedIn }
}
