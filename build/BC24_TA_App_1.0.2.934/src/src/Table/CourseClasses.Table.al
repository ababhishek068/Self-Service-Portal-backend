Table 50039 "Course Classes"
{
    DrillDownPageID = "Course Classes";
    LookupPageID = "Course Classes";

    fields
    {
        field(1; Programme; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(2; Stage; Code[20])
        {
            NotBlank = true;
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
        field(3; "Code"; Code[20]) { }
        field(4; Description; Text[150])
        {
            NotBlank = true;
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

