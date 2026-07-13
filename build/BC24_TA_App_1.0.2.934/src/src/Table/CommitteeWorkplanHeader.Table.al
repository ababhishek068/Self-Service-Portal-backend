Table 50260 "Committee Workplan Header"
{

    fields
    {
        field(1; Code; Code[20])
        {
            TableRelation = Committees.Code;
        }
        field(2; "Committee No"; Code[20])
        {
            TableRelation = Committees.Code;
        }
        field(3; "Committee Name"; Text[50]) { }
        field(4; "Date Raised"; Date) { }
        field(5; "Created By"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
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

