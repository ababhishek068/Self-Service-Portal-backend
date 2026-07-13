Table 50649 "Quote Specification"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[60]) { }
        field(3; "Value/Weight"; Decimal) { }
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

