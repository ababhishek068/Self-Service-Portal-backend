Table 50667 "Food Category"
{

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Description; Text[30]) { }
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

