Table 50650 "Staff Title"
{
    LookupPageID = "Staff Tiltles";

    fields
    {
        field(1; "Code"; Code[50]) { }
        field(2; Description; Text[100]) { }
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

