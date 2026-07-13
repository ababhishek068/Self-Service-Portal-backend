Table 50773 "HMS Signs Setup"
{
    // LookupPageID = "ELECT Login";

    fields
    {
        field(1; "Sign Code"; Code[20]) { }
        field(2; "Signs Name"; Text[100]) { }
        field(3; System; Code[20])
        {
            Description = '$';
            TableRelation = "HMS Systems".Code;
        }
    }

    keys
    {
        key(Key1; "Sign Code", System)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

