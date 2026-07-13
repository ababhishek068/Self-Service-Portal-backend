query 50076 "Imprest Lines 2"
{
    Caption = 'Imprest Lines';
    QueryType = Normal;

    elements
    {
        dataitem(ImprestLines; "Imprest Lines")
        {
            column(AccountName; "Account Name") { }
            column(AccountNo; "Account No:") { }
            column(ActualSpent; "Actual Spent") { }
            column(AdvanceType; "Advance Type") { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount LCY") { }
            column(Applyto; "Apply to") { }
            column(ApplytoID; "Apply to ID") { }
            column(BankPettyCash; "Bank/Petty Cash") { }
            column(BudgetBalance; "Budget Balance") { }
            column(BudgetName; "Budget Name") { }
            column(BudgetaryControlAC; "Budgetary Control A/C") { }
            column(CashSurrenderAmt; "Cash Surrender Amt") { }
            column(Committed; Committed) { }
            column(CommittedAmount; "Committed Amount") { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(DailyRateAmount; "Daily Rate(Amount)") { }
            column(DateIssued; "Date Issued") { }
            column(DateTaken; "Date Taken") { }
            column(DeptVchNo; "Dept. Vch. No.") { }
            column(DestinationCode; "Destination Code") { }
            column(DimensionSetID; "Dimension Set ID") { }
            column(DueDate; "Due Date") { }
            column(EFTAccountName; "EFT Account Name") { }
            column(EFTBankAccountNo; "EFT Bank Account No") { }
            column(EFTBankCode; "EFT Bank Code") { }
            column(EmployeeJobGroup; "Employee Job Group") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(ImprestHolder; "Imprest Holder") { }
            column(ImprestType; "Imprest Type") { }
            column(ItemGLBudgetAccount; "Item G/L Budget Account") { }
            column(JobGroup; "Job Group") { }
            column(LastNotiffDate; "Last Notiff Date") { }
            column(LineNo; "Line No.") { }
            column(Location; Location) { }
            column(MRNo; "M.R. No") { }
            column(No; No) { }
            column(NoofDays; "No of Days") { }
            column(PostedtoPayroll; "Posted to Payroll") { }
            column(Purpose; Purpose) { }
            column(Quantity; Quantity) { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
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
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
