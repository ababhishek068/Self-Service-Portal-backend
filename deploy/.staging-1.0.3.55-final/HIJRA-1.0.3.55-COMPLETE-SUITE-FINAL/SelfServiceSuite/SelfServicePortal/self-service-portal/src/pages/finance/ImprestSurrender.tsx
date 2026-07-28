import { useQuery } from '@tanstack/react-query'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { fetchImprestSurrenderPreview } from '@/api/endpoints/imprest'
import { imprestSurrenderHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'

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
  if (startText && endText) return `${startText}-${endText}`
  return startText || endText || '—'
}

function Detail({ label, value }: { label: string; value: string }) {
  return (
    <div className="space-y-1.5">
      <p className="text-sm font-semibold text-slate-700">{label}</p>
      <p className="min-h-5 text-sm font-medium text-slate-950">{value || '—'}</p>
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
  const payload = { ...listPayload, ...(previewQuery.data ?? {}) }
  const amount = firstValue(payload, [
    'TotalNetAmount',
    'Total_Net_Amount',
    'NetAmount',
    'Net_Amount',
    'Amount',
    'PaidAmount',
    'Paid_Amount',
  ]) ?? fallback?.amount
  const dateRequired = firstValue(payload, [
    'PaymentReleaseDate',
    'Payment_Release_Date',
    'DateRequired',
    'Date_Required',
    'Date',
  ])
  const travelStart = firstValue(payload, [
    'TravelStartDate',
    'Travel_Start_Date',
    'TravelDate',
    'Travel_Date',
    'StartDate',
  ])
  const travelEnd = firstValue(payload, [
    'ExpectedReturnDate',
    'Expected_Return_Date',
    'ReturnDate',
    'Return_Date',
    'EndDate',
  ])
  const destination = firstValue(payload, [
    'TravelDestination',
    'Travel_Destination',
    'Destination',
    'DestinationCode',
  ])
  const outstanding = firstValue(payload, [
    'Balance',
    'OutstandingBalance',
    'Outstanding_Balance',
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
        value={String(firstValue(payload, ['Purpose', 'Description', 'ImpPurpose']) ?? fallback?.title ?? '')}
      />
      <Detail
        label="Imprest Amount"
        value={amount === undefined ? '—' : formatCurrency(Number(amount))}
      />
      <Detail
        label="Outstanding Balance"
        value={outstanding === undefined ? '—' : formatCurrency(Number(outstanding))}
      />
      <Detail label="Duration Date" value={formatDuration(travelStart, travelEnd)} />
      <Detail label="Travel Destination" value={String(destination ?? '')} />
      <Detail
        label="Department"
        value={String(
          firstValue(payload, [
            'DepartmentName',
            'Department_Name',
            'ShortcutDimension2Code',
            'Shortcut_Dimension_2_Code',
            'Department',
            'GlobalDimension1Code',
          ]) ?? fallback?.departmentName ?? fallback?.departmentCode ?? '',
        )}
      />
      <Detail
        label="Responsibility Center"
        value={String(
          firstValue(payload, ['ResponsibilityCenter', 'Responsibility_Center'])
            ?? fallback?.responsibleCenter
            ?? '',
        )}
      />
      <Detail
        label="Job Title"
        value={String(firstValue(payload, ['JobTitle', 'Job_Title', 'JobTitleDescription']) ?? '')}
      />
      <Detail
        label="Date Required"
        value={dateRequired === undefined ? '—' : formatDate(String(dateRequired))}
      />
    </div>
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
      description="Select the imprest to surrender. Surrender lines are generated from the imprest; enter the actual spent and cash receipt details, then request approval."
      module={module}
      queryKey={['finance', 'imprest-surrender']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      newButtonLabel="New Imprest Surrender"
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      headerSchema={imprestSurrenderHeaderSchema}
      headerDefaults={{ imprest: '' }}
      buildHeaderPayload={(values) => ({ imprest: values.imprest, title: `Surrender for ${values.imprest}` })}
      headerFields={[
        {
          name: 'imprest',
          label: 'Imprest to Surrender',
          type: 'select',
          valuePaths: ['ImprestIssueDocNo', 'Imprest_Issue_Doc_No', 'ImprestNo'],
          options: imprestOptions,
          placeholder: imprestQuery.isLoading ? 'Loading imprests…' : 'Select imprest',
        },
      ]}
      headerSupplement={(values) => {
        const imprestNo = String(values.imprest ?? '')
        const selected = (imprestQuery.data ?? []).find((row) => row.requestNo === imprestNo)
        if (!imprestNo) return null
        return <ImprestSurrenderPreview imprestNo={imprestNo} fallback={selected} />
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
          label: 'Duration Date',
          paths: ['payload.DurationDate', 'payload.TravelDate', 'payload.ReturnDate'],
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
          paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
        },
        { label: 'Job Title', paths: ['payload.JobTitle', 'payload.Job_Title'] },
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
          label: 'Outstanding Balance',
          paths: [
            'payload.Balance',
            'payload.BalanceLessthisEntry',
            'payload.BalanceLessThisEntry',
            'payload.Balance_Less_This_Entry',
            'payload.Balance_Less_this_Entry',
            'payload.OutstandingBalance',
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
          paths: ['payload.RejectionReason', 'payload.rejectionReason'],
        },
      ]}
      line={{
        label: 'Imprest Surrender Lines',
        schema: imprestSurrenderHeaderSchema,
        defaultValues: {},
        canAdd: false,
        fields: [],
        editableFields: [
          { name: 'actualSpent', label: 'Actual Spent', type: 'number' },
          { name: 'cashReceiptNo', label: 'Cash Receipt No.', type: 'select', options: receipts.options },
          { name: 'cashReceiptAmount', label: 'Cash Receipt Amount', type: 'number' },
        ],
        columns: [
          { key: 'accountNo', header: 'Account No.' },
          { key: 'surrenderDocNo', header: 'Surrender Doc No' },
          { key: 'accountName', header: 'Account Name' },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'actualSpent', header: 'Actual Spent', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'cashReceiptNo', header: 'Cash Receipt No.' },
          { key: 'cashReceiptAmount', header: 'Cash Receipt Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
        ],
        emptyText:
          'Lines are copied automatically from the selected imprest in Business Central. If this stays empty, the imprest has no lines in BC — add lines on the imprest first, or ask BC admin to publish the surrender line fix (PrepareSurrender).',
      }}
    />
  )
}
