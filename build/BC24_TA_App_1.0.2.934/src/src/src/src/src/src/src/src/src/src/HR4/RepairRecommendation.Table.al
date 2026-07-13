Table 50292 "Repair Recommendation"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Repair No"; Code[20]) { }
        field(3; "Vehicle No"; Code[20]) { }
        field(4; "Recommendation by officer"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Line No", "Repair No", "Vehicle No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

