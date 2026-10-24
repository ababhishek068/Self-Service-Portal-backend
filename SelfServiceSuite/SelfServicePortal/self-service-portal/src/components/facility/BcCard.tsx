import type { ReactNode } from 'react'

/** `key` fields show by default; the rest open with Show all details. */
export type CardField = { label: string; value: ReactNode; emphasis?: 'user' | 'strong'; key?: boolean }

/** One BC card field: label, dotted leader, value box (blank values keep an empty box, as in BC). */
export function CardRow({ label, value, emphasis }: Omit<CardField, 'key'>) {
  const empty = value === '' || value === null || value === undefined
  return (
    <div className="flex min-w-0 items-center gap-2 py-1">
      <span className="flex min-w-0 shrink-0 basis-[42%] items-center gap-1 text-sm text-slate-600 max-w-60">
        <span className="truncate">{label}</span>
        <span className="mb-1 h-px min-w-3 flex-1 border-b border-dotted border-slate-300" aria-hidden="true" />
      </span>
      <span
        className={`min-h-[2rem] min-w-0 flex-1 truncate rounded bg-slate-100 px-2.5 py-1.5 text-sm ${
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
    </div>
  )
}

export function CardSection({
  title,
  intro,
  fields,
  showAll,
}: {
  title: string
  intro?: string
  fields: CardField[]
  showAll: boolean
}) {
  const visible = showAll ? fields : fields.filter((field) => field.key)
  return (
    <section>
      <h3 className="border-b-2 border-slate-700/80 pb-1.5 text-base font-semibold text-slate-900">{title}</h3>
      {intro && showAll ? <p className="mt-3 max-w-3xl text-sm text-slate-600">{intro}</p> : null}
      {/* Columns of at least 24rem, never more than 3: 1 on phones, 2 on laptops, 3 on wider screens. */}
      <div className="mt-2 grid grid-cols-[repeat(auto-fill,minmax(min(100%,max(24rem,calc((100%_-_6rem)/3))),1fr))] gap-x-12">
        {visible.map((field) => (
          <CardRow key={field.label} label={field.label} value={field.value} emphasis={field.emphasis} />
        ))}
      </div>
    </section>
  )
}
