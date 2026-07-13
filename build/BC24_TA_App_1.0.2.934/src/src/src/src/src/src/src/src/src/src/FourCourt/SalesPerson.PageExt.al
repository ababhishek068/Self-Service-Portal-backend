pageextension 50052 "Sales Person" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Customer Pricing Code"; Rec."Customer Pricing Code")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Customer Pricing Code field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}