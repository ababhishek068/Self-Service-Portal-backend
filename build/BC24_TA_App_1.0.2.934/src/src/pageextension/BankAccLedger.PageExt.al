pageextension 50003 "Bank Acc. Ledger" extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Amount")
        {
            field("DebitAmount"; Rec."Debit Amount")
            {
                ApplicationArea = all;
                Caption = 'Debit Amount';
                ToolTip = 'Specifies the total of the ledger entries that represent debits.';
            }
            field("CreditAmount"; Rec."Credit Amount")
            {
                ApplicationArea = all;
                Caption = 'Credit Amount';
                ToolTip = 'Specifies the total of the ledger entries that represent credits.';
            }
            field("Transaction No."; Rec."Transaction No.")
            {
                ApplicationArea = all;
                Caption = 'Transaction No';
                ToolTip = 'Specifies the value of the Transaction No field.';
            }
        }
    }
}
