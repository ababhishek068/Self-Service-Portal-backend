Table 50419 Donors
{
    // DrillDownPageID = UnknownPage39004433;
    // LookupPageID = UnknownPage39004433;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, Code);
                if DimVal.Find('-') then
                    "Donor Name" := DimVal.Name;
            end;
        }
        field(2; "Donor Name"; Text[100]) { }
        field(3; Address; Text[250]) { }
        field(4; "Telephone No."; Text[30]) { }
        field(5; Email; Text[30]) { }
        field(6; "Contact Person"; Text[30]) { }
        field(7; "Donor No."; Code[10])
        {
            TableRelation = Customer."Customer Posting Group" where("Customer Posting Group" = filter('FUND'));
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        DimVal: Record "Dimension Value";
}

