table 50460 "PC MasterPlan Header"
{
    LookupPageId = "MasterPlan List";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Start Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "End Date"; date)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; code)
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