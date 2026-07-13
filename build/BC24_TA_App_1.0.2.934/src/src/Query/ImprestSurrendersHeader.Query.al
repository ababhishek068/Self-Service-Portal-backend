query 50078 "Imprest Surrenders Header"
{
    Caption = 'Imprest Surrenders Header';
    QueryType = Normal;

    elements
    {
        dataitem(ImprestSurrenderHeader; "Imprest Surrender Header")
        {
            column(AccountName; "Account Name") { }
            column(AccountNo; "Account No.") { }
            column(AccountType; "Account Type") { }
            column(Amount; Amount) { }
            column(ApplytoID; "Apply to ID") { }
            column(Balance; Balance) { }
            column(BalanceLessthisEntry; "Balance Less this Entry") { }
            column(BankAccountNo; "Bank Account No") { }
            column(BankCode; "Bank Code") { }
            column(BankType; "Bank Type") { }
            column(BudgetCenterName; "Budget Center Name") { }
            column(CashSurrenderAmt; "Cash Surrender Amt") { }
            column(Cashier; Cashier) { }
            column(CashierBankAccount; "Cashier Bank Account") { }
            column(ChequeDate; "Cheque Date") { }
            column(ChequeNo; "Cheque No") { }
            column(ChequeType; "Cheque Type") { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(DatePosted; "Date Posted") { }
            column(Dim3; Dim3) { }
            column(Dim4; Dim4) { }
            column(EmployeeNo; "Employee No") { }
            column(FinancialPeriod; "Financial Period") { }
            column(FunctionName; "Function Name") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(Grouping; Grouping) { }
            column(ImprestIssueDate; "Imprest Issue Date") { }
            column(ImprestIssueDocNo; "Imprest Issue Doc. No") { }
            column(ImprestSurrenderType; "Imprest Surrender Type") { }
            column(IsHOD; "Is HOD") { }
            column(IssueVoucherType; "Issue Voucher Type") { }
            column(NetAmount; "Net Amount") { }
            column(No; No) { }
            column(NoPrinted; "No. Printed") { }
            column(NoSeries; "No. Series") { }
            column(OnBehalfOf; "On Behalf Of") { }
            column(OpenApproverCount; "Open Approver Count") { }
            column(PVNo; "PV No") { }
            column(PVType; "PV Type") { }
            column(PayMode; "Pay Mode") { }
            column(Payee; Payee) { }
            column(PayingBankAccount; "Paying Bank Account") { }
            column(PaymentType; "Payment Type") { }
            column(PettyCash; "Petty Cash") { }
            column(Posted; Posted) { }
            column(PostedBy; "Posted By") { }
            column(PrintNo; "Print No.") { }
            column(ReceivedFrom; "Received From") { }
            column(Remarks; Remarks) { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code") { }
            column(Status; Status) { }
            column(SurrenderDate; "Surrender Date") { }
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
            column("Type"; "Type") { }
            column(UserID; "User ID") { }
            column(VoteBook; "Vote Book") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
