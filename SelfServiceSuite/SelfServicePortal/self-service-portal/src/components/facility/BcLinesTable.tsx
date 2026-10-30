import { useState } from 'react'
import { Pencil, Plus, Trash2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { CardEditor } from '@/components/facility/BcCard'
import { LookupCombobox } from '@/components/shared/LookupCombobox'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { useUnitOfMeasureOptions } from '@/hooks/useUnitOfMeasureOptions'
import { pick, text } from '@/components/facility/bcCardValues'
import { TYPE_OPTIONS, lineValues, type LineColumn, type PurchaseLine } from '@/components/facility/bcPurchaseLines'
import { formatCurrency } from '@/utils/formatters'

/** BC lookup behind Item / Service Code for each line Type (G/L Account, Item, Fixed Asset). */
const CODE_CATALOGS: Record<string, string> = { '1': 'services', '2': 'items', '4': 'purchase-assets' }

/** Item / Service Code picked from the BC list of the line's Type, as the lookup on the subform. */
function CatalogCodeField({
  catalog,
  label,
  value,
  disabled,
  onChange,
}: {
  catalog: string
  label: string
  value: string
  disabled: boolean
  onChange: (value: string) => void
}) {
  const lookup = useLookupOptions(catalog)
  return (
    <LookupCombobox
      id={`line-code-${catalog}`}
      options={lookup.options}
      value={value}
      onChange={onChange}
      loading={lookup.isLoading}
      disabled={disabled}
      placeholder={`Search ${label.toLowerCase()} by code or name`}
      emptyText="Could not load the list from Business Central. Type the code."
    />
  )
}

/** UOM from the BC Unit of Measure list; a code the list does not have stays selectable. */
function UnitOfMeasureField({
  value,
  disabled,
  onChange,
}: {
  value: string
  disabled: boolean
  onChange: (value: string) => void
}) {
  const units = useUnitOfMeasureOptions()
  if (!units.isLoading && units.options.length === 0) {
    return <CardEditor kind="code" label="UOM" value={value} disabled={disabled} onChange={onChange} />
  }
  const current = value.trim().toUpperCase()
  const options = [
    { value: '', label: units.isLoading ? 'Loading…' : 'Choose the unit' },
    ...(current && !units.options.some((option) => option.value.toUpperCase() === current)
      ? [{ value, label: value }]
      : []),
    ...units.options,
  ]
  const selected = units.options.find((option) => option.value.toUpperCase() === current)?.value ?? value
  return <CardEditor kind="select" label="UOM" options={options} value={selected} disabled={disabled} onChange={onChange} />
}

/**
 * A BC lines subform: the same columns, read-only for everyone, and New Line / Edit / Delete Line
 * when `editable` (the document's owner while BC lets the card be edited). `onSave` and `onDelete`
 * run the document's line actions and report the result; they return false when BC refused.
 */
export function BcLinesTable({
  title,
  lines,
  columns,
  docNo,
  editable,
  busy,
  totalHeader = 'Estimated Total Price',
  showTotal = true,
  onSave,
  onDelete,
}: {
  title: string
  lines: PurchaseLine[]
  columns: LineColumn[]
  docNo: string
  editable: boolean
  busy: boolean
  totalHeader?: string
  /** False while the amounts are not part of the request (LPR line details hidden). */
  showTotal?: boolean
  onSave: (isNew: boolean, payload: Record<string, unknown>) => Promise<boolean>
  onDelete: (line: PurchaseLine) => Promise<boolean>
}) {
  const toast = useToast()
  const confirm = useConfirm()
  // Line being edited: 'new', a line number, or null; draft holds its values by payload key.
  const [editing, setEditing] = useState<string | null>(null)
  const [draft, setDraft] = useState<Record<string, string>>({})
  const editColumns = columns.filter((column) => !column.readOnly)
  const total = lines.reduce((sum, line) => sum + Number(line.lineAmount ?? line.amount ?? 0), 0)

  const startEdit = (line: PurchaseLine | null) => {
    setEditing(line ? text(line.lineNo) : 'new')
    setDraft(lineValues(columns, line))
  }

  const save = async () => {
    const isNew = editing === 'new'
    const original = lineValues(columns, isNew ? null : (lines.find((line) => text(line.lineNo) === editing) ?? null))
    if (!(Number(draft.quantity || 0) > 0)) {
      toast.error('Quantity must be more than 0.', title)
      return
    }
    if (isNew && !draft.description?.trim() && !draft.no?.trim()) {
      toast.error('Enter the Item / Service Name or Code.', title)
      return
    }
    // BC validates an Item / G/L Account / Fixed Asset line against that card, so it needs the code.
    if (columns.some((column) => column.key === 'type') && (draft.type ?? '0') !== '0' && !draft.no?.trim()) {
      const typeLabel = TYPE_OPTIONS.find((option) => option.value === draft.type)?.label ?? 'this Type'
      toast.error(
        `A ${typeLabel} line needs its Item / Service Code. Pick it from the list, or set Type to blank for a free-text line.`,
        title,
      )
      return
    }
    const changed = Object.fromEntries(
      editColumns.filter((column) => (draft[column.key] ?? '') !== original[column.key]).map((column) => [column.key, draft[column.key] ?? '']),
    )
    // Business Central 1.0.3.567 and earlier need lineNo and quantity on every line save.
    const payload = isNew ? changed : { ...changed, lineNo: Number(editing), quantity: draft.quantity }
    if (await onSave(isNew, payload)) setEditing(null)
  }

  const remove = async (line: PurchaseLine) => {
    const name = pick(line.bcDescription, line.itemName) || `line ${text(line.lineNo)}`
    const yes = await confirm({
      title: 'Delete Line',
      message: `Delete ${name} from ${docNo}?`,
      confirmLabel: 'Delete Line',
      tone: 'danger',
    })
    if (yes) await onDelete(line)
  }

  return (
    <section>
      <div className="flex flex-wrap items-end justify-between gap-2 border-b-2 border-slate-700/80 pb-1.5">
        <h3 className="text-base font-semibold text-slate-900">{title}</h3>
        {editable && editing === null ? (
          <Button type="button" size="sm" variant="outline" disabled={busy} onClick={() => startEdit(null)}>
            <Plus className="h-4 w-4" />
            New Line
          </Button>
        ) : null}
      </div>

      <div className="mt-3 overflow-x-auto rounded-lg border border-slate-200">
        <table className="min-w-full text-left text-sm">
          <thead className="bg-slate-50 text-xs text-slate-600">
            <tr>
              {columns.map((column) => (
                <th key={column.key} className={`whitespace-nowrap px-3 py-2 font-medium ${column.numeric ? 'text-right' : ''}`}>
                  {column.header}
                </th>
              ))}
              {showTotal ? <th className="whitespace-nowrap px-3 py-2 text-right font-medium">{totalHeader}</th> : null}
              {editable ? <th className="px-3 py-2" aria-label="Line actions" /> : null}
            </tr>
          </thead>
          <tbody>
            {lines.length === 0 ? (
              <tr>
                <td colSpan={columns.length + (showTotal ? 2 : 1)} className="px-3 py-4 text-center text-slate-500">
                  No lines yet.
                </td>
              </tr>
            ) : null}
            {lines.map((line) => (
              <tr key={text(line.lineNo)} className={`border-t border-slate-100 ${editing === text(line.lineNo) ? 'bg-teal-50/70' : ''}`}>
                {columns.map((column) => (
                  <td
                    key={column.key}
                    className={`px-3 py-2 ${
                      column.wrap
                        ? 'min-w-[16rem] max-w-[28rem] whitespace-pre-wrap align-top'
                        : `max-w-[16rem] truncate whitespace-nowrap ${column.numeric ? 'text-right tabular-nums' : ''}`
                    }`}
                    title={column.value(line)}
                  >
                    {(column.display ?? column.value)(line)}
                  </td>
                ))}
                {showTotal ? (
                  <td className="whitespace-nowrap px-3 py-2 text-right tabular-nums">
                    {Number(line.lineAmount ?? line.amount ?? 0) ? formatCurrency(Number(line.lineAmount ?? line.amount)) : ''}
                  </td>
                ) : null}
                {editable ? (
                  <td className="whitespace-nowrap px-2 py-1 text-right">
                    <Button
                      type="button"
                      size="sm"
                      variant="ghost"
                      disabled={busy || editing !== null}
                      onClick={() => startEdit(line)}
                      aria-label={`Edit line ${text(line.lineNo)}`}
                    >
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button
                      type="button"
                      size="sm"
                      variant="ghost"
                      className="text-red-600 hover:bg-red-50"
                      disabled={busy || editing !== null}
                      onClick={() => void remove(line)}
                      aria-label={`Delete line ${text(line.lineNo)}`}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </td>
                ) : null}
              </tr>
            ))}
          </tbody>
          {total && showTotal ? (
            <tfoot>
              <tr className="border-t border-slate-200 bg-slate-50 font-semibold">
                <td colSpan={columns.length} className="px-3 py-2 text-right">
                  Total
                </td>
                <td className="whitespace-nowrap px-3 py-2 text-right tabular-nums">{formatCurrency(total)}</td>
                {editable ? <td /> : null}
              </tr>
            </tfoot>
          ) : null}
        </table>
      </div>

      {editing !== null ? (
        <div className="mt-3 rounded-lg border border-teal-200 bg-teal-50/50 p-4">
          <p className="text-sm font-semibold text-slate-900">
            {editing === 'new' ? `New line on ${docNo}` : `Edit line ${editing} on ${docNo}`}
          </p>
          <div className="mt-3 grid grid-cols-[repeat(auto-fill,minmax(min(100%,14rem),1fr))] gap-x-4 gap-y-3">
            {editColumns.map((column) => (
              <label key={column.key} className={`block space-y-1 ${column.kind === 'longtext' ? 'sm:col-span-2' : ''}`}>
                <span className="text-xs font-medium text-slate-600">{column.header}</span>
                {column.key === 'unitOfMeasureCode' ? (
                  <UnitOfMeasureField
                    value={draft.unitOfMeasureCode ?? ''}
                    disabled={busy}
                    onChange={(value) => setDraft((current) => ({ ...current, unitOfMeasureCode: value }))}
                  />
                ) : column.key === 'no' && CODE_CATALOGS[draft.type ?? ''] ? (
                  <CatalogCodeField
                    catalog={CODE_CATALOGS[draft.type ?? '']!}
                    label={TYPE_OPTIONS.find((option) => option.value === draft.type)?.label ?? 'code'}
                    value={draft.no ?? ''}
                    disabled={busy}
                    onChange={(value) => setDraft((current) => ({ ...current, no: value }))}
                  />
                ) : (
                  <CardEditor
                    kind={column.kind}
                    label={column.header}
                    options={column.options ?? (column.key === 'type' ? TYPE_OPTIONS : undefined)}
                    value={draft[column.key] ?? ''}
                    disabled={busy}
                    onChange={(value) =>
                      setDraft((current) =>
                        // A code belongs to its Type: changing the Type clears it.
                        column.key === 'type' && value !== current.type
                          ? { ...current, type: value, no: '' }
                          : { ...current, [column.key]: value },
                      )
                    }
                  />
                )}
              </label>
            ))}
          </div>
          <div className="mt-4 flex justify-end gap-2">
            <Button type="button" variant="outline" disabled={busy} onClick={() => setEditing(null)}>
              Cancel
            </Button>
            <Button type="button" variant="gradient" disabled={busy} onClick={() => void save()}>
              {busy ? 'Saving…' : editing === 'new' ? 'Add Line' : 'Save Line'}
            </Button>
          </div>
        </div>
      ) : null}
    </section>
  )
}
