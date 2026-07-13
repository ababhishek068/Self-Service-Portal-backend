Table 50625 "HR Hiring Criteria"
{

    fields
    {
        field(1; "Application Code"; Code[50]) { }
        field(2; "Hiring Criteria"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Application Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

