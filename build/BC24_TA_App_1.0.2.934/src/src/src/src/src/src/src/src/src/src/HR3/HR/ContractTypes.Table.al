Table 50830 "Contract Types"
{
    DrillDownPageID = "Contract Types";
    LookupPageID = "Contract Types";

    fields
    {
        field(1; Contract; Code[50])
        {
            NotBlank = true;
        }
        field(2; Remarks; Text[200]) { }
        field(3; "Pays Provident"; Boolean) { }
        field(4; "Pays Pension"; Boolean) { }
    }

    keys
    {
        key(Key1; Contract)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

