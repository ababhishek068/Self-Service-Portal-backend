Table 50339 "Soft Skills"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal No"; Code[30])
        {
            TableRelation = "HR Appraisal Header - UP"."Appraisal No";
        }
        field(3; "Appraisal Period"; Code[20])
        {
            NotBlank = true;
        }
        field(4; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee";
        }
        field(5; Sections; Option)
        {
            OptionCaption = 'Objectives,Core Responsibilities/Duties,Last year''s goals,Things learnt From Training,Value Added From Training,Attendance&Punctuality,Communication,Cooperation,Internal/External Clients,Initiative,Planning & Organization,Quality,Team Work,Sales Skills,Leadership,Performance Coaching';
            OptionMembers = Objectives,"Core Responsibilities/Duties","Last year's goals","Things learnt From Training","Value Added From Training","Attendance&Punctuality",Communication,Cooperation,"Internal/External Clients",Initiative,"Planning & Organization",Quality,"Team Work","Sales Skills",Leadership,"Performance Coaching";
        }
        field(6; "Soft Skills/ Behavior"; Text[200]) { }
        field(7; "Self Rating"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Self Rating" > maxRating then Error('[%1 %2] should have a Maximum Score of [%3]', FieldCaption("Self Rating"), "Self Rating", maxRating);
            end;
        }
        field(9; "Supervisor Rating"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Supervisor Rating" > maxRating then Error('The score %1 should have a max Score of %2', "Supervisor Rating", maxRating);
            end;
        }
        field(17; "Agreed Rating"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                if "Agreed Rating" > maxRating then Error('[%1 %2] should have a Maximum Score of [%3]', FieldCaption("Self Rating"), "Self Rating", maxRating);

                /*HRAppraisalHeader.RESET;
                HRAppraisalHeader.SETRANGE(HRAppraisalHeader."Appraisal No","Appraisal No");
                IF HRAppraisalHeader.FIND('-') THEN
                BEGIN
                    HRAppraisalHeader.Calculated:=FALSE;
                    HRAppraisalHeader.Overall_Score:=0;
                    HRAppraisalHeader.Percentage_Score:=0;
                    HRAppraisalHeader.Section_2:=0;
                    HRAppraisalHeader.Section_3:=0;
                    HRAppraisalHeader.MODIFY;
                END;
                */

                Achievement := "Agreed Rating" / 2 * 10 / 5;

            end;
        }
        field(18; Weight; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(19; "Overall Employee Comment"; Text[200]) { }
        field(22; "Supervisor Comments"; Text[200]) { }
        field(25; "Approval Status"; Option)
        {
            OptionMembers = "Pending Approval",Approved;
        }
        field(26; "Weight Average"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(27; Remarks; Text[250]) { }
        field(28; "Code"; Code[20]) { }
        field(50003; "Max Appraisal Rating"; Decimal) { }
        field(50004; Achievement; Decimal)
        {

            trigger OnValidate()
            begin
                Achievement := "Agreed Rating" / 2 * 10 / 5;
            end;
        }
    }

    keys
    {
        key(Key1; "Line No", "Appraisal No", "Appraisal Period", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
    //objHRSetup: Record "HR Appraisal Rating Scale";
    //SoftkillsBehavior: Record "Soft Skills/ Behavior";


    procedure maxRating() maxRating: Decimal
    begin
    end;
}

