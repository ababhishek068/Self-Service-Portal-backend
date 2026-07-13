Table 50823 "Company Activities"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200]) { }
        field(3; Day; Date) { }
        field(4; Venue; Text[200]) { }
        field(5; Responsibility; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            var
                objEmployees: Record "HR-Employee";
            begin
                objEmployees.Reset;
                objEmployees.SetRange(objEmployees."No.", Rec.Responsibility);
                if objEmployees.Find() then begin
                    Rec."Employee Name" := objEmployees."First Name" + ' ' + objEmployees."Middle Name" + ' ' + objEmployees."Last Name";

                end;
            end;
        }
        field(6; Costs; Decimal) { }
        field(7; "G/L Account No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No.";
        }
        field(8; "Bal. Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Bank';
            OptionMembers = "G/L Account",Bank;

            trigger OnValidate()
            begin
                //{
                //IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN
                //GLAccts.GET(GLAccts."No.")
                //ELSE
                //Banks.GET(Banks."No.");
                //}
            end;
        }
        field(9; "Bal. Account No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "G/L Account"."No.";
        }
        field(10; Post; Boolean) { }
        field(11; Posted; Boolean)
        {
            Editable = true;
        }
        field(12; "Attachment No."; Integer) { }
        field(13; "Language Code (Default)"; Code[10])
        {
            //TableRelation = Language;
        }
        field(14; Attachement; Option)
        {
            OptionMembers = No,Yes;
        }
        field(15; "Employee Name"; Code[150])
        {
            FieldClass = Normal;
        }
        field(16; "First Name"; Text[50])
        {
            CalcFormula = lookup("HR-Employee"."First Name" where("No." = field(Responsibility)));
            FieldClass = FlowField;
        }
        field(17; "Middle Name"; Text[50])
        {
            CalcFormula = lookup("HR-Employee"."Middle Name" where("No." = field(Responsibility)));
            FieldClass = FlowField;
        }
        field(18; "Last Name"; Text[50])
        {
            CalcFormula = lookup("HR-Employee"."Last Name" where("No." = field(Responsibility)));
            FieldClass = FlowField;
        }
        field(19; Attachments; Text[200]) { }
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

