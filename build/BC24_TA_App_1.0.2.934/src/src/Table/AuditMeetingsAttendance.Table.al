Table 50690 "Audit Meetings Attendance"
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
        field(3; Attendee; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Created By"; Code[30])
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

    fieldgroups { }
}

