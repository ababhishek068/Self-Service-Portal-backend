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
        // QyFuelMaintenanceRequests exposes the FLT columns: RequisitionType
        // ("Vehicle Fuel" / "Fuel Recharge Card"), VehicleRegNo, FuelCardNo,
        // VendorDealer, QuantityofFuelLitres, PriceLitre and Description. The
        // old RequestType/VehicleNo/Quantity paths matched nothing, so the
        // request detail rendered blank after create — UAT fail C.
        { name: 'requestType', label: 'Request Type', type: 'select', options: fuelRequestTypeOptions, valuePaths: ['RequisitionType', 'Requisition_Type', 'RequestType', 'Request_Type'], valueMap: { 'vehicle fuel': '0', vehicle: '0', 'fuel recharge card': '3', card: '3' } },
        { name: 'cardNo', label: 'Fuel Card No.', type: 'select', options: fuelCards.options, valuePaths: ['FuelCardNo', 'Fuel_Card_No', 'CardNo', 'Card_No'] },
        { name: 'vehicleNo', label: 'Vehicle Registration No.', type: 'select', options: vehicles.options, valuePaths: ['VehicleRegNo', 'Vehicle_Reg_No', 'VehicleNo', 'Vehicle_No'] },
        { name: 'fuelDealer', label: 'Fuel Dealer', type: 'select', options: vendors.options, valuePaths: ['VendorDealer', 'Vendor_Dealer', 'FuelDealer', 'Fuel_Dealer'] },
        { name: 'quantity', label: 'Quantity of Fuel (Litres)', type: 'number', valuePaths: ['QuantityofFuelLitres', 'Quantity_of_Fuel_Litres', 'Quantity'] },
        { name: 'price', label: 'Fuel Price per Litre', type: 'number', valuePaths: ['PriceLitre', 'Price_Litre', 'Price'] },
        { name: 'purpose', label: 'Purpose', type: 'textarea', valuePaths: ['Description', 'Purpose'] },
      ]}
      detailFields={[
        { label: 'Requisition No.', paths: ['request.requestNo'] },
        { label: 'Request Type', paths: ['payload.RequisitionType', 'payload.Requisition_Type', 'payload.RequestType', 'payload.Request_Type'] },
        { label: 'Fuel Card No.', paths: ['payload.FuelCardNo', 'payload.Fuel_Card_No', 'payload.CardNo', 'payload.Card_No'] },
        { label: 'Vehicle No.', paths: ['payload.VehicleRegNo', 'payload.Vehicle_Reg_No', 'payload.VehicleNo', 'payload.Vehicle_No'] },
        { label: 'Fuel Dealer', paths: ['payload.VendorDealer', 'payload.Vendor_Dealer', 'payload.FuelDealer', 'payload.Fuel_Dealer'] },
        { label: 'Dealer Name', paths: ['payload.VendorName', 'payload.Vendor_Name'] },
        { label: 'Quantity (Litres)', paths: ['payload.QuantityofFuelLitres', 'payload.Quantity_of_Fuel_Litres', 'payload.Quantity'] },
        { label: 'Price per Litre', paths: ['payload.PriceLitre', 'payload.Price_Litre', 'payload.Price'], format: 'currency' },
        { label: 'Total Fuel Price', paths: ['payload.TotalPriceofFuel', 'payload.Total_Price_of_Fuel'], format: 'currency' },
        { label: 'Request Date', paths: ['payload.RequestDate', 'payload.Request_Date'], format: 'date' },
        { label: 'Purpose', paths: ['payload.Description', 'payload.Purpose'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
    />
  )
}
