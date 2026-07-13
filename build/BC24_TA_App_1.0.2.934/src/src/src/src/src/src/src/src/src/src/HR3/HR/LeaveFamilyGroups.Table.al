Table 50637 "Leave Family Groups"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100]) { }
        field(3; Remarks; Text[200]) { }
        field(4; "Leave Days"; Decimal)
        {
            DecimalPlaces = 1 : 1;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

