Table 50448 "Budget Reporting Line grouping"
{

    fields
    {
        field(1; "Budget Line Grouping"; Code[50]) { }
        field(2; Description; Text[200]) { }
        field(3; Currency; Code[10]) { }
    }

    keys
    {
        key(Key1; "Budget Line Grouping")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

