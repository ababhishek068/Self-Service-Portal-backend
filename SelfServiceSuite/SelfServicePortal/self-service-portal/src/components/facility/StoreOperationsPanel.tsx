import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useEffect, useState } from 'react'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { Select } from '@/components/ui/select'
import { useAuth } from '@/hooks/useAuth'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import {
  downloadStoreBorrowingForm,
  downloadStoreIssueVoucher,
  getLocalPurchaseProjects,
  getStoreBorrowingFormUrl,
  getStoreRequisitionOptions,
  getStoreRequisitionProcess,
  updateStoreRequisitionProcess,
} from '@/api/endpoints/requestEndpoint'
import { StoreBorrowingFormViewer } from '@/components/facility/StoreBorrowingFormViewer'
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

function requesterDecision(request: PortalRequest) {
  const raw = text(request.payload?.RequesterDecision ?? request.payload?.Requester_Decision).toLowerCase()
  if (raw.includes('declin')) return 'DECLINED'
  if (raw.includes('accept')) return 'ACCEPTED'
  return ''
}

/** What the requester does next — the same steps as the BC Store Requisition card. */
function requesterStatusText(stage: string, declined: boolean, lprPath: boolean, givNo: string) {
  if (declined) return 'You declined the offered item. The storekeeper can offer another item, or close the request.'
  switch (stage) {
    case 'PREPARED':
      return 'The store has prepared an item for you. Waiting for the store manager to accept it.'
    case 'ACCEPTED':
      return 'The store offered an item. Open the Item Borrowing Form and check it, then accept or decline the item. No voucher is created until you accept.'
    case 'TRANSIT':
      return `Goods issue voucher ${givNo || '(GIV)'} is with the storekeeper. Status is In Transit. Confirm receipt when you have the item.`
    case 'RECEIVED':
      return 'You confirmed receipt of this item.'
    default:
      return lprPath
        ? 'The item is not in stock, so the store started a local purchase (LPR). You accept the item after it is received into the store.'
        : 'The store is preparing the item for your request.'
  }
}

function issueStageLabel(stage: string) {
  switch (stage) {
    case 'PREPARED':
      return 'Prepared by store — waiting for the store manager'
    case 'ACCEPTED':
      return 'Store manager accepted the offered item — waiting for the requester to accept the borrowing form'
    case 'TRANSIT':
      return 'In transit — goods issue voucher created; waiting for the requester to confirm receipt'
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
  const bcStage = issueStage(request)
  // The browser-only receipt flag covers older BC apps without ConfirmPortalStoreReceipt.
  // It never hides an earlier BC stage (e.g. Accept Item still to do).
  const legacyIssued = bcStage === '' && (issued || status === 'posted')
  const stageHandOff =
    receiptConfirmed && (bcStage === 'TRANSIT' || legacyIssued)
      ? 'RECEIVED'
      : bcStage || (issued ? 'TRANSIT' : '')
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
    /\b(procurement|proc|purchase|purchasing|buyer)\b/.test(assignment)
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  // Local Purchase store actions (BC recording) appear only once BC has the LPR portal methods.
  const localPurchase = useLocalPurchaseAccess()
  // Meeting 18 Oct: project first (blank = non-project); BC then assigns the procurement officer.
  const [lprProjectNo, setLprProjectNo] = useState('')
  // Start Local Purchase (LPR) prompts on the BC card: source, project, then the officer.
  const [lprSource, setLprSource] = useState<'LOCAL' | 'FOREIGN'>('LOCAL')
  const [lprOfficer, setLprOfficer] = useState<'' | 'PROCUREMENT' | 'PROJECT'>('')
  const officersQuery = useQuery({
    queryKey: ['store-requisition', 'options'],
    queryFn: getStoreRequisitionOptions,
    enabled: storeManager && localPurchase.enabled,
    staleTime: 5 * 60 * 1000,
    retry: false,
  })
  const lprOfficers = officersQuery.data?.lprOfficers ?? null
  const [borrowingFormUrl, setBorrowingFormUrl] = useState<string | null>(null)
  const [borrowingFormLoading, setBorrowingFormLoading] = useState(false)
  // Free the PDF blob when the viewer closes or the panel unmounts.
  useEffect(
    () => () => {
      if (borrowingFormUrl) URL.revokeObjectURL(borrowingFormUrl)
    },
    [borrowingFormUrl],
  )
  const processQuery = useQuery({
    queryKey: ['store-process', request.id],
    queryFn: () => getStoreRequisitionProcess(request.id),
    enabled: approved && canViewProcess && !assetRequest,
  })
  const mutation = useMutation({
    mutationFn: (actionCode: string) =>
      actionCode === 'START_LPR'
        ? updateStoreRequisitionProcess(request.id, actionCode, lprProjectNo, {
            procurementSource: lprSource,
            officerType: lprOfficer,
          })
        : updateStoreRequisitionProcess(request.id, actionCode),
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
  const atLprRequested = stage === 'LPR_REQUESTED'
  const stockReady = stockCheck?.allAvailable === true
  const needsBcPrep = stockCheck?.needsBcPrep === true
  const stockBlocked = stockCheck?.allAvailable === false && !needsBcPrep
  const prepHints = stockCheck?.prepHints?.length ? stockCheck.prepHints : DEFAULT_PREP_HINTS
  const canStartLpr = localPurchase.enabled && atLprRequested && storeManager && !processQuery.isError

  const requestNo = request.requestNo
  const requesterId = text(request.payload?.RequesterID ?? request.payload?.UserID ?? request.payload?.User_ID)
  const startLprOfficerKind = lprOfficer || (lprProjectNo ? 'PROJECT' : 'PROCUREMENT')
  const startLprOfficerLabel =
    startLprOfficerKind === 'PROJECT' ? 'the Project Procurement Officer' : 'the Procurement Officer'
  const startLprOfficerId =
    startLprOfficerKind === 'PROJECT' ? lprOfficers?.projectProcurementOfficer : lprOfficers?.procurementOfficer
  const givNo = text(request.payload?.StoreIssueNo ?? request.payload?.Store_Issue_No)
  const storeName = text(request.payload?.StoreName ?? request.payload?.StoreCode ?? request.payload?.IssuingStore)

  const run = async (actionCode: string, title: string, message: string) => {
    const yes = await confirm({ title, message, confirmLabel: title })
    if (!yes) return false
    try {
      const data = await mutation.mutateAsync(actionCode)
      if (actionCode === 'CONFIRM_RECEIPT') {
        window.localStorage.setItem(receiptStorageKey(request.requestNo), 'received')
        setReceiptConfirmed(true)
      }
      const issuedGiv = text(data.request?.payload?.StoreIssueNo ?? data.request?.payload?.Store_Issue_No) || givNo
      const createdLpr = text((data.process?.links as Record<string, unknown> | undefined)?.lprNo)
      toast.success(
        actionCode === 'PREPARE_ISSUE'
          ? 'Submitted to the store manager. Stock has not moved yet.'
          : actionCode === 'ACCEPT_ISSUE'
            ? `Store requisition ${requestNo} accepted. The requester must accept the borrowing form before the goods issue voucher is created.`
            : actionCode === 'ACCEPT_ITEM'
              ? `Accepted. Goods issue voucher ${issuedGiv || '(GIV)'} is with the storekeeper for requisition ${requestNo}. Status is In Transit. Confirm receipt when you have the item.`
              : actionCode === 'DECLINE_ITEM'
                ? `Declined. Store requisition ${requestNo} is back with the storekeeper. They can offer another item, or close the request.`
                : actionCode === 'CONFIRM_RECEIPT'
                  ? `Store requisition ${requestNo} marked as received.`
                  : actionCode === 'ISSUE_AFTER_LPR'
                    ? 'Issued after LPR receive — the goods issue voucher is posted to the requester.'
                    : actionCode === 'REQUEST_FOR_LPR'
                      ? `Store requisition ${requestNo} is with the Store Manager for Local Purchase. Requester: ${requesterId || 'the employee'}. Store Manager: open this request and choose Start Local Purchase (LPR).`
                      : actionCode === 'START_LPR'
                        ? `Local Purchase Requisition ${createdLpr || '(LPR)'} created for store requisition ${requestNo}${requesterId ? ` (employee ${requesterId})` : ''}. Assigned procurement officer ${startLprOfficerId || startLprOfficerLabel} prepares it first. Project ${lprProjectNo || '(non-project)'}. Then ${lprOfficers?.operationsManager ? `Operations Manager ${lprOfficers.operationsManager}` : 'the Operations Manager'} approves, then FAD.`
                        : 'Linked Purchase Request created from this store requisition.',
      )
      return true
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Action failed', title)
      return false
    }
  }

  const openBorrowingForm = () => {
    if (borrowingFormLoading) return
    setBorrowingFormLoading(true)
    void getStoreBorrowingFormUrl(request.id)
      .then(setBorrowingFormUrl)
      .catch((error: unknown) => {
        toast.error(error instanceof Error ? error.message : 'Could not open the Item Borrowing Form')
      })
      .finally(() => setBorrowingFormLoading(false))
  }

  const downloadBorrowingForm = () => {
    void downloadStoreBorrowingForm(request.id, requestNo).catch((error: unknown) => {
      toast.error(error instanceof Error ? error.message : 'Could not download the Item Borrowing Form')
    })
  }

  const downloadGiv = () => {
    void downloadStoreIssueVoucher(request.id, givNo || requestNo).catch((error: unknown) => {
      toast.error(error instanceof Error ? error.message : 'Could not download the Store Issuance Voucher (GIV)')
    })
  }

  const acceptItem = async () => {
    const accepted = await run(
      'ACCEPT_ITEM',
      'Accept Item',
      `Accept the item on the borrowing form for store requisition ${requestNo}? The storekeeper will receive the goods issue voucher.`,
    )
    if (accepted) setBorrowingFormUrl(null)
  }

  const declineItem = async () => {
    const declined = await run(
      'DECLINE_ITEM',
      'Decline Item',
      `Decline the offered item on store requisition ${requestNo}? No voucher will be created.`,
    )
    if (declined) setBorrowingFormUrl(null)
  }

  const awaitingRequester = stageHandOff === 'ACCEPTED'
  const requesterDeclined = requesterDecision(request) === 'DECLINED' && stageHandOff === ''
  const lprPath = /lpr/i.test(text(request.payload?.IssueStage ?? request.payload?.Issue_Stage))

  return (
    <section className="rounded-lg border border-teal-200 bg-teal-50/80 p-4 text-sm text-slate-800">
      <p className="font-semibold text-[var(--portal-navy)]">Store status</p>
      {requesterHandoff ? (
        <p className="mt-1 text-slate-600">
          {requesterStatusText(stageHandOff, requesterDeclined, lprPath, givNo)}
        </p>
      ) : null}
      {requesterHandoff && awaitingRequester ? (
        <div className="mt-3 flex flex-wrap items-center gap-2">
          <Button type="button" variant="outline" disabled={borrowingFormLoading} onClick={openBorrowingForm}>
            {borrowingFormLoading ? 'Opening…' : 'Item Borrowing Form'}
          </Button>
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending || borrowingFormLoading}
            title="Opens the Item Borrowing Form first, then asks you to accept."
            onClick={openBorrowingForm}
          >
            Accept Item
          </Button>
          <Button type="button" variant="outline" disabled={mutation.isPending} onClick={() => void declineItem()}>
            Decline Item
          </Button>
        </div>
      ) : null}
      {requesterHandoff && stageHandOff === 'TRANSIT' ? (
        <div className="mt-3 flex flex-wrap items-center gap-2">
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending}
            onClick={() =>
              void run(
                'CONFIRM_RECEIPT',
                'Confirm Receipt',
                `Confirm that you have received the item on store requisition ${requestNo}${givNo ? ` (GIV ${givNo})` : ''}.`,
              )
            }
          >
            Confirm Receipt
          </Button>
          <Button type="button" variant="outline" disabled={borrowingFormLoading} onClick={openBorrowingForm}>
            Item Borrowing Form
          </Button>
          {givNo ? (
            <Button type="button" variant="outline" onClick={downloadGiv}>
              Store Issuance Voucher (GIV)
            </Button>
          ) : null}
        </div>
      ) : null}
      {requesterHandoff && stageHandOff === 'RECEIVED' ? (
        <div className="mt-3 flex flex-wrap items-center gap-2">
          <Button type="button" variant="outline" onClick={downloadBorrowingForm}>
            Item Borrowing Form
          </Button>
          {givNo ? (
            <Button type="button" variant="outline" onClick={downloadGiv}>
              Store Issuance Voucher (GIV)
            </Button>
          ) : null}
        </div>
      ) : null}
      {borrowingFormUrl ? (
        <StoreBorrowingFormViewer
          url={borrowingFormUrl}
          requestNo={requestNo}
          onClose={() => setBorrowingFormUrl(null)}
          actions={
            requesterHandoff && awaitingRequester ? (
              <>
                <Button type="button" variant="outline" className="rounded-full" onClick={() => setBorrowingFormUrl(null)}>
                  Close
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  className="rounded-full"
                  disabled={mutation.isPending}
                  onClick={() => void declineItem()}
                >
                  Decline Item
                </Button>
                <Button
                  type="button"
                  variant="gradient"
                  className="rounded-full"
                  disabled={mutation.isPending}
                  onClick={() => void acceptItem()}
                >
                  {mutation.isPending ? 'Saving…' : 'Accept Item'}
                </Button>
              </>
            ) : (
              <>
                <Button type="button" variant="outline" className="rounded-full" onClick={downloadBorrowingForm}>
                  Download
                </Button>
                <Button type="button" className="rounded-full" onClick={() => setBorrowingFormUrl(null)}>
                  Close
                </Button>
              </>
            )
          }
        />
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
            variant={stockBlocked || localPurchase.enabled ? 'gradient' : 'outline'}
            // No item / no similar item in store needs no item mapping (BC Request for LPR).
            disabled={mutation.isPending || (!localPurchase.enabled && needsBcPrep)}
            title={
              !localPurchase.enabled && needsBcPrep
                ? 'Finish Business Central prep (Issuing Store + item mapping) first.'
                : localPurchase.enabled
                  ? 'No item / no similar item in store: send this request to the Store Manager with the employee details.'
                  : undefined
            }
            onClick={() =>
              localPurchase.enabled
                ? void run(
                    'REQUEST_FOR_LPR',
                    'Request for LPR',
                    `No stock / no similar item for store requisition ${requestNo}? Send Request for LPR to the Store Manager with the employee details?`,
                  )
                : void run(
                    'STOCK_UNAVAILABLE',
                    'Create Purchase Request',
                    'Confirm stock is unavailable and create the linked Purchase Request.',
                  )
            }
          >
            {localPurchase.enabled ? 'Request for LPR' : 'Stock not available — Purchase Request'}
          </Button>
        </div>
      ) : null}
      {atLprRequested && localPurchase.enabled && !storeManager ? (
        <p className="mt-2 text-xs text-slate-600">
          Store requisition {requestNo} is with the Store Manager for Local Purchase
          {requesterId ? ` (requester ${requesterId})` : ''}. Waiting for the Store Manager to choose Start Local Purchase (LPR).
        </p>
      ) : null}
      {canStartLpr ? (
        <div className="mt-3 space-y-2">
          <p className="text-xs text-slate-700">
            Store requisition {requestNo} is with you for Local Purchase{requesterId ? ` (requester ${requesterId})` : ''}.
          </p>
          <div className="max-w-md space-y-1">
            <label htmlFor={`lpr-source-${request.id}`} className="text-xs font-medium text-slate-700">
              Request procurement from which source?
            </label>
            <Select
              id={`lpr-source-${request.id}`}
              options={[
                { value: 'LOCAL', label: 'Local (Inhouse Local)' },
                { value: 'FOREIGN', label: 'Foreign (Inhouse / Salable Foreign)' },
              ]}
              value={lprSource}
              onChange={(event) => setLprSource(event.target.value === 'FOREIGN' ? 'FOREIGN' : 'LOCAL')}
              disabled={mutation.isPending}
            />
          </div>
          <LprProjectPicker
            id={`lpr-project-${request.id}`}
            value={lprProjectNo}
            onChange={(value) => {
              setLprProjectNo(value)
              // The officer follows the project again unless the manager picks one.
              setLprOfficer('')
            }}
            disabled={mutation.isPending}
          />
          <div className="max-w-md space-y-1">
            <label htmlFor={`lpr-officer-${request.id}`} className="text-xs font-medium text-slate-700">
              Procurement officer
            </label>
            <Select
              id={`lpr-officer-${request.id}`}
              options={(lprProjectNo ? (['PROJECT', 'PROCUREMENT'] as const) : (['PROCUREMENT'] as const)).map((kind) => ({
                value: kind,
                label:
                  kind === 'PROJECT'
                    ? `Project Procurement Officer${lprOfficers?.projectProcurementOfficer ? ` (${lprOfficers.projectProcurementOfficer})` : ''}`
                    : `Procurement Officer${lprOfficers?.procurementOfficer ? ` (${lprOfficers.procurementOfficer})` : ''}`,
              }))}
              value={startLprOfficerKind}
              onChange={(event) => setLprOfficer(event.target.value === 'PROJECT' ? 'PROJECT' : 'PROCUREMENT')}
              disabled={mutation.isPending}
            />
            <p className="text-xs text-slate-500">
              A project purchase defaults to the Project Procurement Officer. A project procurement officer needs a project.
            </p>
          </div>
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending}
            onClick={() =>
              void run(
                'START_LPR',
                'Start Local Purchase (LPR)',
                `Create the ${lprSource === 'FOREIGN' ? 'Foreign' : 'Local'} Purchase Requisition (LPR) for store requisition ${requestNo}` +
                  `${lprProjectNo ? ` — project ${lprProjectNo}` : ' — non-project'}` +
                  `, assigned to ${startLprOfficerId ? `${startLprOfficerLabel} ${startLprOfficerId}` : startLprOfficerLabel}?` +
                  ' The officer prepares it first, then the Operations Manager and FAD approve it on the LPR (not Requests to Approve).',
              )
            }
          >
            Start Local Purchase (LPR)
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
                'Accept Item (Store Manager)',
                `Accept the item offered on store requisition ${requestNo}${storeName ? ` from store ${storeName}` : ''}? The requester will get the borrowing form and can accept or decline it. No voucher is created yet.`,
              )
            }
          >
            Accept Item (Store Manager)
          </Button>
        </div>
      ) : null}
      {stageHandOff === 'PREPARED' && !storeManager && !requesterHandoff ? (
        <p className="mt-2 text-xs text-slate-600">Waiting for the store manager to accept the offered item.</p>
      ) : null}
      {atStockCheck && stockReady ? (
        <p className="mt-2 text-xs text-teal-800">All requested quantities are available at the issuing store.</p>
      ) : null}
      {atStockCheck && !canManageStock ? (
        <p className="mt-2 text-xs text-slate-600">Waiting for Operations/Store to record the stock decision.</p>
      ) : null}
      {atProcurement && !localPurchase.enabled ? (
        <p className="mt-2 text-xs text-slate-600">
          Purchase is continuing in the portal / Business Central{lprNo ? ` (${lprNo})` : ''}. After the
          GRV is posted into the issuing store, reopen this requisition — stage returns to stock check
          for GIV.
        </p>
      ) : null}
      {atProcurement && localPurchase.enabled ? (
        <p className="mt-2 text-xs text-slate-600">
          Issue Stage: LPR Started{lprNo ? ` (${lprNo})` : ''}. Local Purchase continues: Procurement Officer submits →
          Operations Manager → FAD → RFQ (Operations Manager) → quotes → evaluation → FAD final supplier → PO
          (Operations Manager, FAD) → Store Keeper receives (GRN). After the GRN is posted into the issuing store, use
          Issue after LPR receive.
        </p>
      ) : null}
      {atProcurement && localPurchase.enabled && canManageStock && !processQuery.isError ? (
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

/** Project for the new LPR, chosen before the procurement officer (blank = non-project). */
function LprProjectPicker({
  id,
  value,
  onChange,
  disabled,
}: {
  id: string
  value: string
  onChange: (value: string) => void
  disabled?: boolean
}) {
  const projectsQuery = useQuery({
    queryKey: ['local-purchase', 'projects'],
    queryFn: getLocalPurchaseProjects,
    retry: false,
    staleTime: 5 * 60_000,
  })
  const options = [
    { value: '', label: 'Non-project purchase (Procurement Officer)' },
    ...(projectsQuery.data?.projects ?? []).map((project) => ({
      value: project.no,
      label: project.description ? `${project.no} — ${project.description}` : project.no,
    })),
  ]
  return (
    <div className="mt-3 max-w-md space-y-1">
      <label htmlFor={id} className="text-xs font-medium text-slate-700">
        Project for the LPR (project purchases go to the Project Procurement Officer)
      </label>
      <Select
        id={id}
        options={options}
        value={value}
        placeholder={projectsQuery.isLoading ? 'Loading projects…' : 'Non-project purchase'}
        onChange={(event) => onChange(event.target.value)}
        disabled={disabled || projectsQuery.isLoading}
      />
      {projectsQuery.isError ? (
        <p className="text-xs text-red-700">Could not load projects from Business Central.</p>
      ) : null}
    </div>
  )
}
