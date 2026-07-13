table 50266 "Training Attendance Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(3; "Serial No"; code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RegForm: Record "Registration Form";
            begin
                if RegForm.get("Serial No") then
                    Names := RegForm."Full Names";
            end;

        }
        field(4; Names; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Grade Attained"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Certificate No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(7; Remarks; text[200])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; No, "Line No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}