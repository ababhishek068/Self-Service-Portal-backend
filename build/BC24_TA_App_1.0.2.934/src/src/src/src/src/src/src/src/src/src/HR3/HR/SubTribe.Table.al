Table 50143 "Sub Tribe"
{
    LookupPageId = "Sub Tribe";
    fields
    {
        field(1; "Sub Tribe Code"; Code[20]) { }
        field(3; "Tribe Code"; Code[20])
        {
            //TableRelation = "Ethnic Community".code;--felix
        }
        field(2; "Description"; Text[100]) { }

    }

    keys
    {
        key(Key1; "Sub Tribe Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

