import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { useAuth } from '@/hooks/useAuth'
import {
  downloadStoreBorrowingForm,
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
  needsBcMapping?: boolean
}

type StoreStockCheck = {
  issuingStore?: string
  allAvailable?: boolean
  needsBcPrep?: boolean
  prepHints?: string[]
  lines?: StoreStockLineCheck[]
}

const DEFAULT_PREP_HINTS = [
  'Set Issuing Store on the Store Requisition header.',
  'Replace each PORTAL-* line with a real Item No.',
  'Confirm on-hand quantity at that location.',
]

function realBcItemNo(itemNo: string | undefined) {
  const code = String(itemNo ?? '').trim()
  return Boolean(code) && !/^PORTAL-/i.test(code)
}

function issueStage(request: PortalRequest) {
  const raw = text(
    request.payload?.IssueStage ?? request.payload?.Issue_Stage ?? '',
  ).toLowerCase()
  if (!raw || raw === '0') return ''
  if (raw.includes('prepared') || raw === '1') return 'PREPARED'
  if (raw.includes('accepted') || raw === '2') return 'ACCEPTED'
  if (raw.includes('transit') || raw === '3') return 'TRANSIT'
  if (raw.includes('received') || raw === '4') return 'RECEIVED'
  return ''
}

function receiptStorageKey(requestNo: string) {
  return `ssp.storeReceipt.${requestNo}`
}

function linesHaveBeenIssued(request: PortalRequest) {
  const lines = request.payload?.lines
  return Array.isArray(lines) && lines.some((line) => Number((line as { quantityIssued?: unknown }).quantityIssued ?? 0) > 0)
}

function issueStageLabel(stage: string) {
  switch (stage) {
    case 'PREPARED':
      return 'Prepared by store — waiting for the store manager'
    case 'ACCEPTED':
      return 'Store manager accepted the offered item — waiting for the requester'
    case 'TRANSIT':
      return 'In transit — waiting for the requester to confirm receipt'
    case 'RECEIVED':
      return 'Received by the requester'
    default:
      return 'Approved — storekeeper can submit the issue'
  }
}

function userIsStoreManager(employee: ReturnType<typeof useAuth>['employee']) {
  const assignment = [employee?.jobTitle, employee?.departmentName, employee?.departmentCode, ...(employee?.roles ?? [])]
    .map((value) => String(value ?? '').trim().toLowerCase())
    .join(' ')
  return /\bstore\s*manager\b|\bstores\s*manager\b|\bmain\s*store\b|\bstoremanager\b/.test(assignment)
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
  const storeManager = userIsStoreManager(employee)
  const issued = linesHaveBeenIssued(request)
  const storedReceipt =
    typeof window !== 'undefined' && window.localStorage.getItem(receiptStorageKey(request.requestNo)) === 'received'
  const [receiptConfirmed, setReceiptConfirmed] = useState(storedReceipt)
  const stageHandOff = receiptConfirmed
    ? 'RECEIVED'
    : issueStage(request) || (issued ? 'TRANSIT' : '')
  const actorIds = [employee?.employeeNo, employee?.userID]
    .map((value) => text(value).toUpperCase())
    .filter(Boolean)
  const ownerIds = [
    request.makerEmployeeNo,
    request.payload?.EmployeeNo,
    request.payload?.Employee_No,
    request.payload?.UserID,
    request.payload?.User_ID,
    request.payload?.RequesterID,
    request.payload?.Requester_ID,
  ]
    .map((value) => text(value).toUpperCase())
    .filter(Boolean)
  const ownsRequest =
    ownerIds.length === 0 || ownerIds.some((owner) => actorIds.includes(owner))
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
    onSuccess: async (data) => {
      queryClient.setQueryData(['facility', 'store-requisition', 'detail', request.id], data.request)
      await queryClient.invalidateQueries({ queryKey: ['store-process', request.id] })
      await queryClient.invalidateQueries({
        queryKey: ['facility', 'store-requisition'],
        exact: true,
      })
    },
  })

  const requesterHandoff = approved && (ownsRequest || !canViewProcess)
  if (!approved) return null
  if (assetRequest) {
    return (
      <section className="rounded-lg border border-teal-200 bg-teal-50/80 p-4 text-sm text-slate-700">
        Facilities completes the asset assignment and handover in Business Central.
      </section>
    )
  }
  if (!canViewProcess && !requesterHandoff) return null

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
  const needsBcPrep = stockCheck?.needsBcPrep === true
  const stockBlocked = stockCheck?.allAvailable === false && !needsBcPrep
  const prepHints = stockCheck?.prepHints?.length ? stockCheck.prepHints : DEFAULT_PREP_HINTS

  const run = async (actionCode: string, title: string, message: string) => {
    const yes = await confirm({ title, message, confirmLabel: title })
    if (!yes) return
    try {
      await mutation.mutateAsync(actionCode)
      if (actionCode === 'CONFIRM_RECEIPT') {
        window.localStorage.setItem(receiptStorageKey(request.requestNo), 'received')
        setReceiptConfirmed(true)
      }
      toast.success(
        actionCode === 'PREPARE_ISSUE'
          ? 'Submitted to the store manager. Stock has not moved yet.'
          : actionCode === 'ACCEPT_ISSUE'
            ? 'Store manager accepted the issue. Goods are in transit.'
            : actionCode === 'ACCEPT_ITEM'
              ? 'Item accepted. The goods issue voucher is created and the request is in transit.'
              : actionCode === 'DECLINE_ITEM'
                ? 'Item declined. The storekeeper can offer another item.'
                : actionCode === 'CONFIRM_RECEIPT'
                  ? 'Receipt confirmed.'
                  : actionCode === 'ISSUE_AFTER_LPR'
                    ? 'Issued after LPR receive — the goods issue voucher is posted to the requester.'
                    : 'Purchase Requisition (LPR) created — Issue Stage: LPR Started. Next: FAD opens Pending LPR and uses Approve (FAD), not Requests to Approve.',
      )
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Action failed', title)
    }
  }

  return (
    <section className="rounded-lg border border-teal-200 bg-teal-50/80 p-4 text-sm text-slate-800">
      <p className="font-semibold text-[var(--portal-navy)]">Store status</p>
      <p className="mt-1 text-slate-600">
        Download the Item Borrowing Form, then confirm receipt.
      </p>
      {requesterHandoff && !receiptConfirmed ? (
        <div className="mt-3 flex flex-wrap items-center gap-2">
          <Button
            type="button"
            variant="outline"
            onClick={() => {
              void downloadStoreBorrowingForm(request.id, request.requestNo)
                .then(() => {
                  toast.success('Item Borrowing Form downloaded.')
                })
                .catch((error: unknown) => {
                  toast.error(error instanceof Error ? error.message : 'Could not download the Item Borrowing Form')
                })
            }}
          >
            Item Borrowing Form
          </Button>
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending}
            onClick={() =>
              void run(
                'CONFIRM_RECEIPT',
                'Confirm Receipt',
                'Confirm that you have received this store request.',
              )
            }
          >
            Confirm Receipt
          </Button>
        </div>
      ) : null}
      {requesterHandoff && receiptConfirmed ? (
        <div className="mt-3">
          <Button
            type="button"
            variant="outline"
            onClick={() => {
              void downloadStoreBorrowingForm(request.id, request.requestNo).catch((error: unknown) => {
                toast.error(error instanceof Error ? error.message : 'Could not download the Item Borrowing Form')
              })
            }}
          >
            Item Borrowing Form
          </Button>
        </div>
      ) : null}
      <p className="mt-2">
        Issue: <strong>{issueStageLabel(stageHandOff)}</strong>
        {text(request.payload?.StoreName ?? request.payload?.StoreCode)
          ? ` · Store: ${text(request.payload?.StoreName ?? request.payload?.StoreCode)}`
          : ''}
      </p>
      {processQuery.isError ? (
        <p className="mt-2 text-red-700">
          {processQuery.error instanceof Error ? processQuery.error.message : 'Could not load store process stage.'}
        </p>
      ) : canViewProcess ? (
        <p className="mt-2">
          Stage: <strong>{label}</strong>
          {owner ? ` · Owner: ${owner}` : ''}
          {stock ? ` · Stock: ${stock}` : ''}
          {ginNo ? ` · GIV: ${ginNo}` : ''}
          {lprNo ? ` · Purchase Request: ${lprNo}` : ''}
        </p>
      ) : null}
      {atStockCheck && needsBcPrep ? (
        <div className="mt-3 rounded-md border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-950">
          <p className="font-semibold">Business Central prep required before GIV</p>
          <ul className="mt-1 list-disc space-y-1 pl-4">
            {prepHints.map((hint) => (
              <li key={hint}>{hint}</li>
            ))}
          </ul>
        </div>
      ) : null}
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
                const needsMapping = line.needsBcMapping === true || !realBcItemNo(line.itemNo)
                return (
                  <tr key={`${line.itemNo}-${line.itemName}`} className="border-t border-teal-50">
                    <td className="px-3 py-2">
                      {line.itemName || line.itemNo || '—'}
                      {needsMapping ? (
                        <span className="ml-1 font-medium text-amber-800">(map in BC)</span>
                      ) : null}
                    </td>
                    <td className="px-3 py-2">{line.requested ?? '—'}</td>
                    <td
                      className={`px-3 py-2 font-medium ${
                        needsMapping ? 'text-amber-800' : sufficient ? 'text-teal-800' : 'text-red-700'
                      }`}
                    >
                      {needsMapping ? '—' : (line.available ?? 0)}
                      {!needsMapping && !sufficient ? ' · insufficient' : ''}
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
          issue GIV until a posted GRV receives stock into that location.
        </p>
      ) : null}
      {atStockCheck && stageHandOff === '' && canManageStock && !processQuery.isError ? (
        <div className="mt-3 flex flex-wrap gap-2">
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending || stockBlocked || needsBcPrep}
            title={
              needsBcPrep
                ? 'Finish Business Central prep (Issuing Store + item mapping) first.'
                : stockBlocked
                  ? 'Stock is not available at the issuing store for one or more items.'
                  : undefined
            }
            onClick={() =>
              void run(
                'PREPARE_ISSUE',
                'Submit to Store Manager',
                'Fill the remaining quantity and hand this issue to the store manager. Stock does not move yet.',
              )
            }
          >
            Submit to Store Manager
          </Button>
          <Button
            type="button"
            variant={stockBlocked ? 'gradient' : 'outline'}
            disabled={mutation.isPending || needsBcPrep}
            title={
              needsBcPrep
                ? 'Finish Business Central prep (Issuing Store + item mapping) first.'
                : undefined
            }
            onClick={() =>
              void run(
                'REQUEST_FOR_LPR',
                'Request for LPR',
                'Confirm stock is unavailable and create the linked Purchase Requisition (LPR). FAD approves it next with Approve (FAD).',
              )
            }
          >
            Request for LPR
          </Button>
        </div>
      ) : null}
      {stageHandOff === 'PREPARED' && storeManager ? (
        <div className="mt-3">
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending}
            onClick={() =>
              void run(
                'ACCEPT_ISSUE',
                'Accept and Issue',
                'Accept the item the storekeeper offered. The requester then accepts or declines the borrowing form.',
              )
            }
          >
            Accept and Issue
          </Button>
        </div>
      ) : null}
      {stageHandOff === 'PREPARED' && !storeManager ? (
        <p className="mt-2 text-xs text-slate-600">Waiting for the store manager to accept and issue.</p>
      ) : null}
      {atStockCheck && stockReady ? (
        <p className="mt-2 text-xs text-teal-800">All requested quantities are available at the issuing store.</p>
      ) : null}
      {atStockCheck && !canManageStock ? (
        <p className="mt-2 text-xs text-slate-600">Waiting for Operations/Store to record the stock decision.</p>
      ) : null}
      {atProcurement ? (
        <p className="mt-2 text-xs text-slate-600">
          Issue Stage: LPR Started{lprNo ? ` (${lprNo})` : ''}. Local Purchase continues: Approve (FAD) → Convert to
          RFQ → Vendor Quotes → Approve Winner (FAD Final) → Create PO → Approve Local PO → Post Receive. After the
          GRN is posted into the issuing store, use Issue after LPR receive.
        </p>
      ) : null}
      {atProcurement && canManageStock && !processQuery.isError ? (
        <div className="mt-3">
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending}
            onClick={() =>
              void run(
                'ISSUE_AFTER_LPR',
                'Issue after LPR receive',
                'Issue the goods received on the Local Purchase GRN to the requester (GIV).',
              )
            }
          >
            Issue after LPR receive
          </Button>
        </div>
      ) : null}
      {stage === 'COMPLETED' ? (
        <p className="mt-2 text-teal-800">GIV posted — inventory reduced and requisition closed.</p>
      ) : null}
    </section>
  )
}
