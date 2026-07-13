Report 50204 "Catering Daily Summary Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CateringDailySummarySales.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Menu Sale Header"; "Menu Sale Header")
        {
            DataItemTableView = where(Posted = const(true));
            RequestFilterFields = Date, "Sales Type";
            column(ReportForNavId_1; 1) { }
            column(ReceiptNo_MenuSaleHeader; "Menu Sale Header"."Receipt No") { }
            column(Date_MenuSaleHeader; "Menu Sale Header".Date) { }
            column(CashierNo_MenuSaleHeader; "Menu Sale Header"."Cashier No") { }
            column(CustomerType_MenuSaleHeader; "Menu Sale Header"."Customer Type") { }
            column(CustomerNo_MenuSaleHeader; "Menu Sale Header"."Customer No") { }
            column(CustomerName_MenuSaleHeader; "Menu Sale Header"."Customer Name") { }
            column(ReceivingBank_MenuSaleHeader; "Menu Sale Header"."Receiving Bank") { }
            column(Amount_MenuSaleHeader; "Menu Sale Header".Amount) { }
            column(Department_MenuSaleHeader; "Menu Sale Header".Department) { }
            column(ContactStaff_MenuSaleHeader; "Menu Sale Header"."Contact Staff") { }
            column(SalesPoint_MenuSaleHeader; "Menu Sale Header"."Sales Point") { }
            column(PaidAmount_MenuSaleHeader; "Menu Sale Header"."Paid Amount") { }
            column(Balance_MenuSaleHeader; "Menu Sale Header".Balance) { }
            column(Posted_MenuSaleHeader; "Menu Sale Header".Posted) { }
            column(CashierName_MenuSaleHeader; "Menu Sale Header"."Cashier Name") { }
            column(SalesType_MenuSaleHeader; "Menu Sale Header"."Sales Type") { }
            column(PrepaymentBalance_MenuSaleHeader; "Menu Sale Header"."Prepayment Balance") { }
            column(LastSc_MenuSaleHeader; "Menu Sale Header"."Last Sc") { }
            column(UserTotalCash; TotalCash) { }
            column(UserTotalPrep; TotalPrep) { }

            trigger OnAfterGetRecord()
            begin
                /*
               TotalCash:=0;
               TotalPrep:=0;
               SaleH.RESET;
               SaleH.SETRANGE(SaleH."Cashier Name","Menu Sale Header"."Cashier Name");
               //SaleH.SETFILTER(SaleH.Date,"Menu Sale Header".GETFILTER("Menu Sale Header".Date));
               SaleH.SETRANGE(SaleH.Date,"Menu Sale Header".Date);
               IF SaleH.FIND('-') THEN BEGIN
               REPEAT
               SaleH.CALCFIELDS(SaleH."Total Cash");
               SaleH.CALCFIELDS(SaleH."Total Prepayment");
               TotalCash:=TotalCash+SaleH."Total Cash";
               TotalPrep:=TotalPrep+SaleH."Total Prepayment";
               UNTIL SaleH.NEXT=0;
               END;
                */

            end;

            trigger OnPostDataItem()
            begin

                if TransferMoney = true then begin

                    if SaleSetUp.Get() then begin
                        Temp := SaleSetUp."Sales Template";
                        Batch := SaleSetUp."Sales Batch";
                        SaleSetUp.TestField(SaleSetUp."Catering Income Account");
                        SaleSetUp.TestField(SaleSetUp."Catering Control Account");
                        SaleSetUp.TestField(SaleSetUp."Cash Receiving Bank Account");
                        SaleSetUp.TestField(SaleSetUp."MPESA Receiving Bank Account");
                        //SaleSetUp.TESTFIELD(SaleSetUp."PEPEA  Receiving Bank Account");
                        SaleSetUp.TestField(SaleSetUp."Card Payments Bank Account");
                        //SaleSetUp.TESTFIELD(SaleSetUp."Enterprise Meals Exp Account");


                        if "Sales Type" = "sales type"::Credit then
                            SaleSetUp.TestField(SaleSetUp."Department Meals Exp. Account");
                    end else begin
                        Error('Please Fill The Catering SetUp')
                    end;

                    "Receiving Bank" := SaleSetUp."Cash Receiving Bank Account";
                    if ("Sales Type" = "sales type"::Cash) then begin
                        TestField("Paid Amount");
                        GrnLine.Reset;
                        GrnLine.SetRange(GrnLine."Journal Template Name", Temp);
                        GrnLine.SetRange(GrnLine."Journal Batch Name", Batch);
                        if GrnLine.Find('-') then begin
                            GrnLine.DeleteAll;
                        end;

                        GrnLine.Init;
                        GrnLine."Journal Template Name" := Temp;
                        GrnLine."Journal Batch Name" := Batch;
                        GrnLine."Line No." := "Line No";
                        GrnLine."Account Type" := GrnLine."account type"::"Bank Account";
                        GrnLine."Account No." := "Receiving Bank";
                        GrnLine."Posting Date" := Date;
                        //  GrnLine."Document Type":=0;
                        GrnLine."Document No." := "Receipt No";
                        GrnLine.Description := 'Food Sale - ' + "Customer No";
                        GrnLine."Bal. Account No." := SaleSetUp."Catering Income Account";
                        GrnLine."Bal. Account Type" := GrnLine."bal. account type"::"G/L Account";
                        GrnLine.Amount := Amt;
                        //GrnLine."Shortcut Dimension 1 Code":='MAIN';
                        // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 1 Code");
                        // GrnLine."Shortcut Dimension 3 Code":='170';
                        // GrnLine.VALIDATE(GrnLine."Shortcut Dimension 2 Code");
                        GrnLine.Insert(true);
                    end;

                    if ("Sales Type" = "sales type"::"Other Sales") then begin
                        TestField("Paid Amount");
                        GrnLine.Reset;
                        GrnLine.SetRange(GrnLine."Journal Template Name", Temp);
                        GrnLine.SetRange(GrnLine."Journal Batch Name", Batch);
                        if GrnLine.Find('-') then begin
                            GrnLine.DeleteAll;
                        end;
                        GrnLine.Init;
                        GrnLine."Journal Template Name" := Temp;
                        GrnLine."Journal Batch Name" := Batch;
                        GrnLine."Line No." := "Line No";
                        GrnLine."Account Type" := GrnLine."account type"::"Bank Account";
                        GrnLine."Account No." := "Receiving Bank";
                        GrnLine."Posting Date" := Date;
                        // GrnLine."Document Type" := 0;
                        GrnLine."Document No." := "Receipt No";
                        GrnLine.Description := 'Cash Sale -' + "Transaction No.";
                        GrnLine."Bal. Account No." := SaleSetUp."Other Sales Exp Account";
                        GrnLine."Bal. Account Type" := GrnLine."bal. account type"::"G/L Account";
                        GrnLine.Amount := Amt;
                        GrnLine.Insert(true);
                    end;

                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(TransferMoney; TransferMoney)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer to bank';
                    ToolTip = 'Specifies the value of the Transfer to bank field.';
                }
            }
        }

        actions { }
    }

    labels { }

    var
        TotalCash: Integer;
        TotalPrep: Integer;
        TransferMoney: Boolean;
        Amt: Decimal;
        "Line No": Integer;
        GrnLine: Record "Gen. Journal Line";
        SaleSetUp: Record "Catering SetUp";
        Temp: Text[30];
        Batch: Text[30];
}

