Table 50659 "Treatment Buffer"
{

    fields
    {
        field(1; "Treatment No"; Code[20]) { }
        field(2; Category; Code[50]) { }
        field(3; "Code"; Code[50]) { }
        field(4; Description; Text[200]) { }
        field(5; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(6; Remarks; Text[200]) { }
        field(7; "Sort Order"; Integer) { }
    }

    keys
    {
        key(Key1; "Treatment No", "Line No", Category)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

