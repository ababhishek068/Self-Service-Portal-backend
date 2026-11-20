import { useId, useState } from 'react'
import { CircleAlert, HandCoins, Loader2 } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { useConfirmAdvanceReceipt } from '@/hooks/useConfirmAdvanceReceipt'
import { cn } from '@/lib/utils'

export const RECEIPT_CONFIRMATION_TEXT = 'I confirm that I have received the advance payment from Finance.'

/**
 * Confirm Payment Received with the client's mandatory check box (Pending issues, 20 Nov 2026: "clicking
 * confirmation did nothing"; "put a check box … and make it mandatory"). The button stays disabled until the box is
 * ticked; one click then records the receipt in Business Central (PortalAdvanceConfirmReceipt). Progress and Business
 * Central's error are shown right here, so a click never looks like nothing happened.
 */
export function AdvanceReceiptConfirm({
  advanceNo,
  remarks = '',
  compact = false,
  onConfirmed,
}: {
  advanceNo: string
  remarks?: string
  /** Smaller layout for a row in a list (Advance Settlement prerequisite). */
  compact?: boolean
  onConfirmed?: (receiptConfirmedOn: string) => void
}) {
  const receipt = useConfirmAdvanceReceipt()
  const [checked, setChecked] = useState(false)
  const checkboxId = useId()
  const failure = receipt.isError
    ? receipt.error instanceof Error
      ? receipt.error.message
      : 'Business Central did not record the confirmation.'
    : ''

  const confirmNow = () => {
    if (!checked || receipt.isPending) return
    receipt.mutate(
      { advanceNo, remarks: remarks.trim() },
      { onSuccess: (result) => onConfirmed?.(String(result?.receiptConfirmedOn || new Date().toISOString())) },
    )
  }

  return (
    <div
      className={cn('rounded-xl border border-slate-200 bg-white', compact ? 'px-2.5 py-2' : 'px-3 py-3')}
      role="group"
      aria-label={`Confirm payment received for ${advanceNo}`}
    >
      <label htmlFor={checkboxId} className={cn('flex cursor-pointer items-start gap-2.5 text-slate-800', compact ? 'text-xs' : 'text-sm')}>
        <input
          id={checkboxId}
          type="checkbox"
          checked={checked}
          disabled={receipt.isPending}
          onChange={(event) => {
            setChecked(event.target.checked)
            if (receipt.isError) receipt.reset()
          }}
          className={cn('mt-0.5 shrink-0 cursor-pointer accent-[var(--portal-navy)]', compact ? 'h-4 w-4' : 'h-5 w-5')}
          required
        />
        <span>
          {RECEIPT_CONFIRMATION_TEXT}
          <span className="text-rose-600" aria-hidden>
            {' '}
            *
          </span>
        </span>
      </label>
      <Button
        type="button"
        size={compact ? 'sm' : 'default'}
        className={cn('mt-2', compact ? 'text-xs!' : 'w-full text-sm!')}
        disabled={!checked || receipt.isPending}
        aria-disabled={!checked || receipt.isPending}
        onClick={confirmNow}
        title={checked ? undefined : 'Tick the confirmation box first'}
      >
        {receipt.isPending ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <HandCoins className="mr-2 h-4 w-4" />}
        {receipt.isPending ? 'Confirming with Business Central…' : 'Confirm Payment Received'}
      </Button>
      {failure ? (
        <p
          className={cn(
            'mt-2 flex items-start gap-2 rounded-lg border border-rose-200 bg-rose-50 px-3 py-2 text-rose-800',
            compact ? 'text-xs' : 'text-sm',
          )}
          role="alert"
        >
          <CircleAlert className="mt-0.5 h-4 w-4 shrink-0" />
          <span>
            <span className="font-semibold">Not confirmed.</span> {failure}
          </span>
        </p>
      ) : null}
    </div>
  )
}
