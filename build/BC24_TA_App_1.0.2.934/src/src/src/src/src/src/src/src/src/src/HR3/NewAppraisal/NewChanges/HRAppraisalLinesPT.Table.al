Table 50346 "HR Appraisal Lines - PT"
{
    Caption = 'HR Appraisal Lines - Performance Targets';
    DrillDownPageID = "HR Appraisal Lines - PT";
    LookupPageID = "HR Appraisal Lines - PT";

    fields
    {
        field(1; "Appraisal No."; Code[10])
        {
            Editable = false;
            TableRelation = "HR Appraisal Header - UP"."Appraisal No";
        }
        field(2; "Agreed Performance Targets"; Text[150])
        {
            Description = 'to be completed by the appraisee as agreed with the supervisor at the beginning of the appraisal period)';
        }
        field(3; "Appraisee Comments"; Text[200])
        {
            Caption = 'Appraisee Comments(Target Settings)';
            trigger OnValidate()
            begin

                Validate("Key Performance Indicator");
            end;
        }
        field(4; "Key Performance Indicator"; Text[100])
        {
            Description = 'To be completed by the Appraisee in consultation with the supervisor at the beginning at the beginning of the appraisal period';
        }
        field(6; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(7; "Supervisor Comments"; Text[200])
        {

            trigger OnValidate()
            begin

                Validate("Key Performance Indicator");
            end;
        }
        field(8; "Key Result Areas (Output)"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Self Assesment"; Integer)
        {
            BlankZero = true;
            Caption = 'Self-Assessment (Results Achieved)';
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 1;

            trigger OnValidate()
            begin

                Clear("Self-Score");

                if "Self Assesment" <> 0 then begin
                    "Self-Score" := fn_AppraisalRatingScale("Self Assesment");
                end;
            end;
        }
        field(10; "Self-Score"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use Rating Scale';
            Editable = false;
        }
        field(11; "Supervisor-Assesment"; Integer)
        {
            BlankZero = true;
            Caption = 'Supervisor''s Assessment (Results Achieved)';
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 1;

            trigger OnValidate()
            begin
                Clear("Supervisors Score");

                if "Supervisor-Assesment" <> 0 then begin
                    "Supervisors Score" := fn_AppraisalRatingScale("Supervisor-Assesment");
                end;
            end;
        }
        field(12; "Supervisors Score"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use Rating Scale';
            Editable = false;
        }
        field(13; "Agreed-Assesment Results"; Integer)
        {
            BlankZero = true;
            Caption = 'Agreed Assessment (Results Achieved)';
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 1;

            trigger OnValidate()
            begin
                Clear("Agreed Score");

                if "Agreed-Assesment Results" <> 0 then begin
                    "Agreed Score" := fn_AppraisalRatingScale("Agreed-Assesment Results");
                end;
            end;
        }
        field(14; "Agreed Score"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use Rating Scale';
            Editable = false;
        }

        field(15; Weight; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Unit; Text[50])
        {
            DataClassification = ToBeClassified;
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

    local procedure fn_AppraisalRatingScale(PARAM_Score: Integer): Text
    var
        HRAppraisalRatingScale: Record "HR Appraisal Rating Scale - UP";
    begin

        HRAppraisalRatingScale.Reset();
        HRAppraisalRatingScale.SetRange(HRAppraisalRatingScale."Rating Scale", HRAppraisalRatingScale."rating scale"::"Performance Targets");
        HRAppraisalRatingScale.SetRange(HRAppraisalRatingScale.Score, PARAM_Score);
        HRAppraisalRatingScale.FindFirst;
        exit(HRAppraisalRatingScale."Rating Descriptors");
    end;
}

