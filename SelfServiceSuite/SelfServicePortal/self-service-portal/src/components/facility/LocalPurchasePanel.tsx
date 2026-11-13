import { useState, type ReactNode } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ChevronRight, ClipboardList, FileText, PackageCheck, Receipt, ShoppingCart, Truck } from 'lucide-react'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import {
  getLocalPurchaseBankAccounts,
  getLocalPurchaseState,
  getLocalPurchaseVendors,
  getLprPaymentOptions,
  runLocalPurchaseAction,
  uploadLocalPurchaseQuoteAttachment,
  upsertLocalPurchaseVendorQuote,
  type LocalPurchaseNextAction,
  type LocalPurchaseVendorQuote,
} from '@/api/endpoints/requestEndpoint'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import { LprCommentDialog } from '@/components/facility/LprCommentDialog'
import { LprDraftLineEditor } from '@/components/facility/LprDraftLineEditor'
import type { PortalRequest } from '@/types/erp.types'
import { readFileAsBase64 } from '@/utils/readFileAsBase64'
import { StatusNotice } from '@/components/feedback/StatusNotice'
import { StoreRequisitionCardDialog } from '@/components/facility/StoreRequisitionCardDialog'
import type { CardField } from '@/components/facility/BcCard'
import { BcLinesTable } from '@/components/facility/BcLinesTable'
import { EditableCardSection, type EditSpec } from '@/components/facility/EditableCardSection'
import { PoReceiveEditor } from '@/components/facility/PoReceiveEditor'
import { PoReceiveItemSetup } from '@/components/facility/PoReceiveItemSetup'
import { PoAssignStore } from '@/components/facility/PoAssignStore'
import { PoServiceGlEditor } from '@/components/facility/PoServiceGlEditor'
import { VendorQuotesSection, type VendorQuoteSave } from '@/components/facility/VendorQuotesSection'
import { LprPrintButtons } from '@/components/facility/LprPrintButtons'
import { dateValue } from '@/components/facility/bcCardValues'
import {
  ORDER_LINE_COLUMNS,
  poLineColumns,
  lprLinesMissingFields,
  type PurchaseLine,
} from '@/components/facility/bcPurchaseLines'
import { cn } from '@/lib/utils'

/** Actions rendered inline (quote form / quote rows / Store Req) instead of the ribbon. */
const INLINE_ACTIONS = new Set([
  'UPSERT_VENDOR_QUOTE',
  'SELECT_WINNER_FAD',
  'ISSUE_AFTER_LPR',
  'UPDATE_LPR_LINE',
  // Per PO line: the service G/L account and the store keeper's item setup (forms under the PO lines).
  'SET_SERVICE_GL',
  'SET_RECEIVE_ITEM',
  // BC 1.0.3.613: the Store Manager's Assign Store panel under the PO lines.
  'ASSIGN_STORE',
  'CONFIRM_STORE',
])
/** The Store Manager's steps on a released PO, done in the Assign Store panel. */
const STORE_MANAGER_ACTIONS = new Set(['ASSIGN_STORE', 'SET_RECEIVE_ITEM', 'CONFIRM_STORE'])
const RETURN_ACTIONS = new Set([
  'REJECT_LPR',
  'SEND_BACK_LPR',
  'SEND_BACK_RFQ',
  'REJECT_RFQ',
  'SEND_BACK_PO',
  'REJECT_PO',
  'SEND_BACK_INVOICE',
])

const ROLE_LABELS: Record<string, string> = {
  operations: 'Store Keeper',
  storeManager: 'Store Manager',
  operationsManager: 'Operations Manager',
  procurement: 'Procurement',
  projectProcurement: 'Project Procurement',
  fad: 'FAD',
  finance: 'Finance',
  financeChecker: 'Finance Checker',
  technical: 'Technical',
  ceo: 'CEO',
  auditor: 'Auditor',
}

function text(value: unknown) {
  return String(value ?? '').trim()
}

function bcDate(value: unknown) {
  const raw = text(value)
  return raw && !raw.startsWith('0001-01-01') ? raw : ''
}

function isoDate(value: unknown) {
  return bcDate(value).slice(0, 10)
}

function linesOf(doc: Record<string, unknown> | undefined) {
  return Array.isArray(doc?.lines) ? (doc.lines as PurchaseLine[]) : null
}

type PaymentOption = { code: string; description: string }

/** A BC code with its description from the list, e.g. "30 DAYS — Net 30 days". */
function optionLabel(options: PaymentOption[] | undefined, value: unknown) {
  const code = text(value)
  const description = options?.find((option) => option.code === code)?.description
  return code && description ? `${code} — ${description}` : code
}

/** A PO code field: a dropdown of the BC list (BC 1.0.3.595), else typed as a code. */
function optionSpec(key: string, options: PaymentOption[] | undefined, value: unknown): EditSpec {
  const initial = text(value)
  if (!options?.length) return { key, kind: 'code', initial }
  const known = options.some((option) => option.code === initial)
  return {
    key,
    kind: 'select',
    initial,
    options: [
      { value: '', label: '' },
      ...(initial && !known ? [{ value: initial, label: initial }] : []),
      ...options.map((option) => ({
        value: option.code,
        label: option.description ? `${option.code} — ${option.description}` : option.code,
      })),
    ],
  }
}

/** A document in the chain laid out as its BC card (Local RFQ / Purchase Order): card, lines, extras. */
function ChainDocBlock({ id, children }: { id: string; children: ReactNode }) {
  return <div id={id} className="scroll-mt-24 space-y-6 rounded-xl border border-slate-200 bg-white p-4 shadow-sm">{children}</div>
}

function ownerLabel(action: LocalPurchaseNextAction) {
  const owners = action.ownerRoles.filter((role) => role !== 'finance' || action.ownerRoles.length === 1)
  return owners.map((role) => ROLE_LABELS[role] ?? role).join(' / ')
}

function Field({ label, value }: { label: string; value: ReactNode }) {
  if (value === '' || value === null || value === undefined) return null
  return (
    <div>
      <dt className="text-xs text-slate-500">{label}</dt>
      <dd className="font-medium text-slate-800">{value}</dd>
    </div>
  )
}

function DocCard({ id, title, children }: { id?: string; title: string; children: ReactNode }) {
  return (
    <div id={id} className="scroll-mt-24 rounded-md border border-teal-100 bg-white/70 p-3">
      <p className="text-xs font-semibold uppercase tracking-wide text-[var(--portal-navy)]">{title}</p>
      <dl className="mt-2 grid grid-cols-1 gap-2 sm:grid-cols-2">{children}</dl>
    </div>
  )
}

/** One document in the chain (BC related documents): Store Req → LPR → RFQ → PO → GRN → Invoice. */
type RelatedDoc = {
  key: string
  label: string
  no: string
  state: string
  icon: typeof FileText
  current?: boolean
  onOpen?: () => void
}

/** Icon colours of the other documents in the chain, in turn (the dashboard hero's palette). */
const RELATED_DOC_TONES = ['text-[#9df2fc]', 'text-[#c9d9f4]', 'text-[#e9f3a6]', 'text-[#fdb88b]', 'text-[#dde0fa]']

/** The chain on the dashboard hero's brand gradient: glass chips, the open document in white. */
function RelatedDocuments({ docs }: { docs: RelatedDoc[] }) {
  return (
    <div className="portal-band rounded-xl px-3 py-2.5">
      <div className="portal-hero-aurora" aria-hidden>
        <span />
        <span />
        <span />
      </div>
      <div className="portal-hero-grid" aria-hidden />
      <p className="mb-2 text-[11px] font-semibold uppercase tracking-[0.1em] text-white/75">Related documents</p>
      <nav aria-label="Related documents" className="flex flex-wrap items-stretch gap-1.5">
        {docs.map((doc, index) => {
          const Icon = doc.icon
          const body = (
            <>
              <Icon
                className={cn(
                  'h-4 w-4 shrink-0',
                  doc.current ? 'text-[#03949b]' : RELATED_DOC_TONES[index % RELATED_DOC_TONES.length],
                )}
                aria-hidden="true"
              />
              <span className="min-w-0 text-left leading-tight">
                <span className={cn('block text-[11px]', doc.current ? 'text-[#5b5d6b]' : 'text-white/75')}>{doc.label}</span>
                <span className="block text-sm font-semibold">{doc.no}</span>
                {doc.state ? (
                  <span className={cn('block text-[11px]', doc.current ? 'text-[#047a80]' : 'text-white/75')}>
                    {doc.state}
                  </span>
                ) : null}
              </span>
            </>
          )
          const chip = cn(
            'portal-band-chip flex items-center gap-2 px-3 py-1.5',
            doc.current && 'portal-band-chip--current',
            doc.onOpen && 'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white',
          )
          return (
            <div key={doc.key} className="flex items-center gap-1.5">
              {index > 0 ? <ChevronRight className="h-4 w-4 shrink-0 text-white/45" aria-hidden="true" /> : null}
              {doc.onOpen ? (
                <button type="button" className={chip} onClick={doc.onOpen} title={`Open ${doc.label} ${doc.no}`}>
                  {body}
                </button>
              ) : (
                <div className={chip} aria-current={doc.current ? 'page' : undefined}>
                  {body}
                </div>
              )}
            </div>
          )
        })}
      </nav>
    </div>
  )
}

function scrollToDoc(id: string) {
  document.getElementById(id)?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

/**
 * Local Purchase (LPR -> RFQ -> PO) on the Purchase Requisition card: mirrors the BC card — the
 * ribbon (Open Store Requisition and the signed-in user's step), the Process Step from BC and the
 * related documents. Renders the 1.0.3.382 purchase panel (`fallback`) unchanged when Local Purchase
 * is not live in BC yet, or when the document is not a Local LPR.
 */
export function LocalPurchasePanel({ request, fallback }: { request: PortalRequest; fallback: ReactNode }) {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const [actionComment, setActionComment] = useState('')
  // The approve / send back / reject waiting for its comment (BC opens a comment dialog first).
  const [commentAction, setCommentAction] = useState<LocalPurchaseNextAction | null>(null)
  // The vendor quote line a Change Winner (FAD) is for, kept while FAD writes the reason.
  const [commentLinkedNo, setCommentLinkedNo] = useState('')
  const [storeCardOpen, setStoreCardOpen] = useState(false)
  const [vendorInvoiceNo, setVendorInvoiceNo] = useState('')
  const [bankAccountNo, setBankAccountNo] = useState('')
  const access = useLocalPurchaseAccess()
  const stateQuery = useQuery({
    queryKey: ['local-purchase', request.id],
    queryFn: () => getLocalPurchaseState(request.id),
    enabled: access.enabled,
    retry: false,
  })
  const isFinanceChecker = access.roles.includes('financeChecker')
  // BC Vendor list for the quote form's Vendor No. lookup (Procurement only).
  const vendorQuery = useQuery({
    queryKey: ['local-purchase', 'vendors'],
    queryFn: getLocalPurchaseVendors,
    enabled: access.enabled && access.roles.some((role) => role === 'procurement' || role === 'projectProcurement'),
    staleTime: 5 * 60_000,
    retry: false,
  })
  const vendorOptions = (vendorQuery.data?.vendors ?? []).map((vendor) => ({
    value: vendor.no,
    label: vendor.name ? `${vendor.no} - ${vendor.name}` : vendor.no,
  }))
  const bankQuery = useQuery({
    queryKey: ['local-purchase', 'bank-accounts'],
    queryFn: getLocalPurchaseBankAccounts,
    enabled: access.enabled && isFinanceChecker,
    retry: false,
    staleTime: 5 * 60_000,
  })
  // Payment terms / methods and shipment methods for the Purchase Order card (BC 1.0.3.595).
  const paymentQuery = useQuery({
    queryKey: ['local-purchase', 'payment-options'],
    queryFn: getLprPaymentOptions,
    enabled: access.enabled && Boolean(stateQuery.data?.chain.po),
    staleTime: 5 * 60_000,
    retry: false,
  })
  const refresh = async () => {
    await queryClient.invalidateQueries({ queryKey: ['local-purchase', request.id] })
    await queryClient.invalidateQueries({ queryKey: ['facility', 'purchase-requisition'] })
    await queryClient.invalidateQueries({ queryKey: ['local-purchase', 'waiting'] })
    await queryClient.invalidateQueries({ queryKey: ['notifications'] })
  }
  const actionMutation = useMutation({
    mutationFn: (body: Parameters<typeof runLocalPurchaseAction>[1]) => runLocalPurchaseAction(request.id, body),
    onSuccess: refresh,
  })
  const quoteMutation = useMutation({
    mutationFn: (quote: Parameters<typeof upsertLocalPurchaseVendorQuote>[1]) =>
      upsertLocalPurchaseVendorQuote(request.id, quote),
    onSuccess: refresh,
  })
  const attachMutation = useMutation({
    mutationFn: ({ lineNo, file, rfqNo }: { lineNo: number; file: File; rfqNo: string }) =>
      readFileAsBase64(file).then((contentBase64) =>
        uploadLocalPurchaseQuoteAttachment(request.id, lineNo, {
          rfqNo,
          fileName: file.name,
          contentBase64,
          description: `Vendor quote — ${file.name}`,
        }),
      ),
    onSuccess: refresh,
  })

  if (!access.enabled) return <>{fallback}</>
  if (stateQuery.isLoading) {
    return <p className="text-sm text-slate-600">Loading Local Purchase status…</p>
  }
  const state = stateQuery.data
  const lpr = state?.chain.lpr
  const rfq = state?.chain.rfq
  const po = state?.chain.po
  const isLocalFlow = Boolean(text(lpr?.flowStage) || rfq || po)
  if (stateQuery.isError || !state || !isLocalFlow) return <>{fallback}</>

  const busy = actionMutation.isPending || quoteMutation.isPending || attachMutation.isPending
  const nextActions = state.nextActions
  const allowed = (code: string) => nextActions.some((action) => action.actionCode === code && action.allowed)
  const ribbon = nextActions.filter((action) => action.allowed && !INLINE_ACTIONS.has(action.actionCode))
  const storeManagerSteps = nextActions.filter((action) => action.allowed && STORE_MANAGER_ACTIONS.has(action.actionCode) && action.actionCode !== 'SET_RECEIVE_ITEM')
  // Only Send back / Reject (e.g. FAD at Ready for PO): the document waits for someone else's step.
  const ownStep = ribbon.some((action) => !RETURN_ACTIONS.has(action.actionCode)) || storeManagerSteps.length > 0
  const waiting = nextActions.filter(
    (action) =>
      !action.allowed &&
      !['UPSERT_VENDOR_QUOTE', 'ISSUE_AFTER_LPR', 'UPDATE_LPR_LINE', 'FIX_LOCAL_CURRENCY'].includes(action.actionCode),
  )
  const issueAfterLpr = nextActions.find((action) => action.actionCode === 'ISSUE_AFTER_LPR')
  const updateLprLine = nextActions.find((action) => action.actionCode === 'UPDATE_LPR_LINE' && action.allowed)
  // A comment is a must only to send back, reject, recommend (Technical) or change the winner;
  // a routine approval still opens the box, as its confirmation, and the comment may stay empty.
  const needsComment = (action: LocalPurchaseNextAction) =>
    Boolean(action.commentRequired) || action.actionCode === 'SUBMIT_TECHNICAL_REVIEW'
  const asksComment = (action: LocalPurchaseNextAction) => needsComment(action) || Boolean(action.commentOptional)
  const needsVendorInvoiceNo = ribbon.some((action) => action.actionCode === 'CREATE_LOCAL_INVOICE')
  const needsBank = ribbon.some((action) => action.actionCode === 'CLOSE_LPR_AFTER_PAYMENT')
  const bankOptions = (bankQuery.data?.bankAccounts ?? []).map((bank) => ({
    value: bank.no,
    label: [bank.no, bank.name, bank.currencyCode].filter(Boolean).join(' — '),
  }))
  const quotes: LocalPurchaseVendorQuote[] = state.quotes.quotes ?? []
  const rfqNo = text(rfq?.no)
  const minQuotes = Number(rfq?.minQuotesRequired ?? 0) || 0
  const poCurrency = text(po?.currencyCode)
  const technicalComment = text(rfq?.technicalComment)
  const receipts = state.chain.receipts ?? []
  const fadSelectWinner = allowed('SELECT_WINNER_FAD')
  const canEditQuotes = allowed('UPSERT_VENDOR_QUOTE')

  const run = async (
    action: LocalPurchaseNextAction,
    extra: { linkedDocumentNo?: string; commented?: boolean } = {},
  ) => {
    // Approve, send back and reject open the comment box first; it is the confirmation too.
    if (asksComment(action) && !extra.commented) {
      setActionComment('')
      setCommentLinkedNo(extra.linkedDocumentNo ?? '')
      setCommentAction(action)
      return
    }
    const comment = extra.commented ? actionComment.trim() : ''
    if (needsComment(action) && !comment) return
    // BC refuses Submit while a line misses a required field (BC 1.0.3.583 sends Request Type and
    // Purpose with the lines; on older BC the check is left to BC).
    if (action.actionCode === 'SUBMIT_LPR_OPS' && text(lpr?.no).toUpperCase() === request.requestNo.trim().toUpperCase()) {
      const chainLines = (lpr as Record<string, unknown> | undefined)?.lines
      const lprLines = Array.isArray(chainLines)
        ? (chainLines as PurchaseLine[])
        : Array.isArray(request.payload?.lines)
          ? (request.payload.lines as PurchaseLine[])
          : []
      const missing = lprLines.some((line) => 'requestType' in line) ? lprLinesMissingFields(lprLines) : []
      if (missing.length) {
        toast.error(`${missing.join('. ')}.`, 'Complete the LPR lines first')
        return
      }
    }
    if (action.actionCode === 'CREATE_LOCAL_INVOICE' && !vendorInvoiceNo.trim()) {
      toast.error('Enter the real Vendor Invoice No. from the supplier invoice.', 'Vendor Invoice No. required')
      return
    }
    if (action.actionCode === 'CLOSE_LPR_AFTER_PAYMENT' && !bankAccountNo) {
      toast.error('Choose the bank account this payment is made from.', 'Bank account required')
      return
    }
    const yes =
      extra.commented ||
      (await confirm({
        title: action.label,
        message:
          action.actionCode === 'CLOSE_LPR_AFTER_PAYMENT'
            ? `${action.label} on ${action.documentNo} from bank ${bankAccountNo}?`
            : `${action.label} on ${action.documentNo}?`,
        confirmLabel: action.label,
      }))
    if (!yes) return
    try {
      const response = await actionMutation.mutateAsync({
        actionCode: action.actionCode,
        documentNo: action.documentNo,
        linkedDocumentNo: extra.linkedDocumentNo ?? '',
        actionComment: comment,
        payload:
          action.actionCode === 'CREATE_LOCAL_INVOICE'
            ? { vendorInvoiceNo: vendorInvoiceNo.trim() }
            : action.actionCode === 'SUBMIT_TECHNICAL_REVIEW'
              ? { technicalComment: comment }
              : action.actionCode === 'CLOSE_LPR_AFTER_PAYMENT'
                ? { bankAccountNo }
                : undefined,
      })
      setActionComment('')
      setCommentAction(null)
      setVendorInvoiceNo('')
      setBankAccountNo('')
      const resultNo = text(response.result?.resultNo)
      toast.success(
        action.actionCode === 'CONVERT_TO_RFQ'
          ? `RFQ ${resultNo || ''} created. Its next step is shown below (BC 1.0.3.588: prepare it, then Submit RFQ to Operations Manager).`
          : action.actionCode === 'SUBMIT_RFQ_OPS'
            ? `RFQ ${action.documentNo} submitted to the Operations Manager for approval. Vendor quotes start after the approval.`
            : action.actionCode === 'SELECT_WINNER_FAD'
              ? `Winner changed to ${resultNo || 'the selected vendor'}; your reason is the Vendor Selection Reason. Next: Approve Winner (FAD Final).`
            : action.actionCode === 'APPROVE_WINNER_FAD_FINAL'
              ? `Winner approved on ${action.documentNo}. Business Central created the Purchase Order as a draft: Procurement completes it, then submits it to the Operations Manager.`
            : action.actionCode === 'SUBMIT_PO_OPS'
              ? `PO ${action.documentNo} submitted to the Operations Manager for approval.`
            : resultNo && resultNo !== action.documentNo
            ? `${action.label} — ${resultNo}`
            : `${action.label} completed.`,
      )
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Action failed', action.label)
    }
  }

  const saveQuote = async (quote: VendorQuoteSave) => {
    try {
      await quoteMutation.mutateAsync({ rfqNo, ...quote })
      toast.success(
        quote.lineNo
          ? `Vendor quote for ${quote.vendorNo} saved.`
          : `Vendor quote saved for ${quote.vendorNo}. Attach the quote file before Auto Select Winner.`,
      )
      return true
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not save the vendor quote', 'Vendor quote')
      return false
    }
  }

  const attach = async (quote: LocalPurchaseVendorQuote, file: File | undefined) => {
    if (!file) return
    try {
      await attachMutation.mutateAsync({ lineNo: quote.lineNo, file, rfqNo })
      toast.success(`Quote file attached for ${quote.vendorName || quote.vendorNo}.`)
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not attach the quote file', 'Attachments')
    }
  }

  /** Runs a card edit (save / line / delete) on a chain document and reports the result. */
  const saveDoc = async (actionCode: string, documentNo: string, payload: Record<string, unknown>, success: string) => {
    try {
      await actionMutation.mutateAsync({ actionCode, documentNo, payload })
      toast.success(success)
      return true
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not save the change', documentNo)
      return false
    }
  }

  const deleteQuote = async (quote: LocalPurchaseVendorQuote) => {
    const name = quote.vendorName || quote.vendorNo
    const yes = await confirm({
      title: 'Delete vendor quote',
      message: `Delete the quote from ${name} on ${rfqNo}?`,
      confirmLabel: 'Delete',
      tone: 'danger',
    })
    if (!yes) return false
    return saveDoc('DELETE_VENDOR_QUOTE', rfqNo, { lineNo: quote.lineNo }, `Quote from ${name} deleted.`)
  }

  const changeWinnerQuote = quotes.find((quote) => String(quote.lineNo) === commentLinkedNo)
  const changeWinnerTo = changeWinnerQuote ? changeWinnerQuote.vendorName || changeWinnerQuote.vendorNo : ''
  const selectWinner = (quote: LocalPurchaseVendorQuote) => {
    const action = nextActions.find((row) => row.actionCode === 'SELECT_WINNER_FAD')
    if (action) void run(action, { linkedDocumentNo: String(quote.lineNo) })
  }

  const lprNo = text(lpr?.no)
  const poNo = text(po?.no)
  const storeReqNo = text(state.chain.storeRequisitionNo)
  const requestNo = request.requestNo.trim().toUpperCase()
  const isThisLpr = lprNo.toUpperCase() === requestNo
  const processStep = text(po?.processStep || rfq?.processStep || lpr?.processStep)
  const flowStage = text(po?.flowStage) || text(rfq?.flowStage) || text(lpr?.flowStage)
  const invoiceNo = text(po?.postedInvoiceNo) || text(po?.createdInvoiceNo)
  const grnNos = receipts.map((row) => text(row.no)).filter(Boolean)
  const cardTitle = poNo && poNo.toUpperCase() === requestNo
    ? 'Purchase Order'
    : rfqNo && rfqNo.toUpperCase() === requestNo
      ? 'Local RFQ'
      : 'Purchase Requisition Card'
  const relatedDocs: RelatedDoc[] = [
    ...(storeReqNo
      ? [{
          key: 'store',
          label: 'Store Requisition',
          no: storeReqNo,
          state: 'Open card',
          icon: ClipboardList,
          onOpen: () => setStoreCardOpen(true),
        }]
      : []),
    ...(lprNo
      ? [{
          key: 'lpr',
          label: 'Purchase Requisition (LPR)',
          no: lprNo,
          state: text(lpr?.lprStatus),
          icon: ShoppingCart,
          current: isThisLpr,
          onOpen: isThisLpr ? undefined : () => scrollToDoc('lpr-doc-lpr'),
        }]
      : []),
    ...(rfqNo
      ? [{
          key: 'rfq',
          label: 'Local RFQ',
          no: rfqNo,
          state: text(rfq?.flowStage),
          icon: FileText,
          current: rfqNo.toUpperCase() === requestNo,
          onOpen: () => scrollToDoc('lpr-doc-rfq'),
        }]
      : []),
    ...(poNo
      ? [{
          key: 'po',
          label: 'Purchase Order',
          no: poNo,
          state: text(po?.flowStage),
          icon: Truck,
          current: poNo.toUpperCase() === requestNo,
          onOpen: () => scrollToDoc('lpr-doc-po'),
        }]
      : []),
    ...(grnNos.length
      ? [{ key: 'grn', label: 'Goods Receipt (GRN)', no: grnNos.join(', '), state: 'Posted', icon: PackageCheck }]
      : []),
    ...(invoiceNo
      ? [{
          key: 'invoice',
          label: 'Invoice',
          no: invoiceNo,
          state: po?.lprClosed ? 'Paid' : po?.invoiceVerified ? 'Verified' : '',
          icon: Receipt,
        }]
      : []),
  ]

  // What the signed-in user may change now, by BC's rule for each card (BC 1.0.3.569 for RFQ / PO / receive).
  const editing = state.editing ?? { lpr: state.cardEditable === true, rfq: false, po: false, receive: false }
  const rfqLines = linesOf(rfq)
  const poLines = linesOf(po)
  const editHints = [
    editing.lpr && isThisLpr ? 'the LPR card (Edit on General, and New Line / edit / delete in the Purchase Requisition Subform)' : '',
    editing.rfq ? `Local RFQ ${rfqNo} (Edit, and its lines)` : '',
    canEditQuotes ? 'the vendor quotes (add, edit, delete)' : '',
    editing.po ? `Purchase Order ${poNo} (Edit, and its lines)` : '',
    editing.receive ? `what is received on ${poNo} (Receive → Edit)` : '',
  ].filter(Boolean)
  const editHint = editHints.length ? (
    <p className="mt-1 text-xs font-normal">You can change {editHints.join('; ')} below, as in Business Central.</p>
  ) : null

  // Local RFQ card (ABH Local RFQ Card Ext → Local RFQ steps), in the card's order.
  const rfqFields: CardField[] = rfq
    ? [
        { label: 'No.', value: rfqNo, emphasis: 'strong' },
        { label: 'Process Step', value: text(rfq.processStep), emphasis: 'strong' },
        { label: 'Full Flow Stage', value: text(rfq.flowStage) },
        { label: 'From LPR No.', value: text(rfq.fromLprNo) },
        { label: 'From Store Req.', value: text(rfq.storeRequisitionNo) },
        { label: 'Request Description', value: text(rfq.requestSummary) },
        { label: 'Document Date', value: dateValue(bcDate(rfq.documentDate)) },
        { label: 'Requested Receipt Date', value: dateValue(bcDate(rfq.requiredByDate)) },
        { label: 'Quote Due Date', value: dateValue(bcDate(rfq.quoteDueDate)) },
        { label: 'Minimum Quotes Required', value: String(minQuotes) },
        { label: 'Selected Vendor', value: text(rfq.selectedVendorNo), emphasis: 'user' },
        { label: 'Vendor Selection Reason', value: text(rfq.selectionReason) },
        { label: 'RFQ Approved By (Operations Manager)', value: text(rfq.opsRfqApprovedBy), emphasis: 'user' },
        { label: 'Evaluation Reviewed By (Operations Manager)', value: text(rfq.opsEvalReviewedBy), emphasis: 'user' },
        { label: 'Technical Comment', value: technicalComment },
        { label: 'Tech Reviewed By', value: text(rfq.techReviewedBy), emphasis: 'user' },
        { label: 'FAD Final By', value: text(rfq.fadFinalBy), emphasis: 'user' },
        { label: 'Created PO No.', value: text(rfq.createdPoNo) },
        { label: 'Send Back Comment', value: text(rfq.sendBackComment) },
      ]
    : []
  const rfqSpecs: Record<string, EditSpec> = rfq
    ? {
        'Request Description': { key: 'requestSummary', kind: 'text', initial: text(rfq.requestSummary) },
        'Document Date': { key: 'documentDate', kind: 'date', initial: isoDate(rfq.documentDate) },
        'Requested Receipt Date': { key: 'requiredByDate', kind: 'date', initial: isoDate(rfq.requiredByDate) },
        'Quote Due Date': { key: 'quoteDueDate', kind: 'date', initial: isoDate(rfq.quoteDueDate) },
        'Minimum Quotes Required': { key: 'minQuotesRequired', kind: 'number', initial: String(minQuotes) },
      }
    : {}

  // Purchase Order card as in BC: General, Lines, totals, Invoice Details, Shipping and Payment. BC 1.0.3.596
  // sends the card fields the chain had no key for by BC field name (cardFields); older BC leaves them blank.
  const paymentOptions = paymentQuery.data?.available ? paymentQuery.data : undefined
  const poCard = (po?.cardFields ?? {}) as Record<string, unknown>
  const card = (name: string) => text(poCard[name])
  // A card field BC 1.0.3.597 saves by its BC field name (UPDATE_PO_HEADER); dates as yyyy-mm-dd.
  const cardSpec = (name: string, kind: EditSpec['kind']): EditSpec => ({
    key: name,
    kind,
    initial: kind === 'date' ? bcDate(poCard[name]).slice(0, 10) : card(name),
  })
  const yesNo = (value: unknown) => (value === true || String(value).toLowerCase() === 'true' ? 'Yes' : 'No')
  const poTotals = (() => {
    const lines = poLines ?? []
    const subtotal = lines.reduce((sum, line) => sum + Number(line.lineAmount ?? 0), 0)
    const invDiscount = lines.reduce((sum, line) => sum + Number(line.invDiscountAmount ?? 0), 0)
    const inclVat = Number(po?.amountIncludingVat ?? 0)
    // BC 1.0.3.595 sends the amount excl. VAT; before, the lines' total less the invoice discount.
    const exclVat = po?.amountExclVat !== undefined ? Number(po.amountExclVat) : subtotal - invDiscount
    return {
      subtotal,
      invDiscount,
      discountPercent: subtotal > 0 ? (invDiscount / subtotal) * 100 : 0,
      exclVat,
      vat: Math.max(0, inclVat - exclVat),
      inclVat,
    }
  })()

  // General as on the BC Purchase Order card, column by column (7 | 9 | 7).
  const poGeneral: CardField[] = po
    ? [
        { label: 'Vendor Name', value: text(po.vendorName), emphasis: 'user' },
        { label: 'Contact', value: card('Buy-from Contact') },
        { label: 'Document Date', value: dateValue(bcDate(po.documentDate)) },
        { label: 'Vendor Invoice No.', value: card('Vendor Invoice No.') },
        { label: 'PO Remarks / Special Terms', value: text(po.poRemarks) },
        { label: 'Purchase Requisition No.', value: text(po.fromLprNo) },
        { label: 'RFQ No.', value: card('RFQ No.') },
        { label: 'Posting Description', value: text(po.requestSummary) },
        { label: 'Vendor Delivery Note No.', value: text(po.vendorShipmentNo) },
        { label: 'Process Step (from template)', value: text(po.processStep), emphasis: 'strong' },
        { label: 'Full Flow Stage', value: text(po.flowStage) },
        { label: 'Procurement Source', value: text(po.procurementSource) },
        { label: 'From RFQ No.', value: card('Request for Quote No.') || rfqNo },
        { label: 'FAD Approved PO', value: yesNo(po.fadPoApproved) },
        // BC 1.0.3.613: the Store Manager assigns the receiving store before the store keeper receives.
        ...(po.storeAssigned !== undefined
          ? [
              { label: 'Store Assigned', value: yesNo(po.storeAssigned) },
              { label: 'Store Assigned By', value: text(po.storeAssignedBy), emphasis: 'user' as const },
              { label: 'Store Assigned Date', value: dateValue(bcDate(po.storeAssignedDate)) },
              { label: 'Destination Store', value: text(po.destinationStore) },
            ]
          : []),
        { label: 'Created Invoice No.', value: text(po.createdInvoiceNo) },
        { label: 'Invoice 3-Way Verified', value: yesNo(po.invoiceVerified) },
        { label: 'CEO Payment Approved', value: yesNo(po.ceoPayApproved) },
        { label: 'LPR Closed', value: yesNo(po.lprClosed) },
        { label: 'Send Back Comment', value: text(po.sendBackComment) },
        { label: 'Rejection Reason', value: text(po.rejectionReason) },
        { label: 'Sent Back By', value: card('ABH Sent Back By'), emphasis: 'user' },
        { label: 'Sent Back Date', value: dateValue(bcDate(card('ABH Sent Back Date'))) },
        { label: 'Status', value: text(po.status) },
      ]
    : []
  const poGeneralSpecs: Record<string, EditSpec> = po
    ? {
        'Document Date': { key: 'documentDate', kind: 'date', initial: isoDate(po.documentDate) },
        'PO Remarks / Special Terms': { key: 'poRemarks', kind: 'longtext', initial: text(po.poRemarks) },
        'Posting Description': { key: 'requestSummary', kind: 'text', initial: text(po.requestSummary) },
        'Vendor Delivery Note No.': { key: 'vendorShipmentNo', kind: 'text', initial: text(po.vendorShipmentNo) },
        // BC 1.0.3.597: the other card fields are saved by their BC field name.
        Contact: cardSpec('Buy-from Contact', 'text'),
        'Vendor Invoice No.': cardSpec('Vendor Invoice No.', 'text'),
        // Show more (BC 1.0.3.603).
        'Buy-from Address': cardSpec('Buy-from Address', 'text'),
        'Buy-from Address 2': cardSpec('Buy-from Address 2', 'text'),
        'Buy-from City': cardSpec('Buy-from City', 'text'),
        'Buy-from County': cardSpec('Buy-from County', 'text'),
        'Buy-from Post Code': cardSpec('Buy-from Post Code', 'code'),
        'Buy-from Country/Region': cardSpec('Buy-from Country/Region Code', 'code'),
        'Buy-from Contact No.': cardSpec('Buy-from Contact No.', 'code'),
        'Posting Date': cardSpec('Posting Date', 'date'),
        'VAT Reporting Date': cardSpec('VAT Reporting Date', 'date'),
        'Due Date': cardSpec('Due Date', 'date'),
        'Order Date': { key: 'orderDate', kind: 'date', initial: isoDate(po.orderDate) },
        'Campaign No.': cardSpec('Campaign No.', 'code'),
        'Responsibility Center': { key: 'Responsibility Center', kind: 'code', initial: text(po.responsibilityCenter) },
        'User ID': cardSpec('Assigned User ID', 'code'),
      }
    : {}
  // General → Show more, as on the BC card.
  const poGeneralMore: CardField[] = po
    ? [
        { label: 'No.', value: poNo, emphasis: 'strong' },
        { label: 'Vendor No.', value: text(po.vendorNo) },
        { label: 'Buy-from Address', value: card('Buy-from Address') },
        { label: 'Buy-from Address 2', value: card('Buy-from Address 2') },
        { label: 'Buy-from City', value: card('Buy-from City') },
        { label: 'Buy-from County', value: card('Buy-from County') },
        { label: 'Buy-from Post Code', value: card('Buy-from Post Code') },
        { label: 'Buy-from Country/Region', value: card('Buy-from Country/Region Code') },
        { label: 'Buy-from Contact No.', value: card('Buy-from Contact No.') },
        { label: 'No. of Archived Versions', value: card('No. of Archived Versions') },
        { label: 'Posting Date', value: dateValue(bcDate(card('Posting Date'))) },
        { label: 'VAT Reporting Date', value: dateValue(bcDate(card('VAT Reporting Date'))) },
        { label: 'Due Date', value: dateValue(bcDate(card('Due Date'))) },
        { label: 'Order Date', value: dateValue(bcDate(po.orderDate)) },
        { label: 'Quote No.', value: card('Quote No.') },
        { label: 'Campaign No.', value: card('Campaign No.') },
        { label: 'Responsibility Center', value: text(po.responsibilityCenter) },
        { label: 'User ID', value: card('Assigned User ID') },
        { label: 'Job Queue Status', value: card('Job Queue Status') },
      ]
    : []
  // The fields the portal shows besides the BC card: who did each step of the local purchase.
  const poProgress: CardField[] = po
    ? [
        { label: 'Vendor Order No.', value: text(po.vendorOrderNo) },
        { label: 'Operations Manager Approved PO', value: text(po.opsApprovedBy), emphasis: 'user' },
        { label: 'GRN', value: grnNos.join(', ') },
        { label: 'Posted Invoice No.', value: text(po.postedInvoiceNo) },
        { label: 'Invoice Checked By (Operations Manager)', value: text(po.opsInvoiceCheckedBy), emphasis: 'user' },
        { label: 'Paid From Bank', value: text(po.paymentBankNo) },
        { label: 'Payment Voucher', value: text(po.paymentDocNo) },
      ]
    : []
  const poProgressSpecs: Record<string, EditSpec> = po
    ? {
        'Vendor Order No.': { key: 'vendorOrderNo', kind: 'text', initial: text(po.vendorOrderNo) },
      }
    : {}
  // Totals under the lines as on the BC subform (2 | 2 | 2), amounts in the local currency.
  const amountText = (value: number) => value.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
  const totalsCurrency = poCurrency || 'ETB'
  const poTotalFields: CardField[] = [
    { label: `Subtotal Excl. Tax (${totalsCurrency})`, value: amountText(poTotals.subtotal) },
    { label: `Inv. Discount Amount (${totalsCurrency})`, value: amountText(poTotals.invDiscount) },
    { label: 'Invoice Discount %', value: String(Math.round(poTotals.discountPercent * 100) / 100) },
    { label: `Total Excl. Tax (${totalsCurrency})`, value: amountText(poTotals.exclVat) },
    { label: `Total Tax (${totalsCurrency})`, value: amountText(poTotals.vat) },
    { label: `Total Incl. Tax (${totalsCurrency})`, value: amountText(poTotals.inclVat), emphasis: 'strong' },
  ]
  // BC 1.0.3.602: the invoice discount is entered here, as amount or %, and BC spreads it over the lines.
  const poTotalSpecs: Record<string, EditSpec> = {
    [`Inv. Discount Amount (${totalsCurrency})`]: {
      key: 'invoiceDiscountAmount',
      kind: 'number',
      initial: String(Math.round(poTotals.invDiscount * 100) / 100),
    },
    'Invoice Discount %': {
      key: 'invoiceDiscountPercent',
      kind: 'number',
      initial: String(Math.round(poTotals.discountPercent * 100) / 100),
    },
  }
  // Invoice Details as on the BC card (6 | 7 | 7); Payment Method Code and Due Date close their columns.
  const poInvoiceDetails: CardField[] = po
    ? [
        { label: 'Currency Code', value: poCurrency },
        { label: 'Posting No. Series', value: card('Posting No. Series') },
        { label: 'Receiving No. Series', value: card('Receiving No. Series') },
        { label: 'Expected Receipt Date', value: dateValue(bcDate(po.expectedReceiptDate)) },
        { label: 'Prices Including Tax', value: yesNo(po.pricesIncludingVat) },
        { label: 'VAT Bus. Posting Group', value: card('VAT Bus. Posting Group') },
        { label: 'Payment Terms Code', value: optionLabel(paymentOptions?.paymentTerms, po.paymentTermsCode) },
        { label: 'Division Code', value: text(po.divisionCode) },
        { label: 'Department Code', value: text(po.departmentCode) },
        { label: 'Payment Discount %', value: card('Payment Discount %') },
        { label: 'Tax Exemption No.', value: card('Tax Exemption No.') },
        { label: 'Provincial Tax Area Code', value: card('Provincial Tax Area Code') },
        { label: 'Payment Method Code', value: optionLabel(paymentOptions?.paymentMethods, po.paymentMethodCode) },
        { label: 'Shipment Method Code', value: optionLabel(paymentOptions?.shipmentMethods, po.shipmentMethodCode) },
        { label: 'Payment Reference', value: card('Payment Reference') },
        { label: 'Creditor No.', value: card('Creditor No.') },
        { label: 'On Hold', value: card('On Hold') },
        { label: 'Requested Receipt Date', value: dateValue(bcDate(po.requiredByDate)) },
        { label: 'Promised Receipt Date', value: dateValue(bcDate(card('Promised Receipt Date'))) },
      ]
    : []
  // Invoice Details → Show more, as on the BC card.
  const poInvoiceMore: CardField[] = [
    { label: 'Pmt. Discount Date', value: dateValue(bcDate(card('Pmt. Discount Date'))) },
    { label: 'Tax Area Code', value: card('Tax Area Code') },
    { label: 'Tax Liable', value: yesNo(card('Tax Liable')) },
    { label: 'IRS 1099 Code', value: card('IRS 1099 Code') },
    { label: 'Remit-to Code', value: card('Remit-to Code') },
    { label: 'Journal Templ. Name', value: card('Journal Templ. Name') },
  ]
  const poInvoiceSpecs: Record<string, EditSpec> = po
    ? {
        'Expected Receipt Date': { key: 'expectedReceiptDate', kind: 'date', initial: isoDate(po.expectedReceiptDate) },
        'VAT Bus. Posting Group': cardSpec('VAT Bus. Posting Group', 'code'),
        // BC 1.0.3.594: payment / delivery details printed on the Purchase Order.
        'Payment Terms Code': optionSpec('paymentTermsCode', paymentOptions?.paymentTerms, po.paymentTermsCode),
        'Division Code': { key: 'divisionCode', kind: 'code', initial: text(po.divisionCode) },
        'Department Code': { key: 'departmentCode', kind: 'code', initial: text(po.departmentCode) },
        'Payment Discount %': cardSpec('Payment Discount %', 'number'),
        'Tax Exemption No.': cardSpec('Tax Exemption No.', 'text'),
        'Provincial Tax Area Code': cardSpec('Provincial Tax Area Code', 'code'),
        'Payment Method Code': optionSpec('paymentMethodCode', paymentOptions?.paymentMethods, po.paymentMethodCode),
        'Shipment Method Code': optionSpec('shipmentMethodCode', paymentOptions?.shipmentMethods, po.shipmentMethodCode),
        'Payment Reference': cardSpec('Payment Reference', 'text'),
        'Creditor No.': cardSpec('Creditor No.', 'text'),
        'On Hold': cardSpec('On Hold', 'code'),
        'Requested Receipt Date': { key: 'requiredByDate', kind: 'date', initial: isoDate(po.requiredByDate) },
        'Promised Receipt Date': cardSpec('Promised Receipt Date', 'date'),
        // Show more (BC 1.0.3.603).
        'Pmt. Discount Date': cardSpec('Pmt. Discount Date', 'date'),
        'Tax Area Code': cardSpec('Tax Area Code', 'code'),
        'Tax Liable': {
          key: 'Tax Liable',
          kind: 'boolean',
          initial: card('Tax Liable').toLowerCase() === 'true' ? 'true' : 'false',
        },
        'IRS 1099 Code': cardSpec('IRS 1099 Code', 'code'),
        'Remit-to Code': cardSpec('Remit-to Code', 'code'),
      }
    : {}
  // Shipping and Payment as on the BC card: ship-to (12) | pay-to (10).
  const poShipping: CardField[] = po
    ? [
        { label: 'Location Code', value: text(po.locationCode) || text(po.destinationStore) },
        { label: 'Ship-to Code', value: card('Ship-to Code') },
        { label: 'Ship-to Name', value: card('Ship-to Name') },
        { label: 'Ship-to Address', value: card('Ship-to Address') },
        { label: 'Ship-to Address 2', value: card('Ship-to Address 2') },
        { label: 'Ship-to City', value: card('Ship-to City') },
        { label: 'Ship-to County', value: card('Ship-to County') },
        { label: 'Ship-to Post Code', value: card('Ship-to Post Code') },
        { label: 'Ship-to Country/Region', value: card('Ship-to Country/Region Code') },
        { label: 'Ship-to Phone No.', value: card('Ship-to Phone No.') },
        { label: 'Inbound Whse. Handling Time', value: card('Inbound Whse. Handling Time') },
        { label: 'Lead Time Calculation', value: card('Lead Time Calculation') },
        { label: 'Pay-to Vendor No.', value: card('Pay-to Vendor No.') },
        { label: 'Pay-to Name', value: card('Pay-to Name') },
      ]
    : []
  // Shipping and Payment → Show more: the pay-to address.
  const poShippingMore: CardField[] = [
    { label: 'Pay-to Address', value: card('Pay-to Address') },
    { label: 'Pay-to Address 2', value: card('Pay-to Address 2') },
    { label: 'Pay-to City', value: card('Pay-to City') },
    { label: 'Pay-to County', value: card('Pay-to County') },
    { label: 'Pay-to Post Code', value: card('Pay-to Post Code') },
    { label: 'Pay-to Country/Region', value: card('Pay-to Country/Region Code') },
    { label: 'Pay-to Contact No.', value: card('Pay-to Contact No.') },
    { label: 'Pay-to Contact', value: card('Pay-to Contact') },
  ]
  const poShippingSpecs: Record<string, EditSpec> = po
    ? {
        'Location Code': { key: 'locationCode', kind: 'code', initial: text(po.locationCode) },
        'Ship-to Name': cardSpec('Ship-to Name', 'text'),
        'Ship-to Address': cardSpec('Ship-to Address', 'text'),
        'Ship-to Address 2': cardSpec('Ship-to Address 2', 'text'),
        'Ship-to City': cardSpec('Ship-to City', 'text'),
        'Ship-to County': cardSpec('Ship-to County', 'text'),
        'Ship-to Post Code': cardSpec('Ship-to Post Code', 'code'),
        'Ship-to Country/Region': cardSpec('Ship-to Country/Region Code', 'code'),
      }
    : {}
  // Foreign Trade, Prepayment and Electronic Invoice FastTabs of the BC card (BC 1.0.3.600).
  const poForeignTrade: CardField[] = [
    { label: 'Transaction Specification', value: card('Transaction Specification') },
    { label: 'Transaction Type', value: card('Transaction Type') },
    { label: 'Transport Method', value: card('Transport Method') },
    { label: 'Entry Point', value: card('Entry Point') },
    { label: 'Area', value: card('Area') },
  ]
  const poForeignTradeSpecs: Record<string, EditSpec> = Object.fromEntries(
    poForeignTrade.map((field) => [field.label, cardSpec(field.label, 'code')]),
  )
  const prepaymentPercent = card('Prepayment %') || '0'
  const poPrepayment: CardField[] = [
    { label: 'Prepayment %', value: prepaymentPercent },
    { label: 'Compress Prepayment', value: yesNo(card('Compress Prepayment')) },
    { label: 'Prepmt. Payment Terms Code', value: optionLabel(paymentOptions?.paymentTerms, card('Prepmt. Payment Terms Code')) },
    { label: 'Prepayment Due Date', value: dateValue(bcDate(card('Prepayment Due Date'))) },
    { label: 'Prepmt. Payment Discount %', value: card('Prepmt. Payment Discount %') },
    { label: 'Prepmt. Pmt. Discount Date', value: dateValue(bcDate(card('Prepmt. Pmt. Discount Date'))) },
    { label: 'Vendor Cr. Memo No.', value: card('Vendor Cr. Memo No.') },
  ]
  const poPrepaymentSpecs: Record<string, EditSpec> = {
    'Prepayment %': cardSpec('Prepayment %', 'number'),
    'Compress Prepayment': { key: 'Compress Prepayment', kind: 'boolean', initial: card('Compress Prepayment').toLowerCase() === 'true' ? 'true' : 'false' },
    'Prepmt. Payment Terms Code': optionSpec('Prepmt. Payment Terms Code', paymentOptions?.paymentTerms, card('Prepmt. Payment Terms Code')),
    'Prepayment Due Date': cardSpec('Prepayment Due Date', 'date'),
    'Prepmt. Payment Discount %': cardSpec('Prepmt. Payment Discount %', 'number'),
    'Prepmt. Pmt. Discount Date': cardSpec('Prepmt. Pmt. Discount Date', 'date'),
    'Vendor Cr. Memo No.': cardSpec('Vendor Cr. Memo No.', 'text'),
  }
  const poElectronicInvoice: CardField[] = [
    { label: 'Fiscal Invoice Number PAC', value: card('Fiscal Invoice Number PAC') },
  ]
  const poElectronicInvoiceSpecs: Record<string, EditSpec> = {
    'Fiscal Invoice Number PAC': cardSpec('Fiscal Invoice Number PAC', 'text'),
  }
  const savePoHeader = (changed: Record<string, string>) =>
    saveDoc('UPDATE_PO_HEADER', poNo, changed, `${poNo} saved in Business Central.`)

  return (
    <section className="space-y-4 text-sm text-slate-800">
      <LprCommentDialog
        open={commentAction !== null}
        title={
          commentAction?.actionCode === 'SELECT_WINNER_FAD' && changeWinnerTo
            ? `Change Winner (FAD) to ${changeWinnerTo}`
            : (commentAction?.label ?? '')
        }
        documentNo={commentAction?.documentNo ?? ''}
        label={
          commentAction?.actionCode === 'SUBMIT_TECHNICAL_REVIEW'
            ? 'Technical recommendation'
            : commentAction?.actionCode === 'SELECT_WINNER_FAD'
              ? 'Reason for changing the winner (your recommendation after the technical evaluation)'
            : commentAction && RETURN_ACTIONS.has(commentAction.actionCode)
              ? 'Reason (the Procurement Officer sees it)'
              : commentAction && !needsComment(commentAction)
                ? 'Comment (optional)'
                : 'Comment'
        }
        required={Boolean(commentAction && needsComment(commentAction))}
        value={actionComment}
        busy={busy}
        danger={Boolean(commentAction && RETURN_ACTIONS.has(commentAction.actionCode))}
        onChange={setActionComment}
        onCancel={() => setCommentAction(null)}
        onConfirm={() => {
          if (commentAction) void run(commentAction, { commented: true, linkedDocumentNo: commentLinkedNo })
        }}
      />
      <div className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
        <div className="flex flex-wrap items-end justify-between gap-2 px-4 pt-3">
          <div>
            <p className="text-xs text-slate-500">{cardTitle}</p>
            <h2 className="text-2xl font-semibold tracking-tight text-slate-900">{request.requestNo}</h2>
          </div>
          {flowStage ? (
            <span className="mb-1 rounded-full bg-teal-50 px-3 py-1 text-xs font-semibold text-teal-800 ring-1 ring-teal-200">
              {flowStage}
            </span>
          ) : null}
        </div>

        {/* BC ribbon: related card first, then the signed-in user's step(s). */}
        <div className="mt-3 flex flex-wrap items-center gap-2 border-y border-slate-100 bg-slate-50/70 px-4 py-2">
          {storeReqNo ? (
            <button
              type="button"
              onClick={() => setStoreCardOpen(true)}
              className="inline-flex items-center gap-1.5 rounded-md px-2 py-1.5 text-sm font-medium text-slate-800 transition hover:bg-teal-50"
            >
              <ClipboardList className="h-4 w-4 text-teal-600" aria-hidden="true" />
              Open Store Requisition
            </button>
          ) : null}
          {ribbon.map((action) => {
            const isReturn = RETURN_ACTIONS.has(action.actionCode)
            return (
              <Button
                key={`${action.actionCode}-${action.documentNo}`}
                type="button"
                size="sm"
                variant={isReturn || action.actionCode === 'FIX_LOCAL_CURRENCY' ? 'outline' : 'gradient'}
                className={isReturn ? 'border-red-300 text-red-700 hover:bg-red-50' : undefined}
                disabled={busy}
                onClick={() => void run(action)}
              >
                {action.label}
              </Button>
            )
          })}
        </div>

        <div className="space-y-3 px-4 py-3">
          {needsVendorInvoiceNo ? (
            <div className="max-w-md space-y-1.5">
              <Label htmlFor={`lpr-vendor-invoice-${request.id}`}>Vendor Invoice No.</Label>
              <Input
                id={`lpr-vendor-invoice-${request.id}`}
                value={vendorInvoiceNo}
                onChange={(event) => setVendorInvoiceNo(event.target.value)}
                placeholder="Number printed on the supplier invoice"
                disabled={busy}
              />
            </div>
          ) : null}
          {needsBank ? (
            <div className="max-w-md space-y-1.5">
              <Label htmlFor={`lpr-bank-${request.id}`}>Pay from bank account</Label>
              <Select
                id={`lpr-bank-${request.id}`}
                options={bankOptions}
                placeholder={bankQuery.isLoading ? 'Loading bank accounts…' : 'Choose the bank account'}
                value={bankAccountNo}
                onChange={(event) => setBankAccountNo(event.target.value)}
                disabled={busy || bankQuery.isLoading}
              />
              {bankQuery.isError ? (
                <p className="text-xs text-red-700">Could not load bank accounts from Business Central.</p>
              ) : null}
            </div>
          ) : null}

          {po?.lprClosed ? (
            <StatusNotice tone="success" className="">Paid and LPR closed.</StatusNotice>
          ) : ownStep ? (
            <StatusNotice tone="attention" className="">
              <p>Your step: {[...storeManagerSteps, ...ribbon].map((action) => action.label).join(' · ')}</p>
              {storeManagerSteps.length ? (
                <p className="mt-1 text-xs font-normal">
                  Purchase Order {poNo}: choose the receiving store, set up any new items, then Confirm Store (below the PO lines).
                </p>
              ) : null}
              {editHint}
              {processStep ? <p className="mt-1 text-xs font-normal">Process Step (BC): {processStep}</p> : null}
            </StatusNotice>
          ) : waiting.length > 0 ? (
            <StatusNotice tone="waiting" className="">
              {waiting.some((action) => action.actionCode === 'APPROVE_RFQ_OPS') ? (
                <p className="mb-1 font-semibold">
                  RFQ {rfqNo} is submitted to the Operations Manager. Nothing more to send.
                </p>
              ) : null}
              <p>
                Waiting for {[...new Set(waiting.map(ownerLabel))].join(' or ')}:{' '}
                {waiting.map((action) => action.label).join(' · ')}
              </p>
              {editHint}
              {processStep ? <p className="mt-1 text-xs font-normal">Process Step (BC): {processStep}</p> : null}
            </StatusNotice>
          ) : processStep || editHint ? (
            <StatusNotice tone="info" className="">
              {processStep ? <p>Process Step (BC): {processStep}</p> : null}
              {editHint}
            </StatusNotice>
          ) : null}
          {issueAfterLpr ? (
            <StatusNotice tone="success" className="">
              Goods received. Store Keeper: open Store Requisition {issueAfterLpr.documentNo} → Issue after LPR receive.
            </StatusNotice>
          ) : null}

          {relatedDocs.length > 1 ? (
            <div className="pt-1">
              <RelatedDocuments docs={relatedDocs} />
            </div>
          ) : null}
          {/* The chain's Approval History is at the bottom of the page (LprApprovalHistorySection). */}
        </div>
      </div>

      {/* A store LPR edits its lines in the Purchase Requisition Subform (LprLinesSubform). */}
      {updateLprLine && request.payload?.LocalPurchaseFromStore !== true ? (
        <LprDraftLineEditor
          lines={Array.isArray(request.payload?.lines) ? (request.payload.lines as Array<Record<string, unknown>>) : []}
          busy={busy}
          onSave={async (change) => {
            try {
              await actionMutation.mutateAsync({
                actionCode: 'UPDATE_LPR_LINE',
                documentNo: updateLprLine.documentNo,
                payload: change,
              })
              toast.success(`Line ${change.lineNo} saved on ${updateLprLine.documentNo}.`)
              return true
            } catch (error) {
              toast.error(error instanceof Error ? error.message : 'Could not save the LPR line', 'Save LPR line')
              return false
            }
          }}
        />
      ) : null}

      {lpr && !isThisLpr ? (
        <DocCard id="lpr-doc-lpr" title={`Purchase Requisition (LPR) ${lprNo}`}>
          <Field label="From Store Req" value={storeReqNo} />
          <Field label="LPR Status" value={text(lpr.lprStatus)} />
          <Field label="Status" value={text(lpr.status)} />
          <Field label="Project" value={text(lpr.projectNo)} />
          <Field
            label="Procurement Officer"
            value={[text(lpr.assignedProcUserId), text(lpr.procOfficerType)].filter(Boolean).join(' · ')}
          />
          <Field label="Operations Manager Approved By" value={text(lpr.opsApprovedBy)} />
          <Field label="FAD Approved By" value={text(lpr.fadApprovedBy)} />
          <Field label="FAD Approval Date" value={bcDate(lpr.fadApprovalDate)} />
          <Field label="Created RFQ No." value={text(lpr.createdRfqNo)} />
          <Field label="Destination Store" value={text(lpr.destinationStore)} />
        </DocCard>
      ) : null}

      {rfq ? (
        <ChainDocBlock id="lpr-doc-rfq">
          <LprPrintButtons
            lprRequestId={request.id}
            documents={[
              { kind: 'VENDOR_RFQ', label: 'Print Vendor RFQ', fileName: `Vendor-RFQ-${rfqNo}.pdf` },
              ...(quotes.length
                ? [{ kind: 'RFQ_ANALYSIS' as const, label: 'RFQ Response Analysis', fileName: `RFQ-Response-Analysis-${rfqNo}.pdf` }]
                : []),
            ]}
          />
          <EditableCardSection
            title={`Local RFQ ${rfqNo}`}
            fields={rfqFields}
            specs={rfqSpecs}
            canEdit={editing.rfq}
            showAll
            onSave={(changed) => saveDoc('UPDATE_RFQ_HEADER', rfqNo, changed, `${rfqNo} saved in Business Central.`)}
          />
          {rfqLines ? (
            <BcLinesTable
              title="Lines"
              lines={rfqLines}
              columns={ORDER_LINE_COLUMNS}
              docNo={rfqNo}
              editable={editing.rfq}
              busy={busy}
              totalHeader="Line Amount"
              onSave={(isNew, payload) =>
                saveDoc(isNew ? 'ADD_RFQ_LINE' : 'UPDATE_RFQ_LINE', rfqNo, payload, isNew ? `Line added to ${rfqNo}.` : `Line saved on ${rfqNo}.`)
              }
              onDelete={(line) => saveDoc('DELETE_RFQ_LINE', rfqNo, { lineNo: Number(line.lineNo) }, `Line deleted from ${rfqNo}.`)}
            />
          ) : null}
        </ChainDocBlock>
      ) : null}

      {poCurrency ? (
        <StatusNotice tone="attention" className="">
          Currency Code is {poCurrency} on this local PO. Local purchase must keep Currency Code blank — use Fix Local
          Currency.
        </StatusNotice>
      ) : null}
      {text(po?.sendBackComment || rfq?.sendBackComment) ? (
        <StatusNotice tone="warning" className="">
          Sent back: {text(po?.sendBackComment || rfq?.sendBackComment)}
        </StatusNotice>
      ) : null}

      {rfq ? (
        <VendorQuotesSection
          rfqNo={rfqNo}
          quotes={quotes}
          minQuotes={minQuotes}
          rfqLines={rfqLines ?? []}
          canEdit={canEditQuotes}
          canSelectWinner={fadSelectWinner}
          busy={busy}
          vendorOptions={vendorOptions}
          vendorsLoading={vendorQuery.isLoading}
          formId={`lpr-quote-${request.id}`}
          onSave={saveQuote}
          onAttach={(quote, file) => void attach(quote, file)}
          onDelete={deleteQuote}
          onSelectWinner={selectWinner}
        />
      ) : null}

      {po ? (
        <ChainDocBlock id="lpr-doc-po">
          {/* The BC Purchase Order card: title, General, Lines, totals, Invoice Details, Shipping and Payment. */}
          <div className="flex flex-wrap items-end justify-between gap-3">
            <div>
              <p className="text-xs text-slate-500">Purchase Order</p>
              <p className="text-xl font-semibold tracking-tight text-slate-900">
                {[poNo, text(po.vendorName)].filter(Boolean).join(' · ')}
              </p>
            </div>
            <LprPrintButtons
              lprRequestId={request.id}
              documents={[{ kind: 'PO', label: 'Print Purchase Order', fileName: `Purchase-Order-${poNo}.pdf` }]}
            />
          </div>
          <EditableCardSection
            title="General"
            fields={poGeneral}
            specs={poGeneralSpecs}
            canEdit={editing.po}
            showAll
            columns={[7, 9, 7]}
            more={poGeneralMore}
            collapsible
            summary={[text(po.vendorName), dateValue(bcDate(po.documentDate)), text(po.status)]}
            onSave={savePoHeader}
          />
          {poLines ? (
            <BcLinesTable
              title="Lines"
              lines={poLines}
              columns={poLineColumns(poLines)}
              docNo={poNo}
              editable={editing.po}
              busy={busy}
              showTotal={false}
              onSave={(isNew, payload) =>
                saveDoc(isNew ? 'ADD_PO_LINE' : 'UPDATE_PO_LINE', poNo, payload, isNew ? `Line added to ${poNo}.` : `Line saved on ${poNo}.`)
              }
              onDelete={(line) => saveDoc('DELETE_PO_LINE', poNo, { lineNo: Number(line.lineNo) }, `Line deleted from ${poNo}.`)}
            />
          ) : null}
          {poLines?.length ? (
            <EditableCardSection
              title="Totals"
              fields={poTotalFields}
              specs={poTotalSpecs}
              canEdit={editing.po}
              showAll
              columns={[2, 2, 2]}
              onSave={savePoHeader}
            />
          ) : null}
          {/* The Finance Checker may also correct the service G/L at the Finance review (BC 1.0.3.598). */}
          {(allowed('SET_SERVICE_GL') || (editing.po && isFinanceChecker)) && poLines ? (
            <PoServiceGlEditor
              poNo={poNo}
              lines={poLines}
              busy={busy}
              onSave={(lineNo, glAccountNo) =>
                saveDoc('SET_SERVICE_GL', poNo, { lineNo, glAccountNo }, `G/L ${glAccountNo} set on line ${lineNo} of ${poNo}.`)
              }
            />
          ) : null}
          {(allowed('ASSIGN_STORE') || allowed('CONFIRM_STORE')) && poLines ? (
            <PoAssignStore
              poNo={poNo}
              po={po}
              lines={poLines}
              busy={busy}
              onAction={(actionCode, payload, success) => saveDoc(actionCode, poNo, payload, success)}
              onSaveItem={(payload) =>
                saveDoc('SET_RECEIVE_ITEM', poNo, payload, `Item set on line ${String(payload.lineNo)} of ${poNo}.`)
              }
            />
          ) : null}
          {allowed('SET_RECEIVE_ITEM') && !allowed('ASSIGN_STORE') && poLines ? (
            <PoReceiveItemSetup
              poNo={poNo}
              lines={poLines}
              busy={busy}
              onSave={(payload) =>
                saveDoc('SET_RECEIVE_ITEM', poNo, payload, `Item set on line ${String(payload.lineNo)} of ${poNo}.`)
              }
            />
          ) : null}
          {editing.receive && poLines ? (
            <PoReceiveEditor
              poNo={poNo}
              lines={poLines}
              vendorShipmentNo={text(po.vendorShipmentNo)}
              busy={busy}
              onSave={(payload) => saveDoc('UPDATE_PO_RECEIVE', poNo, payload, `Receive quantities saved on ${poNo}.`)}
            />
          ) : null}
          <EditableCardSection
            title="Invoice Details"
            fields={poInvoiceDetails}
            specs={poInvoiceSpecs}
            canEdit={editing.po}
            showAll
            columns={[6, 7, 7]}
            more={poInvoiceMore}
            collapsible
            onSave={savePoHeader}
          />
          <EditableCardSection
            title="Shipping and Payment"
            fields={poShipping}
            specs={poShippingSpecs}
            canEdit={editing.po}
            showAll
            columns={[12, 2]}
            more={poShippingMore}
            collapsible
            defaultOpen={false}
            summary={[text(po.locationCode)]}
            onSave={savePoHeader}
          />
          <EditableCardSection
            title="Foreign Trade"
            fields={poForeignTrade}
            specs={poForeignTradeSpecs}
            canEdit={editing.po}
            showAll
            collapsible
            defaultOpen={false}
            onSave={savePoHeader}
          />
          <EditableCardSection
            title="Prepayment"
            fields={poPrepayment}
            specs={poPrepaymentSpecs}
            canEdit={editing.po}
            showAll
            collapsible
            defaultOpen={false}
            summary={[prepaymentPercent, dateValue(bcDate(card('Prepayment Due Date')))]}
            onSave={savePoHeader}
          />
          <EditableCardSection
            title="Electronic Invoice"
            fields={poElectronicInvoice}
            specs={poElectronicInvoiceSpecs}
            canEdit={editing.po}
            showAll
            collapsible
            defaultOpen={false}
            onSave={savePoHeader}
          />
          <EditableCardSection
            title="Local Purchase progress"
            fields={poProgress}
            specs={poProgressSpecs}
            canEdit={editing.po}
            showAll
            collapsible
            defaultOpen={false}
            summary={[text(po.opsApprovedBy), grnNos.join(', '), text(po.postedInvoiceNo || po.createdInvoiceNo)]}
            onSave={savePoHeader}
          />
        </ChainDocBlock>
      ) : null}

      {storeCardOpen && storeReqNo ? (
        <StoreRequisitionCardDialog
          lprRequestId={request.id}
          storeRequisitionNo={storeReqNo}
          storeRequest={state.chain.storeRequest as Record<string, unknown> | undefined}
          onClose={() => setStoreCardOpen(false)}
        />
      ) : null}
    </section>
  )
}
