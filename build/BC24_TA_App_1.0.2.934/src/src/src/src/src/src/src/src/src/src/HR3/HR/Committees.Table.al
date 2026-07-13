Table 50628 Committees
{
    // LookupPageID = UnknownPage39005784;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200])
        {
            NotBlank = true;
        }
        field(3; Comments; Text[200]) { }
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

