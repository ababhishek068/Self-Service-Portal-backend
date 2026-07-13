Table 50362 "CRM Contract Types"
{

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Code"; Code[30]) { }
        field(3; Description; Text[250]) { }
    }

    keys
    {
        key(Key1; No, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

