import { useQuery } from '@tanstack/react-query'
import { ProcurementProcessBanner } from '@/components/facility/ProcurementProcessBanner'
import { getLocalPurchaseState } from '@/api/endpoints/requestEndpoint'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import {
  ABH_PURCHASE_REQUEST_PROCESS_FLOWS,
  ABH_PURCHASE_REQUEST_PROCESS_NOTE,
  ABH_PURCHASE_REQUEST_PROCESS_TITLE,
  ABH_STORE_REQUISITION_PROCESS_FLOWS,
  ABH_STORE_REQUISITION_PROCESS_TITLE,
  purchaseRequisitionProcess,
  storeRequisitionProcess,
} from '@/data/procurementProcessFlows'
import { localPurchaseStage, storeRequisitionStage } from '@/data/processStages'
import type { PortalRequest } from '@/types/erp.types'

/** Store Requisition Process; on an open requisition it tracks the stage (status + BC Issue Stage). */
export function StoreRequisitionProcessBanner({ request }: { request: PortalRequest | null }) {
  return (
    <ProcurementProcessBanner
      title={ABH_STORE_REQUISITION_PROCESS_TITLE}
      steps={storeRequisitionProcess}
      flows={[...ABH_STORE_REQUISITION_PROCESS_FLOWS]}
      stage={request ? storeRequisitionStage(request) : undefined}
    />
  )
}

/**
 * Local Purchase Process; on an open LPR it tracks the stage from the BC chain (LPR → RFQ → PO),
 * the same query as the Local Purchase panel, so the chain loads once.
 */
export function LocalPurchaseProcessBanner({ request }: { request: PortalRequest | null }) {
  const access = useLocalPurchaseAccess()
  const stateQuery = useQuery({
    queryKey: ['local-purchase', request?.id],
    queryFn: () => getLocalPurchaseState(String(request?.id)),
    enabled: access.enabled && Boolean(request?.id),
    retry: false,
  })
  const loading = access.isLoading || stateQuery.isLoading
  return (
    <ProcurementProcessBanner
      title={ABH_PURCHASE_REQUEST_PROCESS_TITLE}
      steps={purchaseRequisitionProcess}
      note={ABH_PURCHASE_REQUEST_PROCESS_NOTE}
      flows={[...ABH_PURCHASE_REQUEST_PROCESS_FLOWS]}
      stage={request && !loading ? localPurchaseStage(request, stateQuery.data) : undefined}
    />
  )
}
