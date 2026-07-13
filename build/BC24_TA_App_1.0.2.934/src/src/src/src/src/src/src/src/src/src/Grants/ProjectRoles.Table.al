Table 50380 "Project Roles"
{

    fields
    {
        field(1; Role; Code[20]) { }
        field(2; "Role Description"; Text[100]) { }
    }

    keys
    {
        key(Key1; Role)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

