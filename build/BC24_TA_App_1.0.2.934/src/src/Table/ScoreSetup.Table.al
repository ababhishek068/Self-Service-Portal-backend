Table 50616 "Score Setup"
{


    fields
    {
        field(1; "Score ID"; Decimal) { }
        field(2; Score; Text[30]) { }
    }

    keys
    {
        key(Key1; "Score ID")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

