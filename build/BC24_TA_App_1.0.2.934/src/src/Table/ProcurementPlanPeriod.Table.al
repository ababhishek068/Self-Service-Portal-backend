Table 50651 "Procurement Plan Period"
{
    DrillDownPageID = "Procurement Plan Period";
    LookupPageID = "Procurement Plan Period";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Period Name"; Text[30]) { }
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

