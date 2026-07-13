pageextension 50005 "Bank Reconciallation Statement" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("Document No.1"; Rec."Document No.")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies a number of your choice that will appear on the reconciliation line.';
            }
            field("Check No.1"; Rec."Check No.")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the check number for the transaction on the reconciliation line.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}