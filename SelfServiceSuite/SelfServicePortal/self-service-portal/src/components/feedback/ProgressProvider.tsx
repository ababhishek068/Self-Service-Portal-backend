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

function ModernLoader() {
  return (
    <span
      className="portal-loader-ring shrink-0 motion-reduce:animate-none"
      aria-hidden
    />
  )
}

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
      setValue((current) => (current < 10 ? 10 : current))
      if (!trickle.current) {
        trickle.current = setInterval(() => {
          setValue((current) => {
            if (current >= 94) return current
            const remaining = 94 - current
            return current + Math.max(0.45, remaining * 0.055)
          })
        }, 220)
      }
    } else {
      stopTrickle()
      setValue((current) => (current > 0 ? 100 : 0))
      hideTimer.current = setTimeout(() => {
        setVisible(false)
        setValue(0)
      }, 420)
    }

    return stopTrickle
  }, [active])

  if (!visible && value === 0) return null

  return (
    <div
      className="pointer-events-none fixed inset-x-0 top-0 z-[130]"
      style={{ opacity: visible ? 1 : 0, transition: 'opacity 0.4s ease' }}
      aria-hidden
    >
      <div className="portal-progress-track">
        <div
          className="portal-progress-fill motion-reduce:!transition-none"
          style={{
            width: `${value}%`,
            transition: value >= 100 ? 'width 0.32s cubic-bezier(0.22, 1, 0.36, 1)' : 'width 0.28s cubic-bezier(0.22, 1, 0.36, 1)',
          }}
        />
      </div>
    </div>
  )
}

/** Non-blocking status pill — glass card with gradient border; clicks pass through. */
function BackgroundProgressPill({ title, message }: ProgressOptions) {
  return createPortal(
    <div
      className="pointer-events-none fixed inset-x-3 bottom-20 z-[90] flex justify-center sm:inset-x-auto sm:bottom-6 sm:right-5 lg:bottom-8 portal-safe-pb"
      aria-live="polite"
    >
      <div
        role="status"
        className="portal-progress-pill relative flex w-full max-w-[min(92vw,22rem)] items-center gap-3.5 overflow-hidden rounded-2xl px-4 py-3.5 backdrop-blur-xl sm:w-auto"
      >
        <ModernLoader />
        <div className="min-w-0 flex-1 text-left">
          <p className="truncate text-sm font-semibold tracking-tight text-[var(--portal-navy)]">
            {title ?? 'Working…'}
          </p>
          <p className="mt-0.5 truncate text-xs leading-relaxed text-slate-500">
            {message ?? 'You can keep using the portal'}
          </p>
          <div className="portal-progress-bar-mini mt-2.5 w-full max-w-[12rem]" aria-hidden />
        </div>
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
      ? { title: 'Saving…', message: 'Your changes are being synced' }
      : { title: 'Loading…', message: 'Fetching the latest data' }

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
