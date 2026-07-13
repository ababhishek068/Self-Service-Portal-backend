table 50144 "Partner Category"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Partner Category";
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
    }

    keys
    {
        key(Key1; code)
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