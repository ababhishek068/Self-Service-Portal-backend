Table 50336 "Target Indicators"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Name; Text[200]) { }
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

