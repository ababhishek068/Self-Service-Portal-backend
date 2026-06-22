import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { claimTypeOptions, hospitalCategoryOptions } from '@/data/essOptions'
import { staffClaimHeaderSchema, staffClaimLineSchema } from '@/schemas/requestSchemas'
import { isMedicalClaimType, stripNonMedicalClaimFields } from '@/utils/claimHelpers'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'staffClaim', entity: 'selfServiceStaffClaims' } as const

export function StaffClaim() {
  const claimTypes = useLookupOptions('claim-types', claimTypeOptions)
  const glAccounts = useLookupOptions('gl-accounts')

  return (
    <MultiStepRequestPage
      title="Staff Claim"
      headerLabel="New Claim Request"
      description="Create a claim header, then add claim lines (claim type, GL account, expenditure) before requesting approval."
      module={module}
      queryKey={['finance', 'staff-claim']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Claim Request"
      headerSchema={staffClaimHeaderSchema}
      headerDefaults={{ claimDate: today, purpose: '' }}
      buildHeaderPayload={(values) => ({ ...values, title: String(values.purpose || 'Staff Claim') })}
      headerFields={[
        { name: 'claimDate', label: 'Claim Date', type: 'date', valuePaths: ['ClaimDate', 'Claim_Date', 'Date'] },
        { name: 'purpose', label: 'Claim Purpose', type: 'textarea', valuePaths: ['Purpose', 'ClaimDescription', 'Claim_Description'] },
      ]}
      line={{
        label: 'Claim Lines',
        addLabel: 'Add Claim Line',
        schema: staffClaimLineSchema,
        defaultValues: {
          claimType: '',
          accountNo: '',
          accountName: '',
          hospitalCategory: '',
          medicalAmount: 0,
          amount: 0,
          claimReceiptNo: '',
          expenditureDate: today,
          expenditureDescription: '',
        },
        fields: [
          { name: 'claimType', label: 'Claim Type', type: 'select', options: claimTypes.options },
          { name: 'accountNo', label: 'Account No.', type: 'select', options: glAccounts.options },
          {
            name: 'accountName',
            label: 'Account Name',
            type: 'text',
            readOnly: true,
            visibleWhen: (values) => Boolean(values.accountNo),
          },
          {
            name: 'hospitalCategory',
            label: 'Hospital Category',
            type: 'select',
            options: hospitalCategoryOptions,
            visibleWhen: (values) => isMedicalClaimType(values.claimType),
          },
          {
            name: 'medicalAmount',
            label: 'Medical Amount',
            type: 'number',
            visibleWhen: (values) => isMedicalClaimType(values.claimType),
          },
          { name: 'amount', label: 'Amount', type: 'number' },
          { name: 'claimReceiptNo', label: 'Claim Receipt No.', type: 'text' },
          { name: 'expenditureDate', label: 'Expenditure Date', type: 'date' },
          { name: 'expenditureDescription', label: 'Expenditure Description', type: 'textarea' },
        ],
        buildLinePayload: (values) => stripNonMedicalClaimFields(values as Record<string, unknown>),
        onValuesChange: (values, setValue) => {
          const claimType = String(values.claimType ?? '')
          if (claimType) {
            const match = claimTypes.options.find((option) => option.value === claimType)
            const linkedAccount = match?.meta?.accountNo
            if (linkedAccount) setValue('accountNo', String(linkedAccount))
          }
          if (!isMedicalClaimType(values.claimType)) {
            setValue('hospitalCategory', '')
            setValue('medicalAmount', 0)
          }
          const accountNo = String(values.accountNo ?? '')
          if (accountNo) {
            const account = glAccounts.options.find((option) => option.value === accountNo)
            if (account) setValue('accountName', account.label)
          } else {
            setValue('accountName', '')
          }
        },
        columns: [
          { key: 'claimType', header: 'Claim Type' },
          { key: 'accountNo', header: 'Account No' },
          { key: 'accountName', header: 'Account Name' },
          { key: 'hospitalCategory', header: 'Hospital Category' },
          { key: 'medicalAmount', header: 'Medical Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'claimReceiptNo', header: 'Claim Receipt No.' },
          { key: 'expenditureDate', header: 'Expenditure Date' },
          { key: 'expenditureDescription', header: 'Expenditure Description' },
        ],
        emptyText: '*** No Claim Lines Found ***',
      }}
    />
  )
}
