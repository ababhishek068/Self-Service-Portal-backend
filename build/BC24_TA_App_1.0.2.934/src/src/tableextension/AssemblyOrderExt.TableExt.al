tableextension 50045 "Assembly Order Ext" extends "Assembly Header"
{
    fields
    {
        field(50000; "Assembly Status"; code[20])
        {
            TableRelation = "Production Status";
        }
    }
}