report 50031 "Sales By Customer Details"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; "Item Ledger Entry")
        {
            column(Source_No_; "Source No.") { }
            column(Document_No_; "Document No.") { }
            column(Sales_Amount__Actual_; "Sales Amount (Actual)") { }
            column(Document_Type; "Document Type") { }
            column(Posting_Date; "Posting Date") { }
            column(Item_No_; "Item No.") { }
            column(Quantity; Quantity) { }
            column(ItemName; ItemName) { }
            column(CustName; CustName) { }
            column(SalesPrice; SalesPrice) { }
            column(CompInfName; CompInf.Name) { }
            column(CompInf; CompInf.Picture) { }
            column(Entry_Type; "Entry Type") { }


            trigger OnAfterGetRecord()
            var
                cust: Record Customer;
                salesInv: record "Sales Invoice Line";
                item: Record Item;
            begin
                cust.Reset();
                if cust.get("Source No.") then
                    CustName := cust.Name;

                salesInv.Reset();
                salesInv.SetRange("Document No.", "Document No.");
                salesInv.SetRange("Line No.", "Document Line No.");
                if salesInv.find('-') then begin
                    SalesPrice := salesInv."Unit Price";

                end;

                item.reset();
                if item.get() then
                    ItemName := item.Description;



            end;



        }
    }

    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
    end;


    var
        SalesPrice: Decimal;
        ItemName: text[50];
        CustName: text[100];
        CompInf: Record "Company Information";

}