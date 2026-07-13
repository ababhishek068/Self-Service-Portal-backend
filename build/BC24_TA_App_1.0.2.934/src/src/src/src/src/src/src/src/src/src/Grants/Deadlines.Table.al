Table 50401 Deadlines
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Inv. Code"; Code[10]) { }
        field(3; Date; Date) { }
        field(4; Description; Text[100]) { }
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

