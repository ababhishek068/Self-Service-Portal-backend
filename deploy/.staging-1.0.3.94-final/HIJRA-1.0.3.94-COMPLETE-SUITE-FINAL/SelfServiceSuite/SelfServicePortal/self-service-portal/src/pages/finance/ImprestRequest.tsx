import { formatISO } from 'date-fns'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { fetchImprestLineAmount } from '@/api/endpoints/imprestCalc'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { imprestTypeOptions } from '@/data/essOptions'
import { imprestHeaderSchema, imprestLineHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import type { PortalRequest } from '@/types/erp.types'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'imprest', entity: 'selfServiceImprestRequests' } as const

function documentNoFromRequestId(requestId: string) {
  const separator = requestId.indexOf('-')
  return separator >= 0 ? requestId.slice(separator + 1) : requestId
}

let imprestAmountRequest = 0
let imprestCalcBusy = false
let imprestPrevValues: FieldValues = {}

function roundMoney(value: number) {
  return Math.round(value * 100) / 100
}

function erpCalcKey(values: FieldValues) {
  return [
    String(values.advanceType ?? '').trim(),
    String(values.destination ?? '').trim(),
    Number(values.noOfDays ?? 0),
  ].join('|')
}

async function applyImprestLineAmount(
  values: FieldValues,
  form: UseFormReturn<FieldValues>,
  requestId: string,
) {
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

  if (erpFieldsChanged && advanceType && destination && noOfDays > 0) {
    const requestKey = ++imprestAmountRequest
    imprestCalcBusy = true
    try {
      const { amount: fetchedAmount, dailyRate: fetchedRate } = await fetchImprestLineAmount({
        headerNo: documentNoFromRequestId(requestId),
        noOfDays,
        advanceType,
        destinationCode: destination,
      })
      if (requestKey !== imprestAmountRequest) return
      form.clearErrors('dailyRate')
      form.clearErrors('amount')
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
        imprestPrevValues = { ...values }
      }
    } catch (err) {
      const message =
        err instanceof Error
          ? err.message
          : 'Could not calculate daily rate from Business Central. Check advance type, destination and days.'
      form.setError('dailyRate', { type: 'manual', message })
      imprestPrevValues = { ...values }
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

function destinationFromRequest(request: PortalRequest) {
  const payload = request.payload ?? {}
  return String(
    payload.TravelDestination ??
      payload.Travel_Destination ??
      payload.Destination ??
      payload.DestinationCode ??
      '',
  )
}

export function ImprestRequest() {
  const imprestTypes = useLookupOptions('imprest-types', imprestTypeOptions)
  const destinations = useLookupOptions('travel-destinations')

  return (
    <MultiStepRequestPage
      title="Imprest Requisition"
      headerLabel="New Imprest Requisition"
      description="Create the imprest header, then add advance lines (type, destination, duty area, days, daily rate and amount) before requesting approval."
      module={module}
      queryKey={['finance', 'imprest']}
      listRequests={() => listModuleRequests(module)}
      listStatusFilter
      newButtonLabel="New Imprest Requisition"
      headerSchema={imprestHeaderSchema}
      headerDefaults={{ dateRequired: today, purpose: '', travelDestination: '', travelDate: today, returnDate: today }}
      buildHeaderPayload={(values) => ({
        ...values,
        startDate: values.travelDate,
        title: String(values.purpose || 'Imprest Requisition'),
      })}
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
          label: 'Travel Destination (free text)',
          type: 'text',
          valuePaths: ['TravelDestination', 'Travel_Destination'],
        },
        {
          name: 'travelDate',
          label: 'Travel Date',
          type: 'date',
          valuePaths: ['TravelStartDate', 'Travel_Start_Date', 'TravelDate', 'Travel_Date'],
        },
        {
          name: 'returnDate',
          label: 'Return Date',
          type: 'date',
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
          label: 'Travel Date',
          paths: [
            'payload.TravelStartDate',
            'payload.Travel_Start_Date',
            'payload.TravelDate',
            'payload.Travel_Date',
          ],
          format: 'date',
        },
        {
          label: 'Return Date',
          paths: ['payload.ExpectedReturnDate', 'payload.Expected_Return_Date', 'payload.ReturnDate', 'payload.Return_Date'],
          format: 'date',
        },
        { label: 'Duration', paths: ['payload.DurationDate'] },
        {
          label: 'Division',
          paths: ['payload.Division', 'payload.GlobalDimension1Code', 'request.departmentName'],
        },
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
        { label: 'Employee Account', paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.ImprestNo'] },
        { label: 'Total Net Amount', paths: ['payload.TotalNetAmount', 'request.amount'], format: 'currency' },
        {
          label: 'Remaining Unsettled',
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
        defaultValuesFromRequest: (request) => ({
          destination: destinationFromRequest(request),
        }),
        onValuesChange: (values, form, requestId) => applyImprestLineAmount(values, form, requestId),
        fields: [
          { name: 'advanceType', label: 'Advance Type', type: 'select', options: imprestTypes.options },
          {
            name: 'destination',
            label: 'Travel Destination',
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
            label: 'Daily Rate (from Business Central)',
            type: 'number',
            placeholder: 'Auto-filled from ERP — or enter manually if needed',
          },
          {
            name: 'amount',
            label: 'Amount',
            type: 'number',
            placeholder: 'Auto-filled from ERP (daily rate × days) — or enter manually',
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
        emptyText: '*** No Imprest Lines Found ***',
        canEdit: false,
      }}
    />
  )
}
