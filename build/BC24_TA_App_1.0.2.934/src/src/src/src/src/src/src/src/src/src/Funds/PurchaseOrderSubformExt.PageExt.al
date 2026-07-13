pageextension 50019 "Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Over-Receipt Quantity")
        {
            Visible = false;
        }
        // modify("Cross-Reference No.")
        // {
        //     Visible = false;
        // }
        addafter(Description)
        {
            field("Request Summary"; Rec."Request Summary")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Request Summary field.';
            }
        }
        addbefore("Qty. to Receive")
        {
            field("Item G/L Budget Account"; Rec."Item G/L Budget Account")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Item G/L Budget Account field.';
            }
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}