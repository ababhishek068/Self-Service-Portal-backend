Table 50107 "Individual Work Plan Objective"
{

    fields
    {
        field(1; Code; Code[20])
        {
            NotBlank = true;
            TableRelation = "Individual Work Plan".Code;
        }
        field(2; "Staff No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
        }
        field(3; "Appraisal Period"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Appraisal Periods - UP".Code;
        }
        field(4; Objective; Text[500]) { }
        field(5; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(6; "Department Code"; Code[20]){}
        field(7;"Departmental Objective Code";code[20]){}
    }

    keys
    {
        key(Key1; Code, "Staff No", "Appraisal Period", "Entry No","Departmental Objective Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

