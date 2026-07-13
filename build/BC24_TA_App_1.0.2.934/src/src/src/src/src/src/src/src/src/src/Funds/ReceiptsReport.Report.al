Report 50083 "Receipts Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ReceiptsReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Receipts Header"; "Receipts Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1102755004; 1102755004) { }
            column(CompInfo; companyInfo.Name) { }
            column(CompAddr; companyInfo.Address) { }
            column(CompPhone; companyInfo."Phone No.") { }
            column(CompFax; companyInfo."E-Mail") { }
            column(CompPic; companyInfo.Picture) { }
            column(HeaderNo; "Receipts Header"."No.") { }
            column(HeaderDate; "Receipts Header".Date) { }
            column(UserID; "Receipts Header".Cashier) { }
            column(AcctName; AcctName) { }
            column(RegNo; RegNo) { }
            column(RecFrom; "Receipts Header"."Received From") { }
            column(CheqNo; "Receipts Header"."Cheque No.") { }
            column(AmountReceived; "Receipts Header"."Amount Recieved") { }
            column(UserName; UserName) { }
            column(pic; companyInfo.Picture) { }
            column(TotalAmount; TotalAmount) { }
            dataitem("Receipt Line q"; "Receipt Line q")
            {
                DataItemLink = No = field("No.");
                column(ReportForNavId_1102755006; 1102755006) { }
                column(RecLineNo; "Receipt Line q"."Account No.") { }
                column(RecLineAcctName; "Receipt Line q"."Account Name") { }
                column(Amount; "Receipt Line q".Amount) { }
                column(NumberText_1_; NumberText[1]) { }
                column(PayMode; "Receipt Line q"."Pay Mode") { }
                column(TRanName; "Receipt Line q"."Transaction Name") { }
                column(BankCode; "Receipt Line q"."Bank Code") { }
                column(ChequeDepositSlipNo; "Receipt Line q"."Cheque/Deposit Slip No") { }
                column(Account_No_; "Account No.") { }

                trigger OnAfterGetRecord()
                begin
                    //TotalAmount:=TotalAmount+"Receipt Line q".Amount;

                    ////CheckReport.InitTextVariable;
                    //CheckReport.FormatNoText(NumberText,TotalAmount,'');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmount := 0;

                Clear(UserName);
                UserName := "Receipts Header".Cashier;

                if usersTable.Get(Database.UserId) then begin
                    if usersTable.UserName <> '' then
                        UserName := usersTable.UserName
                end;
                //CheckReport.FormatNoText(NumberText,"Receipts Header"."Amount Recieved",'');

                //
                //CheckReport.FormatNoText(NumberText,"Receipts Header"."Amount Recieved",'');


                receiptLine.Reset;
                receiptLine.SetRange(receiptLine.No, "Receipts Header"."No.");
                if receiptLine.Find('-') then
                    repeat
                        TotalAmount := TotalAmount + receiptLine.Amount;
                    until receiptLine.Next = 0;

                //CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText, TotalAmount, 0,'');
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        companyInfo.Reset;
        if companyInfo.Find('-') then begin
            companyInfo.CalcFields(Picture);
        end;
    end;

    var
        AcctName: Text[150];
        RegNo: Code[30];
        NumberText: array[2] of Text[120];
        CheckReport: Report "Check Translation Management";
        TotalAmount: Decimal;
        UserName: Text[250];
        usersTable: Record "User Setup";
        companyInfo: Record "Company Information";
        receiptLine: Record "Receipt Line q";
}

