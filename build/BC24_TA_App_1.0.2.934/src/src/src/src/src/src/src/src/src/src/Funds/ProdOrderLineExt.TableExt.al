tableextension 50044 "Prod. Order Line Ext" extends "Prod. Order Line"
{
    fields
    {
        field(50000; "Store Requisition No"; code[20])
        {
            TableRelation = "Store Requistion Header"."No." where(Status = filter(Posted));
        }
    }
}