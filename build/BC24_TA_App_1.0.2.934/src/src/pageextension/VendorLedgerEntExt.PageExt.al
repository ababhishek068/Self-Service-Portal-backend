pageextension 50043 "Vendor Ledger Ent. Ext" extends "Vendor Ledger Entries"
{
    layout { }

    actions
    {
        addafter(UnapplyEntries)
        {
            action(ForceUnApply)
            {
                caption = 'Force Unapply';
                ApplicationArea = basic;
                image = UnApply;
                Promoted = true;
                ToolTip = 'Executes the Force Unapply action.';
                trigger OnAction()
                var
                    WebPortal: Codeunit HRWebportal;
                begin
                    if Confirm('Are you sure you want to force unapply this transaction?', true) = true then begin
                        WebPortal.PostForcedUnApplyVendor(Rec."Document No.");
                        Message('Transaction unapplied successfully');
                    end;
                end;
            }
        }
    }
}