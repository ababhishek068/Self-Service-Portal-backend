import * as React from 'react'
import { createPortal } from 'react-dom'
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
 * Searchable select (combobox). Dropdown is portaled + fixed so it is not clipped
 * by `.portal-card { overflow: hidden }` or the main scroll pane.
 */
export const Select = React.forwardRef<HTMLSelectElement, SelectProps>(
  ({ className, options, placeholder, id, disabled, ...props }, ref) => {
    const innerRef = React.useRef<HTMLSelectElement | null>(null)
    const anchorRef = React.useRef<HTMLDivElement | null>(null)
    const listRef = React.useRef<HTMLDivElement | null>(null)
    const [open, setOpen] = React.useState(false)
    const [query, setQuery] = React.useState('')
    const [current, setCurrent] = React.useState<string>(String(props.value ?? props.defaultValue ?? ''))
    const [highlight, setHighlight] = React.useState(0)
    const [menuBox, setMenuBox] = React.useState({ top: 0, left: 0, width: 0, maxHeight: 240 })

    const setRefs = (element: HTMLSelectElement | null) => {
      innerRef.current = element
      if (typeof ref === 'function') ref(element)
      else if (ref) (ref as React.MutableRefObject<HTMLSelectElement | null>).current = element
    }

    React.useEffect(() => {
      if (props.value === undefined) return
      const next = String(props.value ?? '')
      if (next !== current) setCurrent(next)
    }, [props.value, current])

    React.useEffect(() => {
      const value = innerRef.current?.value
      if (value !== undefined && value !== current && props.value === undefined) setCurrent(value)
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

    const updateMenuBox = React.useCallback(() => {
      const el = anchorRef.current
      if (!el) return
      const rect = el.getBoundingClientRect()
      const gap = 4
      const spaceBelow = window.innerHeight - rect.bottom - gap - 8
      const spaceAbove = rect.top - 8
      const preferBelow = spaceBelow >= 160 || spaceBelow >= spaceAbove
      const maxHeight = Math.min(280, Math.max(140, preferBelow ? spaceBelow : spaceAbove))
      const top = preferBelow ? rect.bottom + gap : Math.max(8, rect.top - gap - maxHeight)
      setMenuBox({
        top,
        left: rect.left,
        width: Math.max(rect.width, 180),
        maxHeight,
      })
    }, [])

    React.useEffect(() => {
      if (!open) return
      updateMenuBox()
      const onReposition = () => updateMenuBox()
      window.addEventListener('resize', onReposition)
      window.addEventListener('scroll', onReposition, true)
      return () => {
        window.removeEventListener('resize', onReposition)
        window.removeEventListener('scroll', onReposition, true)
      }
    }, [open, updateMenuBox, filtered.length])

    React.useEffect(() => {
      if (!open) return
      const onPointerDown = (event: MouseEvent) => {
        const target = event.target as Node
        if (anchorRef.current?.contains(target)) return
        if (listRef.current?.contains(target)) return
        close()
      }
      document.addEventListener('mousedown', onPointerDown)
      return () => document.removeEventListener('mousedown', onPointerDown)
    }, [open])

    const menu =
      open && !disabled
        ? createPortal(
            <div
              ref={listRef}
              className="overflow-hidden rounded-md border border-slate-200 bg-white shadow-xl"
              style={{
                position: 'fixed',
                top: menuBox.top,
                left: menuBox.left,
                width: menuBox.width,
                zIndex: 10000,
              }}
            >
              {normalizedQuery === '' && options.length > 8 ? (
                <div className="flex items-center gap-1.5 border-b border-slate-100 px-3 py-1.5 text-xs text-slate-400">
                  <Search className="h-3 w-3" />
                  Type to search {options.length} options
                </div>
              ) : null}
              <div className="overflow-y-auto py-1" style={{ maxHeight: menuBox.maxHeight }}>
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
            </div>,
            document.body,
          )
        : null

    return (
      <div ref={anchorRef} className={cn('relative', className)}>
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
        {menu}
      </div>
    )
  },
)
Select.displayName = 'Select'
