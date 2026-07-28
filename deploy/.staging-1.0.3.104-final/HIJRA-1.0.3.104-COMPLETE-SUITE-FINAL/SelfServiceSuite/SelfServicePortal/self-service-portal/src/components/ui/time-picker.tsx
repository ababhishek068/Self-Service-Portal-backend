import * as React from 'react'
import { Clock3, Zap } from 'lucide-react'
import { cn } from '@/lib/utils'

export interface TimePickerProps {
  id?: string
  value?: string
  onChange: (value: string) => void
  onBlur?: () => void
  disabled?: boolean
  placeholder?: string
  className?: string
  name?: string
}

function clockValue(value: string | undefined) {
  const match = String(value ?? '').trim().match(/^(\d{1,2}):(\d{2})/)
  if (!match) return ''
  return `${match[1]!.padStart(2, '0')}:${match[2]}`
}

function currentTimeValue() {
  const now = new Date()
  return `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
}

export const TimePicker = React.forwardRef<HTMLInputElement, TimePickerProps>(
  (
    {
      id,
      value,
      onChange,
      onBlur,
      disabled,
      placeholder = 'Select time',
      className,
      name,
    },
    forwardedRef,
  ) => {
    const inputRef = React.useRef<HTMLInputElement | null>(null)

    const setRefs = (element: HTMLInputElement | null) => {
      inputRef.current = element
      if (typeof forwardedRef === 'function') forwardedRef(element)
      else if (forwardedRef) forwardedRef.current = element
    }

    const openPicker = () => {
      if (disabled) return
      const input = inputRef.current
      input?.focus()
      try {
        input?.showPicker?.()
      } catch {
        input?.click()
      }
    }

    const normalizedValue = clockValue(value)

    return (
      <div
        className={cn(
          'group flex h-11 w-full items-center overflow-hidden rounded-xl border border-slate-200',
          'bg-gradient-to-r from-white via-white to-blue-50/70 shadow-sm transition-all duration-200',
          'focus-within:border-[var(--portal-navy)] focus-within:ring-4 focus-within:ring-[var(--portal-navy)]/10',
          disabled && 'cursor-not-allowed bg-slate-50 opacity-70',
          className,
        )}
      >
        <button
          type="button"
          aria-label="Open time picker"
          disabled={disabled}
          className="ml-1.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-[var(--portal-navy)]/8 text-[var(--portal-navy)] transition hover:bg-[var(--portal-navy)] hover:text-white disabled:pointer-events-none"
          onClick={openPicker}
        >
          <Clock3 className="h-4 w-4" />
        </button>
        <input
          ref={setRefs}
          id={id}
          name={name}
          type="time"
          step={60}
          value={normalizedValue}
          aria-label={placeholder}
          disabled={disabled}
          className="h-full min-w-0 flex-1 border-0 bg-transparent px-3 text-sm font-medium tabular-nums text-slate-900 outline-none disabled:cursor-not-allowed"
          onChange={(event) => onChange(event.target.value)}
          onBlur={onBlur}
        />
        <div className="h-6 w-px bg-slate-200" />
        <button
          type="button"
          disabled={disabled}
          className="mx-1.5 inline-flex h-8 shrink-0 items-center gap-1 rounded-lg px-2.5 text-xs font-semibold text-[var(--portal-navy)] transition hover:bg-[var(--portal-orange)] hover:text-white disabled:pointer-events-none"
          onClick={() => {
            onChange(currentTimeValue())
            window.setTimeout(() => inputRef.current?.focus(), 0)
          }}
        >
          <Zap className="h-3.5 w-3.5" />
          Now
        </button>
      </div>
    )
  },
)
TimePicker.displayName = 'TimePicker'
