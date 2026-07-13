table 50187 "Sub Region"
{
    DataClassification = ToBeClassified;

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
        field(3; Target; decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(4; Region; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Region.code;

        }
    }

    keys
    {
        key(Key1; Code, Region)
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