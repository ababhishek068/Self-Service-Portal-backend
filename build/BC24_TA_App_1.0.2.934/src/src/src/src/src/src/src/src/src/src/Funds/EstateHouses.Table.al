table 50474 "Estate Houses"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Estate Houses";
    LookupPageId = "Estate Houses";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Occupant Employee No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Outsider Name"; text[100])
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