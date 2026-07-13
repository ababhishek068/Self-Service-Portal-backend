Table 50529 "HR Leave Calendar Lines"
{
    DrillDownPageID = "HR Leave Calendar Lines";
    LookupPageID = "HR Leave Calendar Lines";

    fields
    {
        field(1; "Code"; Code[10])
        {
            TableRelation = "HR Leave Calendar".Code;
        }
        field(2; Day; Text[40])
        {
            Editable = false;
        }
        field(3; Date; Date) { }
        field(4; "Non Working"; Boolean) { }
        field(5; Reason; Text[40]) { }
    }

    keys
    {
        key(Key1; Date, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

