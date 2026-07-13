Table 50384 "Reporting Date"
{

    fields
    {
        field(1; "code"; Code[20]) { }
        field(2; "Financial Reporting Date"; Date) { }
        field(3; "Technical Reporting Date"; Date) { }
    }

    keys
    {
        key(Key1; "code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

