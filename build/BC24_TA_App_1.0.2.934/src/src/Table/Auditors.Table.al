Table 50188 Auditors
{

    fields
    {
        field(1; "Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Role; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Member,Leader';
            OptionMembers = ,Member,Leader;
        }
        field(3; "Audit Programme"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Audit Programmes".Code;
        }
        field(4; "Audit No."; Option)
        {
            Editable = false;
            FieldClass = Normal;
            OptionCaption = ',1st Internal Audit,1st Surveillance Audit,6th Internal Audit,3rd Surveillance Audit,7th Internal Audit,4th Surveillance Audit';
            OptionMembers = ,"1st Internal Audit","1st Surveillance Audit","6th Internal Audit","3rd Surveillance Audit","7th Internal Audit","4th Surveillance Audit";
        }
        field(5; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "User ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Department; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Audit Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Pending Approval,Accepted,Rejected';
            OptionMembers = ,"Pending Approval",Accepted,Rejected;
        }
        field(10; "Approval Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Conclusion1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Conclusion2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Audit Programme", Department, "User ID", "Audit Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

