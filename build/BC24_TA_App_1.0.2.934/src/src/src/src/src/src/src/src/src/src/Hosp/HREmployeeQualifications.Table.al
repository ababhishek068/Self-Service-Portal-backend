Table 50847 "HR Employee Qualifications"
{
    Caption = 'Employee Qualification 2';
    DataCaptionFields = "Employee No.";
    DrillDownPageID = "Qualified Employees";
    LookupPageID = "Employee Qualifications";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
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
        field(7; Description; Text[100])
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
        field(14; "Qualification Type"; Code[20])
        {
            NotBlank = false;
            TableRelation = "HR Lookup Values".Code where(Type = filter("Qualification Type"));
        }
        field(15; "Qualification Code"; Code[30])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "HR Qualifications".Code where("Qualification Type" = field("Qualification Type"));

            trigger OnValidate()
            begin
                /*.SETFILTER(Requirments."Qualification Type","Qualification Type");
                Requirments.SETFILTER(Requirments.Code,"Qualification Code");
                IF Requirments.FIND('-') THEN
                 Qualification := Requirments.Description; */


                if HRQualifications.Get("Qualification Type", "Qualification Code") then
                    "Qualification Description" := HRQualifications.Description;

                fnTrackChanges('Change in Qualification', Format(xRec."Qualification Code"), Format("Qualification Code"));

            end;
        }
        field(16; "Qualification Description"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Employee No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if Comment then
            Error(Text000);
    end;

    trigger OnInsert()
    begin
        Employee.Get("Employee No.");
        "Employee Status" := Employee.Status;
    end;

    var
        Text000: label 'You cannot delete employee qualification information if there are comments associated with it.';
        Employee: Record "HR-Employee";
        HRQualifications: Record "HR Qualifications";

    procedure fnTrackChanges(columnss: Code[250]; oldValue: Code[250]; NewValue: Code[250])
    var
        HRtracker: Record "HR Change Entries";
    begin
        HRtracker.Init;
        HRtracker."employee No" := "Employee No.";
        HRtracker."Change Date" := Today;
        HRtracker."Change Description" := columnss;
        HRtracker."Old Value" := oldValue;
        HRtracker."New Value" := NewValue;
        HRtracker.UserID := UserId;
        HRtracker.Insert;
    end;
}

