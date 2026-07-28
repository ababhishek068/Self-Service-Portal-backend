import type { DetailFieldConfig } from '@/components/shared/RequestFormPage'

/**
 * Header fields shown to APPROVERS on the approval detail screen, per module.
 *
 * UAT fail C: fuel (and other header-only documents) reached the approver with
 * no request details at all — the approval screen only rendered lines, and
 * fuel has none. These mirror the requester-side detail fields of each module
 * page, resolved against the same `payload` (raw Business Central row).
 */
export const approvalDetailFields: Record<string, DetailFieldConfig[]> = {
  fuelRequest: [
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
  ],
  maintenance: [
    { label: 'Request Type', paths: ['payload.RequisitionType', 'payload.Requisition_Type', 'payload.Type'] },
    { label: 'Vehicle No.', paths: ['payload.VehicleRegNo', 'payload.Vehicle_Reg_No'] },
    { label: 'Fixed Asset No.', paths: ['payload.FixedAssetNo', 'payload.Fixed_Asset_No'] },
    { label: 'Type of Maintenance', paths: ['payload.TypeofMaintenance', 'payload.Type_of_Maintenance'] },
    { label: 'Request Date', paths: ['payload.RequestDate', 'payload.Request_Date'], format: 'date' },
    { label: 'Description', paths: ['payload.MaintenanceDescription', 'payload.Description'] },
  ],
  transport: [
    { label: 'Request Type', paths: ['payload.Vehicle_Type', 'payload.VehicleType', 'payload.RequestType', 'payload.Request_Type'] },
    { label: 'Destination', paths: ['payload.To', 'payload.Destination'] },
    { label: 'Date of Trip', paths: ['payload.Date_of_Trip', 'payload.DateOfTrip'], format: 'date' },
    { label: 'Responsibility Center', paths: ['payload.Responsibility_Center', 'payload.ResponsibilityCenter', 'request.responsibleCenter'] },
    { label: 'No. of Days', paths: ['payload.No_of_Days_Requested', 'payload.NoOfDays'] },
    { label: 'No. of Passengers', paths: ['payload.No_Of_Passangers', 'payload.NoOfPassengers'] },
    { label: 'Purpose', paths: ['payload.Purpose_of_Trip', 'payload.PurposeOfTrip', 'payload.Purpose'] },
  ],
  purchaseRequisition: [
    { label: 'Needed By Date', paths: ['payload.Needed_By_Date', 'payload.OrderDate', 'payload.Order_Date', 'payload.Posting_Date'], format: 'date' },
    { label: 'Description', paths: ['payload.Posting_Description', 'payload.PostingDescription'] },
    { label: 'Department', paths: ['payload.RequestingDepartment', 'payload.Requesting_Department', 'payload.Shortcut_Dimension_1_Code', 'request.departmentName', 'request.departmentCode'] },
    { label: 'Responsibility Center', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
  ],
  storeRequisition: [
    { label: 'Date Required', paths: ['payload.RequiredDate', 'payload.Required_Date', 'payload.RequestDate'], format: 'date' },
    { label: 'Issuing Store', paths: ['payload.IssuingStore', 'payload.Issuing_Store'] },
    { label: 'Description', paths: ['payload.RequestDescription', 'payload.Request_Description'] },
    { label: 'Department', paths: ['request.departmentName', 'request.departmentCode', 'payload.ShortcutDimension2Code'] },
  ],
  gatePass: [
    { label: 'Source', paths: ['payload.gatePassSourceLabel', 'payload.Linkto', 'payload.Link_to'] },
    { label: 'Source Document No.', paths: ['payload.TransferNo', 'payload.Transfer_No', 'payload.AssetTransferNo'] },
    { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location', 'payload.AssetFromLocation'] },
    { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location', 'payload.AssetToLocation'] },
    { label: 'Date Out', paths: ['payload.DateOut', 'payload.Date_Out', 'payload.DateCreated'], format: 'date' },
    { label: 'Description', paths: ['payload.Description'] },
    { label: 'Comment', paths: ['payload.Comment'] },
  ],
  transferOrder: [
    { label: 'From', paths: ['payload.TransferFromCode', 'payload.Transfer_from_Code', 'payload.FromCode'] },
    { label: 'To', paths: ['payload.TransferToCode', 'payload.Transfer_to_Code', 'payload.ToCode'] },
    { label: 'In-Transit Code', paths: ['payload.InTransitCode', 'payload.In_Transit_Code'] },
    { label: 'Posting Date', paths: ['payload.PostingDate', 'payload.Posting_Date'], format: 'date' },
    { label: 'Driver', paths: ['payload.DriverName', 'payload.Driver_Name'] },
    { label: 'Truck No.', paths: ['payload.TruckNo', 'payload.Truck_No'] },
  ],
  assetTransfer: [
    { label: 'Transfer Type', paths: ['payload.TransferType', 'payload.Transfer_Type', 'payload.TypeOfTransfer'] },
    { label: 'Asset No.', paths: ['payload.AssetNo', 'payload.Asset_No', 'payload.FixedAssetNo'] },
    { label: 'From Employee', paths: ['payload.FromEmployeeNo', 'payload.From_Employee_No'] },
    { label: 'To Employee', paths: ['payload.ToEmployeeNo', 'payload.To_Employee_No'] },
    { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location'] },
    { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location'] },
    { label: 'Reason', paths: ['payload.ReasonText', 'payload.Reason', 'payload.Description'] },
  ],
  staffClaim: [
    { label: 'Claim No.', paths: ['request.requestNo'] },
    { label: 'Claim Date', paths: ['payload.ClaimDate', 'payload.Claim_Date', 'request.createdAt'], format: 'date' },
    { label: 'Purpose', paths: ['payload.ClaimDescription', 'payload.Claim_Description', 'payload.Purpose'] },
    {
      label: 'Department',
      paths: [
        'request.departmentName',
        'request.departmentCode',
        'payload.DepartmentName',
        'payload.Department',
        'payload.GlobalDimension1Code',
      ],
    },
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
    },
    {
      label: 'Job Title',
      paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
    },
    {
      label: 'Total Net Amount',
      paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'request.amount'],
      format: 'currency',
    },
  ],
}
