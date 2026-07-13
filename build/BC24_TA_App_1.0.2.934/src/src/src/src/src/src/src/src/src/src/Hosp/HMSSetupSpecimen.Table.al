Table 50569 "HMS Setup Specimen"
{
    //  LookupPageID = UnknownPage70135061;

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
        field(3; "Normal Ranges"; Text[100]) { }
        field(4; Units; Code[20]) { }
        field(5; "Desirable level"; Text[200]) { }
        field(6; "High Risk"; Text[200]) { }
        field(7; "Min Range"; Decimal) { }
        field(8; "Max Range"; Decimal) { }
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

