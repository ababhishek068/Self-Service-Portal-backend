Table 50112 "Exam Periods"
{
    LookupPageID = "Exam Period";

    fields
    {
        field(1; "Code"; Code[50]) { }
        field(2; "Exam Period"; Text[150]) { }
        field(3; "Graduation Date"; Date) { }
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

