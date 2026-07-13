Table 50749 "Student Requisition Lines"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Application No"; Code[20]) { }
        field(3; "Unit Code"; Code[20]) { }
        field(4; "Unit Title"; Text[50]) { }
        field(5; Reason; Text[50]) { }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

