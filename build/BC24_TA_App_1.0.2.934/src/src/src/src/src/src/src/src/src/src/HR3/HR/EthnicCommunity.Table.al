Table 50471 "Languages"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Language"; Text[100]) { }

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

