table 50233 "License Info"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Voice Number"; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Name; text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Address"; text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Product Line"; text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Product Edition"; text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Product Version"; text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Creation Date"; text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Cummulative Users"; Integer)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "No")
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