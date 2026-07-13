Table 50554 "Disposal Period"
{
    DrillDownPageID = "Disposal Period";
    LookupPageID = "Disposal Period";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "From Date"; Date) { }
        field(3; "To Date"; Date) { }
        field(4; Description; Text[30]) { }
        field(5; "Financial Year"; Code[10])
        {
            TableRelation = "Financial Periods";
        }
        field(6; "Previous Year"; Boolean) { }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

