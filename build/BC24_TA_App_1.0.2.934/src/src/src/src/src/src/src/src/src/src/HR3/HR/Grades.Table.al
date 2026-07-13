Table 50632 Grades
{


    fields
    {
        field(1; Grade; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[250]) { }
        field(3; "Annual Leave Days"; Integer) { }
    }

    keys
    {
        key(Key1; Grade)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

