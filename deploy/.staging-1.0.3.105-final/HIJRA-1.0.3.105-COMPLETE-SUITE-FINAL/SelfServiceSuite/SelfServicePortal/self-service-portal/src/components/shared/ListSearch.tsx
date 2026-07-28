import { Search, X } from 'lucide-react'
import { Input } from '@/components/ui/input'

interface ListSearchProps {
  value: string
  onChange: (value: string) => void
  total: number
  shown: number
  placeholder?: string
  ariaLabel?: string
}

export function ListSearch({
  value,
  onChange,
  total,
  shown,
  placeholder = 'Search records...',
  ariaLabel = 'Search records',
}: ListSearchProps) {
  if (total <= 1 && !value) return null

  return (
    <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
      <label className="relative block w-full sm:max-w-md">
        <span className="sr-only">{ariaLabel}</span>
        <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
        <Input
          type="search"
          value={value}
          onChange={(event) => onChange(event.target.value)}
          placeholder={placeholder}
          aria-label={ariaLabel}
          className="pr-10 pl-9"
        />
        {value ? (
          <button
            type="button"
            onClick={() => onChange('')}
            aria-label={`Clear ${ariaLabel.toLocaleLowerCase()}`}
            className="absolute right-2 top-1/2 flex h-7 w-7 -translate-y-1/2 items-center justify-center rounded-full text-slate-400 transition hover:bg-slate-100 hover:text-slate-700"
          >
            <X className="h-4 w-4" />
          </button>
        ) : null}
      </label>
      <p className="text-xs text-slate-500" aria-live="polite">
        {value ? `${shown} of ${total} records` : `${total} records`}
      </p>
    </div>
  )
}
