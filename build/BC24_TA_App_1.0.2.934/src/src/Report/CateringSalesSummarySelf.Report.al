Report 50203 "Catering Sales Summary-Self"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CateringSalesSummarySelf.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Menu Sale Header Self"; "Menu Sale Header Self")
        {
            RequestFilterFields = Date;
            column(ReportForNavId_1; 1) { }
            column(ReceiptNo_MenuSaleHeaderSelf; "Menu Sale Header Self"."Receipt No") { }
            column(Date_MenuSaleHeaderSelf; "Menu Sale Header Self".Date) { }
            column(CustomerType_MenuSaleHeaderSelf; "Menu Sale Header Self"."Customer Type") { }
            column(CustomerNo_MenuSaleHeaderSelf; "Menu Sale Header Self"."Customer No") { }
            column(CustomerName_MenuSaleHeaderSelf; "Menu Sale Header Self"."Customer Name") { }
            column(SalesPoint_MenuSaleHeaderSelf; "Menu Sale Header Self"."Sales Point") { }
            column(SalesType_MenuSaleHeaderSelf; "Menu Sale Header Self"."Sales Type") { }
            column(PrepaymentBalance_MenuSaleHeaderSelf; "Menu Sale Header Self"."Prepayment Balance") { }
            column(AmountTotals_MenuSaleHeaderSelf; "Menu Sale Header Self"."Amount Totals") { }

            trigger OnAfterGetRecord()
            begin
                /*
                 TotalCash:=0;
                TotalPrep:=0;
                SaleH.RESET;
               SaleH.SETRANGE(SaleH."Cashier Name","Menu Sale Header"."Cashier Name");
               SaleH.SETFILTER(SaleH.Date,"Menu Sale Header".GETFILTER("Menu Sale Header".Date));
               IF SaleH.FIND('-') THEN BEGIN
             //  REPEAT
               SaleH.CALCFIELDS(SaleH."Daily Total Cash");
               SaleH.CALCFIELDS(SaleH."Daily Total Prepayment");
               TotalCash:=SaleH."Daily Total Cash";
               TotalPrep:=SaleH."Daily Total Prepayment";
              // UNTIL SaleH.NEXT=0;
               END;
                */

            end;

            trigger OnPreDataItem()
            begin
                // SETFILTER("Menu Sale Header".Date,GETFILTER("Menu Sale Header"."Date Filter"));
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

