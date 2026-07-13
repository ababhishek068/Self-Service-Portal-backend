Table 50288 "Academics Central Setups"
{
    DrillDownPageID = "Academic Central Setup";
    LookupPageID = "Academic Central Setup";

    fields
    {
        field(1; "Title Code"; Code[10]) { }
        field(2; Description; Text[30]) { }
        field(3; Category; Option)
        {
            OptionCaption = ' ,Titles,Religions,Denominations,Relationships,Counties,Countries,Nationality,Districts,Positions,Constituencies,Ethnicity,Disability';
            OptionMembers = " ",Titles,Religions,Denominations,Relationships,Counties,Countries,Nationality,Districts,Positions,Constituencies,Ethnicity,Disability;
        }
        field(4; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Semesters.Code;
        }
        field(5; "Intake Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Intake.Code;
        }
        field(6; "Program Category"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,PHD,Professional,Course List';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,PHD,Professional,"Course List";
        }

    }

    keys
    {
        key(Key1; Category, "Title Code", Description)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

