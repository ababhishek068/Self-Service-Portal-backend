Table 50641 "Hr Institutions"
{

    fields
    {
        field(1; "Institution Code"; Code[30]) { }
        field(2; "Institution Name"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Institution Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

