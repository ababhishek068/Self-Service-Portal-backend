report 50334 "Sales Details Report3"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = where("Applied Credit Memo No" = filter(''));

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                RequestFilterFields = "Posting Date", "Location Code", "Bill-to Customer No.";
                column(No_; "No.") { }
                column(Document_No_; "Document No.") { }
                column(Description; Description) { }
                column(Posting_Date; "Posting Date") { }
                column(Posting_DateFilter; Getfilter("Posting Date")) { }
                column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
                column(Quantity; Quantity) { }
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
                column(Bill_to_Customer_No_; "Bill-to Customer No.") { }


                column(StaffNo; StaffNo) { }
                column(Converter; Converter) { }
                column(CustName; CustName) { }
                column(CompInfLogo; CompInf.Picture) { }
                column(CompInfName; CompInf.Name) { }
                dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                {
                    DataItemLink = "Applies To Doc No" = field("Document No.");
                    column(Quantity_CreditMemo; Quantity) { }
                    column(Amount_CreditMemo; Amount) { }
                    column(Line_Amount_CreditMemo; "Line Amount") { }
                    column(Amount_Including_VAT_CreditMemo; "Amount Including VAT") { }
                }
                trigger OnAfterGetRecord()
                var
                    SHeader: record "Sales Invoice Header";
                    Cust: record Customer;
                begin
                    sHeader.reset;
                    SHeader.setrange("No.", "Sales Invoice Line"."Document No.");
                    if SHeader.find('-') then begin
                        StaffNo := SHeader."Salesperson Code";
                    end;
                    if Cust.get("Bill-to Customer No.") then
                        CustName := Cust.Name;

                    Converter := 0;
                    if Itm.get("No.") then
                        Converter := Itm."Additional Convertion Rate";


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
        StaffNo: code[20];
        CustName: text[100];
        Itm: Record item;
        Converter: Decimal;
}