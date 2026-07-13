Table 50557 "Disposal Methods"
{
    DrillDownPageID = "Disposal Methods List";
    LookupPageID = "Disposal Methods List";

    fields
    {
        field(1; "Disposal Methods"; Code[20]) { }
        field(2; "Disposal Description"; Text[30]) { }
        field(3; Date; Date) { }
    }

    keys
    {
        key(Key1; "Disposal Methods", "Disposal Description")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

