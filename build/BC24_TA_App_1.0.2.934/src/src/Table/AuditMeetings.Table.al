Table 50248 "Audit Meetings"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Audit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Description 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Description 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Opening Meeting, Progress meeting, Closing Meeting';
            OptionMembers = ,"Opening Meeting"," Progress meeting"," Closing Meeting";
        }
        field(6; "Audit Programme"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Audit No."; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',1st Internal Audit,1st Surveillance Audit,6th Internal Audit,3rd Surveillance Audit,7th Internal Audit,4th Surveillance Audit';
            OptionMembers = ,"1st Internal Audit","1st Surveillance Audit","6th Internal Audit","3rd Surveillance Audit","7th Internal Audit","4th Surveillance Audit";
        }
        field(8; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Meeting Date"; Date)
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

