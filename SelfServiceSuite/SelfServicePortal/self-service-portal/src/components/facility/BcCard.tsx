import type { ReactNode } from 'react'

/** `key` fields show by default; the rest open with Show all details. `editor` replaces the value box while editing. */
export type CardField = {
  label: string
  value: ReactNode
  emphasis?: 'user' | 'strong'
  key?: boolean
  editor?: ReactNode
}

/** A text value longer than this wraps in its box instead of being cut off ("…"). */
const WRAP_AFTER_CHARS = 32

/**
 * One BC card field: label, dotted leader, value box (blank values keep an empty box, as in BC).
 * Long text (a description, purpose, process step or comment) is shown in full, wrapped.
 */
export function CardRow({ label, value, emphasis, editor }: Omit<CardField, 'key'>) {
  const empty = value === '' || value === null || value === undefined
  const long = typeof value === 'string' && value.trim().length > WRAP_AFTER_CHARS
  return (
    <div className={`flex min-w-0 gap-2 py-1 ${long ? 'items-start' : 'items-center'}`}>
      <span
        className={`flex min-w-0 shrink-0 basis-[42%] items-center gap-1 text-sm text-slate-600 max-w-60 ${long ? 'min-h-[2rem]' : ''}`}
      >
        <span className="truncate">{label}</span>
        <span className="mb-1 h-px min-w-3 flex-1 border-b border-dotted border-slate-300" aria-hidden="true" />
      </span>
      {editor ? (
        <div className="min-w-0 flex-1">{editor}</div>
      ) : (
      <span
        className={`min-h-[2rem] min-w-0 flex-1 rounded bg-slate-100 px-2.5 py-1.5 text-sm ${
          long ? 'whitespace-pre-wrap break-words' : 'truncate'
        } ${
          emphasis === 'user'
            ? 'font-semibold text-teal-700'
            : emphasis === 'strong'
              ? 'font-semibold text-slate-900'
              : 'text-slate-800'
        }`}
        title={typeof value === 'string' ? value : undefined}
      >
        {empty ? '' : value}
      </span>
      )}
    </div>
  )
}

export function CardSection({
  title,
  intro,
  fields,
  showAll,
  action,
}: {
  title: string
  intro?: string
  fields: CardField[]
  showAll: boolean
  /** Buttons at the right of the section title (e.g. Edit / Save). */
  action?: ReactNode
}) {
  const visible = showAll ? fields : fields.filter((field) => field.key)
  return (
    <section>
      <div className="flex flex-wrap items-end justify-between gap-2 border-b-2 border-slate-700/80 pb-1.5">
        <h3 className="text-base font-semibold text-slate-900">{title}</h3>
        {action}
      </div>
      {intro && showAll ? <p className="mt-3 max-w-3xl text-sm text-slate-600">{intro}</p> : null}
      {/* Columns of at least 24rem, never more than 3: 1 on phones, 2 on laptops, 3 on wider screens. */}
      <div className="mt-2 grid grid-cols-[repeat(auto-fill,minmax(min(100%,max(24rem,calc((100%_-_6rem)/3))),1fr))] gap-x-12">
        {visible.map((field) => (
          <CardRow
            key={field.label}
            label={field.label}
            value={field.value}
            emphasis={field.emphasis}
            editor={field.editor}
          />
        ))}
      </div>
    </section>
  )
}

export type CardEditorKind = 'text' | 'longtext' | 'code' | 'date' | 'number' | 'select' | 'boolean'

/** An editable BC card value: same height as the value box; codes are upper-case as in BC. */
export function CardEditor({
  kind,
  value,
  onChange,
  options = [],
  label,
  disabled,
}: {
  kind: CardEditorKind
  value: string
  onChange: (value: string) => void
  options?: Array<{ value: string; label: string }>
  label: string
  disabled?: boolean
}) {
  const box =
    'h-8 w-full rounded border border-slate-300 bg-white px-2.5 text-sm text-slate-900 outline-none transition focus:border-teal-500 focus:ring-2 focus:ring-teal-500/20 disabled:bg-slate-100'
  if (kind === 'boolean') {
    return (
      <label className="flex h-8 items-center gap-2 text-sm text-slate-700">
        <input
          type="checkbox"
          aria-label={label}
          className="h-4 w-4 accent-teal-600"
          checked={value === 'true'}
          disabled={disabled}
          onChange={(event) => onChange(event.target.checked ? 'true' : 'false')}
        />
        {value === 'true' ? 'Yes' : 'No'}
      </label>
    )
  }
  if (kind === 'select') {
    return (
      <select aria-label={label} className={box} value={value} disabled={disabled} onChange={(event) => onChange(event.target.value)}>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    )
  }
  if (kind === 'longtext') {
    return (
      <textarea
        aria-label={label}
        className={`${box} h-auto min-h-[4.5rem] py-1.5`}
        rows={3}
        value={value}
        disabled={disabled}
        onChange={(event) => onChange(event.target.value)}
      />
    )
  }
  return (
    <input
      aria-label={label}
      className={box}
      type={kind === 'date' ? 'date' : kind === 'number' ? 'number' : 'text'}
      inputMode={kind === 'number' ? 'decimal' : undefined}
      value={value}
      disabled={disabled}
      onChange={(event) => onChange(kind === 'code' ? event.target.value.toUpperCase() : event.target.value)}
    />
  )
}
