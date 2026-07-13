Page 51406 "Bank Account Statement1"
{
    Caption = 'Bank Account Statement';
    InsertAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = "Bank Account Statement";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(BankAccountNo; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the bank account that has been reconciled with this Bank Account Statement.';
                }
                field(StatementNo; Rec."Statement No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the bank''s statement that has been reconciled with the bank account.';
                }
                field(StatementDate; Rec."Statement Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date on the bank''s statement that has been reconciled with the bank account.';
                }
                field(BalanceLastStatement; Rec."Balance Last Statement")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ending balance on the bank account statement from the last posted bank account reconciliation.';
                }
                field(StatementEndingBalance; Rec."Statement Ending Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ending balance on the bank''s statement that has been reconciled with the bank account.';
                }
            }
            part(Control11; "Bank Account Statement Lines")
            {
                SubPageLink = "Bank Account No." = field("Bank Account No."),
                              "Statement No." = field("Statement No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Statement)
            {
                Caption = 'St&atement';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = '&Card';
                    Image = EditLines;
                    RunObject = Page "Bank Account Card";
                    RunPageLink = "No." = field("Bank Account No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the &Card action.';
                }
                action("Posted Bank Reconciliation")
                {
                    ApplicationArea = Basic;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    ToolTip = 'Executes the Posted Bank Reconciliation action.';

                    trigger OnAction()
                    begin
                        BankAccountStatement.Reset;
                        BankAccountStatement.SetRange(BankAccountStatement."Statement No.", Rec."Statement No.");
                        BankAccountStatement.SetRange(BankAccountStatement."Bank Account No.", Rec."Bank Account No.");
                        if BankAccountStatement.Find('-') then Report.Run(1407, true, false, BankAccountStatement);
                    end;
                }
            }
        }
    }

    var
        BankAccountStatement: Record "Bank Account Statement";
}

