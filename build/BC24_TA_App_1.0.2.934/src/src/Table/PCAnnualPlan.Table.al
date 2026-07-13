table 50653 "PC Annual Plan"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Annual Plans";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[2000])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategies".Code;
        }
        field(4; Active; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(PK; code, "Strategic Plan")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created On" := CreateDateTime(Today, Time);
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