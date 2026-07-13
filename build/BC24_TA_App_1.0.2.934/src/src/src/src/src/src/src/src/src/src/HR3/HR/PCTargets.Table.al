table 50458 "PC Targets"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Quarterly Target"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Actual achieved"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Cumulative Target"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Cumulative Actual"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Variance"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Comments on variance"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "action taken"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Risk Mitigation"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Strategic Plan No."; code[20])
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(PK; "Entry No", "Strategic Plan No.")
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