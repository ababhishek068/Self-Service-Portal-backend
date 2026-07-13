Table 50612 "HMS Treatment History"
{

    fields
    {
        field(1; "Treatment No."; Code[20]) { }
        field(2; "History Code"; Code[20])
        {
            TableRelation = "HMS Patient History"."History Code";
        }
        field(3; "History Value"; Code[250]) { }
        field(4; "History Name"; Text[250])
        {
            CalcFormula = lookup("HMS Patient History"."History Name" where("History Code" = field("History Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Treatment No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

