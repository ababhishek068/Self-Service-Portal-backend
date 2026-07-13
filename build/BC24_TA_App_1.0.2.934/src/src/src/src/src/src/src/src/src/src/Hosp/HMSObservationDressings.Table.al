Table 50597 "HMS Observation Dressings"
{

    fields
    {
        field(1; "Observation No."; Code[20]) { }
        field(2; "Process No."; Code[20])
        {
            TableRelation = "Store Requistion Header"."No.";
        }
        field(3; Description; Text[30])
        {
            // CalcFormula = lookup("Store Requistion Header"."Request date" where ("No."=field("Process No.")));
            FieldClass = FlowField;
        }
        field(4; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(5; "Item Description"; Text[30])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(6; "Unit of Measure"; Code[20])
        {
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(7; Quantity; Decimal) { }
        field(8; Remarks; Text[200]) { }
        field(9; Posted; Boolean) { }
    }

    keys
    {
        key(Key1; "Observation No.", "Process No.", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

