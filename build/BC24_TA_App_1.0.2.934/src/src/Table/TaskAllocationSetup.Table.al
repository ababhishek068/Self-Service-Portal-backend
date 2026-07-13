Table 50131 "Task Allocation Setup"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[50]) { }
        field(3; Current; Boolean) { }
        field(4; "Date Created"; Date) { }
        field(5; Closed; Boolean) { }
        field(6; "Submission Deadline"; Date) { }
        field(7; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
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

