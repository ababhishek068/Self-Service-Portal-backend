import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useEffect, useState } from 'react'
import { Warehouse } from 'lucide-react'
import { Link } from 'react-router-dom'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { useAuth } from '@/hooks/useAuth'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import {
  downloadStoreBorrowingForm,
  downloadStoreIssueVoucher,
  getMyStoreRoles,
  getStoreBorrowingFormUrl,
  getStoreRequisitionOptions,
  getStoreRequisitionProcess,
  updateStoreRequisitionProcess,
} from '@/api/endpoints/requestEndpoint'
import { StoreBorrowingFormViewer } from '@/components/facility/StoreBorrowingFormViewer'
import { StoreKeeperOfferSection } from '@/components/facility/StoreKeeperOfferSection'
import { StatusNotice } from '@/components/feedback/StatusNotice'
import { StartLprCard, StoreManagerReviewCard } from '@/components/facility/StoreManagerSections'
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
      return 'The store offered an item. Click View Item to check it on the Item Borrowing Form, then accept or decline it there. No voucher is created until you accept.'
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

function issueStageLabel(stage: string, lprRunning: boolean) {
  if (stage === '' && lprRunning) return 'Local Purchase (LPR) in progress'
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

function stockCheckFromProcess(data: Record<string, unknown> | undefined): StoreStockCheck | null {
  const raw = data?.stockCheck
  if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return null
  return raw as StoreStockCheck
}

export function StoreOperationsPanel({ request }: { request: PortalRequest }) {
  const { employee } = useAuth()
  const status = request.status.trim().toLowerCase()
  const approved = ['approved', 'released', 'posted'].includes(status)
  const assignment = [employee?.jobTitle, employee?.departmentCode, employee?.departmentName]
    .map((value) => String(value ?? '').trim().toLowerCase())
    .join(' ')
  // Store roles also come from BC (Warehouse Employees for MAIN, the store card's Store Manager).
  const storeRolesQuery = useQuery({
    queryKey: ['store-requisition', 'my-roles'],
    queryFn: getMyStoreRoles,
    enabled: approved,
    staleTime: 60_000,
    retry: false,
  })
  const storeManager = userIsStoreManager(employee) || storeRolesQuery.data?.storeManager === true
  const canManageStock =
    (employee?.roles ?? []).some((role) => ['operations', 'store'].includes(String(role).toLowerCase())) ||
    /\b(operations?|ops|store|storekeeper)\b/.test(assignment) ||
    storeManager ||
    storeRolesQuery.data?.storeKeeper === true
  // The keeper's own step (add the item, Submit to Store Manager, Request for LPR) is never
  // shown to the Store Manager, who only reviews what the keeper submitted.
  const keeperStep = canManageStock && !storeManager
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
  // Start LPR defaults to the project already on the store request.
  const [lprProjectNo, setLprProjectNo] = useState(() =>
    request.payload?.IsProject === true ? text(request.payload?.ProjectCode ?? request.payload?.Project_Code) : '',
  )
  // Start Local Purchase (LPR) prompts on the BC card: source, project, then the officer.
  const [lprSource, setLprSource] = useState<'LOCAL' | 'FOREIGN'>('LOCAL')
  const [lprOfficer, setLprOfficer] = useState<'' | 'PROCUREMENT' | 'PROJECT'>('')
  // The store manager reviews the offer; "Change the item" opens the store keeper section.
  const [managerEditing, setManagerEditing] = useState(false)
  const storeOptionsQuery = useQuery({
    queryKey: ['store-requisition', 'options'],
    queryFn: getStoreRequisitionOptions,
    enabled: storeManager || canManageStock,
    staleTime: 5 * 60 * 1000,
    retry: false,
  })
  const lprOfficers = storeOptionsQuery.data?.lprOfficers ?? null
  // BC 1.0.3.544 has the store hand-off methods (Submit to Store Manager, Accept Item) for the portal.
  const bcStoreHandOff = storeOptionsQuery.data?.storesFromBc === true
  // BC 1.0.3.545: Add Item to Issue, Offer Another Item and Close Request from the portal.
  const storeOffers = storeOptionsQuery.data?.features?.includes('storeOffers') === true
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
    enabled: approved && canViewProcess,
  })
  const mutation = useMutation({
    mutationFn: ({ actionCode, extra = {} }: { actionCode: string; extra?: Record<string, string | number> }) =>
      actionCode === 'START_LPR'
        ? updateStoreRequisitionProcess(request.id, actionCode, lprProjectNo, {
            procurementSource: lprSource,
            officerType: lprOfficer,
          })
        : updateStoreRequisitionProcess(request.id, actionCode, '', extra),
    onSuccess: async (data) => {
      queryClient.setQueryData(['facility', 'store-requisition', 'detail', request.id], data.request)
      await queryClient.invalidateQueries({ queryKey: ['store-process', request.id] })
      await queryClient.invalidateQueries({
        queryKey: ['facility', 'store-requisition'],
        exact: true,
      })
      await queryClient.invalidateQueries({ queryKey: ['notifications'] })
    },
  })

  const requesterHandoff = approved && (ownsRequest || !canViewProcess)
  if (!approved) return null
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
  // BC Purchase Requisition Card of the running LPR (null on older BC apps or if it cannot load).
  const lprProgress = (processQuery.data?.localPurchase ?? null) as LprProgress | null
  const canOpenLpr = localPurchase.enabled && localPurchase.roles.length > 0 && Boolean(lprNo)
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

  const run = async (
    actionCode: string,
    title: string,
    message: string,
    extra: Record<string, string | number> = {},
    confirmFirst = true,
  ) => {
    if (confirmFirst && !(await confirm({ title, message, confirmLabel: title }))) return false
    try {
      const data = await mutation.mutateAsync({ actionCode, extra })
      if (actionCode === 'CONFIRM_RECEIPT') {
        window.localStorage.setItem(receiptStorageKey(request.requestNo), 'received')
        setReceiptConfirmed(true)
      }
      const issuedGiv = text(data.request?.payload?.StoreIssueNo ?? data.request?.payload?.Store_Issue_No) || givNo
      const createdLpr = text((data.process?.links as Record<string, unknown> | undefined)?.lprNo)
      // Same wording as the Business Central messages for each step.
      const successMessages: Record<string, string> = {
        PREPARE_ISSUE: `Store requisition ${requestNo} is with the store manager. The requester's line and the store offer line are both there. Stock has not moved.`,
        ADD_STORE_OFFER: 'Item added to issue. Submit to Store Manager when the offer is complete.',
        REMOVE_STORE_OFFER: 'Store offer removed.',
        OFFER_ANOTHER_ITEM: `The new item on store requisition ${requestNo} is with the store manager. After the manager accepts, the requester can accept or decline it.`,
        CLOSE_REQUEST: `Store requisition ${requestNo} is closed. Nothing was issued.`,
        ACCEPT_ISSUE: `Store requisition ${requestNo} accepted. The requester must accept the borrowing form before the goods issue voucher is created.`,
        ACCEPT_ITEM: `Accepted. Goods issue voucher ${issuedGiv || '(GIV)'} is with the storekeeper for requisition ${requestNo}. Status is In Transit. Confirm receipt when you have the item.`,
        DECLINE_ITEM: `Declined. Store requisition ${requestNo} is back with the storekeeper. They can offer another item, or close the request.`,
        CONFIRM_RECEIPT: `Store requisition ${requestNo} marked as received.`,
        ISSUE_AFTER_LPR: 'Issued after LPR receive — the goods issue voucher is posted to the requester.',
        REQUEST_FOR_LPR: `Store requisition ${requestNo} is with the Store Manager for Local Purchase. Requester: ${requesterId || 'the employee'}. Store Manager: open this request and choose Start Local Purchase (LPR).`,
        START_LPR: `Local Purchase Requisition ${createdLpr || '(LPR)'} created for store requisition ${requestNo}${requesterId ? ` (employee ${requesterId})` : ''}. Assigned procurement officer ${startLprOfficerId || startLprOfficerLabel} prepares it first. Project ${lprProjectNo || '(non-project)'}. Then ${lprOfficers?.operationsManager ? `Operations Manager ${lprOfficers.operationsManager}` : 'the Operations Manager'} approves, then FAD.`,
      }
      toast.success(successMessages[actionCode] ?? 'Linked Purchase Request created from this store requisition.')
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
  // Store Keeper works on the Store Offer until the store manager accepts it (BC Store Req Header Approved).
  const showOfferSection =
    storeOffers &&
    canManageStock &&
    ['approved', 'released'].includes(status) &&
    ((stageHandOff === '' && keeperStep) || stageHandOff === 'PREPARED') &&
    !(storeManager && stageHandOff === 'PREPARED' && !managerEditing) &&
    !lprPath &&
    !issued
  // No item / no similar item in store needs no item mapping (BC Request for LPR).
  const requestLprButton = (
    <Button
      type="button"
      variant={showOfferSection ? 'outline' : stockBlocked || localPurchase.enabled ? 'gradient' : 'outline'}
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
      {localPurchase.enabled
        ? showOfferSection
          ? 'Not in store? Request for LPR'
          : 'Request for LPR'
        : 'Stock not available — Purchase Request'}
    </Button>
  )
  const offerAvailable: Record<string, number> = Object.fromEntries(
    (stockCheck?.lines ?? [])
      .filter((line) => realBcItemNo(line.itemNo))
      .map((line) => [String(line.itemNo).toUpperCase(), Number(line.available ?? 0)]),
  )

  return (
    <section className="rounded-xl border border-teal-200/80 bg-gradient-to-br from-teal-50/90 via-white to-white p-4 text-sm text-slate-800 shadow-sm">
      <div className="flex items-center gap-2">
        <span className="flex h-8 w-8 items-center justify-center rounded-full bg-[var(--portal-navy)]/10 text-[var(--portal-navy-dark)]">
          <Warehouse className="h-4 w-4" />
        </span>
        <p className="text-base font-semibold text-[var(--portal-navy-dark)]">Store status</p>
      </div>
      {requesterHandoff ? (
        <StatusNotice tone={stageHandOff === 'RECEIVED' ? 'success' : stageHandOff === 'ACCEPTED' || stageHandOff === 'TRANSIT' ? 'info' : 'waiting'}>
          {requesterStatusText(stageHandOff, requesterDeclined, lprPath, givNo)}
        </StatusNotice>
      ) : null}
      {requesterHandoff && awaitingRequester ? (
        // View Item opens the Item Borrowing Form with Accept Item / Decline Item (as on the BC card).
        <div className="mt-3 flex flex-wrap items-center gap-2">
          <Button
            type="button"
            variant="gradient"
            disabled={mutation.isPending || borrowingFormLoading}
            onClick={openBorrowingForm}
          >
            {borrowingFormLoading ? 'Opening…' : 'View Item'}
          </Button>
          <Button type="button" variant="outline" onClick={downloadBorrowingForm}>
            Item Borrowing Form
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
      <div className="mt-3 flex flex-wrap items-center gap-2 text-xs">
        <span className="inline-flex items-center gap-1.5 rounded-full bg-white px-2.5 py-1 font-semibold text-[var(--portal-navy-dark)] shadow-sm ring-1 ring-teal-200">
          <span className="h-1.5 w-1.5 rounded-full bg-[var(--portal-navy)]" />
          {issueStageLabel(stageHandOff, atProcurement)}
        </span>
        {storeName ? <MetaChip label="Store" value={storeName} /> : null}
        {canViewProcess && !processQuery.isError && processQuery.data ? (
          <>
            <MetaChip label="Stage" value={label} />
            {owner ? <MetaChip label="Owner" value={owner} /> : null}
            {stock ? <MetaChip label="Stock" value={stock} /> : null}
          </>
        ) : null}
        {ginNo || givNo ? <MetaChip label="GIV" value={ginNo || givNo} /> : null}
        {lprNo ? <MetaChip label="LPR" value={lprNo} /> : null}
      </div>
      {processQuery.isError ? (
        <p className="mt-2 text-red-700">
          {processQuery.error instanceof Error ? processQuery.error.message : 'Could not load store process stage.'}
        </p>
      ) : null}
      {atStockCheck && needsBcPrep && !storeOffers ? (
        <div className="mt-3 rounded-md border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-950">
          <p className="font-semibold">Business Central prep required before GIV</p>
          <ul className="mt-1 list-disc space-y-1 pl-4">
            {prepHints.map((hint) => (
              <li key={hint}>{hint}</li>
            ))}
          </ul>
        </div>
      ) : null}
      {atStockCheck && stockCheck?.lines?.length && !storeOffers ? (
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
      {atStockCheck && stockBlocked && !storeOffers ? (
        <StatusNotice tone="warning">
          Stock is not available at {stockCheck?.issuingStore || 'the issuing store'}. Use Purchase Request — do not
          issue GIV until a posted GRV receives stock into that location.
        </StatusNotice>
      ) : null}
      {atStockCheck && stageHandOff === '' && keeperStep && !processQuery.isError && !storeOffers ? (
        <StatusNotice>
          Item in store: in Business Central (Store Req Header Approved) use Add Item to Issue, then Submit to Store
          Manager{bcStoreHandOff ? ' (in BC or here)' : ''}. Item not in store: Request for LPR below.
        </StatusNotice>
      ) : null}
      {showOfferSection ? (
        <StoreKeeperOfferSection
          request={request}
          stage={stageHandOff}
          declined={requesterDeclined}
          available={offerAvailable}
          busy={mutation.isPending}
          run={run}
          secondaryAction={
            atStockCheck && stageHandOff === '' && !processQuery.isError ? requestLprButton : null
          }
        />
      ) : null}
      {atStockCheck && stageHandOff === '' && keeperStep && !processQuery.isError && !showOfferSection ? (
        <div className="mt-3 flex flex-wrap gap-2">
          {bcStoreHandOff && !storeOffers ? (
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
          ) : null}
          {requestLprButton}
        </div>
      ) : null}
      {atLprRequested && localPurchase.enabled && !storeManager ? (
        <StatusNotice tone="waiting">
          Store requisition {requestNo} is with the Store Manager for Local Purchase
          {requesterId ? ` (requester ${requesterId})` : ''}. Waiting for the Store Manager to choose Start Local Purchase (LPR).
        </StatusNotice>
      ) : null}
      {canStartLpr ? (
        <StartLprCard
          requestNo={requestNo}
          requesterId={requesterId}
          request={request}
          showChoices={Boolean(lprOfficers)}
          officers={lprOfficers}
          source={lprSource}
          onSourceChange={setLprSource}
          projectNo={lprProjectNo}
          onProjectChange={(value) => {
            setLprProjectNo(value)
            // The officer follows the project again unless the manager picks one.
            setLprOfficer('')
          }}
          officerKind={startLprOfficerKind}
          onOfficerChange={setLprOfficer}
          busy={mutation.isPending}
          onStart={() =>
            void run(
              'START_LPR',
              'Start Local Purchase (LPR)',
              `Create the ${lprSource === 'FOREIGN' ? 'Foreign' : 'Local'} Purchase Requisition (LPR) for store requisition ${requestNo}` +
                `${lprProjectNo ? ` — project ${lprProjectNo}` : ' — non-project'}` +
                `, assigned to ${startLprOfficerId ? `${startLprOfficerLabel} ${startLprOfficerId}` : startLprOfficerLabel}?` +
                ' The officer prepares it first, then the Operations Manager and FAD approve it on the LPR (not Requests to Approve).',
            )
          }
        />
      ) : null}
      {stageHandOff === 'PREPARED' && storeManager && !managerEditing ? (
        <StoreManagerReviewCard
          request={request}
          available={offerAvailable}
          storeName={storeName}
          canAccept={bcStoreHandOff}
          busy={mutation.isPending}
          onChangeItem={() => setManagerEditing(true)}
          onAccept={() =>
            void run(
              'ACCEPT_ISSUE',
              'Accept Item (Store Manager)',
              `Accept the item offered on store requisition ${requestNo}${storeName ? ` from store ${storeName}` : ''}? The requester will get the borrowing form and can accept or decline it. No voucher is created yet.`,
            )
          }
        />
      ) : null}
      {stageHandOff === 'PREPARED' && storeManager && managerEditing ? (
        <div className="mt-3 flex justify-end">
          <Button type="button" variant="outline" size="sm" onClick={() => setManagerEditing(false)}>
            Back to review
          </Button>
        </div>
      ) : null}
      {stageHandOff === 'PREPARED' && !storeManager && !requesterHandoff ? (
        <StatusNotice tone="waiting">Waiting for the store manager to accept the offered item.</StatusNotice>
      ) : null}
      {atStockCheck && stockReady ? (
        <StatusNotice tone="success">All requested quantities are available at the issuing store.</StatusNotice>
      ) : null}
      {atStockCheck && !canManageStock ? (
        <StatusNotice tone="waiting">Waiting for Operations/Store to record the stock decision.</StatusNotice>
      ) : null}
      {atStockCheck && stageHandOff === '' && storeManager ? (
        <StatusNotice tone="waiting">
          Waiting for the Store Keeper to add the item to issue and submit it to you. Nothing to do here yet.
        </StatusNotice>
      ) : null}
      {atProcurement && !localPurchase.enabled ? (
        <StatusNotice tone="waiting">
          Purchase is continuing in the portal / Business Central{lprNo ? ` (${lprNo})` : ''}. After the
          GRV is posted into the issuing store, reopen this requisition — stage returns to stock check
          for GIV.
        </StatusNotice>
      ) : null}
      {atProcurement && localPurchase.enabled && lprProgress?.received ? (
        <StatusNotice tone="success">
          The goods for {lprProgress.lprNo || lprNo} are received into the store (GRN).{' '}
          {keeperStep ? 'Use Issue after LPR receive to issue them to the requester.' : 'Waiting for the Store Keeper to issue them to the requester.'}
        </StatusNotice>
      ) : null}
      {atProcurement && localPurchase.enabled && lprProgress && !lprProgress.received ? (
        <StatusNotice tone="waiting">
          <p>
            Local Purchase {lprProgress.lprNo || lprNo}
            {lprProgress.lprStatus ? ` · LPR Status ${lprProgress.lprStatus}` : ''}
            {lprProgress.currentDocumentNo && lprProgress.currentDocumentNo !== lprProgress.lprNo
              ? ` · now on ${lprProgress.currentDocumentNo}${lprProgress.flowStage ? ` (${lprProgress.flowStage})` : ''}`
              : ''}
          </p>
          <p className="mt-1 font-semibold">
            Now: {lprProgress.processStep || lprProgress.flowStage || 'in Business Central'}
          </p>
          {lprProgress.assignedProcUserId ? (
            <p className="mt-1 text-xs font-normal">Assigned Procurement Officer: {lprProgress.assignedProcUserId}</p>
          ) : null}
          <p className="mt-1 text-xs font-normal">
            The store issues the item after the goods are received into the store (GRN).
          </p>
        </StatusNotice>
      ) : null}
      {atProcurement && localPurchase.enabled && !lprProgress ? (
        <StatusNotice tone="waiting">
          Local Purchase{lprNo ? ` ${lprNo}` : ''} is running in Business Central. The store issues the item after the
          goods are received into the store (GRN).
        </StatusNotice>
      ) : null}
      {atProcurement && canOpenLpr ? (
        <div className="mt-3">
          <Button asChild variant="outline">
            <Link to={`/facility/local-purchase-request?open=${encodeURIComponent(`purchaseRequisition-${lprNo}`)}`}>
              Open LPR {lprNo}
            </Link>
          </Button>
        </div>
      ) : null}
      {/* Store Keeper only, once the LPR goods are received (or when BC cannot say, on older apps). */}
      {atProcurement &&
      localPurchase.enabled &&
      keeperStep &&
      !processQuery.isError &&
      (lprProgress ? lprProgress.received : true) ? (
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
        <StatusNotice tone="success">GIV posted — inventory reduced and requisition closed.</StatusNotice>
      ) : null}
    </section>
  )
}

type LprProgress = {
  lprNo: string
  lprStatus: string
  assignedProcUserId: string
  currentDocumentNo: string
  flowStage: string
  processStep: string
  received: boolean
}

function MetaChip({ label, value }: { label: string; value: string }) {
  return (
    <span className="inline-flex items-center gap-1 rounded-full bg-white/80 px-2.5 py-1 text-slate-600 ring-1 ring-slate-200">
      <span className="text-slate-400">{label}</span>
      <span className="font-medium text-slate-700">{value}</span>
    </span>
  )
}
