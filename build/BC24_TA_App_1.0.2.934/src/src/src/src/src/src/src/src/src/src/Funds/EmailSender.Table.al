Table 50669 "Email Sender"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Subject; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Receiver Email"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Message Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Message Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Message Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Message Desc 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Sent?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Online Application,Enquiry,QMS,Password Reset,Audit Notification';
            OptionMembers = ,"Online Application",Enquiry,QMS,"Password Reset","Audit Notification";
        }
        field(10; "Date Created"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Sender; Code[100])
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

