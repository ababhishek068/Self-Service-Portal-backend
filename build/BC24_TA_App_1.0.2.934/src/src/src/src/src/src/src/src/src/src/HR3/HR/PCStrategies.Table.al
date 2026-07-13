table 50457 "PC Strategies"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Strategies";
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
        field(3; "Period From"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Period To"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Last Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Last Modified On"; DateTime)
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
        "Created By" := UserId;
        "Created On" := CreateDateTime(Today, Time);
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified On" := CreateDateTime(Today, Time);
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}