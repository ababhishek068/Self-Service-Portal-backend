/// <summary>
/// SSP Facility UAT R35-R44: maintenance template extras readback (priority,
/// technician assignment, odometer / next service KM, FA receipt).
/// PUBLISH AS ODATA WEB SERVICE with Service Name = "QyPortalFuelMaintExtra".
/// Column names are read verbatim by the portal — do not rename.
/// </summary>
query 52123 "QyPortalFuelMaintExtra"
{
    QueryType = Normal;

    elements
    {
        dataitem(Extra; "Portal Fuel Maint. Extra")
        {
            column(RequisitionNo; "Requisition No.") { }
            column(EmployeeNo; "Employee No.") { }
            column(RequestType; "Request Type") { }
            column(FATagNumber; "FA Tag Number") { }
            column(VehicleNo; "Vehicle No.") { }
            column(Item; Item) { }
            column(Quantity; Quantity) { }
            column(Priority; Priority) { }
            column(Location; Location) { }
            column(IssueDescription; "Issue Description") { }
            column(CurrentOdometer; "Current Odometer") { }
            column(LastServiceOdometer; "Last Service Odometer") { }
            column(NextServiceKM; "Next Service KM") { }
            column(AssignedTechnician; "Assigned Technician") { }
            column(AssignedTechnicianName; "Assigned Technician Name") { }
            column(FAReceivedBy; "FA Received By") { }
            column(FAReceivedDate; "FA Received Date") { }
            column(ReceiptRemarks; "Receipt Remarks") { }
        }
    }
}
