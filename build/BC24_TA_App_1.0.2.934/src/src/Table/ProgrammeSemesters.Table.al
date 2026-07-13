Table 50067 "Programme Semesters"
{
    DrillDownPageID = "Programme Semesters";
    LookupPageID = "Programme Semesters";

    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(2; Semester; Code[20])
        {
            NotBlank = true;
            TableRelation = Semesters.Code;
        }
        field(3; Remarks; Text[150]) { }
        field(4; Budget; Integer) { }
        field(5; Current; Boolean) { }
        field(6; "Intake Semester"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Programme Code", Semester)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

