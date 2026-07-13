Table 50547 "Investment Posting Setup"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Investment Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(3; "Interest Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Accrual Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Withholding Tax Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
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

