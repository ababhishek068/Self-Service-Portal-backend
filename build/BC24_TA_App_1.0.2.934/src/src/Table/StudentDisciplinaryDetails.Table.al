Table 50121 "Student Disciplinary Details"
{
    Caption = 'Employee Relative';

    fields
    {
        field(1; "Student No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Customer."No.";
        }
        field(2; Date; Date)
        {
            NotBlank = true;
        }
        field(3; "Disciplinary Case"; Text[250])
        {
            NotBlank = true;
        }
        field(4; "Disciplinary Action"; Text[100]) { }
        field(5; Remarks; Text[250]) { }
    }

    keys
    {
        key(Key1; "Student No.", Date)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    var
        HRCommentLine: Record "Human Resource Comment Line";
    begin
        HRCommentLine.SetRange("Table Name", HRCommentLine."table name"::"Employee Relative");
        HRCommentLine.SetRange("No.", "Student No.");
        HRCommentLine.DeleteAll;
    end;
}

