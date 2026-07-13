Page 50852 "Payments List"
{
    PageType = List;
    SourceTable = "Payment Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(PayMode; Rec."Pay Mode")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field(ChequeNo; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque No field.';
                }
                field(ChequeDate; Rec."Cheque Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Date field.';
                }
                field(ChequeType; Rec."Cheque Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Type field.';
                }
                field(BankCode; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field(ReceivedFrom; Rec."Received From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field(OnBehalfOf; Rec."On Behalf Of")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(AccountName; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(DatePosted; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(TimePosted; Rec."Time Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field(PostedBy; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(TransactionName; Rec."Transaction Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field(VATCode; Rec."VAT Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Code field.';
                }
                field(WithholdingTaxCode; Rec."Withholding Tax Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Code field.';
                }
                field(VATAmount; Rec."VAT Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Amount field.';
                }
                field(WithholdingTaxAmount; Rec."Withholding Tax Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Amount field.';
                }
                field(NetAmount; Rec."Net Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Net Amount field.';
                }
                field(PayingBankAccount; Rec."Paying Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(BranchCode; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field(POINVNo; Rec."PO/INV No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PO/INV No field.';
                }
                field(BankAccountNo; Rec."Bank Account No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Account No field.';
                }
                field(CashierBankAccount; Rec."Cashier Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cashier Bank Account field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field(Grouping; Rec.Grouping)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grouping field.';
                }
                field(PaymentType; Rec."Payment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }
                field(BankType; Rec."Bank Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Type field.';
                }
                field(PVType; Rec."PV Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PV Type field.';
                }
                field(Applyto; Rec."Apply to")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Apply to field.';
                }
                field(ApplytoID; Rec."Apply to ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Apply to ID field.';
                }
                field(NoofUnits; Rec."No of Units")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No of Units field.';
                }
                field(SurrenderDate; Rec."Surrender Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Surrender Date field.';
                }
                field(Surrendered; Rec.Surrendered)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Surrendered field.';
                }
                field(SurrenderDocNo; Rec."Surrender Doc. No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Surrender Doc. No field.';
                }
                field(VoteBook; Rec."Vote Book")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vote Book field.';
                }
                field(TotalAllocation; Rec."Total Allocation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Allocation field.';
                }
                field(TotalExpenditure; Rec."Total Expenditure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Expenditure field.';
                }
                field(TotalCommitments; Rec."Total Commitments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Commitments field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(BalanceLessthisEntry; Rec."Balance Less this Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance Less this Entry field.';
                }
                field(ApplicantDesignation; Rec."Applicant Designation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applicant Designation field.';
                }
                field(PettyCash; Rec."Petty Cash")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Petty Cash field.';
                }
                field(SupplierInvoiceNo; Rec."Supplier Invoice No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supplier Invoice No. field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ImprestRequestNo; Rec."Imprest Request No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Imprest Request No field.';
                }
                field(BatchedImprestTot; Rec."Batched Imprest Tot")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Batched Imprest Tot field.';
                }
                field(FunctionName; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field(BudgetCenterName; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field(FarmerPurchaseNo; Rec."Farmer Purchase No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Farmer Purchase No field.';
                }
                field(TransporterAnanlysisNo; Rec."Transporter Ananlysis No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transporter Ananlysis No field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(JournalTemplate; Rec."Journal Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Journal Template field.';
                }
                field(JournalBatch; Rec."Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Journal Batch field.';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(RequireSurrender; Rec."Require Surrender")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Require Surrender field.';
                }
                field(CommitedAmmount; Rec."Commited Ammount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Commited Ammount field.';
                }
                field(SelecttoSurrender; Rec."Select to Surrender")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select to Surrender field.';
                }
                field(PaymentReference; Rec."Payment Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Reference field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(VATRate; Rec."VAT Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Rate field.';
                }
                field(AmountWithVAT; Rec."Amount With VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount With VAT field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(ExchangeRate; Rec."Exchange Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                }
                field(CurrencyReciprical; Rec."Currency Reciprical")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Reciprical field.';
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                }
                field(BudgetaryControlAC; Rec."Budgetary Control A/C")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budgetary Control A/C field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Committed field.';
                }
                field(CurrencyFactor; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field(NetAmountLCY; Rec."NetAmount LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the NetAmount LCY field.';
                }
                field(AppliestoDocType; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applies-to Doc. Type field.';
                }
                field(AppliestoDocNo; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applies-to Doc. No. field.';
                }
                field(AppliestoID; Rec."Applies-to ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applies-to ID field.';
                }
                field(RetentionCode; Rec."Retention Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retention Code field.';
                }
                field(RetentionAmount; Rec."Retention  Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retention  Amount field.';
                }
                field(RetentionRate; Rec."Retention Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retention Rate field.';
                }
                field(WTaxRate; Rec."W/Tax Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the W/Tax Rate field.';
                }
                field(VendorBankAccount; Rec."Vendor Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor Bank Account field.';
                }
                field(EFTBankAccountNo; Rec."EFT Bank Account No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the EFT Bank Account No field.';
                }
                field(EFTBankCode; Rec."EFT Bank Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the EFT Bank Code field.';
                }
                field(EFTAccountName; Rec."EFT Account Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the EFT Account Name field.';
                }
                field(EFTBranchNo; Rec."EFT Branch No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the EFT Branch No. field.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(DocumentNo; Rec."Document No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document No field.';
                }
                field(DocumentLine; Rec."Document Line")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Line field.';
                }
            }
        }
    }

    actions { }
}

