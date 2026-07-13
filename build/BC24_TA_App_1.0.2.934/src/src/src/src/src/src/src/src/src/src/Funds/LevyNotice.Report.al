report 50341 "Levy Notice"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("SASRA Annual Levy"; "SASRA Annual Levy")
        {
            RequestFilterFields = "Levy Year", "Customer No";
            column(Customer_No; "Customer No") { }
            column(Name; Name) { }
            column(Total_Deposit; "Total Deposit") { }
            column(Levy_Year; "Levy Year") { }
            column(Levy_Computation; "Levy Computation") { }
            column(Levy_Capped; "Levy Capped") { }
            column(Serial_No; "Serial No") { }
            column(CustName; CustName) { }
            column(CompInfName; CompInf.Name) { }
            column(CompInfLogo; CompInf.Picture) { }
            trigger OnAfterGetRecord()
            var
                Cust: Record customer;
            begin
                if Cust.get("Customer No") then
                    CustName := Cust.Name;
            end;
        }
    }


    trigger OnPreReport()
    begin
        CompInf.get;
        CompInf.CalcFields(Picture);
    end;



    var
        CompInf: Record "Company Information";
        CustName: Text[200];
}