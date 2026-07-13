Report 50279 "Customer Statement 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CustomerStatement.rdlc';
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
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
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

                column(DebitAmountLCY_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Debit Amount") { }
                column(CreditAmountLCY_DetailedCustLedgEntry; "Detailed Cust. Ledg. Entry"."Credit Amount") { }

                column(RuningBal; RuningBal) { }
                column(PriceUSD; PriceUSD) { }
                column(Semester; TransSemester) { }
                column(ProgName; ProgName) { }
                column(SchoolName; SchoolName) { }
                column(TransPrefix; CopyStr("Detailed Cust. Ledg. Entry"."Document No.", 1, 2)) { }
                column(Currency_Code; "Currency Code") { }
                column(Transaction_No_; "Transaction No.") { }
                column(Driver; Driver) { }
                column(Truck; Truck) { }
                column(VATRate; VATRate) { }
                column(L20Quantity; L20Quantity) { }
                column(Observed; Observed) { }
                column(Description2; Description2) { }
                column(Lts; Lts) { }


                trigger OnAfterGetRecord()
                begin
                    //"Detailed Cust. Ledg. Entry".CalcFields(Stage);
                    //Description2 := "Detailed Cust. Ledg. Entry".Description;
                    Driver := '';
                    Truck := '';
                    VATRate := 0;
                    PriceUSD := 0;
                    L20Quantity := 0;
                    Observed := 0;

                    Lts := 0;
                    RuningBal := RuningBal + "Detailed Cust. Ledg. Entry".Amount;

                    Truck := '';

                    SalesInvHD.reset;
                    SalesInvHD.SetRange("No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    if SalesInvHD.find('-') then begin
                        // Driver := SalesInvLine."Driver No";
                        Truck := SalesInvHD."Ship-to Contact";
                        //VATRate := SalesInvLine."VAT %";
                    end;


                    SalesInvLine.reset;
                    SalesInvLine.SetRange("Document No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    if SalesInvLine.find('-') then begin
                        Driver := SalesInvLine."Driver No";
                        //Truck := SalesInvLine."Truck No";
                        VATRate := SalesInvLine."VAT %";
                        Observed := SalesInvLine."Unit Volume";
                        //kimeturamba
                        Lts := SalesInvLine.Quantity;
                        itemRec.Reset;
                        itemRec.SetRange(itemRec."No.", SalesInvLine."No.");
                        if itemRec.Find('-') then begin
                            itemCategory.Reset;
                            itemCategory.SetRange(itemCategory.Code, itemRec."Item Category Code");
                            if itemCategory.Find('-') then
                                ProductType := itemCategory.Description;
                            // Message(ProductType);

                        end;
                        Description2 := "Detailed Cust. Ledg. Entry".Description + ' ' + Truck + ' ' + ProductType;


                        //kimeturamba
                        cust2.Reset;
                        cust2.SetRange(cust2."No.", "Detailed Cust. Ledg. Entry"."Customer No.");
                        if cust2.Find('-') then begin
                            currencyCode := cust2."Currency Code";

                            Inv.Reset;
                            Inv.SetRange(Inv."No.", "Detailed Cust. Ledg. Entry"."Document No.");
                            Inv.SetRange(Inv."Currency Code", currencyCode);
                            if Inv.Find('-') = true then begin
                                if currencyCode <> '' then
                                    PriceUSD := SalesInvLine."Unit Price" else
                                    PriceUSD := 0;
                            end;

                        end;
                    end;

                    SalesInvHD.reset;
                    SalesInvHD.SetRange("No.", "Detailed Cust. Ledg. Entry"."Document No.");
                    if SalesInvHD.find('-') then begin
                        // Driver := SalesInvLine."Driver No";
                        Truck := SalesInvHD."Ship-to Contact";
                        //VATRate := SalesInvLine."VAT %";
                    end;

                end;
            }

            trigger OnAfterGetRecord()

            begin

                RuningBal := 0;

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
        //Sem: Record Semesters;
        CompInf: Record "Company Information";
        RuningBal: Decimal;

        PriceUSD: Decimal;
        Observed: decimal;
        L20Quantity: Decimal;
        TransSemester: text[100];
        ProgName: text[150];
        SchoolName: text[150];

        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHD: Record "Sales Invoice Header";

        Driver: text[100];

        Truck: text[50];
        VATRate: Decimal;
        Inv: Record "Sales Invoice Header";
        cust2: Record Customer;
        currencyCode: Code[20];
        Lts: Decimal;
        ProductType: Text[100];
        itemCategory: Record "Item Category";
        itemRec: Record Item;
        Description2: Text[500];
}

