table 50311 "Visitor Items"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(4; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Description"; text[300])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Item Category"; Option)
        {
            OptionMembers = Personal,"Company Asset",Delivery,Return;
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Line No", No)
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