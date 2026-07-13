Table 50369 "Fuel Card Setup"
{
    LookupPageId = "Fuel Card Setup";
    DrillDownPageId = "Fuel Card Setup";
    fields
    {
        field(1; "Card No"; Code[20]) { }
        field(2; Vendor; Code[20])
        {
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                vend: Record Vendor;
            begin
                vend.Reset();
                vend.SetRange("No.", Vendor);
                if vend.Find('-') then "Vendor Name" := vend.Name;
            end;
        }
        field(3; "Vendor Name"; Text[100]) { }
        field(4; "Vehicle Assigned"; Code[20])
        {
            TableRelation = "FLT-Vehicle Header"."No.";
        }
        field(5; "Card PIN"; Code[30]) { }
        field(6; "Card Limit"; Decimal) { }
    }

    keys
    {
        key(Key1; "Card No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

