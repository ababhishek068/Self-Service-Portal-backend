import { useCallback } from 'react'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import type { LookupOption } from '@/api/endpoints/lookups'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { pettyCashTypeOptions } from '@/data/essOptions'
import { pettyCashHeaderSchema, pettyCashLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'pettyCash', entity: 'selfServicePettyCashRequests' } as const

function accountDisplay(option: LookupOption | undefined) {
  if (!option) return ''
  const accountNo = String(option.meta?.accountNo ?? '').trim()
  const accountName = String(option.meta?.accountName ?? '').trim()
  if (accountNo && accountName) return `${accountNo} — ${accountName}`
  if (accountNo) return accountNo
  if (accountName) return accountName
  return ''
}

export function PettyCash() {
  const paymentTypes = useLookupOptions('petty-cash-types', pettyCashTypeOptions)

  const onLineValuesChange = useCallback(
    (values: FieldValues, form: UseFormReturn<FieldValues>) => {
      const type = String(values.type ?? '').trim()
      if (!type) {
        form.setValue('name', '', { shouldValidate: false })
        form.setValue('accountNo', '', { shouldValidate: false })
        form.setValue('accountName', '', { shouldValidate: false })
        return
      }
      const match = paymentTypes.options.find((option) => String(option.value).trim() === type)
      const label = String(match?.label ?? '').trim()
      const accountNo = String(match?.meta?.accountNo ?? '').trim()
      const accountName = String(match?.meta?.accountName ?? '').trim()
      const display = accountDisplay(match)
      if (label && String(form.getValues('name') ?? '') !== label) {
        form.setValue('name', label, { shouldValidate: false })
      }
      if (String(form.getValues('accountNo') ?? '') !== accountNo) {
        form.setValue('accountNo', accountNo, { shouldValidate: false })
      }
      if (String(form.getValues('accountName') ?? '') !== (display || accountName)) {
        form.setValue('accountName', display || accountName, { shouldValidate: false })
      }
    },
    [paymentTypes.options],
  )

  return (
    <MultiStepRequestPage
      title="Petty Cash Settlement"
      headerLabel="New Petty Cash Settlement"
      description="Create a petty cash settlement header, then add settlement lines (payment type, G/L account from Business Central, and amount) before requesting approval. Department float limits apply on Petty Cash Request (replenishment), not on settlement."
      module={module}
      queryKey={['finance', 'petty-cash']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      newButtonLabel="New Petty Cash Settlement"
      headerSchema={pettyCashHeaderSchema}
      headerDefaults={{ dateNeeded: today, description: '' }}
      buildHeaderPayload={(values) => ({ ...values, title: String(values.description || 'Petty Cash Settlement') })}
      headerFields={[
        { name: 'dateNeeded', label: 'Needed By Date', type: 'date', valuePaths: ['Needed_By_Date', 'RequiredDate', 'Required_Date', 'Date'] },
        { name: 'description', label: 'Petty Cash Description & Reason', type: 'textarea', valuePaths: ['PaymentNarration', 'Payment_Narration', 'Posting_Description', 'PostingDescription', 'Narration'] },
      ]}
      headerSupplement={() => <FinanceEmployeeOrgBanner />}
      requiresAttachmentBeforeSubmit
      requiredAttachmentMessage="Attach at least one supporting document before requesting approval for petty cash."
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        {
          label: 'Needed By Date',
          paths: ['payload.Needed_By_Date', 'payload.RequiredDate', 'payload.Required_Date', 'payload.Date', 'request.createdAt'],
          format: 'date',
        },
        {
          label: 'Description',
          paths: [
            'payload.PaymentNarration',
            'payload.Payment_Narration',
            'payload.Posting_Description',
            'payload.PostingDescription',
            'payload.Narration',
          ],
        },
        ...financeOrgDetailFields,
        {
          label: 'Job Title',
          paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
        },
        {
          label: 'Job Grade',
          paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
        },
        {
          label: 'Place of Duty',
          paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.Place_of_Duty', 'payload.DutyArea'],
        },
        {
          label: 'Responsibility Center',
          paths: [
            'request.responsibleCenter',
            'payload.ResponsibilityCenter',
            'payload.Responsibility_Center',
          ],
        },
        {
          label: 'Total Net Amount',
          paths: [
            'payload.TotalNetAmount',
            'payload.Total_Net_Amount',
            'payload.TotalPaymentAmount',
            'payload.Total_Payment_Amount',
            'payload.Amount',
            'request.amount',
          ],
          format: 'currency',
        },
        { label: 'Status', paths: ['request.status'], format: 'status' },
        {
          label: 'Rejection Reason',
          paths: ['payload.RejectionReason', 'payload.rejectionReason', 'payload.Comment', 'payload.Comments'],
        },
      ]}
      line={{
        label: 'Petty Cash Lines',
        addLabel: 'Add Line',
        schema: pettyCashLineSchema,
        defaultValues: { type: '', name: '', accountNo: '', accountName: '', amount: 0 },
        onValuesChange: onLineValuesChange,
        buildLinePayload: (values) => ({
          type: String(values.type ?? '').trim(),
          name: String(values.name ?? '').trim(),
          amount: Number(values.amount ?? 0),
        }),
        fields: [
          {
            name: 'type',
            label: 'Payment Type',
            type: 'select',
            options: paymentTypes.options,
            placeholder: paymentTypes.isLoading
              ? 'Loading payment types from Business Central…'
              : 'Select payment type',
          },
          {
            name: 'name',
            label: 'Type Name',
            type: 'text',
            readOnly: true,
            placeholder: 'Filled from the payment type',
          },
          {
            name: 'accountName',
            label: 'G/L Account',
            type: 'text',
            readOnly: true,
            placeholder: 'Filled from Business Central for the payment type',
          },
          { name: 'amount', label: 'Amount', type: 'number' },
        ],
        columns: [
          { key: 'type', header: 'Type' },
          { key: 'name', header: 'Name' },
          {
            key: 'accountName',
            header: 'G/L Account',
            format: (value, row) => {
              const display = String(value ?? '').trim()
              if (display) return display
              const accountNo = String(row.accountNo ?? '').trim()
              return accountNo || '—'
            },
          },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
        ],
        emptyText: '*** No Petty Cash Lines Found ***',
      }}
    />
  )
}
