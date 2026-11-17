import * as React from 'react'
import { Check, ChevronDown, Search, X } from 'lucide-react'
import { cn } from '@/lib/utils'
import type { SelectOption } from '@/components/ui/select'

export interface MultiSelectProps {
  id?: string
  options: SelectOption[]
  /** The chosen values, in the order they were chosen. */
  value: string[]
  onChange: (value: string[]) => void
  placeholder?: string
  disabled?: boolean
  invalid?: boolean
  className?: string
  'aria-describedby'?: string
}

/**
 * Searchable multi-select, the many-values sibling of `Select`: the chosen options sit in the field as chips (each
 * removable), typing filters the list, and each row toggles with a tick. The menu stays open while choosing and
 * opens in document flow (it pushes later fields down, like `Select`).
 */
export function MultiSelect({
  id,
  options,
  value,
  onChange,
  placeholder,
  disabled,
  invalid,
  className,
  'aria-describedby': describedBy,
}: MultiSelectProps) {
  const inputRef = React.useRef<HTMLInputElement | null>(null)
  const listId = React.useId()
  const [open, setOpen] = React.useState(false)
  const [query, setQuery] = React.useState('')
  const [highlight, setHighlight] = React.useState(0)

  const chosen = new Set(value)
  const labelOf = (code: string) => options.find((option) => option.value === code)?.label ?? code
  const normalizedQuery = query.trim().toLowerCase()
  const filtered = normalizedQuery
    ? options.filter((option) => `${option.label} ${option.value}`.toLowerCase().includes(normalizedQuery))
    : options

  const toggle = (code: string) => {
    if (options.some((option) => option.value === code && option.disabled)) return
    onChange(chosen.has(code) ? value.filter((item) => item !== code) : [...value, code])
    setQuery('')
  }

  const close = () => {
    setOpen(false)
    setQuery('')
    setHighlight(0)
  }

  return (
    <div
      className={cn('relative w-full min-w-0', className)}
      onBlur={(event) => {
        if (!event.currentTarget.contains(event.relatedTarget as Node)) close()
      }}
    >
      <div
        className={cn(
          'portal-input flex min-h-10 w-full flex-wrap items-center gap-1.5 rounded-md border bg-white py-1.5 pl-2 pr-8 text-sm text-slate-950 shadow-sm',
          'focus-within:border-[var(--portal-navy,#03949b)] focus-within:ring-2 focus-within:ring-[var(--portal-navy,#03949b)]/20',
          invalid ? 'border-rose-400' : 'border-slate-200',
          disabled ? 'cursor-not-allowed bg-slate-50 text-slate-500' : 'cursor-text',
        )}
        onMouseDown={(event) => {
          if (disabled || event.target === inputRef.current) return
          // Clicking the field (not a chip's remove button) focuses the search.
          if (!(event.target as HTMLElement).closest('button')) {
            event.preventDefault()
            inputRef.current?.focus()
          }
        }}
      >
        {value.map((code) => (
          <span
            key={code}
            className="inline-flex max-w-full items-center gap-0.5 rounded-full bg-teal-50 py-0.5 pl-2.5 pr-1 text-xs font-medium text-teal-900 ring-1 ring-teal-200"
          >
            <span className="truncate">{labelOf(code)}</span>
            <button
              type="button"
              disabled={disabled}
              aria-label={`Remove ${labelOf(code)}`}
              className="rounded-full p-0.5 text-teal-700 hover:bg-teal-100 hover:text-teal-950 disabled:cursor-not-allowed"
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => toggle(code)}
            >
              <X className="h-3 w-3" />
            </button>
          </span>
        ))}
        <input
          ref={inputRef}
          id={id}
          type="text"
          role="combobox"
          aria-expanded={open}
          aria-controls={listId}
          aria-autocomplete="list"
          aria-describedby={describedBy}
          aria-invalid={invalid || undefined}
          autoComplete="off"
          disabled={disabled}
          className="h-7 min-w-[6rem] flex-1 bg-transparent px-1 text-sm outline-none placeholder:text-slate-400 disabled:cursor-not-allowed"
          placeholder={value.length ? 'Add another…' : placeholder || 'Select'}
          value={query}
          onFocus={() => {
            setOpen(true)
            setHighlight(0)
          }}
          onChange={(event) => {
            setQuery(event.target.value)
            setOpen(true)
            setHighlight(0)
          }}
          onKeyDown={(event) => {
            if (event.key === 'Escape') {
              event.preventDefault()
              close()
            } else if (event.key === 'ArrowDown') {
              event.preventDefault()
              setOpen(true)
              setHighlight((index) => Math.min(index + 1, Math.max(filtered.length - 1, 0)))
            } else if (event.key === 'ArrowUp') {
              event.preventDefault()
              setHighlight((index) => Math.max(index - 1, 0))
            } else if (event.key === 'Enter') {
              const option = filtered[highlight]
              if (open && option && !option.disabled) {
                event.preventDefault()
                toggle(option.value)
              }
            } else if (event.key === 'Backspace' && !query && value.length) {
              onChange(value.slice(0, -1))
            } else if (event.key === 'Tab') {
              close()
            }
          }}
        />
      </div>
      <ChevronDown className="pointer-events-none absolute right-2.5 top-5 h-4 w-4 -translate-y-1/2 text-slate-400" />

      {open && !disabled ? (
        <div className="relative left-0 right-0 z-50 mt-1 overflow-hidden rounded-md border border-slate-200 bg-white shadow-lg">
          <div className="flex items-center justify-between gap-2 border-b border-slate-100 px-3 py-1.5 text-xs text-slate-400">
            <span className="flex min-w-0 items-center gap-1.5">
              <Search className="h-3 w-3 shrink-0" />
              <span className="truncate">
                {normalizedQuery ? `${filtered.length} of ${options.length}` : `Choose one or more of ${options.length}`}
              </span>
            </span>
            {value.length ? (
              <span className="shrink-0 font-medium text-teal-800">{value.length} selected</span>
            ) : null}
          </div>
          <div id={listId} role="listbox" aria-multiselectable="true" className="max-h-72 overflow-y-auto py-1">
            {filtered.map((option, index) => {
              const selected = chosen.has(option.value)
              return (
                <button
                  key={option.value}
                  type="button"
                  role="option"
                  aria-selected={selected}
                  disabled={option.disabled}
                  className={cn(
                    // `!`: the global `button { font: inherit }` rule beats utilities (see Select).
                    'flex w-full items-center gap-2.5 px-3 py-1.5 text-left text-sm! leading-5! sm:py-1',
                    option.disabled ? 'cursor-not-allowed text-slate-400' : 'text-slate-900 hover:bg-slate-100',
                    !option.disabled && index === highlight ? 'bg-slate-100' : '',
                    selected ? 'font-semibold text-[var(--portal-navy,#03949b)]' : '',
                  )}
                  onMouseDown={(event) => {
                    event.preventDefault()
                    if (!option.disabled) toggle(option.value)
                  }}
                  onMouseEnter={() => setHighlight(index)}
                >
                  <span
                    aria-hidden="true"
                    className={cn(
                      'flex h-4 w-4 shrink-0 items-center justify-center rounded border transition-colors',
                      selected ? 'border-teal-600 bg-teal-600 text-white' : 'border-slate-300 bg-white',
                    )}
                  >
                    {selected ? <Check className="h-3 w-3" strokeWidth={3} /> : null}
                  </span>
                  <span className="truncate">{option.label}</span>
                </button>
              )
            })}
            {filtered.length === 0 ? <div className="px-3 py-1.5 text-sm text-slate-400">No matches</div> : null}
          </div>
        </div>
      ) : null}
    </div>
  )
}
