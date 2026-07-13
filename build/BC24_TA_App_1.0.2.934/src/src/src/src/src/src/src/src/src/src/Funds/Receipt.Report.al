Report 50200 Receipt
{
    DefaultLayout = RDLC;
    RDLCLayout = './NewLayouts/Receipt.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Receipt Header"; "Receipts Header")
        {
            DataItemTableView = where("Posted count" = filter(> 0));
            RequestFilterFields = "No.";
            column(ReportForNavId_3632; 3632) { }
            column(Directorate; "Receipt Header"."Global Dimension 1 Code") { }
            column(PayMode_ReceiptHeader; "Pay Mode") { }
            column(Department; "Receipt Header"."Shortcut Dimension 2 Code") { }

            column(Currency_Code; "Receipt Header"."Currency Code") { }
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(Received_From; "Receipt Header"."Received From") { }
            column(No_ReceiptHeader; "Receipt Header"."No.") { }
            column(Date; "Receipt Header".Date) { }
            column(VATRegistrationNo; CompanyInfo."VAT Registration No.") { }
            column(EMail; CompanyInfo."E-Mail") { }
            column(HomePage; CompanyInfo."Home Page") { }
            column(Picture; CompanyInfo.Picture) { }
            column(Address_1; CompanyInfo.Address) { }
            column(Address_2; CompanyInfo."Address 2") { }
            column(Dimension1; "Receipt Line"."Global Dimension 1 Code") { }
            column(AmountRecieved_ReceiptHeader; "Receipt Header"."Amount Recieved") { }
            column(Dimension2; "Receipt Line"."Dest Shortcut Dimension 2 Code") { }
            column(City; CompanyInfo.City) { }
            column(BankCode_ReceiptHeader; "Receipt Header"."Bank Code") { }
            column(BankName_ReceiptHeader; "Receipt Header"."Bank Name") { }
            column(Phone_No; CompanyInfo."Phone No.") { }
            column(Phone_No2; CompanyInfo."Phone No. 2") { }
            column(ReceivedFrom; "Receipt Header"."Received From") { }
            column(Cashier_ReceiptHeader; "Receipt Header".Cashier) { }
            column(CustomerName; "Receipt Header"."Customer No") { }
            column(CustomerAddress; "Receipt Header"."Customer No") { }
            dataitem("Receipt Line"; "Receipt Line q")
            {
                DataItemLink = No = field("No.");
                DataItemTableView = sorting("Line No.", No) order(ascending);
                column(ReportForNavId_7160; 7160) { }
                column(Description; "Receipt Line"."Account Name") { }
                column(LineNo_ReceiptLine; "Line No.") { }
                column(Amount; "Receipt Line".Amount) { }
                column(NumberText; NumberText[1]) { }
                column(AccountNo; "Receipt Line"."Account No.") { }
                column(Type; Type) { }
                column(Transaction_Name; "Transaction Name") { }
                column(Transaction_No_; "Transaction No.") { }

                trigger OnAfterGetRecord()
                begin
                    // Amount := Amount + "Receipt Line".Amount;
                    ////CheckReport.InitTextVariable;
                    CheckReport.FormatNoText(NumberText, "Receipt Header"."Amount Recieved", 0, '');

                    // strCurrency := "Receipt Header"."Currency Code";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                /*
                objLogos.RESET;
                 objLogos.SETRANGE(objLogos.Code,"Receipt Header"."Global Dimension 1 Code");
                IF objLogos.FIND('-') THEN BEGIN
                    objLogos.CALCFIELDS(objLogos.Picture);
                END ELSE BEGIN
                    objLogos.SETRANGE(objLogos.Default,TRUE);
                    objLogos.CALCFIELDS(objLogos.Picture);
                END;
                */
                if "Receipt Header"."Currency Code" = '' then "Receipt Header"."Currency Code" := 'USD';


            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
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
        CompanyInfo: Record "Company Information";
        CheckReport: Report "Check Translation Management";
        NumberText: array[2] of Text;

}

