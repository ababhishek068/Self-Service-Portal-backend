Table 50611 "HMS Patient History"
{
    //  LookupPageID = "Units/Subject List";

    fields
    {
        field(1; "History Code"; Code[20]) { }
        field(2; "History Name"; Text[100]) { }
    }

    keys
    {
        key(Key1; "History Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

