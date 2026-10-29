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
  /** Long text (e.g. the specification) wraps in the table instead of being cut off. */
  wrap?: boolean
  /** Choices of a select column (Type uses TYPE_OPTIONS). */
  options?: Array<{ value: string; label: string }>
  /**
   * Filled by the Procurement Officer after approval: hidden while BC says lineDetailsVisible =
   * false (LPR Draft, Pending Operations Manager, Pending FAD), when the lines carry the request only.
   */
  detail?: boolean
}

/** LPR line Request Type (BC "ABH Request Type"), not BC's posting Type. */
export const REQUEST_TYPE_OPTIONS = [
  { value: '', label: ' ' },
  { value: 'Item', label: 'Item' },
  { value: 'Service', label: 'Service' },
  { value: 'Fixed Asset', label: 'Fixed Asset' },
  { value: 'Consumable', label: 'Consumable' },
]

/** The Purchase Requisition Subform columns; Local RFQ / PO lines use the same keys (BC chain lines). */
export const PURCHASE_LINE_COLUMNS: LineColumn[] = [
  {
    header: 'Request Type',
    key: 'requestType',
    kind: 'select',
    options: REQUEST_TYPE_OPTIONS,
    value: (line) => text(line.requestType),
  },
  {
    header: 'Type',
    key: 'type',
    kind: 'select',
    detail: true,
    value: (line) => typeCode(text(line.bcType)),
    display: (line) => TYPE_OPTIONS.find((option) => option.value === typeCode(text(line.bcType)))?.label ?? '',
  },
  { header: 'Item / Service Code', key: 'no', kind: 'code', detail: true, value: (line) => text(line.bcNo) },
  { header: 'Typed Code', key: 'portalItemCode', kind: 'text', detail: true, value: (line) => text(line.portalItemCode) },
  { header: 'Item / Service Name', key: 'description', kind: 'text', value: (line) => pick(line.bcDescription, line.itemName) },
  { header: 'Description / Purpose', key: 'purpose', kind: 'longtext', wrap: true, value: (line) => text(line.purpose) },
  { header: 'Category', key: 'category', kind: 'text', detail: true, value: (line) => pick(line.requestCategory, line.category) },
  // The requester's Additional specification (BC Request Summary, up to 1000 characters from BC 1.0.3.577).
  { header: 'Specification', key: 'specification', kind: 'longtext', wrap: true, value: (line) => text(line.specification) },
  { header: 'Preferred Brand / Model', key: 'brandModel', kind: 'text', value: (line) => text(line.preferredBrandModel) },
  {
    header: 'Required Date',
    key: 'requiredDate',
    kind: 'date',
    value: (line) => text(line.requiredDate).slice(0, 10),
    display: (line) => dateValue(text(line.requiredDate)),
  },
  { header: 'Suggested Supplier', key: 'suggestedSupplier', kind: 'text', detail: true, value: (line) => text(line.suggestedSupplier) },
  { header: 'Remarks', key: 'remarks', kind: 'text', value: (line) => pick(line.extendedDescription, line.remarks) },
  { header: 'Location Code', key: 'locationCode', kind: 'code', value: (line) => text(line.location) },
  { header: 'Quantity', key: 'quantity', kind: 'number', numeric: true, value: (line) => quantity(line.quantity) },
  { header: 'UOM', key: 'unitOfMeasureCode', kind: 'code', value: (line) => pick(line.unitOfMeasureCode, line.unitOfMeasure) },
  { header: 'VAT Prod. Posting Group', key: 'vatProdPostingGroup', kind: 'code', detail: true, value: (line) => text(line.vatProdPostingGroup) },
  {
    header: 'Estimated Unit Price',
    key: 'directUnitCost',
    kind: 'number',
    numeric: true,
    detail: true,
    value: (line) => quantity(line.directUnitCost ?? line.estimatedUnitPrice),
    display: (line) => amount(line.directUnitCost ?? line.estimatedUnitPrice),
  },
]

/** The fields of the request on an LPR line, carried to the RFQ and PO lines (shown there, edited on the LPR). */
const CARRIED_REQUEST_KEYS = new Set(['requestType', 'purpose', 'remarks'])

/**
 * Local RFQ / Purchase Order lines: the subform columns BC shows there, with Direct Unit Cost, and
 * the request carried from the LPR (Request Type, Purpose, Remarks; BC 1.0.3.580).
 */
export const ORDER_LINE_COLUMNS: LineColumn[] = PURCHASE_LINE_COLUMNS.filter((column) =>
  ['requestType', 'type', 'no', 'description', 'purpose', 'specification', 'brandModel', 'requiredDate', 'remarks', 'locationCode', 'quantity', 'unitOfMeasureCode', 'vatProdPostingGroup', 'directUnitCost'].includes(column.key),
).map((column) =>
  column.key === 'directUnitCost'
    ? { ...column, header: 'Direct Unit Cost' }
    : CARRIED_REQUEST_KEYS.has(column.key)
      ? { ...column, readOnly: true }
      : column,
)

/** BC SUBMIT_LPR_OPS refuses a line without these: the same check before the request goes to BC. */
export function lprLinesMissingFields(lines: PurchaseLine[]) {
  return lines
    .map((line) => {
      const missing = [
        !text(line.requestType) && 'Request Type',
        !pick(line.bcDescription, line.itemName) && 'Item / Service Name',
        !text(line.purpose) && 'Purpose',
        !pick(line.unitOfMeasureCode, line.unitOfMeasure) && 'UOM',
        !(Number(line.quantity ?? 0) > 0) && 'Quantity',
        !text(line.requiredDate) && 'Required Date',
      ].filter(Boolean)
      return missing.length
        ? `Line ${text(line.lineNo)}${pick(line.bcDescription, line.itemName) ? ` (${pick(line.bcDescription, line.itemName)})` : ''} is missing: ${missing.join(', ')}`
        : ''
    })
    .filter(Boolean)
}

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
