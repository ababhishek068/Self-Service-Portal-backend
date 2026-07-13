Table 50805 "HR Employee Attachments"
{

    fields
    {
        field(1; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
        }
        field(2; "Document Description"; Text[200])
        {
            NotBlank = true;
        }
        field(3; "Document Link"; Text[200]) { }
        field(6; "Attachment No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(7; "Language Code (Default)"; Code[10])
        {
            //TableRelation = Language;
        }
        field(8; Attachment; Option)
        {
            Editable = false;
            OptionMembers = No,Yes;
        }
    }

    keys
    {
        key(Key1; "Employee No", "Document Description")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    procedure PlaceFilter(prompt: Boolean; EmployeeNo: Code[10]): Boolean
    begin
        if prompt then begin
            SetFilter("Employee No", EmployeeNo);
        end;
    end;
}

