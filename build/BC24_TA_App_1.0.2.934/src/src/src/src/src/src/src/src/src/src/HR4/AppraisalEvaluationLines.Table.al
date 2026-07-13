Table 50117 "Appraisal Evaluation Lines"
{

    fields
    {
        field(1; "Appraisal Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Appraisal Header - UP"."Appraisal No";
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
        field(4; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(5; Objective; Text[500]) { }
        field(6; Target; Text[500]) { }
        field(7; Activity; Text[500]) { }
        field(8; "Resources Required"; Text[500]) { }
        field(9; "Expected Results"; Text[500]) { }
        field(10; "Time Frame"; Option)
        {
            OptionMembers = " ",Q1,Q2,Q3,Q4,Continous;
        }
        field(11; "Performance Indicator"; Text[500]) { }
        field(12; "Appraisee Score"; Decimal) { }
        field(13; "Supervisor Score"; Decimal) { }
        field(14; "Agreed Score"; Decimal) { }
    }

    keys
    {
        key(Key1; "Appraisal Code", "Appraisal Period", "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    trigger OnInsert()
    begin
    end;
}

