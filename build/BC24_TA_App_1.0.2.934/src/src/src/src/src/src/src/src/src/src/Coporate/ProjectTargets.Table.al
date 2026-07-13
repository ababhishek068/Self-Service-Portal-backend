table 50232 "Project Targets"
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
        field(3; "Key Results"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Reporting Frequency"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Target Quarter1"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Target Quarter2"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Target Quarter3"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Target Quarter4"; text[100])
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