import { formatISO } from 'date-fns'
import type { FieldValues, UseFormReturn } from 'react-hook-form'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { fetchImprestLineAmount } from '@/api/endpoints/imprestCalc'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { imprestTypeOptions } from '@/data/essOptions'
import { imprestHeaderSchema, imprestLineHeaderSchema } from '@/schemas/requestSchemas'
import { formatCurrency } from '@/utils/formatters'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'imprest', entity: 'selfServiceImprestRequests' } as const

function documentNoFromRequestId(requestId: string) {
  const separator = requestId.indexOf('-')
  return separator >= 0 ? requestId.slice(separator + 1) : requestId
}

let imprestAmountRequest = 0

async function applyImprestLineAmount(
  values: FieldValues,
  form: UseFormReturn<FieldValues>,
  requestId: string,
) {
  const advanceType = String(values.advanceType ?? '').trim()
  const destination = String(values.destination ?? '').trim()
  const noOfDays = Number(values.noOfDays ?? 0)
  if (!advanceType || !destination || !noOfDays) return

  const requestKey = ++imprestAmountRequest
  try {
    const amount = await fetchImprestLineAmount({
      headerNo: documentNoFromRequestId(requestId),
      noOfDays,
      advanceType,
      destinationCode: destination,
    })
    if (requestKey !== imprestAmountRequest) return
    if (amount > 0) form.setValue('amount', amount, { shouldValidate: true })
  } catch {
    // Allow manual correction if BC calculation is unavailable.
  }
}

export function ImprestRequest() {
  const imprestTypes = useLookupOptions('imprest-types', imprestTypeOptions)
  const destinations = useLookupOptions('travel-destinations')

  return (
    <MultiStepRequestPage
      title="Imprest Requisition"
      headerLabel="New Imprest Requisition"
      description="Create the imprest header, then add advance lines (type, destination, duty area, days, amount) before requesting approval."
      module={module}
      queryKey={['finance', 'imprest']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Imprest Requisition"
      headerSchema={imprestHeaderSchema}
      headerDefaults={{ dateRequired: today, purpose: '', travelDestination: '', travelDate: today, returnDate: today }}
      buildHeaderPayload={(values) => ({
        ...values,
        startDate: values.travelDate,
        title: String(values.purpose || 'Imprest Requisition'),
      })}
      headerFields={[
        { name: 'dateRequired', label: 'Date Required', type: 'date', valuePaths: ['DateRequired', 'Date_Required', 'Date'] },
        { name: 'purpose', label: 'Imprest Purpose', type: 'textarea', valuePaths: ['Purpose'] },
        // UAT 23/07/2026: free-text destination, persisted on the BC header (tableextension 52133).
        { name: 'travelDestination', label: 'Travel Destination (free text)', type: 'text', valuePaths: ['TravelDestination', 'Travel_Destination'] },
        { name: 'travelDate', label: 'Travel Date', type: 'date', valuePaths: ['TravelStartDate', 'Travel_Start_Date', 'TravelDate', 'Travel_Date'] },
        { name: 'returnDate', label: 'Return Date', type: 'date', valuePaths: ['ReturnDate', 'Return_Date', 'Date'] },
      ]}
      detailFields={[
        { label: 'Request No.', paths: ['request.requestNo'] },
        { label: 'Date Required', paths: ['payload.DateRequired', 'payload.Date_Required'], format: 'date' },
        { label: 'Purpose', paths: ['payload.Purpose', 'payload.purpose'] },
        { label: 'Travel Destination', paths: ['payload.TravelDestination', 'payload.Travel_Destination'] },
        { label: 'Travel Date', paths: ['payload.TravelStartDate', 'payload.Travel_Start_Date', 'payload.TravelDate', 'payload.Travel_Date'], format: 'date' },
        { label: 'Return Date', paths: ['payload.ReturnDate', 'payload.Return_Date'], format: 'date' },
        { label: 'Duration', paths: ['payload.DurationDate'] },
        { label: 'Department', paths: ['request.departmentName', 'request.departmentCode', 'payload.ShortcutDimension2Code'] },
        {
          label: 'Job Title',
          paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
        },
        { label: 'Responsibility Center', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
        { label: 'Place of Duty', paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'] },
        { label: 'Employee Account', paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.ImprestNo'] },
        { label: 'Total Net Amount', paths: ['payload.TotalNetAmount', 'request.amount'], format: 'currency' },
        // BC's own Full/Partial surrender state (field 88) — read-only, shows after surrenders post.
        { label: 'Surrender Status (BC)', paths: ['payload.SurrenderStatus', 'payload.Surrender_Status'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
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
          amount: '',
        },
        onValuesChange: (values, form, requestId) => applyImprestLineAmount(values, form, requestId),
        fields: [
          { name: 'advanceType', label: 'Advance Type', type: 'select', options: imprestTypes.options },
          { name: 'destination', label: 'Travel Destination', type: 'select', options: destinations.options },
          { name: 'dutyArea', label: 'Duty Area', type: 'text' },
          { name: 'noOfDays', label: 'No. of Days', type: 'number' },
          {
            name: 'amount',
            label: 'Amount',
            type: 'number',
            placeholder: 'Auto-calculated from type, destination and days — or enter manually',
          },
        ],
        columns: [
          { key: 'advanceType', header: 'Advance Type' },
          { key: 'destination', header: 'Travel Destination' },
          { key: 'accountNo', header: 'Account No.' },
          { key: 'accountName', header: 'Account Name' },
          { key: 'amount', header: 'Amount', format: (value) => formatCurrency(Number(value ?? 0)) },
          { key: 'noOfDays', header: 'No of Days' },
        ],
        emptyText: '*** No Imprest Lines Found ***',
        canEdit: false,
      }}
    />
  )
}
