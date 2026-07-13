report 50032 "Sales Per Item Summary"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Description; Description) { }
            column(CompInfName; CompInf.Name) { }
            column(CompInfLogo; CompInf.Picture) { }
            column(Item_Category_Code; "Item Category Code") { }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = field("No.");
                RequestFilterFields = "Posting Date", "Location Code";

                column(Quantity; Quantity) { }
                column(Location_Code; "Location Code") { }
                column(Posting_Date; "Posting Date") { }
                column(Document_Date; "Document Date") { }
                column(Sales_Amount__Actual_; "Sales Amount (Actual)") { }
                column(Cost_Amount__Actual_; "Cost Amount (Actual)") { }
                column(Item_Category_Code2; "Item Category Code") { }
                column(Entry_Type; "Entry Type") { }

                trigger OnAfterGetRecord()
                var

                begin


                end;



            }

        }
    }
    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
    end;

    var

        CompInf: Record "Company Information";

}