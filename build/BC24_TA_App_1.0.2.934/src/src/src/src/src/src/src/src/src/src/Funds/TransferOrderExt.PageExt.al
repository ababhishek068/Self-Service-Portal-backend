pageextension 50060 "Transfer Order Ext" extends "Transfer Order"
{
    layout
    {
        addafter("Transfer-to")
        {
            field("Shortcut Dimension 1 Code1"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

            }
        }
        addafter(Status)
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Approval Status field.';
            }
        }
        addafter("In-Transit Code")
        {
            field("Ship-to Contact1"; Rec."Shipping Agent Code")
            {
                caption = 'Truck No';
                ApplicationArea = All;
                ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
            }
            field("Ship-to Address1"; Rec."Transfer-to Address")
            {
                caption = 'Driver Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the address of the location that the items are transferred to.';
            }

        }
    }

    actions
    {
        addbefore("P&osting")
        {
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = Category4;
                ToolTip = 'Executes the Approvals action.';

                trigger OnAction()
                var
                    AppEntry: Record "Approval Entry";
                    AppEntryPage: page "Approval Entries2";
                begin
                    AppEntry.reset;
                    AppEntry.setrange("Document No.", Rec."No.");
                    if AppEntry.find('-') then begin
                        AppEntryPage.SetTableView(AppEntry);
                        AppEntryPage.Run();
                    end;
                    //ApprovalsMgmt.OpenApprovalEntriesPage(RecordId);
                end;
            }
            action(sendApproval)
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Send A&pproval Request action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin

                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);


                end;
            }
            action(cancellsApproval)
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Cancel Approval Re&quest action.';

                trigger OnAction()
                var
                    VarVariant: Variant;
                    CustomApprovals: Codeunit "Custom Approvals Codeunit";
                begin

                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);

                end;
            }
        }
    }
}