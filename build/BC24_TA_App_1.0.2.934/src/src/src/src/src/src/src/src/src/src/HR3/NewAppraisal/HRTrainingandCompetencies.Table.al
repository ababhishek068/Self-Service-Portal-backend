Table 50344 "HR Training and Competencies"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal No"; Code[30])
        {
            TableRelation = "HR Appraisal Header - UP"."Appraisal No";
        }
        field(3; "Appraisal Period"; Code[20])
        {
            NotBlank = true;
        }
        field(4; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
        }
        field(5000; "Training In Past One YR"; Text[250]) { }
        field(5019; "Training & Development Needs"; Text[200]) { }
        field(5020; Remarks; Text[200]) { }
    }

    keys
    {
        key(Key1; "Line No", "Appraisal No", "Appraisal Period", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

