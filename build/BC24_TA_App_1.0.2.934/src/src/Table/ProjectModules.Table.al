Table 50256 "Project Modules"
{
    DrillDownPageID = Modules;
    LookupPageID = Modules;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
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

