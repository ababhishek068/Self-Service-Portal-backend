Table 50551 "Online Audit Trail"
{

    fields
    {
        field(1; "User Name"; Code[50])
        {
            TableRelation = "Online Sessions"."User Name";
        }
        field(2; "Session ID"; Text[150])
        {
            TableRelation = "Online Sessions"."Session ID";
        }
        field(3; Transaction; Text[250]) { }
        field(4; "Time of Transaction"; DateTime) { }
        field(5; "IP Address"; Text[30]) { }
    }

    keys
    {
        key(Key1; "Time of Transaction", "User Name", "Session ID")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

