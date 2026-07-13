Table 50869 "HR Applicant Qualifications"
{
    Caption = 'HR Applicant Qualifications';
    DataCaptionFields = "Employee No.";

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Application No"; code[50])
        {
            // Caption = 'Application No';
            // TableRelation = "HR Job Applications"."Job Application No.";
        }
        field(3; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
        }
        field(4; "Qualification Type"; Code[200])
        {
            // Caption = 'Qualification Description';
            TableRelation = "HR Lookup Values".Code where(Type = filter("Qualification Type"));

            trigger OnValidate()
            begin
                /*
                Qualifications.RESET;
                Qualifications.SETRANGE(Qualifications.Code,"Qualification Description");
                IF Qualifications.FIND('-') THEN
                "Qualification Code":=Qualifications.Description;
                */

            end;
        }
        field(5; "Qualification Category"; Code[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(Type = filter("Qualification category"), Category = field("Qualification Type"));
        }
        field(6; "Qualification Code"; Code[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(Type = filter(Course), Category = field("Qualification Type"), "Sub Category" = field("Qualification Category"));
            trigger OnValidate()
            var
                HRLookup: record "HR Lookup Values";
            begin
                HRLookup.reset;
                HRLookup.setrange(Code, "Qualification Code");
                HRLookup.setrange(Type, HRLookup.type::Course);
                if HRLookup.find('-') then begin
                    "Score ID" := HRLookup.Score;
                    "Qualification Description" := HRLookup.Description;
                end;
            end;
        }
        field(7; "Qualification Description"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Description where(Code = field("Qualification Code"));
        }
        field(8; "Institution/Company"; Text[200])
        {
            Caption = 'Institution/Company';
            DataClassification = ToBeClassified;
        }
        field(9; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(10; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(11; Award; Code[200])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Attachment ID"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Score ID"; Decimal) { }
        field(15; "Email"; text[150]) { }
        field(16; "Desired Score"; Decimal) { }
        field(17; "Account No"; code[20]) { }
        field(18; "Institution No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Attachment Incr ID"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Document Attachment".ID where("Table ID" = filter(52505), "No." = field("Application No")));
        }
        field(20; "Custom Qualification"; Text[200])
        {
            Caption = 'Qualification Specification';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Line No.", "Account No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

