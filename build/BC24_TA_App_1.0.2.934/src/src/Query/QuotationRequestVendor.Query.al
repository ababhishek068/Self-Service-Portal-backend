query 50048 "Quotation Request Vendor"
{

    elements
    {
        dataitem(Quotation_Request_Vendors; "Quotation Request Vendors")
        {
            column(Requisition_Document_No; "Requisition Document No.") { }
            column(Vendor_No; "Vendor No.") { }
            column(Vendor_Name; "Vendor Name") { }
            column(Request_Summary; "Request Summary") { }
            dataitem(Purchase_Quote_Header; "Purchase Quote Header")
            {
                DataItemLink = "No." = Quotation_Request_Vendors."Requisition Document No.";
                column(Request_Description; "Request Description") { }
                column(Location; "Location Code") { }
                column(Expected_Closing_Date; "Expected Closing Date") { }
                column(Status; Status) { }
                column(Request_Description1; "Request Description") { }
                column(Posting_Description; "Posting Description") { }
                column(Document_Date; "Document Date") { }
                column(Document_Type; "Document Type") { }
            }
        }
    }
}

