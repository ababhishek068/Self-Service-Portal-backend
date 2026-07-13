Table 50624 "Flt Make"
{
    DrillDownPageID = "Flt Make List";
    LookupPageID = "Flt Make List";

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

