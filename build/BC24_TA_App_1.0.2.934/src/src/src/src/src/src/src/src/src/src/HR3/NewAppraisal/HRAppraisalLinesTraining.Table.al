Table 50348 "HR Appraisal Lines - Training"
{
    Caption = 'HR Appraisal Lines - Staff Training and Development Plan';
    DrillDownPageID = "HR Appraisal Lines - TD";
    LookupPageID = "HR Appraisal Lines - TD";

    fields
    {
        field(1; "Appraisal No."; Code[10])
        {
            Editable = false;
            TableRelation = "HR Appraisal Header - UP"."Appraisal No";
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(3; "Name of the Course"; Text[100]) { }
        field(4; "Duration of Course"; DateFormula)
        {

            trigger OnValidate()
            begin
                if "Expected Start Date" <> 0D then "Expected End Date" := CalcDate("Duration of Course", "Expected Start Date");
            end;
        }
        field(5; Reaction; Text[100])
        {
            Caption = 'Reaction on the Training Attended';
            DataClassification = ToBeClassified;
            Description = 'Reaction on the Training Attended';
        }
        field(6; "Learning Obtained"; Text[100])
        {
            Caption = 'Learning Obtained from the Training';
            DataClassification = ToBeClassified;

        }
        field(7; "Behavior Changes Adopted"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Results Obtained"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Remarks Appraisee"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Remarks Supervisor"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Expected Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Duration of Course");
                Validate("Duration of Course");
            end;
        }
        field(12; "Expected End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Appraisal No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

