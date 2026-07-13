Table 50123 "Budget Line Items"
{
    DrillDownPageID = "Budget Line Items List";
    LookupPageID = "Budget Line Items List";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Name; Text[250]) { }
        field(3; Use; Boolean) { }
        field(4; Position; Integer) { }
        field(5; "Budget Line Grouping"; Code[50])
        {
            TableRelation = "Budget Reporting Line grouping"."Budget Line Grouping";
        }
        field(6; "Global Dimension 2 Code"; Code[50])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('PROJECT'));
        }
    }

    keys
    {
        key(Key1; "Code", Position, "Budget Line Grouping")
        {
            Clustered = true;
        }
        key(Key2; Position) { }
        key(Key3; "Budget Line Grouping") { }
    }

    fieldgroups { }
}

