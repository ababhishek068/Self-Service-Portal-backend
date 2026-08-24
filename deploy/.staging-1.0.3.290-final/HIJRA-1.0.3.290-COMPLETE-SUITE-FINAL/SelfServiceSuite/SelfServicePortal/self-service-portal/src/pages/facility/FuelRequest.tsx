import { MultiStepRequestPage } from '@/components/shared/MultiStepRequestPage'
import { listModuleRequests } from '@/api/endpoints/requestEndpoint'
import { fuelRequestTypeOptions } from '@/data/essOptions'
import { fuelHeaderSchema } from '@/schemas/requestSchemas'
import { useLookupOptions } from '@/hooks/useLookupOptions'
import { formatCurrency } from '@/utils/formatters'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'

const module = { module: 'fuelRequest', entity: 'selfServiceFuelRequests' } as const

export function FuelRequest() {
  const fuelCards = useLookupOptions('fuel-cards')
  const vehicles = useLookupOptions('vehicles')
  const vendors = useLookupOptions('vendors')
  const fuelCardOptions = fuelCards.options.map((option) => {
    const vehicleNo = String(option.meta?.vehicleNo ?? '').trim()
    return {
      ...option,
      label: vehicleNo ? `${option.label} — Vehicle ${vehicleNo}` : option.label,
    }
  })

  return (
    <MultiStepRequestPage
      title="Fuel Requisition"
      headerLabel="New Fuel Requisition Card"
      description="Bank vehicle fuel requests require previous KM and current KM so consumption can be checked against the vehicle fuel standard."
      module={module}
      queryKey={['facility', 'fuel-request']}
      listRequests={() => listModuleRequests(module)}
      newButtonLabel="New Fuel Requisition"
      listValueColumn={{
        id: 'amount',
        header: 'Fuel Cost',
        cell: (row) => row.amount > 0 ? formatCurrency(row.amount) : 'Not costed',
      }}
      headerSchema={fuelHeaderSchema}
      headerDefaults={{
        requestType: '0',
        cardNo: '',
        vehicleNo: '',
        fuelDealer: '',
        quantity: 0,
        price: 0,
        odometer: 0,
        purpose: '',
        consumptionRemark: '',
      }}
      buildHeaderPayload={(values) => {
        const isCard = String(values.requestType) === '3'
        const card = isCard
          ? fuelCards.options.find((option) => option.value === values.cardNo)
          : undefined
        const vehicleNo = String(card?.meta?.vehicleNo ?? values.vehicleNo ?? '').trim()
        const vehicle = vehicles.options.find((option) => option.value === vehicleNo)
        const fuelRating = Number(vehicle?.meta?.fuelRating ?? card?.meta?.fuelRating ?? 0)
        const previousReading = Number(vehicle?.meta?.currentReading ?? card?.meta?.currentReading ?? 0)
        const currentOdometer = Number(values.odometer ?? 0)
        const litres = Number(values.quantity ?? 0)
        const consumptionRemark = String(values.consumptionRemark ?? '').trim()
        if (previousReading > 0 && currentOdometer > 0 && currentOdometer < previousReading) {
          throw new Error(
            `Current KM (${currentOdometer}) cannot be less than previous KM (${previousReading}).`,
          )
        }
        if (previousReading > 0 && currentOdometer > 0 && litres > 0 && fuelRating > 0) {
          const kmDriven = currentOdometer - previousReading
          const actualKmPerLitre = kmDriven / litres
          if (actualKmPerLitre < fuelRating && !consumptionRemark) {
            throw new Error(
              `Actual consumption ${actualKmPerLitre.toFixed(2)} km/L is below the vehicle standard ${fuelRating} km/L. ` +
                `Please enter a reason in the "Consumption Remark" field (e.g. rough terrain, heavy load, traffic).`,
            )
          }
        }
        return {
          ...values,
          consumptionRemark,
          ...(isCard
            ? {
                vehicleNo: String(card?.meta?.vehicleNo ?? values.vehicleNo ?? ''),
                fuelDealer: String(card?.meta?.vendorNo ?? values.fuelDealer ?? ''),
              }
            : {}),
          title: String(values.purpose || 'Fuel Requisition'),
        }
      }}
      headerSupplement={(values, setValue) => {
        const isCard = String(values.requestType) === '3'
        const card = isCard
          ? fuelCards.options.find((option) => option.value === values.cardNo)
          : undefined
        const vehicleNo = String(card?.meta?.vehicleNo ?? values.vehicleNo ?? '').trim()
        const vehicle = vehicles.options.find((option) => option.value === vehicleNo)
        const vendor = String(card?.meta?.vendorName ?? card?.meta?.vendorNo ?? '').trim()
        const monthlyLimit = Number(card?.meta?.monthlyLimit ?? 0)
        const requestedLitres = Number(values.quantity ?? 0)
        const fuelRating = Number(vehicle?.meta?.fuelRating ?? card?.meta?.fuelRating ?? 0)
        const previousReading = Number(vehicle?.meta?.currentReading ?? card?.meta?.currentReading ?? 0)
        const currentOdometer = Number(values.odometer ?? 0)
        const kmDriven =
          currentOdometer > 0 && previousReading > 0 && currentOdometer >= previousReading
            ? currentOdometer - previousReading
            : 0
        const actualKmPerLitre =
          kmDriven > 0 && requestedLitres > 0 ? kmDriven / requestedLitres : 0
        const belowStandard =
          fuelRating > 0 && actualKmPerLitre > 0 && actualKmPerLitre < fuelRating
        const consumptionRemark = String(values.consumptionRemark ?? '')
        if (!vehicleNo && !values.cardNo) return null
        return (
          <div className="space-y-2">
            <div className="grid gap-2 sm:grid-cols-2">
              <div className="rounded-lg border border-slate-200 bg-white px-3 py-2">
                <p className="text-xs text-slate-500">Previous KM (from vehicle card)</p>
                <p className="mt-0.5 text-sm font-semibold text-slate-800">
                  {previousReading > 0 ? `${previousReading.toLocaleString()} km` : 'Not set on FLT Vehicle Card'}
                </p>
              </div>
              <div className="rounded-lg border border-slate-200 bg-white px-3 py-2">
                <p className="text-xs text-slate-500">Current KM (entered on this request)</p>
                <p className="mt-0.5 text-sm font-semibold text-slate-800">
                  {currentOdometer > 0 ? `${currentOdometer.toLocaleString()} km` : 'Enter current odometer below'}
                </p>
              </div>
            </div>
            <div className="rounded-lg border border-blue-200 bg-blue-50 p-3 text-sm text-blue-900">
              <p className="font-semibold">Vehicle fuel standard (Bank vehicle)</p>
              {isCard ? <p>Fuel card: {String(values.cardNo || 'Not selected')}</p> : null}
              <p>Assigned vehicle: {vehicleNo || 'Not configured on fuel card setup'}</p>
              {isCard ? <p>Fuel vendor: {vendor || 'Not configured on fuel card setup'}</p> : null}
              <p>
                Vehicle fuel rating (standard):{' '}
                {fuelRating > 0 ? `${fuelRating} km/L` : '0 — set Fuel Rating on FLT Vehicle Card in BC'}
              </p>
              <p>Requested litres: {requestedLitres > 0 ? `${requestedLitres} L` : '—'}</p>
              <p>
                Fuel price / litre:{' '}
                {Number(values.price ?? 0) > 0 ? formatCurrency(Number(values.price)) : '—'}
              </p>
              <p>
                Total fuel cost:{' '}
                {Number(values.price ?? 0) > 0 && requestedLitres > 0
                  ? formatCurrency(Number(values.price) * requestedLitres)
                  : '—'}
              </p>
              {kmDriven > 0 ? <p>KM driven (current − previous): {kmDriven} km</p> : null}
              {actualKmPerLitre > 0 ? (
                <p>
                  Implied consumption: {actualKmPerLitre.toFixed(2)} km/L
                  {fuelRating > 0 ? ` vs standard ${fuelRating} km/L` : ''}
                  {belowStandard ? ' — below vehicle standard' : ' — within standard ✓'}
                </p>
              ) : null}
              {monthlyLimit > 0 ? (
                <p>
                  Monthly fuel card limit: {formatCurrency(monthlyLimit)} · Requested: {requestedLitres} L
                  {requestedLitres > monthlyLimit ? ' — exceeds limit' : ''}
                </p>
              ) : null}
            </div>
            {fuelRating <= 0 || previousReading <= 0 ? (
              <p className="rounded-md border border-amber-200 bg-amber-50 p-2 text-xs text-amber-900">
                BC vehicle master is incomplete for this plate. In Business Central open{' '}
                <span className="font-medium">FLT Vehicle Card</span> for this vehicle and set{' '}
                <span className="font-medium">Fuel Rating</span> and{' '}
                <span className="font-medium">Current Reading</span> (previous KM), then refresh this page.
              </p>
            ) : null}
            {belowStandard ? (
              <div className="rounded-md border border-amber-200 bg-amber-50 p-3 space-y-2">
                <p className="text-xs font-semibold text-amber-900">
                  Consumption below vehicle standard ({actualKmPerLitre.toFixed(2)} km/L &lt; {fuelRating} km/L)
                </p>
                <p className="text-xs text-amber-800">
                  This can happen due to terrain, traffic, load, vehicle age or operating conditions.
                  Please provide a brief reason so the approver can review and approve accordingly.
                </p>
                <div className="space-y-1">
                  <Label htmlFor="consumptionRemark" className="text-xs font-medium text-amber-900">
                    Reason for below-standard consumption <span className="text-red-600">*</span>
                  </Label>
                  <Textarea
                    id="consumptionRemark"
                    placeholder="e.g. Heavy traffic conditions, mountainous terrain, vehicle carrying heavy load, aged vehicle…"
                    className="min-h-[72px] text-sm bg-white"
                    value={consumptionRemark}
                    onChange={(e) => setValue?.('consumptionRemark', e.target.value)}
                  />
                  {!consumptionRemark.trim() ? (
                    <p className="text-xs text-red-600">Required — submission is blocked until a reason is entered.</p>
                  ) : null}
                </div>
              </div>
            ) : null}
          </div>
        )
      }}
      headerFields={[
        // QyFuelMaintenanceRequests exposes the FLT columns: RequisitionType
        // ("Vehicle Fuel" / "Fuel Recharge Card"), VehicleRegNo, FuelCardNo,
        // VendorDealer, QuantityofFuelLitres, PriceLitre and Description.
        { name: 'requestType', label: 'Request Type', type: 'select', options: fuelRequestTypeOptions, valuePaths: ['RequisitionType', 'Requisition_Type', 'RequestType', 'Request_Type'], valueMap: { 'vehicle fuel': '0', vehicle: '0', 'fuel recharge card': '3', card: '3' } },
        { name: 'cardNo', label: 'Fuel Card No.', type: 'select', options: fuelCardOptions, valuePaths: ['FuelCardNo', 'Fuel_Card_No', 'CardNo', 'Card_No'] },
        { name: 'vehicleNo', label: 'Vehicle Registration No.', type: 'select', options: vehicles.options, valuePaths: ['VehicleRegNo', 'Vehicle_Reg_No', 'VehicleNo', 'Vehicle_No'] },
        { name: 'fuelDealer', label: 'Fuel Dealer', type: 'select', options: vendors.options, valuePaths: ['VendorDealer', 'Vendor_Dealer', 'FuelDealer', 'Fuel_Dealer'] },
        { name: 'quantity', label: 'Quantity of Fuel (Litres)', type: 'number', valuePaths: ['QuantityofFuelLitres', 'Quantity_of_Fuel_Litres', 'Quantity'] },
        { name: 'price', label: 'Fuel Price per Litre', type: 'number', valuePaths: ['PriceLitre', 'Price_Litre', 'Price'] },
        { name: 'odometer', label: 'Current KM (odometer)', type: 'number', valuePaths: ['CurrentOdometer', 'Initial_Odometer_Reading', 'InitialOdometerReading'] },
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
        { label: 'Previous KM', paths: ['payload.VehicleCurrentReading', 'payload.Vehicle_Current_Reading'] },
        { label: 'Current KM', paths: ['payload.CurrentOdometer', 'payload.Initial_Odometer_Reading', 'payload.InitialOdometerReading'] },
        { label: 'Vehicle Fuel Rating (km/L)', paths: ['payload.VehicleFuelRating'] },
        { label: 'Price per Litre', paths: ['payload.PriceLitre', 'payload.Price_Litre', 'payload.Price'], format: 'currency' },
        { label: 'Total Fuel Price', paths: ['payload.TotalPriceofFuel', 'payload.Total_Price_of_Fuel', 'request.amount'], format: 'currency' },
        { label: 'Request Date', paths: ['payload.RequestDate', 'payload.Request_Date'], format: 'date' },
        { label: 'Purpose', paths: ['payload.Description', 'payload.Purpose'] },
        { label: 'Consumption Remark', paths: ['payload.consumptionRemark', 'payload.ConsumptionRemark', 'payload.IssueDescription'] },
        { label: 'Status', paths: ['request.status'], format: 'status' },
      ]}
    />
  )
}
