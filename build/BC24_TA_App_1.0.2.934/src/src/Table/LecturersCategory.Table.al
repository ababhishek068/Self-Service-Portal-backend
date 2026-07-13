Table 50064 "Lecturers Category"
{
    LookupPageId = "Lecturer Category";
    DrillDownPageId = "Lecturer Category";
    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(3; "Max. Fulltime Units"; Integer) { }
        field(4; "Max. Parttime Units"; Integer) { }
        field(5; "Max. Units"; Integer) { }
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

