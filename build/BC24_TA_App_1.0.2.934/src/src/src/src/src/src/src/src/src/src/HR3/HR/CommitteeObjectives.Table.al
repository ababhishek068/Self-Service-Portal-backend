Table 50623 "Committee Objectives"
{

    fields
    {
        field(1; Code; Code[20]) { }
        field(2; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Objective; Text[500]) { }
    }

    keys
    {
        key(Key1; Code, "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

