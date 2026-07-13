table 50705 "Staff Shift"
{
    DataClassification = ToBeClassified;
    LookupPageId = Shift;
    fields
    {
        field(1; Code; code[20])
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