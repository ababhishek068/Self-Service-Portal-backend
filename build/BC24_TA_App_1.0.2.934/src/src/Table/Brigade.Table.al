Table 50200 "Brigade"
{
    LookupPageId = Brigade;
    fields
    {
        field(1; Code; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
        field(3; "Paramilitary Academy"; Code[20])
        {
            TableRelation = "Paramilitary Academy".Code;
        }
        field(4; Capacity; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = sum(Barracks.Capacity where(Brigate = field(Code)));
        }
        field(5; "Skip Booking"; Boolean) { }
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

