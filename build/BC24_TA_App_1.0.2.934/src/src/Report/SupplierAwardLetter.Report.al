report 50270 "Supplier Award Letter"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    //expiRDLCLayout = '';
    dataset
    {
        dataitem("RFQ Awards"; "RFQ Awards")
        {
            column(Vendor_No; "Vendor No") { }
            column(Vendor_Name; "Vendor Name") { }
            column(Awarded_By; "Awarded By") { }
            column(Date_of_Award; "Date of Award") { }
            column(Description; Description) { }
            column(Expiry_Date; "Expiry Date") { }
            column(Date_of_Acknowledgement; "Date of Acknowledgement") { }
        }

    }
}