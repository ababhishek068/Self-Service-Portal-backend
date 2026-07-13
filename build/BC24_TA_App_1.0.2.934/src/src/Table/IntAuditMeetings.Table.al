Table 50358 "Int. Audit Meetings"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Quarter; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Quarters".Code;
        }
        field(3; "Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Opening Meeting, Progress meeting, Closing Meeting,Council Meeting';
            OptionMembers = ,"Opening Meeting"," Progress meeting"," Closing Meeting","Council Meeting";
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
        key(Key1; "Code", Quarter)
        {
            Clustered = true;
        }
        key(MyKey; Quarter, Code)
        {
            Unique = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Description") { }
    }
}

