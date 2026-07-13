pageextension 50055 ProductionOrderLine extends "Planned Prod. Order Lines"
{
    layout
    {
        addafter("Item No.")
        {
            field("Store Requisition No"; Rec."Store Requisition No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Store Requisition No field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}