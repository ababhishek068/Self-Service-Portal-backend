report 50319 "Receipts Details"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Receipt Line q"; "Receipt Line q")
        {
            RequestFilterFields = Date, Type;
            column(Type; Type) { }
            column(No; No) { }
            column(Date; Date) { }
            column(Account_Name; "Account Name") { }
            column(Transaction_Name; "Transaction Name") { }
            column(Amount; Amount) { }
            column(Transaction_No_; "Transaction No.") { }
            column(Pay_Mode; "Pay Mode") { }
            column(Cheque_Deposit_Slip_No; "Cheque/Deposit Slip No") { }
            column(Account_No_; "Account No.") { }
            column(CompInfLogo; CompInf.Picture) { }

            column(Station; Emp."Work Station") { }

            column(CompInfName; CompInf.Name) { }
            trigger OnPreDataItem()
            begin
                CompInf.get;
                CompInf.CalcFields(Picture);
            end;
        }

    }





    var
        CompInf: Record "Company Information";

        Emp: Record "HR-Employee";
}