Table 50645 "FLT-Flt Model"
{
    DrillDownPageID = "Flt Model List";
    LookupPageID = "Flt Model List";

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Description; Text[30]) { }
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

