Table 50807 "HR Document Content Source"
{
    //  DrillDownPageID = UnknownPage39003971;
    //  LookupPageID = UnknownPage39003971;

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
        field(8; "Objective Type"; Option)
        {
            OptionMembers = Quantitative,Qualitative;
        }
    }

    keys
    {
        key(Key1; "Objective Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

