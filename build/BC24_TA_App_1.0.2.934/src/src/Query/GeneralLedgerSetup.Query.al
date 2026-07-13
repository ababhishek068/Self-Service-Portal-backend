query 50069 "General Ledger Setup"
{
    Caption = 'General Ledger Setup';
    QueryType = Normal;

    elements
    {
        dataitem(GeneralLedgerSetup; "General Ledger Setup")
        {
            column(AdditionalReportingCurrency; "Additional Reporting Currency") { }
            column(AdjustARCJnlBatchName; "Adjust ARC Jnl. Batch Name") { }
            column(AdjustARCJnlTemplateName; "Adjust ARC Jnl. Template Name") { }
            column(AdjustforPaymentDisc; "Adjust for Payment Disc.") { }
            column(AllowDeferralPostingFrom; "Allow Deferral Posting From") { }
            column(AllowDeferralPostingTo; "Allow Deferral Posting To") { }
            column(AllowGLAccDeletionBefore; "Allow G/L Acc. Deletion Before") { }
            column(AllowPostingFrom; "Allow Posting From") { }
            column(AllowPostingTo; "Allow Posting To") { }
            column(AmountDecimalPlaces; "Amount Decimal Places") { }
            column(AmountRoundingPrecision; "Amount Rounding Precision") { }
            column(ApplnRoundingPrecision; "Appln. Rounding Precision") { }
            column(ApplyJnlBatchName; "Apply Jnl. Batch Name") { }
            column(ApplyJnlTemplateName; "Apply Jnl. Template Name") { }
            column(BankAccReconBatchName; "Bank Acc. Recon. Batch Name") { }
            column(BankAccReconTemplateName; "Bank Acc. Recon. Template Name") { }
            column(BankAccountNos; "Bank Account Nos.") { }
            column(BilltoSelltoVATCalc; "Bill-to/Sell-to VAT Calc.") { }
            column(BlockDeletionofGLAccounts; "Block Deletion of G/L Accounts") { }
            column(CheckGLAccountUsage; "Check G/L Account Usage") { }
            column(EMUCurrency; "EMU Currency") { }
            column(EnableDataCheck; "Enable Data Check") { }
            column(FinRepforBalanceSheet; "Fin. Rep. for Balance Sheet") { }
            column(FinRepforCashFlowStmt; "Fin. Rep. for Cash Flow Stmt") { }
            column(FinRepforIncomeStmt; "Fin. Rep. for Income Stmt.") { }
            column(FinRepforRetainedEarn; "Fin. Rep. for Retained Earn.") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(HidePaymentMethodCode; "Hide Payment Method Code") { }
            column(InvRoundingPrecisionLCY; "Inv. Rounding Precision (LCY)") { }
            column(InvRoundingTypeLCY; "Inv. Rounding Type (LCY)") { }
            column(JobQPrioforPostPrint; "Job Q. Prio. for Post & Print") { }
            column(JobQueueCategoryCode; "Job Queue Category Code") { }
            column(JobQueuePriorityforPost; "Job Queue Priority for Post") { }
            column(JobWIPJnlBatchName; "Job WIP Jnl. Batch Name") { }
            column(JobWIPJnlTemplateName; "Job WIP Jnl. Template Name") { }
            column(JournalTemplNameMandatory; "Journal Templ. Name Mandatory") { }
            column(LCYCode; "LCY Code") { }
            column(LastICTransactionNo; "Last IC Transaction No.") { }
            column(LocalAddressFormat; "Local Address Format") { }
            column(LocalContAddrFormat; "Local Cont. Addr. Format") { }
            column(LocalCurrencyDescription; "Local Currency Description") { }
            column(LocalCurrencySymbol; "Local Currency Symbol") { }
            column(MarkCrMemosasCorrections; "Mark Cr. Memos as Corrections") { }
            column(MaxPaymentToleranceAmount; "Max. Payment Tolerance Amount") { }
            column(MaxVATDifferenceAllowed; "Max. VAT Difference Allowed") { }
            column(NotifyOnSuccess; "Notify On Success") { }
            column(PaymentDiscountGracePeriod; "Payment Discount Grace Period") { }
            column(PaymentTolerance; "Payment Tolerance %") { }
            column(PaymentTolerancePosting; "Payment Tolerance Posting") { }
            column(PaymentToleranceWarning; "Payment Tolerance Warning") { }
            column(PayrollTransImportFormat; "Payroll Trans. Import Format") { }
            column(PmtDiscExclVAT; "Pmt. Disc. Excl. VAT") { }
            column(PmtDiscTolerancePosting; "Pmt. Disc. Tolerance Posting") { }
            column(PmtDiscToleranceWarning; "Pmt. Disc. Tolerance Warning") { }
            column(PostPrintwithJobQueue; "Post & Print with Job Queue") { }
            column(PostwithJobQueue; "Post with Job Queue") { }
            column(PostingPreviewType; "Posting Preview Type") { }
            column(PrepaymentUnrealizedVAT; "Prepayment Unrealized VAT") { }
            column(PrimaryKey; "Primary Key") { }
            column(PrintVATspecificationinLCY; "Print VAT specification in LCY") { }
            column(RegisterTime; "Register Time") { }
            column(ReportOutputType; "Report Output Type") { }
            column(ReqCountryRegCodeinAddr; "Req.Country/Reg. Code in Addr.") { }
            column(SEPAExportwoBankAccData; "SEPA Export w/o Bank Acc. Data") { }
            column(SEPANonEuroExport; "SEPA Non-Euro Export") { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code") { }
            column(ShortcutDimension6Code; "Shortcut Dimension 6 Code") { }
            column(ShortcutDimension7Code; "Shortcut Dimension 7 Code") { }
            column(ShortcutDimension8Code; "Shortcut Dimension 8 Code") { }
            column(ShowAmounts; "Show Amounts") { }
            column(SummarizeGLEntries; "Summarize G/L Entries") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TaxInvoiceRenamingThreshold; "Tax Invoice Renaming Threshold") { }
            column(UnitAmountDecimalPlaces; "Unit-Amount Decimal Places") { }
            column(UnitAmountRoundingPrecision; "Unit-Amount Rounding Precision") { }
            column(UnrealizedVAT; "Unrealized VAT") { }
            column(VATExchangeRateAdjustment; "VAT Exchange Rate Adjustment") { }
            column(VATReportingDate; "VAT Reporting Date") { }
            column(VATRoundingType; "VAT Rounding Type") { }
            column(VATTolerance; "VAT Tolerance %") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
