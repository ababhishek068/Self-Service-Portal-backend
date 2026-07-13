Table 50126 "Grants Lookup Values"
{
    // DrillDownPageID = "prEmployee Posting Group";
    //  LookupPageID = "prEmployee Posting Group";

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = 'Sub Contractor Close Out Checklist,,Close Out Checklist';
            OptionMembers = "Sub Contractor Close Out Checklist",,"Close Out Checklist";
        }
        field(2; "Code"; Code[70]) { }
        field(3; Description; Text[80]) { }
        field(4; Remarks; Text[250]) { }
        field(6; Closed; Boolean) { }
        field(7; "Order"; Integer) { }
        field(8; "Grants no."; Code[50])
        {
            TableRelation = Jobs."No.";
        }
    }

    keys
    {
        key(Key1; "Order", Type, "Code", "Grants no.")
        {
            Clustered = true;
        }

    }

    fieldgroups { }
}

