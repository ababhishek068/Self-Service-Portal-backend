table 50228 "Supplier Portal Central Setups"
{

    DrillDownPageId = "Central Setup List";
    LookupPageId = "Central Setup List";
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Nationalities,Countries,Counties,Languages,Cities,Attachments,Disposal Justification,Tender Category';
            OptionMembers = ,Nationalities,Countries,Counties,Languages,Cities,Attachments,"Disposal Justification","Tender Category";
        }
        field(4; Agpo; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; General; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Expires; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Attachment Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Corporate,Individual';
            OptionMembers = ,Corporate,Individual;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

