Table 50542 "Investment Interest Schedule"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Investment No."; Code[20]) { }
        field(3; Date; Date) { }
        field(4; "Interest Calculated"; Decimal) { }
        field(5; Posted; Boolean) { }
        field(6; "Archived Versions"; Integer) { }
        field(7; "Investment Withholding Tax"; Decimal) { }
        field(8; "Investment Rate"; Decimal)
        {
            TableRelation = "Investment Rates".Rate where(Type = filter(Interest));
        }
        field(11; "Investment Principal"; Decimal) { }
        field(19; "Withholding Tax Rate"; Decimal)
        {
            TableRelation = "Investment Rates".Rate where(Type = filter("Withholding Tax"));
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Investment No.", "Archived Versions", Date) { }
    }

    fieldgroups { }
}

