table 50229 "Case Mention Dates"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Case No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Hearing Date"; date)
        {
            DataClassification = ToBeClassified;


        }
        field(4; "Court Remarks"; text[200])
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; "Case No", "Line No")
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