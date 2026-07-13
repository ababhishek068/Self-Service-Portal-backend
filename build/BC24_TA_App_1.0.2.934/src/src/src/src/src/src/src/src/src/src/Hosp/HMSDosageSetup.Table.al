Table 50660 "HMS Dosage Setup"
{
    // LookupPageID = "HR Job Requirement Lines";

    fields
    {
        field(1; "Dose Code"; Code[20]) { }
        field(2; Description; Text[100]) { }
        field(3; "Calculate Dosage"; Boolean) { }
    }

    keys
    {
        key(Key1; "Dose Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

