pageextension 50051 "General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {

        addafter("Source Code")
        {
            field("Customer No"; Rec."Customer No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Customer No field.';
            }
            field("Vendor No"; Rec."Vendor No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Vendor No field.';
            }
            field("Bank No"; Rec."Bank No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Bank No field.';
            }
            field("Applied Document No"; Rec."Applied Document No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Applied Document No field.';
            }
            field("Applied Cheque No"; Rec."Applied Cheque No")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Applied Cheque No field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Value Entries")
        {
            action("Update Transactions")
            {
                ApplicationArea = All;
                Caption = 'Update Transactions';
                Promoted = true;
                ToolTip = 'Executes the Update Transactions action.';
                trigger OnAction()
                var
                    UpdateTransactionsCodeunit: Codeunit "Update Transaction numbers";
                begin
                    UpdateTransactionsCodeunit.RUN;
                end;
            }
            action("Update All Other Tables")
            {
                ApplicationArea = All;
                Caption = 'Update All Other Tables';
                Promoted = true;
                RunObject = report "Update Transaction Number";
                ToolTip = 'Executes the Update All Other Tables action.';
            }
        }
    }
}