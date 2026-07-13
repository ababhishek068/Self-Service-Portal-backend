Table 50629 "Appraisal Periods"
{
    // DrillDownPageID = UnknownPage39005787;
    // LookupPageID = UnknownPage39005787;

    fields
    {
        field(1; Period; Code[30]) { }
        field(2; Comments; Text[250]) { }
    }

    keys
    {
        key(Key1; Period)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

