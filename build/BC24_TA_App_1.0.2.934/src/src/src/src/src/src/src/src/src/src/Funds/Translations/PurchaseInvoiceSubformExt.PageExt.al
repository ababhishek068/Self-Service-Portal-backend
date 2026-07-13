pageextension 50023 "Purchase Invoice Subform Ext" extends "Purch. Invoice Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        modify("Total VAT Amount")
        {
            Visible = true;
        }

        addafter("VAT Prod. Posting Group")
        {
            field("Item G/L Budget Account"; Rec."Item G/L Budget Account")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Item G/L Budget Account field.';
            }
            // field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            // {
            //     ApplicationArea = basic;
            // }

            field("Shipping Agent Code1"; Rec."Shipping Agent Code")
            {
                caption = 'Truck No';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Truck No field.';
            }
            field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
            {
                caption = 'Driver Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Driver Name field.';
            }
            field("Observed Quantity"; Rec."Unit Volume")
            {
                caption = 'Observed Quantity';
                ApplicationArea = All;
                ToolTip = 'Specifies the volume of one unit of the item. In the purchase statistics window, the volume of one unit of the item on the line is included in the total volume of all the lines for the particular purchase document.';
            }
            field("Board Member No"; Rec."Board Member No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Board Member No field.';
            }
        }
    }

}