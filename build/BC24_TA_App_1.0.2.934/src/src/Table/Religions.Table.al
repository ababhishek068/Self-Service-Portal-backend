Table 50715 Religions
{


    fields
    {
        field(1; Religion; Code[50])
        {
            NotBlank = true;
        }
        field(2; Remarks; Text[150]) { }
    }

    keys
    {
        key(Key1; Religion)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

