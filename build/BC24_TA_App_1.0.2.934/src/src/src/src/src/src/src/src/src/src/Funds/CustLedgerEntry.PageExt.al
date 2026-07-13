pageextension 50044 "Cust. Ledger Entry" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Customer No.") { }
    }

    actions
    {
        addafter(UnapplyEntries)
        {
            action(ForceUnApply)
            {
                caption = 'Force Unapply';
                ApplicationArea = basic;
                image = UnApply;
                ToolTip = 'Executes the Force Unapply action.';
                trigger OnAction()
                var
                    StudBill: Codeunit "Student Billing";
                begin
                    studbill.PostForcedUnApply(Rec."Document No.");
                end;
            }
        }
    }
}