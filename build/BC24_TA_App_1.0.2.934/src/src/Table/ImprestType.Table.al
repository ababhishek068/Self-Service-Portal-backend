table 50711 "Imprest Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Imprest Type";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Due Duration (Days)"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Imprest Limit"; Integer)
        {
            DataClassification = ToBeClassified;

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