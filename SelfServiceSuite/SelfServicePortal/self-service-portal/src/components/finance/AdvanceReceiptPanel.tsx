import { useState } from 'react'
import { Link } from 'react-router-dom'
import { CheckCircle2, Clock, HandCoins, Receipt } from 'lucide-react'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { useConfirmAdvanceReceipt } from '@/hooks/useConfirmAdvanceReceipt'
import type { PortalRequest } from '@/types/erp.types'
import { advancePaid, fullySettled, receiptConfirmed } from '@/utils/advanceReceipt'
import { formatCurrency, formatDateTime } from '@/utils/formatters'

/**
 * The step after approval on an Advance Request: waiting for Finance to pay → confirm the payment was received →
 * settle it. Shown on the request itself, not only on the settlement page. With BC 1.0.3.662
 * (`receiptAfterApproval`) the confirmation is offered right after approval, like the Store receipt (client,
 * 16 Nov 2026); settlement still needs Finance's payment in Business Central.
 */
export function AdvanceReceiptPanel({
  request,
  supportsReceipt,
  receiptAfterApproval = false,
}: {
  request: PortalRequest
  supportsReceipt: boolean
  receiptAfterApproval?: boolean
}) {
  const confirm = useConfirm()
  const receipt = useConfirmAdvanceReceipt()
  const [remarks, setRemarks] = useState('')
  if (!supportsReceipt || !['Approved', 'Posted'].includes(request.status) || fullySettled(request)) return null
  const payload = request.payload ?? {}
  const amount = Number(payload.TotalNetAmount ?? payload.Total_Net_Amount ?? request.amount ?? 0)
  const paid = advancePaid(request)

  if (!paid && !receiptAfterApproval && !receiptConfirmed(request)) {
    return (
      <section className="flex items-start gap-3 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-700">
        <Clock className="mt-0.5 h-4 w-4 shrink-0 text-slate-500" />
        <p>
          <span className="font-semibold text-slate-900">Approved — waiting for Finance to pay.</span> When Finance has paid the
          advance in Business Central, confirm here that you received the money; Advance Settlement opens after that.
        </p>
      </section>
    )
  }

  if (receiptConfirmed(request)) {
    const on = String(payload.ReceiptConfirmedOn ?? payload.Receipt_Confirmed_On ?? '')
    const confirmedOn = on && !on.startsWith('0001') ? ` — confirmed ${formatDateTime(on)}` : ''
    if (!paid) {
      return (
        <section className="flex items-start gap-3 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-950">
          <CheckCircle2 className="mt-0.5 h-5 w-5 shrink-0 text-emerald-600" />
          <p className="min-w-0 flex-1">
            <span className="font-semibold">Payment received</span>
            {confirmedOn}. Finance still has to record the payment in Business Central; Advance Settlement opens for this
            advance after that.
          </p>
        </section>
      )
    }
    return (
      <section className="flex flex-wrap items-center gap-3 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-950">
        <CheckCircle2 className="h-5 w-5 shrink-0 text-emerald-600" />
        <p className="min-w-0 flex-1">
          <span className="font-semibold">Payment received</span>
          {confirmedOn}. Next: settle the advance with the actual expenses and their evidence.
        </p>
        <Button asChild size="sm">
          <Link to="/finance/advance-settlement">
            <Receipt className="mr-2 h-4 w-4" />
            Go to Advance Settlement
          </Link>
        </Button>
      </section>
    )
  }

  const confirmNow = async () => {
    const ok = await confirm({
      title: `Confirm you received ${request.requestNo}?`,
      message: paid
        ? 'Confirm only once the money is in your hands or your bank account. Advance Settlement opens for this advance after you confirm.'
        : 'Confirm only once Finance has paid you and the money is in your hands or your bank account. Advance Settlement opens once Finance has also recorded the payment in Business Central.',
      confirmLabel: 'Yes, I received it',
    })
    if (ok) receipt.mutate({ advanceNo: request.requestNo, remarks: remarks.trim() })
  }

  return (
    <section
      className="rounded-xl border-2 border-amber-300 bg-amber-50 px-4 py-4 text-sm text-amber-950 shadow-sm"
      aria-label="Confirm payment received"
    >
      <div className="flex flex-wrap items-start gap-3">
        <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-amber-200 text-amber-900">
          <HandCoins className="h-5 w-5" />
        </span>
        <div className="min-w-0 flex-1">
          <p className="text-base font-semibold">
            {paid
              ? 'Finance has paid this advance — confirm you received the money'
              : 'Approved — confirm here once you receive the money from Finance'}
          </p>
          <p className="mt-1 text-amber-900">
            {request.requestNo}
            {amount > 0 ? ` · ${formatCurrency(amount)}` : ''}.{' '}
            {paid
              ? 'Advance Settlement is possible only after you confirm the payment was received.'
              : 'Finance pays the approved advance (cash, cheque or bank transfer). When the money reaches you, confirm it here; Advance Settlement opens after that.'}
          </p>
          <div className="mt-3 flex flex-col gap-2 sm:flex-row sm:items-center">
            <Input
              value={remarks}
              maxLength={250}
              onChange={(event) => setRemarks(event.target.value)}
              placeholder="Remarks (optional), e.g. received by bank transfer"
              className="bg-white sm:max-w-md"
            />
            <Button type="button" disabled={receipt.isPending} onClick={() => void confirmNow()}>
              <HandCoins className="mr-2 h-4 w-4" />
              {receipt.isPending ? 'Confirming…' : 'Confirm Payment Received'}
            </Button>
          </div>
        </div>
      </div>
    </section>
  )
}
