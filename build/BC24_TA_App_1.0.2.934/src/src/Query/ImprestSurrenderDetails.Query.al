query 50079 "Imprest Surrender Details"
{
    Caption = 'Imprest Surrender Details';
    QueryType = Normal;

    elements
    {
        dataitem(ImprestSurrenderDetails; "Imprest Surrender Details")
        {
            column(AccountName; "Account Name") { }
            
            column(AccountNo; "Account No:") { }
            column(ActualSpent; "Actual Spent") { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount LCY") { }
            column(Applyto; "Apply to") { }
            column(ApplytoID; "Apply to ID") { }
            column(BankPettyCash; "Bank/Petty Cash") { }
            column(CashPayMode; "Cash Pay Mode") { }
            column(CashReceiptAmount; "Cash Receipt Amount") { }
            column(CashReceiptNo; "Cash Receipt No") { }
            column(CashSurrenderAmt; "Cash Surrender Amt") { }
            column(CashSurrenderAmtLCY; "Cash Surrender Amt LCY") { }
            column(ChequeDepositSlipBank; "Cheque/Deposit Slip Bank") { }
            column(ChequeDepositSlipDate; "Cheque/Deposit Slip Date") { }
            column(ChequeDepositSlipNo; "Cheque/Deposit Slip No") { }
            column(ChequeDepositSlipType; "Cheque/Deposit Slip Type") { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(DateIssued; "Date Issued") { }
            column(DeptVchNo; "Dept. Vch. No.") { }
            column(DueDate; "Due Date") { }
            column(EntryNo; "Entry No") { }
            column(ImprestHolder; "Imprest Holder") { }
            column(ImprestReqAmtLCY; "Imprest Req Amt LCY") { }
            column(ImprestSurrenderType; "Imprest Surrender Type") { }
            column(ImprestType; "Imprest Type") { }
            column(Location; Location) { }
            column(OverExpenditure; "Over Expenditure") { }
            column(Quantity; Quantity) { }
            column(ShortcutDimension1Code; "Shortcut Dimension 1 Code") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code") { }
            column(ShortcutDimension6Code; "Shortcut Dimension 6 Code") { }
            column(ShortcutDimension7Code; "Shortcut Dimension 7 Code") { }
            column(ShortcutDimension8Code; "Shortcut Dimension 8 Code") { }
            column(SurrenderDate; "Surrender Date") { }
            column(SurrenderDocNo; "Surrender Doc No.") { }
            column(Surrendered; Surrendered) { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TypeofSurrender; "Type of Surrender") { }
            column(UnitCostLCY; "Unit Cost (LCY)") { }
            column(UnitofMeasure; "Unit of Measure") { }
            column(VATProdPostingGroup; "VAT Prod. Posting Group") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
