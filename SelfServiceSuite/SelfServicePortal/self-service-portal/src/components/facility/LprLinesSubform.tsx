import { useState } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { Pencil, Plus, Trash2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { getLocalPurchaseState, runLocalPurchaseAction } from '@/api/endpoints/requestEndpoint'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { CardEditor, type CardEditorKind } from '@/components/facility/BcCard'
import { dateValue, pick, text } from '@/components/facility/bcCardValues'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import type { PortalRequest } from '@/types/erp.types'
import { formatCurrency } from '@/utils/formatters'

type Line = Record<string, unknown>

/** BC Purchase Line Type (enum ordinal) as the subform shows it. */
const TYPE_OPTIONS = [
  { value: '0', label: ' ' },
  { value: '1', label: 'G/L Account' },
  { value: '2', label: 'Item' },
  { value: '3', label: 'Resource' },
  { value: '4', label: 'Fixed Asset' },
  { value: '5', label: 'Charge (Item)' },
]

function typeCode(raw: string) {
  const value = raw.replace(/_x0020_/g, ' ').replace(/_x0028_|_x0029_/g, '').replace(/_/g, ' ').trim().toLowerCase()
  if (!value) return '0'
  if (value.startsWith('g')) return '1'
  if (value.startsWith('item')) return '2'
  if (value.startsWith('resource')) return '3'
  if (value.startsWith('fixed')) return '4'
  if (value.startsWith('charge')) return '5'
  return /^\d+$/.test(value) ? value : '0'
}

/** One subform column: BC caption, payload key for UPDATE_LPR_LINE / ADD_LPR_LINE, editor, value. */
type Column = {
  header: string
  key: string
  kind: CardEditorKind
  value: (line: Line) => string
  display?: (line: Line) => string
  numeric?: boolean
}

const COLUMNS: Column[] = [
  {
    header: 'Type',
    key: 'type',
    kind: 'select',
    value: (line) => typeCode(text(line.bcType)),
    display: (line) => TYPE_OPTIONS.find((option) => option.value === typeCode(text(line.bcType)))?.label ?? '',
  },
  { header: 'Item / Service Code', key: 'no', kind: 'code', value: (line) => text(line.bcNo) },
  { header: 'Typed Code', key: 'portalItemCode', kind: 'text', value: (line) => text(line.portalItemCode) },
  { header: 'Item / Service Name', key: 'description', kind: 'text', value: (line) => pick(line.bcDescription, line.itemName) },
  { header: 'Category', key: 'category', kind: 'text', value: (line) => pick(line.requestCategory, line.category) },
  { header: 'Specification', key: 'specification', kind: 'text', value: (line) => text(line.specification) },
  { header: 'Preferred Brand / Model', key: 'brandModel', kind: 'text', value: (line) => text(line.preferredBrandModel) },
  {
    header: 'Required Date',
    key: 'requiredDate',
    kind: 'date',
    value: (line) => text(line.requiredDate).slice(0, 10),
    display: (line) => dateValue(text(line.requiredDate)),
  },
  { header: 'Suggested Supplier', key: 'suggestedSupplier', kind: 'text', value: (line) => text(line.suggestedSupplier) },
  { header: 'Remarks', key: 'remarks', kind: 'text', value: (line) => pick(line.extendedDescription, line.remarks) },
  { header: 'Location Code', key: 'locationCode', kind: 'code', value: (line) => text(line.location) },
  { header: 'Quantity', key: 'quantity', kind: 'number', numeric: true, value: (line) => String(Number(line.quantity ?? 0) || '') },
  { header: 'UOM', key: 'unitOfMeasureCode', kind: 'code', value: (line) => pick(line.unitOfMeasureCode, line.unitOfMeasure) },
  { header: 'VAT Prod. Posting Group', key: 'vatProdPostingGroup', kind: 'code', value: (line) => text(line.vatProdPostingGroup) },
  {
    header: 'Estimated Unit Price',
    key: 'directUnitCost',
    kind: 'number',
    numeric: true,
    value: (line) => String(Number(line.directUnitCost ?? line.estimatedUnitPrice ?? 0) || ''),
    display: (line) => {
      const value = Number(line.directUnitCost ?? line.estimatedUnitPrice ?? 0)
      return value ? formatCurrency(value) : ''
    },
  },
]

function lineValues(line: Line | null) {
  return Object.fromEntries(COLUMNS.map((column) => [column.key, line ? column.value(line) : column.key === 'type' ? '0' : '']))
}

/**
 * LPR lines as the BC Purchase Requisition Subform: the same columns, read-only for everyone, and
 * New Line / Edit / Delete Line for the assigned Procurement Officer while the card is editable.
 */
export function LprLinesSubform({ request }: { request: PortalRequest }) {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const access = useLocalPurchaseAccess()
  const stateQuery = useQuery({
    queryKey: ['local-purchase', request.id],
    queryFn: () => getLocalPurchaseState(request.id),
    enabled: access.enabled,
    retry: false,
  })
  // Line being edited: 'new', a line number, or null; draft holds its values by payload key.
  const [editing, setEditing] = useState<string | null>(null)
  const [draft, setDraft] = useState<Record<string, string>>({})
  const mutation = useMutation({
    mutationFn: (body: Parameters<typeof runLocalPurchaseAction>[1]) => runLocalPurchaseAction(request.id, body),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['local-purchase', request.id] })
      await queryClient.invalidateQueries({ queryKey: ['facility', 'purchase-requisition'] })
    },
  })

  const lines = Array.isArray(request.payload?.lines) ? (request.payload.lines as Line[]) : []
  const lprNo = text(stateQuery.data?.chain.lpr?.no)
  const editable =
    stateQuery.data?.cardEditable === true && lprNo.toUpperCase() === request.requestNo.trim().toUpperCase()
  const busy = mutation.isPending
  const total = lines.reduce((sum, line) => sum + Number(line.lineAmount ?? line.amount ?? 0), 0)

  const startEdit = (line: Line | null) => {
    setEditing(line ? text(line.lineNo) : 'new')
    setDraft(lineValues(line))
  }

  const save = async () => {
    const isNew = editing === 'new'
    const original = isNew ? lineValues(null) : lineValues(lines.find((line) => text(line.lineNo) === editing) ?? null)
    const quantity = Number(draft.quantity || 0)
    if (!(quantity > 0)) {
      toast.error('Quantity must be more than 0.', 'LPR line')
      return
    }
    if (isNew && !draft.description.trim() && !draft.no.trim()) {
      toast.error('Enter the Item / Service Name or Code.', 'LPR line')
      return
    }
    const changed = Object.fromEntries(
      COLUMNS.filter((column) => (draft[column.key] ?? '') !== original[column.key]).map((column) => [
        column.key,
        draft[column.key] ?? '',
      ]),
    )
    // Business Central 1.0.3.567 and earlier need lineNo and quantity on every line save.
    const payload = isNew ? changed : { ...changed, lineNo: Number(editing), quantity: draft.quantity }
    try {
      await mutation.mutateAsync({
        actionCode: isNew ? 'ADD_LPR_LINE' : 'UPDATE_LPR_LINE',
        documentNo: lprNo,
        payload,
      })
      setEditing(null)
      toast.success(isNew ? `Line added to ${lprNo}.` : `Line saved on ${lprNo}.`)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not save the line', 'LPR line')
    }
  }

  const remove = async (line: Line) => {
    const name = pick(line.bcDescription, line.itemName) || `line ${text(line.lineNo)}`
    const yes = await confirm({
      title: 'Delete Line',
      message: `Delete ${name} from ${lprNo}?`,
      confirmLabel: 'Delete Line',
      tone: 'danger',
    })
    if (!yes) return
    try {
      await mutation.mutateAsync({ actionCode: 'DELETE_LPR_LINE', documentNo: lprNo, payload: { lineNo: Number(line.lineNo) } })
      toast.success(`Line deleted from ${lprNo}.`)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not delete the line', 'Delete Line')
    }
  }

  return (
    <section>
      <div className="flex flex-wrap items-end justify-between gap-2 border-b-2 border-slate-700/80 pb-1.5">
        <h3 className="text-base font-semibold text-slate-900">Purchase Requisition Subform</h3>
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
              {COLUMNS.map((column) => (
                <th key={column.key} className={`whitespace-nowrap px-3 py-2 font-medium ${column.numeric ? 'text-right' : ''}`}>
                  {column.header}
                </th>
              ))}
              <th className="whitespace-nowrap px-3 py-2 text-right font-medium">Estimated Total Price</th>
              {editable ? <th className="px-3 py-2" aria-label="Line actions" /> : null}
            </tr>
          </thead>
          <tbody>
            {lines.length === 0 ? (
              <tr>
                <td colSpan={COLUMNS.length + 2} className="px-3 py-4 text-center text-slate-500">
                  No lines yet.
                </td>
              </tr>
            ) : null}
            {lines.map((line) => (
              <tr
                key={text(line.lineNo)}
                className={`border-t border-slate-100 ${editing === text(line.lineNo) ? 'bg-teal-50/70' : ''}`}
              >
                {COLUMNS.map((column) => (
                  <td
                    key={column.key}
                    className={`max-w-[16rem] truncate whitespace-nowrap px-3 py-2 ${column.numeric ? 'text-right tabular-nums' : ''}`}
                    title={column.value(line)}
                  >
                    {(column.display ?? column.value)(line)}
                  </td>
                ))}
                <td className="whitespace-nowrap px-3 py-2 text-right tabular-nums">
                  {Number(line.lineAmount ?? line.amount ?? 0) ? formatCurrency(Number(line.lineAmount ?? line.amount)) : ''}
                </td>
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
          {total ? (
            <tfoot>
              <tr className="border-t border-slate-200 bg-slate-50 font-semibold">
                <td colSpan={COLUMNS.length} className="px-3 py-2 text-right">
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
            {editing === 'new' ? `New line on ${lprNo}` : `Edit line ${editing} on ${lprNo}`}
          </p>
          <div className="mt-3 grid grid-cols-[repeat(auto-fill,minmax(min(100%,14rem),1fr))] gap-x-4 gap-y-3">
            {COLUMNS.map((column) => (
              <label key={column.key} className="block space-y-1">
                <span className="text-xs font-medium text-slate-600">{column.header}</span>
                <CardEditor
                  kind={column.kind}
                  label={column.header}
                  options={column.key === 'type' ? TYPE_OPTIONS : undefined}
                  value={draft[column.key] ?? ''}
                  disabled={busy}
                  onChange={(value) => setDraft((current) => ({ ...current, [column.key]: value }))}
                />
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
