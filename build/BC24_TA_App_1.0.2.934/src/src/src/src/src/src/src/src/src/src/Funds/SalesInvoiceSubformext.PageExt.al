pageextension 50024 "Sales Invoice Subform ext" extends "Sales Invoice Subform"
{
    layout
    {
        addbefore("Location Code")
        {
            field("Pump Code"; Rec."Pump Code")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Pump Code field.';
            }
        }
        addafter(Description)
        {
            field("VAT Prod. Posting Group1"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
            }
            // field("Amount Including VAT"; "Amount Including VAT")
            // {
            //     ApplicationArea = basic;
            // }
            //felix
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shipping Agent Code1"; Rec."Shipping Agent Code")
            {
                caption = 'Vessel No';
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
            }
            field("Shipping Agent Service Code1"; Rec."Shipping Agent Service Code")
            {
                caption = 'Driver Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.';
            }



        }
    }

    actions
    {
        // Add changes to page actions here
    }


}