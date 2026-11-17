import { useQuery } from '@tanstack/react-query'
import { Link } from 'react-router-dom'
import { CheckCircle2, Circle, HandCoins, Info, XCircle } from 'lucide-react'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { AdvanceSettlementProcessBanner } from '@/components/finance/AdvanceSettlementProcessBanner'
import { AdvanceOutstandingNotice } from '@/components/finance/AdvanceOutstandingNotice'
import { settleByText } from '@/api/endpoints/advanceOutstanding'
import { AdvanceSettlementSections } from '@/pages/finance/AdvanceSettlementPanel'
import { settlementSubmitProblem } from '@/hooks/useAdvanceSettlementContext'
import { fetchAdvanceSettlementContext } from '@/api/endpoints/advanceSettlement'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { imprestSurrenderHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { useConfirm } from '@/components/feedback/ConfirmProvider'
import { useConfirmAdvanceReceipt } from '@/hooks/useConfirmAdvanceReceipt'
import type { PortalRequest } from '@/types/erp.types'

const module = { module: 'imprestSurrender', entity: 'selfServiceImprestSurrenders' } as const
const imprestModule = { module: 'imprest', entity: 'selfServiceImprestRequests' } as const

function firstValue(source: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = source[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return value
  }
  return undefined
}

function isPosted(row: PortalRequest) {
  const payload = row.payload ?? {}
  const posted = payload.Posted ?? payload.posted
  const datePosted = String(
    firstValue(payload, ['DatePosted', 'Date_Posted', 'PostedDate', 'Date Posted']) ?? '',
  )
  const hasPostingDate = Boolean(datePosted) && !datePosted.startsWith('0001-01-01')
  return (
    row.status === 'Posted' ||
    posted === true ||
    ['true', 'yes', '1'].includes(String(posted).toLowerCase()) ||
    hasPostingDate
  )
}

function isFullySurrendered(row: PortalRequest) {
  const surrenderStatus = String(
    firstValue(row.payload ?? {}, ['SurrenderStatus', 'Surrender_Status']) ?? '',
  ).toLowerCase()
  return (
    surrenderStatus === 'full' ||
    surrenderStatus === 'fully surrendered' ||
    surrenderStatus === 'complete'
  )
}

/** Hijra ESS: posted imprest that is not fully surrendered. ABH also accepts Approved when Posted is missing from status mapping. */
function isSurrenderableImprest(row: PortalRequest) {
  if (isFullySurrendered(row)) return false
  const blocked = ['Draft', 'Pending Approval', 'Rejected', 'Cancelled', 'Canceled']
  if (blocked.includes(row.status)) return false
  return isPosted(row) || row.status === 'Approved'
}

/** ESSP spec section 3 supporting documents for a settlement. */
const SETTLEMENT_ATTACHMENT_CATEGORIES = [
  { label: 'Expense receipt / invoice', value: 'Expense receipt / invoice' },
  { label: 'Refund payment receipt', value: 'Refund payment receipt' },
  { label: 'Justification for exceeding', value: 'Justification for exceeding' },
  { label: 'Other supporting document', value: 'Other supporting document' },
]

function truthyFlag(value: unknown) {
  return value === true || ['true', 'yes', '1'].includes(String(value ?? '').toLowerCase())
}

/** BC pays an advance through Payment Schedule posting (Fully Paid when the whole amount is paid) or posts it. */
function isPaid(row: PortalRequest) {
  const payload = row.payload ?? {}
  return truthyFlag(payload.FullyPaid ?? payload.Fully_Paid) || isPosted(row)
}

function receiptConfirmed(row: PortalRequest) {
  const payload = row.payload ?? {}
  return truthyFlag(payload.ReceiptConfirmed ?? payload.Receipt_Confirmed)
}

/** Why one of the employee's approved advances is not in BC's settleable list. */
function notSettleableReason(row: PortalRequest, withReceipt: boolean, receiptAfterApproval: boolean) {
  // BC 1.0.3.662: the requester confirms first (right after approval), then Finance's payment must be in BC.
  if (withReceipt && receiptAfterApproval && !receiptConfirmed(row)) return 'confirm payment received first'
  if (!isPaid(row)) return receiptAfterApproval ? 'received, Finance has not recorded the payment yet' : 'approved, not paid yet'
  if (withReceipt && !receiptConfirmed(row)) return 'paid, confirm payment received first'
  return 'a settlement is already open'
}

type PrerequisiteState = 'met' | 'unmet' | 'open'

function PrerequisiteItem({ state, children }: { state: PrerequisiteState; children: string }) {
  const icon =
    state === 'met' ? (
      <CheckCircle2 className="h-4 w-4 text-emerald-600" />
    ) : state === 'unmet' ? (
      <XCircle className="h-4 w-4 text-red-600" />
    ) : (
      <Circle className="h-4 w-4 text-teal-700/60" />
    )
  return (
    <li className="flex items-center gap-2">
      {icon}
      {children}
    </li>
  )
}

/**
 * ESSP spec section 2: settlement can start only after the advance is approved and paid. The ticks follow
 * the selected advance; unpaid approved advances are named so the employee knows who to ask.
 */
function Prerequisite({
  available,
  loading,
  selectedSettleable,
  unpaid,
  withReceipt,
  receiptAfterApproval,
  awaitingReceipt,
  onConfirmReceipt,
  confirming,
}: {
  available: number
  loading: boolean
  selectedSettleable: boolean
  unpaid: string[]
  withReceipt: boolean
  /** BC 1.0.3.662: receipt is confirmed right after approval, before Finance's payment is in BC. */
  receiptAfterApproval: boolean
  awaitingReceipt: string[]
  /** BC 1.0.3.653+: confirm the payment of a paid advance was received (PortalAdvanceConfirmReceipt). */
  onConfirmReceipt: (advanceNo: string) => void
  confirming: string | null
}) {
  const state: PrerequisiteState = selectedSettleable ? 'met' : 'open'
  return (
    <div className="rounded-xl border border-teal-200 bg-teal-50/80 px-4 py-3 text-sm text-teal-950">
      <p className="flex items-center gap-2 font-semibold">
        <Info className="h-4 w-4 text-teal-700" />
        Prerequisite — you can start an Advance Settlement only after:
      </p>
      <ul className="mt-1.5 space-y-1 pl-6">
        <PrerequisiteItem state={state}>an approved Advance Payment Request,</PrerequisiteItem>
        {withReceipt && receiptAfterApproval ? (
          <>
            <PrerequisiteItem state={state}>you have confirmed receipt of the money in ESSP, and</PrerequisiteItem>
            <PrerequisiteItem state={state}>Finance has recorded the payment in Business Central.</PrerequisiteItem>
          </>
        ) : (
          <>
            <PrerequisiteItem state={state}>{withReceipt ? 'the advance has been paid, and' : 'the advance has been paid.'}</PrerequisiteItem>
            {withReceipt ? (
              <PrerequisiteItem state={state}>you have confirmed receipt of the money in ESSP.</PrerequisiteItem>
            ) : null}
          </>
        )}
      </ul>
      <p className="mt-1.5 text-xs text-teal-900/80">
        {loading
          ? 'Checking Business Central for advances you can settle…'
          : available > 0
            ? `${available} approved and paid advance${available === 1 ? '' : 's'} can be settled. An advance with an open settlement is not listed again (no duplicate settlement).`
            : 'No approved and paid advance is waiting for settlement.'}
      </p>
      {!loading && awaitingReceipt.length ? (
        <div className="mt-2 rounded-lg border border-amber-300 bg-amber-50 px-3 py-2 text-xs text-amber-950">
          <p>
            {receiptAfterApproval
              ? `Confirm you received the money for ${awaitingReceipt.length === 1 ? 'this approved advance' : 'these approved advances'} once Finance has paid you; then ${awaitingReceipt.length === 1 ? 'it' : 'they'} can be settled here.`
              : `Finance has paid ${awaitingReceipt.length === 1 ? 'this advance' : 'these advances'}: confirm you received the money, then the advance can be settled here.`}
          </p>
          <ul className="mt-2 space-y-1.5">
            {awaitingReceipt.map((advanceNo) => (
              <li key={advanceNo} className="flex flex-wrap items-center gap-2">
                <Link
                  to={`/finance/advance-request?open=${encodeURIComponent(`imprest-${advanceNo}`)}`}
                  className="font-semibold text-amber-950 underline-offset-2 hover:underline"
                >
                  {advanceNo}
                </Link>
                <button
                  type="button"
                  disabled={confirming === advanceNo}
                  onClick={() => onConfirmReceipt(advanceNo)}
                  className="inline-flex items-center gap-1 rounded-full bg-[var(--portal-navy)] px-2.5 py-1 font-semibold text-white hover:bg-[var(--portal-navy-dark)] disabled:opacity-60"
                >
                  <HandCoins className="h-3.5 w-3.5" />
                  {confirming === advanceNo ? 'Confirming…' : 'Confirm payment received'}
                </button>
              </li>
            ))}
          </ul>
        </div>
      ) : null}
      {!loading && unpaid.length ? (
        <p className="mt-2 flex items-start gap-2 rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-950">
          <XCircle className="mt-0.5 h-3.5 w-3.5 shrink-0 text-amber-700" />
          <span>
            <span className="font-semibold">{unpaid.join(', ')}</span>{' '}
            {receiptAfterApproval
              ? `${unpaid.length === 1 ? 'is' : 'are'} received, but Finance has not recorded the payment in Business Central yet.`
              : `${unpaid.length === 1 ? 'is' : 'are'} approved but not paid in Business Central yet.`}{' '}
            Finance records it through the Payment Schedule (Business Central marks it Fully Paid once the whole amount is
            paid) or posts it; it then appears here for settlement.
          </span>
        </p>
      ) : null}
    </div>
  )
}

function Detail({ label, value }: { label: string; value: string }) {
  return (
    <div className="space-y-1.5">
      <p className="text-sm font-semibold text-slate-700">{label}</p>
      <p className="min-h-5 text-sm font-medium text-slate-950">{value || '—'}</p>
    </div>
  )
}

export function ImprestSurrender() {
  const receipts = useLookupOptions('posted-receipts')
  const confirm = useConfirm()
  const receiptConfirmation = useConfirmAdvanceReceipt()
  const confirmReceipt = async (advanceNo: string) => {
    const ok = await confirm({
      title: `Confirm you received ${advanceNo}?`,
      message:
        'Confirm only once the money is in your hands or your bank account. The advance can then be settled here.',
      confirmLabel: 'Yes, I received it',
    })
    if (ok) receiptConfirmation.mutate({ advanceNo })
  }
  // BC 1.0.3.636: only approved + paid advances from PortalAdvanceSettlementContext.
  const settleableQuery = useQuery({
    queryKey: ['finance', 'advance-settlement', 'context', 'create'],
    queryFn: () => fetchAdvanceSettlementContext(''),
  })
  // Fallback display details when BC context is unavailable.
  const imprestQuery = useQuery({
    queryKey: ['finance', 'imprest', 'for-surrender'],
    queryFn: () => listModuleRequests(imprestModule),
  })

  const settleable = settleableQuery.data?.settleableAdvances ?? []
  // BC 1.0.3.667 (client, 17 Nov 2026): settle within 7 days of the activity end date; overdue ones are named.
  const outstanding = settleableQuery.data?.outstanding ?? null
  const dueOf = (advanceNo: string) => {
    const row = outstanding?.advances.find((item) => item.advanceNo === advanceNo)
    return row ? settleByText(row) : ''
  }
  const settleableNos = new Set(settleable.map((row) => row.advanceNo))
  // The employee's approved advances BC will not settle yet (not paid, or a settlement is open).
  const waiting = settleableQuery.isSuccess
    ? (imprestQuery.data ?? []).filter((row) => isSurrenderableImprest(row) && !settleableNos.has(row.requestNo))
    : []
  // BC 1.0.3.653: paid advances wait for the requester's receipt confirmation before settlement; BC 1.0.3.662 asks
  // for it right after approval (then Finance's payment in BC is the last step).
  const withReceipt = settleableQuery.data?.supportsReceiptConfirmation === true
  const receiptAfterApproval = withReceipt && settleableQuery.data?.receiptAfterApproval === true
  const unpaid = waiting
    .filter((row) => !isPaid(row) && (!receiptAfterApproval || receiptConfirmed(row)))
    .map((row) => row.requestNo)
  const awaitingReceipt = withReceipt
    ? Array.from(
        new Set([
          ...(settleableQuery.data?.awaitingReceipt ?? []).map((row) => row.advanceNo),
          ...waiting
            .filter((row) => (receiptAfterApproval || isPaid(row)) && !receiptConfirmed(row))
            .map((row) => row.requestNo),
        ]),
      )
    : []
  // Only what BC's PortalAdvanceSettlementContext allows (BC refuses the rest: "must be paid before settlement");
  // without that context, the employee's paid advances.
  const imprestOptions = settleableQuery.isSuccess
    ? [
        ...settleable.map((row) => ({
          label: `${row.advanceNo} — ${formatCurrency(Number(row.amount ?? 0))}${row.purpose ? ` · ${row.purpose}` : ''}${dueOf(row.advanceNo) ? ` · ${dueOf(row.advanceNo)}` : ''}`,
          value: row.advanceNo,
        })),
        ...waiting.map((row) => ({
          label: `${row.requestNo} — ${notSettleableReason(row, withReceipt, receiptAfterApproval)}`,
          value: `blocked:${row.requestNo}`,
          disabled: true,
        })),
      ]
    : (imprestQuery.data ?? [])
        .filter((row) => isSurrenderableImprest(row) && isPaid(row))
        .map((row) => ({
          label: `${row.requestNo}${row.status && row.status !== 'Posted' ? ` (${row.status})` : ''}`,
          value: row.requestNo,
        }))
  const emptyImprestHint = settleableQuery.isLoading
    ? 'Loading settleable advances from Business Central…'
    : settleableQuery.isError && imprestQuery.isError
      ? 'Could not load advances from Business Central.'
      : imprestOptions.filter((option) => !('disabled' in option && option.disabled)).length === 0
        ? 'No approved and paid advance is available to settle yet.'
        : 'Select advance request'

  return (
    <MultiStepRequestPage
      title="Advance Settlement"
      headerLabel="New Advance Settlement"
      description="Settle an advance received through an approved and paid Advance Payment Request: enter the actual expenses incurred, attach the supporting documents, and reconcile the advance against the actual expenses. The outcome is Fully Settled, Advance Surrender (return the unused balance) or Additional Reimbursement (claim the extra amount)."
      processBanner={(request) => <AdvanceSettlementProcessBanner request={request} />}
      showProcessBannerOnList={false}
      submitButtonLabel="Submit for Processing"
      submitConfirmTitle="Submit the settlement for processing?"
      submitConfirmMessage="The settlement goes to Business Central for approval. The advance is closed only after Finance finalizes the reconciliation."
      submitSuccessMessage="Settlement submitted for processing in Business Central"
      validateBeforeSubmit={(request) => settlementSubmitProblem(String(request.requestNo ?? ''))}
      requiresAttachmentBeforeSubmit
      requiredAttachmentMessage="Attach the expense receipts / supporting documents before submitting the settlement."
      attachmentCategoryOptions={SETTLEMENT_ATTACHMENT_CATEGORIES}
      attachmentsTitle="Supporting documents"
      attachmentCategoryHint="Attach every expense receipt; for Advance Surrender the refund payment receipt, for Additional Reimbursement the documents for the extra expenses. Several files can be attached."
      module={module}
      queryKey={['finance', 'advance-settlement']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Advance Settlement"
      headerSchema={imprestSurrenderHeaderSchema}
      headerDefaults={{ imprest: '' }}
      buildHeaderPayload={(values) => ({ imprest: values.imprest, title: `Settlement for ${values.imprest}` })}
      // Re-saving the header makes BC re-copy the advance lines and drop the expense lines.
      allowHeaderEdit={false}
      // Client, 16 Nov 2026: three sequential sections — 1 Advance Summary, 2 Expense Entries and Supporting
      // Documents, 3 Expense Reconciliation and Settlement (one card per expense on BC 1.0.3.663).
      // Step 5 of the client's workflow: the declaration, then Submit for Processing — the actions follow the sections.
      detailActionsPlacement="bottom"
      detailLayout={({ request, details, lines, attachments }) => (
        <AdvanceSettlementSections request={request} details={details} lines={lines} attachments={attachments} />
      )}
      headerFields={[
        {
          name: 'imprest',
          label: 'Original Advance Payment Request No. *',
          type: 'select',
          valuePaths: ['ImprestIssueDocNo', 'Imprest_Issue_Doc_No', 'ImprestNo'],
          options: imprestOptions,
          placeholder: emptyImprestHint,
        },
      ]}
      headerSupplement={(values) => {
        const advanceNo = String(values.imprest ?? '')
        const settleableRow = settleable.find((row) => row.advanceNo === advanceNo)
        const selected = (imprestQuery.data ?? []).find((row) => row.requestNo === advanceNo)
        const payload = selected?.payload ?? {}
        const amount =
          settleableRow?.amount ??
          firstValue(payload, ['TotalNetAmount', 'Total_Net_Amount', 'NetAmount']) ??
          selected?.amount
        const purpose =
          settleableRow?.purpose ||
          settleableRow?.requestPurposeText ||
          String(firstValue(payload, ['Purpose', 'Description']) ?? selected?.title ?? '')
        const dateRequired =
          settleableRow?.date ||
          firstValue(payload, [
            'PaymentReleaseDate',
            'Payment_Release_Date',
            'DateRequired',
            'Date_Required',
          ])

        return (
          <div className="space-y-3">
          <AdvanceOutstandingNotice outstanding={outstanding} showSettlementLink={false} />
          <Prerequisite
            available={settleable.length}
            loading={settleableQuery.isLoading}
            selectedSettleable={settleableNos.has(advanceNo)}
            unpaid={unpaid}
            withReceipt={withReceipt}
            receiptAfterApproval={receiptAfterApproval}
            awaitingReceipt={awaitingReceipt}
            onConfirmReceipt={(advanceNo) => void confirmReceipt(advanceNo)}
            confirming={receiptConfirmation.isPending ? (receiptConfirmation.variables?.advanceNo ?? null) : null}
          />
          {advanceNo ? (
          <div>
          <p className="text-xs font-semibold uppercase tracking-wide text-slate-500">Advance details (retrieved from Business Central)</p>
          <div className="mt-2 grid gap-x-8 gap-y-5 border-y border-slate-200 py-4 sm:grid-cols-2 lg:grid-cols-3">
            <Detail label="Advance Purpose" value={purpose} />
            <Detail
              label="Total Advance Received"
              value={amount === undefined || amount === '' ? '—' : formatCurrency(Number(amount))}
            />
            <Detail
              label="Department"
              value={String(
                firstValue(payload, ['ShortcutDimension2Code', 'Shortcut_Dimension_2_Code', 'Department'])
                  ?? selected?.departmentName
                  ?? selected?.departmentCode
                  ?? '',
              )}
            />
            <Detail
              label="Responsibility Center"
              value={String(
                firstValue(payload, ['ResponsibilityCenter', 'Responsibility_Center'])
                  ?? selected?.responsibleCenter
                  ?? '',
              )}
            />
            <Detail
              label="Payment / Advance Date"
              value={dateRequired === undefined || dateRequired === '' ? '—' : formatDate(String(dateRequired))}
            />
            {dueOf(advanceNo) ? <Detail label="Settle By (activity end + 7 days)" value={dueOf(advanceNo)} /> : null}
          </div>
          </div>
          ) : null}
          </div>
        )
      }}
      detailFields={[
        { label: 'Settlement No.', paths: ['request.requestNo'] },
        {
          label: 'Settlement Date',
          paths: ['payload.SurrenderDate', 'payload.Surrender_Date', 'payload.DateCreated', 'request.createdAt'],
          format: 'date',
        },
        { label: 'Advance Request No.', paths: ['payload.ImprestIssueDocNo', 'payload.Imprest_Issue_Doc_No', 'payload.ImprestNo'] },
        { label: 'Purpose', paths: ['payload.Purpose', 'request.title'] },
        {
          label: 'Department',
          paths: [
            'request.departmentName',
            'request.departmentCode',
            'payload.DepartmentName',
            'payload.Department',
            'payload.GlobalDimension1Code',
          ],
        },
        {
          label: 'Responsibility Center',
          paths: [
            'request.responsibleCenter',
            'payload.ResponsibilityCenter',
            'payload.Responsibility_Center',
            'payload.JobTitle',
            'payload.Job_Title',
          ],
        },
        { label: 'Employee Grade', paths: ['payload.EmployeeGrade', 'payload.JobGrade', 'payload.Job_Grade'] },
        {
          label: 'Place of Duty',
          paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.Place_of_Duty', 'payload.DutyArea'],
        },
        {
          label: 'Employee Account',
          paths: [
            'payload.EmployeeAccountNo',
            'payload.Employee_Account_No',
            'payload.CustomerNo',
            'payload.ImprestNo',
          ],
        },
        {
          label: 'Advance Amount',
          paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'payload.Amount', 'request.amount'],
          format: 'currency',
        },
        { label: 'Status', paths: ['request.status'], format: 'status' },
        {
          // Spec rule 8: complete only once Finance has finalized (posted) the reconciliation.
          label: 'Settlement Status',
          paths: [],
          resolve: (request) => {
            const status = request.status.trim().toLowerCase()
            if (status === 'posted' || status === 'completed' || status === 'closed') return 'Reconciled and closed (posted in Business Central)'
            if (status === 'approved') return 'Approved — Finance finalizes the reconciliation'
            if (status.includes('pending')) return 'Submitted — pending approval in Business Central'
            if (status === 'draft') return 'Draft — complete the expenses and submit'
            return undefined
          },
        },
      ]}
      line={{
        label: 'Expense entries',
        lineHint:
          'Enter the actual amount spent on each line and press Save; add other expenses below. Business Central recalculates the reconciliation in section 3.',
        schema: imprestSurrenderHeaderSchema,
        defaultValues: {},
        canAdd: false,
        fields: [],
        editableFields: [
          { name: 'actualSpent', label: 'Actual Spent', type: 'number' },
          {
            name: 'cashReceiptNo',
            label: 'Cash Receipt No. (when returning unused balance)',
            type: receipts.options.length > 0 ? 'select' : 'text',
            options:
              receipts.options.length > 0
                ? [{ value: '', label: '— None / not applicable —' }, ...receipts.options]
                : undefined,
            placeholder:
              receipts.options.length > 0
                ? 'Select posted cash receipt'
                : 'No posted receipts found — type receipt no. or leave blank if fully spent',
          },
          { name: 'cashReceiptAmount', label: 'Cash Receipt Amount', type: 'number' },
        ],
        columns: [
          { key: 'accountName', header: 'Expense' },
          { key: 'accountNo', header: 'Account No.' },
          { key: 'amount', header: 'Advance Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'actualSpent', header: 'Actual Expense', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'cashReceiptNo', header: 'Cash Receipt No.' },
          { key: 'cashReceiptAmount', header: 'Cash Receipt Amount' },
        ],
        emptyText: '*** No expense entries yet ***',
      }}
    />
  )
}
