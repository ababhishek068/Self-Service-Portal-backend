import { useState } from 'react'
import { Pencil } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { useToast } from '@/components/feedback/ToastProvider'
import { CardEditor, CardRow } from '@/components/facility/BcCard'
import { pick, text } from '@/components/facility/bcCardValues'
import type { PurchaseLine } from '@/components/facility/bcPurchaseLines'

function qty(value: unknown) {
  return String(Number(value ?? 0) || 0)
}

/**
 * Receive step on a released Local PO, as on the BC Purchase Order before Post → Receive: the Store
 * Keeper edits Vendor Shipment No. (delivery note) and Qty. to Receive per line, then posts the GRN.
 * A line left at 0 is filled with what is still outstanding when the receipt is posted.
 */
export function PoReceiveEditor({
  poNo,
  lines,
  vendorShipmentNo,
  busy,
  onSave,
}: {
  poNo: string
  lines: PurchaseLine[]
  vendorShipmentNo: string
  busy: boolean
  onSave: (payload: { vendorShipmentNo?: string; lines: Array<{ lineNo: number; qtyToReceive: string }> }) => Promise<boolean>
}) {
  const toast = useToast()
  const [draft, setDraft] = useState<{ shipment: string; qty: Record<string, string> } | null>(null)
  const receivable = lines.filter((line) => Number(line.outstandingQuantity ?? line.quantity ?? 0) > 0)

  const startEdit = () =>
    setDraft({
      shipment: vendorShipmentNo,
      qty: Object.fromEntries(receivable.map((line) => [text(line.lineNo), qty(line.qtyToReceive)])),
    })

  const save = async () => {
    if (!draft) return
    const changedLines = receivable
      .filter((line) => (draft.qty[text(line.lineNo)] ?? '') !== qty(line.qtyToReceive))
      .map((line) => ({ lineNo: Number(line.lineNo), qtyToReceive: draft.qty[text(line.lineNo)] || '0' }))
    const over = changedLines.find((change) => {
      const line = receivable.find((row) => Number(row.lineNo) === change.lineNo)
      return Number(change.qtyToReceive) < 0 || Number(change.qtyToReceive) > Number(line?.outstandingQuantity ?? line?.quantity ?? 0)
    })
    if (over) {
      toast.error(`Line ${over.lineNo}: Qty. to Receive must be between 0 and the outstanding quantity.`, 'Receive')
      return
    }
    const shipmentChanged = draft.shipment.trim() !== vendorShipmentNo
    if (!shipmentChanged && changedLines.length === 0) {
      setDraft(null)
      return
    }
    const payload = { ...(shipmentChanged ? { vendorShipmentNo: draft.shipment.trim() } : {}), lines: changedLines }
    if (await onSave(payload)) setDraft(null)
  }

  return (
    <section>
      <div className="flex flex-wrap items-end justify-between gap-2 border-b-2 border-slate-700/80 pb-1.5">
        <h3 className="text-base font-semibold text-slate-900">Receive (before Post Receive)</h3>
        {draft ? (
          <div className="flex gap-2">
            <Button type="button" size="sm" variant="outline" disabled={busy} onClick={() => setDraft(null)}>
              Cancel
            </Button>
            <Button type="button" size="sm" variant="gradient" disabled={busy} onClick={() => void save()}>
              {busy ? 'Saving…' : 'Save'}
            </Button>
          </div>
        ) : (
          <Button type="button" size="sm" variant="outline" disabled={busy} onClick={startEdit}>
            <Pencil className="h-4 w-4" />
            Edit
          </Button>
        )}
      </div>
      <p className="mt-2 text-sm text-slate-600">
        Enter what arrived on {poNo}. A line left at 0 is received in full when you Post Receive (GRN).
      </p>
      <div className="mt-2 max-w-xl">
        <CardRow
          label="Vendor Shipment No."
          value={vendorShipmentNo}
          editor={
            draft ? (
              <CardEditor
                kind="text"
                label="Vendor Shipment No."
                value={draft.shipment}
                disabled={busy}
                onChange={(value) => setDraft((current) => (current ? { ...current, shipment: value } : current))}
              />
            ) : undefined
          }
        />
      </div>
      <div className="mt-3 overflow-x-auto rounded-lg border border-slate-200">
        <table className="min-w-full text-left text-sm">
          <thead className="bg-slate-50 text-xs text-slate-600">
            <tr>
              <th className="px-3 py-2 font-medium">Item / Service Name</th>
              <th className="px-3 py-2 text-right font-medium">Quantity</th>
              <th className="px-3 py-2 text-right font-medium">Quantity Received</th>
              <th className="px-3 py-2 text-right font-medium">Outstanding</th>
              <th className="px-3 py-2 text-right font-medium">Qty. to Receive</th>
            </tr>
          </thead>
          <tbody>
            {receivable.length === 0 ? (
              <tr>
                <td colSpan={5} className="px-3 py-4 text-center text-slate-500">
                  Nothing left to receive.
                </td>
              </tr>
            ) : null}
            {receivable.map((line) => {
              const key = text(line.lineNo)
              return (
                <tr key={key} className="border-t border-slate-100">
                  <td className="px-3 py-2">{pick(line.bcDescription, line.bcNo) || `Line ${key}`}</td>
                  <td className="px-3 py-2 text-right tabular-nums">{qty(line.quantity)}</td>
                  <td className="px-3 py-2 text-right tabular-nums">{qty(line.quantityReceived)}</td>
                  <td className="px-3 py-2 text-right tabular-nums">{qty(line.outstandingQuantity)}</td>
                  <td className="w-40 px-3 py-1.5 text-right tabular-nums">
                    {draft ? (
                      <CardEditor
                        kind="number"
                        label={`Qty. to Receive, line ${key}`}
                        value={draft.qty[key] ?? ''}
                        disabled={busy}
                        onChange={(value) =>
                          setDraft((current) => (current ? { ...current, qty: { ...current.qty, [key]: value } } : current))
                        }
                      />
                    ) : (
                      qty(line.qtyToReceive)
                    )}
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </section>
  )
}
