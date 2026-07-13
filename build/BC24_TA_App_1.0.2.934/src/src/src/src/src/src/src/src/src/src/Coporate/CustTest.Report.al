report 50143 CustTest
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Customers List';
    DefaultLayout = RDLC;
    WordLayout = 'CustTest2.docx';
    RDLCLayout = 'CustTest2.rdlc';
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.") { }
            column(Name; Name) { }
        }
    }

}