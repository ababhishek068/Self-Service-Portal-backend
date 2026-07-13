Table 50787 "HR Appraisal Card1"
{

    fields
    {
        field(1; "Appraisal Code"; Code[50]) { }
        field(2; "Staff No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(3; "Appraisal Type"; Code[10])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("Appraisal Type"));
        }
        field(4; "Appraisal Period"; Code[10])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("Appraisal Period"));
        }
        field(5; "Supervisor Comment"; Text[250]) { }
        field(6; "Appraisee Comment"; Text[250]) { }
        field(7; Recomendations; Text[250]) { }
        field(8; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Approved,Cancelled;
        }
        field(9; Supervisor; Code[10])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(10; "Explored By Appraisee"; Boolean) { }
        field(11; "Explored By Supervisor"; Boolean) { }
        field(12; "User ID"; Code[100])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(13; "Resp Center"; Code[30])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(14; "Staff Name"; Text[150]) { }
        field(15; Department; Code[30])
        {
            TableRelation = "Dimension Value".Code;
        }
        field(16; "No Series"; Code[30]) { }
        field(17; "No of Staff Supervised"; Code[30]) { }
        field(18; "Appraiser No"; Code[30]) { }
        field(19; "Appraiser User ID"; Code[100]) { }
        field(20; "Appraiser Names"; Text[200]) { }
        field(21; "Duration Supervised"; Text[30]) { }
        field(22; "Total Weighted Score"; Decimal)
        {
            CalcFormula = sum("HR Appraisal Objectives".Ratings where("Document No" = field("Appraisal Code"),
                                                                       "Appraisal Period" = field("Appraisal Period"),
                                                                       Section = const("End Year")));
            FieldClass = FlowField;
        }
        field(23; "Total Competency Score"; Decimal)
        {
            CalcFormula = sum("HR Appraisal skills comp Score".Score where("Appraisal No" = field("Appraisal Code"),
                                                                            "Appraisal Period" = field("Appraisal Period")));
            FieldClass = FlowField;
        }
        field(24; "Appraisal Stage"; Option)
        {
            OptionCaption = 'Q1,Q2,Q3,Q4';
            OptionMembers = Q1,Q2,Q3,Q4;
        }
        field(25; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(26; "Target-Setting"; Boolean) { }
        field(27; "Mid-Year"; Boolean) { }
        field(28; "End-Year"; Boolean) { }
        field(29; "Total Weight"; Decimal)
        {
            CalcFormula = sum("HR Appraisal Objectives"."Max Weight" where("Document No" = field("Appraisal Code"),
                                                                            Section = const("Strategic Objectives"),
                                                                            "Appraisal Period" = field("Appraisal Period")));
            FieldClass = FlowField;
        }
        field(30; "Quarter Two"; Boolean) { }
        field(31; "Appraisee Total Score"; Decimal)
        {
            CalcFormula = sum("HR Appraisal Objectives".Ratings where("Document No" = field("Appraisal Code"),
                                                                       "Appraisal Period" = field("Appraisal Period"),
                                                                       Section = const("End Year")));
            FieldClass = FlowField;
        }
        field(32; "Supervisor Total Score"; Decimal)
        {
            CalcFormula = sum("HR Appraisal Objectives"."Supervisor Rating" where("Document No" = field("Appraisal Code"),
                                                                                   "Appraisal Period" = field("Appraisal Period"),
                                                                                   Section = const("End Year")));
            FieldClass = FlowField;
        }
        field(33; "Supervisor Score Part B"; Decimal)
        {
            CalcFormula = sum("HR Appraisal skills comp Score".Score where("Appraisal No" = field("Appraisal Code"),
                                                                            "Appraisal Period" = field("Appraisal Period")));
            FieldClass = FlowField;
        }
        field(34; Branch; Code[20]) { }
        field(35; "Supervisor Q1 Comment"; Text[250]) { }
        field(36; "Supervisor Q2 Comment"; Text[250]) { }
        field(37; "Supervisor Q3 Comment"; Text[250]) { }
        field(38; "Supervisor Q4 Comment"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Appraisal Code", "Appraisal Period")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

