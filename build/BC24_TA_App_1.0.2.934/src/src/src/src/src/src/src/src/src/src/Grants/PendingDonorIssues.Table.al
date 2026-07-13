Table 50386 "Pending Donor Issues"
{

    fields
    {
        field(1; "code"; Code[10]) { }
        field(2; Description; Text[250]) { }
    }

    keys
    {
        key(Key1; "code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

