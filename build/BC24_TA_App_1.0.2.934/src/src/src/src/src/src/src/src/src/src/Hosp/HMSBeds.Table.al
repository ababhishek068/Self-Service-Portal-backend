Table 50140 "HMS Beds"
{
    // LookupPageID = UnknownPage70135226;

    fields
    {
        field(1; "Ward No"; Code[20])
        {
            TableRelation = "HMS Ward Setup"."Ward Code";
        }
        field(2; "Bed No"; Code[20]) { }
        field(3; "Bed Name"; Text[30]) { }
        field(4; Occupied; Boolean) { }
    }

    keys
    {
        key(Key1; "Ward No", "Bed No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

