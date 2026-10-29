import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { getLocalPurchaseState, runLocalPurchaseAction } from '@/api/endpoints/requestEndpoint'
import { useToast } from '@/components/feedback/ToastProvider'
import { BcLinesTable } from '@/components/facility/BcLinesTable'
import { text } from '@/components/facility/bcCardValues'
import { PURCHASE_LINE_COLUMNS, type PurchaseLine } from '@/components/facility/bcPurchaseLines'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import type { PortalRequest } from '@/types/erp.types'

/**
 * LPR lines as the BC Purchase Requisition Subform: the same columns, read-only for everyone, and
 * New Line / Edit / Delete Line for the assigned Procurement Officer while the card is editable.
 */
export function LprLinesSubform({ request }: { request: PortalRequest }) {
  const toast = useToast()
  const queryClient = useQueryClient()
  const access = useLocalPurchaseAccess()
  const stateQuery = useQuery({
    queryKey: ['local-purchase', request.id],
    queryFn: () => getLocalPurchaseState(request.id),
    enabled: access.enabled,
    retry: false,
  })
  const mutation = useMutation({
    mutationFn: (body: Parameters<typeof runLocalPurchaseAction>[1]) => runLocalPurchaseAction(request.id, body),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['local-purchase', request.id] })
      await queryClient.invalidateQueries({ queryKey: ['facility', 'purchase-requisition'] })
    },
  })

  const lines = Array.isArray(request.payload?.lines) ? (request.payload.lines as PurchaseLine[]) : []
  const lprNo = text(stateQuery.data?.chain.lpr?.no)
  const editable =
    stateQuery.data?.cardEditable === true && lprNo.toUpperCase() === request.requestNo.trim().toUpperCase()
  // While the LPR is approved, its lines carry the request only; the Procurement Officer fills the
  // item, category, VAT, prices and supplier after approval (BC lineDetailsVisible).
  const detailsVisible = text(stateQuery.data?.chain.lpr?.lineDetailsVisible).toLowerCase() !== 'false'
  const columns = detailsVisible ? PURCHASE_LINE_COLUMNS : PURCHASE_LINE_COLUMNS.filter((column) => !column.detail)

  const run = async (actionCode: string, payload: Record<string, unknown>, success: string) => {
    try {
      await mutation.mutateAsync({ actionCode, documentNo: lprNo, payload })
      toast.success(success)
      return true
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not save the line', 'LPR line')
      return false
    }
  }

  return (
    <BcLinesTable
      title="Purchase Requisition Subform"
      lines={lines}
      columns={columns}
      showTotal={detailsVisible}
      docNo={lprNo}
      editable={editable}
      busy={mutation.isPending}
      onSave={(isNew, payload) =>
        run(isNew ? 'ADD_LPR_LINE' : 'UPDATE_LPR_LINE', payload, isNew ? `Line added to ${lprNo}.` : `Line saved on ${lprNo}.`)
      }
      onDelete={(line) => run('DELETE_LPR_LINE', { lineNo: Number(line.lineNo) }, `Line deleted from ${lprNo}.`)}
    />
  )
}
