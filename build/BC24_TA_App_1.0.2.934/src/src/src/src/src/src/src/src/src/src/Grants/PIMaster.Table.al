Table 50372 "PI Master"
{
    // DrillDownPageID = "ACA-Clearance Approval Entries";
    //  LookupPageID = "ACA-Clearance Approval Entries";

    fields
    {
        field(1; "PI Code"; Code[50]) { }
        field(2; "PI Name"; Text[100]) { }
        field(3; "Colabotative Institution"; Text[100]) { }
        field(4; "PI Address"; Text[30]) { }
        field(5; "PI Telephone"; Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(6; "PI EMail"; Text[30])
        {
            ExtendedDatatype = EMail;
        }
    }

    keys
    {
        key(Key1; "PI Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

