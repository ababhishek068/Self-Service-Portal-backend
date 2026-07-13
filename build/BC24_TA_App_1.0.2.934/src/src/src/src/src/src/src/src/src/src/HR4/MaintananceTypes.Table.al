Table 50293 "Maintanance Types"
{
    DrillDownPageID = "Maintanance Type";
    LookupPageID = "Maintanance Type";

    fields
    {
        field(1; "Maintanance Code"; Code[30]) { }
        field(2; "Maintanance Description"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Maintanance Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

