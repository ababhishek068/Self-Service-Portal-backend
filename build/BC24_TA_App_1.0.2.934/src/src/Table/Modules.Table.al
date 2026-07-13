Table 50364 Modules
{

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Description; Text[100]) { }
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

