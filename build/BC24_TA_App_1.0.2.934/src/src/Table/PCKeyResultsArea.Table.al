table 50833 "PC Key Results Area"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Key Results Areas";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[2000])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategies".Code;
        }
        field(4; "Strategic Objective"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Objectives".Code;
        }
    }

    keys
    {
        key(PK; code, "Strategic Plan")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}