/// <summary>
/// Fuel & maintenance list including portal additive fields (technician / odometer / FA receipt).
/// Base columns = live table 50865. Extension columns = tableextension 52124.
/// Published as "QyPortalFuelMaint".
/// </summary>
query 52125 "Portal Fuel Maint Requests"
{
    Caption = 'Portal Fuel Maint Requests';
    QueryType = Normal;

    elements
    {
        dataitem(FuelMaint; "FLT-Fuel & Maintenance Req.")
        {
            column(RequisitionNo; "Requisition No") { }
            column(RequestDate; "Request Date") { }
            column(Status; Status) { }
            column(Type_Field; "Type") { }
            column(TypeofMaintenance; "Type of Maintenance") { }
            column(RequisitionType; "Requisition Type") { }
            column(VehicleRegNo; "Vehicle Reg No") { }
            column(FixedAssetNo; "Fixed Asset No") { }
            column(Description; Description) { }
            column(MaintenanceDescription; "Maintenance Description") { }
            column(RequesterID; "Requester ID") { }
            column(PreparedBy; "Prepared By") { }
            column(DateTakenforMaintenance; "Date Taken for Maintenance") { }
            column(InitialOdometerReading; "Initial Odometer Reading") { }
            column(CurrentOdometerReading; "Current Odometer Reading") { }
            column(LastServiceDate; "Last Service Date") { }
            column(QuantityofFuelLitres; "Quantity of Fuel(Litres)") { }
            column(AssignedTechnician; "Assigned Technician") { }
            column(AssignedTechnicianName; "Assigned Technician Name") { }
            column(CurrentOdometer; "Current Odometer") { }
            column(LastServiceOdometer; "Last Service Odometer") { }
            column(NextServiceKM; "Next Service KM") { }
            column(FAReceivedBy; "FA Received By") { }
            column(FAReceivedDate; "FA Received Date") { }
            column(FAReceiptRemarks; "FA Receipt Remarks") { }
            column(SystemId; SystemId) { }
        }
    }
}
