tableextension 50046 "Purch. Inv. Line Ext" extends "Purch. Inv. Line"
{

    fields
    {
        field(50000; Closed; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header".Closed where("No." = field("Document No.")));
        }
    }
}