Report 50127 "Stock ledger and Control card"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/StockledgerandControlcard.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Item No.", "Posting Date", "Source No.", "Location Code";
            column(ReportForNavId_1; 1) { }
            column(Date; "Item Ledger Entry"."Posting Date") { }
            column(Document_No; "Item Ledger Entry"."Document No.") { }
            column(Supplier_Requisitioning_Office; "Item Ledger Entry"."Source No.") { }
            column(Quantity; "Item Ledger Entry".Quantity) { }
            column(Receipt; Receipt) { }
            column(InvoiceUnitPrice; InvoiceUnitPrice) { }
            column(Value; "Item Ledger Entry"."Cost Amount (Actual)") { }
            column(Issue; Issue) { }
            column(Balance; Balance) { }
            column(Item_Description; ItemDescription) { }
            column(Unit_of_Issue; UnitofIssue) { }
            column(Location; Location) { }
            column(ReceiptValue; ReceiptValue) { }
            column(IssueValue; IssueValue) { }
            column(Cost_Balance; ValueBal) { }
            column(AverageUnitPrice; AverageUnitPrice) { }

            trigger OnAfterGetRecord()
            begin
                Receipt := 0;
                Issue := 0;
                ReceiptValue := 0;
                IssueValue := 0;
                Balance := 0;
                InvoiceUnitPrice := 0;




                if "Item Ledger Entry".Positive = true then begin
                    Receipt := "Item Ledger Entry".Quantity;
                    ReceiptValue := "Item Ledger Entry"."Cost Amount (Actual)";
                    InvoiceUnitPrice := "Item Ledger Entry"."Cost Amount (Actual)" / "Item Ledger Entry".Quantity;

                    //IssueValue := FORMAT('');  //During receipts, issues should be null
                end else begin
                    Issue := 0 - "Item Ledger Entry".Quantity; //To register quantity as a positive
                    IssueValue := 0 - "Item Ledger Entry"."Cost Amount (Actual)";
                    AverageUnitPrice := "Item Ledger Entry"."Cost Amount (Actual)" / "Item Ledger Entry".Quantity;
                    // ReceiptValue := FORMAT(''); //During issues, receipts should be null
                end;

                //Keep track of running balances of total receipts and issues
                TotReceipt := TotReceipt + Receipt;
                TotIssue := TotIssue + Issue;
                Balance := TotReceipt - TotIssue;
                ValueBal := ValueBal + "Item Ledger Entry"."Cost Amount (Actual)";
            end;

            trigger OnPreDataItem()
            begin
                //Get item details for header
                Location := "Item Ledger Entry".GetFilter("Item Ledger Entry"."Location Code");
                ItemNo := "Item Ledger Entry".GetFilter("Item Ledger Entry"."Item No.");
                Item.SetRange(Item."No.", ItemNo);
                if Item.Find('-') then begin
                    ItemDescription := Item.Description;
                    UnitofIssue := Item."Base Unit of Measure";
                end;
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
        Receipt: Integer;
        Issue: Integer;
        Balance: Integer;
        TotReceipt: Integer;
        TotIssue: Integer;
        InvoiceUnitPrice: Decimal;
        ItemDescription: Text;
        UnitofIssue: Text;
        Location: Text;
        ItemNo: Text;
        Item: Record Item;
        ReceiptValue: Decimal;
        IssueValue: Decimal;
        ValueBal: Decimal;
        AverageUnitPrice: Decimal;
}

