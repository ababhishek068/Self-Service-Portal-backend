Table 50681 "HR Employee Kin"
{
    Caption = 'Employee Relative';

    fields
    {
        field(1; "Employee Code"; Code[20])
        {

            TableRelation = "HR-Employee"."No.";
        }
        field(2; Relationship; Option)
        {

            OptionMembers = "","Spouse","Child",Other;
        }

        field(22; Relationship2; Option)
        {

            Caption = 'Relationship';
            OptionMembers = "","Child","Spouse","Parent/Guardian","Sibling",Other;
        }

        field(23; Other; Text[50]) { }
        field(3; SurName; Text[50]) { }
        field(4; "Other Names"; Text[100]) { }
        field(5; "Card No"; Code[50])
        {
            trigger OnValidate()
            begin
                if "Identification Type" = "Identification Type"::" " then Error('Select Identification Type');
            end;
        }
        field(6; "Date Of Birth"; Date) { }
        field(7; Occupation; Text[100]) { }
        field(8; Address; Text[250]) { }
        field(9; "Office Tel No"; Text[100]) { }
        field(10; "Home Tel No"; Text[50]) { }
        field(11; Remarks; Text[250]) { }
        field(12; Type; Option)
        {
            OptionMembers = "","Next of Kin","Beneficiary","Dependant",Other;
        }
        field(13; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(14; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const("Employee Relative"),
                                                                     "No." = field("Employee Code"),
                                                                     "Table Line No." = field("Line No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Code"; Code[10]) { }
        field(16; "Percentage(%)"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Percentage(%)" > 100 then
                    Error('The total Percentage for all Beneficiaries should not be more than 100%');
            end;
        }
        field(17; "No."; Code[10]) { }
        field(18; "Member ID"; Text[50]) { }
        field(19; Category; Text[30]) { }
        field(20; Gender; Option)
        {

            OptionMembers = " ","Male","Female";
        }
        field(21; Status; Option)
        {
            OptionMembers = " ",Active,Inactive;
            Editable = false;
        }
        field(25; "Identification Type"; Option)
        {
            OptionMembers = " ","Passport No.","ID Number","Birth Cert. No.";
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Member ID", "Type", "Line No.")
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
        HRCommentLine.SetRange("No.", "Employee Code");
        HRCommentLine.DeleteAll;
    end;
}

