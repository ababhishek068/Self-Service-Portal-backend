Table 50640 "HR Employee Vehicle"
{

    fields
    {
        field(1; "Employee No"; Code[20]) { }
        field(2; "Vehicle Reg No"; Code[20]) { }
        field(3; "Vehicle Make"; Code[20]) { }
        field(4; "Vehicle Model"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Employee No", "Vehicle Reg No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

