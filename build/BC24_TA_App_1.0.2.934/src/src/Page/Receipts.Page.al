Page 50154 Receipts
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Worksheet;
    SourceTable = Receipt;
    UsageCategory = Lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = true;
                field(ReceiptNo; Rec."Receipt No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                }
                field(BankSlipChequeNo; Rec."Bank Slip/Cheque No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Slip/Cheque No field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Reversed field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(TransactionDate; Rec."Transaction Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Date field.';
                }
                field(PaymentMode; Rec."Payment Mode")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payment Mode field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(PaymentBy; Rec."Payment By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Payment By field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Preview)
            {
                ApplicationArea = all;
                Caption = 'Preview';
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Executes the Preview action.';

                trigger OnAction()
                begin
                    Rec.TestField(Reversed, false);
                    Receipts.Reset;
                    Receipts.SetRange(Receipts."Receipt No.", Rec."Receipt No.");
                    if Receipts.Find('-') then
                        Report.Run(70134858, true, false, Receipts);
                end;
            }
            action(AppliedItems)
            {
                ApplicationArea = all;
                Caption = 'Applied Items';
                Image = ApplicationWorksheet;
                RunObject = page "Receipt Items";
                RunPageLink = "Receipt No" = field("Receipt No.");
                ToolTip = 'Executes the Applied Items action.';

            }
        }
    }

    var
        Receipts: Record Receipt;
}

