Table 50469 "HR Recruitment Courses"
{
    LookupPageId = "HR Recruitment Courses";
    DrillDownPageId = "HR Recruitment Courses";
    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Course Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Course Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Course Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Course Code", "Course Description") { }
    }
}

