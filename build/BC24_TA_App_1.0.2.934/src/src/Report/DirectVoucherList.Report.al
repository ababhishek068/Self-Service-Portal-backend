report 50014 "Direct Voucher List"
{
    Caption = 'Direct Voucher List';
    ApplicationArea = All;
    dataset
    {
        dataitem(PaymentHeaderGreenCom; "Payment Header GreenCom")
        {
            column(ChequeNo; "Cheque No") { }
            column(DocumentDate; "Document Date") { }
            column(DocumentType; "Document Type") { }
            column(ModifiedDate; "Modified Date") { }
            column(NoSeries; "No. Series") { }
            column(PVNo; "PV No") { }
            column(PayingBank; "Paying Bank") { }
            column(PayingBankName; "Paying Bank Name") { }
            column(PaymentMode; "Payment Mode") { }
            column(PostingDescription; "Posting Description") { }
            column(RaisedBy; "Raised By") { }
            column(Status; Status) { }
            column(VendorName; "Vendor Name") { }
            column(VendorNo; "Vendor No.") { }
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
