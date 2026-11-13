import { useCallback, useMemo, useRef } from 'react'
import { useQuery } from '@tanstack/react-query'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { validateHospitalCategory } from '@/api/endpoints/claimCalc'
import { getMedicalClaimDependants } from '@/api/endpoints/profile'
import type { LookupOption } from '@/api/endpoints/lookups'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import {
  claimTypeOptions,
  hospitalCategoryOptions,
  medicalClaimTypeSeed,
  MEDICAL_CLAIM_COMPANY_COVERAGE_PERCENT,
  staffClaimTypeOptions,
} from '@/data/essOptions'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { staffClaimHeaderSchema, staffClaimLineSchema } from '@/schemas/requestSchemas'
import { formatCurrency, formatDate } from '@/utils/formatters'
import { todayIsoDate } from '@/utils/validators'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'
import { MEDICAL_CLAIM_AFTER_APPROVAL, MEDICAL_CLAIM_APPROVERS } from '@/data/processStages'

const module = { module: 'staffClaim', entity: 'selfServiceStaffClaims' } as const

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
  return medical.length > 0 ? medical : medicalClaimTypeSeed
}

/**
 * Medical Claim and Staff Claims share the BC Staff Claim document. List rows often carry no lines, so
 * the claim purpose decides the menu ("Medical Claim — …" from the ESSP form). Fall back to header
 * claim type when present so older medical drafts stay on the Medical Claim list only.
 */
function isMedicalClaimRequest(row: PortalRequest) {
  // BC 1.0.3.648 flags the header Is Medical Claim (kept off the Staff Claim list).
  const flag = row.payload?.IsMedicalClaim ?? row.payload?.Is_Medical_Claim
  if (flag === true || String(flag ?? '').toLowerCase() === 'true') return true
  const purpose = String(row.title || row.payload?.Purpose || row.payload?.ClaimDescription || '')
  if (/medical/i.test(purpose)) return true
  const headerType = row.payload?.ClaimType ?? row.payload?.claimType ?? row.payload?.Claim_Type
  return isMedicalClaim(headerType)
}

/** Staff Claims exclude Medical — Medical Claim is a separate menu/page. */
function nonMedicalClaimTypeOptions(options: LookupOption[]) {
  return options.filter(
    (option) => !isMedicalClaim(option.value) && !isMedicalClaim(option.label),
  )
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

function glAccountForClaimType(claimType: string, claimTypes: LookupOption[]) {
  const code = claimTypeCode(claimType)
  const selected =
    claimTypes.find((option) => option.value === claimType) ??
    claimTypes.find((option) => claimTypeCode(option.value) === code)
  return String(selected?.meta?.accountNo ?? '').trim()
}

/** True when the chosen claim type has no G/L account (BC claim type, or Medical Allowance for medical). */
function claimTypeNeedsAccount(claimType: unknown, claimTypes: LookupOption[], glAccounts: LookupOption[]) {
  const value = String(claimType ?? '').trim()
  if (!value) return false
  if (glAccountForClaimType(value, claimTypes)) return false
  return !(isMedicalClaim(value) && findMedicalAllowanceAccount(glAccounts))
}

function findMedicalAllowanceAccount(glAccounts: LookupOption[]) {
  return glAccounts.find((option) => option.label.toLowerCase().includes('medical allowance'))
}

function accountDisplay(accountNo: string, accountName: string) {
  if (!accountNo) return ''
  return accountName ? `${accountNo} — ${accountName}` : accountNo
}

let medicalAmountRequest = 0

/** Policy: company covers 80% of the accepted receipt (before Self/Dependant budget cap). */
function localMedicalRefund(medicalAmount: number) {
  const rate = MEDICAL_CLAIM_COMPANY_COVERAGE_PERCENT / 100
  const amountToRefund = Math.round(medicalAmount * rate * 100) / 100
  return { amount: amountToRefund, amountToRefund, coveragePercent: MEDICAL_CLAIM_COMPANY_COVERAGE_PERCENT }
}

async function applyMedicalClaimAmounts(values: FieldValues, form: UseFormReturn<FieldValues>) {
  if (!isMedicalClaim(values.claimType)) return
  // BC 1.0.3.642: hospital category does not drive refund % (flat 80% + budget cap).
  const hospitalCategory = String(values.hospitalCategory ?? '0').trim() || '0'
  const medicalAmount = Number(values.medicalAmount ?? 0)
  const patient = String(values.patient ?? 'self').trim()
  const dependant = String(values.dependant ?? '').trim()
  if (!medicalAmount) return
  if (isDependantPatient(patient) && !dependant) return

  const requestKey = ++medicalAmountRequest
  try {
    const data = await validateHospitalCategory({
      hospitalCategory,
      medicalAmount,
      patient,
      dependant: isDependantPatient(patient) ? dependant : '',
    })
    if (requestKey !== medicalAmountRequest) return
    let amount = Number(data.Amount ?? data.amount ?? 0)
    let amountToRefund = Number(data.AmountToRefund ?? data.amountToRefund ?? 0)
    let coveragePercent = Number(data.coveragePercent ?? data.CoveragePercent ?? 0)
    if (amountToRefund <= 0 && amount <= 0) {
      const fallback = localMedicalRefund(medicalAmount)
      amount = fallback.amount
      amountToRefund = fallback.amountToRefund
      coveragePercent = fallback.coveragePercent
    }
    // BC sets claim line Amount from Amount to refund — never send uncapped receipt amount.
    const netAmount = amountToRefund > 0 ? amountToRefund : amount
    if (netAmount >= 0) form.setValue('amount', netAmount, { shouldValidate: true })
    if (amountToRefund >= 0) form.setValue('amountToRefund', amountToRefund, { shouldValidate: true })
    if (coveragePercent > 0) form.setValue('coveragePercent', coveragePercent, { shouldValidate: false })
    const available = Number(data.availableBalance)
    if (Number.isFinite(available) && available >= 0) {
      form.setValue('availableBalance', available, { shouldValidate: false })
    }
    const employeeContribution = Number(data.employeeContribution ?? data.EmployeeContribution)
    if (Number.isFinite(employeeContribution) && employeeContribution >= 0) {
      form.setValue('employeeContribution', employeeContribution, { shouldValidate: false })
    } else if (medicalAmount > 0 && amountToRefund >= 0) {
      form.setValue(
        'employeeContribution',
        Math.round((medicalAmount - amountToRefund) * 100) / 100,
        { shouldValidate: false },
      )
    }
    if (data.budgetCapped) {
      const balanceLabel = Number.isFinite(available)
        ? ` Available budget: ${formatCurrency(available)}.`
        : ''
      form.setValue(
        'budgetNote',
        `Refund capped at remaining Self/Dependant medical claim balance.${balanceLabel}`,
        { shouldValidate: false },
      )
    } else {
      form.setValue('budgetNote', '', { shouldValidate: false })
    }
  } catch {
    // Policy rates still apply when SOAP is down.
    const fallback = localMedicalRefund(medicalAmount)
    form.setValue('amount', fallback.amount, { shouldValidate: true })
    form.setValue('amountToRefund', fallback.amountToRefund, { shouldValidate: true })
    form.setValue('coveragePercent', fallback.coveragePercent, { shouldValidate: false })
    form.setValue(
      'employeeContribution',
      Math.round((medicalAmount - fallback.amountToRefund) * 100) / 100,
      { shouldValidate: false },
    )
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

/** Meeting 11 Nov 2026 / BC 642: only Spouse, Father, Mother, Child (under 18). */
const medicalRelationshipOptions = [
  { value: 'Spouse', label: 'Spouse' },
  { value: 'Father', label: 'Father' },
  { value: 'Mother', label: 'Mother' },
  { value: 'Child', label: 'Child' },
]

function hospitalCategoryLabel(value: unknown) {
  const code = String(value ?? '').trim()
  const match = hospitalCategoryOptions.find((option) => option.value === code)
  return match?.label ?? (code || '—')
}

export function StaffClaim({ medicalOnly = false }: { medicalOnly?: boolean }) {
  const claimTypesQuery = useLookupOptions(
    'claim-types',
    medicalOnly ? claimTypeOptions : staffClaimTypeOptions,
  )
  const glAccounts = useLookupOptions('gl-accounts')
  const kinDependants = useLookupOptions('employee-dependants')
  const medicalDependantsQuery = useQuery({
    queryKey: ['profile', 'medical-dependants'],
    queryFn: getMedicalClaimDependants,
    enabled: medicalOnly,
    staleTime: 60_000,
  })
  const medicalDependantOptions = useMemo<LookupOption[]>(() => {
    const rows = medicalDependantsQuery.data?.dependants ?? []
    // Show eligible + ineligible Children so HR can see why a child is blocked (age / birth cert).
    return rows.map((row) => {
      const base = row.relationship ? `${row.fullName} (${row.relationship})` : row.fullName
      const reason = String(row.ineligibleReason ?? '').trim()
      return {
        value: row.systemId || row.no,
        label: row.eligible ? base : reason ? `${base} — ${reason}` : `${base} — not eligible`,
        disabled: !row.eligible,
        meta: {
          dependantNo: row.no || row.memberId,
          relationship: row.relationship,
          dateOfBirth: row.dateOfBirth,
          cardNo: row.cardNo,
          identificationType: row.identificationType,
          eligible: row.eligible,
          ineligibleReason: reason,
        },
      }
    })
  }, [medicalDependantsQuery.data?.dependants])
  const eligibleMedicalDependantCount = useMemo(
    () => medicalDependantOptions.filter((option) => !option.disabled).length,
    [medicalDependantOptions],
  )
  const dependants = medicalOnly
    ? {
        options: medicalDependantOptions,
        isLoading: medicalDependantsQuery.isLoading,
        isError: medicalDependantsQuery.isError,
      }
    : kinDependants
  const claimTypeChoices = medicalOnly
    ? medicalClaimTypeOptions(claimTypesQuery.options)
    : nonMedicalClaimTypeOptions(
        mergeClaimTypeOptions(claimTypesQuery.options, staffClaimTypeOptions),
      )
  const defaultMedicalClaimType = claimTypeChoices[0]?.value ?? 'MEDICAL'
  const claimTypePlaceholder = claimTypesQuery.isLoading
    ? 'Loading claim types from Business Central…'
    : claimTypesQuery.isError
      ? 'Could not load claim types'
      : medicalOnly
        ? 'Select claim type'
        : 'Select claim type (Medical Claim is under Finance → Medical Claim)'
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
          ? `Medical Claim (BC 1.0.3.642): company pays ${MEDICAL_CLAIM_COMPANY_COVERAGE_PERCENT}% of the accepted receipt, capped by remaining Self / Dependants budget (Basic × 12 × 20%, split 50/50). Eligible dependants: Spouse, Father, Mother, Child under 18 with Date of Birth and Birth Certificate No. on HR Employee Dependants. Attach the invoice, then Submit: HR verifies, Finance approves (BC 1.0.3.648). Finance then pays it through a payment voucher (FAD → Finance Manager); once paid, the claim closes and your medical balance updates.`
          : 'Add claim lines by type (Accommodation, Travel, Other, and any non-medical BC types). Medical Claim is not available here — use Finance → Medical Claim.'
      }
      module={module}
      queryKey={medicalOnly ? ['hr', 'staff-medical-claim'] : ['finance', 'staff-claim']}
      listRequests={async () => {
        const rows = await listModuleRequests(module)
        return rows.filter((row) => isMedicalClaimRequest(row) === medicalOnly)
      }}
      listStatusFilter
      requiresAttachmentBeforeSubmit
      requiredAttachmentMessage={
        medicalOnly
          ? 'Attach at least one supporting document before Submit.'
          : 'Attach at least one supporting document before requesting approval for a claim.'
      }
      submitButtonLabel={medicalOnly ? 'Submit' : undefined}
      submitConfirmTitle={medicalOnly ? 'Submit medical claim' : undefined}
      submitConfirmMessage={
        medicalOnly
          ? 'Submit this medical claim to HR?'
          : undefined
      }
      submitSuccessMessage={medicalOnly ? 'Medical claim submitted to HR' : undefined}
      // BC 1.0.3.648: after HR → Finance, the payment voucher (FAD → Finance Manager), then Paid.
      progressAfterApproval={medicalOnly ? () => MEDICAL_CLAIM_AFTER_APPROVAL : undefined}
      progressApprovers={medicalOnly ? MEDICAL_CLAIM_APPROVERS : undefined}
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      newButtonLabel={medicalOnly ? 'New Medical Claim' : 'New Staff Claim'}
      headerSchema={staffClaimHeaderSchema}
      headerDefaults={{ claimDate: todayIsoDate(), purpose: medicalOnly ? 'Medical Claim' : '' }}
      headerSupplement={() => <FinanceEmployeeOrgBanner showMedicalBalances={medicalOnly} />}
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
          // Classification only — BC 642 ignores hospital % (flat 80% + budget).
          hospitalCategory: medicalOnly ? '0' : '',
          patient: medicalOnly ? 'self' : '',
          relationship: '',
          dependant: '',
          dependantDateOfBirth: '',
          medicalAmount: '',
          amount: '',
          amountToRefund: '',
          coveragePercent: '',
          availableBalance: '',
          employeeContribution: '',
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
            hospitalCategory: medical ? String(values.hospitalCategory ?? '0').trim() || '0' : '',
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
            // Medical Claim menu always uses MEDICAL — do not show Staff Claim's claim-type picker.
            visibleWhen: () => !medicalOnly,
          },
          // UAT (5 Nov): the G/L account means nothing to the requester; it comes from the claim type. The
          // selector shows only when Business Central has no account for the chosen claim type.
          {
            name: 'accountNo',
            label: 'G/L Account',
            type: 'select',
            options: glAccounts.options,
            placeholder: glAccounts.isLoading
              ? 'Loading G/L accounts from Business Central…'
              : 'This claim type has no G/L account in Business Central — choose one',
            visibleWhen: (values) =>
              !medicalOnly &&
              claimTypeNeedsAccount(values.claimType, claimTypeChoices, glAccounts.options),
          },
          {
            // BC 642: hospital category no longer drives refund % — field kept off Medical Claim UI.
            name: 'hospitalCategory',
            label: 'Hospital / Facility Category',
            type: 'select',
            options: hospitalCategoryOptions,
            placeholder: 'Select hospital / facility category',
            visibleWhen: () => false,
          },
          {
            name: 'patient',
            label: 'Patient',
            type: 'select',
            options: medicalPatientOptions,
            visibleWhen: () => medicalOnly,
          },
          {
            // Select dependant first; Relationship fills from the chosen person (smoother than reverse).
            name: 'dependant',
            label: 'Dependant',
            type: 'select',
            options: dependants.options,
            placeholder: dependants.isLoading
              ? 'Loading dependants from Business Central…'
              : eligibleMedicalDependantCount > 0
                ? 'Select eligible dependant (Spouse / Father / Mother / Child under 18)'
                : dependants.options.length
                  ? 'No selectable dependants — greyed rows show the BC reason (age or birth certificate)'
                  : 'No dependants found — ask HR to add Employee Dependants',
            hint: medicalOnly
              ? 'Child needs DOB + Birth Cert. No. (Card No.) on HR Employee Dependants. Over-18 stays listed but disabled.'
              : undefined,
            visibleWhen: (values) => medicalOnly && isDependantPatient(values.patient),
          },
          {
            name: 'relationship',
            label: 'Relationship',
            type: 'select',
            options: medicalRelationshipOptions,
            readOnlyWhen: () => medicalOnly,
            hint: medicalOnly ? 'Filled automatically from the selected dependant.' : undefined,
            visibleWhen: (values) => medicalOnly && isDependantPatient(values.patient),
          },
          {
            name: 'medicalAmount',
            label: 'Receipt Amount',
            type: 'number',
            placeholder: 'Enter the medical receipt amount',
            hint: medicalOnly
              ? `Not yet verified by Finance. Company pays ${MEDICAL_CLAIM_COMPANY_COVERAGE_PERCENT}% (capped by Available Budget for Self or Dependants).`
              : undefined,
            visibleWhen: () => medicalOnly,
          },
          {
            name: 'availableBalance',
            label: 'Available Budget (this category)',
            type: 'number',
            readOnly: true,
            placeholder: 'Filled from Business Central when you enter the receipt amount',
            visibleWhen: () => medicalOnly,
          },
          {
            name: 'amountToRefund',
            label: medicalOnly
              ? 'Company Reimbursement (Amount to Refund)'
              : 'Amount to Refund',
            type: 'number',
            readOnlyWhen: () => medicalOnly,
            visibleWhen: (values) => medicalOnly || isOtherClaim(values.claimType),
          },
          {
            name: 'employeeContribution',
            label: 'Employee Contribution',
            type: 'number',
            readOnly: true,
            visibleWhen: () => medicalOnly,
          },
          {
            name: 'amount',
            label: 'Net Claim Amount (company pays)',
            type: 'number',
            readOnly: true,
            visibleWhen: () => medicalOnly,
            placeholder: 'Enter receipt amount to calculate',
          },
          {
            name: 'amount',
            label: 'Claim Amount',
            type: 'number',
            visibleWhen: () => !medicalOnly,
            placeholder: 'Enter the amount being claimed',
          },
          {
            name: 'coveragePercent',
            label: 'Company coverage % (policy)',
            type: 'number',
            readOnly: true,
            visibleWhen: (values) => medicalOnly && Number(values.coveragePercent ?? 0) > 0,
          },
          { name: 'claimReceiptNo', label: 'Claim Receipt No.', type: 'text' },
          { name: 'expenditureDate', label: 'Expenditure Date', type: 'date', readOnly: true },
          {
            name: 'expenditureDescription',
            label: medicalOnly ? 'Other Details' : 'Expenditure Description',
            type: 'textarea',
            fullWidth: true,
            placeholder: medicalOnly ? 'Optional notes (not required for medical claims)' : undefined,
            hint: medicalOnly ? 'Optional — leave blank if not needed.' : undefined,
          },
        ],
        columns: [
          {
            key: 'claimType',
            header: 'Claim Type',
            format: (value) => claimTypeDisplay(value, claimTypeChoices),
          },
          {
            key: 'hospitalCategory',
            header: 'Hospital Category',
            visibleWhen: () => false,
            format: (value) => hospitalCategoryLabel(value),
          },
          {
            key: 'patient',
            header: 'Patient',
            visibleWhen: () => medicalOnly,
          },
          {
            key: 'dependant',
            header: 'Dependant',
            visibleWhen: (lines) =>
              medicalOnly && lines.some((line) => isDependantPatient(line.patient)),
          },
          {
            key: 'relationship',
            header: 'Relationship',
            visibleWhen: (lines) =>
              medicalOnly && lines.some((line) => isDependantPatient(line.patient)),
          },
          {
            key: 'medicalAmount',
            header: 'Receipt Amount',
            visibleWhen: () => medicalOnly,
            format: (value) => formatCurrency(Number(value ?? 0)),
          },
          {
            key: 'coveragePercent',
            header: 'Coverage %',
            visibleWhen: (lines) =>
              medicalOnly &&
              lines.some((line) => Number(line.coveragePercent ?? 0) > 0),
            format: (value) => (Number(value ?? 0) > 0 ? `${Number(value).toFixed(0)}%` : '—'),
          },
          {
            key: 'amountToRefund',
            header: 'Refund Amount',
            visibleWhen: (lines) =>
              medicalOnly || lines.some((line) => isOtherClaim(line.claimType)),
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
          {
            key: 'expenditureDescription',
            header: medicalOnly ? 'Other Details' : 'Expenditure Description',
          },
        ],
        emptyText: '*** No Claim Lines Found ***',
      }}
    />
  )
}
