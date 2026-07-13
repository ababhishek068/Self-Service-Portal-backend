Table 50550 "File Request Reasons"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
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

