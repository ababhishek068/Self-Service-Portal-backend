report 50322 "Station Summary"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Dimension Value"; "Dimension Value")
        {
            DataItemTableView = where("Fore Coart Station" = filter(true));


            column(Code; Code) { }
            column(Name; Name) { }
            column(Total_Income_Dept; "Total Income Dept") { }
            column(Total_Expenditure; "Total Expenditure") { }
            column(Total_Receipt; "Total Receipt") { }
            column(Total_Receipt_MPESA; "Total Receipt MPESA") { }
            column(Total_Receipt_Cash; "Total Receipt Cash") { }
            column(Total_Receipt_PDQ; "Total Receipt PDQ") { }

            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            column(IntBankAmount; IntBankAmount) { }
            column(InvoiceAmount; InvoiceAmount) { }
            column(PumpOuts; PumpOuts) { }
            column(startDate; startDate) { }
            column(EndDate; EndDate) { }
            trigger OnAfterGetRecord()


            begin

                IntBankAmount := 0;
                InvoiceAmount := 0;
                PumpOuts := 0;
                intBank.Reset();
                //intBank.SetFilter(Status, 'Posted');
                intBank.SetRange("Source Depot Code", Code);
                intBank.SetRange(Date, startDate, EndDate);
                if intBank.Find('-') then begin
                    repeat
                        IntBankAmount := intBank.Amount + IntBankAmount;
                    until intBank.next = 0

                end;
                Invoices.reset;
                Invoices.SetRange("Station Code", Code);
                Invoices.SetRange(Date, startDate, EndDate);
                Invoices.SetRange(Posted, true);
                if Invoices.Find('-') then begin
                    repeat
                        Invoices.CalcFields("Total Invoice Amount");
                        InvoiceAmount := invoiceAmount + Invoices."Total Invoice Amount"
                  until Invoices.next = 0;
                end;
                Creditmemo.Reset();
                Creditmemo.SetRange("Shortcut Dimension 1 Code", code);
                Creditmemo.SetRange("Posting Date", startDate, EndDate);
                //Creditmemo.SetRange();
                if Creditmemo.Find('-') then begin
                    repeat
                        PumpOuts := PumpOuts + Creditmemo."Amount Including VAT";
                    until Creditmemo.Next = 0;
                end;


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
                    field(startDate; startDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the startDate field.';

                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the EndDate field.';

                    }
                }
            }
        }
    }


    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
        //EVALUATE("Dimension Value"."Date Filter", 'startDate..EndDate');
    end;




    var
        CompInf: Record "Company Information";
        intBank: Record "InterBank Transfers";
        Invoices: Record "Pump Reading Header";
        IntBankAmount: Decimal;
        InvoiceAmount: Decimal;
        Creditmemo: Record "Sales Cr.Memo Line";
        PumpOuts: Decimal;
        startDate: date;
        EndDate: date;
}
