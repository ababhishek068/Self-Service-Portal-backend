import { useQuery } from '@tanstack/react-query'
import { formatISO } from 'date-fns'
import { useMemo } from 'react'
import { Banknote, HandCoins, Landmark, Receipt, UserCheck } from 'lucide-react'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { AdvanceRequestCreate } from '@/components/finance/AdvanceRequestCreate'
import { fetchAdvancePaymentContext } from '@/api/endpoints/advancePaymentContext'
import { AdvanceReceiptPanel } from '@/components/finance/AdvanceReceiptPanel'
import { AdvanceSettleByNote } from '@/components/finance/AdvanceOutstandingNotice'
import { advancePaid, fullySettled, receiptConfirmed } from '@/utils/advanceReceipt'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import {
  allAdvancePurposeOptions,
  purposeRequiresOtherDetails,
} from '@/data/advanceRequestPurpose'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { advanceAttachmentCategories, imprestTypeOptions } from '@/data/essOptions'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { advanceLineSchema, imprestHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useAuth } from '@/hooks/useAuth'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'
import type { TrackerStep } from '@/components/shared/ProcessTracker'
import type { AfterApproval } from '@/components/shared/RequestProgress'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'imprest', entity: 'selfServiceImprestRequests' } as const

/** BC 1.0.3.646 Advance Request route (ABH spec section 4), shown until BC has the approval entries. */
const ADVANCE_APPROVERS: TrackerStep[] = [
  { key: 'line-manager', heading: 'Line Manager', owner: 'Workflow User Group', icon: UserCheck },
  { key: 'final-approver', heading: 'FAD | COO | CEO', owner: 'By amount: <50k · 50–100k · >100k ETB', icon: Landmark },
]

/**
 * Business requirement (Nov 2026): approval → Finance pays → the requester confirms receipt in ESSP → only then
 * settlement (BC 1.0.3.653). On older BC there is no receipt step. BC 1.0.3.662 (`afterApproval`): the receipt can
 * be confirmed right after approval, like the Store receipt; settlement still waits for Finance's payment in BC.
 */
function advanceAfterApproval(request: PortalRequest, withReceipt: boolean, afterApproval: boolean): AfterApproval {
  const paid = advancePaid(request)
  const received = receiptConfirmed(request)
  const settled = fullySettled(request)
  const steps: TrackerStep[] = [
    { key: 'payment', heading: 'Finance', owner: 'Pays the advance', icon: Banknote },
    ...(withReceipt ? [{ key: 'receipt', heading: 'Payment received', owner: 'You confirm in ESSP', icon: HandCoins }] : []),
    { key: 'settlement', heading: 'Settlement', owner: 'Advance Settlement', icon: Receipt },
  ]
  if (settled) return { steps, caption: 'Settled', current: steps.length }
  if (withReceipt && afterApproval) {
    if (!received) {
      return paid
        ? { steps, caption: 'Paid · confirm you received the money', current: 1 }
        : { steps, caption: 'Finance pays the advance · confirm below once you receive it', current: 0 }
    }
    return paid
      ? { steps, caption: 'Settle the advance under Advance Settlement', current: 2 }
      : { steps, caption: 'Received · settle once Finance has recorded the payment in Business Central', current: 2 }
  }
  if (!paid) return { steps, caption: 'Waiting for Finance to pay the advance', current: 0 }
  if (withReceipt && !received) return { steps, caption: 'Paid · confirm you received the money', current: 1 }
  return { steps, caption: 'Settle the advance under Advance Settlement', current: withReceipt ? 2 : 1 }
}

function receiptStatus(request: PortalRequest, afterApproval: boolean) {
  const payload = request.payload ?? {}
  if (receiptConfirmed(request)) {
    const on = firstPayloadDate(payload, ['ReceiptConfirmedOn', 'Receipt_Confirmed_On'])
    return on ? `Confirmed on ${on}` : 'Confirmed'
  }
  if (advancePaid(request)) return 'Paid — waiting for your confirmation (Confirm Payment Received)'
  return afterApproval && ['Approved', 'Posted'].includes(request.status)
    ? 'Approved — confirm once you receive the money (Confirm Payment Received)'
    : undefined
}

function paymentStatus(request: PortalRequest) {
  const payload = request.payload ?? {}
  const posted = payload.Posted === true || String(payload.Posted ?? '').toLowerCase() === 'true'
  const datePosted = firstPayloadDate(payload, ['DatePosted', 'Date_Posted'])
  const voucher = String(
    payload.PVNo ?? payload.PV_No ?? payload.PaymentVoucherNo ?? payload.Payment_Voucher_No ?? '',
  ).trim()
  if (posted) return datePosted ? `Paid (posted ${datePosted})` : 'Paid (posted)'
  if (voucher) return 'Payment voucher raised'
  return undefined
}

function firstPayloadDate(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = String(payload[key] ?? '').trim()
    if (value && !value.startsWith('0001-01-01')) return value.slice(0, 10)
  }
  return ''
}

function imprestListSearchExtra(row: PortalRequest): Array<string | number | undefined | null> {
  const payload = row.payload ?? {}
  return [
    payload.TravelDestination,
    payload.Travel_Destination,
    payload.Destination,
    payload.DestinationCode,
    payload.Purpose,
    payload.purpose,
    payload.ImprestNo,
    payload.EmployeeAccountNo,
    payload.CustomerNo,
  ].map((value) =>
    value === undefined || value === null ? value : typeof value === 'number' ? value : String(value),
  )
}

export function ImprestRequest() {
  const { employee } = useAuth()
  const imprestTypes = useLookupOptions('imprest-types', imprestTypeOptions)
  // Activity / Purpose of Assignment: the same list for every requester (BC 1.0.3.661; client 16 Nov 2026).
  const fallbackPurposes = useMemo(() => allAdvancePurposeOptions(), [])
  const purposeContext = useQuery({
    queryKey: ['advance-payment-context', employee?.employeeNo ?? ''],
    queryFn: () => fetchAdvancePaymentContext(String(employee?.employeeNo ?? '')),
    // BC 1.0.3.667: it also says whether a new advance may be submitted (4 not settled), so it is kept fresh.
    staleTime: 60 * 1000,
  })
  const purposeOptions =
    purposeContext.data?.purposes?.length ? purposeContext.data.purposes : fallbackPurposes
  // ESSP spec: Project / Assignment (Optional) — on BC 1.0.3.651+, which reports the field.
  const supportsProject = purposeContext.data?.supportsProjectAssignment === true
  // BC 1.0.3.668: Yes/No project-related → active Job + justification (replaces free-text when available).
  const supportsProjectRelated = purposeContext.data?.supportsProjectRelated === true
  // BC 1.0.3.653: confirm receipt before settlement, and the ESSP Advance Request Types list.
  const supportsReceipt = purposeContext.data?.supportsReceiptConfirmation === true
  // BC 1.0.3.662: Confirm Payment Received right after approval (client, 16 Nov 2026: like the Store receipt).
  const receiptAfterApproval = supportsReceipt && purposeContext.data?.receiptAfterApproval === true
  const advanceTypeOptions = purposeContext.data?.advanceTypes?.length ? purposeContext.data.advanceTypes : imprestTypes.options
  const advanceTypeLabel = (code: unknown) =>
    advanceTypeOptions.find((option) => option.value === String(code ?? ''))?.label || String(code ?? '')
  const purposeHint = 'What the advance is for. Choose Other (Specify) to describe an activity not in the list.'
  // BC 1.0.3.667 (client, 17 Nov 2026): settle within 7 days of the activity end; no new advance with 4 not settled.
  const outstanding = purposeContext.data?.outstanding ?? null
  const settleDays = outstanding?.settlementDueDays ?? 7
  const createForm = {
    module,
    purposeOptions,
    purposeHint,
    advanceTypes: advanceTypeOptions,
    supportsProject,
    supportsProjectRelated,
    outstanding,
  }

  return (
    <MultiStepRequestPage
      title="Advance Request"
      headerLabel="New Advance Request"
      description={`Request field activity advance funds (Phase 1–2 of the Advance & Settlement cycle). Fill in the purpose, justification and activity dates, choose one or more advance types with the amount of each (ETB), attach supporting documents (activity plan, assignment approval, budget support or other evidence), then submit for approval. Approval (BC 1.0.3.646): Line Manager first (Workflow User Group), then FAD (below ETB 50,000), COO (ETB 50,000–100,000), or CEO (above ETB 100,000). After Finance pays the advance, confirm here that you received the money (Confirm Payment Received); only then can it be settled via Advance Settlement, within ${settleDays} days of the activity end date. An employee with ${outstanding?.maxUnsettled || 4} advances not settled cannot request a new one until one is settled.`}
      module={module}
      queryKey={['finance', 'advance-request']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      listSearchExtra={imprestListSearchExtra}
      newButtonLabel="New Advance Request"
      headerSchema={imprestHeaderSchema}
      headerDefaults={{
        requestDate: today,
        dateRequired: today,
        requestPurpose: purposeOptions[0]?.value ?? 'GN-OTH',
        otherPurposeDetails: '',
        justification: '',
        activityLocation: '',
        activityStartDate: '',
        activityEndDate: '',
        projectAssignment: '',
        purpose: '',
      }}
      // Developer handover: one page — employee & purpose, details with Requested Amount (ETB),
      // supporting documents, and Save as Draft / Submit for Approval / Cancel / View History.
      customCreate={({ onCreated, onCancel }) => <AdvanceRequestCreate {...createForm} onCreated={onCreated} onCancel={onCancel} />}
      // A saved draft opens in the same one-page form (client, 16 Nov 2026), not the old line editor.
      draftOpensInEdit
      customEdit={({ request, onSaved, onCancel, onDeleted }) => (
        <AdvanceRequestCreate {...createForm} request={request} onSaved={onSaved} onDeleted={onDeleted} onCancel={onCancel} />
      )}
      progressApprovers={ADVANCE_APPROVERS}
      progressAfterApproval={(request) => advanceAfterApproval(request, supportsReceipt, receiptAfterApproval)}
      // BC 1.0.3.653+: a clear "Confirm Payment Received" step on the request itself (662: right after approval).
      detailSupplement={({ request }) => (
        <div className="space-y-3">
          {/* BC 1.0.3.667: settle-by date (activity end + 7 days), or how long the settlement is overdue. */}
          <AdvanceSettleByNote outstanding={outstanding} advanceNo={request.requestNo} />
          <AdvanceReceiptPanel request={request} supportsReceipt={supportsReceipt} receiptAfterApproval={receiptAfterApproval} />
        </div>
      )}
      submitButtonLabel="Submit for Approval"
      attachmentCategoryOptions={advanceAttachmentCategories}
      attachmentCategoryHint="Attach the activity plan, assignment approval, budget support or other evidence. Several files can be attached; describe each one."
      headerSupplement={() => (
        <div className="space-y-3">
          <FinanceEmployeeOrgBanner showEmployeeNoAndStatus />
          <div className="rounded-xl border border-teal-200 bg-teal-50/80 px-3 py-2.5 text-sm text-teal-950">
            <p className="font-semibold">Finance approval (Business Central 1.0.3.646)</p>
            <p className="mt-1 text-xs leading-5 text-teal-900/90">
              ESSP submission → Business Central → Line Manager approval → final approver by amount (ETB):
              below 50,000 → FAD; 50,000–100,000 → COO; above 100,000 → CEO. The Line Manager is the
              Workflow User Group on the Advance Request workflow. Activity / Purpose of Assignment is one list for
              every requester — choose Other (Specify) when needed. Settlement is only via Advance Settlement.
            </p>
          </div>
        </div>
      )}
      buildHeaderPayload={(values) => {
        const justification = String(values.justification ?? '').trim()
        const purposeCode = String(values.requestPurpose ?? '').trim()
        const purposeLabel =
          purposeOptions.find((option) => option.value === purposeCode)?.label ?? purposeCode
        const activityStartDate = String(values.activityStartDate ?? '')
        const { projectAssignment, ...rest } = values
        // No travel fields on the form: the backend fills BC's Travel Start / Expected Return from these.
        return {
          ...rest,
          ...(supportsProject ? { projectAssignment: String(projectAssignment ?? '').trim() } : {}),
          activityStartDate,
          activityEndDate: String(values.activityEndDate ?? '') || activityStartDate,
          purposeCode,
          requestPurpose: purposeCode,
          purpose: justification || purposeLabel,
          title: justification || purposeLabel || 'Advance Request',
        }
      }}
      headerOnValuesChange={(values, form) => {
        // One-day activity by default: the end date follows the start date until set later.
        const start = String(values.activityStartDate ?? '')
        const end = String(values.activityEndDate ?? '')
        if (start && !end) form.setValue('activityEndDate', start, { shouldValidate: true, shouldDirty: true })
      }}
      headerFields={[
        {
          name: 'requestDate',
          label: 'Request Date',
          type: 'date',
          readOnly: true,
          valuePaths: ['Date', 'RequestDate', 'Request_Date'],
          hint: 'System generated',
        },
        {
          name: 'dateRequired',
          label: 'Required Advance Date *',
          type: 'date',
          valuePaths: [
            'DateRequired',
            'Date_Required',
            'PaymentReleaseDate',
            'Payment_Release_Date',
          ],
          hint: 'Date you need the funds (today or later, on or before the activity start)',
        },
        {
          name: 'requestPurpose',
          label: 'Activity / Purpose of Assignment *',
          type: 'select',
          options: purposeOptions,
          valuePaths: ['RequestPurposeCode', 'Request_Purpose_Code'],
          hint: purposeHint,
        },
        {
          name: 'otherPurposeDetails',
          label: 'Other Purpose Details',
          type: 'textarea',
          fullWidth: true,
          maxLength: 250,
          visibleWhen: (values) =>
            purposeRequiresOtherDetails(String(values.requestPurpose ?? ''), purposeOptions),
          placeholder: 'Describe the purpose when Other is selected',
          valuePaths: ['OtherPurposeDetails', 'Other_Purpose_Details'],
        },
        {
          name: 'justification',
          label: 'Request Justification *',
          type: 'textarea',
          fullWidth: true,
          maxLength: 250,
          placeholder: 'Explain why the advance is needed',
          valuePaths: ['RequestJustification', 'Request_Justification', 'Purpose'],
        },
        {
          name: 'activityStartDate',
          label: 'Activity Start Date *',
          type: 'date',
          valuePaths: ['ActivityStartDate', 'Activity_Start_Date'],
        },
        {
          name: 'activityEndDate',
          label: 'Activity End Date',
          type: 'date',
          valuePaths: ['ActivityEndDate', 'Activity_End_Date'],
          hint: 'On or after the start date (same date for a one-day activity)',
        },
        {
          name: 'activityLocation',
          label: 'Activity Location',
          type: 'text',
          fullWidth: true,
          placeholder: 'Where the activity will take place (where relevant)',
          valuePaths: ['ActivityLocation', 'Activity_Location'],
        },
        {
          name: 'projectAssignment',
          label: 'Project / Assignment (optional)',
          type: 'text',
          fullWidth: true,
          maxLength: 100,
          placeholder: 'Project or assignment this advance is for',
          valuePaths: ['ProjectAssignment', 'Project_Assignment'],
          visibleWhen: () => supportsProject,
        },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        { label: 'Request Date', paths: ['payload.Date', 'request.createdAt'], format: 'date' },
        {
          label: 'Required Advance Date',
          paths: [
            'payload.DateRequired',
            'payload.Date_Required',
            'payload.PaymentReleaseDate',
            'payload.Payment_Release_Date',
          ],
          format: 'date',
        },
        {
          label: 'Activity / Purpose of Assignment',
          paths: ['payload.RequestPurposeText', 'payload.RequestPurposeCode', 'payload.Purpose'],
        },
        {
          label: 'Other Purpose Details',
          paths: ['payload.OtherPurposeDetails', 'payload.Other_Purpose_Details'],
        },
        {
          label: 'Request Justification',
          paths: ['payload.RequestJustification', 'payload.Request_Justification', 'payload.Purpose'],
        },
        {
          label: 'Activity Start Date',
          paths: ['payload.ActivityStartDate', 'payload.Activity_Start_Date'],
          format: 'date',
        },
        {
          label: 'Activity End Date',
          paths: ['payload.ActivityEndDate', 'payload.Activity_End_Date'],
          format: 'date',
        },
        {
          label: 'Activity Location',
          paths: ['payload.ActivityLocation', 'payload.Activity_Location'],
        },
        { label: 'Project / Assignment', paths: ['payload.ProjectAssignment', 'payload.Project_Assignment'] },
        { label: 'Advance Type (Other)', paths: ['payload.AdvanceTypeDetails', 'payload.Advance_Type_Details'] },
        ...financeOrgDetailFields,
        {
          label: 'Job Title',
          paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
        },
        {
          label: 'Job Grade',
          paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
        },
        { label: 'Responsibility Center', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
        { label: 'Place of Duty', paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'] },
        { label: 'Requested Amount (ETB)', paths: ['payload.TotalNetAmount', 'request.amount'], format: 'currency' },
        {
        label: 'Remaining Not Settled',
          paths: [
            'payload.RemainingUnsettledAmount',
            'payload.RemainingNotSettledAmount',
            'payload.OutstandingBalance',
            'payload.Balance',
          ],
          format: 'currency',
        },
        { label: 'Settlement Status (BC)', paths: ['payload.SurrenderStatus', 'payload.Surrender_Status'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
        // Shown only once BC has a payment for the advance (spec section 5).
        { label: 'Payment Status', paths: [], resolve: paymentStatus },
        {
          label: 'Receipt Confirmation',
          paths: [],
          resolve: (request) => (supportsReceipt ? receiptStatus(request, receiptAfterApproval) : undefined),
        },
        {
          label: 'Payment Reference',
          paths: ['payload.PVNo', 'payload.PV_No', 'payload.PaymentVoucherNo', 'payload.Payment_Voucher_No'],
        },
        {
          label: 'Rejection Reason',
          paths: [
            'payload.RejectionReason',
            'payload.rejectionReason',
            'payload.Comment',
            'payload.Comments',
          ],
        },
      ]}
      line={{
        label: 'Advance Lines',
        addLabel: 'Add Advance Line',
        // Advance Type + amount only (no travel fields); drafts are edited in the one-page form.
        schema: advanceLineSchema,
        defaultValues: { advanceType: '', amount: '' },
        fields: [
          { name: 'advanceType', label: 'Advance Type', type: 'select', options: advanceTypeOptions },
          { name: 'amount', label: 'Amount (ETB)', type: 'number' },
        ],
        columns: [
          { key: 'advanceType', header: 'Advance Type', format: (value) => advanceTypeLabel(value) },
          {
            key: 'destination',
            header: 'Travel Destination',
            visibleWhen: (lines) => lines.some((row) => String(row.destination ?? '').trim()),
          },
          { key: 'accountNo', header: 'Account No.' },
          { key: 'accountName', header: 'Account Name' },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
        ],
        emptyText: '*** No Advance Lines Found ***',
        requiredMessage: 'Add at least one advance line with an amount above 0 (ETB) before Request Approval.',
        canAdd: false,
        canEdit: false,
      }}
    />
  )
}
