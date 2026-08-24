query 50075 "Imprest Headers"
{
    Caption = 'Imprest Header';
    QueryType = Normal;

    elements
    {
        dataitem(ImprestHeader; "Imprest Header")
        {
            column(AccountNo; "Account No.") { }
            column(AccountType; "Account Type") { }
            column(ActualExpenditure; "Actual Expenditure") { }
            column(BankName; "Bank Name") { }
            column(BudgetBalance; "Budget Balance") { }
            column(BudgetCenterName; "Budget Center Name") { }
            column(BudgetedAmount; "Budgeted Amount") { }
            column(CancellationRemarks; "Cancellation Remarks") { }
            column(Cashier; Cashier) { }
            column(ChequeNo; "Cheque No.") { }
            column(Committed; Committed) { }
            column(CommittedAmount; "Committed Amount") { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(CurrencyReciprical; "Currency Reciprical") { }
            column(CurrentSourceACBal; "Current Source A/C Bal.") { }
            column(CurrentStatus; "Current Status") { }
            column("Date"; "Date") { }
            column(DatePosted; "Date Posted") { }
            column(DateRequired; "Date Required") { }
            // UAT 18/07/2026: expose the real travel start date so the portal can show it.
            column(TravelStartDate; "Travel Start Date") { }
            column(Dim3; Dim3) { }
            column(Dim4; Dim4) { }
            column(Dim5; Dim5) { }
            column(DocumentType; "Document Type") { }
            column(EmployeeNo; "Employee No.") { }
            column(ExchangeRate; "Exchange Rate") { }
            column(ExpectedReturnDate; "Expected Return Date") { }
            column(FromEntryNo; "From Entry No.") { }
            column(FullyPaid; "Fully Paid") { }
            column(FunctionName; "Function Name") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(ImprestDueType; "Imprest Due Type") { }
            column(InvoiceCurrencyCode; "Invoice Currency Code") { }
            column(IsHOD; "Is HOD") { }
            column(MemoNo; "Memo No") { }
            column(NegotiatedExchangeRate; "Negotiated Exchange Rate") { }
            column(No; "No.") { }
            column(NoPrinted; "No. Printed") { }
            column(NoSeries; "No. Series") { }
            column(OnBehalfOf; "On Behalf Of") { }
            column(PVNo; "PV No") { }
            column(PayMode; "Pay Mode") { }
            column(Payee; Payee) { }
            column(PayingBankAccount; "Paying Bank Account") { }
            column(PaymentReleaseDate; "Payment Release Date") { }
            column(PaymentScheduleNo; "Payment Schedule No") { }
            column(PaymentType; "Payment Type") { }
            column(PaymentVoucherNo; "Payment Voucher No") { }
            column(Posted; Posted) { }
            column(PostedBy; "Posted By") { }
            column(PurchaseRequisition; "Purchase Requisition") { }
            column(Purpose; Purpose) { }
            column(RegisterNumber; "Register Number") { }
            column(RequestedBy; "Requested By") { }
            column(RequisitonType; "Requisiton Type") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(Select; Select) { }
            column(SerialNo; "Serial No.") { }
            column(SharedDepartment; "Shared Department") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code") { }
            column(Status; Status) { }
            column(SurrenderStatus; "Surrender Status") { }
            // UAT 23/07/2026: free-text travel destination (tableextension 52133).
            column(TravelDestination; "Travel Destination") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TimePosted; "Time Posted") { }
            column(ToEntryNo; "To Entry No.") { }
            column(VATBaseAmount; "VAT Base Amount") { }
            column(WorkActivity; "Work Activity") { }
            column(imprestTYpe; "imprest TYpe") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
