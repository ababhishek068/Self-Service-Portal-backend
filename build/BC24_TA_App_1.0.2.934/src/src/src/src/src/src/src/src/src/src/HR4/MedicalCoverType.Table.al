Table 50223 "Medical Cover Type"
{

    fields
    {
        field(1; "Scheme No"; Code[30]) { }
        field(2; "Cover Type"; Option)
        {
            OptionCaption = ',IP,OP';
            OptionMembers = ,IP,OP;
        }
        field(3; "CAT A"; Decimal) { }
        field(4; "CAT B"; Decimal) { }
        field(5; "CAT C"; Decimal) { }
        field(6; "CAT D"; Decimal) { }
        field(7; "CAT E"; Decimal) { }
        field(8; Description; Text[100]) { }
        field(9; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Scheme No", "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

