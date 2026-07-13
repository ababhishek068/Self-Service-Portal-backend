Table 50199 "Audit Notifications"
{

    fields
    {
        field(1; "Programme"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Audit; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Auditee; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Auditor"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Objectives1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Read?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Audit Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Objectives2; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Criteria1; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Criteria2; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Activities1; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Activities2; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Code; code[20])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

