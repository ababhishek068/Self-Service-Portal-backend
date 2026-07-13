table 50063 "Lecturer Evaluation Items"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[150])
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