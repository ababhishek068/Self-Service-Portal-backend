table 50205 "Case Withness"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Case No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Name"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Address"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Phone No"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Gender"; option)
        {
            OptionMembers = ,Male,Female;
            DataClassification = ToBeClassified;

        }
        field(6; "ID Number"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Age"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Email"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Physical Address"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

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