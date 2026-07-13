table 50224 "Vendor Notifications"
{

    fields
    {
        field(1; "Notification ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Title; Code[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Active,Inactive;
        }
        field(5; "Date Posted"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Posted By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Notification ID")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

