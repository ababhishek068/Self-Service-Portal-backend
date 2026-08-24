import { formatISO } from 'date-fns'
import { useQuery } from '@tanstack/react-query'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { ImprestSurrenderLinesEditor } from '@/components/finance/ImprestSurrenderLinesEditor'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { fetchImprestSurrenderPreview } from '@/api/endpoints/imprest'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { imprestSurrenderHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'imprestSurrender', entity: 'selfServiceImprestSurrenders' } as const
const imprestModule = { module: 'imprest', entity: 'selfServiceImprestRequests' } as const

function firstValue(source: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = source[key]
    if (value !== undefined && value !== null && String(value).trim() !== '') return value
  }
  return undefined
}

function firstFromSources(sources: Record<string, unknown>[], keys: string[]) {
  for (const source of sources) {
    const value = firstValue(source, keys)
    if (value !== undefined) return value
  }
  return undefined
}

function isPosted(row: PortalRequest) {
  const posted = row.payload?.Posted ?? row.payload?.posted
  return row.status === 'Posted' || posted === true || ['true', 'yes', '1'].includes(String(posted).toLowerCase())
}

function isSurrenderableImprest(row: PortalRequest) {
  if (!isPosted(row)) return false
  const payload = row.payload ?? {}
  const surrenderStatus = String(
    firstValue(payload, ['SurrenderStatus', 'Surrender_Status']) ?? '',
  ).toLowerCase()
  return surrenderStatus !== 'full'
}

function formatDuration(start?: unknown, end?: unknown) {
  const startText = start ? formatDate(String(start)) : ''
  const endText = end ? formatDate(String(end)) : ''
  if (startText && endText) return `${startText} – ${endText}`
  return startText || endText
}

function Detail({ label, value }: { label: string; value: string }) {
  const displayValue = value.trim()
  if (!displayValue || displayValue === '—' || displayValue.startsWith('01 Jan 0001')) return null

  return (
    <div className="space-y-1.5">
      <p className="text-sm font-semibold text-slate-700">{label}</p>
      <p className="min-h-5 text-sm font-medium text-slate-950">{displayValue}</p>
    </div>
  )
}

function ImprestSurrenderPreview({
  imprestNo,
  fallback,
}: {
  imprestNo: string
  fallback?: PortalRequest
}) {
  const previewQuery = useQuery({
    queryKey: ['finance', 'imprest-surrender-preview', imprestNo],
    queryFn: () => fetchImprestSurrenderPreview(imprestNo),
    enabled: Boolean(imprestNo),
  })

  const listPayload = fallback?.payload ?? {}
  const previewPayload = previewQuery.data ?? {}
  const sources = [previewPayload, listPayload]
  const amount =
    firstFromSources(sources, [
      'TotalNetAmount',
      'Total_Net_Amount',
      'NetAmount',
      'Net_Amount',
      'Amount',
      'PaidAmount',
      'Paid_Amount',
      'TotalPaymentAmount',
      'Total_Payment_Amount',
    ]) ?? fallback?.amount
  const dateRequired = firstFromSources(sources, [
    'PaymentReleaseDate',
    'Payment_Release_Date',
    'DateRequired',
    'Date_Required',
    'Date',
  ]) ?? fallback?.createdAt
  const durationDate = firstFromSources(sources, ['DurationDate', 'Duration_Date'])
  const travelStart = firstFromSources(sources, [
    'TravelStartDate',
    'Travel_Start_Date',
    'TravelDate',
    'Travel_Date',
    'StartDate',
  ])
  const travelEnd = firstFromSources(sources, [
    'ExpectedReturnDate',
    'Expected_Return_Date',
    'ReturnDate',
    'Return_Date',
    'EndDate',
  ])
  const destination = firstFromSources(sources, [
    'TravelDestination',
    'Travel_Destination',
    'Destination',
    'DestinationCode',
  ])
  const outstanding = firstFromSources(sources, [
    'RemainingUnsettledAmount',
    'RemainingNotSettledAmount',
    'OutstandingBalance',
    'Balance',
    'BalanceLessThisEntry',
    'Balance_Less_This_Entry',
    'Balance_Less_this_Entry',
  ])

  if (previewQuery.isLoading) {
    return (
      <p className="border-y border-slate-200 py-4 text-sm text-slate-500">
        Loading imprest details from Business Central…
      </p>
    )
  }

  return (
    <div className="grid gap-x-8 gap-y-5 border-y border-slate-200 py-4 sm:grid-cols-2 lg:grid-cols-3">
      <Detail
        label="Imprest Purpose"
        value={String(firstFromSources(sources, ['Purpose', 'Description', 'ImpPurpose']) ?? fallback?.title ?? '')}
      />
      <Detail
        label="Imprest Amount"
        value={amount === undefined ? '' : formatCurrency(Number(amount))}
      />
      <Detail
        label="Outstanding Balance"
        value={outstanding === undefined ? '' : formatCurrency(Number(outstanding))}
      />
      <Detail label="Duration Date" value={durationDate ? formatDate(String(durationDate)) : formatDuration(travelStart, travelEnd)} />
      <Detail
        label="Travel Start Date"
        value={travelStart === undefined ? '' : formatDate(String(travelStart))}
      />
      <Detail
        label="Expected Return Date"
        value={travelEnd === undefined ? '' : formatDate(String(travelEnd))}
      />
      <Detail label="Travel Destination" value={String(destination ?? '')} />
      <Detail
        label="Place of Duty"
        value={String(
          firstFromSources(sources, [
            'PlaceofDuty',
            'PlaceOfDuty',
            'Place_of_Duty',
            'DutyArea',
            'Duty_Area',
          ]) ?? '',
        )}
      />
      <Detail
        label="Job Grade"
        value={String(firstFromSources(sources, ['JobGrade', 'Job_Grade', 'Grade', 'SalaryGrade']) ?? '')}
      />
      <Detail
        label="Responsibility Center"
        value={String(
          firstFromSources(sources, ['ResponsibilityCenter', 'Responsibility_Center'])
            ?? fallback?.responsibleCenter
            ?? '',
        )}
      />
      <Detail
        label="Job Title"
        value={String(firstFromSources(sources, ['JobTitle', 'Job_Title', 'JobTitleDescription']) ?? '')}
      />
      <Detail
        label="Date Required"
        value={dateRequired === undefined ? '' : formatDate(String(dateRequired))}
      />
    </div>
  )
}

function imprestSurrenderListSearchExtra(row: PortalRequest): Array<string | number | undefined | null> {
  const payload = row.payload ?? {}
  return [
    payload.ImprestIssueDocNo,
    payload.Imprest_Issue_Doc_No,
    payload.ImprestNo,
    payload.TravelDestination,
    payload.Travel_Destination,
    payload.Destination,
    payload.Purpose,
  ].map((value) =>
    value === undefined || value === null ? value : typeof value === 'number' ? value : String(value),
  )
}

export function ImprestSurrender() {
  const receipts = useLookupOptions('posted-receipts')
  const imprestQuery = useQuery({
    queryKey: ['finance', 'imprest', 'for-surrender'],
    queryFn: () => listModuleRequests(imprestModule),
  })

  const imprestOptions = (imprestQuery.data ?? [])
    .filter(isSurrenderableImprest)
    .map((row) => ({
      label: row.requestNo,
      value: row.requestNo,
    }))

  return (
    <MultiStepRequestPage
      title="Imprest Surrender"
      headerLabel="New Imprest Surrender"
      description="Create: select imprest + Actual Return Date. Draft: enter Actual Spent on each line, save, then request approval."
      module={module}
      queryKey={['finance', 'imprest-surrender']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      listSearchExtra={imprestSurrenderListSearchExtra}
      newButtonLabel="New Imprest Surrender"
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      headerSchema={imprestSurrenderHeaderSchema}
      headerDefaults={{ imprest: '', actualReturnDate: today }}
      buildHeaderPayload={(values) => ({
        imprest: values.imprest,
        imprestIssueDocNo: values.imprest,
        actualReturnDate: String(values.actualReturnDate ?? ''),
        title: `Surrender for ${values.imprest}`,
      })}
      headerFields={[
        {
          name: 'imprest',
          label: 'Imprest to Surrender',
          type: 'select',
          valuePaths: ['ImprestIssueDocNo', 'Imprest_Issue_Doc_No', 'ImprestNo'],
          options: imprestOptions,
          placeholder: imprestQuery.isLoading ? 'Loading imprests…' : 'Select imprest',
        },
        {
          name: 'actualReturnDate',
          label: 'Actual Return Date',
          type: 'date',
          valuePaths: ['ActualReturnDate', 'Actual_Return_Date'],
        },
      ]}
      headerSupplement={(values) => {
        const imprestNo = String(values.imprest ?? '')
        const selected = (imprestQuery.data ?? []).find((row) => row.requestNo === imprestNo)
        return (
          <>
            <FinanceEmployeeOrgBanner />
            {imprestNo ? <ImprestSurrenderPreview imprestNo={imprestNo} fallback={selected} /> : null}
          </>
        )
      }}
      detailFields={[
        { label: 'Surrender No.', paths: ['request.requestNo'] },
        {
          label: 'Surrender Date',
          paths: ['payload.SurrenderDate', 'payload.Surrender_Date', 'payload.DateCreated', 'request.createdAt'],
          format: 'date',
        },
        { label: 'Imprest No.', paths: ['payload.ImprestIssueDocNo', 'payload.Imprest_Issue_Doc_No', 'payload.ImprestNo'] },
        {
          label: 'Travel Start Date',
          paths: ['payload.TravelStartDate', 'payload.Travel_Start_Date', 'payload.TravelDate'],
          format: 'date',
        },
        {
          label: 'Expected Return Date',
          paths: ['payload.ExpectedReturnDate', 'payload.Expected_Return_Date', 'payload.ReturnDate'],
          format: 'date',
        },
        {
          label: 'Actual Return Date',
          paths: ['payload.ActualReturnDate', 'payload.Actual_Return_Date'],
          format: 'date',
        },
        {
          label: 'Duration Date',
          paths: ['payload.DurationDate'],
          format: 'date',
        },
        {
          label: 'Travel Destination',
          paths: [
            'payload.TravelDestination',
            'payload.Travel_Destination',
            'payload.Destination',
            'payload.DestinationCode',
          ],
        },
        { label: 'Purpose', paths: ['payload.Purpose', 'request.title'] },
        ...financeOrgDetailFields,
        {
          label: 'Responsibility Center',
          paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
        },
        { label: 'Job Title', paths: ['payload.JobTitle', 'payload.Job_Title'] },
        {
          label: 'Job Grade',
          paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
        },
        {
          label: 'Place of Duty',
          paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.Place_of_Duty', 'payload.DutyArea'],
        },
        {
          label: 'Imprest Amount',
          paths: [
            'payload.TotalNetAmount',
            'payload.Total_Net_Amount',
            'payload.Net_Amount',
            'payload.Amount',
            'request.amount',
          ],
          format: 'currency',
        },
        {
          label: 'Balance (BC)',
          paths: ['payload.Balance', 'payload.OutstandingBalance'],
          format: 'currency',
        },
        {
          label: 'Balance Less this Entry (BC)',
          paths: [
            'payload.BalanceLessThisEntry',
            'payload.Balance_Less_This_Entry',
            'payload.Balance_Less_this_Entry',
          ],
          format: 'currency',
        },
        {
          label: 'Cash Surrender Amount (BC)',
          paths: [
            'payload.CashSurrenderAmt',
            'payload.Cash_Surrender_Amt',
            'payload.CashSurrenderAmount',
            'payload.Cash_Surrender_Amount',
          ],
          format: 'currency',
        },
        {
        label: 'Remaining Not Settled',
          paths: [
            'payload.RemainingUnsettledAmount',
            'payload.RemainingNotSettledAmount',
          ],
          format: 'currency',
        },
        {
          label: 'Surrender Status',
          paths: ['payload.SurrenderStatus', 'payload.Surrender_Status'],
        },
        { label: 'Status', paths: ['request.status'], format: 'status' },
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
      customLineSection={({ request, onChanged }) => (
        <ImprestSurrenderLinesEditor
          request={request}
          receiptOptions={receipts.options}
          onChanged={onChanged}
        />
      )}
      line={{
        label: 'Imprest Surrender Lines (synced with BC)',
        schema: imprestSurrenderHeaderSchema,
        defaultValues: {},
        canAdd: false,
        fields: [],
        columns: [],
      }}
    />
  )
}
