pageextension 50004 "Posted Purch. Invoice Subform1" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Direct Unit Cost")
        {

            field("Observed Quantity"; Rec."Unit Volume")
            {
                caption = 'Observed Quantity';
                ApplicationArea = All;
                ToolTip = 'Specifies the volume of one unit of the item. In the purchase statistics window, the volume of one unit of the item on the line is included in the total volume of all the lines for the particular purchase document.';
            }
        }
    }
}
