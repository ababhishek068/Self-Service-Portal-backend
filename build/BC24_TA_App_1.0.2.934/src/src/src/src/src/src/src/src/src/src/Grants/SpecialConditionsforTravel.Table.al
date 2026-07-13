Table 50385 "Special Conditions for Travel"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[250]) { }
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

