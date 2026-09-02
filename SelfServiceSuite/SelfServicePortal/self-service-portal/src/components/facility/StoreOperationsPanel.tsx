import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { useAuth } from '@/hooks/useAuth'
import {
  getStoreRequisitionProcess,
  updateStoreRequisitionProcess,
} from '@/api/endpoints/requestEndpoint'
import type { PortalRequest } from '@/types/erp.types'

function text(value: unknown) {
  return String(value ?? '').trim()
}

type StoreStockLineCheck = {
  itemNo?: string
  itemName?: string
  requested?: number
  available?: number
  sufficient?: boolean
}

type StoreStockCheck = {
  issuingStore?: string
  allAvailable?: boolean
  lines?: StoreStockLineCheck[]
}

function isAssetRequest(request: PortalRequest) {
  const payload = request.payload ?? {}
  const value = text(
    payload.StoreRequisitionType ??
      payload.Store_Requisition_Type ??
      payload.requestType,
  ).toLowerCase()
  return value === '1' || value === 'asset' || value === 'minor asset'
}

function stockCheckFromProcess(data: Record<string, unknown> | undefined): StoreStockCheck | null {
  const raw = data?.stockCheck
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return null
  return raw as StoreStockCheck
}

export function StoreOperationsPanel({ request }: { request: PortalRequest }) {
  const { employee } = useAuth()
  const status = request.status.trim().toLowerCase()
  const approved = ['approved', 'released', 'posted'].includes(status)
  const assetRequest = isAssetRequest(request)
  const assignment = [employee?.jobTitle, employee?.departmentCode, employee?.departmentName]
    .map((value) => String(value ?? '').trim().toLowerCase())
    .join(' ')
  const canManageStock =
    (employee?.roles ?? []).some((role) => ['operations', 'store'].includes(String(role).toLowerCase())) ||
    /\b(operations?|ops|store|storekeeper)\b/.test(assignment)
  const canViewProcess =
    canManageStock ||
    Boolean(employee?.roles?.includes('procurement')) ||
    /\b(procurement|proc)\b/.test(assignment)
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const processQuery = useQuery({
    queryKey: ['store-process', request.id],
    queryFn: () => getStoreRequisitionProcess(request.id),
    enabled: approved && canViewProcess && !assetRequest,
  })
  const mutation = useMutation({
    mutationFn: (actionCode: string) => updateStoreRequisitionProcess(request.id, actionCode),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['store-process', request.id] })
      await queryClient.invalidateQueries({ queryKey: ['facility', 'store-requisition'] })
    },
  })

  if (!approved) return null
  if (assetRequest) {
    return (
      <section className="rounded-lg border border-teal-200 bg-teal-50/80 p-4 text-sm text-slate-700">
        Facilities completes the asset assignment and handover in Business Central.
      </section>
    )
  }
  if (!canViewProcess) return null

  const stage = text(processQuery.data?.stageCode).toUpperCase()
  const label = text(processQuery.data?.stageLabel) || 'Loading process…'
  const owner = text(processQuery.data?.ownerRole)
  const stock = text(processQuery.data?.stockDecision)
  const lprNo = text((processQuery.data?.links as Record<string, unknown> | undefined)?.lprNo)
  const ginNo = text((processQuery.data?.links as Record<string, unknown> | undefined)?.ginNo)
  const stockCheck = stockCheckFromProcess(processQuery.data)
  const atStockCheck = stage === 'STOCK_CHECK'
  const atProcurement = stage === 'PROCUREMENT_REQUEST'
  const stockReady = stockCheck?.allAvailable === true
  const stockBlocked = stockCheck?.allAvailable === false

  const run = async (actionCode: string, title: string, message: string) => {
    const yes = await confirm({ title, message, confirmLabel: title })
    if (!yes) return
    try {
      await mutation.mutateAsync(actionCode)
      toast.success(
        actionCode === 'STOCK_AVAILABLE'
          ? 'GIN issued from this store requisition.'
          : 'Linked Purchase Request created from this store requisition.',
      )
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Action failed', title)
    }
  }

  return (
    <section className="rounded-lg border border-teal-200 bg-teal-50/80 p-4 text-sm text-slate-800">
      <p className="font-semibold text-[var(--portal-navy)]">Store status</p>
      <p className="mt-1 text-slate-600">Operations/Store records stock availability after final approval.</p>
      {processQuery.isError ? (
        <p className="mt-2 text-red-700">
          {processQuery.error instanceof Error ? processQuery.error.message : 'Could not load store process stage.'}
        </p>
      ) : (
        <p className="mt-2">
          Stage: <strong>{label}</strong>
          {owner ? ` · Owner: ${owner}` : ''}
          {stock ? ` · Stock: ${stock}` : ''}
          {ginNo ? ` · GIN: ${ginNo}` : ''}
          {lprNo ? ` · Purchase Request: ${lprNo}` : ''}
        </p>
      )}
      {atStockCheck && stockCheck?.lines?.length ? (
        <div className="mt-3 overflow-x-auto rounded-md border border-teal-100 bg-white/70">
          <table className="min-w-full text-xs">
            <thead className="bg-teal-50 text-left text-slate-600">
              <tr>
                <th className="px-3 py-2 font-medium">Item</th>
                <th className="px-3 py-2 font-medium">Requested</th>
                <th className="px-3 py-2 font-medium">
                  Available at {stockCheck.issuingStore || 'issuing store'}
                </th>
              </tr>
            </thead>
            <tbody>
              {stockCheck.lines.map((line) => {
                const sufficient = line.sufficient === true
                return (
                  <tr key={`${line.itemNo}-${line.itemName}`} className="border-t border-teal-50">
                    <td className="px-3 py-2">{line.itemName || line.itemNo || '—'}</td>
                    <td className="px-3 py-2">{line.requested ?? '—'}</td>
                    <td className={`px-3 py-2 font-medium ${sufficient ? 'text-teal-800' : 'text-red-700'}`}>
                      {line.available ?? 0}
                      {!sufficient ? ' · insufficient' : ''}
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      ) : null}
      {atStockCheck && stockBlocked ? (
        <p className="mt-2 text-xs font-medium text-red-700">
          Stock is not available at {stockCheck?.issuingStore || 'the issuing store'}. Use Purchase Request — do not
          issue GIN until stock is received into that location.
        </p>
      ) : null}
      {atStockCheck && canManageStock && !processQuery.isError ? (
        <div className="mt-3 flex flex-wrap gap-2">
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending || stockBlocked}
            title={
              stockBlocked
                ? 'Stock is not available at the issuing store for one or more items.'
                : undefined
            }
            onClick={() =>
              void run(
                'STOCK_AVAILABLE',
                'Issue GIN',
                'Confirm these items are available in the issuing store and issue them by GIN.',
              )
            }
          >
            Stock available — GIN &amp; Issue
          </Button>
          <Button
            type="button"
            variant={stockBlocked ? 'gradient' : 'outline'}
            disabled={mutation.isPending}
            onClick={() =>
              void run(
                'STOCK_UNAVAILABLE',
                'Create Purchase Request',
                'Confirm stock is unavailable and create the linked Purchase Request.',
              )
            }
          >
            Stock not available — Purchase Request
          </Button>
        </div>
      ) : null}
      {atStockCheck && stockReady ? (
        <p className="mt-2 text-xs text-teal-800">All requested quantities are available at the issuing store.</p>
      ) : null}
      {atStockCheck && !canManageStock ? (
        <p className="mt-2 text-xs text-slate-600">Waiting for Operations/Store to record the stock decision.</p>
      ) : null}
      {atProcurement ? (
        <p className="mt-2 text-xs text-slate-600">
          Procurement is continuing in Business Central{lprNo ? ` (${lprNo})` : ''}.
        </p>
      ) : null}
      {stage === 'COMPLETED' ? (
        <p className="mt-2 text-teal-800">Stock updated and requisition closed.</p>
      ) : null}
    </section>
  )
}
