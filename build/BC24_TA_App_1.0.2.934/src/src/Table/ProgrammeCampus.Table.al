Table 50035 "Programme Campus"
{


    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(2; Campus; Code[20])
        {
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(3; Remarks; Text[150]) { }
        field(4; Budget; Integer) { }
    }

    keys
    {
        key(Key1; "Programme Code", Campus)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

