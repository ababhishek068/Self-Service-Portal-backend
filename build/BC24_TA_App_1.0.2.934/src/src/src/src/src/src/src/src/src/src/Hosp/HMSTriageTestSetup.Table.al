Table 50615 "HMS Triage Test Setup"
{

    fields
    {
        field(1; "Test Code"; Code[30]) { }
        field(2; "Test Description"; Text[250]) { }
        field(3; Compulsory; Boolean) { }
    }

    keys
    {
        key(Key1; "Test Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

