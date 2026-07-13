Table 50565 "HMS Setup Immunization"
{
    // LookupPageID = UnknownPage52506;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            NotBlank = true;
        }
        field(3; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4; Amount; Decimal) { }
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

