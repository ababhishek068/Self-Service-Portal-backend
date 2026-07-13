table 50438 "PC Strategic Objectives"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Strategic Objectives";
    fields
    {
        field(1; Code; code[100])
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