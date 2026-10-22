import { useState, type ReactNode } from 'react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useToast } from '@/components/feedback/ToastProvider'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select } from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import {
  getLocalPurchaseBankAccounts,
  getLocalPurchaseState,
  runLocalPurchaseAction,
  uploadLocalPurchaseQuoteAttachment,
  upsertLocalPurchaseVendorQuote,
  type LocalPurchaseNextAction,
  type LocalPurchaseVendorQuote,
} from '@/api/endpoints/requestEndpoint'
import { useLocalPurchaseAccess } from '@/hooks/useLocalPurchaseAccess'
import { LprDraftLineEditor } from '@/components/facility/LprDraftLineEditor'
import type { PortalRequest } from '@/types/erp.types'
import { formatCurrency } from '@/utils/formatters'
import { readFileAsBase64 } from '@/utils/readFileAsBase64'
import { todayIsoDate } from '@/utils/validators'
import { StatusNotice } from '@/components/feedback/StatusNotice'

/** Actions rendered inline (quote form / quote rows / Store Req) instead of the ribbon. */
const INLINE_ACTIONS = new Set(['UPSERT_VENDOR_QUOTE', 'SELECT_WINNER_FAD', 'ISSUE_AFTER_LPR', 'UPDATE_LPR_LINE'])
const RETURN_ACTIONS = new Set(['REJECT_LPR', 'SEND_BACK_RFQ', 'SEND_BACK_PO'])

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

function DocCard({ title, children }: { title: string; children: ReactNode }) {
  return (
    <div className="rounded-md border border-teal-100 bg-white/70 p-3">
      <p className="text-xs font-semibold uppercase tracking-wide text-[var(--portal-navy)]">{title}</p>
      <dl className="mt-2 grid grid-cols-1 gap-2 sm:grid-cols-2">{children}</dl>
    </div>
  )
}

/**
 * Local Purchase (LPR -> RFQ -> PO) on the Purchase Requisition card: mirrors the BC Local RFQ
 * steps ribbon. Renders the 1.0.3.382 purchase panel (`fallback`) unchanged when Local Purchase
 * is not live in BC yet, or when the document is not a Local LPR.
 */
export function LocalPurchasePanel({ request, fallback }: { request: PortalRequest; fallback: ReactNode }) {
  const toast = useToast()
  const confirm = useConfirm()
  const queryClient = useQueryClient()
  const [actionComment, setActionComment] = useState('')
  const [vendorInvoiceNo, setVendorInvoiceNo] = useState('')
  const [bankAccountNo, setBankAccountNo] = useState('')
  const [quoteForm, setQuoteForm] = useState({
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
  const needsComment = ribbon.some(
    (action) => action.commentRequired || action.actionCode === 'SUBMIT_TECHNICAL_REVIEW',
  )
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

  const run = async (action: LocalPurchaseNextAction, extra: { linkedDocumentNo?: string } = {}) => {
    const comment = actionComment.trim()
    if ((action.commentRequired || action.actionCode === 'SUBMIT_TECHNICAL_REVIEW') && !comment) {
      toast.error(
        action.actionCode === 'SUBMIT_TECHNICAL_REVIEW'
          ? 'Write the technical recommendation before submitting.'
          : 'Enter a reason before sending this back.',
        'Comment required',
      )
      return
    }
    if (action.actionCode === 'CREATE_LOCAL_INVOICE' && !vendorInvoiceNo.trim()) {
      toast.error('Enter the real Vendor Invoice No. from the supplier invoice.', 'Vendor Invoice No. required')
      return
    }
    if (action.actionCode === 'CLOSE_LPR_AFTER_PAYMENT' && !bankAccountNo) {
      toast.error('Choose the bank account this payment is made from.', 'Bank account required')
      return
    }
    const yes = await confirm({
      title: action.label,
      message:
        action.actionCode === 'CLOSE_LPR_AFTER_PAYMENT'
          ? `${action.label} on ${action.documentNo} from bank ${bankAccountNo}?`
          : `${action.label} on ${action.documentNo}?`,
      confirmLabel: action.label,
    })
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
      setVendorInvoiceNo('')
      setBankAccountNo('')
      const resultNo = text(response.result?.resultNo)
      toast.success(resultNo && resultNo !== action.documentNo ? `${action.label} — ${resultNo}` : `${action.label} completed.`)
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
      })
      setQuoteForm({ vendorNo: '', quotedAmount: '', leadTimeDays: '', quoteDate: todayIsoDate(), notes: '' })
      toast.success(`Vendor quote saved for ${vendorNo}. Attach the quote file before Auto Select Winner.`)
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

  const selectWinner = (quote: LocalPurchaseVendorQuote) => {
    const action = nextActions.find((row) => row.actionCode === 'SELECT_WINNER_FAD')
    if (action) void run(action, { linkedDocumentNo: String(quote.lineNo) })
  }

  return (
    <section className="space-y-4 rounded-lg border border-teal-200 bg-teal-50/80 p-4 text-sm text-slate-800">
      <div>
        <p className="font-semibold text-[var(--portal-navy)]">Local Purchase (LPR -&gt; RFQ -&gt; PO)</p>
        <p className="mt-1 text-slate-600">
          Full Flow Stage: <strong>{text(po?.flowStage) || text(rfq?.flowStage) || text(lpr?.flowStage)}</strong>
          {text(po?.processStep || rfq?.processStep || lpr?.processStep)
            ? ` · Process Step: ${text(po?.processStep || rfq?.processStep || lpr?.processStep)}`
            : ''}
        </p>
      </div>

      <div className="grid grid-cols-1 gap-3 lg:grid-cols-2">
        {lpr ? (
          <DocCard title={`Purchase Requisition (LPR) ${text(lpr.no)}`}>
            <Field label="From Store Req" value={text(state.chain.storeRequisitionNo)} />
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
          <DocCard title={`Local RFQ ${rfqNo}`}>
            <Field label="From LPR No." value={text(rfq.fromLprNo)} />
            <Field label="Full Flow Stage" value={text(rfq.flowStage)} />
            <Field label="RFQ Approved By (Operations Manager)" value={text(rfq.opsRfqApprovedBy)} />
            <Field label="Quote Due Date" value={bcDate(rfq.quoteDueDate)} />
            <Field label="Minimum Quotes Required" value={minQuotes || ''} />
            <Field label="Selected Vendor" value={text(rfq.selectedVendorNo)} />
            <Field label="Vendor Selection Reason" value={text(rfq.selectionReason)} />
            <Field label="Evaluation Reviewed By (Operations Manager)" value={text(rfq.opsEvalReviewedBy)} />
            <Field label="FAD Final Approved By" value={text(rfq.fadFinalBy)} />
            <Field label="Created PO No." value={text(rfq.createdPoNo)} />
          </DocCard>
        ) : null}
        {po ? (
          <DocCard title={`Purchase Order ${text(po.no)}`}>
            <Field label="Full Flow Stage" value={text(po.flowStage)} />
            <Field label="Vendor" value={text(po.vendorName) || text(po.vendorNo)} />
            <Field
              label="Amount Incl. VAT"
              value={Number(po.amountIncludingVat ?? 0) > 0 ? formatCurrency(Number(po.amountIncludingVat)) : ''}
            />
            <Field label="Currency Code" value={poCurrency || 'Blank (local ETB)'} />
            <Field label="Location" value={text(po.locationCode) || text(po.destinationStore)} />
            <Field label="Operations Manager Approved PO" value={text(po.opsApprovedBy)} />
            <Field label="FAD Approved PO" value={po.fadPoApproved ? 'Yes' : ''} />
            <Field label="GRN" value={receipts.map((row) => text(row.no)).filter(Boolean).join(', ')} />
            <Field label="Invoice" value={text(po.postedInvoiceNo) || text(po.createdInvoiceNo)} />
            <Field label="Invoice Checked By (Operations Manager)" value={text(po.opsInvoiceCheckedBy)} />
            <Field label="Invoice Verified (Finance)" value={po.invoiceVerified ? 'Yes' : ''} />
            <Field label="Payment Approved (F&A)" value={po.ceoPayApproved ? 'Yes' : ''} />
            <Field label="Paid From Bank" value={text(po.paymentBankNo)} />
            <Field label="Payment Voucher" value={text(po.paymentDocNo)} />
            <Field label="LPR Closed" value={po.lprClosed ? 'Yes' : ''} />
          </DocCard>
        ) : null}
      </div>

      {poCurrency ? (
        <StatusNotice tone="attention" className="">
          Currency Code is {poCurrency} on this local PO. Local purchase must keep Currency Code blank — use Fix Local
          Currency.
        </StatusNotice>
      ) : null}
      {technicalComment ? (
        <p className="rounded-md border border-teal-100 bg-white/70 px-3 py-2">
          <span className="text-xs text-slate-500">Technical Recommendation</span>
          <br />
          {technicalComment}
          {text(rfq?.techReviewedBy) ? ` — ${text(rfq?.techReviewedBy)}` : ''}
        </p>
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
                </tr>
              </thead>
              <tbody>
                {quotes.length === 0 ? (
                  <tr>
                    <td colSpan={7} className="px-3 py-3 text-slate-500">
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
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          {canEditQuotes ? (
            <div className="grid grid-cols-1 gap-2 rounded-md border border-teal-100 bg-white/70 p-3 sm:grid-cols-5">
              <div className="space-y-1">
                <Label htmlFor={`lpr-quote-vendor-${request.id}`}>Vendor No.</Label>
                <Input
                  id={`lpr-quote-vendor-${request.id}`}
                  value={quoteForm.vendorNo}
                  onChange={(event) => setQuoteForm({ ...quoteForm, vendorNo: event.target.value })}
                  placeholder="ABH-VEN000001"
                  disabled={busy}
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
              <div className="sm:col-span-5">
                <Button type="button" variant="outline" disabled={busy} onClick={() => void saveQuote()}>
                  Save vendor quote
                </Button>
              </div>
            </div>
          ) : null}
        </div>
      ) : null}

      {updateLprLine ? (
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

      {ribbon.length > 0 ? (
        <div className="space-y-3">
          {needsComment ? (
            <div className="max-w-2xl space-y-1.5">
              <Label htmlFor={`lpr-action-comment-${request.id}`}>
                {ribbon.some((action) => action.actionCode === 'SUBMIT_TECHNICAL_REVIEW')
                  ? 'Technical Recommendation'
                  : 'Comment (required to reject / send back)'}
              </Label>
              <Textarea
                id={`lpr-action-comment-${request.id}`}
                value={actionComment}
                onChange={(event) => setActionComment(event.target.value)}
                rows={2}
                className="min-h-16"
                disabled={busy}
              />
            </div>
          ) : null}
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
          <div className="flex flex-wrap gap-2">
            {ribbon.map((action) => {
              const isReturn = RETURN_ACTIONS.has(action.actionCode)
              return (
                <Button
                  key={`${action.actionCode}-${action.documentNo}`}
                  type="button"
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
        </div>
      ) : null}

      {issueAfterLpr ? (
        <StatusNotice tone="success" className="">
          Goods received. Store Keeper: open Store Requisition {issueAfterLpr.documentNo} → Issue after LPR receive.
        </StatusNotice>
      ) : null}
      {ribbon.length === 0 && waiting.length > 0 ? (
        <StatusNotice tone="waiting" className="">
          Waiting for {[...new Set(waiting.map(ownerLabel))].join(' or ')}:{' '}
          {waiting.map((action) => action.label).join(' · ')}
        </StatusNotice>
      ) : null}
      {po?.lprClosed ? <StatusNotice tone="success" className="">Paid and LPR closed.</StatusNotice> : null}
    </section>
  )
}
