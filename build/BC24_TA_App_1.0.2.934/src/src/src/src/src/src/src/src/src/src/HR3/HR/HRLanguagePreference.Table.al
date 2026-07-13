Table 50617 "HR Language Preference"
{
    // DrillDownPageID = UnknownPage39005608;
    // LookupPageID = UnknownPage39005608;

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; "Language Preference"; Text[30]) { }
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

