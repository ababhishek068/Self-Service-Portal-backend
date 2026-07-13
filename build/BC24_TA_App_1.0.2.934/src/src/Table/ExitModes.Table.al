Table 50717 "Exit Modes"
{


    fields
    {
        field(1; Code; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
    }

    keys
    {
        key(Key1; code)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

