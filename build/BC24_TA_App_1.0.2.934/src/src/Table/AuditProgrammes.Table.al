Table 50247 "Audit Programmes"
{

    fields
    {
        field(1; "Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Title; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Description/Comment"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Created By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Last Edited By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Date Edited"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"Pending Approval",Approved,Rejected;
        }
        field(9; "Approval Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Notification Sent?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Category"; option)
        {
            OptionMembers = QMS,"Internal Audit";
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Title) { }
    }

    fieldgroups { }
}

