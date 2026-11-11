import { useQuery } from '@tanstack/react-query'
import { addDays, differenceInCalendarDays, formatISO, parseISO } from 'date-fns'
import { useMemo } from 'react'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { fetchAdvancePaymentContext } from '@/api/endpoints/advancePaymentContext'
import { fetchImprestLineAmount } from '@/api/endpoints/imprestCalc'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import {
  purposeOptionsForDivision,
  purposeRequiresOtherDetails,
} from '@/data/advanceRequestPurpose'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { imprestTypeOptions } from '@/data/essOptions'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { imprestHeaderSchema, imprestLineHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useAuth } from '@/hooks/useAuth'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'
import type { LookupOption } from '@/api/endpoints/lookups'

const today = formatISO(new Date(), { representation: 'date' })
const tomorrow = formatISO(addDays(new Date(), 1), { representation: 'date' })
const module = { module: 'imprest', entity: 'selfServiceImprestRequests' } as const

function documentNoFromRequestId(requestId: string) {
  const separator = requestId.indexOf('-')
  return separator >= 0 ? requestId.slice(separator + 1) : requestId
}

let imprestAmountRequest = 0
let imprestCalcBusy = false
let imprestPrevValues: FieldValues = {}
let imprestPrevRequestId = ''

function roundMoney(value: number) {
  return Math.round(value * 100) / 100
}

function usesManualDailyRate(advanceType: string, options: LookupOption[]) {
  const selected = options.find((option) => String(option.value) === advanceType)
  const rateSource = String(selected?.meta?.rateSource ?? '').trim().toLowerCase()
  return rateSource === 'manual' || rateSource === '1'
}

function erpCalcKey(values: FieldValues) {
  const advanceType = String(values.advanceType ?? '').trim()
  const destination = String(values.destination ?? '').trim()
  return [advanceType, destination, Number(values.noOfDays ?? 0)].join('|')
}

function inclusiveTravelDays(travelDate: string, returnDate: string) {
  try {
    const start = parseISO(travelDate)
    const end = parseISO(returnDate)
    if (Number.isNaN(start.getTime()) || Number.isNaN(end.getTime())) return 0
    return Math.max(1, differenceInCalendarDays(end, start) + 1)
  } catch {
    return 0
  }
}

function firstPayloadDate(payload: Record<string, unknown>, keys: string[]) {
  for (const key of keys) {
    const value = String(payload[key] ?? '').trim()
    if (value && !value.startsWith('0001-01-01')) return value.slice(0, 10)
  }
  return ''
}

async function applyImprestLineAmount(
  values: FieldValues,
  form: UseFormReturn<FieldValues>,
  requestId: string,
  imprestTypes: LookupOption[],
) {
  // Calculation state must not leak from one draft to another. Repeating the
  // same type/destination/days on a new request still requires a fresh ERP call.
  if (requestId !== imprestPrevRequestId) {
    imprestAmountRequest += 1
    imprestPrevRequestId = requestId
    imprestPrevValues = {}
    imprestCalcBusy = false
  }
  if (imprestCalcBusy) return

  const advanceType = String(values.advanceType ?? '').trim()
  const destination = String(values.destination ?? '').trim()
  const noOfDays = Number(values.noOfDays ?? 0)
  const amount = Number(values.amount ?? 0)
  const dailyRate = Number(values.dailyRate ?? 0)
  const calcKey = erpCalcKey(values)
  const prevKey = erpCalcKey(imprestPrevValues)

  const erpFieldsChanged = calcKey !== prevKey
  const dailyRateChanged = values.dailyRate !== imprestPrevValues.dailyRate
  const amountChanged = values.amount !== imprestPrevValues.amount
  // Business Central's FetchImprestLineAmount resolves the destination-rate
  // record by both advance type and destination code. Do not calculate before
  // the destination exists, and always recalculate when it changes.
  const canFetchFromErp = Boolean(advanceType) && Boolean(destination) && noOfDays > 0

  if (erpFieldsChanged && canFetchFromErp) {
    if (usesManualDailyRate(advanceType, imprestTypes)) {
      form.clearErrors('dailyRate')
      form.clearErrors('amount')
      imprestPrevValues = { ...values }
      return
    }
    const requestKey = ++imprestAmountRequest
    imprestCalcBusy = true
    const clearedValues = { ...values, amount: '', dailyRate: '' }
    imprestPrevValues = clearedValues
    form.setValue('dailyRate', '', { shouldValidate: false })
    form.setValue('amount', '', { shouldValidate: false })
    try {
      const {
        amount: fetchedAmount,
        dailyRate: fetchedRate,
        requiresManualRate,
      } = await fetchImprestLineAmount({
        headerNo: documentNoFromRequestId(requestId),
        noOfDays,
        advanceType,
        destinationCode: destination,
      })
      if (requestKey !== imprestAmountRequest) return
      form.clearErrors('dailyRate')
      form.clearErrors('amount')
      if (requiresManualRate) {
        imprestPrevValues = clearedValues
        return
      }
      if (fetchedAmount > 0) {
        const rate = fetchedRate > 0 ? fetchedRate : roundMoney(fetchedAmount / noOfDays)
        form.setValue('amount', fetchedAmount, { shouldValidate: true })
        form.setValue('dailyRate', rate, { shouldValidate: true })
        imprestPrevValues = { ...values, amount: fetchedAmount, dailyRate: rate }
      } else {
        form.setError('dailyRate', {
          type: 'manual',
          message:
            'ERP returned no daily rate for this type and destination. Enter daily rate or amount manually.',
        })
        imprestPrevValues = clearedValues
      }
    } catch (err) {
      const message =
        err instanceof Error
          ? err.message
          : 'Could not calculate daily rate from Business Central. Check advance type, destination and days.'
      form.setError('dailyRate', { type: 'manual', message })
      imprestPrevValues = clearedValues
    } finally {
      imprestCalcBusy = false
    }
    return
  }

  imprestPrevValues = { ...values }

  if (!noOfDays) return

  imprestCalcBusy = true
  try {
    if (dailyRateChanged && dailyRate > 0) {
      const nextAmount = roundMoney(dailyRate * noOfDays)
      form.setValue('amount', nextAmount, { shouldValidate: true })
      imprestPrevValues = { ...values, amount: nextAmount }
      return
    }
    if (amountChanged && amount > 0) {
      const nextRate = roundMoney(amount / noOfDays)
      form.setValue('dailyRate', nextRate, { shouldValidate: true })
      imprestPrevValues = { ...values, dailyRate: nextRate }
    }
  } finally {
    imprestCalcBusy = false
  }
}

function destinationFromRequest(
  request: PortalRequest,
  destinationOptions: Array<{ value: string; label: string }>,
) {
  const payload = request.payload ?? {}
  const raw = String(
    payload.TravelDestination ??
      payload.Travel_Destination ??
      payload.Destination ??
      payload.DestinationCode ??
      '',
  ).trim()
  if (!raw) return ''
  const codes = new Set(destinationOptions.map((option) => String(option.value)))
  if (codes.has(raw)) return raw
  const byLabel = destinationOptions.find(
    (option) => String(option.label).trim().toLowerCase() === raw.toLowerCase(),
  )
  if (byLabel) return String(byLabel.value)
  const partial = destinationOptions.find((option) => {
    const label = String(option.label).trim().toLowerCase()
    const code = String(option.value).trim().toLowerCase()
    const needle = raw.toLowerCase()
    return label.includes(needle) || needle.includes(label) || code === needle
  })
  return partial ? String(partial.value) : ''
}

function imprestListSearchExtra(row: PortalRequest): Array<string | number | undefined | null> {
  const payload = row.payload ?? {}
  return [
    payload.TravelDestination,
    payload.Travel_Destination,
    payload.Destination,
    payload.DestinationCode,
    payload.Purpose,
    payload.purpose,
    payload.ImprestNo,
    payload.EmployeeAccountNo,
    payload.CustomerNo,
  ].map((value) =>
    value === undefined || value === null ? value : typeof value === 'number' ? value : String(value),
  )
}

export function ImprestRequest() {
  const { employee } = useAuth()
  const imprestTypes = useLookupOptions('imprest-types', imprestTypeOptions)
  const destinations = useLookupOptions('travel-destinations')
  const fallbackPurposes = useMemo(
    () =>
      purposeOptionsForDivision(
        `${employee?.departmentCode ?? ''} ${employee?.placeOfDuty ?? ''} ${employee?.jobGrade ?? ''}`,
      ),
    [employee?.departmentCode, employee?.placeOfDuty, employee?.jobGrade],
  )
  const purposeContext = useQuery({
    queryKey: ['advance-payment-context', employee?.employeeNo ?? ''],
    queryFn: () => fetchAdvancePaymentContext(String(employee?.employeeNo ?? '')),
    staleTime: 5 * 60 * 1000,
  })
  const purposeOptions =
    purposeContext.data?.purposes?.length ? purposeContext.data.purposes : fallbackPurposes
  const purposeHint = purposeContext.data?.purposeGroupCaption
    ? `Purposes for ${purposeContext.data.purposeGroupCaption}${
        purposeContext.data.divisionCode ? ` (${purposeContext.data.divisionCode})` : ''
      }. Choose Other (Specify) when needed.`
    : 'Purpose list comes from Business Central for your division. Choose Other (Specify) to add details.'

  return (
    <MultiStepRequestPage
      title="Advance Payment"
      headerLabel="New Advance Payment"
      description="Request field activity advance funds (Phase 1–2 of the Advance & Settlement cycle). Create the header, add budget lines, then submit for approval. Approval: Line Manager first, then FAD (below ETB 50,000), COO (ETB 50,000–100,000), or CEO (above ETB 100,000). Settle unused or spent funds later via Advance Settlement (within two working days of return)."
      module={module}
      queryKey={['finance', 'advance-payment']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      listSearchExtra={imprestListSearchExtra}
      newButtonLabel="New Advance Payment"
      headerSchema={imprestHeaderSchema}
      headerDefaults={{
        dateRequired: today,
        requestPurpose: purposeOptions[0]?.value ?? 'GN-OTH',
        otherPurposeDetails: '',
        justification: '',
        activityLocation: '',
        activityStartDate: '',
        activityEndDate: '',
        purpose: '',
        travelDestination: '',
        travelDate: today,
        returnDate: tomorrow,
      }}
      headerSupplement={() => (
        <div className="space-y-3">
          <FinanceEmployeeOrgBanner />
          <div className="rounded-xl border border-teal-200 bg-teal-50/80 px-3 py-2.5 text-sm text-teal-950">
            <p className="font-semibold">Finance approval (Business Central)</p>
            <p className="mt-1 text-xs leading-5 text-teal-900/90">
              Line Manager approves every request first. Then by amount (ETB): below 50,000 → FAD;
              50,000–100,000 → COO; above 100,000 → CEO. Status, comments, and payment reference
              come from BC after each step. Settlement is only via Advance Settlement.
            </p>
          </div>
        </div>
      )}
      buildHeaderPayload={(values) => {
        const travelDate = String(values.travelDate ?? '')
        let returnDate = String(values.returnDate ?? '')
        if (travelDate && (!returnDate || returnDate <= travelDate)) {
          const next = new Date(`${travelDate}T12:00:00`)
          next.setDate(next.getDate() + 1)
          returnDate = `${next.getFullYear()}-${String(next.getMonth() + 1).padStart(2, '0')}-${String(next.getDate()).padStart(2, '0')}`
        }
        const justification = String(values.justification ?? '').trim()
        const purposeCode = String(values.requestPurpose ?? '').trim()
        const purposeLabel =
          purposeOptions.find((option) => option.value === purposeCode)?.label ?? purposeCode
        return {
          ...values,
          travelDate,
          returnDate,
          startDate: travelDate,
          purposeCode,
          requestPurpose: purposeCode,
          purpose: justification || purposeLabel,
          title: justification || purposeLabel || 'Advance Payment',
        }
      }}
      headerOnValuesChange={(values, form) => {
        const travelDate = String(values.travelDate ?? '')
        const returnDate = String(values.returnDate ?? '')
        if (!travelDate) return
        if (returnDate && returnDate > travelDate) return
        const next = new Date(`${travelDate}T12:00:00`)
        next.setDate(next.getDate() + 1)
        const bumped = `${next.getFullYear()}-${String(next.getMonth() + 1).padStart(2, '0')}-${String(next.getDate()).padStart(2, '0')}`
        if (returnDate !== bumped) {
          form.setValue('returnDate', bumped, { shouldValidate: true, shouldDirty: true })
        }
      }}
      headerFields={[
        {
          name: 'dateRequired',
          label: 'Required Advance Date',
          type: 'date',
          valuePaths: [
            'DateRequired',
            'Date_Required',
            'PaymentReleaseDate',
            'Payment_Release_Date',
            'Date',
          ],
          hint: 'Date you need the funds',
        },
        {
          name: 'requestPurpose',
          label: 'Request Purpose',
          type: 'select',
          options: purposeOptions,
          valuePaths: ['RequestPurposeCode', 'Request_Purpose_Code'],
          hint: purposeHint,
        },
        {
          name: 'otherPurposeDetails',
          label: 'Other Purpose Details',
          type: 'textarea',
          fullWidth: true,
          maxLength: 250,
          visibleWhen: (values) =>
            purposeRequiresOtherDetails(String(values.requestPurpose ?? ''), purposeOptions),
          placeholder: 'Describe the purpose when Other is selected',
          valuePaths: ['OtherPurposeDetails', 'Other_Purpose_Details'],
        },
        {
          name: 'justification',
          label: 'Request Justification',
          type: 'textarea',
          fullWidth: true,
          maxLength: 250,
          placeholder: 'Explain why the advance is needed',
          valuePaths: ['RequestJustification', 'Request_Justification', 'Purpose'],
        },
        {
          name: 'activityStartDate',
          label: 'Activity Start Date',
          type: 'date',
          valuePaths: ['ActivityStartDate', 'Activity_Start_Date'],
        },
        {
          name: 'activityEndDate',
          label: 'Activity End Date',
          type: 'date',
          valuePaths: ['ActivityEndDate', 'Activity_End_Date'],
        },
        {
          name: 'activityLocation',
          label: 'Activity Location',
          type: 'text',
          placeholder: 'Where the activity will take place',
          valuePaths: ['ActivityLocation', 'Activity_Location'],
        },
        {
          name: 'travelDestination',
          label: 'Travel Destination (free text)',
          type: 'text',
          valuePaths: ['TravelDestination', 'Travel_Destination'],
        },
        {
          name: 'travelDate',
          label: 'Travel Start Date',
          type: 'date',
          valuePaths: ['TravelStartDate', 'Travel_Start_Date', 'TravelDate', 'Travel_Date'],
        },
        {
          name: 'returnDate',
          label: 'Expected Return Date',
          type: 'date',
          valuePaths: ['ExpectedReturnDate', 'Expected_Return_Date', 'ReturnDate', 'Return_Date'],
        },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        {
          label: 'Required Advance Date',
          paths: [
            'payload.DateRequired',
            'payload.Date_Required',
            'payload.PaymentReleaseDate',
            'payload.Payment_Release_Date',
            'payload.Date',
            'request.createdAt',
          ],
          format: 'date',
        },
        {
          label: 'Request Purpose',
          paths: ['payload.RequestPurposeText', 'payload.RequestPurposeCode', 'payload.Purpose'],
        },
        {
          label: 'Other Purpose Details',
          paths: ['payload.OtherPurposeDetails', 'payload.Other_Purpose_Details'],
        },
        {
          label: 'Request Justification',
          paths: ['payload.RequestJustification', 'payload.Request_Justification', 'payload.Purpose'],
        },
        {
          label: 'Activity Start Date',
          paths: ['payload.ActivityStartDate', 'payload.Activity_Start_Date'],
          format: 'date',
        },
        {
          label: 'Activity End Date',
          paths: ['payload.ActivityEndDate', 'payload.Activity_End_Date'],
          format: 'date',
        },
        {
          label: 'Activity Location',
          paths: ['payload.ActivityLocation', 'payload.Activity_Location'],
        },
        { label: 'Travel Destination', paths: ['payload.TravelDestination', 'payload.Travel_Destination'] },
        {
          label: 'Travel Start Date',
          paths: [
            'payload.TravelStartDate',
            'payload.Travel_Start_Date',
            'payload.TravelDate',
            'payload.Travel_Date',
          ],
          format: 'date',
        },
        {
          label: 'Expected Return Date',
          paths: ['payload.ExpectedReturnDate', 'payload.Expected_Return_Date', 'payload.ReturnDate', 'payload.Return_Date'],
          format: 'date',
        },
        { label: 'Duration Date', paths: ['payload.DurationDate'] },
        ...financeOrgDetailFields,
        {
          label: 'Job Title',
          paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
        },
        {
          label: 'Job Grade',
          paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
        },
        { label: 'Responsibility Center', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
        { label: 'Place of Duty', paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'] },
        { label: 'Total Net Amount', paths: ['payload.TotalNetAmount', 'request.amount'], format: 'currency' },
        {
        label: 'Remaining Not Settled',
          paths: [
            'payload.RemainingUnsettledAmount',
            'payload.RemainingNotSettledAmount',
            'payload.OutstandingBalance',
            'payload.Balance',
          ],
          format: 'currency',
        },
        { label: 'Settlement Status (BC)', paths: ['payload.SurrenderStatus', 'payload.Surrender_Status'] },
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
        label: 'Advance Lines',
        addLabel: 'Add Advance Line',
        schema: imprestLineHeaderSchema,
        defaultValues: {
          advanceType: '',
          destination: '',
          dutyArea: '',
          noOfDays: 1,
          dailyRate: '',
          amount: '',
        },
        defaultValuesFromRequest: (request) => {
          const payload = request.payload ?? {}
          const travelDate = firstPayloadDate(payload, [
            'TravelStartDate',
            'Travel_Start_Date',
            'TravelDate',
            'Travel_Date',
          ])
          const returnDate = firstPayloadDate(payload, [
            'ExpectedReturnDate',
            'Expected_Return_Date',
            'ReturnDate',
            'Return_Date',
          ])
          const days = travelDate && returnDate ? inclusiveTravelDays(travelDate, returnDate) : 0
          return {
            destination: destinationFromRequest(request, destinations.options),
            ...(days > 0 ? { noOfDays: days } : {}),
          }
        },
        onValuesChange: (values, form, requestId) =>
          applyImprestLineAmount(values, form, requestId, imprestTypes.options),
        fields: [
          { name: 'advanceType', label: 'Advance Type', type: 'select', options: imprestTypes.options },
          {
            name: 'destination',
            label: 'Travel Destination (location)',
            type: 'select',
            options: destinations.options,
            placeholder: destinations.isLoading
              ? 'Loading travel destinations…'
              : destinations.isError
                ? 'Could not load travel destinations'
                : 'Select travel destination',
          },
          { name: 'dutyArea', label: 'Duty Area', type: 'text' },
          { name: 'noOfDays', label: 'No. of Days', type: 'number' },
          {
            name: 'dailyRate',
            label: 'Daily Rate (ERP)',
            type: 'number',
            placeholder: 'Auto-filled from Business Central Destination Rates',
          },
          {
            name: 'amount',
            label: 'Amount',
            type: 'number',
            placeholder: 'Auto-filled from ERP (daily rate × days)',
          },
        ],
        columns: [
          { key: 'advanceType', header: 'Advance Type' },
          { key: 'destination', header: 'Travel Destination' },
          { key: 'accountNo', header: 'Account No.' },
          { key: 'accountName', header: 'Account Name' },
          {
            key: 'dailyRate',
            header: 'Daily Rate',
            format: (value) => (Number(value ?? 0) > 0 ? formatCurrency(Number(value)) : '—'),
          },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'noOfDays', header: 'No of Days' },
        ],
        emptyText: '*** No Advance Lines Found ***',
        canEdit: false,
      }}
    />
  )
}
