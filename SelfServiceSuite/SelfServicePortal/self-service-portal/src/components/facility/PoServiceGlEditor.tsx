import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { LookupCombobox } from '@/components/shared/LookupCombobox'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { pick, text } from '@/components/facility/bcCardValues'
import type { PurchaseLine } from '@/components/facility/bcPurchaseLines'

function isTrue(value: unknown) {
  return String(value).toLowerCase() === 'true'
}

/**
 * Service lines of a Local PO and their G/L account (BC 1.0.3.590 SET_SERVICE_GL): set by the
 * Procurement Officer or the Finance Checker before the Operations Manager approves the PO, which
 * BC refuses while a Service line has none.
 */
export function PoServiceGlEditor({
  poNo,
  lines,
  busy,
  onSave,
}: {
  poNo: string
  lines: PurchaseLine[]
  busy: boolean
  onSave: (lineNo: number, glAccountNo: string) => Promise<boolean>
}) {
  const accounts = useLookupOptions('services')
  const [draft, setDraft] = useState<Record<string, string>>({})
  const serviceLines = lines.filter(
    (line) =>
      isTrue(line.needsGlAccount) ||
      (text(line.requestType).toLowerCase() === 'service' && /g\/?l/i.test(text(line.bcType))),
  )
  if (!serviceLines.length) return null

  return (
    <section className="mt-4 rounded-lg border border-amber-200 bg-amber-50/60 p-4">
      <p className="text-sm font-semibold text-amber-900">Service G/L accounts on {poNo}</p>
      <p className="mt-0.5 text-xs text-amber-900/80">
        A service line needs its G/L account before the Operations Manager can approve the PO.
      </p>
      <ul className="mt-3 space-y-3">
        {serviceLines.map((line) => {
          const lineNo = text(line.lineNo)
          const current = text(line.glAccountNo) || (/g\/?l/i.test(text(line.bcType)) ? text(line.bcNo) : '')
          const value = draft[lineNo] ?? current
          return (
            <li key={lineNo} className="grid gap-2 sm:grid-cols-[minmax(0,1fr)_minmax(0,20rem)_auto] sm:items-center">
              <div className="min-w-0">
                <p className="text-sm font-medium text-slate-900">
                  Line {lineNo}: {pick(line.bcDescription, line.itemName) || 'Service'}
                </p>
                <p className="text-xs text-slate-600">
                  {isTrue(line.needsGlAccount) ? (
                    <span className="font-semibold text-red-700">G/L needed</span>
                  ) : (
                    <>
                      G/L {current}
                      {text(line.glAccountName) ? ` · ${text(line.glAccountName)}` : ''}
                    </>
                  )}
                </p>
              </div>
              <LookupCombobox
                id={`service-gl-${lineNo}`}
                options={accounts.options}
                value={value}
                onChange={(next) => setDraft((all) => ({ ...all, [lineNo]: next }))}
                loading={accounts.isLoading}
                disabled={busy}
                placeholder="Search G/L account by No. or name"
                emptyText="Could not load the G/L accounts from Business Central. Type the account No."
              />
              <Button
                type="button"
                size="sm"
                variant="gradient"
                disabled={busy || !value.trim() || value.trim() === current}
                onClick={() =>
                  void onSave(Number(line.lineNo), value.trim()).then((saved) => {
                    if (saved) setDraft((all) => ({ ...all, [lineNo]: '' }))
                  })
                }
              >
                Set G/L
              </Button>
            </li>
          )
        })}
      </ul>
    </section>
  )
}
