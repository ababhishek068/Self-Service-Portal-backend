Table 50600 "HMS Systems"
{
    //  DrillDownPageID = UnknownPage70135144;
    //  LookupPageID = UnknownPage70135144;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[30]) { }
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

