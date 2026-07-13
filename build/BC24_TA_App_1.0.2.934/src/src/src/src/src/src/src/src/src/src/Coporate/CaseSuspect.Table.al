table 50201 "Case Suspect"
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
        field(8; "Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Region.Code;

        }
        field(9; "Sub Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Region".Code where(Region = field(Region));

        }
        field(10; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(11; "Ward"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Village"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Nearest Reference Institution"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Place Residence"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(15; "Email"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(16; "Occupation"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(17; "Place of Work"; text[200])
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