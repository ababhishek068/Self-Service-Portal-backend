Table 50689 "Audit Meetings Agenda List"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Meeting Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Agenda Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Agenda Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Discussed?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Date Edited"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Edited By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Meeting Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Created By" := Database.UserId;
        "Date Created" := today;
    end;

    trigger OnModify()
    begin
        "Edited By" := Database.UserId;
        "Date Edited" := today;
    end;
}

