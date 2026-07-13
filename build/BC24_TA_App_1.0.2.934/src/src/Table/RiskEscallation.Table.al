table 50466 "Risk Escallation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; UserID; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Designation; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Date; date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Action Taken"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Risk Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; UserID, "Risk Code")
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