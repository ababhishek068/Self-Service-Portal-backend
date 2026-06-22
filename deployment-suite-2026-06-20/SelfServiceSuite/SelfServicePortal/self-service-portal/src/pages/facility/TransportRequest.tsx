import { formatISO } from 'date-fns'
import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { passengerTypeOptions, transportRequestTypeOptions } from '@/data/essOptions'
import { transportHeaderSchema, transportPassengerLineSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const today = formatISO(new Date(), { representation: 'date' })
const module = { module: 'transport', entity: 'selfServiceTransportRequests' } as const

export function TransportRequest() {
  const responsibilityCenters = useLookupOptions('responsibility-centers')
  const employees = useLookupOptions('employees')

  return (
    <MultiStepRequestPage
      title="Transport Requisition"
      headerLabel="New Transport Requisition"
      description="Create the transport header, then add passengers before requesting approval."
      module={module}
      queryKey={['facility', 'transport-request']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Transport Requisition"
      headerSchema={transportHeaderSchema}
      headerDefaults={{
        requestType: '0',
        destination: '',
        dateOfTrip: today,
        responsibilityCenter: '',
        noOfDays: 1,
        noOfPassengers: 1,
        purpose: '',
      }}
      buildHeaderPayload={(values) => ({
        ...values,
        tripDate: values.dateOfTrip,
        transportType: values.requestType,
        title: String(values.purpose || 'Transport Requisition'),
      })}
      headerFields={[
        { name: 'requestType', label: 'Request Type', type: 'select', options: transportRequestTypeOptions },
        { name: 'destination', label: 'Destination', type: 'text' },
        { name: 'dateOfTrip', label: 'Date of Trip', type: 'date' },
        { name: 'responsibilityCenter', label: 'Responsibility Center', type: 'select', options: responsibilityCenters.options },
        { name: 'noOfDays', label: 'No. of Days', type: 'number' },
        { name: 'noOfPassengers', label: 'No. of Passengers', type: 'number' },
        { name: 'purpose', label: 'Purpose of the Trip', type: 'textarea' },
      ]}
      line={{
        label: 'Passengers',
        addLabel: 'Add Passenger',
        schema: transportPassengerLineSchema,
        defaultValues: { passengerType: 'Staff', employeeNo: '', externalPassName: '', externalPassOrganization: '' },
        fields: [
          { name: 'passengerType', label: 'Passenger Type', type: 'select', options: passengerTypeOptions },
          { name: 'employeeNo', label: 'Employee', type: 'select', options: employees.options },
          { name: 'externalPassName', label: 'External Passenger Name', type: 'text' },
          { name: 'externalPassOrganization', label: 'Organization (External)', type: 'text' },
        ],
        columns: [
          { key: 'passengerType', header: 'Type' },
          { key: 'employeeNo', header: 'Employee No.' },
          { key: 'externalPassName', header: 'External Passenger' },
          { key: 'externalPassOrganization', header: 'Organization' },
        ],
        emptyText: '*** No Passengers Found ***',
      }}
      businessRules={[
        'Trip date cannot be in the past.',
        'Add internal staff or external passengers after creating the header.',
        'Request approval once passengers are captured.',
      ]}
    />
  )
}
