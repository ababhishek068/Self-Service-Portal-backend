Report 50347 "Customer Statement2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/StudentStatement.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1) { }
            column(Address_Customer; Customer.Address) { }
            column(Address2_Customer; Customer."Address 2") { }
            column(PhoneNo_Customer; Customer."Phone No.") { }
            column(No_Customer; Customer."No.") { }
            column(Name_Customer; Customer.Name) { }
            column(Balance_Customer; Customer.Balance) { }
            column(Balance__LCY_; "Balance (LCY)") { }

            column(Current_Programme; "Current Programme") { }
            column(CompName; CompInf.Name) { }
            column(CompLogo; CompInf.Picture) { }
            column(CompAdd1; CompInf.Address) { }
            column(CompAdd2; CompInf."Address 2") { }
            dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Customer No.", "Posting Date") order(ascending) where("Entry Type" = filter("Initial Entry"), Reversed = const(false), "Cust. Ledger Entry No." = filter(> 0));
                column(ReportForNavId_7; 7) { }
                column(PostingDate_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Posting Date") { }
                column(DocumentNo_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Document No.") { }
                column(Description_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry".Description) { }

                column(DebitAmountLCY_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Debit Amount (LCY)") { }
                column(CreditAmountLCY_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Credit Amount (LCY)") { }

                column(RuningBal; RuningBal) { }
                column(Semester; TransSemester) { }
                column(ProgName; ProgName) { }
                column(SchoolName; SchoolName) { }
                column(TransPrefix; CopyStr("Detailed Cust. Ledg. Entry"."Document No.", 1, 2)) { }
                column(Currency_Code; "Currency Code") { }
                column(SalesDesc; SalesDesc) { }
                column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }


                trigger OnAfterGetRecord()
                begin

                    // "Detailed Cust. Ledg. Entry".CalcFields("Charge Semester");
                    RuningBal := RuningBal + "Detailed Cust. Ledg. Entry"."Amount (LCY)";

                    //   TransSemester := "Detailed Cust. Ledg. Entry"."Charge Semester";
                    if TransSemester = '' then begin
                        Sem.Reset;
                        if Sem.Find('-') then begin
                            repeat
                                if ("Detailed Cust. Ledg. Entry"."Posting Date" > Sem.From) and ("Detailed Cust. Ledg. Entry"."Posting Date" < Sem."To") then begin
                                    TransSemester := Sem.Code;
                                end;
                            until Sem.Next = 0;
                        end;
                    end;
                    if Sem.get(TransSemester) then
                        TransSemester := Sem.Description;

                    SalesDesc := '';
                    Sline.reset;
                    Sline.setrange("Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    if sline.find('-') then begin
                        repeat
                            PriceIncVAT := 0;
                            IF Sline.Quantity <> 0 then
                                PriceIncVAT := ROUND(Sline."Amount Including VAT" / Sline.Quantity, 0.5, '=');
                            SalesDesc := SalesDesc + ' ' + Sline.Description + ', ' + Format(Sline.Quantity) + ' @ ' + Format(PriceIncVAT) + ' ' + ' Via ' + sline."Truck No";
                        until sline.next = 0;
                    end;
                end;
            }

            trigger OnAfterGetRecord()

            begin
                RuningBal := 0;
                if prog.get("Current Programme") then begin
                    ProgName := Prog.Description;
                    DimRec.reset;
                    dimrec.setrange(Code, Prog."School Code");
                    dimrec.setrange("Global Dimension No.", 3);
                    if Dimrec.Find('-') then
                        SchoolName := Dimrec.Name;
                end;

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

        layout { }

        actions { }
    }

    labels { }

    var
        Sem: Record Semesters;
        CompInf: Record "Company Information";
        RuningBal: Decimal;
        TransSemester: text[100];
        ProgName: text[150];
        SchoolName: text[150];
        // CustPost: Codeunit "Gen. Jnl.-Post Line";
        Prog: Record Programme;
        DimRec: Record "Dimension Value";
        Sline: Record "Sales Invoice Line";
        SalesDesc: Text[1000];
        PriceIncVAT: Decimal;
}

