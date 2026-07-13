query 50072 "Staff Claims Header"
{
    Caption = 'Staff Claims Header';
    QueryType = Normal;

    elements
    {
        dataitem(StaffClaimsHeader; "Staff Claims Header")
        {

            column(AccountNo; "Account No.") { }
            column(AccountType; "Account Type") { }
            column(BankName; "Bank Name") { }
            column(BudgetCenterName; "Budget Center Name") { }
            column(CancellationRemarks; "Cancellation Remarks") { }
            column(Cashier; Cashier) { }
            column(ChequeNo; "Cheque No.") { }
            column(ClaimFromImprest; "Claim From Imprest") { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(CurrencyReciprical; "Currency Reciprical") { }
            column(CurrentSourceACBal; "Current Source A/C Bal.") { }
            column(CurrentStatus; "Current Status") { }
            column("Date"; "Date") { }
            column(DatePosted; "Date Posted") { }
            column(Dim3; Dim3) { }
            column(Dim4; Dim4) { }
            column(DocumentType; "Document Type") { }
            column(EmployeeNo; "Employee No") { }
            column(ExchangeRate; "Exchange Rate") { }
            column(FromEntryNo; "From Entry No.") { }
            column(FullyPaid; "Fully Paid") { }
            column(FunctionName; "Function Name") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(ImprestDocNo; "Imprest Doc No") { }
            column(InvoiceCurrencyCode; "Invoice Currency Code") { }
            column(IsHOD; "Is HOD") { }
            column(No; "No.") { }
            column(NoPrinted; "No. Printed") { }
            column(NoSeries; "No. Series") { }
            column(OnBehalfOf; "On Behalf Of") { }
            column(PaidAmount; "Paid Amount") { }
            column(PayMode; "Pay Mode") { }
            column(Payee; Payee) { }
            column(PayingBankAccount; "Paying Bank Account") { }
            column(PaymentReleaseDate; "Payment Release Date") { }
            column(PaymentType; "Payment Type") { }
            column(PaymentVoucherNo; "Payment Voucher No") { }
            column(Posted; Posted) { }
            column(PostedBy; "Posted By") { }
            column(Purpose; Purpose) { }
            column(RegisterNumber; "Register Number") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(Select; Select) { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(Status; Status) { }
            column(SurrenderStatus; "Surrender Status") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TimePosted; "Time Posted") { }
            column(ToEntryNo; "To Entry No.") { }
            column(VATBaseAmount; "VAT Base Amount") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
