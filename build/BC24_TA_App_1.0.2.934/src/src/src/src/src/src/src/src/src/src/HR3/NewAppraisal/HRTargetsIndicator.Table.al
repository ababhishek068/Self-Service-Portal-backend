Table 50343 "HR Targets Indicator"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            //TableRelation = "HR Appraisal Values and Compt.".Description where(Code = filter('1'));

            trigger OnValidate()
            begin
                Target.Reset;
                Target.SetRange(Target.Description, Code);
                if Target.Find('-') then
                    Description := Target.Description
            end;
        }
        field(2; Description; Text[30])
        {
            Editable = false;
        }
        field(3; Score; Decimal)
        {

            trigger OnValidate()
            begin

                HRAppraisalRating.Reset;
                HRAppraisalRating.SetRange(HRAppraisalRating.Score, Score);
                if HRAppraisalRating.Find('-') then begin
                    Error('You cannot have two appraisal ratings with the same score');
                end;
            end;
        }
        field(4; Recommendations; Text[200]) { }
        field(5; "Description 2"; Text[250]) { }
        field(6; "Performance Areas"; Text[250]) { }
        field(7; "Target Description"; Text[250]) { }
        field(8; "Unit of Measure"; Text[250])
        {
            //TableRelation = "Target Indicators".Code;
        }
        field(9; "Target Levels"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                Achievement := "Agreed Rating" / "Target Levels" * 90;
            end;
        }
        field(10; Weights; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                "Weighted Average" := Achievement / 100 * Weights;
            end;
        }
        field(11; "Performance Indicators/Proof"; Text[250]) { }
        field(50000; "Appraisal No"; Code[30])
        {
            TableRelation = "HR Appraisal Header - UP";
        }
        field(50001; "Appraisal Period"; Code[20])
        {
            NotBlank = true;
        }
        field(50002; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee";
        }
        field(50003; Sections; Option)
        {
            OptionCaption = 'Objectives,Core Responsibilities/Duties,Last year''s goals,Things learnt From Training,Value Added From Training,Attendance&Punctuality,Communication,Cooperation,Internal/External Clients,Initiative,Planning & Organization,Quality,Team Work,Sales Skills,Leadership,Performance Coaching';
            OptionMembers = Objectives,"Core Responsibilities/Duties","Last year's goals","Things learnt From Training","Value Added From Training","Attendance&Punctuality",Communication,Cooperation,"Internal/External Clients",Initiative,"Planning & Organization",Quality,"Team Work","Sales Skills",Leadership,"Performance Coaching";
        }
        field(50004; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(50005; Remarks; Text[250]) { }
        field(50006; "Targets Varied Mid Term"; Boolean) { }
        field(50007; "First Derivery Quarter"; Code[20])
        {
            //TableRelation = Table50392;
        }
        field(50008; Name; Text[50]) { }
        field(50009; "Reviewed Target Level"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(50010; "Reviewed Weight"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(50011; "Self Rating"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(50012; "Appraiser Rating"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(50013; "Agreed Rating"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                Achievement := "Agreed Rating" / "Target Levels" * 90;
                Validate("Weighted Average");
            end;
        }
        field(50014; Achievement; Decimal)
        {

            trigger OnValidate()
            begin
                Achievement := "Agreed Rating" / "Target Levels" * 90;

                "Weighted Average" := Achievement / 100 * Weights;
            end;
        }
        field(50015; "Weighted Average"; Decimal)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                "Weighted Average" := Achievement / 100 * Weights;
            end;
        }
        field(50016; "Last Derivery Quarter"; Code[20])
        {
            //TableRelation = Table50392;
        }
    }

    keys
    {
        key(Key1; "Line No", "Appraisal No", "Appraisal Period", "Employee No")
        {
            Clustered = true;
        }
        key(Key2; Sections) { }
    }

    fieldgroups { }

    trigger OnModify()
    begin
        AppHeader.Reset;
        AppHeader.SetRange(AppHeader."Appraisal No", "Appraisal No");
        if AppHeader.FindFirst then begin
            if (AppHeader.Locked = true) then
                Error('You Cannot modify Appraisal documents that has been locked');
        end;
    end;

    var
        HRAppraisalRating: Record "HR Targets Indicator";
        Target: Record "HR Appraisal Lines - Values-UP";
        AppHeader: Record "HR Appraisal Header - UP";
}

