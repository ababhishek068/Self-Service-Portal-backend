Table 50111 "Individual Target Activities"
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
        field(4; "Objective Entry No"; Integer)
        {
            TableRelation = "Individual Work Plan Objective"."Entry No" where(Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period"));
        }
        field(5; "Target Entry No"; Integer)
        {
            TableRelation = "Individual Work Plan Target"."Entry No" where(Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period"), "Objective Entry No" = field("Objective Entry No"));
        }
        field(6; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(7; Objective; Text[500]) { }
        field(8; Target; Text[500]) { }
        field(9; Activity; Text[500]) { }
        field(10; "Resources Required"; Text[500]) { }
        field(11; "Expected Results"; Text[500]) { }
        field(12; "Time Frame"; Option)
        {
            OptionMembers = " ",Q1,Q2,Q3,Q4,Continous;
        }
        field(13; "Performance Indicator"; Text[500]) { }
    }

    keys
    {
        key(Key1; Code, "Staff No", "Objective Entry No", "Target Entry No", "Appraisal Period", "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    trigger OnInsert()
    var
        IndObj: Record "Individual Work Plan Objective";
        Indtarget: Record "Individual Work Plan Target";
    begin
        IndObj.Reset();
        IndObj.SetRange(Code, Code);
        IndObj.SetRange("Entry No", "Objective Entry No");
        IndObj.SetRange("Staff No", "Staff No");
        IndObj.SetRange("Appraisal Period", "Appraisal Period");
        if IndObj.Find('-') then begin
            Objective := IndObj.Objective;

            Indtarget.Reset();
            Indtarget.SetRange(Code, Code);
            Indtarget.SetRange("Staff No", "Staff No");
            Indtarget.SetRange("Appraisal Period", "Appraisal Period");
            Indtarget.SetRange("Entry No", "Objective Entry No");
            Indtarget.SetRange("Entry No", "Target Entry No");
            if Indtarget.Find('-') then begin
                Target := Indtarget."Objective Target";
            end;
        end;
    end;
}

