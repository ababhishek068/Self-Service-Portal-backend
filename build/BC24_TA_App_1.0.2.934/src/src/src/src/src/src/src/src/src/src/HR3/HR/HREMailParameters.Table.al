Table 50845 "HR E-Mail Parameters"
{

    fields
    {
        field(1; "Associate With"; Option)
        {
            Caption = 'Associate With';
            OptionMembers = "Vacancy Advertisements","Interview Invitations",General,"HR Jobs","Regret Notification"," Aptitude Test Invitation","Aptitude Regret Notification","Assesment Test Invitation","Assesment Regret Notification";
        }
        field(2; "Sender Name"; Text[30]) { }
        field(3; "Sender Address"; Text[30]) { }
        field(4; Recipients; Text[30]) { }
        field(5; Subject; Text[100]) { }
        field(6; Body; Text[100]) { }
        field(7; "Body 2"; Text[250]) { }
        field(8; HTMLFormatted; Boolean) { }
        field(9; "Body 3"; Text[250]) { }
        field(10; "Body 4"; Text[250]) { }
        field(11; "Body 5"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Associate With")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

