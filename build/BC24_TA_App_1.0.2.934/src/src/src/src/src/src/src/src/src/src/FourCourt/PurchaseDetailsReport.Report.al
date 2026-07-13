report 50335 "Purchase Details Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            RequestFilterFields = "Document No.";
            //DataItemTableView = where(Closed = filter(false));
            column(No_; "No.") { }
            column(Document_No_; "Document No.") { }
            column(Description; Description) { }
            column(Posting_Date; "Posting Date") { }
            column(Posting_DateFilter; Getfilter("Posting Date")) { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(Quantity; Quantity) { }
            column(Amount; Amount) { }

            column(Unit_Cost; "Unit Cost") { }
            column(VAT__; "VAT %") { }
            column(VAT_Base_Amount; "VAT Base Amount") { }
            column(Line_Amount; "Line Amount") { }
            column(Line_Discount_Amount; "Line Discount Amount") { }



            column(Order_No_; "Order No.") { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Description_2; "Description 2") { }

            column(StaffNo; StaffNo) { }
            column(Converter; Converter) { }
            column(CustName; CustName) { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }

            trigger OnAfterGetRecord()
            var
                SHeader: record "Purch. Inv. Header";
                Cust: record Customer;
            begin
                sHeader.reset;
                SHeader.setrange("No.", "Purch. Inv. Line"."Document No.");
                if SHeader.find('-') then begin
                    // StaffNo := SHeader."Salesperson Code";
                end;
                if Cust.get("Buy-from Vendor No.") then
                    CustName := Cust.Name;

                Converter := 0;
                if Itm.get("No.") then
                    Converter := Itm."Additional Convertion Rate";
            end;
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
}