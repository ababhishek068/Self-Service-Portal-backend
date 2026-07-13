Page 51430 "Cash Office User Template UP"
{
    DataCaptionFields = UserID;
    PageType = List;
    SourceTable = "Cash Office User Template";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102758000)
            {
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the UserID field.';
                }
                field(ReceiptJournalTemplate; Rec."Receipt Journal Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt Journal Template field.';
                }
                field(ReceiptJournalBatch; Rec."Receipt Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt Journal Batch field.';
                }
                field(ImprestTemplate; Rec."Imprest Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Imprest Template field.';
                }
                field("Claim Template"; Rec."Claim Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claim Template field.';
                }
                field("Claim  Batch"; Rec."Claim  Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claim  Batch field.';
                }
                field(ImprestBatch; Rec."Imprest  Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Imprest  Batch field.';
                }
                field(DefaultReceiptsBank; Rec."Default Receipts Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Receipts Bank field.';
                }
                field(DefaultPettyCashBank; Rec."Default Petty Cash Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Petty Cash Bank field.';
                }
                field("Default MPESA Cash Bank"; Rec."Default MPESA Cash Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default MPESA Cash Bank field.';
                }
                field(DefaultPaymentBank; Rec."Default Payment Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Payment Bank field.';
                }
                field(PaymentJournalTemplate; Rec."Payment Journal Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Journal Template field.';
                }
                field(PaymentJournalBatch; Rec."Payment Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Journal Batch field.';
                }
                field(PettyCashTemplate; Rec."Petty Cash Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Petty Cash Template field.';
                }
                field(PettyCashBatch; Rec."Petty Cash Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Petty Cash Batch field.';
                }
                field(InterBankTemplateName; Rec."Inter Bank Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inter Bank Template Name field.';
                }
                field(InterBankBatchName; Rec."Inter Bank Batch Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inter Bank Batch Name field.';
                }
                field(BankPayInJournalTemplate; Rec."Bank Pay In Journal Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Pay In Journal Template field.';
                }
                field(BankPayInJournalBatch; Rec."Bank Pay In Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Pay In Journal Batch field.';
                }
                field("Item Template"; Rec."Item Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item Template field.';
                }
                field("Item Batch"; Rec."Item Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Item Batch field.';
                }
                field("Default Location"; Rec."Default Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Location field.';
                }
                field("Source of Funds"; Rec."Source of Funds")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Source of Funds field.';
                }
                field("Advance  Batch";"Advance  Batch"){}
                field("Advance Template";"Advance Template"){}
                field("Advance Surr Batch";"Advance Surr Batch"){}
                field("Advance Surr Template";"Advance Surr Template"){}
            }
        }
    }

    actions { }
}

