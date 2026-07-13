
report 50316 "Sales - Order Feedback"
{
    UsageCategory = Administration;
    ApplicationArea = All;


    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Posting_Date; "Posting Date") { }
        }
    }
}
