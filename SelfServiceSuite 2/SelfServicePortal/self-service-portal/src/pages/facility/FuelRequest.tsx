import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { fuelRequestTypeOptions } from '@/data/essOptions'
import { fuelHeaderSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'

const module = { module: 'fuelRequest', entity: 'selfServiceFuelRequests' } as const

export function FuelRequest() {
  const fuelCards = useLookupOptions('fuel-cards')
  const vehicles = useLookupOptions('vehicles')
  const vendors = useLookupOptions('vendors')

  return (
    <MultiStepRequestPage
      title="Fuel Requisition"
      headerLabel="New Fuel Requisition Card"
      description="Request fuel against a vehicle or a fuel recharge card, then submit for approval."
      module={module}
      queryKey={['facility', 'fuel-request']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Fuel Requisition"
      headerSchema={fuelHeaderSchema}
      headerDefaults={{
        requestType: '0',
        cardNo: '',
        vehicleNo: '',
        fuelDealer: '',
        quantity: 0,
        price: 0,
        purpose: '',
      }}
      buildHeaderPayload={(values) => ({
        ...values,
        title: String(values.purpose || 'Fuel Requisition'),
      })}
      headerFields={[
        { name: 'requestType', label: 'Request Type', type: 'select', options: fuelRequestTypeOptions },
        { name: 'cardNo', label: 'Fuel Card No.', type: 'select', options: fuelCards.options },
        { name: 'vehicleNo', label: 'Vehicle Registration No.', type: 'select', options: vehicles.options },
        { name: 'fuelDealer', label: 'Fuel Dealer', type: 'select', options: vendors.options },
        { name: 'quantity', label: 'Quantity of Fuel (Litres)', type: 'number' },
        { name: 'price', label: 'Fuel Price per Litre', type: 'number' },
        { name: 'purpose', label: 'Purpose', type: 'textarea' },
      ]}
      businessRules={[
        'Vehicle fuel requires a vehicle registration number; a recharge card requires a card number.',
        'Capture the dealer, quantity and price per litre, then request approval.',
      ]}
    />
  )
}
