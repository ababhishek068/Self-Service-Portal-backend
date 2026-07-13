report 50033 "Vendor Statement1"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItemName; Vendor)
        {
            RequestFilterFields = "No.";

            column(Address_Customer; Address) { }
            column(Address2_Customer; "Address 2") { }
            column(PhoneNo_Customer; "Phone No.") { }
            column(No_Customer; "No.") { }
            column(Name_Customer; Name) { }
            column(Balance_Customer; Balance) { }
            column(Balance__LCY_; "Balance (LCY)") { }


            column(CompName; CompInf.Name) { }
            column(CompLogo; CompInf.Picture) { }
            column(CompAdd1; CompInf.Address) { }
            column(CompAdd2; CompInf."Address 2") { }
            dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
            {
                DataItemLink = "vendor no." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("vendor no.", "Posting Date") order(ascending) where("Entry Type" = filter("Initial Entry"), "Vendor Ledger Entry No." = filter(> 0));
                column(ReportForNavId_7; 7) { }
                column(PostingDate_DetailedCustLedgEntry; "Detailed Vendor Ledg. Entry"."Posting Date") { }
                column(DocumentNo_DetailedCustLedgEntry; "Detailed Vendor Ledg. Entry"."Document No.") { }

                column(DebitAmountLCY_DetailedCustLedgEntry; "Detailed Vendor Ledg. Entry"."Debit Amount (LCY)") { }
                column(CreditAmountLCY_DetailedCustLedgEntry; "Detailed Vendor Ledg. Entry"."Credit Amount (LCY)") { }

                column(RuningBal; RuningBal) { }
                column(Semester; TransSemester) { }
                column(ProgName; ProgName) { }
                column(SchoolName; SchoolName) { }
                column(TransPrefix; CopyStr("Detailed Vendor Ledg. Entry"."Document No.", 1, 2)) { }
                column(Currency_Code; "Currency Code") { }
                column(SalesDesc; SalesDesc) { }
                column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }
                column(vendorInv; vendorInv) { }


                trigger OnAfterGetRecord()
                begin

                    // "Detailed Cust. Ledg. Entry".CalcFields("Charge Semester");
                    RuningBal := RuningBal + "Detailed Vendor Ledg. Entry"."Amount (LCY)";

                    //   TransSemester := "Detailed Cust. Ledg. Entry"."Charge Semester";
                    if TransSemester = '' then begin
                        Sem.Reset;
                        if Sem.Find('-') then begin
                            repeat
                                if ("Detailed Vendor Ledg. Entry"."Posting Date" > Sem.From) and ("Detailed Vendor Ledg. Entry"."Posting Date" < Sem."To") then begin
                                    TransSemester := Sem.Code;
                                end;
                            until Sem.Next = 0;
                        end;
                    end;
                    if Sem.get(TransSemester) then
                        TransSemester := Sem.Description;

                    SalesDesc := '';
                    Sline.reset;
                    Sline.setrange("Document No.", "Detailed Vendor Ledg. Entry"."Document No.");
                    if sline.find('-') then begin
                        repeat
                            PriceIncVAT := 0;
                            IF Sline.Quantity <> 0 then
                                PriceIncVAT := ROUND(Sline."Amount Including VAT" / Sline.Quantity, 0.5, '=');
                            SalesDesc := SalesDesc + ' ' + Sline.Description + ', ' + Format(Sline.Quantity) + ' @ ' + Format(PriceIncVAT);
                        until sline.next = 0;
                    end;
                    vendorInv := '';
                    PurchHeader.reset;
                    PurchHeader.setrange("No.", "Detailed Vendor Ledg. Entry"."Document No.");
                    if PurchHeader.find('-') then begin
                        vendorInv := PurchHeader."Vendor Invoice No.";

                    end;
                end;


            }
            trigger OnAfterGetRecord()

            begin


            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName) { }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Executes the ActionName action.';

                }
            }
        }
    }

    var
        Sem: Record Semesters;
        CompInf: Record "Company Information";
        RuningBal: Decimal;
        TransSemester: text[100];
        ProgName: text[150];
        SchoolName: text[150];
        Sline: Record "Purch. Inv. Line";
        SalesDesc: Text[1000];
        PurchHeader: Record "Purch. Inv. Header";
        vendorInv: code[50];
        PriceIncVAT: Decimal;
}