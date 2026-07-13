Report 50205 "Catering Sales Per Items"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CateringSalesPerItems.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Food Menu"; "Food Menu")
        {
            DataItemTableView = order(ascending) where("Total Quantity" = filter(> 0));
            RequestFilterFields = "Date Filter";
            column(ReportForNavId_1; 1) { }
            column(CompName; CompInf.Name) { }
            column(CompPic; CompInf.Picture) { }
            column(Code_FoodMenu; "Food Menu".Code) { }
            column(Description_FoodMenu; "Food Menu".Description) { }
            column(TotalQuantity_FoodMenu; "Food Menu"."Total Quantity") { }
            column(TotalAmount_FoodMenu; "Food Menu"."Total Amount") { }
            column(No; i) { }

            trigger OnAfterGetRecord()
            begin
                i := i + 1;
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
        CompInf: Record "Company Information";
        i: Integer;
}

