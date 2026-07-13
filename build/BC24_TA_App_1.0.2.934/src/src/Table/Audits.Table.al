Table 50246 Audits
{

    fields
    {
        field(1; "Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Audit Programme"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Audit Programmes".Code;
        }
        field(3; "Audit No."; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',1st Internal Audit,1st Surveillance Audit,6th Internal Audit,3rd Surveillance Audit,7th Internal Audit,4th Surveillance Audit';
            OptionMembers = ,"1st Internal Audit","1st Surveillance Audit","6th Internal Audit","3rd Surveillance Audit","7th Internal Audit","4th Surveillance Audit";
        }
        field(4; "Audit From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Audit To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Leaders Appointment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Members Appointment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Follow Up To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Review To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Follow Up From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Review From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Open,Closed;
        }
        field(13; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Name; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; Quarter; option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"1st Quarter","2nd Quarter","3rd Quarter","4th Quarter";
        }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Audit Programme") { }
    }

    fieldgroups { }
    trigger OnInsert()
    begin
        "Created By" := Database.UserId;
        "Date Created" := today;
    end;
}

