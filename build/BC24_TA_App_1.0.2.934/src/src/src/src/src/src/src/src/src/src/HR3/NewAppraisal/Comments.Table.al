Table 50340 "Comments"
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
        field(6; "Appraiser Comments"; Text[250]) { }
        field(7; "Appraisee Comments"; Text[250]) { }
        field(8; "Second Appraiser Comments"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Line No", "Appraisal No", "Appraisal Period", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

