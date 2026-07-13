table 50320 "Cleaning Sections"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Cleaning Sections";

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
        key(PK; Code)
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