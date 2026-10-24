import type { CardEditorKind } from '@/components/facility/BcCard'
import { dateValue, pick, text } from '@/components/facility/bcCardValues'
import { formatCurrency } from '@/utils/formatters'

export type PurchaseLine = Record<string, unknown>

/** BC Purchase Line Type (enum ordinal) as the subform shows it. */
export const TYPE_OPTIONS = [
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

function amount(value: unknown) {
  const number = Number(value ?? 0)
  return number ? formatCurrency(number) : ''
}

function quantity(value: unknown) {
  return String(Number(value ?? 0) || '')
}

/**
 * One subform column: BC caption, payload key for the line actions (UPDATE_*_LINE / ADD_*_LINE),
 * editor and value. `readOnly` columns are shown but never edited (e.g. Quantity Received).
 */
export type LineColumn = {
  header: string
  key: string
  kind: CardEditorKind
  value: (line: PurchaseLine) => string
  display?: (line: PurchaseLine) => string
  numeric?: boolean
  readOnly?: boolean
}

/** The Purchase Requisition Subform columns; Local RFQ / PO lines use the same keys (BC chain lines). */
export const PURCHASE_LINE_COLUMNS: LineColumn[] = [
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
  { header: 'Quantity', key: 'quantity', kind: 'number', numeric: true, value: (line) => quantity(line.quantity) },
  { header: 'UOM', key: 'unitOfMeasureCode', kind: 'code', value: (line) => pick(line.unitOfMeasureCode, line.unitOfMeasure) },
  { header: 'VAT Prod. Posting Group', key: 'vatProdPostingGroup', kind: 'code', value: (line) => text(line.vatProdPostingGroup) },
  {
    header: 'Estimated Unit Price',
    key: 'directUnitCost',
    kind: 'number',
    numeric: true,
    value: (line) => quantity(line.directUnitCost ?? line.estimatedUnitPrice),
    display: (line) => amount(line.directUnitCost ?? line.estimatedUnitPrice),
  },
]

/** Local RFQ / Purchase Order lines: the subform columns BC shows there, with Direct Unit Cost. */
export const ORDER_LINE_COLUMNS: LineColumn[] = PURCHASE_LINE_COLUMNS.filter((column) =>
  ['type', 'no', 'description', 'specification', 'brandModel', 'requiredDate', 'locationCode', 'quantity', 'unitOfMeasureCode', 'vatProdPostingGroup', 'directUnitCost'].includes(column.key),
).map((column) => (column.key === 'directUnitCost' ? { ...column, header: 'Direct Unit Cost' } : column))

/** Receive columns on the Purchase Order lines (read-only; the Store Keeper sets Qty. to Receive in Receive). */
export const RECEIVE_LINE_COLUMNS: LineColumn[] = [
  { header: 'Qty. to Receive', key: 'qtyToReceive', kind: 'number', numeric: true, readOnly: true, value: (line) => quantity(line.qtyToReceive) },
  { header: 'Quantity Received', key: 'quantityReceived', kind: 'number', numeric: true, readOnly: true, value: (line) => quantity(line.quantityReceived) },
]

/** Editor values for a line (a new line starts blank with Type blank). */
export function lineValues(columns: LineColumn[], line: PurchaseLine | null) {
  return Object.fromEntries(
    columns
      .filter((column) => !column.readOnly)
      .map((column) => [column.key, line ? column.value(line) : column.key === 'type' ? '0' : '']),
  )
}
