Query 50029 "HMS Transaction Code"
{

    elements
    {
        dataitem(HMS_Transactions_code; "HMS Transactions code")
        {
            column(Transaction_Type; "Transaction Type") { }
            column(Description; Description) { }
            column(Income_G_L_Account; "Income G/L Account") { }
            column(Expense_G_L_Account; "Expense G/L Account") { }
            column(Calculate_Doctor_Fee; "Calculate Doctor Fee") { }
            column(Calculate_Insurance_Fee; "Calculate Insurance Fee") { }
            column(Amount; Amount) { }
        }
    }
}

