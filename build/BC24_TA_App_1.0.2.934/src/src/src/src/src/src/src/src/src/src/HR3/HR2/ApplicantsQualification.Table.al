Table 50154 "Applicants Qualification"
{
    Caption = 'Applicants Qualification';
    DataCaptionFields = "Employee No.";
    // DrillDownPageID = UnknownPage39005860;
    // LookupPageID = UnknownPage39005860;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            // TableRelation = Applicants."Application No";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Qualification Code"; Code[20])
        {
            Caption = 'Qualification Code';
            NotBlank = true;
            TableRelation = "HR Qualifications".Code;


            trigger OnValidate()
            begin
                Qualifications.Reset;
                Qualifications.SetRange(Qualifications.Code, "Qualification Code");
                if Qualifications.Find('-') then
                    Qualification := Qualifications.Description;
            end;
        }
        field(4; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(6; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Internal,External,Previous Position';
            OptionMembers = " ",Internal,External,"Previous Position";
        }
        field(7; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(8; "Institution/Company"; Text[30])
        {
            Caption = 'Institution/Company';
        }
        field(9; Cost; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost';
        }
        field(10; "Course Grade"; Text[30])
        {
            Caption = 'Course Grade';
        }
        field(11; "Employee Status"; Option)
        {
            Caption = 'Employee Status';
            Editable = false;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(12; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const("Employee Qualification"),
                                                                     "No." = field("Employee No."),
                                                                     "Table Line No." = field("Line No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(50000; "Qualification Type"; Option)
        {
            NotBlank = false;
            OptionMembers = " ",Academic,Professional,Technical,Experience,"Personal Attributes";
        }
        field(50001; Qualification; Text[200])
        {
            NotBlank = true;
        }
        field(50003; "Score ID"; Decimal)
        {
            TableRelation = "Score Setup"."Score ID";
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Qualification Type", "Qualification Code")
        {
            Clustered = true;
            SumIndexFields = "Score ID";
        }
        key(Key2; "Qualification Code") { }
    }

    fieldgroups { }

    var
        Qualifications: Record Qualification;
}

