pageextension 50012 BankAccountCard extends "Bank Account Card"

{
    layout
    {
        addafter(Blocked)
        {
            field("Receipt No. Series"; Rec."Receipt No. Series")
            {
                ApplicationArea = all;
                Caption = 'Receipts No. Series';
                ToolTip = 'Specifies the value of the Receipts No. Series field.';
            }
            field("Bank Type"; Rec."Bank Type")
            {
                ApplicationArea = all;
                Caption = 'Bank Type';
                ToolTip = 'Specifies the value of the Bank Type field.';
            }
            field("Bank Account Name"; Rec."Bank Account Name")
            {
                ApplicationArea = all;
                Caption = 'Bank Account Name';
                ToolTip = 'Specifies the value of the Bank Account Name field.';
            }

        }
        addafter("Currency Code")
        {
            field("Min. Balance1"; Rec."Min. Balance")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies a minimum balance for the bank account.';

            }
        }


    }
    actions
    {
        addafter("Check Details")
        {
            action("&Bank Statement")
            {
                ApplicationArea = basic;
                Caption = 'Print';
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print action.';
                trigger OnAction()
                var
                    BankLed: Record "Bank Account Ledger Entry";
                begin
                    BankLed.reset;
                    BankLed.setfilter(BankLed."Bank Account No.", Rec."No.");
                    if BankLed.find('-') then
                        report.Run(70134906, true, true, BankLed);

                end;

            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserRec: record "User Setup";
    begin
        UserRec.Get(Database.UserId);
        UserRec.TestField("Can Create Bank");

    end;
}