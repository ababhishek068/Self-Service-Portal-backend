import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'

export type LprDraftLineChange = {
  lineNo: number
  quantity: number
  description: string
  specification: string
}

type DraftLine = {
  lineNo: string
  description: string
  specification: string
  quantity: number
  unitOfMeasure: string
}

function text(value: unknown) {
  return String(value ?? '').trim()
}

function draftLines(lines: Array<Record<string, unknown>>): DraftLine[] {
  return lines.map((line) => {
    const description = text(line.description) || text(line.itemName)
    return {
      lineNo: text(line.lineNo),
      description,
      specification: text(line.specification) === description ? '' : text(line.specification),
      quantity: Number(line.quantity ?? 0),
      unitOfMeasure: text(line.unitOfMeasure),
    }
  })
}

/**
 * Step 7 on a Draft LPR: the assigned Procurement Officer checks the need, quantity and
 * specification on each line before Submit to Operations Manager (as on the BC LPR card).
 */
export function LprDraftLineEditor({
  lines,
  busy,
  onSave,
}: {
  lines: Array<Record<string, unknown>>
  busy: boolean
  /** Resolves true when Business Central saved the line (errors are shown by the caller). */
  onSave: (change: LprDraftLineChange) => Promise<boolean>
}) {
  const rows = draftLines(lines)
  const [edits, setEdits] = useState<Record<string, DraftLine>>({})
  if (!rows.length) return null

  return (
    <div className="space-y-2 rounded-md border border-teal-100 bg-white/80 p-3">
      <p className="text-sm font-semibold text-[var(--portal-navy)]">Prepare the LPR lines</p>
      <p className="text-xs text-slate-600">
        Check the need, quantity and specification, save each changed line, then Submit to Operations Manager.
      </p>
      {rows.map((row) => {
        const edit = edits[row.lineNo] ?? row
        const changed =
          edit.description !== row.description ||
          edit.specification !== row.specification ||
          edit.quantity !== row.quantity
        const update = (patch: Partial<DraftLine>) =>
          setEdits((current) => ({ ...current, [row.lineNo]: { ...edit, ...patch } }))
        return (
          <div key={row.lineNo} className="grid gap-2 border-t border-slate-100 pt-2 md:grid-cols-[2fr_2fr_8rem_auto] md:items-end">
            <label className="space-y-1 text-xs font-medium text-slate-700">
              Item / need
              <Input value={edit.description} onChange={(event) => update({ description: event.target.value })} disabled={busy} />
            </label>
            <label className="space-y-1 text-xs font-medium text-slate-700">
              Specification
              <Textarea
                rows={1}
                className="min-h-9"
                value={edit.specification}
                onChange={(event) => update({ specification: event.target.value })}
                disabled={busy}
              />
            </label>
            <label className="space-y-1 text-xs font-medium text-slate-700">
              Quantity{row.unitOfMeasure ? ` (${row.unitOfMeasure})` : ''}
              <Input
                type="number"
                min={0}
                step="any"
                value={Number.isFinite(edit.quantity) ? String(edit.quantity) : ''}
                onChange={(event) => update({ quantity: Number(event.target.value) })}
                disabled={busy}
              />
            </label>
            <Button
              type="button"
              variant="outline"
              disabled={busy || !changed || !(edit.quantity > 0) || !edit.description.trim()}
              onClick={() =>
                void onSave({
                  lineNo: Number(row.lineNo),
                  quantity: edit.quantity,
                  description: edit.description.trim(),
                  specification: edit.specification.trim(),
                }).then((saved) => {
                  if (!saved) return
                  setEdits((current) => {
                    const next = { ...current }
                    delete next[row.lineNo]
                    return next
                  })
                })
              }
            >
              Save line
            </Button>
          </div>
        )
      })}
    </div>
  )
}
