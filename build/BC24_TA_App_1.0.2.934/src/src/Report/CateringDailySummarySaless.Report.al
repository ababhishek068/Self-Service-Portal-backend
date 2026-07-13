Report 50254 "Catering Daily Summary Saless"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CateringDailySummarySaless.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Menu Sale Header"; "Menu Sale Header")
        {
            DataItemTableView = where(Posted = const(true));
            RequestFilterFields = Date, "Sales Type";
            column(ReportForNavId_1; 1) { }
            column(ReceiptNo_MenuSaleHeader; "Menu Sale Header"."Receipt No") { }
            column(Date_MenuSaleHeader; "Menu Sale Header".Date) { }
            column(CashierNo_MenuSaleHeader; "Menu Sale Header"."Cashier No") { }
            column(CustomerType_MenuSaleHeader; "Menu Sale Header"."Customer Type") { }
            column(CustomerNo_MenuSaleHeader; "Menu Sale Header"."Customer No") { }
            column(CustomerName_MenuSaleHeader; "Menu Sale Header"."Customer Name") { }
            column(ReceivingBank_MenuSaleHeader; "Menu Sale Header"."Receiving Bank") { }
            column(Amount_MenuSaleHeader; "Menu Sale Header".Amount) { }
            column(Department_MenuSaleHeader; "Menu Sale Header".Department) { }
            column(ContactStaff_MenuSaleHeader; "Menu Sale Header"."Contact Staff") { }
            column(SalesPoint_MenuSaleHeader; "Menu Sale Header"."Sales Point") { }
            column(PaidAmount_MenuSaleHeader; "Menu Sale Header"."Paid Amount") { }
            column(Balance_MenuSaleHeader; "Menu Sale Header".Balance) { }
            column(Posted_MenuSaleHeader; "Menu Sale Header".Posted) { }
            column(CashierName_MenuSaleHeader; "Menu Sale Header"."Cashier Name") { }
            column(SalesType_MenuSaleHeader; "Menu Sale Header"."Sales Type") { }
            column(PrepaymentBalance_MenuSaleHeader; "Menu Sale Header"."Prepayment Balance") { }
            column(LastSc_MenuSaleHeader; "Menu Sale Header"."Last Sc") { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

