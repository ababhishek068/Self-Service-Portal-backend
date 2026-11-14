import { useQuery } from '@tanstack/react-query'
import { CheckCircle2, Info } from 'lucide-react'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { AdvanceSettlementProcessBanner } from '@/components/finance/AdvanceSettlementProcessBanner'
import { AdvanceSettlementPanel } from '@/pages/finance/AdvanceSettlementPanel'
import { settlementSubmitProblem } from '@/hooks/useAdvanceSettlementContext'
import { fetchAdvanceSettlementContext } from '@/api/endpoints/advanceSettlement'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { imprestSurrenderHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'
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

/** ESSP spec section 2: settlement can start only after the advance is approved and paid. */
function Prerequisite({ available, loading }: { available: number; loading: boolean }) {
  return (
    <div className="rounded-xl border border-teal-200 bg-teal-50/80 px-4 py-3 text-sm text-teal-950">
      <p className="flex items-center gap-2 font-semibold">
        <Info className="h-4 w-4 text-teal-700" />
        Prerequisite — you can start an Advance Settlement only after:
      </p>
      <ul className="mt-1.5 space-y-1 pl-6">
        <li className="flex items-center gap-2">
          <CheckCircle2 className="h-4 w-4 text-emerald-600" />
          an approved Advance Payment Request, and
        </li>
        <li className="flex items-center gap-2">
          <CheckCircle2 className="h-4 w-4 text-emerald-600" />
          the advance has been paid.
        </li>
      </ul>
      <p className="mt-1.5 text-xs text-teal-900/80">
        {loading
          ? 'Checking Business Central for advances you can settle…'
          : available > 0
            ? `${available} approved and paid advance${available === 1 ? '' : 's'} can be settled. An advance with an open settlement is not listed again (no duplicate settlement).`
            : 'No approved and paid advance is waiting for settlement. Finance must pay (Fully Paid) the advance in Business Central first.'}
      </p>
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
  const imprestOptions =
    settleable.length > 0
      ? settleable.map((row) => ({
          label: `${row.advanceNo} — ${formatCurrency(Number(row.amount ?? 0))}${row.purpose ? ` · ${row.purpose}` : ''}`,
          value: row.advanceNo,
        }))
      : (imprestQuery.data ?? []).filter(isSurrenderableImprest).map((row) => ({
          label: `${row.requestNo}${row.status && row.status !== 'Posted' ? ` (${row.status})` : ''}`,
          value: row.requestNo,
        }))
  const emptyImprestHint = settleableQuery.isLoading
    ? 'Loading settleable advances from Business Central…'
    : settleableQuery.isError && imprestQuery.isError
      ? 'Could not load advances from Business Central.'
      : imprestOptions.length === 0
        ? 'No approved and paid advance is available to settle. Finance must mark the advance Fully Paid in Business Central first.'
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
      detailSupplement={({ request }) => <AdvanceSettlementPanel request={request} />}
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
          <Prerequisite available={settleable.length} loading={settleableQuery.isLoading} />
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
        label: 'Actual Expenses',
        lineHint:
          'Enter the actual amount spent on each line; add other expenses with Add Expense Entry above. Business Central recalculates the balance and the outcome.',
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
