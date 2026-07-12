import * as React from 'react'
import { ChevronDown, Search } from 'lucide-react'
import { cn } from '@/lib/utils'

export interface SelectOption {
  label: string
  value: string
}

export interface SelectProps extends React.SelectHTMLAttributes<HTMLSelectElement> {
  options: SelectOption[]
  placeholder?: string
}

/**
 * Searchable select (combobox). Renders a visually-hidden native <select>
 * carrying every passed prop, so both usage patterns keep working unchanged:
 *   - react-hook-form: {...form.register(name)} (ref + change events)
 *   - controlled: value= / onChange=(e) => ... (e.target.value)
 * The visible part is a type-to-filter input; picking an option sets the
 * hidden select's value and dispatches a real change event.
 */
export const Select = React.forwardRef<HTMLSelectElement, SelectProps>(
  ({ className, options, placeholder, id, disabled, ...props }, ref) => {
    const innerRef = React.useRef<HTMLSelectElement | null>(null)
    const listRef = React.useRef<HTMLDivElement | null>(null)
    const [open, setOpen] = React.useState(false)
    const [query, setQuery] = React.useState('')
    const [current, setCurrent] = React.useState<string>(String(props.value ?? props.defaultValue ?? ''))
    const [highlight, setHighlight] = React.useState(0)

    const setRefs = (element: HTMLSelectElement | null) => {
      innerRef.current = element
      if (typeof ref === 'function') ref(element)
      else if (ref) (ref as React.MutableRefObject<HTMLSelectElement | null>).current = element
    }

    // Keep the displayed value in sync with the hidden select — covers
    // react-hook-form writing values through the ref (no event fired).
    React.useEffect(() => {
      const value = innerRef.current?.value
      if (value !== undefined && value !== current) setCurrent(value)
    })

    const commit = (value: string) => {
      const element = innerRef.current
      if (!element) return
      const setter = Object.getOwnPropertyDescriptor(HTMLSelectElement.prototype, 'value')?.set
      setter?.call(element, value)
      element.dispatchEvent(new Event('change', { bubbles: true }))
      setCurrent(value)
      setOpen(false)
      setQuery('')
    }

    const normalizedQuery = query.trim().toLowerCase()
    const filtered = normalizedQuery
      ? options.filter((option) => `${option.label} ${option.value}`.toLowerCase().includes(normalizedQuery))
      : options
    const selectedLabel = options.find((option) => option.value === current)?.label ?? ''

    const close = () => {
      setOpen(false)
      setQuery('')
      setHighlight(0)
    }

    return (
      <div
        className={cn('relative', className)}
        onBlur={(event) => {
          if (!event.currentTarget.contains(event.relatedTarget as Node)) close()
        }}
      >
        {/* Hidden native select: the single source of truth for forms. */}
        <select
          ref={setRefs}
          tabIndex={-1}
          aria-hidden="true"
          className="sr-only"
          disabled={disabled}
          {...props}
          onChange={(event) => {
            setCurrent(event.target.value)
            props.onChange?.(event)
          }}
        >
          <option value="">{placeholder ?? ''}</option>
          {options.map((option) => (
            <option key={option.value} value={option.value}>
              {option.label}
            </option>
          ))}
        </select>

        <div className="relative">
          <input
            id={id}
            type="text"
            role="combobox"
            aria-expanded={open}
            autoComplete="off"
            disabled={disabled}
            className={cn(
              'portal-input flex h-10 w-full rounded-md border border-slate-200 bg-white px-3 py-2 pr-8 text-sm text-slate-950 shadow-sm outline-none',
              'disabled:cursor-not-allowed disabled:bg-slate-50 disabled:text-slate-500',
            )}
            placeholder={selectedLabel || placeholder || 'Select'}
            value={open ? query : selectedLabel}
            onFocus={() => {
              setOpen(true)
              setQuery('')
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
                if (open && filtered[highlight]) {
                  event.preventDefault()
                  commit(filtered[highlight]!.value)
                }
              } else if (event.key === 'Tab') {
                close()
              }
            }}
          />
          <ChevronDown className="pointer-events-none absolute right-2.5 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
        </div>

        {open && !disabled ? (
          <div className="absolute z-50 mt-1 w-full overflow-hidden rounded-md border border-slate-200 bg-white shadow-lg">
            {normalizedQuery === '' && options.length > 8 ? (
              <div className="flex items-center gap-1.5 border-b border-slate-100 px-3 py-1.5 text-xs text-slate-400">
                <Search className="h-3 w-3" />
                Type to search {options.length} options
              </div>
            ) : null}
            <div ref={listRef} className="max-h-60 overflow-y-auto py-1">
              {placeholder && !normalizedQuery ? (
                <button
                  type="button"
                  className="block w-full px-3 py-2 text-left text-sm text-slate-400 hover:bg-slate-50"
                  onMouseDown={(event) => {
                    event.preventDefault()
                    commit('')
                  }}
                >
                  {placeholder}
                </button>
              ) : null}
              {filtered.map((option, index) => (
                <button
                  key={option.value}
                  type="button"
                  className={cn(
                    'block w-full px-3 py-2 text-left text-sm hover:bg-slate-100',
                    index === highlight ? 'bg-slate-100' : '',
                    option.value === current ? 'font-semibold text-[var(--portal-navy,#1e3a8a)]' : 'text-slate-900',
                  )}
                  onMouseDown={(event) => {
                    event.preventDefault()
                    commit(option.value)
                  }}
                  onMouseEnter={() => setHighlight(index)}
                >
                  {option.label}
                </button>
              ))}
              {filtered.length === 0 ? (
                <div className="px-3 py-2 text-sm text-slate-400">No matches</div>
              ) : null}
            </div>
          </div>
        ) : null}
      </div>
    )
  },
)
Select.displayName = 'Select'
