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
  /**
   * When true, the full-screen blocker prevents clicks/navigation until the task
   * finishes. Defaults to true for manual `show()` / `run()` calls.
   */
  blocking?: boolean
}

interface ProgressTask extends ProgressOptions {
  id: number
  blocking: boolean
}

interface ProgressContextValue {
  /** Show a progress indicator. Returns an id used to update/hide it. */
  show: (options?: ProgressOptions) => number
  /** Update the title/message of an active progress task. */
  update: (id: number, options: ProgressOptions) => void
  /** Hide a specific progress task. */
  hide: (id: number) => void
  /** Wrap a promise (or async fn) with a blocking indicator until it settles. */
  run: <T>(task: Promise<T> | (() => Promise<T>), options?: ProgressOptions) => Promise<T>
}

const ProgressContext = createContext<ProgressContextValue | null>(null)

const WRITE_DELAY_MS = 120
const SLOW_READ_DELAY_MS = 600

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

/** Full-screen blocker — nothing else is clickable while this is visible. */
function BlockingOverlay({ title, message }: ProgressOptions) {
  return createPortal(
    <div
      className="portal-blocking-overlay fixed inset-0 z-[200] flex items-center justify-center p-4"
      role="alertdialog"
      aria-modal="true"
      aria-busy="true"
      aria-live="assertive"
      aria-label={title ?? 'Loading'}
    >
      <div className="portal-blocking-backdrop absolute inset-0 bg-[var(--portal-navy)]/25 backdrop-blur-[3px]" />
      <div className="portal-blocking-card animate-toast-in relative w-full max-w-sm overflow-hidden rounded-2xl border border-white/60 bg-white/95 px-6 py-7 text-center shadow-2xl ring-1 ring-[var(--portal-navy)]/10">
        <div
          className="pointer-events-none absolute inset-x-0 top-0 h-1"
          style={{
            background: 'linear-gradient(90deg, var(--portal-navy), var(--portal-orange))',
          }}
        />
        <div className="relative mx-auto mb-5 flex h-16 w-16 items-center justify-center">
          <span
            className="absolute inset-0 rounded-full border-2 border-[var(--portal-navy)]/15"
            style={{ animation: 'portal-blocking-spin 2.4s linear infinite' }}
          />
          <span
            className="absolute inset-1 rounded-full border-2 border-transparent border-t-[var(--portal-orange)] border-r-[var(--portal-navy)]/40"
            style={{ animation: 'portal-blocking-spin 1.1s linear infinite reverse' }}
          />
          <span className="relative flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-[var(--portal-navy)]/8 to-[var(--portal-orange)]/12">
            <Loader2 className="h-6 w-6 animate-spin text-[var(--portal-navy)] motion-reduce:animate-none" />
          </span>
        </div>
        <p className="text-base font-semibold tracking-tight text-[var(--portal-navy)]">
          {title ?? 'Please wait…'}
        </p>
        <p className="mt-1.5 text-sm text-slate-500">{message ?? 'Do not close or refresh this page.'}</p>
        <div className="portal-blocking-shimmer mt-5 h-1 overflow-hidden rounded-full bg-slate-100">
          <div className="portal-blocking-shimmer-bar h-full w-1/3 rounded-full" />
        </div>
      </div>
    </div>,
    document.body,
  )
}

/** Corner pill for slow background reads (non-blocking). */
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
        </span>
        <div className="min-w-0 text-left">
          <p className="truncate text-sm font-semibold text-[var(--portal-navy)]">{title ?? 'Loading…'}</p>
          <p className="truncate text-xs text-slate-500">{message ?? 'Fetching data'}</p>
        </div>
      </div>
    </div>,
    document.body,
  )
}

function BlockingController({
  manual,
  writes,
}: {
  manual?: ProgressTask
  writes: number
}) {
  const [autoWrite, setAutoWrite] = useState(false)

  useEffect(() => {
    if (writes > 0) {
      const timer = setTimeout(() => setAutoWrite(true), WRITE_DELAY_MS)
      return () => clearTimeout(timer)
    }
    setAutoWrite(false)
    return undefined
  }, [writes])

  const blockingManual = manual?.blocking !== false
  const open = (blockingManual && Boolean(manual)) || autoWrite
  if (!open) return null

  const props: ProgressOptions =
    blockingManual && manual
      ? { title: manual.title, message: manual.message }
      : { title: 'Processing…', message: 'Saving your changes — please wait.' }

  return <BlockingOverlay {...props} />
}

function BackgroundProgressController({
  blockingActive,
  active,
  writes,
}: {
  blockingActive: boolean
  active: number
  writes: number
}) {
  const [autoSlow, setAutoSlow] = useState(false)

  useEffect(() => {
    if (active > 0 && writes === 0) {
      const timer = setTimeout(() => setAutoSlow(true), SLOW_READ_DELAY_MS)
      return () => clearTimeout(timer)
    }
    setAutoSlow(false)
    return undefined
  }, [active, writes])

  if (blockingActive) return null
  if (!autoSlow) return null

  return <BackgroundProgressPill title="Loading…" message="Fetching data from Business Central" />
}

export function ProgressProvider({ children }: { children: ReactNode }) {
  const { active, writes } = useApiActivity()
  const [tasks, setTasks] = useState<ProgressTask[]>([])
  const idRef = useRef(0)

  const blockingActive =
    writes > 0 || tasks.some((task) => task.blocking !== false)

  useEffect(() => {
    if (blockingActive) {
      document.body.classList.add('portal-api-blocking')
      document.body.style.overflow = 'hidden'
    } else {
      document.body.classList.remove('portal-api-blocking')
      document.body.style.overflow = ''
    }
    return () => {
      document.body.classList.remove('portal-api-blocking')
      document.body.style.overflow = ''
    }
  }, [blockingActive])

  const show = useCallback((options?: ProgressOptions) => {
    const id = (idRef.current += 1)
    const blocking = options?.blocking !== false
    setTasks((current) => [...current, { id, blocking, ...options }])
    return id
  }, [])

  const update = useCallback((id: number, options: ProgressOptions) => {
    setTasks((current) =>
      current.map((task) =>
        task.id === id
          ? {
              ...task,
              ...options,
              blocking: options.blocking !== undefined ? options.blocking !== false : task.blocking,
            }
          : task,
      ),
    )
  }, [])

  const hide = useCallback((id: number) => {
    setTasks((current) => current.filter((task) => task.id !== id))
  }, [])

  const run = useCallback(
    async <T,>(task: Promise<T> | (() => Promise<T>), options?: ProgressOptions): Promise<T> => {
      const id = show({ blocking: true, ...options })
      try {
        return await (typeof task === 'function' ? task() : task)
      } finally {
        hide(id)
      }
    },
    [show, hide],
  )

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
      <BlockingController manual={manual} writes={writes} />
      <BackgroundProgressController blockingActive={blockingActive} active={active} writes={writes} />
    </ProgressContext.Provider>
  )
}

// eslint-disable-next-line react-refresh/only-export-components
export function useProgress() {
  const context = useContext(ProgressContext)
  if (!context) throw new Error('useProgress must be used within a ProgressProvider')
  return context
}
