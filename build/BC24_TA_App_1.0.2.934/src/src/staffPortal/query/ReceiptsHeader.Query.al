namespace Hijra.Hijra;

query 50101 "Receipts Header"
{
    Caption = 'Receipts Header';
    QueryType = Normal;
    
    elements
    {
        dataitem(ReceiptsHeader; "Receipts Header")
        {
            column(No; "No.")
            {
            }
            column("Date"; "Date")
            {
            }
            column(Cashier; Cashier)
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(Posted; Posted)
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(BankCode; "Bank Code")
            {
            }
            column(ReceivedFrom; "Received From")
            {
            }
            column(OnBehalfOf; "On Behalf Of")
            {
            }
            column(AmountRecieved; "Amount Recieved")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(CurrencyFactor; "Currency Factor")
            {
            }
            column(TotalAmount; "Total Amount")
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(PrintNo; "Print No.")
            {
            }
            column(Status; Status)
            {
            }
            column(ChequeNo; "Cheque No.")
            {
            }
            column(NoPrinted; "No. Printed")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(CreatedDateTime; "Created Date Time")
            {
            }
            column(RegisterNo; "Register No.")
            {
            }
            column(FromEntryNo; "From Entry No.")
            {
            }
            column(ToEntryNo; "To Entry No.")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code")
            {
            }
            column(Dim3; Dim3)
            {
            }
            column(Dim4; Dim4)
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(ReceiptReference; "Receipt Reference")
            {
            }
            column(StaffNumber; "Staff Number")
            {
            }
            column(PatientNo; "Patient No.")
            {
            }
            column(PatientAppointmentNo; "Patient Appointment No")
            {
            }
            column(SurrenderNo; "Surrender No")
            {
            }
            column(ManualRefNumber; "Manual Ref.Number")
            {
            }
            column(ImprestNo; "Imprest No")
            {
            }
            column(PayMode1; "Pay Mode1")
            {
            }
            column(PharmacyNo; "Pharmacy No")
            {
            }
            column(LaboratoryNo; "Laboratory No")
            {
            }
            column(PhysiotheraphyNo; "Physiotheraphy No")
            {
            }
            column(PostedCount; "Posted Count")
            {
            }
            column(CashMode; "Cash Mode")
            {
            }
            column(FullyDisbursed; "Fully Disbursed")
            {
            }
            column(DisbursableAmount; "Disbursable Amount")
            {
            }
            column(InterBankNo; "InterBank No")
            {
            }
            column(PayMode; "Pay Mode")
            {
            }
            column(CustomerNo; "Customer No")
            {
            }
            column(SalesPerson; "Sales Person")
            {
            }
            column(ShiftNo; "Shift No")
            {
            }
            column(ShiftDiscount; "Shift Discount")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(CustomerCategory; "Customer Category")
            {
            }
            column(InvoiceNo; "Invoice No")
            {
            }
            column(Reversed; Reversed)
            {
            }
            column(Reversed2; Reversed2)
            {
            }
            column(NegotiatedExchangeRate; "Negotiated Exchange Rate")
            {
            }
            column(Description; Description)
            {
            }
            column(SystemId; SystemId)
            {
            }
        }
    }
    
    trigger OnBeforeOpen()
    begin
    
    end;
}
