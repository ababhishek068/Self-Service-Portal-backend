Table 50037 "Course Prerequisite"
{

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
        field(3; Requirement; Text[150])
        {
            NotBlank = true;
        }
        field(4; Mandatory; Boolean) { }
    }

    keys
    {
        key(Key1; Programme, Stage, Requirement)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

