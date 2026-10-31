import { useState, type ReactNode } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { ChevronRight, ClipboardList, FileText, PackageCheck, Pencil, Receipt, ShoppingCart, Trash2, Truck } from 'lucide-react'
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
  runLocalPurchaseAction,
  uploadLocalPurchaseQuoteAttachment,
  upsertLocalPurchaseVendorQuote,
  type LocalPurchaseNextAction,
  type LocalPurchaseVendorQuote,
} from '@/api/endpoints/requestEndpoint'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import { LookupCombobox } from '@/components/shared/LookupCombobox'
import { LprApprovalHistory } from '@/components/facility/LprApprovalHistory'
import { LprCommentDialog } from '@/components/facility/LprCommentDialog'
import { LprDraftLineEditor } from '@/components/facility/LprDraftLineEditor'
import type { PortalRequest } from '@/types/erp.types'
import { formatCurrency } from '@/utils/formatters'
import { readFileAsBase64 } from '@/utils/readFileAsBase64'
import { todayIsoDate } from '@/utils/validators'
import { StatusNotice } from '@/components/feedback/StatusNotice'
import { StoreRequisitionCardDialog } from '@/components/facility/StoreRequisitionCardDialog'
import type { CardField } from '@/components/facility/BcCard'
import { BcLinesTable } from '@/components/facility/BcLinesTable'
import { EditableCardSection, type EditSpec } from '@/components/facility/EditableCardSection'
import { PoReceiveEditor } from '@/components/facility/PoReceiveEditor'
import { PoReceiveItemSetup } from '@/components/facility/PoReceiveItemSetup'
import { PoServiceGlEditor } from '@/components/facility/PoServiceGlEditor'
import { dateValue } from '@/components/facility/bcCardValues'
import {
  ORDER_LINE_COLUMNS,
  RECEIVE_LINE_COLUMNS,
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
])
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

function RelatedDocuments({ docs }: { docs: RelatedDoc[] }) {
  return (
    <nav aria-label="Related documents" className="flex flex-wrap items-stretch gap-1.5">
      {docs.map((doc, index) => {
        const Icon = doc.icon
        const body = (
          <>
            <Icon className={cn('h-4 w-4 shrink-0', doc.current ? 'text-white' : 'text-teal-600')} aria-hidden="true" />
            <span className="min-w-0 text-left leading-tight">
              <span className={cn('block text-[11px]', doc.current ? 'text-teal-50' : 'text-slate-500')}>{doc.label}</span>
              <span className="block text-sm font-semibold">{doc.no}</span>
              {doc.state ? (
                <span className={cn('block text-[11px]', doc.current ? 'text-teal-50' : 'text-slate-500')}>{doc.state}</span>
              ) : null}
            </span>
          </>
        )
        const chip = cn(
          'flex items-center gap-2 rounded-lg border px-3 py-1.5 transition',
          doc.current
            ? 'border-[var(--portal-navy)] bg-[var(--portal-navy)] text-white shadow-sm'
            : 'border-slate-200 bg-white text-slate-800',
          doc.onOpen && 'hover:border-teal-400 hover:bg-teal-50',
        )
        return (
          <div key={doc.key} className="flex items-center gap-1.5">
            {index > 0 ? <ChevronRight className="h-4 w-4 shrink-0 text-slate-300" aria-hidden="true" /> : null}
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
  const [storeCardOpen, setStoreCardOpen] = useState(false)
  const [vendorInvoiceNo, setVendorInvoiceNo] = useState('')
  const [bankAccountNo, setBankAccountNo] = useState('')
  const [quoteForm, setQuoteForm] = useState<{
    lineNo?: number
    vendorNo: string
    quotedAmount: string
    leadTimeDays: string
    quoteDate: string
    notes: string
  }>({
    vendorNo: '',
    quotedAmount: '',
    leadTimeDays: '',
    quoteDate: todayIsoDate(),
    notes: '',
  })
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
  const waiting = nextActions.filter(
    (action) => !action.allowed && !['UPSERT_VENDOR_QUOTE', 'ISSUE_AFTER_LPR', 'UPDATE_LPR_LINE'].includes(action.actionCode),
  )
  const issueAfterLpr = nextActions.find((action) => action.actionCode === 'ISSUE_AFTER_LPR')
  const updateLprLine = nextActions.find((action) => action.actionCode === 'UPDATE_LPR_LINE' && action.allowed)
  const asksComment = (action: LocalPurchaseNextAction) =>
    Boolean(action.commentRequired) || action.actionCode === 'SUBMIT_TECHNICAL_REVIEW'
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
      setCommentAction(action)
      return
    }
    const comment = extra.commented ? actionComment.trim() : ''
    if (asksComment(action) && !comment) return
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
            : resultNo && resultNo !== action.documentNo
            ? `${action.label} — ${resultNo}`
            : `${action.label} completed.`,
      )
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Action failed', action.label)
    }
  }

  const saveQuote = async () => {
    const vendorNo = quoteForm.vendorNo.trim()
    const quotedAmount = Number(quoteForm.quotedAmount.replace(/,/g, ''))
    const leadTimeDays = Number(quoteForm.leadTimeDays || 0)
    if (!vendorNo) {
      toast.error('Vendor No. is required.', 'Vendor quote')
      return
    }
    if (!Number.isFinite(quotedAmount) || quotedAmount <= 0) {
      toast.error('Quoted Amount must be greater than zero.', 'Vendor quote')
      return
    }
    try {
      await quoteMutation.mutateAsync({
        rfqNo,
        vendorNo,
        quotedAmount,
        leadTimeDays: Number.isFinite(leadTimeDays) ? leadTimeDays : 0,
        quoteDate: quoteForm.quoteDate,
        notes: quoteForm.notes.trim(),
        ...(quoteForm.lineNo ? { lineNo: quoteForm.lineNo } : {}),
      })
      setQuoteForm({ vendorNo: '', quotedAmount: '', leadTimeDays: '', quoteDate: todayIsoDate(), notes: '' })
      toast.success(
        quoteForm.lineNo
          ? `Vendor quote for ${vendorNo} saved.`
          : `Vendor quote saved for ${vendorNo}. Attach the quote file before Auto Select Winner.`,
      )
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Could not save the vendor quote', 'Vendor quote')
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

  const editQuote = (quote: LocalPurchaseVendorQuote) =>
    setQuoteForm({
      lineNo: quote.lineNo,
      vendorNo: quote.vendorNo,
      quotedAmount: String(quote.quotedAmount ?? ''),
      leadTimeDays: String(quote.leadTimeDays ?? ''),
      quoteDate: bcDate(quote.quoteDate).slice(0, 10) || todayIsoDate(),
      notes: quote.notes ?? '',
    })

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
    if (!yes) return
    if (await saveDoc('DELETE_VENDOR_QUOTE', rfqNo, { lineNo: quote.lineNo }, `Quote from ${name} deleted.`)) {
      if (quoteForm.lineNo === quote.lineNo) {
        setQuoteForm({ vendorNo: '', quotedAmount: '', leadTimeDays: '', quoteDate: todayIsoDate(), notes: '' })
      }
    }
  }

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

  // Purchase Order card: General, Invoice / payment progress of the local purchase.
  const poFields: CardField[] = po
    ? [
        { label: 'No.', value: poNo, emphasis: 'strong' },
        { label: 'Process Step', value: text(po.processStep), emphasis: 'strong' },
        { label: 'Full Flow Stage', value: text(po.flowStage) },
        { label: 'Vendor No.', value: text(po.vendorNo) },
        { label: 'Vendor Name', value: text(po.vendorName), emphasis: 'user' },
        { label: 'Request Description', value: text(po.requestSummary) },
        { label: 'Document Date', value: dateValue(bcDate(po.documentDate)) },
        { label: 'Order Date', value: dateValue(bcDate(po.orderDate)) },
        { label: 'Requested Receipt Date', value: dateValue(bcDate(po.requiredByDate)) },
        { label: 'Expected Receipt Date', value: dateValue(bcDate(po.expectedReceiptDate)) },
        { label: 'Vendor Order No.', value: text(po.vendorOrderNo) },
        { label: 'Vendor Shipment No.', value: text(po.vendorShipmentNo) },
        { label: 'Location Code', value: text(po.locationCode) || text(po.destinationStore) },
        {
          label: 'Amount Incl. VAT',
          value: Number(po.amountIncludingVat ?? 0) > 0 ? formatCurrency(Number(po.amountIncludingVat)) : '',
          emphasis: 'strong',
        },
        { label: 'Currency Code', value: poCurrency || 'Blank (local ETB)' },
        { label: 'Operations Manager Approved PO', value: text(po.opsApprovedBy), emphasis: 'user' },
        { label: 'FAD Approved PO', value: po.fadPoApproved ? 'Yes' : 'No' },
        { label: 'GRN', value: grnNos.join(', ') },
        { label: 'Invoice', value: invoiceNo },
        { label: 'Invoice Checked By (Operations Manager)', value: text(po.opsInvoiceCheckedBy), emphasis: 'user' },
        { label: 'Invoice Verified (Finance)', value: po.invoiceVerified ? 'Yes' : 'No' },
        { label: 'Payment Approved (F&A)', value: po.ceoPayApproved ? 'Yes' : 'No' },
        { label: 'Paid From Bank', value: text(po.paymentBankNo) },
        { label: 'Payment Voucher', value: text(po.paymentDocNo) },
        { label: 'LPR Closed', value: po.lprClosed ? 'Yes' : 'No' },
        { label: 'Send Back Comment', value: text(po.sendBackComment) },
      ]
    : []
  const poSpecs: Record<string, EditSpec> = po
    ? {
        'Request Description': { key: 'requestSummary', kind: 'text', initial: text(po.requestSummary) },
        'Document Date': { key: 'documentDate', kind: 'date', initial: isoDate(po.documentDate) },
        'Order Date': { key: 'orderDate', kind: 'date', initial: isoDate(po.orderDate) },
        'Requested Receipt Date': { key: 'requiredByDate', kind: 'date', initial: isoDate(po.requiredByDate) },
        'Expected Receipt Date': { key: 'expectedReceiptDate', kind: 'date', initial: isoDate(po.expectedReceiptDate) },
        'Vendor Order No.': { key: 'vendorOrderNo', kind: 'text', initial: text(po.vendorOrderNo) },
        'Vendor Shipment No.': { key: 'vendorShipmentNo', kind: 'text', initial: text(po.vendorShipmentNo) },
        'Location Code': { key: 'locationCode', kind: 'code', initial: text(po.locationCode) },
      }
    : {}

  return (
    <section className="space-y-4 text-sm text-slate-800">
      <LprCommentDialog
        open={commentAction !== null}
        title={commentAction?.label ?? ''}
        documentNo={commentAction?.documentNo ?? ''}
        label={
          commentAction?.actionCode === 'SUBMIT_TECHNICAL_REVIEW'
            ? 'Technical recommendation'
            : commentAction && RETURN_ACTIONS.has(commentAction.actionCode)
              ? 'Reason (the Procurement Officer sees it)'
              : 'Comment'
        }
        value={actionComment}
        busy={busy}
        danger={Boolean(commentAction && RETURN_ACTIONS.has(commentAction.actionCode))}
        onChange={setActionComment}
        onCancel={() => setCommentAction(null)}
        onConfirm={() => {
          if (commentAction) void run(commentAction, { commented: true })
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
          ) : ribbon.length > 0 ? (
            <StatusNotice tone="attention" className="">
              <p>Your step: {ribbon.map((action) => action.label).join(' · ')}</p>
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
            <div className="space-y-1.5 pt-1">
              <p className="text-[11px] font-semibold uppercase tracking-wide text-slate-500">Related documents</p>
              <RelatedDocuments docs={relatedDocs} />
            </div>
          ) : null}
          <LprApprovalHistory entries={state.chain.approvalHistory} />
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
        <div className="space-y-2">
          <p className="font-semibold text-[var(--portal-navy)]">
            Vendor Quotes (Local RFQ)
            <span className="ml-2 text-xs font-normal text-slate-600">
              {quotes.length} received{minQuotes ? ` · minimum ${minQuotes}` : ''}
            </span>
          </p>
          <div className="overflow-x-auto rounded-md border border-teal-100 bg-white/70">
            <table className="min-w-full text-xs">
              <thead className="bg-teal-50 text-left text-slate-600">
                <tr>
                  <th className="px-3 py-2 font-medium">Vendor No.</th>
                  <th className="px-3 py-2 font-medium">Vendor</th>
                  <th className="px-3 py-2 text-right font-medium">Quoted Amount</th>
                  <th className="px-3 py-2 text-right font-medium">Lead Time (Days)</th>
                  <th className="px-3 py-2 font-medium">Quote Received Date</th>
                  <th className="px-3 py-2 font-medium">Attachments</th>
                  <th className="px-3 py-2 font-medium">Winner</th>
                  {canEditQuotes ? <th className="px-3 py-2" aria-label="Quote actions" /> : null}
                </tr>
              </thead>
              <tbody>
                {quotes.length === 0 ? (
                  <tr>
                    <td colSpan={canEditQuotes ? 8 : 7} className="px-3 py-3 text-slate-500">
                      No vendor quotes yet.
                    </td>
                  </tr>
                ) : null}
                {quotes.map((quote) => (
                  <tr key={quote.lineNo} className={`border-t border-teal-50 ${quote.selected ? 'bg-teal-50' : ''}`}>
                    <td className="px-3 py-2">{quote.vendorNo}</td>
                    <td className="px-3 py-2">
                      {quote.vendorName}
                      {quote.notes ? <span className="block text-slate-500">{quote.notes}</span> : null}
                    </td>
                    <td className="px-3 py-2 text-right">{formatCurrency(Number(quote.quotedAmount ?? 0))}</td>
                    <td className="px-3 py-2 text-right">{quote.leadTimeDays}</td>
                    <td className="px-3 py-2">{bcDate(quote.quoteDate)}</td>
                    <td className="px-3 py-2">
                      <span className={quote.attachments > 0 ? 'text-teal-800' : 'font-medium text-red-700'}>
                        {quote.attachments > 0 ? `${quote.attachments} file(s)` : 'Missing'}
                      </span>
                      {canEditQuotes ? (
                        <label className="ml-2 cursor-pointer text-[var(--portal-navy)] underline">
                          Attach
                          <input
                            type="file"
                            className="sr-only"
                            accept=".pdf,.doc,.docx,.jpg,.png"
                            disabled={busy}
                            onChange={(event) => {
                              void attach(quote, event.target.files?.[0])
                              event.target.value = ''
                            }}
                          />
                        </label>
                      ) : null}
                    </td>
                    <td className="px-3 py-2">
                      {quote.selected ? <strong className="text-teal-800">Selected</strong> : null}
                      {!quote.selected && fadSelectWinner ? (
                        <Button
                          type="button"
                          variant="outline"
                          size="sm"
                          disabled={busy}
                          onClick={() => selectWinner(quote)}
                        >
                          Select as Winner (FAD)
                        </Button>
                      ) : null}
                    </td>
                    {canEditQuotes ? (
                      <td className="whitespace-nowrap px-2 py-1 text-right">
                        <Button
                          type="button"
                          size="sm"
                          variant="ghost"
                          disabled={busy}
                          onClick={() => editQuote(quote)}
                          aria-label={`Edit quote from ${quote.vendorName || quote.vendorNo}`}
                        >
                          <Pencil className="h-4 w-4" />
                        </Button>
                        <Button
                          type="button"
                          size="sm"
                          variant="ghost"
                          className="text-red-600 hover:bg-red-50"
                          disabled={busy}
                          onClick={() => void deleteQuote(quote)}
                          aria-label={`Delete quote from ${quote.vendorName || quote.vendorNo}`}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </td>
                    ) : null}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          {canEditQuotes ? (
            <div
              className={cn(
                'grid grid-cols-1 gap-2 rounded-md border bg-white/70 p-3 sm:grid-cols-3 lg:grid-cols-6',
                quoteForm.lineNo ? 'border-teal-300 bg-teal-50/50' : 'border-teal-100',
              )}
            >
              {quoteForm.lineNo ? (
                <p className="text-sm font-semibold text-slate-900 sm:col-span-3 lg:col-span-6">Edit the quote from {quoteForm.vendorNo}</p>
              ) : null}
              <div className="space-y-1 sm:col-span-3 lg:col-span-2">
                <Label htmlFor={`lpr-quote-vendor-${request.id}`}>Vendor No.</Label>
                <LookupCombobox
                  id={`lpr-quote-vendor-${request.id}`}
                  options={vendorOptions}
                  loading={vendorQuery.isLoading}
                  emptyText="Vendor list not available from Business Central. Type the exact Vendor No.; BC checks it on save."
                  value={quoteForm.vendorNo}
                  onChange={(vendorNo) => setQuoteForm((current) => ({ ...current, vendorNo }))}
                  placeholder="Type vendor no. or name"
                  disabled={busy || Boolean(quoteForm.lineNo)}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor={`lpr-quote-amount-${request.id}`}>Quoted Amount</Label>
                <Input
                  id={`lpr-quote-amount-${request.id}`}
                  inputMode="decimal"
                  value={quoteForm.quotedAmount}
                  onChange={(event) => setQuoteForm({ ...quoteForm, quotedAmount: event.target.value })}
                  disabled={busy}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor={`lpr-quote-lead-${request.id}`}>Lead Time (Days)</Label>
                <Input
                  id={`lpr-quote-lead-${request.id}`}
                  inputMode="numeric"
                  value={quoteForm.leadTimeDays}
                  onChange={(event) => setQuoteForm({ ...quoteForm, leadTimeDays: event.target.value })}
                  disabled={busy}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor={`lpr-quote-date-${request.id}`}>Quote Received Date</Label>
                <Input
                  id={`lpr-quote-date-${request.id}`}
                  type="date"
                  value={quoteForm.quoteDate}
                  onChange={(event) => setQuoteForm({ ...quoteForm, quoteDate: event.target.value })}
                  disabled={busy}
                />
              </div>
              <div className="space-y-1">
                <Label htmlFor={`lpr-quote-notes-${request.id}`}>Notes</Label>
                <Input
                  id={`lpr-quote-notes-${request.id}`}
                  value={quoteForm.notes}
                  onChange={(event) => setQuoteForm({ ...quoteForm, notes: event.target.value })}
                  disabled={busy}
                />
              </div>
              <div className="flex gap-2 sm:col-span-3 lg:col-span-6">
                {quoteForm.lineNo ? (
                  <Button
                    type="button"
                    variant="outline"
                    disabled={busy}
                    onClick={() =>
                      setQuoteForm({ vendorNo: '', quotedAmount: '', leadTimeDays: '', quoteDate: todayIsoDate(), notes: '' })
                    }
                  >
                    Cancel
                  </Button>
                ) : null}
                <Button type="button" variant={quoteForm.lineNo ? 'gradient' : 'outline'} disabled={busy} onClick={() => void saveQuote()}>
                  {quoteForm.lineNo ? 'Save changes' : 'Save vendor quote'}
                </Button>
              </div>
            </div>
          ) : null}
        </div>
      ) : null}

      {po ? (
        <ChainDocBlock id="lpr-doc-po">
          <EditableCardSection
            title={`Purchase Order ${poNo}`}
            fields={poFields}
            specs={poSpecs}
            canEdit={editing.po}
            showAll
            onSave={(changed) => saveDoc('UPDATE_PO_HEADER', poNo, changed, `${poNo} saved in Business Central.`)}
          />
          {poLines ? (
            <BcLinesTable
              title="Lines"
              lines={poLines}
              columns={[...ORDER_LINE_COLUMNS, ...RECEIVE_LINE_COLUMNS]}
              docNo={poNo}
              editable={editing.po}
              busy={busy}
              totalHeader="Line Amount"
              onSave={(isNew, payload) =>
                saveDoc(isNew ? 'ADD_PO_LINE' : 'UPDATE_PO_LINE', poNo, payload, isNew ? `Line added to ${poNo}.` : `Line saved on ${poNo}.`)
              }
              onDelete={(line) => saveDoc('DELETE_PO_LINE', poNo, { lineNo: Number(line.lineNo) }, `Line deleted from ${poNo}.`)}
            />
          ) : null}
          {allowed('SET_SERVICE_GL') && poLines ? (
            <PoServiceGlEditor
              poNo={poNo}
              lines={poLines}
              busy={busy}
              onSave={(lineNo, glAccountNo) =>
                saveDoc('SET_SERVICE_GL', poNo, { lineNo, glAccountNo }, `G/L ${glAccountNo} set on line ${lineNo} of ${poNo}.`)
              }
            />
          ) : null}
          {allowed('SET_RECEIVE_ITEM') && poLines ? (
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
