Table 50253 "Project Activity"
{
    DrillDownPageID = "Projects Activity";
    LookupPageID = "Projects Activity";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(3; "Activity Type"; Option)
        {
            OptionCaption = ' ,Support,Implementation';
            OptionMembers = " ",Support,Implementation;
        }
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

