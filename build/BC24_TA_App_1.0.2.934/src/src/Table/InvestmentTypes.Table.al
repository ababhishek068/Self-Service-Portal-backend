Table 50546 "Investment Types"
{

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Name; Text[50]) { }
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

