Table 50454 "Ampath Data Source Forms"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Inv. code"; Code[10]) { }
        field(3; "Ampath Source Form"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Line No.", "Inv. code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

