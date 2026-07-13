table 50314 "Research Objectives"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Research Area"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method".Code;

        }
        field(4; "Objective"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Measure Indicator"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Research Results"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; No, "Line No")
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