report 50303 "Sales Shipment Variance"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = where("Shipped Qty Variance" = filter(<> 0));
            RequestFilterFields = "Document No.", "Posting Date", "Sell-to Customer No.";
            column(Document_No_; "Document No.") { }
            column(Posting_Date; "Posting Date") { }
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Actual_Shipped_Qty; "Actual Shipped Qty") { }
            column(Shipped_Qty_Variance; "Shipped Qty Variance") { }
            column(Unit_Price; "Unit Price") { }
            column(VariancePrice; "Shipped Qty Variance" * "Unit Price") { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            trigger OnPreDataItem()
            begin
                CompInf.get;
                CompInf.CalcFields(Picture);
            end;
        }

    }




    var
        CompInf: Record "Company Information";
}