Table 50349 "HR Appraisal Lines - Values-UP"
{
    Caption = 'HR Appraisal Lines - Values and Competences ';
    DrillDownPageID = "HR Appraisal Lines - VC";
    LookupPageID = "HR Appraisal Lines - VC";

    fields
    {
        field(1; "Appraisal No."; Code[10])
        {
            Editable = false;
            TableRelation = "HR Appraisal Header - UP"."Appraisal No";
        }
        field(2; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Staff Values","Core Competence","Managerial and Supervisory Competence";
        }
        field(3; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "HR Appraisal Values and Compt.".Code;

            trigger OnValidate()
            begin
                Clear(Description);

                HRAppraisalValuesandCompt.Reset();
                HRAppraisalValuesandCompt.SetRange(Code, Code);
                if HRAppraisalValuesandCompt.FindFirst() then begin
                    Description := HRAppraisalValuesandCompt.Description;
                    Category := HRAppraisalValuesandCompt.Category
                end;
            end;
        }
        field(4; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Appraisal Assesment"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Score; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                Clear("Score Descriptors");
                if Score <> 0 then begin
                    HRAppraisalRatingScale.Reset();
                    HRAppraisalRatingScale.SetRange(HRAppraisalRatingScale."Rating Scale", HRAppraisalRatingScale."rating scale"::"Values and Competencies");
                    HRAppraisalRatingScale.SetRange(HRAppraisalRatingScale.Score, Score);
                    HRAppraisalRatingScale.FindFirst;
                    "Score Descriptors" := HRAppraisalRatingScale."Rating Descriptors";
                end;
            end;
        }
        field(7; "Score Descriptors"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(9; "Supervisor Score"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                Clear("Score Descriptors");
                if Score <> 0 then begin
                    HRAppraisalRatingScale.Reset();
                    HRAppraisalRatingScale.SetRange(HRAppraisalRatingScale."Rating Scale", HRAppraisalRatingScale."rating scale"::"Values and Competencies");
                    HRAppraisalRatingScale.SetRange(HRAppraisalRatingScale.Score, Score);
                    HRAppraisalRatingScale.FindFirst;
                    "Supervisor Score Descriptors" := HRAppraisalRatingScale."Rating Descriptors";
                end;
            end;
        }
        field(10; "Supervisor Score Descriptors"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Agreed Score"; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                Clear("Score Descriptors");
                if Score <> 0 then begin
                    HRAppraisalRatingScale.Reset();
                    HRAppraisalRatingScale.SetRange(HRAppraisalRatingScale."Rating Scale", HRAppraisalRatingScale."rating scale"::"Values and Competencies");
                    HRAppraisalRatingScale.SetRange(HRAppraisalRatingScale.Score, Score);
                    HRAppraisalRatingScale.FindFirst;
                    "Agreed Score Descriptors" := HRAppraisalRatingScale."Rating Descriptors";
                end;
            end;
        }
        field(12; "Agreed Score Descriptors"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Appraisal No.", "Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HRAppraisalValuesandCompt: Record "HR Appraisal Lines - Values";
        HRAppraisalRatingScale: Record "HR Appraisal Rating Scale - UP";
}

