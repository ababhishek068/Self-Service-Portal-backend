table 50231 "Project Output"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Key Activity"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Out Put"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Indicators"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Means Of Verification"; text[100])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(No; "Line No")
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