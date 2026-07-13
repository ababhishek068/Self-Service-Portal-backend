Table 50417 "Budget Grouping Codes"
{

    fields
    {
        field(1; "Code"; Code[30]) { }
        field(2; Description; Text[30]) { }
        field(3; "Budget Amount"; Decimal) { }
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

