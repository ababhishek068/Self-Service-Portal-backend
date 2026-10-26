import { useState } from 'react'
import { Check, Pencil, X } from 'lucide-react'
import { useMutation } from '@tanstack/react-query'
import { setStoreApproverQuantity } from '@/api/endpoints/requestEndpoint'
import { useToast } from '@/components/feedback/ToastProvider'
import { Input } from '@/components/ui/input'

/**
 * Requested quantity on a store requisition line in My Approvals. The approver whose approval is
 * open can reduce it (e.g. 4 to 2) before approving; Business Central logs the change.
 */
export function ApproverQuantityCell({
  requestId,
  lineNo,
  quantity,
  display,
  onSaved,
}: {
  requestId: string
  lineNo: number
  quantity: number
  display: string
  onSaved: () => Promise<unknown>
}) {
  const toast = useToast()
  const [value, setValue] = useState<string | null>(null)
  const mutation = useMutation({
    mutationFn: (next: number) => setStoreApproverQuantity(requestId, lineNo, next),
  })
  const next = Number(value ?? '')
  const valid = next > 0 && next <= quantity

  const save = async () => {
    if (!valid) return
    if (next === quantity) {
      setValue(null)
      return
    }
    try {
      await mutation.mutateAsync(next)
      await onSaved()
      toast.success(`Quantity changed from ${quantity} to ${next}. Approve or reject when ready.`)
      setValue(null)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not change the quantity.', 'Quantity')
    }
  }

  if (value === null) {
    return (
      <span className="inline-flex items-center justify-end gap-1">
        {display}
        <button
          type="button"
          title="Reduce quantity"
          aria-label={`Reduce quantity on line ${lineNo}`}
          className="rounded-md p-1 text-slate-400 transition hover:bg-teal-50 hover:text-[var(--portal-navy-dark)]"
          onClick={() => setValue(String(quantity))}
        >
          <Pencil className="h-3.5 w-3.5" />
        </button>
      </span>
    )
  }

  return (
    <form
      className="inline-flex items-center justify-end gap-1"
      onSubmit={(event) => {
        event.preventDefault()
        void save()
      }}
    >
      <Input
        autoFocus
        type="number"
        min={1}
        max={quantity}
        step="any"
        inputMode="decimal"
        aria-label={`Quantity on line ${lineNo}`}
        title={`Up to ${quantity}`}
        className="h-8 w-20 text-right"
        value={value}
        disabled={mutation.isPending}
        onChange={(event) => setValue(event.target.value)}
        onKeyDown={(event) => {
          if (event.key === 'Escape') setValue(null)
        }}
      />
      <button
        type="submit"
        disabled={mutation.isPending || !valid}
        aria-label="Save quantity"
        className="rounded-md p-1 text-emerald-700 transition hover:bg-emerald-50 disabled:opacity-40"
      >
        <Check className="h-4 w-4" />
      </button>
      <button
        type="button"
        disabled={mutation.isPending}
        aria-label="Cancel"
        className="rounded-md p-1 text-slate-400 transition hover:bg-slate-100 disabled:opacity-40"
        onClick={() => setValue(null)}
      >
        <X className="h-4 w-4" />
      </button>
    </form>
  )
}
