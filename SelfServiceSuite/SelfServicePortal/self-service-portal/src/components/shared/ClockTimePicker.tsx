import { Clock } from 'lucide-react'
import { useEffect, useRef, useState, type KeyboardEvent, type PointerEvent } from 'react'
import { createPortal } from 'react-dom'
import { cn } from '@/lib/utils'

type Meridiem = 'AM' | 'PM'
type Mode = 'hour' | 'minute'

/** Labels sit on a circle 38.7% of the dial size from its centre (96 px on the 248 px dial). */
const LABEL_RADIUS = 38.7

function pad(value: number) {
  return String(value).padStart(2, '0')
}

function parse24(value: string) {
  const match = /^(\d{1,2}):(\d{2})/.exec(value)
  if (!match) return null
  const hour = Number(match[1])
  const minute = Number(match[2])
  if (hour > 23 || minute > 59) return null
  return { hour12: hour % 12 || 12, minute, meridiem: (hour < 12 ? 'AM' : 'PM') as Meridiem }
}

function format24(hour12: number, minute: number, meridiem: Meridiem) {
  return `${pad((hour12 % 12) + (meridiem === 'PM' ? 12 : 0))}:${pad(minute)}`
}

/** "17:30" -> "05:30 PM"; blank when the value is not a time. */
function clockLabel(value: string) {
  const parsed = parse24(value)
  return parsed ? `${pad(parsed.hour12)}:${pad(parsed.minute)} ${parsed.meridiem}` : ''
}

function ClockDialog({
  title,
  value,
  defaultMeridiem,
  onDone,
  onClose,
}: {
  title: string
  value: string
  defaultMeridiem: Meridiem
  onDone: (value: string) => void
  onClose: () => void
}) {
  const initial = parse24(value)
  const [mode, setMode] = useState<Mode>('hour')
  const [hour, setHour] = useState<number | null>(initial?.hour12 ?? null)
  const [minute, setMinute] = useState<number | null>(initial?.minute ?? null)
  const [meridiem, setMeridiem] = useState<Meridiem>(initial?.meridiem ?? defaultMeridiem)
  const dialRef = useRef<HTMLDivElement>(null)
  const panelRef = useRef<HTMLDivElement>(null)
  const dragging = useRef(false)

  useEffect(() => {
    panelRef.current?.focus()
  }, [])

  const pick = (clientX: number, clientY: number, finish: boolean) => {
    const dial = dialRef.current
    if (!dial) return
    const rect = dial.getBoundingClientRect()
    const dx = clientX - (rect.left + rect.width / 2)
    const dy = clientY - (rect.top + rect.height / 2)
    let degrees = (Math.atan2(dx, -dy) * 180) / Math.PI
    if (degrees < 0) degrees += 360
    if (mode === 'hour') {
      setHour(Math.round(degrees / 30) % 12 || 12)
      if (finish) setMode('minute')
    } else {
      setMinute(Math.round(degrees / 6) % 60)
    }
  }

  const onPointerDown = (event: PointerEvent<HTMLDivElement>) => {
    dragging.current = true
    event.currentTarget.setPointerCapture(event.pointerId)
    pick(event.clientX, event.clientY, false)
  }
  const onPointerMove = (event: PointerEvent<HTMLDivElement>) => {
    if (dragging.current) pick(event.clientX, event.clientY, false)
  }
  const onPointerUp = (event: PointerEvent<HTMLDivElement>) => {
    if (!dragging.current) return
    dragging.current = false
    pick(event.clientX, event.clientY, true)
  }

  const onKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    if (event.key === 'Escape') {
      event.stopPropagation()
      onClose()
    }
  }

  const numbers = Array.from({ length: 12 }, (_, index) => (mode === 'hour' ? index || 12 : index * 5))
  const selected = mode === 'hour' ? hour : minute
  const angle = selected === null ? null : mode === 'hour' ? (selected % 12) * 30 : selected * 6
  const done = () => {
    if (hour === null) return
    onDone(format24(hour, minute ?? 0, meridiem))
  }

  return (
    <div
      className="fixed inset-0 z-[100] flex items-center justify-center bg-slate-900/40 p-4"
      onMouseDown={(event) => {
        if (event.target === event.currentTarget) onClose()
      }}
    >
      <div
        ref={panelRef}
        role="dialog"
        aria-modal="true"
        aria-label={title}
        tabIndex={-1}
        onKeyDown={onKeyDown}
        className="w-full max-w-[19rem] overflow-hidden rounded-2xl bg-white shadow-2xl outline-none"
      >
        <div className="bg-[var(--portal-navy)] px-5 pb-4 pt-3 text-white">
          <p className="text-xs font-medium uppercase tracking-wide text-white/75">{title}</p>
          <div className="mt-2 flex items-center justify-between">
            <div className="flex items-center gap-1 text-4xl font-semibold tabular-nums">
              <button
                type="button"
                onClick={() => setMode('hour')}
                aria-label="Choose the hour"
                className={cn('rounded-md px-1.5 py-0.5', mode === 'hour' ? 'bg-white/20' : 'text-white/70 hover:text-white')}
              >
                {hour === null ? '--' : pad(hour)}
              </button>
              <span className="text-white/70">:</span>
              <button
                type="button"
                onClick={() => setMode('minute')}
                aria-label="Choose the minutes"
                className={cn('rounded-md px-1.5 py-0.5', mode === 'minute' ? 'bg-white/20' : 'text-white/70 hover:text-white')}
              >
                {minute === null ? '--' : pad(minute)}
              </button>
            </div>
            <div className="flex flex-col overflow-hidden rounded-lg text-sm font-semibold ring-1 ring-white/40">
              {(['AM', 'PM'] as const).map((option) => (
                <button
                  key={option}
                  type="button"
                  aria-pressed={meridiem === option}
                  onClick={() => setMeridiem(option)}
                  className={cn('px-3 py-1', meridiem === option ? 'bg-white text-[var(--portal-navy)]' : 'text-white/80 hover:bg-white/10')}
                >
                  {option}
                </button>
              ))}
            </div>
          </div>
        </div>

        <div className="px-5 pb-2 pt-5">
          <div
            ref={dialRef}
            className="relative mx-auto aspect-square w-full max-w-[15.5rem] touch-none select-none rounded-full bg-slate-100"
            onPointerDown={onPointerDown}
            onPointerMove={onPointerMove}
            onPointerUp={onPointerUp}
            onPointerCancel={() => {
              dragging.current = false
            }}
          >
            {angle !== null ? (
              <div
                className="pointer-events-none absolute w-0.5 bg-[var(--portal-navy)]"
                style={{
                  left: 'calc(50% - 1px)',
                  bottom: '50%',
                  height: `${LABEL_RADIUS}%`,
                  transform: `rotate(${angle}deg)`,
                  transformOrigin: 'bottom center',
                }}
              >
                <span
                  className={cn(
                    'absolute left-1/2 top-0 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[var(--portal-navy)]',
                    mode === 'minute' && minute !== null && minute % 5 !== 0 ? 'h-3 w-3' : 'h-9 w-9',
                  )}
                />
              </div>
            ) : null}
            <span className="pointer-events-none absolute left-1/2 top-1/2 h-2 w-2 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[var(--portal-navy)]" />
            {numbers.map((number, index) => {
              const radians = (index * 30 * Math.PI) / 180
              const isSelected = number === selected
              return (
                <button
                  key={`${mode}-${number}`}
                  type="button"
                  // The dial takes the pointer (drag to choose); the buttons are for the keyboard.
                  className={cn(
                    'pointer-events-none absolute flex h-9 w-9 -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full text-sm tabular-nums focus-visible:outline focus-visible:outline-2 focus-visible:outline-[var(--portal-navy)]',
                    isSelected ? 'font-semibold text-white' : 'text-slate-700',
                  )}
                  style={{
                    left: `${50 + LABEL_RADIUS * Math.sin(radians)}%`,
                    top: `${50 - LABEL_RADIUS * Math.cos(radians)}%`,
                  }}
                  aria-label={mode === 'hour' ? `${number} o'clock` : `${pad(number)} minutes`}
                  onClick={() => {
                    if (mode === 'hour') {
                      setHour(number)
                      setMode('minute')
                    } else {
                      setMinute(number)
                    }
                  }}
                >
                  {mode === 'hour' ? number : pad(number)}
                </button>
              )
            })}
          </div>
          <p className="mt-3 text-center text-xs text-slate-500">
            {mode === 'hour' ? 'Tap or drag to the hour' : 'Tap or drag to the minutes'}
          </p>
        </div>

        <div className="flex items-center justify-between gap-2 border-t border-slate-100 px-3 py-2.5">
          <button
            type="button"
            onClick={() => onDone('')}
            className="rounded-md px-3 py-2 text-sm font-medium text-slate-500 hover:bg-slate-100"
          >
            Clear
          </button>
          <div className="flex gap-1">
            <button
              type="button"
              onClick={onClose}
              className="rounded-md px-3 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100"
            >
              Cancel
            </button>
            <button
              type="button"
              onClick={done}
              disabled={hour === null}
              className="rounded-md bg-[var(--portal-navy)] px-4 py-2 text-sm font-semibold text-white disabled:opacity-40"
            >
              OK
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

/**
 * A time chosen on a clock face: the hour, then the minutes, with AM / PM. The value stays in
 * 24-hour time ("17:30"); blank until a time is chosen.
 */
export function ClockTimePicker({
  id,
  value,
  title,
  defaultMeridiem,
  placeholder = 'Select time',
  invalid = false,
  onChange,
}: {
  id: string
  value: string
  /** Shown on top of the clock, e.g. "Select start time". */
  title: string
  defaultMeridiem: Meridiem
  placeholder?: string
  invalid?: boolean
  onChange: (value: string) => void
}) {
  const [open, setOpen] = useState(false)
  const triggerRef = useRef<HTMLButtonElement>(null)
  const shown = clockLabel(value)
  const close = () => {
    setOpen(false)
    triggerRef.current?.focus()
  }
  return (
    <>
      <button
        ref={triggerRef}
        id={id}
        type="button"
        aria-haspopup="dialog"
        aria-invalid={invalid}
        onClick={() => setOpen(true)}
        className={cn(
          'portal-input flex h-10 w-full items-center justify-between rounded-md border bg-white px-3 py-2 text-left text-sm shadow-sm outline-none',
          invalid ? 'border-red-400' : 'border-slate-200',
          shown ? 'text-slate-950' : 'text-slate-400',
        )}
      >
        <span className="tabular-nums">{shown || placeholder}</span>
        <Clock className="h-4 w-4 text-slate-500" aria-hidden />
      </button>
      {open
        ? createPortal(
            <ClockDialog
              title={title}
              value={value}
              defaultMeridiem={defaultMeridiem}
              onClose={close}
              onDone={(next) => {
                onChange(next)
                close()
              }}
            />,
            document.body,
          )
        : null}
    </>
  )
}
