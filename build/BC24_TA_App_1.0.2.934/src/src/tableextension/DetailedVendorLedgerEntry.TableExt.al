tableextension 50040 "Detailed Vendor Ledger Entry" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        field(39003911; "External No"; Code[50])
        {
            CalcFormula = lookup("Vendor Ledger Entry"."External Document No." where("Document No." = field("Document No.")));
            FieldClass = FlowField;
        }
    }
}