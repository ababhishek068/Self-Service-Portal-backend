Page 51429 "Cash Office Setup UP"
{
    PageType = Card;
    SourceTable = "Cash Office Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field(PaymentVoucher; Rec."Normal Payments No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Voucher';
                    ToolTip = 'Specifies the value of the Payment Voucher field.';
                }
                field(ChequeRejectPeriod; Rec."Cheque Reject Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Reject Period field.';
                }
                field(PettyCashPaymentsNo; Rec."Petty Cash Payments No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Petty Cash Payments No field.';
                }
                field(CurrentBudget; Rec."Current Budget")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Budget field.';
                }
                field(CurrentBudgetStartDate; Rec."Current Budget Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Budget Start Date field.';
                }
                field(CurrentBudgetEndDate; Rec."Current Budget End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Budget End Date field.';
                }
                field(BankDepositNo; Rec."Bank Deposit No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Deposit No. field.';
                }
                field(StaffClaimNo; Rec."Staff Claim No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff Claim No field.';
                }
                field("Other Staff Advance No"; Rec."Other Staff Advance No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Other Staff Advance No field.';
                }
                field(InterBankTransferNo; Rec."InterBank Transfer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the InterBank Transfer No. field.';
                }
                field(SurrenderTemplate; Rec."Surrender Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Surrender Template field.';
                }
                field(SurrenderBatch; Rec."Surrender  Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Surrender  Batch field.';
                }
                field(ReceiptsNo; Rec."Receipts No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipts No field.';
                }
                field(CashierTransferNos; Rec."Cashier Transfer Nos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cashier Transfer Nos field.';
                }
                field(DefaultBankDepositSlipAC; Rec."Default Bank Deposit Slip A/C")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Bank Deposit Slip A/C field.';
                }
                field(Control1102755003; Rec."Imprest Req No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Req No.';
                    ToolTip = 'Specifies the value of the Imprest Req No. field.';
                }
                field("Enable Imprest Memo"; Rec."Enable Imprest Memo")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Enable Imprest Memo field.';
                }
                field("Memos Req No"; Rec."Memos Req No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Memo Req No.';
                    ToolTip = 'Specifies the value of the Imprest Memo Req No. field.';
                }
                field(ImprestSurrenderNo; Rec."Imprest Surrender No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Imprest Surrender No field.';
                }
                field("Notify On Imprest Surrender"; Rec."Notify On Imprest Surrender")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notify On Imprest Surrender field.';
                }
                field("Auto Post Due Imprest to Payroll"; Rec."Auto Post Due Imprest to Payroll")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Auto Post Due Imprest to Payroll field.';
                }
                field("Receipts Posted Later"; Rec."Receipts Posted Later")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipts Posted Later field.';
                }
                field("Imprest Control Type"; Rec."Imprest Control Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Imprest Control Type field.';
                }
                field(PVTemplate; Rec."PV Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PV Template field.';
                }
                field("Multiple PV Layouts"; Rec."Multiple PV Layouts")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Multiple PV Layouts field.';
                }
                field(PVBatch; Rec."PV  Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PV  Batch field.';
                }
                field(PaymentScheduleNo; Rec."Payment Schedule No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Schedule No field.';
                }
                field("Payment Split Account"; Rec."Payment Split Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Split Account field.';
                }
                field("Payment Posting Method"; Rec."Payment Posting Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Posting Method field.';
                }
                field("Stores Requisition No"; Rec."Stores Requisition No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stores Requisition No field.';
                }
                field("Store Issuance Nos";"Store Issuance Nos"){}
                field("Item Cash Purchase Control Ac."; Rec."Item Cash Purchase Control Ac.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Item Cash Purchase Control Ac. field.';
                }
                field("Items issue Template"; Rec."Items issue Template")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Items issue Template field.';
                }
                field("Items Issue Batch"; Rec."Items Issue Batch")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Items Issue Batch field.';
                }
                field("Requisition Default Vendor"; Rec."Requisition Default Vendor")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Requisition Default Vendor field.';
                }
                field("Quotation Request No"; Rec."Quotation Request No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Quotation Request No field.';
                }
                field("Casual Nos"; Rec."Casual Nos")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Casual Nos field.';
                }
                field("Casual Payment Nos"; Rec."Casual Payment Nos")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Casual Payment Nos field.';
                }
                field("Parttimers Nos"; Rec."Parttimers Nos")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Parttimers Nos field.';
                }
                field("Cash Sale Invoice Nos"; Rec."Cash Sale Invoice Nos")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cash Sale Invoice Nos field.';
                }
                field("Cash Sale Customer No"; Rec."Cash Sale Customer No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cash Sale Customer No field.';
                }
                field("ICT Requisition Nos"; Rec."ICT Requisition Nos")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the ICT Requisition Nos field.';
                }
                field("Maintenance Nos."; Rec."Maintenance Nos.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Maintenance Nos. field.';
                }
                field("Maintenance Plan Nos."; Rec."Maintenance Plan Nos.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Maintenance Plan Nos. field.';
                }
                field("Motor Vehicle Maintenance Nos."; Rec."Motor Vehicle Maintenance Nos.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Motor Vehicle Maintenance Nos. field.';
                }
                field("Asset Transfer Nos."; Rec."Asset Transfer Nos.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Asset Transfer Nos. field.';
                }
                field("Repair Request Nos."; Rec."Repair Request Nos.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Repair Request Nos. field.';
                }
                field("Trucks Posting Group"; Rec."Trucks Posting Group")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Trucks Posting Group field.';
                }
                field("Levy Rate"; Rec."Levy Rate")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Levy Rate field.';
                }
                field("Max Levy Payable"; Rec."Max Levy Payable")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Max Levy Payable field.';
                }
                field("GreenCom Direct Voucher Nos"; Rec."GreenCom PV Nos")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the GreenCom PV Nos field.';
                }

                field("Petty Cash Nos"; Rec."Petty Cash Nos")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Petty Cash Nos field.';
                }


            }
        }
    }

    actions { }
}

