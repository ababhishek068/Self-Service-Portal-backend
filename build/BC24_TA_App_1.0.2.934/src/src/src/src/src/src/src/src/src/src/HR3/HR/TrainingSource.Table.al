Table 50634 "Training Source"
{
    // LookupPageID = UnknownPage39005843;

    fields
    {
        field(1; Source; Code[50])
        {
            NotBlank = true;
        }
        field(2; Remarks; Text[250]) { }
    }

    keys
    {
        key(Key1; Source)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

