Table 50261 "Committee Workplan Lines"
{

    fields
    {
        field(1; Code; Code[20])
        {
            TableRelation = "Committee Workplan Header".Code;
        }
        field(2; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Indicator; Text[200]) { }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

