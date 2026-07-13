Report 50202 "Catering Sales Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CateringSalesSummary.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Menu Sale Header"; "Menu Sale Header")
        {
            DataItemTableView = where(Posted = const(true));
            RequestFilterFields = "Date Filter", "Cashier Name";
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
            column(LineAmount_MenuSaleHeader; "Menu Sale Header"."Line Amount") { }
            column(DailyTotalPrepayment_MenuSaleHeader; "Menu Sale Header"."Daily Total Prepayment") { }
            column(DailyTotalCash_MenuSaleHeader; "Menu Sale Header"."Daily Total Cash") { }
            column(Sum2; TotalCash + TotalPrep) { }
            column(UserTotalCash; TotalCash) { }
            column(UserTotalPrep; TotalPrep) { }
            column(TotalAmount; "Menu Sale Header"."Total Amount") { }
            column(TotalPrepayment_MenuSaleHeader; "Menu Sale Header"."Total Prepayment") { }
            column(TotalCash_MenuSaleHeader; "Menu Sale Header"."Total Cash") { }

            trigger OnAfterGetRecord()
            begin

                TotalCash := 0;
                TotalPrep := 0;
                SaleH.Reset;
                SaleH.SetRange(SaleH."Cashier Name", "Menu Sale Header"."Cashier Name");
                SaleH.SetFilter(SaleH.Date, "Menu Sale Header".GetFilter("Menu Sale Header".Date));
                if SaleH.Find('-') then begin
                    //  REPEAT
                    SaleH.CalcFields(SaleH."Daily Total Cash");
                    SaleH.CalcFields(SaleH."Daily Total Prepayment");
                    TotalCash := SaleH."Daily Total Cash";
                    TotalPrep := SaleH."Daily Total Prepayment";
                    // UNTIL SaleH.NEXT=0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Menu Sale Header".Date, GetFilter("Menu Sale Header"."Date Filter"));
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
        TotalCash: Decimal;
        SaleH: Record "Menu Sale Header";
        TotalPrep: Integer;
}

