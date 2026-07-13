Table 50433 "Grant Phases"
{
    LookupPageId = "Grant Phases";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[30]) { }
        field(3; "Financial Reporting Date"; Date) { }
        field(4; "Technical Reporting Date"; Date) { }
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

