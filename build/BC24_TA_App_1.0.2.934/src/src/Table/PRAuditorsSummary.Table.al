Table 50513 "PR Auditors Summary"
{

    fields
    {
        field(1; "Transaction Code"; Code[10]) { }
        field(2; "Transaction Type"; Text[30]) { }
        field(3; Amount; Decimal) { }
    }

    keys
    {
        key(Key1; "Transaction Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

