pageextension 50062 "Sales Shippment Ext" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Ship-to Contact1"; Rec."Ship-to Contact")
            {
                caption = 'Truck No';
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the person you regularly contact at the address that the items were shipped to.';
            }
            field("Ship-to Address1"; Rec."Ship-to Address")
            {
                caption = 'Driver Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the address that you delivered the items to.';
            }
            field("Ship-to Address 22"; Rec."Ship-to Address 2")
            {
                caption = 'Drivers ID';
                ApplicationArea = All;
                ToolTip = 'Specifies the extended address that you delivered the items to.';
            }
            field("Ship-to Name1"; Rec."Ship-to Name")
            {
                caption = 'Transporter';
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the customer that you delivered the items to.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}