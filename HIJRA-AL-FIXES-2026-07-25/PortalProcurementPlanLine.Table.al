/// <summary>
/// SSP Facility UAT R59-R61: itemised procurement budget plan lines.
/// Type: 1 = G/L Account, 2 = Item, 3 = Fixed Asset (matches the SSP portal).
/// Read by query 52125 "QyProcurementPlanLines"; written by codeunit 52122 (CuPortalFacility).
/// </summary>
table 52125 "Portal Procurement Plan Line"
{
    Caption = 'Portal Procurement Plan Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Budget Name"; Code[50]) { Caption = 'Budget Name'; }
        field(2; Department; Code[20]) { Caption = 'Department'; }
        field(3; Type; Integer) { Caption = 'Type (1=G/L Account, 2=Item, 3=Fixed Asset)'; }
        field(4; "Type No."; Code[30]) { Caption = 'Type No.'; }
        field(5; "Global Dimension 1"; Code[20]) { Caption = 'Sector (Global Dimension 1)'; }
        field(6; "Plan Period"; Code[20]) { Caption = 'Procurement Plan Period'; }
        field(7; Description; Text[100]) { Caption = 'Description'; }
        field(8; Quantity; Decimal) { Caption = 'Quantity'; }
        field(9; "Unit Cost"; Decimal) { Caption = 'Unit Cost'; }
        field(10; Amount; Decimal) { Caption = 'Amount'; }
        field(11; "Plan Date"; Date) { Caption = 'Plan Date'; }
        field(12; "Created On"; DateTime) { Caption = 'Created On'; Editable = false; }
    }

    keys
    {
        key(PK; "Budget Name", Department, Type, "Type No.", "Global Dimension 1", "Plan Period") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        "Created On" := CurrentDateTime;
    end;
}
