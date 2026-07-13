Table 50373 "Jobs Comments"
{

    fields
    {
        field(1; "jobs no"; Code[50]) { }
        field(2; Comments; Text[250]) { }
        field(3; "Date Comments"; Date) { }
    }

    keys
    {
        key(Key1; "jobs no")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

