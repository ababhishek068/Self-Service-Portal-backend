/// <summary>
/// SSP Facility UAT R59-R61: department / district procurement budget template.
/// Additive header — one plan per Budget Name + Sector + Department + Period.
/// Read by query 52169 "QyProcurementPlanHeader"; written by codeunit 52161 (CuPortalFacility).
/// </summary>
table 52164 "Portal Procurement Plan Hdr."
{
    Caption = 'Portal Procurement Plan Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Budget Name"; Code[50]) { Caption = 'Budget Name'; }
        field(2; "Global Dimension 1"; Code[20]) { Caption = 'Sector (Global Dimension 1)'; }
        field(3; "Global Dimension 2"; Code[20]) { Caption = 'Department (Global Dimension 2)'; }
        field(4; "Plan Period"; Code[20]) { Caption = 'Procurement Plan Period'; }
        field(5; Status; Text[20]) { Caption = 'Status'; }
        field(6; "Created By"; Code[50]) { Caption = 'Created By (User ID)'; }
        field(7; "Created On"; DateTime) { Caption = 'Created On'; Editable = false; }
        field(8; "Submitted On"; DateTime) { Caption = 'Submitted On'; }
    }

    keys
    {
        key(PK; "Budget Name", "Global Dimension 1", "Global Dimension 2", "Plan Period") { Clustered = true; }
    }

    trigger OnInsert()
    begin
        "Created On" := CurrentDateTime;
        if Status = '' then
            Status := 'Open';
    end;
}
