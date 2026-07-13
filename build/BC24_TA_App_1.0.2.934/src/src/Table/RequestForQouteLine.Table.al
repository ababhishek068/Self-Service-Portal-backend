Table 50741 "Request For Qoute Line"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Quote No"; Code[10]) { }
        field(3; "Item No"; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(4; Description; Text[50]) { }
        field(5; Units; Code[20]) { }
        field(6; Qty; Decimal) { }
        field(7; "Unit Cost"; Decimal) { }
        field(8; "Line Amount"; Decimal) { }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
        key(Key2; "Quote No")
        {
            SumIndexFields = "Line Amount";
        }
    }

    fieldgroups { }
}

