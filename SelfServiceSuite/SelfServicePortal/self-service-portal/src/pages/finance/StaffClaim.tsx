import { useCallback, useRef } from 'react'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { validateHospitalCategory } from '@/api/endpoints/claimCalc'
import type { LookupOption } from '@/api/endpoints/lookups'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { claimTypeOptions, hospitalCategoryOptions } from '@/data/essOptions'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { staffClaimHeaderSchema, staffClaimLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { todayIsoDate } from '@/utils/validators'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const module = { module: 'staffClaim', entity: 'selfServiceStaffClaims' } as const

const HOSPITAL_REFUND_RATE: Record<string, number> = { '0': 1, '1': 0.6, '2': 0.9 }

function claimTypeCode(value: unknown) {
  const raw = String(value ?? '').trim()
  const base = raw.split(' - ')[0]?.trim() ?? raw
  const upper = base.toUpperCase()
  if (upper.includes('MEDICAL') || upper.startsWith('MED')) return 'MEDICAL'
  if (upper.startsWith('ACC')) return 'ACC'
  return base || raw
}

function isMedicalClaim(claimType: unknown) {
  return claimTypeCode(claimType) === 'MEDICAL'
}

function isDependantPatient(patient: unknown) {
  const normalized = String(patient ?? '').trim().toLowerCase()
  return normalized === 'dependant' || normalized === 'dependent' || normalized === '2'
}

function isOtherClaim(claimType: unknown) {
  return claimTypeCode(claimType).toUpperCase() === 'OTHER'
}

/** Keep ABH's known claim types visible even when the BC lookup is incomplete. */
function mergeClaimTypeOptions(bc: LookupOption[], seeds: LookupOption[]) {
  const byCode = new Map<string, LookupOption>()
  for (const seed of seeds) byCode.set(claimTypeCode(seed.value), seed)
  for (const row of bc) {
    const code = claimTypeCode(row.value)
    if (!code) continue
    const previous = byCode.get(code)
    byCode.set(code, {
      value: code,
      label: row.label || previous?.label || code,
      meta: row.meta ?? previous?.meta,
    })
  }
  return [...byCode.values()]
}

function medicalClaimTypeOptions(options: LookupOption[]) {
  const medical = options.filter(
    (option) => isMedicalClaim(option.value) || isMedicalClaim(option.label),
  )
  return medical.length > 0 ? medical : claimTypeOptions.filter((option) => option.value === 'MEDICAL')
}

function accountNameForNo(accountNo: string, glAccounts: LookupOption[]) {
  const normalizedAccountNo = accountNo.trim().toUpperCase()
  const match = glAccounts.find(
    (option) => String(option.value).trim().toUpperCase() === normalizedAccountNo,
  )
  if (!match) return ''
  const dash = match.label.indexOf(' - ')
  return dash >= 0 ? match.label.slice(dash + 3) : match.label
}

function claimTypeDisplay(value: unknown, claimTypes: LookupOption[]) {
  const raw = String(value ?? '').trim()
  const code = claimTypeCode(raw)
  const match =
    claimTypes.find((option) => String(option.value).trim() === raw) ??
    claimTypes.find((option) => claimTypeCode(option.value) === code)
  return match?.label || raw
}

function lineHasAccountName(line: Record<string, unknown>, glAccounts: LookupOption[]) {
  return Boolean(
    String(line.accountName ?? '').trim() ||
      accountNameForNo(String(line.accountNo ?? ''), glAccounts),
  )
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

function localMedicalRefund(hospitalCategory: string, medicalAmount: number) {
  const rate = HOSPITAL_REFUND_RATE[hospitalCategory] ?? HOSPITAL_REFUND_RATE['0']
  const amountToRefund = Math.round(medicalAmount * rate * 100) / 100
  return { amount: amountToRefund, amountToRefund, coveragePercent: rate * 100 }
}

async function applyMedicalClaimAmounts(values: FieldValues, form: UseFormReturn<FieldValues>) {
  if (!isMedicalClaim(values.claimType)) return
  const hospitalCategory = String(values.hospitalCategory ?? '').trim()
  const medicalAmount = Number(values.medicalAmount ?? 0)
  if (!hospitalCategory || !medicalAmount) return

  const requestKey = ++medicalAmountRequest
  try {
    const data = await validateHospitalCategory({ hospitalCategory, medicalAmount })
    if (requestKey !== medicalAmountRequest) return
    let amount = Number(data.Amount ?? data.amount ?? 0)
    let amountToRefund = Number(data.AmountToRefund ?? data.amountToRefund ?? 0)
    let coveragePercent = Number(data.coveragePercent ?? data.CoveragePercent ?? 0)
    if (amountToRefund <= 0) {
      const fallback = localMedicalRefund(hospitalCategory, medicalAmount)
      amount = fallback.amount
      amountToRefund = fallback.amountToRefund
      coveragePercent = fallback.coveragePercent
    }
    const netAmount = amountToRefund > 0 ? amountToRefund : amount
    if (netAmount > 0) form.setValue('amount', netAmount, { shouldValidate: true })
    if (amountToRefund >= 0) form.setValue('amountToRefund', amountToRefund, { shouldValidate: true })
    if (coveragePercent > 0) form.setValue('coveragePercent', coveragePercent, { shouldValidate: false })
  } catch {
    // ABH can still use its configured reimbursement rates while SOAP is down.
    const fallback = localMedicalRefund(hospitalCategory, medicalAmount)
    form.setValue('amount', fallback.amount, { shouldValidate: true })
    form.setValue('amountToRefund', fallback.amountToRefund, { shouldValidate: true })
    form.setValue('coveragePercent', fallback.coveragePercent, { shouldValidate: false })
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
          form.setValue('patient', '', { shouldValidate: false })
          form.setValue('relationship', '', { shouldValidate: false })
          form.setValue('dependant', '', { shouldValidate: false })
          form.setValue('dependantDateOfBirth', '', { shouldValidate: false })
          if (!isOtherClaim(claimType)) {
            form.setValue('amount', '', { shouldValidate: false })
          }
        } else {
          form.setValue('amount', '', { shouldValidate: false })
          form.setValue('amountToRefund', '', { shouldValidate: false })
          if (!String(form.getValues('patient') ?? '').trim()) {
            form.setValue('patient', 'self', { shouldValidate: false })
          }
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
          // Some existing BC claim types (for example GOV in UAT) have no
          // configured G/L mapping. Preserve the previously-working flow by
          // letting the requester choose the G/L account manually below.
        }
      }

      const selectedAccountNo = String(
        form.getValues('accountNo') ?? values.accountNo ?? '',
      ).trim()
      if (selectedAccountNo) {
        // An account is resolved, so drop any stale "account required" error —
        // it otherwise survives on the field and blocks submitting the claim.
        form.clearErrors('accountNo')
        const accountName = accountNameForNo(selectedAccountNo, glAccounts)
        const display = accountDisplay(selectedAccountNo, accountName)
        if (String(form.getValues('accountName') ?? '') !== display) {
          form.setValue('accountName', display, { shouldValidate: false })
        }
      }

      if (isMedicalClaim(claimType)) {
        const patient = values.patient ?? form.getValues('patient') ?? 'self'
        if (!isDependantPatient(patient)) {
          if (String(form.getValues('relationship') ?? '')) {
            form.setValue('relationship', '', { shouldValidate: false })
          }
          if (String(form.getValues('dependant') ?? '')) {
            form.setValue('dependant', '', { shouldValidate: false })
          }
          form.setValue('dependantDateOfBirth', '', { shouldValidate: false })
        }
      }

      await applyMedicalClaimAmounts(values, form)
    },
    [claimTypes, glAccounts],
  )
}

const medicalPatientOptions = [
  { value: 'self', label: 'Self' },
  { value: 'dependant', label: 'Dependant' },
]

const medicalRelationshipOptions = [
  { value: 'Spouse', label: 'Spouse' },
  { value: 'Child', label: 'Child' },
  { value: 'Father', label: 'Father' },
  { value: 'Mother', label: 'Mother' },
  { value: 'Other', label: 'Other' },
]

function hospitalCategoryLabel(value: unknown) {
  const code = String(value ?? '').trim()
  const match = hospitalCategoryOptions.find((option) => option.value === code)
  return match?.label ?? (code || '—')
}

export function StaffClaim({ medicalOnly = false }: { medicalOnly?: boolean }) {
  const claimTypesQuery = useLookupOptions('claim-types', claimTypeOptions)
  const glAccounts = useLookupOptions('gl-accounts')
  const dependants = useLookupOptions('employee-dependants')
  const claimTypeChoices = medicalOnly
    ? medicalClaimTypeOptions(claimTypesQuery.options)
    : mergeClaimTypeOptions(claimTypesQuery.options, claimTypeOptions)
  const defaultMedicalClaimType = claimTypeChoices[0]?.value ?? 'MEDICAL'
  const claimTypePlaceholder = claimTypesQuery.isLoading
    ? 'Loading claim types from Business Central…'
    : claimTypesQuery.isError
      ? 'Could not load claim types'
      : 'Select claim type'
  const onLineValuesChange = useStaffClaimLineChange(claimTypeChoices, glAccounts.options)

  const applyDependantMeta = useCallback(
    async (values: FieldValues, form: UseFormReturn<FieldValues>) => {
      await onLineValuesChange(values, form)
      if (!isMedicalClaim(values.claimType)) return
      const dependantNo = String(values.dependant ?? '').trim()
      const match = dependants.options.find((option) => option.value === dependantNo)
      const relationship = String(match?.meta?.relationship ?? '').trim()
      const dob = String(match?.meta?.dateOfBirth ?? '').trim()
      if (dependantNo && relationship && String(form.getValues('relationship') ?? '') !== relationship) {
        form.setValue('relationship', relationship, { shouldValidate: true })
      }
      if (dob && String(form.getValues('dependantDateOfBirth') ?? '') !== dob) {
        form.setValue('dependantDateOfBirth', dob, { shouldValidate: true })
      }
    },
    [dependants.options, onLineValuesChange],
  )

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
      requiresAttachmentBeforeSubmit
      requiredAttachmentMessage="Attach at least one supporting document before requesting approval for a claim."
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      newButtonLabel={medicalOnly ? 'New Medical Claim' : 'New Staff Claim'}
      headerSchema={staffClaimHeaderSchema}
      headerDefaults={{ claimDate: todayIsoDate(), purpose: medicalOnly ? 'Medical Claim' : '' }}
      headerSupplement={() => <FinanceEmployeeOrgBanner showMedicalBalances />}
      buildHeaderPayload={(values) => ({
        ...values,
        // Always stamp ERP working date (today) — never reuse a stale form default.
        claimDate: todayIsoDate(),
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
        {
          label: 'Duration Date (per diem / expenditure)',
          paths: ['payload.DurationDate'],
        },
        ...financeOrgDetailFields,
        { label: 'Job Title', paths: ['payload.JobTitle', 'payload.Job_Title', 'request.responsibleCenter'] },
        { label: 'Job Grade', paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade'] },
        {
          label: 'Place of Duty',
          paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.Place_of_Duty', 'payload.DutyArea'],
        },
        {
          label: 'Responsibility Center',
          paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
        },
        { label: 'Total Net Amount', paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'request.amount'], format: 'currency' },
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
      line={{
        label: 'Claim Lines',
        addLabel: 'Add Claim Line',
        schema: staffClaimLineSchema,
        defaultValues: {
          claimType: medicalOnly ? defaultMedicalClaimType : '',
          accountNo: '',
          accountName: '',
          hospitalCategory: '',
          patient: medicalOnly ? 'self' : '',
          relationship: '',
          dependant: '',
          dependantDateOfBirth: '',
          medicalAmount: '',
          amount: '',
          amountToRefund: '',
          coveragePercent: '',
          claimReceiptNo: '',
          expenditureDate: todayIsoDate(),
          expenditureDescription: '',
        },
        buildLinePayload: (values) => {
          const claimType = claimTypeCode(values.claimType)
          const accountNo = String(values.accountNo ?? '').trim()
          const medical = isMedicalClaim(values.claimType)
          const dependantPatient = medical && isDependantPatient(values.patient)
          const payload: Record<string, unknown> = {
            claimType,
            accountNo,
            hospitalCategory: medical ? values.hospitalCategory : '',
            patient: medical ? (dependantPatient ? 'dependant' : 'self') : '',
            relationship: dependantPatient ? String(values.relationship ?? '') : '',
            dependant: dependantPatient ? String(values.dependant ?? '') : '',
            dependantDateOfBirth: dependantPatient
              ? String(values.dependantDateOfBirth ?? '')
              : '',
            medicalAmount: medical ? Number(values.medicalAmount ?? 0) : 0,
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
            const refund = Number(values.amountToRefund ?? 0)
            const net = Number(values.amount ?? 0)
            const resolved = refund > 0 ? refund : net
            payload.amountToRefund = resolved
            payload.amount = resolved
            const coverage = Number(values.coveragePercent ?? 0)
            if (coverage > 0) payload.coveragePercent = coverage
          }
          return payload
        },
        onValuesChange: applyDependantMeta,
        fields: [
          {
            name: 'claimType',
            label: 'Claim Type',
            type: 'select',
            options: claimTypeChoices,
            placeholder: claimTypePlaceholder,
          },
          {
            name: 'accountNo',
            label: 'G/L Account',
            type: 'select',
            options: glAccounts.options,
            placeholder: glAccounts.isLoading
              ? 'Loading G/L accounts from Business Central…'
              : 'Auto-selected from claim type — choose one if not mapped',
          },
          {
            name: 'accountName',
            label: 'Selected G/L Account',
            type: 'text',
            readOnly: true,
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
            name: 'patient',
            label: 'Patient',
            type: 'select',
            options: medicalPatientOptions,
            visibleWhen: (values) => isMedicalClaim(values.claimType),
          },
          {
            name: 'relationship',
            label: 'Relationship',
            type: 'select',
            options: medicalRelationshipOptions,
            visibleWhen: (values) =>
              isMedicalClaim(values.claimType) && isDependantPatient(values.patient),
          },
          {
            name: 'dependant',
            label: 'Dependant',
            type: 'select',
            options: dependants.options,
            placeholder: dependants.isLoading
              ? 'Loading dependants from Business Central…'
              : 'Select a dependant from HR Employee Kin',
            visibleWhen: (values) =>
              isMedicalClaim(values.claimType) && isDependantPatient(values.patient),
          },
          {
            name: 'medicalAmount',
            label: 'Medical Amount',
            type: 'number',
            visibleWhen: (values) => isMedicalClaim(values.claimType),
          },
          // Medical claims derive the net amount in BC, everything else is
          // entered by hand. Two entries rather than one conditionally-readonly
          // field, so each case gets the label and placeholder that fit it.
          {
            name: 'amount',
            label: 'Calculated Net Claim Amount',
            type: 'number',
            readOnly: true,
            visibleWhen: (values) => isMedicalClaim(values.claimType),
            placeholder: 'Enter Medical Amount above to calculate',
          },
          {
            name: 'amount',
            label: 'Claim Amount',
            type: 'number',
            visibleWhen: (values) => !isMedicalClaim(values.claimType),
            placeholder: 'Enter the amount being claimed',
          },
          {
            name: 'amountToRefund',
            label: 'Refund Amount',
            type: 'number',
            readOnlyWhen: (values) => isMedicalClaim(values.claimType),
            visibleWhen: (values) => isMedicalClaim(values.claimType) || isOtherClaim(values.claimType),
          },
          {
            name: 'coveragePercent',
            label: 'Coverage %',
            type: 'number',
            readOnly: true,
            visibleWhen: (values) =>
              isMedicalClaim(values.claimType) && Number(values.coveragePercent ?? 0) > 0,
          },
          { name: 'claimReceiptNo', label: 'Claim Receipt No.', type: 'text' },
          { name: 'expenditureDate', label: 'Expenditure Date', type: 'date', readOnly: true },
          { name: 'expenditureDescription', label: 'Expenditure Description', type: 'textarea', fullWidth: true },
        ],
        columns: [
          {
            key: 'claimType',
            header: 'Claim Type',
            format: (value) => claimTypeDisplay(value, claimTypeChoices),
          },
          { key: 'accountNo', header: 'Account No' },
          {
            key: 'accountName',
            header: 'Account Name',
            visibleWhen: (lines) =>
              lines.some((line) => lineHasAccountName(line, glAccounts.options)),
            format: (value, line) =>
              String(value ?? '').trim() ||
              accountNameForNo(String(line.accountNo ?? ''), glAccounts.options),
          },
          {
            key: 'hospitalCategory',
            header: 'Hospital Category',
            visibleWhen: (lines) => lines.some((line) => isMedicalClaim(line.claimType)),
            format: (value) => hospitalCategoryLabel(value),
          },
          {
            key: 'patient',
            header: 'Patient',
            visibleWhen: (lines) => lines.some((line) => isMedicalClaim(line.claimType)),
          },
          {
            key: 'relationship',
            header: 'Relationship',
            visibleWhen: (lines) =>
              lines.some((line) => isDependantPatient(line.patient)),
          },
          {
            key: 'dependant',
            header: 'Dependant',
            visibleWhen: (lines) =>
              lines.some((line) => isDependantPatient(line.patient)),
          },
          {
            key: 'medicalAmount',
            header: 'Medical Bill Amount',
            visibleWhen: (lines) => lines.some((line) => isMedicalClaim(line.claimType)),
            format: (value) => formatCurrency(Number(value ?? 0)),
          },
          {
            key: 'coveragePercent',
            header: 'Coverage %',
            visibleWhen: (lines) =>
              lines.some((line) => isMedicalClaim(line.claimType) && Number(line.coveragePercent ?? 0) > 0),
            format: (value) => (Number(value ?? 0) > 0 ? `${Number(value).toFixed(0)}%` : '—'),
          },
          {
            key: 'amountToRefund',
            header: 'Refund Amount',
            visibleWhen: (lines) =>
              lines.some(
                (line) => isMedicalClaim(line.claimType) || isOtherClaim(line.claimType),
              ),
            format: (value) => formatCurrency(Number(value ?? 0)),
          },
          {
            key: 'amount',
            header: 'Net Claim Amount',
            format: (value) => formatCurrency(Number(value ?? 0)),
          },
          { key: 'claimReceiptNo', header: 'Claim Receipt No.' },
          {
            key: 'expenditureDate',
            header: 'Expenditure Date',
            format: (value) => formatDate(String(value ?? '')),
          },
          { key: 'expenditureDescription', header: 'Expenditure Description' },
        ],
        emptyText: '*** No Claim Lines Found ***',
      }}
    />
  )
}
