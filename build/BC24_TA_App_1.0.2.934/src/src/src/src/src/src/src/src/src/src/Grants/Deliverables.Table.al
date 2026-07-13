Table 50446 Deliverables
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Inv. Code"; Code[10]) { }
        field(3; Description; Text[250]) { }
    }

    keys
    {
        key(Key1; "Line No", "Inv. Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

