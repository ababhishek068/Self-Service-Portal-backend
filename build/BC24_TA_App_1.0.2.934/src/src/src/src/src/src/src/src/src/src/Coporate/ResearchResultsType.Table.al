table 50125 "Research Results Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Research Results Type";
    fields
    {
        field(1; "Results Type"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Description; Text[200])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Results Type", Code)
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