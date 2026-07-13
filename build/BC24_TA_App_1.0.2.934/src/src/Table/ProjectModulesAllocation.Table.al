Table 50257 "Project Modules Allocation"
{

    fields
    {
        field(1; "Project No"; Code[20]) { }
        field(2; Module; Code[20])
        {
            TableRelation = "Project Modules".Code;
        }
    }

    keys
    {
        key(Key1; "Project No", Module)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

