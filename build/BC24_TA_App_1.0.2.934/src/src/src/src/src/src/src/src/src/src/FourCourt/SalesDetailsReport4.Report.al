report 50029 "Sales Details Report4"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Location Code", "Posting Date";

            column(Document_No_; "Document No.") { }
            column(Item_No_; "Item No.") { }

            column(Description; Description2) { }
            column(Posting_Date; "Posting Date") { }
            column(Posting_DateFilter; Getfilter("Posting Date")) { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Quantity; Quantity) { }
            column(Sales_Amount__Actual_; "Sales Amount (Actual)") { }
            column(Amount; Amount) { }
            column(Unit_Price; "Unit Price") { }
            column(VAT__; "VAT %") { }
            column(VAT_Base_Amount; "VAT Base Amount") { }
            column(Line_Amount; "Line Amount") { }
            column(Line_Discount_Amount; "Line Discount Amount") { }
            column(Driver_No; "Driver No") { }
            column(Truck_No; "Truck No") { }

            column(Order_No_; "Order No.") { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Source_No_; "Source No.") { }


            column(StaffNo; StaffNo) { }
            column(SalesPerson; StaffNo) { }
            column(Converter; Converter) { }
            column(CustName; CustName) { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            column(QuantityLtrs; QuantityLtrs) { }
            column(TotalQUantity; TotalQUantity) { }
            trigger OnAfterGetRecord()
            var
                SHeader: record "Sales Invoice Header";
                Cust: record Customer;
                SLines: Record "Sales Invoice Line";
                ScrMemo: record "Sales Cr.Memo Header";
            begin
                IF "Document Type" = "Document Type"::"Sales Invoice" THEN BEGIN
                    sHeader.reset;
                    SHeader.setrange("No.", "Item Ledger Entry"."Document No.");
                    if SHeader.find('-') then begin
                        StaffNo := SHeader."Salesperson Code";
                    end;
                END ELSE BEGIN
                    ScrMemo.reset;
                    ScrMemo.setrange("No.", "Item Ledger Entry"."Document No.");
                    if ScrMemo.find('-') then begin
                        StaffNo := ScrMemo."Salesperson Code";
                    end;
                END;

                if Cust.get("Source No.") then
                    CustName := Cust.Name;

                Converter := 0;
                if Itm.get("Item No.") then
                    Converter := Itm."Additional Convertion Rate";

                SLines.reset;
                SLines.SetRange("Document No.", "Item Ledger Entry"."Document No.");
                SLines.SetRange("Line No.", "Item Ledger Entry"."Document Line No.");
                IF SLines.Find('-') then begin
                    Amount := SLines.Amount;
                    Description2 := SLines.Description;
                    "Truck No" := SLines."Truck No";
                    "Driver No" := SLines."Driver No";
                    "Unit Price" := SLines."Unit Price";
                    "Line Amount" := SLines."Line Amount";
                    "Amount Including VAT" := SLines."Amount Including VAT";
                end;

                QuantityLtrs := 0;
                TotalQUantity := 0;

                QuantityLtrs := Converter * Quantity;
                TotalQUantity := TotalQUantity + Quantity;


            end;
        }


    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; StaffNo)
                    {
                        Caption = 'Sales Person';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Sales Person field.';

                    }
                }
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
        StaffNo: code[20];
        CustName: text[100];
        Itm: Record item;
        Converter: Decimal;
        QuantityLtrs: Decimal;
        TotalQUantity: Decimal;
        Amount: Decimal;
        "Unit Price": Decimal;
        "VAT %": Decimal;
        "VAT Base Amount": Decimal;
        "Line Amount": Decimal;
        "Line Discount Amount": Decimal;
        "Driver No": text[100];
        "Truck No": Text[10];
        "Amount Including VAT": Decimal;
        Description2: text[50];






}