Report 50187 "Catering Per Item Sales (Self)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CateringPerItemSalesSelf.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Menu Sales Line Self"; "Menu Sales Line Self")
        {
            RequestFilterFields = "Posting Date", "Receipt No";
            column(ReportForNavId_1; 1) { }
            column(ReceiptNo_MenuSalesLineSelf; "Menu Sales Line Self"."Receipt No") { }
            column(Menu_MenuSalesLineSelf; "Menu Sales Line Self".Menu) { }
            column(UnitCost_MenuSalesLineSelf; "Menu Sales Line Self"."Unit Cost") { }
            column(Quantity_MenuSalesLineSelf; "Menu Sales Line Self".Quantity) { }
            column(Amount_MenuSalesLineSelf; "Menu Sales Line Self".Amount) { }
            column(Description_MenuSalesLineSelf; "Menu Sales Line Self".Description) { }
            column(Date_MenuSalesLineSelf; "Menu Sales Line Self".GetFilter("Posting Date")) { }
            column(Qty_MenuSalesLineSelf; "Menu Sales Line Self".Qty) { }
            column(StudentNo_MenuSalesLineSelf; "Menu Sales Line Self".StudentNo) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

