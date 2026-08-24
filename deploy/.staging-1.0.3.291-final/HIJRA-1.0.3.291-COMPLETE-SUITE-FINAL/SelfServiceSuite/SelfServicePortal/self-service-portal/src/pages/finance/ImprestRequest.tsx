import { addDays, differenceInCalendarDays, formatISO, parseISO, isValid, format } from 'date-fns'
import { useCallback, useRef } from 'react'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { FinanceEmployeeOrgBanner } from '@/components/finance/FinanceEmployeeOrgBanner'
import { fetchImprestLineAmount } from '@/api/endpoints/imprestCalc'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'
import { imprestTypeOptions } from '@/data/essOptions'
import { FINANCE_CANCEL_STATUSES } from '@/lib/utils'
import { imprestHeaderSchema, imprestLineHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'
import type { LookupOption } from '@/api/endpoints/lookups'

const today = formatISO(new Date(), { representation: 'date' })
const tomorrow = formatISO(addDays(new Date(), 1), { representation: 'date' })
const module = { module: 'imprest', entity: 'selfServiceImprestRequests' } as const

function bumpReturnAfterTravel(travelDate: string) {
  const next = parseISO(travelDate)
  if (!isValid(next)) return ''
  return format(addDays(next, 1), 'yyyy-MM-dd')
}

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

function usesJobGradeDailyRate(advanceType: string, options: LookupOption[]) {
  const selected = options.find((option) => String(option.value) === advanceType)
  const rateSource = String(selected?.meta?.rateSource ?? '').trim().toLowerCase()
  // Empty / Job Grade / 0 → ERP Job Grade Advance Rates (not destination).
  return !rateSource || rateSource === 'job grade' || rateSource === 'jobgrade' || rateSource === '0'
}

function erpCalcKey(values: FieldValues, imprestTypes: LookupOption[]) {
  const advanceType = String(values.advanceType ?? '').trim()
  const destination = usesJobGradeDailyRate(advanceType, imprestTypes)
    ? ''
    : String(values.destination ?? '').trim()
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
  // Prefer line destination; otherwise use header travel destination (Word Aug 7).
  const destination = String(
    values.destination || values.travelDestination || values.headerTravelDestination || '',
  ).trim()
  const noOfDays = Number(values.noOfDays ?? 0)
  const amount = Number(values.amount ?? 0)
  const dailyRate = Number(values.dailyRate ?? 0)
  const calcKey = erpCalcKey(values, imprestTypes)
  const prevKey = erpCalcKey(imprestPrevValues, imprestTypes)

  const erpFieldsChanged = calcKey !== prevKey
  const dailyRateChanged = values.dailyRate !== imprestPrevValues.dailyRate
  const amountChanged = values.amount !== imprestPrevValues.amount
  const jobGradeRate = usesJobGradeDailyRate(advanceType, imprestTypes)
  const canFetchFromErp =
    Boolean(advanceType) && noOfDays > 0 && (jobGradeRate || Boolean(destination))

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
        form.setError('dailyRate', {
          type: 'manual',
          message:
            'ERP has no Job Grade daily rate for your employee (Job Group/Grade missing or not set up). Enter Daily Rate manually — Amount = rate × days.',
        })
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
  const imprestTypes = useLookupOptions('imprest-types', imprestTypeOptions)
  const destinations = useLookupOptions('travel-destinations')
  const prevTravelRef = useRef<{ travel: string; ret: string }>({ travel: '', ret: '' })

  const buildHeaderPayload = useCallback((values: FieldValues) => {
    const travelDate = String(values.travelDate ?? '')
    let returnDate = String(values.returnDate ?? '')
    if (travelDate && (!returnDate || returnDate <= travelDate)) {
      returnDate = bumpReturnAfterTravel(travelDate)
    }
    return {
      ...values,
      travelDate,
      returnDate,
      startDate: travelDate,
      title: String(values.purpose || 'Imprest Requisition'),
    }
  }, [])

  const headerOnValuesChange = useCallback((values: FieldValues, form: UseFormReturn<FieldValues>) => {
    const travelDate = String(values.travelDate ?? '').trim()
    const returnDate = String(values.returnDate ?? '').trim()
    const prev = prevTravelRef.current
    const travelChanged = travelDate !== prev.travel
    const returnChanged = returnDate !== prev.ret
    prevTravelRef.current = { travel: travelDate, ret: returnDate }

    if (travelChanged && !travelDate) {
      if (returnDate) form.setValue('returnDate', '', { shouldValidate: false, shouldDirty: true })
      return
    }
    if (travelChanged && travelDate && (!returnDate || returnDate <= travelDate)) {
      const bumped = bumpReturnAfterTravel(travelDate)
      if (bumped && bumped !== returnDate) {
        form.setValue('returnDate', bumped, { shouldValidate: true, shouldDirty: true })
      }
      return
    }
    if (returnChanged && returnDate && travelDate && returnDate <= travelDate) {
      const bumped = bumpReturnAfterTravel(travelDate)
      if (bumped !== returnDate) {
        form.setValue('returnDate', bumped, { shouldValidate: true, shouldDirty: true })
      }
    }
  }, [])

  return (
    <MultiStepRequestPage
      title="Imprest Requisition"
      headerLabel="New Imprest Requisition"
      description="Create the imprest header, then add advance lines. Per-diem daily rates are fetched from Business Central Job Grade Advance Rates using your employee job grade, advance type, and number of days (not destination rates)."
      module={module}
      queryKey={['finance', 'imprest']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      cancelStatuses={FINANCE_CANCEL_STATUSES}
      listSearchExtra={imprestListSearchExtra}
      newButtonLabel="New Imprest Requisition"
      headerSchema={imprestHeaderSchema}
      headerDefaults={{ dateRequired: today, purpose: '', travelDestination: '', travelDate: today, returnDate: tomorrow }}
      headerSupplement={() => <FinanceEmployeeOrgBanner />}
      buildHeaderPayload={buildHeaderPayload}
      headerOnValuesChange={headerOnValuesChange}
      headerFields={[
        {
          name: 'dateRequired',
          label: 'Date Required',
          type: 'date',
          valuePaths: [
            'DateRequired',
            'Date_Required',
            'PaymentReleaseDate',
            'Payment_Release_Date',
            'Date',
          ],
        },
        { name: 'purpose', label: 'Imprest Purpose', type: 'textarea', valuePaths: ['Purpose'] },
        {
          name: 'travelDestination',
          label: 'Travel Destination',
          type: 'text',
          valuePaths: ['TravelDestination', 'Travel_Destination'],
        },
        {
          name: 'travelDate',
          label: 'Travel Start Date',
          type: 'date',
          hint: 'Return date auto-fills to the next day when empty',
          valuePaths: ['TravelStartDate', 'Travel_Start_Date', 'TravelDate', 'Travel_Date'],
        },
        {
          name: 'returnDate',
          label: 'Expected Return Date',
          type: 'date',
          hint: 'Must be after the travel start date',
          valuePaths: ['ExpectedReturnDate', 'Expected_Return_Date', 'ReturnDate', 'Return_Date'],
        },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        {
          label: 'Date Required',
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
        { label: 'Purpose', paths: ['payload.Purpose', 'payload.purpose'] },
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
        {
          label: 'Daily Rate (Job Grade)',
          paths: ['payload.DailyRate', 'payload.Daily_Rate', 'payload.DailyRateAmount'],
          format: 'currency',
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
        { label: 'Surrender Status (BC)', paths: ['payload.SurrenderStatus', 'payload.Surrender_Status'] },
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
        label: 'Imprest Lines',
        addLabel: 'Add Imprest Line',
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
            // Word Aug 7: destination already entered on header — prefill ERP rate location from it.
            destination: destinationFromRequest(request, destinations.options),
            ...(days > 0 ? { noOfDays: days } : {}),
          }
        },
        onValuesChange: (values, form, requestId) =>
          applyImprestLineAmount(values, form, requestId, imprestTypes.options),
        fields: [
          { name: 'advanceType', label: 'Advance Type', type: 'select', options: imprestTypes.options },
          { name: 'dutyArea', label: 'Duty Area', type: 'text' },
          { name: 'noOfDays', label: 'No. of Days', type: 'number' },
          {
            name: 'dailyRate',
            label: 'Daily Rate (ERP Job Grade)',
            type: 'number',
            placeholder: 'Auto-filled from Job Grade Advance Rates — enter manually only if BC has no rate',
          },
          {
            name: 'amount',
            label: 'Amount',
            type: 'number',
            placeholder: 'Auto-filled from ERP (job-grade daily rate × days) — or enter manually',
          },
        ],
        columns: [
          { key: 'advanceType', header: 'Advance Type' },
          { key: 'destination', header: 'Rate Location' },
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
        emptyText: '*** No Imprest Lines Found ***',
        canEdit: false,
      }}
    />
  )
}
