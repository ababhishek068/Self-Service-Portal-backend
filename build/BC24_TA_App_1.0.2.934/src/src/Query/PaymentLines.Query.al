query 50081 "Payment Lines"
{
    Caption = 'Payment Lines';
    QueryType = Normal;

    elements
    {
        dataitem(PaymentLine; "Payment Line")
        {
            column(AccountName; "Account Name") { }
            column(AccountNo; "Account No.") { }
            column(AccountType; "Account Type") { }
            column(Amount; Amount) { }
            column(AmountTaxed; "Amount Taxed") { }
            column(AmountWithVAT; "Amount With VAT") { }
            column(ApplicantDesignation; "Applicant Designation") { }
            column(AppliestoDocNo; "Applies-to Doc. No.") { }
            column(AppliestoDocType; "Applies-to Doc. Type") { }
            column(AppliestoID; "Applies-to ID") { }
            column(Applyto; "Apply to") { }
            column(ApplytoID; "Apply to ID") { }
            column(Balance; Balance) { }
            column(BalanceLessthisEntry; "Balance Less this Entry") { }
            column(BankAccountNo; "Bank Account No") { }
            column(BankCode; "Bank Code") { }
            column(BankType; "Bank Type") { }
            column(BatchedImprestTot; "Batched Imprest Tot") { }
            column(BranchCode; "Branch Code") { }
            column(BudgetBalance; "Budget Balance") { }
            column(BudgetCenterName; "Budget Center Name") { }
            column(BudgetControlAC; "Budget Control A/C") { }
            column(BudgetName; "Budget Name") { }
            column(BudgetaryControlAC; "Budgetary Control A/C") { }
            column(BudgetedAmount; "Budgeted Amount") { }
            column(Cashier; Cashier) { }
            column(CashierBankAccount; "Cashier Bank Account") { }
            column(ChequeDate; "Cheque Date") { }
            column(ChequeNo; "Cheque No") { }
            column(ChequeType; "Cheque Type") { }
            column(CommisionAmount; "Commision Amount") { }
            column(Commission; Commission) { }
            column(Committed; Committed) { }
            column(CommittedAmount; "Committed Amount") { }
            column(CouncilClaim; "Council Claim") { }
            column(CouncilNo; "Council No.") { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(CurrencyReciprical; "Currency Reciprical") { }
            column("Date"; "Date") { }
            column(DatePosted; "Date Posted") { }
            column(DocumentLine; "Document Line") { }
            column(DocumentNo; "Document No") { }
            column(DocumentType; "Document Type") { }
            column(EFTAccountName; "EFT Account Name") { }
            column(EFTBankAccountNo; "EFT Bank Account No") { }
            column(EFTBankCode; "EFT Bank Code") { }
            column(EFTBranchNo; "EFT Branch No.") { }
            column(ExchangeRate; "Exchange Rate") { }
            column(ExciseAmount; "Excise  Amount") { }
            column(ExciseCode; "Excise Code") { }
            column(ExciseRate; "Excise Rate") { }
            column(FarmerPurchaseNo; "Farmer Purchase No") { }
            column(FunctionName; "Function Name") { }
            column(GLAccount; "G/L Account") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(Grouping; Grouping) { }
            column(IDNumber; "ID Number") { }
            column(ImprestRequestNo; "Imprest Request No") { }
            column(IncludeinVAT; "Include in VAT") { }
            column(Invested; Invested) { }
            column(JournalBatch; "Journal Batch") { }
            column(JournalTemplate; "Journal Template") { }
            column(KRA_Pin_No_;"KRA Pin No.") { }
            column(LPONo; "LPO No") { }
            column(LineNo; "Line No.") { }
            column(MedicalClaimType; "Medical Claim Type") { }
            column(MedicalRefNo; "Medical Ref. No") { }
            column(NetAmount; "Net Amount") { }
            column(NetAmountLCY; "NetAmount LCY") { }
            column(No; No) { }
            column(NoofUnits; "No of Units") { }
            column(NoSeries; "No. Series") { }
            column(NotVatable; "Not Vatable") { }
            column(OnBehalfOf; "On Behalf Of") { }
            column(PAYEAmount; "PAYE Amount") { }
            column(PAYECode; "PAYE Code") { }
            column(PAYERate; "PAYE Rate") { }
            column(POINVNo; "PO/INV No") { }
            column(PVType; "PV Type") { }
            column(PayMode; "Pay Mode") { }
            column(Payee; Payee) { }
            column(PayingBankAccount; "Paying Bank Account") { }
            column(PaymentReference; "Payment Reference") { }
            column(PaymentStatus; "Payment Status") { }
            column(PaymentType; "Payment Type") { }
            column(PettyCash; "Petty Cash") { }
            column(Posted; Posted) { }
            column(PostedBy; "Posted By") { }
            column(PostedDate; "Posted Date") { }
            column(Posteds; Posteds) { }
            column(ReceivedFrom; "Received From") { }
            column(Remarks; Remarks) { }
            column(RequireSurrender; "Require Surrender") { }
            column(RetentionAmount; "Retention  Amount") { }
            column(RetentionCode; "Retention Code") { }
            column(RetentionRate; "Retention Rate") { }
            column(SalesPerson; "Sales Person") { }
            column(Select; Select) { }
            column(SelecttoSurrender; "Select to Surrender") { }
            column(ShiftNo; "Shift No") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code") { }
            column(Status; Status) { }
            column(StudentNo; "Student No") { }
            column(SupplierInvoiceNo; "Supplier Invoice No.") { }
            column(SurrenderDate; "Surrender Date") { }
            column(SurrenderDocNo; "Surrender Doc. No") { }
            column(Surrendered; Surrendered) { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TimePosted; "Time Posted") { }
            column(TotalAllocation; "Total Allocation") { }
            column(TotalCommitments; "Total Commitments") { }
            column(TotalExpenditure; "Total Expenditure") { }
            column(TransactionName; "Transaction Name") { }
            column(TransporterAnanlysisNo; "Transporter Ananlysis No") { }
            column("Type"; "Type") { }
            column(UserID; "User ID") { }
            column(VATAmount; "VAT Amount") { }
            column(VATCode; "VAT Code") { }
            column(VATProdPostingGroup; "VAT Prod. Posting Group") { }
            column(VATRate; "VAT Rate") { }
            column(VATSixRate; "VAT Six % Rate") { }
            column(VATWithheldAmount; "VAT Withheld Amount") { }
            column(VATWithheldCode; "VAT Withheld Code") { }
            column(VendorBankAccount; "Vendor Bank Account") { }
            column(VoteBook; "Vote Book") { }
            column(WTaxRate; "W/Tax Rate") { }
            column(WithholdingTaxAmount; "Withholding Tax Amount") { }
            column(WithholdingTaxCode; "Withholding Tax Code") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
