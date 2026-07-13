Table 50046 "Exemption Codes"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[50]) { }
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

