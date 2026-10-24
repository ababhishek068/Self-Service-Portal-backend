import { useId, useState, type KeyboardEvent } from 'react'
import { ChevronDown } from 'lucide-react'
import type { LookupOption } from '@/api/endpoints/lookups'
import { cn } from '@/lib/utils'

const MAX_SHOWN = 50

/**
 * A BC lookup field: type part of the code or the name, then pick from the Business Central list
 * (as the lookup on a BC field). Only listed values are kept; if the list could not be loaded the
 * typed code is used and BC validates it on save.
 */
export function LookupCombobox({
  id,
  options,
  value,
  onChange,
  placeholder,
  disabled,
  loading,
}: {
  id?: string
  options: LookupOption[]
  value: string
  onChange: (value: string) => void
  placeholder?: string
  disabled?: boolean
  loading?: boolean
}) {
  const listId = useId()
  // Text being typed (null when showing the chosen value).
  const [query, setQuery] = useState<string | null>(null)
  const [open, setOpen] = useState(false)
  const [active, setActive] = useState(0)
  const selected = options.find((option) => option.value === value)
  const search = (query ?? '').trim().toLowerCase()
  const matches = (
    search
      ? options.filter((option) => option.value.toLowerCase().includes(search) || option.label.toLowerCase().includes(search))
      : options
  ).slice(0, MAX_SHOWN)

  const choose = (option: LookupOption) => {
    onChange(option.value)
    setQuery(null)
    setOpen(false)
  }

  const close = () => {
    setOpen(false)
    if (query === null) return
    const exact = options.find((option) => option.value.toLowerCase() === search)
    if (exact) choose(exact)
    else if (options.length === 0) onChange(query.trim().toUpperCase())
    setQuery(null)
  }

  const onKeyDown = (event: KeyboardEvent<HTMLInputElement>) => {
    if (event.key === 'ArrowDown') {
      event.preventDefault()
      setOpen(true)
      setActive((index) => Math.min(index + 1, Math.max(matches.length - 1, 0)))
    } else if (event.key === 'ArrowUp') {
      event.preventDefault()
      setActive((index) => Math.max(index - 1, 0))
    } else if (event.key === 'Enter' && open && matches[active]) {
      event.preventDefault()
      choose(matches[active])
    } else if (event.key === 'Escape') {
      setQuery(null)
      setOpen(false)
    }
  }

  return (
    <div className="relative">
      <input
        id={id}
        role="combobox"
        aria-expanded={open}
        aria-controls={listId}
        aria-autocomplete="list"
        autoComplete="off"
        className="portal-input flex h-10 w-full rounded-md border border-slate-200 bg-white py-2 pl-3 pr-9 text-sm text-slate-950 shadow-sm outline-none disabled:cursor-not-allowed disabled:bg-slate-50 disabled:text-slate-500"
        value={query ?? (selected ? selected.label : value)}
        placeholder={loading ? 'Loading from Business Central…' : placeholder}
        disabled={disabled}
        onFocus={() => setOpen(true)}
        onClick={() => setOpen(true)}
        onBlur={close}
        onKeyDown={onKeyDown}
        onChange={(event) => {
          setQuery(event.target.value)
          setOpen(true)
          setActive(0)
        }}
      />
      <ChevronDown className="pointer-events-none absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" aria-hidden="true" />
      {open && !disabled && (options.length > 0 || loading) ? (
        <ul
          id={listId}
          role="listbox"
          className="absolute z-30 mt-1 max-h-72 w-full min-w-[18rem] overflow-y-auto rounded-md border border-slate-200 bg-white py-1 text-sm shadow-lg"
        >
          {loading ? <li className="px-3 py-2 text-slate-500">Loading from Business Central…</li> : null}
          {!loading && matches.length === 0 ? <li className="px-3 py-2 text-slate-500">No match in Business Central.</li> : null}
          {matches.map((option, index) => (
            <li
              key={option.value}
              role="option"
              aria-selected={option.value === value}
              // Keep focus in the input so blur does not close the list before the click lands.
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => choose(option)}
              onMouseEnter={() => setActive(index)}
              className={cn(
                'cursor-pointer px-3 py-2',
                index === active ? 'bg-teal-50 text-teal-900' : 'text-slate-800',
                option.value === value && 'font-semibold',
              )}
            >
              {option.label}
            </li>
          ))}
          {!search && options.length > MAX_SHOWN ? (
            <li className="px-3 py-2 text-xs text-slate-500">Type part of the number or name to find more.</li>
          ) : null}
        </ul>
      ) : null}
    </div>
  )
}
