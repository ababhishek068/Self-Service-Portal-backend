Table 50505 "Online Sessions"
{

    fields
    {
        field(1; "User Name"; Code[50])
        {
            Editable = false;
        }
        field(2; "Session ID"; Text[150])
        {
            Editable = false;
        }
        field(3; "Login Time"; DateTime)
        {
            Editable = false;
        }
        field(4; "Logout Time"; DateTime)
        {
            Editable = false;
        }
        field(5; "Login Duration"; Decimal) { }
        field(6; "IP Address"; Text[30]) { }
    }

    keys
    {
        key(Key1; "Session ID", "User Name")
        {
            Clustered = true;
        }
        key(Key2; "Login Time") { }
    }

    fieldgroups { }
}

