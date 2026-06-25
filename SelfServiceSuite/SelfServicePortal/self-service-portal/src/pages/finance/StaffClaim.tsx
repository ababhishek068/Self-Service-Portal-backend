import { formatISO } from 'date-fns'
import { useCallback, useRef } from 'react'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { validateHospitalCategory } from '@/api/endpoints/claimCalc'
import type { LookupOption } from '@/api/endpoints/lookups'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { claimTypeOptions, hospitalCategoryOptions } from '@/data/essOptions'
import { staffClaimHeaderSchema, staffClaimLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'staffClaim', entity: 'selfServiceStaffClaims' } as const

function isMedicalClaim(claimType: unknown) {
  return String(claimType ?? '').toUpperCase().includes('MEDICAL')
}

function accountNameForNo(accountNo: string, glAccounts: LookupOption[]) {
  const match = glAccounts.find((option) => option.value === accountNo)
  if (!match) return ''
  const dash = match.label.indexOf(' - ')
  return dash >= 0 ? match.label.slice(dash + 3) : match.label
}

function glAccountForClaimType(claimType: string, claimTypes: LookupOption[]) {
  const selected = claimTypes.find((option) => option.value === claimType)
  return String(selected?.meta?.accountNo ?? '').trim()
}

function findMedicalAllowanceAccount(glAccounts: LookupOption[]) {
  return glAccounts.find((option) => option.label.toLowerCase().includes('medical allowance'))
}

let medicalAmountRequest = 0

async function applyMedicalClaimAmounts(values: FieldValues, form: UseFormReturn<FieldValues>) {
  if (!isMedicalClaim(values.claimType)) return
  const hospitalCategory = String(values.hospitalCategory ?? '').trim()
  const medicalAmount = Number(values.medicalAmount ?? 0)
  if (!hospitalCategory || !medicalAmount) return

  const requestKey = ++medicalAmountRequest
  try {
    const data = await validateHospitalCategory({ hospitalCategory, medicalAmount })
    if (requestKey !== medicalAmountRequest) return
    const amount = Number(data.Amount ?? data.amount ?? 0)
    const amountToRefund = Number(data.AmountToRefund ?? data.amountToRefund ?? 0)
    if (amount > 0) form.setValue('amount', amount, { shouldValidate: true })
    if (amountToRefund >= 0) form.setValue('amountToRefund', amountToRefund, { shouldValidate: true })
  } catch {
    // Keep manual entry when BC validation is unavailable.
  }
}

function useStaffClaimLineChange(claimTypes: LookupOption[], glAccounts: LookupOption[]) {
  const lastClaimTypeRef = useRef('')

  return useCallback(
    async (values: FieldValues, form: UseFormReturn<FieldValues>) => {
      const claimType = String(values.claimType ?? '').trim()
      if (!claimType) {
        lastClaimTypeRef.current = ''
        return
      }

      const claimTypeChanged = claimType !== lastClaimTypeRef.current
      if (claimTypeChanged) {
        lastClaimTypeRef.current = claimType
        if (!isMedicalClaim(claimType)) {
          form.setValue('hospitalCategory', '')
          form.setValue('medicalAmount', '')
          form.setValue('amountToRefund', '')
        }
      }

      const currentAccountNo = String(values.accountNo ?? '').trim()
      if (claimTypeChanged || (isMedicalClaim(claimType) && !currentAccountNo)) {
        let accountNo = glAccountForClaimType(claimType, claimTypes)
        if (!accountNo && isMedicalClaim(claimType)) {
          accountNo = findMedicalAllowanceAccount(glAccounts)?.value ?? ''
        }
        if (accountNo && currentAccountNo !== accountNo) {
          form.setValue('accountNo', accountNo, { shouldValidate: true })
        }
      }

      const accountNo = String(form.getValues('accountNo') ?? values.accountNo ?? '').trim()
      if (accountNo) {
        const accountName = accountNameForNo(accountNo, glAccounts)
        if (accountName && values.accountName !== accountName) {
          form.setValue('accountName', accountName, { shouldValidate: true })
        }
      }

      await applyMedicalClaimAmounts(values, form)
    },
    [claimTypes, glAccounts],
  )
}

export function StaffClaim() {
  const claimTypes = useLookupOptions('claim-types', claimTypeOptions)
  const glAccounts = useLookupOptions('gl-accounts')
  const onLineValuesChange = useStaffClaimLineChange(claimTypes.options, glAccounts.options)

  return (
    <MultiStepRequestPage
      title="Staff Claim"
      headerLabel="New Claim Request"
      description="Create a claim header, then add claim lines (claim type, GL account, hospital category, expenditure) before requesting approval."
      module={module}
      queryKey={['finance', 'staff-claim']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Claim Request"
      headerSchema={staffClaimHeaderSchema}
      headerDefaults={{ claimDate: today, purpose: '' }}
      buildHeaderPayload={(values) => ({ ...values, title: String(values.purpose || 'Staff Claim') })}
      headerFields={[
        { name: 'claimDate', label: 'Claim Date', type: 'date', readOnly: true, valuePaths: ['ClaimDate', 'Claim_Date', 'Date'] },
        { name: 'purpose', label: 'Claim Purpose', type: 'textarea', valuePaths: ['Purpose', 'ClaimDescription', 'Claim_Description'] },
      ]}
      detailFields={[
        { label: 'Claim No.', paths: ['request.requestNo'] },
        { label: 'Claim Date', paths: ['payload.ClaimDate', 'payload.Claim_Date'], format: 'date' },
        { label: 'Purpose', paths: ['payload.ClaimDescription', 'payload.Claim_Description', 'payload.Purpose'] },
        { label: 'Department', paths: ['request.departmentName', 'request.departmentCode', 'payload.ShortcutDimension2Code'] },
        { label: 'Responsibility Center', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
        { label: 'Place of Duty', paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'] },
        { label: 'Employee Account', paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.ImprestNo'] },
        { label: 'Total Net Amount', paths: ['payload.TotalNetAmount', 'request.amount'], format: 'currency' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
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
          medicalAmount: '',
          amount: '',
          amountToRefund: '',
          claimReceiptNo: '',
          expenditureDate: today,
          expenditureDescription: '',
        },
        buildLinePayload: (values) => {
          const accountNo = String(values.accountNo ?? '').trim()
          const { amountToRefund: _refund, ...rest } = values
          return {
            ...rest,
            accountName: accountNameForNo(accountNo, glAccounts.options) || String(values.accountName ?? ''),
          }
        },
        onValuesChange: onLineValuesChange,
        fields: [
          { name: 'claimType', label: 'Claim Type', type: 'select', options: claimTypes.options },
          { name: 'accountNo', label: 'Account No.', type: 'select', options: glAccounts.options },
          {
            name: 'hospitalCategory',
            label: 'Hospital Category',
            type: 'select',
            options: hospitalCategoryOptions,
          },
          {
            name: 'medicalAmount',
            label: 'Medical Amount',
            type: 'number',
            visibleWhen: (values) => isMedicalClaim(values.claimType),
          },
          {
            name: 'amount',
            label: 'Amount',
            type: 'number',
            readOnlyWhen: (values) => isMedicalClaim(values.claimType),
          },
          {
            name: 'amountToRefund',
            label: 'Amount to Refund',
            type: 'number',
            readOnly: true,
            visibleWhen: (values) => isMedicalClaim(values.claimType),
          },
          { name: 'claimReceiptNo', label: 'Claim Receipt No.', type: 'text' },
          { name: 'expenditureDate', label: 'Expenditure Date', type: 'date', readOnly: true },
          { name: 'expenditureDescription', label: 'Expenditure Description', type: 'textarea' },
        ],
        columns: [
          { key: 'claimType', header: 'Claim Type' },
          { key: 'accountNo', header: 'Account No' },
          { key: 'accountName', header: 'Account Name' },
          { key: 'hospitalCategory', header: 'Hospital Category' },
          { key: 'medicalAmount', header: 'Medical Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'amountToRefund', header: 'Amount to Refund', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'claimReceiptNo', header: 'Claim Receipt No.' },
          { key: 'expenditureDate', header: 'Expenditure Date' },
          { key: 'expenditureDescription', header: 'Expenditure Description' },
        ],
        emptyText: '*** No Claim Lines Found ***',
        canEdit: false,
      }}
    />
  )
}
