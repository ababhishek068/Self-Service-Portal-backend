Report 50252 "Receipts Collections2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ReceiptsCollections2.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Receipts Header"; "Receipts Header")
        {
            DataItemTableView = where(Reversed = filter(false), "Posted Count" = filter(> 0));
            RequestFilterFields = Date, Cashier, "Bank Code";
            column(ReportForNavId_1; 1) { }
            column(No_ReceiptsHeader; "Receipts Header"."No.") { }
            column(Date_ReceiptsHeader; "Receipts Header".Date) { }
            column(Cashier_ReceiptsHeader; "Receipts Header".Cashier) { }
            column(DatePosted_ReceiptsHeader; "Receipts Header"."Date Posted") { }
            column(TimePosted_ReceiptsHeader; "Receipts Header"."Time Posted") { }
            column(Posted_ReceiptsHeader; "Receipts Header".Posted) { }
            column(NoSeries_ReceiptsHeader; "Receipts Header"."No. Series") { }
            column(BankCode_ReceiptsHeader; "Receipts Header"."Bank Code") { }
            column(ReceivedFrom_ReceiptsHeader; "Receipts Header"."Received From") { }
            column(OnBehalfOf_ReceiptsHeader; "Receipts Header"."On Behalf Of") { }
            column(AmountRecieved_ReceiptsHeader; "Receipts Header"."Amount Recieved") { }
            column(GlobalDimension1Code_ReceiptsHeader; "Receipts Header"."Global Dimension 1 Code") { }
            column(ShortcutDimension2Code_ReceiptsHeader; "Receipts Header"."Shortcut Dimension 2 Code") { }
            column(CurrencyCode_ReceiptsHeader; "Receipts Header"."Currency Code") { }
            column(CurrencyFactor_ReceiptsHeader; "Receipts Header"."Currency Factor") { }
            column(TotalAmount_ReceiptsHeader; "Receipts Header"."Total Amount") { }
            column(PostedBy_ReceiptsHeader; "Receipts Header"."Posted By") { }
            column(PrintNo_ReceiptsHeader; "Receipts Header"."Print No.") { }
            column(Status_ReceiptsHeader; "Receipts Header".Status) { }
            column(ChequeNo_ReceiptsHeader; "Receipts Header"."Cheque No.") { }
            column(NoPrinted_ReceiptsHeader; "Receipts Header"."No. Printed") { }
            column(CreatedBy_ReceiptsHeader; "Receipts Header"."Created By") { }
            column(CreatedDateTime_ReceiptsHeader; "Receipts Header"."Created Date Time") { }
            column(RegisterNo_ReceiptsHeader; "Receipts Header"."Register No.") { }
            column(FromEntryNo_ReceiptsHeader; "Receipts Header"."From Entry No.") { }
            column(ToEntryNo_ReceiptsHeader; "Receipts Header"."To Entry No.") { }
            column(DocumentDate_ReceiptsHeader; "Receipts Header"."Document Date") { }
            column(ResponsibilityCenter_ReceiptsHeader; "Receipts Header"."Responsibility Center") { }
            column(ShortcutDimension3Code_ReceiptsHeader; "Receipts Header"."Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code_ReceiptsHeader; "Receipts Header"."Shortcut Dimension 4 Code") { }
            column(Dim3_ReceiptsHeader; "Receipts Header".Dim3) { }
            column(Dim4_ReceiptsHeader; "Receipts Header".Dim4) { }
            column(BankName_ReceiptsHeader; "Receipts Header"."Bank Name") { }
            column(ReceiptReference_ReceiptsHeader; "Receipts Header"."Receipt Reference") { }
            column(StaffNumber_ReceiptsHeader; "Receipts Header"."Staff Number") { }
            column(PatientNo_ReceiptsHeader; "Receipts Header"."Patient No.") { }
            column(PatientAppointmentNo_ReceiptsHeader; "Receipts Header"."Patient Appointment No") { }
            column(SurrenderNo_ReceiptsHeader; "Receipts Header"."Surrender No") { }
            column(ManualRefNumber_ReceiptsHeader; "Receipts Header"."Manual Ref.Number") { }
            column(ImprestNo_ReceiptsHeader; "Receipts Header"."Imprest No") { }

            column(PayMode_ReceiptsHeader; "Receipts Header"."Pay Mode1") { }
            column(PharmacyNo_ReceiptsHeader; "Receipts Header"."Pharmacy No") { }
            column(LaboratoryNo_ReceiptsHeader; "Receipts Header"."Laboratory No") { }
            column(PhysiotheraphyNo_ReceiptsHeader; "Receipts Header"."Physiotheraphy No") { }
            column(PostedCount_ReceiptsHeader; "Receipts Header"."Posted Count") { }
            column(CashMode_ReceiptsHeader; "Receipts Header"."Cash Mode") { }
            column(FullyDisbursed_ReceiptsHeader; "Receipts Header"."Fully Disbursed") { }
            column(DisbursableAmount_ReceiptsHeader; "Receipts Header"."Disbursable Amount") { }

            column(CompName; CompInf.Name) { }
            column(CompPic; CompInf.Picture) { }
            column(CustName; CustName) { }
            dataitem("Receipt Line q"; "Receipt Line q")
            {
                DataItemLink = No = field("No.");
                column(ReportForNavId_55; 55) { }
                column(Type; "Receipt Line q".Type) { }
                column(AccountType; "Receipt Line q"."Account Type") { }
                column(AccountNo; "Receipt Line q"."Account No.") { }
                column(ChequeNo; "Receipt Line q"."Cheque/Deposit Slip No") { }
                column(Amount_ReceiptLineq; "Receipt Line q".Amount) { }
                column(TotalAmount_ReceiptLineq; "Receipt Line q"."Total Amount") { }
                dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
                {
                    DataItemLink = "Document No." = field(No);
                    DataItemTableView = where(Reversed = filter(false));
                    column(ReportForNavId_61; 61) { }
                    column(Reversed_BankAccountLedgerEntry; "Bank Account Ledger Entry".Reversed) { }
                }

                trigger OnAfterGetRecord()
                begin
                    Cust.Reset;
                    Cust.SetRange(Cust."No.", "Receipt Line q"."Account No.");
                    if Cust.Find('-') then
                        CustName := Cust.Name;
                end;
            }

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        CompInf: Record "Company Information";
        Cust: Record Customer;
        CustName: Text[70];
}

