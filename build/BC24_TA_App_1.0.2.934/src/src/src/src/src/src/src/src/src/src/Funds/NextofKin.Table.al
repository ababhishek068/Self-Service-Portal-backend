Table 50029 "Next of Kin"
{

    fields
    {
        field(1; "Patient No"; Code[20]) { }
        field(2; Names; Text[200])
        {
            NotBlank = true;
        }
        field(3; Relationship; Code[20]) { }
        field(4; Occupation; Text[200]) { }
        field(5; "Date of Birth"; Date) { }
        field(6; "Tel No"; Text[100]) { }
        field(7; "E-Mail"; Text[100]) { }
        field(8; Address; Text[200]) { }
    }

    keys
    {
        key(Key1; Names, "Patient No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

