Table 50836 "Appraisal Types"
{
    // DrillDownPageID = UnknownPage39005882;
    //   LookupPageID = UnknownPage39005882;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150])
        {
            NotBlank = true;
        }
        field(3; "Use Template"; Boolean) { }
        field(4; "Template Link"; Text[200]) { }
        field(5; Remarks; Text[250]) { }
        field(6; "Max. Weighting"; Decimal) { }
        field(7; "Max. Score"; Decimal) { }
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

