import { useCallback, useMemo } from 'react'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { PettyCashRequestTemplate } from '@/pages/finance/PettyCashRequestTemplate'
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

function isBlockedPaymentCode(option: LookupOption) {
  const hay = `${option.value} ${option.label}`.toUpperCase()
  return (
    hay.includes('SUPPLIER') ||
    hay.includes('VEND') ||
    hay.includes('WHT') ||
    hay.includes('WITHHOLD')
  )
}

export function PettyCash() {
  const paymentTypes = useLookupOptions('petty-cash-types', pettyCashTypeOptions)
  const expenseCategoryOptions = useMemo(
    () => paymentTypes.options.filter((option) => !isBlockedPaymentCode(option)),
    [paymentTypes.options],
  )

  const onLineValuesChange = useCallback(
    (values: FieldValues, form: UseFormReturn<FieldValues>) => {
      const type = String(values.type ?? '').trim()
      if (!type) {
        form.setValue('name', '', { shouldValidate: false })
        form.setValue('accountNo', '', { shouldValidate: false })
        form.setValue('accountName', '', { shouldValidate: false })
        return
      }
      const match = expenseCategoryOptions.find((option) => String(option.value).trim() === type)
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
    [expenseCategoryOptions],
  )

  return (
    <MultiStepRequestPage
      title="Petty Cash Request"
      headerLabel="New Petty Cash Request"
      description="Submit a request for petty cash to cover official business expenses. Create the request, add lines if needed, attach supporting documents, then request approval. Settlement of the cash remains a separate Finance step."
      module={module}
      queryKey={['finance', 'petty-cash']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      newButtonLabel="New Petty Cash Request"
      headerSchema={pettyCashHeaderSchema}
      headerDefaults={{ dateNeeded: today, description: '' }}
      buildHeaderPayload={(values) => ({
        ...values,
        title: String(values.description || 'Petty Cash Request'),
      })}
      customCreate={({ onCreated, onCancel }) => (
        <PettyCashRequestTemplate onCreated={onCreated} onCancel={onCancel} />
      )}
      headerFields={[
        {
          name: 'dateNeeded',
          label: 'Required Date',
          type: 'date',
          valuePaths: ['Needed_By_Date', 'RequiredDate', 'Required_Date', 'Date'],
        },
        {
          name: 'description',
          label: 'Purpose of Request',
          type: 'textarea',
          valuePaths: [
            'PaymentNarration',
            'Payment_Narration',
            'Posting_Description',
            'PostingDescription',
            'Narration',
          ],
        },
      ]}
      headerSupplement={() => <FinanceEmployeeOrgBanner />}
      requiresAttachmentBeforeSubmit
      requiredAttachmentMessage="Attach at least one supporting document before requesting approval for petty cash."
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        {
          label: 'Required Date',
          paths: [
            'payload.Needed_By_Date',
            'payload.RequiredDate',
            'payload.Required_Date',
            'payload.Date',
            'request.createdAt',
          ],
          format: 'date',
        },
        {
          label: 'Purpose of Request',
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
            label: 'Expense Category',
            type: 'select',
            options: expenseCategoryOptions,
            placeholder: paymentTypes.isLoading
              ? 'Loading expense categories…'
              : 'Select expense category',
            hint: 'Expense Category from Business Central (not Payment Type / supplier codes).',
          },
          {
            name: 'name',
            label: 'Category Name',
            type: 'text',
            readOnly: true,
            placeholder: 'Filled from the expense category',
          },
          {
            name: 'accountName',
            label: 'G/L Account',
            type: 'text',
            readOnly: true,
            placeholder: 'Filled from Business Central for the category',
          },
          { name: 'amount', label: 'Amount (ETB)', type: 'number' },
        ],
        columns: [
          { key: 'type', header: 'Category' },
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
