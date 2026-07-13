Table 50620 "HR Committees"
{
    //LookupPageID = UnknownPage70135016;

    fields
    {
        field(1; "Code"; Code[70])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200])
        {
            NotBlank = true;
        }
        field(3; Roles; Text[200]) { }
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

