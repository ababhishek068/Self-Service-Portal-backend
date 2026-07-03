import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
  type ReactNode,
} from 'react'
import { createPortal } from 'react-dom'
import { Loader2 } from 'lucide-react'
import { useApiActivity } from '@/hooks/useApiActivity'

export interface ProgressOptions {
  title?: string
  message?: string
}

interface ProgressTask extends ProgressOptions {
  id: number
}

interface ProgressContextValue {
  /** Show a background progress indicator. Returns an id used to update/hide it. */
  show: (options?: ProgressOptions) => number
  /** Update the title/message of an active progress task. */
  update: (id: number, options: ProgressOptions) => void
  /** Hide a specific progress task. */
  hide: (id: number) => void
  /** Wrap a promise (or async fn) with the background indicator until it settles. */
  run: <T>(task: Promise<T> | (() => Promise<T>), options?: ProgressOptions) => Promise<T>
}

const ProgressContext = createContext<ProgressContextValue | null>(null)

// Delays keep the pill from flashing on fast calls.
const WRITE_DELAY_MS = 180
const SLOW_READ_DELAY_MS = 800

function TopProgressBar() {
  const { active } = useApiActivity()
  const [value, setValue] = useState(0)
  const [visible, setVisible] = useState(false)
  const trickle = useRef<ReturnType<typeof setInterval> | null>(null)
  const hideTimer = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => {
    const stopTrickle = () => {
      if (trickle.current) {
        clearInterval(trickle.current)
        trickle.current = null
      }
    }

    if (active > 0) {
      if (hideTimer.current) {
        clearTimeout(hideTimer.current)
        hideTimer.current = null
      }
      setVisible(true)
      setValue((current) => (current < 8 ? 8 : current))
      if (!trickle.current) {
        trickle.current = setInterval(() => {
          setValue((current) => {
            if (current >= 92) return current
            const remaining = 92 - current
            return current + Math.max(0.5, remaining * 0.06)
          })
        }, 240)
      }
    } else {
      stopTrickle()
      setValue((current) => (current > 0 ? 100 : 0))
      hideTimer.current = setTimeout(() => {
        setVisible(false)
        setValue(0)
      }, 380)
    }

    return stopTrickle
  }, [active])

  if (!visible && value === 0) return null

  return (
    <div
      className="pointer-events-none fixed inset-x-0 top-0 z-[130] h-[3px]"
      style={{ opacity: visible ? 1 : 0, transition: 'opacity 0.35s ease' }}
      aria-hidden
    >
      <div
        className="relative h-full origin-left"
        style={{
          width: `${value}%`,
          transition: 'width 0.24s cubic-bezier(0.22, 1, 0.36, 1)',
          background:
            'linear-gradient(90deg, var(--portal-navy) 0%, #0a5cad 45%, var(--portal-orange) 100%)',
          boxShadow: '0 0 10px var(--portal-glow-orange), 0 0 4px rgba(0, 51, 102, 0.4)',
        }}
      >
        <span
          className="absolute right-0 top-0 h-full w-24"
          style={{
            background: 'linear-gradient(90deg, transparent, rgba(255,255,255,0.85))',
            filter: 'blur(1px)',
          }}
        />
        <span
          className="absolute right-0 top-1/2 h-3 w-3 -translate-y-1/2 translate-x-1/2 rounded-full"
          style={{
            background: 'var(--portal-orange)',
            boxShadow: '0 0 12px 2px var(--portal-glow-orange)',
          }}
        />
      </div>
    </div>
  )
}

/** Non-blocking status pill — sits in the corner; clicks pass through to the app. */
function BackgroundProgressPill({ title, message }: ProgressOptions) {
  return createPortal(
    <div
      className="pointer-events-none fixed inset-x-3 bottom-20 z-[90] flex justify-end sm:inset-x-auto sm:bottom-6 sm:right-4 lg:bottom-8 portal-safe-pb"
      aria-live="polite"
    >
      <div
        role="status"
        className="animate-toast-in flex max-w-[min(92vw,20rem)] items-center gap-3 rounded-2xl border border-slate-200/80 bg-white/95 px-4 py-3 shadow-xl ring-1 ring-[var(--portal-navy)]/8 backdrop-blur-md"
      >
        <span className="relative flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-[var(--portal-navy)]/10 to-[var(--portal-orange)]/15">
          <Loader2 className="h-5 w-5 animate-spin text-[var(--portal-navy)] motion-reduce:animate-none" />
          <span
            className="absolute inset-0 rounded-full ring-2 ring-[var(--portal-orange)]/25"
            style={{ animation: 'portal-glow-pulse 1.8s ease-in-out infinite' }}
          />
        </span>
        <div className="min-w-0 text-left">
          <p className="truncate text-sm font-semibold text-[var(--portal-navy)]">{title ?? 'Working…'}</p>
          <p className="truncate text-xs text-slate-500">{message ?? 'You can keep using the portal'}</p>
        </div>
        <span
          className="hidden h-8 w-1 shrink-0 rounded-full sm:block"
          style={{
            background: 'linear-gradient(180deg, var(--portal-navy), var(--portal-orange))',
          }}
        />
      </div>
    </div>,
    document.body,
  )
}

/**
 * Owns the activity subscription so only this leaf re-renders on every request.
 * Shows a background pill for writes / slow reads and any manual task.
 */
function BackgroundProgressController({ manual }: { manual?: ProgressTask }) {
  const { active, writes } = useApiActivity()
  const [autoWrite, setAutoWrite] = useState(false)
  const [autoSlow, setAutoSlow] = useState(false)

  useEffect(() => {
    if (writes > 0) {
      const timer = setTimeout(() => setAutoWrite(true), WRITE_DELAY_MS)
      return () => clearTimeout(timer)
    }
    setAutoWrite(false)
    return undefined
  }, [writes])

  useEffect(() => {
    if (active > 0) {
      const timer = setTimeout(() => setAutoSlow(true), SLOW_READ_DELAY_MS)
      return () => clearTimeout(timer)
    }
    setAutoSlow(false)
    return undefined
  }, [active])

  const open = Boolean(manual) || autoWrite || autoSlow
  if (!open) return null

  const props: ProgressOptions = manual
    ? manual
    : autoWrite
      ? { title: 'Working…', message: 'Saving your changes — keep browsing' }
      : { title: 'Loading…', message: 'Fetching data — keep browsing' }

  return <BackgroundProgressPill {...props} />
}

export function ProgressProvider({ children }: { children: ReactNode }) {
  const [tasks, setTasks] = useState<ProgressTask[]>([])
  const idRef = useRef(0)

  const show = useCallback((options?: ProgressOptions) => {
    const id = (idRef.current += 1)
    setTasks((current) => [...current, { id, ...options }])
    return id
  }, [])

  const update = useCallback((id: number, options: ProgressOptions) => {
    setTasks((current) => current.map((task) => (task.id === id ? { ...task, ...options } : task)))
  }, [])

  const hide = useCallback((id: number) => {
    setTasks((current) => current.filter((task) => task.id !== id))
  }, [])

  const run = useCallback(
    async <T,>(task: Promise<T> | (() => Promise<T>), options?: ProgressOptions): Promise<T> => {
      const id = show(options)
      try {
        return await (typeof task === 'function' ? task() : task)
      } finally {
        hide(id)
      }
    },
    [show, hide],
  )

  // Bridge for non-React callers: window.dispatchEvent(new CustomEvent('portal:progress', { detail: { action: 'show'|'hide', title, message } }))
  useEffect(() => {
    let externalId: number | null = null
    const handler = (event: Event) => {
      const detail = (event as CustomEvent<{ action?: string } & ProgressOptions>).detail
      if (!detail) return
      if (detail.action === 'hide') {
        if (externalId !== null) {
          hide(externalId)
          externalId = null
        }
        return
      }
      if (externalId === null) externalId = show(detail)
      else update(externalId, detail)
    }
    window.addEventListener('portal:progress', handler as EventListener)
    return () => window.removeEventListener('portal:progress', handler as EventListener)
  }, [show, hide, update])

  const value = useMemo<ProgressContextValue>(
    () => ({ show, update, hide, run }),
    [show, update, hide, run],
  )

  const manual = tasks[tasks.length - 1]

  return (
    <ProgressContext.Provider value={value}>
      {children}
      <TopProgressBar />
      <BackgroundProgressController manual={manual} />
    </ProgressContext.Provider>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export function useProgress() {
  const context = useContext(ProgressContext)
  if (!context) throw new Error('useProgress must be used within a ProgressProvider')
  return context
}
