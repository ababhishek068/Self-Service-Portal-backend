Table 50677 Hobbies
{

    fields
    {
        field(1; "Account No"; Code[20])
        {
            //TableRelation = hr job;
        }
        field(2; Hobbies; Text[200]) { }
        field(3; "Line No"; integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Line No", "Account No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

