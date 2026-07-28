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

function claimTypeCode(value: unknown) {
  const raw = String(value ?? '').trim()
  const base = raw.split(' - ')[0]?.trim() ?? raw
  if (base.toUpperCase().includes('MEDICAL') || base.toUpperCase().startsWith('MED')) return 'MEDICAL'
  return base || raw
}

function isMedicalClaim(claimType: unknown) {
  return claimTypeCode(claimType) === 'MEDICAL'
}

function isOtherClaim(claimType: unknown) {
  return claimTypeCode(claimType).toUpperCase() === 'OTHER'
}

function medicalClaimTypeOptions(options: LookupOption[]) {
  const medical = options.filter(
    (option) => isMedicalClaim(option.value) || isMedicalClaim(option.label),
  )
  return medical.length > 0 ? medical : claimTypeOptions.filter((option) => option.value === 'MEDICAL')
}

function accountNameForNo(accountNo: string, glAccounts: LookupOption[]) {
  const match = glAccounts.find((option) => option.value === accountNo)
  if (!match) return ''
  const dash = match.label.indexOf(' - ')
  return dash >= 0 ? match.label.slice(dash + 3) : match.label
}

function glAccountForClaimType(claimType: string, claimTypes: LookupOption[]) {
  const code = claimTypeCode(claimType)
  const selected =
    claimTypes.find((option) => option.value === claimType) ??
    claimTypes.find((option) => claimTypeCode(option.value) === code)
  return String(selected?.meta?.accountNo ?? '').trim()
}

function findMedicalAllowanceAccount(glAccounts: LookupOption[]) {
  return glAccounts.find((option) => option.label.toLowerCase().includes('medical allowance'))
}

function accountDisplay(accountNo: string, accountName: string) {
  if (!accountNo) return ''
  return accountName ? `${accountNo} — ${accountName}` : accountNo
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
  } catch (err) {
    form.setError('amount', {
      type: 'manual',
      message:
        err instanceof Error
          ? err.message
          : 'Could not calculate claim amount from Business Central',
    })
  }
}

function useStaffClaimLineChange(claimTypes: LookupOption[], glAccounts: LookupOption[]) {
  const lastClaimTypeRef = useRef('')

  return useCallback(
    async (values: FieldValues, form: UseFormReturn<FieldValues>) => {
      const claimType = String(values.claimType ?? '').trim()
      if (!claimType) {
        lastClaimTypeRef.current = ''
        form.setValue('accountNo', '', { shouldValidate: false })
        form.setValue('accountName', '', { shouldValidate: false })
        return
      }

      const claimTypeChanged = claimType !== lastClaimTypeRef.current
      if (claimTypeChanged) {
        lastClaimTypeRef.current = claimType
        form.clearErrors('claimType')
        form.clearErrors('amount')

        if (!isMedicalClaim(claimType)) {
          form.setValue('hospitalCategory', '', { shouldValidate: false })
          form.setValue('medicalAmount', '', { shouldValidate: false })
          form.setValue('amountToRefund', '', { shouldValidate: false })
          if (!isOtherClaim(claimType)) {
            form.setValue('amount', '', { shouldValidate: false })
          }
        } else {
          form.setValue('amount', '', { shouldValidate: false })
          form.setValue('amountToRefund', '', { shouldValidate: false })
        }

        let accountNo = glAccountForClaimType(claimType, claimTypes)
        if (!accountNo && isMedicalClaim(claimType)) {
          accountNo = findMedicalAllowanceAccount(glAccounts)?.value ?? ''
        }
        form.setValue('accountNo', accountNo, { shouldValidate: true })
        if (accountNo) {
          const accountName = accountNameForNo(accountNo, glAccounts)
          form.setValue('accountName', accountDisplay(accountNo, accountName), { shouldValidate: false })
        } else {
          form.setValue('accountName', '', { shouldValidate: false })
          form.setError('claimType', {
            type: 'manual',
            message: 'This claim type has no G/L account in Business Central',
          })
        }
      }

      await applyMedicalClaimAmounts(values, form)
    },
    [claimTypes, glAccounts],
  )
}

function hospitalCategoryLabel(value: unknown) {
  const code = String(value ?? '').trim()
  const match = hospitalCategoryOptions.find((option) => option.value === code)
  return match?.label ?? (code || '—')
}

export function StaffClaim({ medicalOnly = false }: { medicalOnly?: boolean }) {
  const claimTypesQuery = useLookupOptions('claim-types', claimTypeOptions)
  const glAccounts = useLookupOptions('gl-accounts')
  const claimTypeChoices = medicalOnly
    ? medicalClaimTypeOptions(claimTypesQuery.options)
    : claimTypesQuery.options.length > 0
      ? claimTypesQuery.options
      : claimTypeOptions
  const defaultMedicalClaimType = claimTypeChoices[0]?.value ?? 'MEDICAL'
  const claimTypePlaceholder = claimTypesQuery.isLoading
    ? 'Loading claim types from Business Central…'
    : claimTypesQuery.isError
      ? 'Could not load claim types'
      : 'Select claim type'
  const onLineValuesChange = useStaffClaimLineChange(claimTypeChoices, glAccounts.options)

  return (
    <MultiStepRequestPage
      title={medicalOnly ? 'Medical Claim' : 'Staff Claims'}
      headerLabel={medicalOnly ? 'New Medical Claim' : 'New Staff Claim'}
      description={
        medicalOnly
          ? 'Add claim lines with hospital category and medical amount — Business Central calculates the refund amount and G/L account.'
          : 'Add claim lines by type. Business Central sets the G/L account from the claim type; you enter amount and expenditure details.'
      }
      module={module}
      queryKey={medicalOnly ? ['hr', 'staff-medical-claim'] : ['finance', 'staff-claim']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      newButtonLabel={medicalOnly ? 'New Medical Claim' : 'New Staff Claim'}
      headerSchema={staffClaimHeaderSchema}
      headerDefaults={{ claimDate: today, purpose: medicalOnly ? 'Medical Claim' : '' }}
      buildHeaderPayload={(values) => ({
        ...values,
        title: String(values.purpose || (medicalOnly ? 'Medical Claim' : 'Staff Claim')),
      })}
      headerFields={[
        { name: 'claimDate', label: 'Claim Date', type: 'date', readOnly: true, valuePaths: ['ClaimDate', 'Claim_Date', 'Date'] },
        { name: 'purpose', label: 'Claim Purpose', type: 'textarea', valuePaths: ['Purpose', 'ClaimDescription', 'Claim_Description'] },
      ]}
      detailFields={[
        { label: 'Claim No.', paths: ['request.requestNo'] },
        { label: 'Claim Date', paths: ['payload.ClaimDate', 'payload.Claim_Date', 'request.createdAt'], format: 'date' },
        { label: 'Purpose', paths: ['payload.ClaimDescription', 'payload.Claim_Description', 'payload.Purpose', 'request.title'] },
        { label: 'Division', paths: ['payload.Division', 'payload.GlobalDimension1Code'] },
        {
          label: 'Department / District',
          paths: [
            'request.departmentName',
            'request.departmentCode',
            'payload.DepartmentName',
            'payload.Department',
            'payload.ShortcutDimension2Code',
            'payload.District',
          ],
        },
        { label: 'Job Title', paths: ['payload.JobTitle', 'payload.Job_Title', 'request.responsibleCenter'] },
        { label: 'Job Grade', paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade'] },
        {
          label: 'Responsibility Center',
          paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
        },
        { label: 'Total Net Amount', paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'request.amount'], format: 'currency' },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
      line={{
        label: 'Claim Lines',
        addLabel: 'Add Claim Line',
        schema: staffClaimLineSchema,
        defaultValues: {
          claimType: medicalOnly ? defaultMedicalClaimType : '',
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
          const claimType = claimTypeCode(values.claimType)
          const accountNo = String(values.accountNo ?? '').trim()
          const payload: Record<string, unknown> = {
            claimType,
            accountNo,
            hospitalCategory: isMedicalClaim(values.claimType) ? values.hospitalCategory : '',
            medicalAmount: isMedicalClaim(values.claimType) ? Number(values.medicalAmount ?? 0) : 0,
            amount: Number(values.amount ?? 0),
            claimReceiptNo: values.claimReceiptNo ?? '',
            expenditureDate: values.expenditureDate,
            expenditureDescription: values.expenditureDescription,
          }
          if (isOtherClaim(values.claimType)) {
            const refund = Number(values.amountToRefund ?? 0)
            const amount = Number(values.amount ?? 0)
            if (refund > 0 && amount <= 0) payload.amount = refund
            if (refund > 0) payload.amountToRefund = refund
          } else if (isMedicalClaim(values.claimType)) {
            payload.amountToRefund = Number(values.amountToRefund ?? 0)
          }
          return payload
        },
        onValuesChange: onLineValuesChange,
        fields: [
          {
            name: 'claimType',
            label: 'Claim Type',
            type: 'select',
            options: claimTypeChoices,
            placeholder: claimTypePlaceholder,
          },
          {
            name: 'accountName',
            label: 'G/L Account (from Business Central)',
            type: 'text',
            readOnly: true,
            placeholder: 'Set automatically when you choose claim type',
            visibleWhen: (values) => Boolean(String(values.accountNo ?? '').trim()),
          },
          {
            name: 'hospitalCategory',
            label: 'Hospital Category',
            type: 'select',
            options: hospitalCategoryOptions,
            visibleWhen: (values) => isMedicalClaim(values.claimType),
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
            placeholder: 'Enter amount (or auto-calculated for medical claims)',
          },
          {
            name: 'amountToRefund',
            label: 'Amount to Refund',
            type: 'number',
            readOnlyWhen: (values) => isMedicalClaim(values.claimType),
            visibleWhen: (values) => isMedicalClaim(values.claimType) || isOtherClaim(values.claimType),
          },
          { name: 'claimReceiptNo', label: 'Claim Receipt No.', type: 'text' },
          { name: 'expenditureDate', label: 'Expenditure Date', type: 'date', readOnly: true },
          { name: 'expenditureDescription', label: 'Expenditure Description', type: 'textarea', fullWidth: true },
        ],
        columns: [
          { key: 'claimType', header: 'Claim Type' },
          { key: 'accountNo', header: 'Account No' },
          { key: 'accountName', header: 'Account Name' },
          {
            key: 'hospitalCategory',
            header: 'Hospital Category',
            format: (value) => hospitalCategoryLabel(value),
          },
          { key: 'medicalAmount', header: 'Medical Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'amountToRefund', header: 'Amount to Refund', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'claimReceiptNo', header: 'Claim Receipt No.' },
          { key: 'expenditureDate', header: 'Expenditure Date' },
          { key: 'expenditureDescription', header: 'Expenditure Description' },
        ],
        emptyText: '*** No Claim Lines Found ***',
      }}
    />
  )
}
