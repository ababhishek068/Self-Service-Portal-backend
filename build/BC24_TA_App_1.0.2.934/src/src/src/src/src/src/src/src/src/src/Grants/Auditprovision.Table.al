Table 50420 "Audit provision"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[250]) { }
        field(3; date; Date) { }
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

