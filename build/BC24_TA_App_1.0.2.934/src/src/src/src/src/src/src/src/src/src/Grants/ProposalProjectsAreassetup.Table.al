Table 50394 "Proposal/Projects Areas setup"
{
    // DrillDownPageID = UnknownPage70134739;
    // LookupPageID = UnknownPage70134739;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Area Description"; Text[100]) { }
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

