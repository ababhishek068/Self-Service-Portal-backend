Table 50337 "Appraisal Strategic Obj. - UP"
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
        field(6; "Strategic Objectives"; Code[30])
        {
            TableRelation = "HR Appraisal Dept. Obj. Setup"."Objective Code";

            trigger OnValidate()
            begin
                HRAppraisalDeptObjectives.Reset;
                HRAppraisalDeptObjectives.SetRange(HRAppraisalDeptObjectives."Objective Code", "Strategic Objectives");
                if HRAppraisalDeptObjectives.Find('-') then
                    "Objective Description" := HRAppraisalDeptObjectives."Objective Description";
            end;
        }
        field(7; "Self Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                // IF "Self Rating" >maxRating THEN  ERROR('[%1 %2] should have a Maximum Score of [%3]',FIELDCAPTION("Self Rating"),"Self Rating",maxRating);
            end;
        }
        field(8; "Peer Rating"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF "Peer Rating">maxRating THEN  ERROR('The score %1 should have a max Score of %2',"Peer Rating",maxRating);
            end;
        }
        field(9; "Supervisor Rating"; Decimal)
        {

            trigger OnValidate()
            begin
                // IF "Supervisor Rating">maxRating THEN  ERROR('The score %1 should have a max Score of %2',"Supervisor Rating",maxRating);
            end;
        }
        field(10; "Sub-ordinates Rating"; Decimal)
        {

            trigger OnValidate()
            begin
                //   IF "Sub-ordinates Rating">maxRating THEN  ERROR('The score %1 should have a max Score of %2',"Sub-ordinates Rating",maxRating);
            end;
        }
        field(11; "Outside Agencies Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                //IF "Outside Agencies Rating">maxRating THEN  ERROR('The score %1 should have a max Score of %2',"Outside Agencies Rating",maxRating);
            end;
        }
        field(17; "Agreed Rating"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                /* IF "Agreed Rating">maxRating THEN  ERROR('The score %1 should have a max Score of %2',"Agreed Rating",maxRating);
                HRAppraisalHeader.RESET;
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

            end;
        }
        field(18; "Agreed Rating x Weighting"; Decimal) { }
        field(19; "Overall Employee Comment"; Text[200]) { }
        field(21; "Peer Comments"; Text[200]) { }
        field(22; "Supervisor Comments"; Text[200]) { }
        field(23; "Subordinates Comments"; Text[200]) { }
        field(25; "Approval Status"; Option)
        {
            OptionMembers = "Pending Approval",Approved;
        }
        field(26; "Categorize As"; Option)
        {
            OptionCaption = ' ,Employee''s Subordinates,Employee''s Peers,External Sources,Job Specific,Self Evaluation,Personal Goals/Objectives';
            OptionMembers = " ","Employee's Subordinates","Employee's Peers","External Sources","Job Specific","Self Evaluation","Personal Goals/Objectives";
        }
        field(27; "Sub Category"; Option)
        {
            OptionCaption = ' ,Objectives,Core Responsibilities / Duties,Attendance & Punctuality,Communication,Cooperation,Planning & Organization,Quality,Team Work,Sales Skills,Leadership,Performance Coaching,Personal Goals';
            OptionMembers = " ",Objectives,"Core Responsibilities / Duties","Attendance & Punctuality",Communication,Cooperation,"Planning & Organization",Quality,"Team Work","Sales Skills",Leadership,"Performance Coaching","Personal Goals";
        }
        field(28; "External Source Rating"; Decimal) { }
        field(29; "External Source Comments"; Text[250]) { }
        field(30; "Min. Target Score"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF "Min. Target Score" >maxRating THEN  ERROR('The score %1 should have a max Score of %2',"Min. Target Score",maxRating);
            end;
        }
        field(31; "Max Target Score"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF "Max Target Score" >maxRating THEN  ERROR('The score %1 should have a max Score of %2',"Max Target Score",maxRating);
            end;
        }
        field(32; "Target Quarter"; Integer) { }
        field(33; "Approved Appraisal No"; Code[20]) { }
        field(34; "Objective Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Perspective Code"; Code[100])
        {
            DataClassification = ToBeClassified;
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
        AppHeader: Record "HR Appraisal Header - UP";
        HRAppraisalDeptObjectives: Record "HR Appraisal Dept. Obj. Setup";
}

