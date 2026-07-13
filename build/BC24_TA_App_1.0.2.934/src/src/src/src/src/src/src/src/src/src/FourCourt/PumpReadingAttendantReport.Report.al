report 50331 "Pump Reading Attendant Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Pump Reading Header"; "Pump Reading Header")
        {
            RequestFilterFields = "Station Code", "Shift No", Date, "Staff No";
            CalcFields = "Total Cash Amount", "Total Expenditure", "Total Invoice Amount", "Total MPESA Amount",
            "Total PDQ Amount", "Total Pump Return Amount", "Total PumpOut Amount", "Total Reading Amount";
            column(Station_Code; "Station Code") { }
            column(Date; Date) { }
            column(Staff_No; "Staff No") { }
            column(Staff_Name; "Staff Name") { }
            column(Shift_No; "Shift No") { }
            column(Total_Reading_Amount; "Total Reading Amount") { }
            column(Total_Cash_Amount; "Total Cash Amount") { }
            column(Total_Invoice_Amount; "Total Invoice Amount") { }
            column(Total_Expenditure; "Total Expenditure") { }
            column(Total_MPESA_Amount; "Total MPESA Amount") { }
            column(Total_PDQ_Amount; "Total PDQ Amount") { }
            column(Total_Pump_Return_Amount; "Total Pump Return Amount") { }


            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
        }
    }

    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
    end;

    var
        CompInf: Record "Company Information";
}