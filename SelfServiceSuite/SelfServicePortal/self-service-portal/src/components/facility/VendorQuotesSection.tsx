import { Fragment, useState } from 'react'
import { ChevronDown, ChevronRight, Pencil, Trash2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { LookupCombobox } from '@/components/shared/LookupCombobox'
import type { LocalPurchaseVendorQuote, LocalPurchaseVendorQuoteLine } from '@/api/endpoints/requestEndpoint'
import type { PurchaseLine } from '@/components/facility/bcPurchaseLines'
import { formatAmount } from '@/utils/formatters'
import { todayIsoDate } from '@/utils/validators'
import { cn } from '@/lib/utils'

/** VAT registered vendors charge 15%; BC 1.0.3.594 keeps 0 for a vendor that is not registered. */
const DEFAULT_VAT_PERCENT = 15
const VAT_OPTIONS = [
  { value: '15', label: '15% (VAT registered)' },
  { value: '0', label: '0% (not VAT registered)' },
]

export type VendorQuoteSave = {
  vendorNo: string
  vendorQuoteNo: string
  quotedAmount: number
  vatPercent: number
  leadTimeDays: number
  quoteDate: string
  notes: string
  lineNo?: number
  lines?: Array<{ rfqLineNo: number; unitPrice: number }>
}

type QuoteForm = {
  lineNo?: number
  vendorNo: string
  vendorQuoteNo: string
  quotedAmount: string
  vatPercent: string
  leadTimeDays: string
  quoteDate: string
  notes: string
  /** Unit price per RFQ line no., as typed. */
  prices: Record<number, string>
  /** The quote was priced per item before this edit (its prices are sent even when cleared). */
  hadPrices: boolean
}

const EMPTY_FORM: QuoteForm = {
  vendorNo: '',
  vendorQuoteNo: '',
  quotedAmount: '',
  vatPercent: String(DEFAULT_VAT_PERCENT),
  leadTimeDays: '',
  quoteDate: '',
  notes: '',
  prices: {},
  hadPrices: false,
}

function text(value: unknown) {
  return String(value ?? '').trim()
}

function bcDate(value: unknown) {
  const raw = text(value)
  return raw && !raw.startsWith('0001-01-01') ? raw : ''
}

function amount(value: string) {
  const parsed = Number(value.replace(/,/g, ''))
  return Number.isFinite(parsed) ? parsed : NaN
}

function round2(value: number) {
  return Math.round(value * 100) / 100
}

/** VAT and total of a quote: BC's (1.0.3.594), or worked out the same way on older BC. */
function quoteTotals(quote: LocalPurchaseVendorQuote) {
  const quoted = Number(quote.quotedAmount ?? 0)
  const vatPercent = quote.vatPercent ?? DEFAULT_VAT_PERCENT
  const vat = quote.vatAmount ?? round2((quoted * vatPercent) / 100)
  return { quoted, vatPercent, vat, total: quote.totalAmount ?? round2(quoted + vat) }
}

/** RFQ lines to price: the quote's own (BC 1.0.3.594), else the Local RFQ lines. */
function priceLinesFor(quote: LocalPurchaseVendorQuote | undefined, rfqLines: PurchaseLine[]): LocalPurchaseVendorQuoteLine[] {
  if (quote?.lines?.length) return quote.lines
  return rfqLines
    .filter((line) => text(line.bcDescription) && Number(line.lineNo) > 0)
    .map((line) => ({
      rfqLineNo: Number(line.lineNo),
      description: text(line.bcDescription),
      specification: text(line.specification),
      unitOfMeasure: text(line.unitOfMeasureCode) || text(line.portalUnitOfMeasure),
      quantity: Number(line.quantity ?? 0),
      unitPrice: 0,
      lineAmount: 0,
      remarks: '',
    }))
}

/**
 * Vendor Quotes (Local RFQ) as on the UAT-2 final layout: Vendor Name | Quote No. | Quoted Amount |
 * VAT 15% | Total amount | Lead Time | Remarks, with the received date, attachments and winner kept.
 * A vendor opens to its item prices; the form works out VAT and the total as the amounts are typed.
 */
export function VendorQuotesSection({
  rfqNo,
  quotes,
  minQuotes,
  rfqLines,
  canEdit,
  canSelectWinner,
  busy,
  vendorOptions,
  vendorsLoading,
  formId,
  onSave,
  onAttach,
  onDelete,
  onSelectWinner,
}: {
  rfqNo: string
  quotes: LocalPurchaseVendorQuote[]
  minQuotes: number
  rfqLines: PurchaseLine[]
  canEdit: boolean
  canSelectWinner: boolean
  busy: boolean
  vendorOptions: Array<{ value: string; label: string }>
  vendorsLoading: boolean
  formId: string
  onSave: (quote: VendorQuoteSave) => Promise<boolean>
  onAttach: (quote: LocalPurchaseVendorQuote, file: File | undefined) => void
  onDelete: (quote: LocalPurchaseVendorQuote) => Promise<boolean>
  onSelectWinner: (quote: LocalPurchaseVendorQuote) => void
}) {
  const [form, setForm] = useState<QuoteForm>({ ...EMPTY_FORM, quoteDate: todayIsoDate() })
  const [error, setError] = useState('')
  const [opened, setOpened] = useState<number | null>(null)
  const reset = () => {
    setForm({ ...EMPTY_FORM, quoteDate: todayIsoDate() })
    setError('')
  }

  const editedQuote = form.lineNo ? quotes.find((quote) => quote.lineNo === form.lineNo) : undefined
  const priceLines = priceLinesFor(editedQuote, rfqLines)
  const pricedTotal = round2(
    priceLines.reduce((sum, line) => {
      const price = amount(form.prices[line.rfqLineNo] ?? '')
      return sum + (Number.isFinite(price) ? price * line.quantity : 0)
    }, 0),
  )
  const byItem = priceLines.some((line) => amount(form.prices[line.rfqLineNo] ?? '') > 0)
  const quoted = byItem ? pricedTotal : amount(form.quotedAmount)
  const vatPercent = Number(form.vatPercent)
  const vat = Number.isFinite(quoted) ? round2((quoted * vatPercent) / 100) : NaN
  const total = Number.isFinite(quoted) ? round2(quoted + vat) : NaN
  const columns = canEdit ? 12 : 11

  const edit = (quote: LocalPurchaseVendorQuote) => {
    const lines = priceLinesFor(quote, rfqLines)
    const prices = Object.fromEntries(
      lines.filter((line) => line.unitPrice > 0).map((line) => [line.rfqLineNo, String(line.unitPrice)]),
    )
    setForm({
      lineNo: quote.lineNo,
      vendorNo: quote.vendorNo,
      vendorQuoteNo: quote.vendorQuoteNo ?? '',
      quotedAmount: String(quote.quotedAmount ?? ''),
      vatPercent: String(quote.vatPercent ?? DEFAULT_VAT_PERCENT),
      leadTimeDays: String(quote.leadTimeDays ?? ''),
      quoteDate: bcDate(quote.quoteDate).slice(0, 10) || todayIsoDate(),
      notes: quote.notes ?? '',
      prices,
      hadPrices: Object.keys(prices).length > 0,
    })
    setError('')
  }

  const save = async () => {
    const vendorNo = form.vendorNo.trim()
    const leadTimeDays = Number(form.leadTimeDays || 0)
    const badPrice = priceLines.find((line) => {
      const raw = (form.prices[line.rfqLineNo] ?? '').trim()
      return raw !== '' && !(amount(raw) >= 0)
    })
    const problem = !vendorNo
      ? 'Vendor No. is required.'
      : badPrice
        ? `Enter a valid unit price for ${badPrice.description}.`
        : !Number.isFinite(quoted) || quoted <= 0
          ? 'Enter the Quoted Amount, or the unit prices of the items.'
          : !Number.isFinite(leadTimeDays) || leadTimeDays < 0
            ? 'Lead Time must be zero or more days.'
            : ''
    if (problem) {
      setError(problem)
      return
    }
    setError('')
    const saved = await onSave({
      vendorNo,
      vendorQuoteNo: form.vendorQuoteNo.trim(),
      quotedAmount: quoted,
      vatPercent,
      leadTimeDays,
      quoteDate: form.quoteDate,
      notes: form.notes.trim(),
      ...(form.lineNo ? { lineNo: form.lineNo } : {}),
      ...(byItem || form.hadPrices
        ? {
            lines: priceLines.map((line) => ({
              rfqLineNo: line.rfqLineNo,
              unitPrice: Math.max(0, amount(form.prices[line.rfqLineNo] ?? '') || 0),
            })),
          }
        : {}),
    })
    if (saved) reset()
  }

  return (
    <div className="space-y-2">
      <p className="font-semibold text-[var(--portal-navy)]">
        Vendor Quotes (Local RFQ)
        <span className="ml-2 text-xs font-normal text-slate-600">
          {quotes.length} received{minQuotes ? ` · minimum ${minQuotes}` : ''}
        </span>
      </p>
      <div className="overflow-x-auto rounded-md border border-teal-100 bg-white/70">
        <table className="min-w-full text-xs">
          <thead className="bg-teal-50 text-left text-slate-600">
            <tr>
              <th className="px-3 py-2 font-medium">Vendor No.</th>
              <th className="px-3 py-2 font-medium">Vendor Name</th>
              <th className="px-3 py-2 font-medium">Quote No.</th>
              <th className="px-3 py-2 text-right font-medium">Quoted Amount</th>
              <th className="px-3 py-2 text-right font-medium">VAT 15%</th>
              <th className="px-3 py-2 text-right font-medium">Total Amount</th>
              <th className="px-3 py-2 text-right font-medium">Lead Time (Days)</th>
              <th className="px-3 py-2 font-medium">Remarks</th>
              <th className="px-3 py-2 font-medium">Quote Received Date</th>
              <th className="px-3 py-2 font-medium">Attachments</th>
              <th className="px-3 py-2 font-medium">Winner</th>
              {canEdit ? <th className="px-3 py-2" aria-label="Quote actions" /> : null}
            </tr>
          </thead>
          <tbody>
            {quotes.length === 0 ? (
              <tr>
                <td colSpan={columns} className="px-3 py-3 text-slate-500">
                  No vendor quotes yet.
                </td>
              </tr>
            ) : null}
            {quotes.map((quote) => {
              const totals = quoteTotals(quote)
              const priced = (quote.lines ?? []).filter((line) => line.unitPrice > 0)
              const isOpen = opened === quote.lineNo
              return (
                <Fragment key={quote.lineNo}>
                  <tr className={cn('border-t border-teal-50', quote.selected && 'bg-teal-50')}>
                    <td className="px-3 py-2">{quote.vendorNo}</td>
                    <td className="px-3 py-2">
                      {quote.vendorName}
                      {priced.length ? (
                        <button
                          type="button"
                          className="mt-0.5 flex items-center gap-0.5 text-[11px] font-medium text-[var(--portal-navy)] hover:underline"
                          aria-expanded={isOpen}
                          onClick={() => setOpened(isOpen ? null : quote.lineNo)}
                        >
                          {isOpen ? <ChevronDown className="h-3 w-3" /> : <ChevronRight className="h-3 w-3" />}
                          Item prices ({priced.length})
                        </button>
                      ) : null}
                    </td>
                    <td className="px-3 py-2">{quote.vendorQuoteNo || '—'}</td>
                    <td className="whitespace-nowrap px-3 py-2 text-right tabular-nums">{formatAmount(totals.quoted)}</td>
                    <td className="whitespace-nowrap px-3 py-2 text-right tabular-nums">
                      {formatAmount(totals.vat)}
                      {totals.vatPercent !== DEFAULT_VAT_PERCENT ? (
                        <span className="block text-[11px] text-slate-500">{totals.vatPercent}% VAT</span>
                      ) : null}
                    </td>
                    <td className="whitespace-nowrap px-3 py-2 text-right font-semibold tabular-nums">
                      {formatAmount(totals.total)}
                    </td>
                    <td className="px-3 py-2 text-right">{quote.leadTimeDays}</td>
                    <td className="px-3 py-2">{quote.notes || '—'}</td>
                    <td className="px-3 py-2">{bcDate(quote.quoteDate)}</td>
                    <td className="px-3 py-2">
                      <span className={quote.attachments > 0 ? 'text-teal-800' : 'font-medium text-red-700'}>
                        {quote.attachments > 0 ? `${quote.attachments} file(s)` : 'Missing'}
                      </span>
                      {canEdit ? (
                        <label className="ml-2 cursor-pointer text-[var(--portal-navy)] underline">
                          Attach
                          <input
                            type="file"
                            className="sr-only"
                            accept=".pdf,.doc,.docx,.jpg,.png"
                            disabled={busy}
                            onChange={(event) => {
                              onAttach(quote, event.target.files?.[0])
                              event.target.value = ''
                            }}
                          />
                        </label>
                      ) : null}
                    </td>
                    <td className="px-3 py-2">
                      {quote.selected ? <strong className="text-teal-800">Selected</strong> : null}
                      {!quote.selected && canSelectWinner ? (
                        <Button type="button" variant="outline" size="sm" disabled={busy} onClick={() => onSelectWinner(quote)}>
                          Select as Winner (FAD)
                        </Button>
                      ) : null}
                    </td>
                    {canEdit ? (
                      <td className="whitespace-nowrap px-2 py-1 text-right">
                        <Button
                          type="button"
                          size="sm"
                          variant="ghost"
                          disabled={busy}
                          onClick={() => edit(quote)}
                          aria-label={`Edit quote from ${quote.vendorName || quote.vendorNo}`}
                        >
                          <Pencil className="h-4 w-4" />
                        </Button>
                        <Button
                          type="button"
                          size="sm"
                          variant="ghost"
                          className="text-red-600 hover:bg-red-50"
                          disabled={busy}
                          onClick={() =>
                            void onDelete(quote).then((deleted) => {
                              if (deleted && form.lineNo === quote.lineNo) reset()
                            })
                          }
                          aria-label={`Delete quote from ${quote.vendorName || quote.vendorNo}`}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </td>
                    ) : null}
                  </tr>
                  {isOpen ? (
                    <tr className="border-t border-teal-50 bg-slate-50/60">
                      <td colSpan={columns} className="px-3 py-2">
                        <ItemPriceTable lines={quote.lines ?? []} />
                      </td>
                    </tr>
                  ) : null}
                </Fragment>
              )
            })}
          </tbody>
        </table>
      </div>

      {canEdit ? (
        <div
          className={cn(
            'grid grid-cols-1 gap-2 rounded-md border bg-white/70 p-3 sm:grid-cols-3 lg:grid-cols-6',
            form.lineNo ? 'border-teal-300 bg-teal-50/50' : 'border-teal-100',
          )}
        >
          {form.lineNo ? (
            <p className="text-sm font-semibold text-slate-900 sm:col-span-3 lg:col-span-6">Edit the quote from {form.vendorNo}</p>
          ) : null}
          <div className="space-y-1 sm:col-span-3 lg:col-span-2">
            <Label htmlFor={`${formId}-vendor`}>Vendor No.</Label>
            <LookupCombobox
              id={`${formId}-vendor`}
              options={vendorOptions}
              loading={vendorsLoading}
              emptyText="Vendor list not available from Business Central. Type the exact Vendor No.; BC checks it on save."
              value={form.vendorNo}
              onChange={(vendorNo) => setForm((current) => ({ ...current, vendorNo }))}
              placeholder="Type vendor no. or name"
              disabled={busy || Boolean(form.lineNo)}
            />
          </div>
          <div className="space-y-1">
            <Label htmlFor={`${formId}-quote-no`}>Quote No.</Label>
            <Input
              id={`${formId}-quote-no`}
              value={form.vendorQuoteNo}
              placeholder="Vendor's quotation no."
              onChange={(event) => setForm({ ...form, vendorQuoteNo: event.target.value })}
              disabled={busy}
            />
          </div>
          <div className="space-y-1">
            <Label htmlFor={`${formId}-amount`}>Quoted Amount (excl. VAT)</Label>
            <Input
              id={`${formId}-amount`}
              inputMode="decimal"
              value={byItem ? String(pricedTotal) : form.quotedAmount}
              onChange={(event) => setForm({ ...form, quotedAmount: event.target.value })}
              disabled={busy || byItem}
              title={byItem ? 'The total of the item prices below' : undefined}
            />
          </div>
          <div className="space-y-1">
            <Label htmlFor={`${formId}-vat`}>VAT %</Label>
            <Select
              id={`${formId}-vat`}
              options={VAT_OPTIONS}
              value={form.vatPercent}
              onChange={(event) => setForm({ ...form, vatPercent: event.target.value })}
              disabled={busy}
            />
          </div>
          <div className="space-y-1">
            <Label htmlFor={`${formId}-lead`}>Lead Time (Days)</Label>
            <Input
              id={`${formId}-lead`}
              inputMode="numeric"
              value={form.leadTimeDays}
              onChange={(event) => setForm({ ...form, leadTimeDays: event.target.value })}
              disabled={busy}
            />
          </div>
          <div className="space-y-1">
            <Label>VAT ({form.vatPercent}%)</Label>
            <p className="flex h-10 items-center justify-end rounded-md border border-slate-200 bg-slate-50 px-3 text-sm tabular-nums text-slate-700">
              {Number.isFinite(vat) ? formatAmount(vat) : '—'}
            </p>
          </div>
          <div className="space-y-1">
            <Label>Total Amount</Label>
            <p className="flex h-10 items-center justify-end rounded-md border border-teal-200 bg-teal-50 px-3 text-sm font-semibold tabular-nums text-teal-900">
              {Number.isFinite(total) ? formatAmount(total) : '—'}
            </p>
          </div>
          <div className="space-y-1">
            <Label htmlFor={`${formId}-date`}>Quote Received Date</Label>
            <Input
              id={`${formId}-date`}
              type="date"
              value={form.quoteDate}
              onChange={(event) => setForm({ ...form, quoteDate: event.target.value })}
              disabled={busy}
            />
          </div>
          <div className="space-y-1 sm:col-span-3 lg:col-span-3">
            <Label htmlFor={`${formId}-notes`}>Remarks</Label>
            <Input
              id={`${formId}-notes`}
              value={form.notes}
              placeholder="e.g. In stock, with all accessories"
              onChange={(event) => setForm({ ...form, notes: event.target.value })}
              disabled={busy}
            />
          </div>

          {priceLines.length ? (
            <div className="space-y-1.5 sm:col-span-3 lg:col-span-6">
              <p className="text-xs font-semibold text-slate-700">
                Item prices <span className="font-normal text-slate-500">(optional)</span>
              </p>
              <p className="text-xs text-slate-500">
                Enter the vendor's unit price for each item; the Quoted Amount is then their total, and the winner's prices go
                onto the Purchase Order lines. Or leave them blank and enter the Quoted Amount for the whole lot.
              </p>
              <div className="overflow-x-auto rounded-md border border-slate-200 bg-white">
                <table className="min-w-full text-xs">
                  <thead className="bg-slate-50 text-left text-slate-600">
                    <tr>
                      <th className="px-3 py-1.5 font-medium">Item</th>
                      <th className="px-3 py-1.5 font-medium">Specification</th>
                      <th className="px-3 py-1.5 font-medium">UOM</th>
                      <th className="px-3 py-1.5 text-right font-medium">Quantity</th>
                      <th className="px-3 py-1.5 text-right font-medium">Unit Price (excl. VAT)</th>
                      <th className="px-3 py-1.5 text-right font-medium">Line Amount</th>
                    </tr>
                  </thead>
                  <tbody>
                    {priceLines.map((line) => {
                      const price = amount(form.prices[line.rfqLineNo] ?? '')
                      return (
                        <tr key={line.rfqLineNo} className="border-t border-slate-100">
                          <td className="px-3 py-1.5 font-medium text-slate-800">{line.description}</td>
                          <td className="max-w-xs truncate px-3 py-1.5 text-slate-600" title={line.specification}>
                            {line.specification || '—'}
                          </td>
                          <td className="px-3 py-1.5">{line.unitOfMeasure}</td>
                          <td className="px-3 py-1.5 text-right tabular-nums">{line.quantity}</td>
                          <td className="px-3 py-1 text-right">
                            <Input
                              aria-label={`Unit price of ${line.description}`}
                              inputMode="decimal"
                              className="ml-auto h-8 w-32 text-right"
                              value={form.prices[line.rfqLineNo] ?? ''}
                              onChange={(event) =>
                                setForm({ ...form, prices: { ...form.prices, [line.rfqLineNo]: event.target.value } })
                              }
                              disabled={busy}
                            />
                          </td>
                          <td className="whitespace-nowrap px-3 py-1.5 text-right tabular-nums">
                            {price > 0 ? formatAmount(round2(price * line.quantity)) : '—'}
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          ) : null}

          {error ? <p className="text-sm text-red-700 sm:col-span-3 lg:col-span-6">{error}</p> : null}
          <div className="flex gap-2 sm:col-span-3 lg:col-span-6">
            {form.lineNo ? (
              <Button type="button" variant="outline" disabled={busy} onClick={reset}>
                Cancel
              </Button>
            ) : null}
            <Button type="button" variant={form.lineNo ? 'gradient' : 'outline'} disabled={busy || !rfqNo} onClick={() => void save()}>
              {form.lineNo ? 'Save changes' : 'Save vendor quote'}
            </Button>
          </div>
        </div>
      ) : null}
    </div>
  )
}

/** A vendor's item prices under its quote row. */
function ItemPriceTable({ lines }: { lines: LocalPurchaseVendorQuoteLine[] }) {
  return (
    <table className="min-w-full text-xs">
      <thead className="text-left text-slate-500">
        <tr>
          <th className="px-2 py-1 font-medium">Item</th>
          <th className="px-2 py-1 font-medium">Specification</th>
          <th className="px-2 py-1 font-medium">UOM</th>
          <th className="px-2 py-1 text-right font-medium">Quantity</th>
          <th className="px-2 py-1 text-right font-medium">Unit Price</th>
          <th className="px-2 py-1 text-right font-medium">Line Amount</th>
          <th className="px-2 py-1 font-medium">Remarks</th>
        </tr>
      </thead>
      <tbody>
        {lines.map((line) => (
          <tr key={line.rfqLineNo} className="border-t border-slate-200/70">
            <td className="px-2 py-1 font-medium text-slate-800">{line.description}</td>
            <td className="max-w-xs truncate px-2 py-1 text-slate-600" title={line.specification}>
              {line.specification || '—'}
            </td>
            <td className="px-2 py-1">{line.unitOfMeasure}</td>
            <td className="px-2 py-1 text-right tabular-nums">{line.quantity}</td>
            <td className="whitespace-nowrap px-2 py-1 text-right tabular-nums">
              {line.unitPrice > 0 ? formatAmount(line.unitPrice) : '—'}
            </td>
            <td className="whitespace-nowrap px-2 py-1 text-right tabular-nums">
              {line.lineAmount > 0 ? formatAmount(line.lineAmount) : '—'}
            </td>
            <td className="px-2 py-1">{line.remarks || '—'}</td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}
