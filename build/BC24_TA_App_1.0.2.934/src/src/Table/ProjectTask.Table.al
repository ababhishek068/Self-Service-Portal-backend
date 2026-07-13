Table 50258 "Project Task"
{

    fields
    {
        field(2; "Project No"; Code[20]) { }
        field(5; "Activity Code"; Code[20])
        {
            TableRelation = "Project Activity".Code;
        }
        field(6; "Start Date"; Date) { }
        field(7; "End Date"; Date) { }
        field(8; Status; Option)
        {
            OptionCaption = ' ,On-going,Suspended,Closed,Pending';
            OptionMembers = " ","On-going",Suspended,Closed,Pending;
        }
        field(9; Remarks; Text[100]) { }
        field(10; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Project No", "Activity Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

