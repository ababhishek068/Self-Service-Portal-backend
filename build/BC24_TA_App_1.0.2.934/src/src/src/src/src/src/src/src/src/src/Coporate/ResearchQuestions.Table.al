table 50316 "Research Questions"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Research Questions";
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Category; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Partner Category";

        }
    }

    keys
    {
        key(Key1; Code)
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