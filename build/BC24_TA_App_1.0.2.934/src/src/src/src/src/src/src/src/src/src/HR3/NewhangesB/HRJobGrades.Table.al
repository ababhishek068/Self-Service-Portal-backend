Table 50411 "HR Job Grades"
{
    DataCaptionFields = "Code", Descrition;
    DrillDownPageID = "HR Job Grades List";
    LookupPageID = "HR Job Grades List";

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; Descrition; Text[30]) { }

        field(3; "Sorting Oder"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Sorting Oder") { }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Descrition) { }
    }
}

