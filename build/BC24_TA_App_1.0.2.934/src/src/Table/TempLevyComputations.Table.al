table 50329 "Temp Levy Computations"
{

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; "DT-NAME"; Text[30]) { }
        field(3; "CS. NO"; Code[20]) { }
        field(4; "TOTAL DEPOSITS"; Decimal) { }
        field(5; PERCENTAGE; Decimal)
        {
            DecimalPlaces = 1 : 4;
        }
        field(6; "LEVY COMPUTATION"; Decimal) { }
        field(7; "LEVY CAPPED"; Decimal) { }
        field(8; "LEVY RATE"; Decimal) { }
        field(9; "POSTED"; Boolean) { }
    }

    keys
    {
        key(Key1; "Line No.") { }
    }

    fieldgroups { }
}

