Table 50110 "Individual Work Plan Target"
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
        field(5; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(6; Objective; Text[500]) { }
        field(7; "Objective Target"; Text[500]) { }
    }

    keys
    {
        key(Key1; Code, "Staff No", "Appraisal Period", "Objective Entry No", "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    trigger OnInsert()
    var
        IndObj: Record "Individual Work Plan Objective";
    begin
        IndObj.Reset();
        IndObj.SetRange(Code, Code);
        IndObj.SetRange("Entry No", "Objective Entry No");
        IndObj.SetRange("Staff No", "Staff No");
        IndObj.SetRange("Appraisal Period", "Appraisal Period");
        if IndObj.Find('-') then begin
            Objective := IndObj.Objective;
        end;
    end;
}

