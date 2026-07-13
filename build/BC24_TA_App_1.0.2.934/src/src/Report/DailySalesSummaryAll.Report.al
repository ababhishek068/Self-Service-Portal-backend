Report 50253 "Daily Sales Summary (All)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/DailySalesSummaryAll.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Menu Sale Header"; "Menu Sale Header")
        {
            DataItemTableView = sorting("Receipt No") order(ascending) where(Posted = const(true));
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Receipt No", Date, "Cashier Name";
            column(ReportForNavId_1; 1) { }
            column(ReceiptNo; "Menu Sale Header"."Receipt No") { }
            column(Date; "Menu Sale Header".Date) { }
            column(Amount; "Menu Sale Header".Amount) { }
            column(CashierName; "Menu Sale Header"."Cashier Name") { }

            trigger OnAfterGetRecord()
            begin

                //"Cafeteria Item Inventory".CALCFIELDS("Cafeteria Item Inventory"."Quantity Sold")
                // "Menu Sale Header".CALCFIELDS("Menu Sale Header".Amount);
            end;

            trigger OnPreDataItem()
            begin
                "Menu Sale Header".SetFilter("Menu Sale Header".Date, '=%1', datefilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(datefilter; datefilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sale Date';
                    ToolTip = 'Specifies the value of the Sale Date field.';
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport()
    begin
        //  datefilter:=TODAY;
    end;

    trigger OnPreReport()
    begin
        if datefilter = 0D then Error('Please specify the sale date.')
    end;

    var
        datefilter: Date;
}

