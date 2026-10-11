/// <summary>
/// SSP Facility UAT R35-R44: maintenance-request template extras the FLT
/// Fuel &amp; Maintenance Req. table (50865) does not carry — priority, FA tag,
/// technician assignment (R39), FA receipt confirmation (R40) and odometer /
/// next-service-KM tracking (R41/R42).
/// Additive companion table keyed by the FLT Requisition No.
/// Read by query 52168 "QyPortalFuelMaintExtra"; written by codeunit 52161 (CuPortalFacility).
/// </summary>
table 52163 "Portal Fuel Maint. Extra"
{
    Caption = 'Portal Fuel & Maintenance Extra';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Requisition No."; Code[20]) { Caption = 'Requisition No.'; }
        field(2; "Employee No."; Code[20]) { Caption = 'Requesting Employee No.'; }
        field(3; "Request Type"; Integer) { Caption = 'Request Type (1=Fixed Asset, 2=Vehicle Service)'; }
        field(4; "FA Tag Number"; Code[30]) { Caption = 'FA Tag Number'; }
        field(5; "Vehicle No."; Code[30]) { Caption = 'Vehicle Registration No.'; }
        field(6; Item; Text[100]) { Caption = 'Item / Service'; }
        field(7; Quantity; Decimal) { Caption = 'Quantity'; }
        field(8; Priority; Text[20]) { Caption = 'Priority'; }
        field(9; Location; Text[100]) { Caption = 'Location'; }
        field(10; "Issue Description"; Text[500]) { Caption = 'Issue Description'; }
        field(11; "Current Odometer"; Decimal) { Caption = 'Current Odometer (KM)'; }
        field(12; "Last Service Odometer"; Decimal) { Caption = 'Last Service Odometer (KM)'; }
        field(13; "Next Service KM"; Decimal) { Caption = 'Next Service KM'; }
        field(14; "Assigned Technician"; Code[20]) { Caption = 'Assigned Technician (Employee No.)'; }
        field(15; "Assigned Technician Name"; Text[100]) { Caption = 'Assigned Technician Name'; }
        field(16; "Assigned By"; Code[50]) { Caption = 'Assigned By (User ID)'; }
        field(17; "Assigned On"; DateTime) { Caption = 'Assigned On'; }
        field(18; "FA Received By"; Code[50]) { Caption = 'FA Received By (User ID)'; }
        field(19; "FA Received Date"; Date) { Caption = 'FA Received Date'; }
        field(20; "Receipt Remarks"; Text[100]) { Caption = 'Receipt Remarks'; }
        field(21; "Created On"; DateTime) { Caption = 'Created On'; Editable = false; }
        field(22; "Requested Fuel Litres"; Decimal) { Caption = 'Requested Fuel (Litres)'; }
        field(23; "Vehicle Fuel Rating"; Decimal) { Caption = 'Vehicle Fuel Rating'; }
        field(24; "Vehicle Current Reading"; Decimal) { Caption = 'Vehicle Previous Odometer Reading'; }
    }

    keys
    {
        key(PK; "Requisition No.") { Clustered = true; }
        key(Employee; "Employee No.") { }
    }

    trigger OnInsert()
    begin
        "Created On" := CurrentDateTime;
    end;
}
