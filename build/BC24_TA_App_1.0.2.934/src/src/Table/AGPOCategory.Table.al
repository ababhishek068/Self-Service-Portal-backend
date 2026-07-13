table 50220 "AGPO Category"
{
    DataClassification = ToBeClassified;
    LookupPageId = "AGPO Category";
    DrillDownPageId = "AGPO Category";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[120])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; code)
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