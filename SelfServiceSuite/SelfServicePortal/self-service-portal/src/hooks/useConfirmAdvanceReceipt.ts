import { useMutation, useQueryClient } from '@tanstack/react-query'
import { confirmAdvanceReceipt } from '@/api/endpoints/advanceSettlement'
import { useToast } from '@/components/feedback/ToastProvider'

/** Every query that shows an advance's payment / receipt / settlement state. */
const ADVANCE_RECEIPT_QUERY_KEYS = [
  ['finance', 'advance-request'],
  ['finance', 'advance-settlement'],
  ['finance', 'imprest', 'for-surrender'],
  ['notifications'],
] as const

/**
 * Confirm I received the advance payment (BC 1.0.3.653+, `PortalAdvanceConfirmReceipt`). Settlement is allowed
 * only after it; the advance, settlement and bell views refresh.
 */
export function useConfirmAdvanceReceipt() {
  const queryClient = useQueryClient()
  const toast = useToast()
  return useMutation({
    mutationFn: ({ advanceNo, remarks }: { advanceNo: string; remarks?: string }) =>
      confirmAdvanceReceipt(advanceNo, remarks ?? ''),
    onSuccess: (_result, { advanceNo }) => {
      for (const queryKey of ADVANCE_RECEIPT_QUERY_KEYS) void queryClient.invalidateQueries({ queryKey: [...queryKey] })
      toast.success(`${advanceNo}: payment receipt confirmed. You can now settle it under Advance Settlement.`, 'Payment received')
    },
    onError: (error) =>
      toast.error(error instanceof Error ? error.message : 'Business Central did not record the confirmation.', 'Not confirmed'),
  })
}
