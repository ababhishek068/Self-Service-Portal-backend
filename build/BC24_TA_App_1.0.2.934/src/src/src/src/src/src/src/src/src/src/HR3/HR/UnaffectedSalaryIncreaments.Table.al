Table 50853 "Un-affected Salary Increaments"
{

    fields
    {
        field(1; "Increament Month"; Code[20]) { }
        field(2; "Increament Year"; Integer) { }
        field(3; "Employee No."; Code[20]) { }
        field(4; "Employee Category"; Code[20]) { }
        field(5; "Employee Grade"; Code[20]) { }
        field(6; Reason; Text[250]) { }
    }

    keys
    {
        key(Key1; "Increament Month")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

