import { useQuery } from '@tanstack/react-query'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
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
  // ESS lets you surrender against a posted/approved imprest. Offer those as the picker source.
  const imprestQuery = useQuery({
    queryKey: ['finance', 'imprest', 'for-surrender'],
    queryFn: () => listModuleRequests(imprestModule),
  })

  const surrenderable = (imprestQuery.data ?? []).filter(isSurrenderableImprest)
  const imprestOptions = surrenderable.map((row) => ({
    label: `${row.requestNo}${row.status && row.status !== 'Posted' ? ` (${row.status})` : ''}`,
    value: row.requestNo,
  }))
  const emptyImprestHint = imprestQuery.isLoading
    ? 'Loading imprests…'
    : imprestQuery.isError
      ? 'Could not load imprests from Business Central.'
      : (imprestQuery.data ?? []).length === 0
        ? 'No imprest requisitions found for your employee number.'
        : surrenderable.length === 0
          ? 'No posted or approved imprest is available to surrender. Finance must post the imprest in Business Central first, and fully surrendered imprests are excluded.'
          : 'Select imprest'

  return (
    <MultiStepRequestPage
      title="Imprest Surrender"
      headerLabel="New Imprest Surrender"
      description="Select a posted or approved imprest to surrender. Enter Actual Spent. Cash Receipt No. is only needed when unused cash is returned (fully spent → leave blank / amount 0). Then request approval."
      module={module}
      queryKey={['finance', 'imprest-surrender']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Imprest Surrender"
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
          placeholder: emptyImprestHint,
        },
      ]}
      headerSupplement={(values) => {
        const selected = (imprestQuery.data ?? []).find(
          (row) => row.requestNo === String(values.imprest ?? ''),
        )
        const payload = selected?.payload ?? {}
        const amount = firstValue(payload, ['TotalNetAmount', 'Total_Net_Amount', 'NetAmount'])
          ?? selected?.amount
        const dateRequired = firstValue(payload, [
          'PaymentReleaseDate',
          'Payment_Release_Date',
          'DateRequired',
          'Date_Required',
        ])

        return (
          <div className="grid gap-x-8 gap-y-5 border-y border-slate-200 py-4 sm:grid-cols-2 lg:grid-cols-3">
            <Detail
              label="Imprest Purpose"
              value={String(firstValue(payload, ['Purpose', 'Description']) ?? selected?.title ?? '')}
            />
            <Detail
              label="Imprest Amount"
              value={amount === undefined ? '—' : formatCurrency(Number(amount))}
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
              label="Date Required"
              value={dateRequired === undefined ? '—' : formatDate(String(dateRequired))}
            />
          </div>
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
          label: 'Imprest Amount',
          paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'payload.Amount', 'request.amount'],
          format: 'currency',
        },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Imprest Surrender Lines',
        schema: imprestSurrenderHeaderSchema,
        defaultValues: {},
        canAdd: false,
        fields: [],
        editableFields: [
          { name: 'actualSpent', label: 'Actual Spent', type: 'number' },
          {
            name: 'cashReceiptNo',
            label: 'Cash Receipt No. (optional if fully spent)',
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
          { key: 'accountNo', header: 'Account No.' },
          { key: 'surrenderDocNo', header: 'Surrender Doc No' },
          { key: 'accountName', header: 'Account Name' },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'actualSpent', header: 'Actual Spent' },
          { key: 'cashReceiptNo', header: 'Cash Receipt No.' },
          { key: 'cashReceiptAmount', header: 'Cash Receipt Amount' },
        ],
        emptyText: '*** No surrender lines ***',
      }}
    />
  )
}
