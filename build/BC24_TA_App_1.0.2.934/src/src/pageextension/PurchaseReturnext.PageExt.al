pageextension 50032 "Purchase Return ext" extends "Purchase Return Order"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Return Shipment No. Series"; Rec."Return Shipment No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Return Shipment No. Series field.';
            }
        }
        moveafter("Responsibility Center"; "Shortcut Dimension 2 Code")
        moveafter("Responsibility Center"; "Shortcut Dimension 1 Code")
        modify("Buy-from Contact")
        {
            Visible = false;
        }
        modify("Buy-from Contact No.")
        {
            Visible = false;
        }
        modify("Pay-to Contact")
        {
            Visible = false;
        }
        modify("Ship-to Contact")
        {
            Visible = false;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }

    }

    actions
    {
        // Add changes to page actions here
    }
}