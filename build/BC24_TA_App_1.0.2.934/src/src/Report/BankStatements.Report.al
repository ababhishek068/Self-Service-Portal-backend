report 50272 "Bank Statements"
{
    ApplicationArea = All;
    Caption = 'Bank Statements';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(BankAccountLedgerEntry; "Bank Account Ledger Entry")
        {
            column(Bank_Account_No_; "Bank Account No.") { }
            column(BalAccountNo; "Bal. Account No.") { }
            column(DocumentDate; "Document Date") { }
            column(DocumentNo; "Document No.") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(DebitAmount; "Debit Amount") { }
            column(CreditAmount; "Credit Amount") { }
            column(DebitAmountLCY; "Debit Amount (LCY)") { }
            column(CreditAmountLCY; "Credit Amount (LCY)") { }
            column(Amount; Amount) { }
            column(Description; Description) { }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }
        actions
        {
            area(processing) { }
        }
    }
}
