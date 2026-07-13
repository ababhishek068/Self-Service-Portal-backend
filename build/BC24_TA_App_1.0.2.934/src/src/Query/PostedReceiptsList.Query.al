query 50063 "Posted Receipts List"
{
    QueryType = Normal;

    elements
    {
        dataitem(Receipts_Header; "Receipts Header")
        {
            column(No; "No.") { }
            column(Customer_No; "Customer No") { }
            column(Surrender_No; "Surrender No") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
