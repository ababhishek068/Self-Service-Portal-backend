report 50329 "Shift Allocation Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Shift Allocation Line"; "Shift Allocation Line")
        {
            RequestFilterFields = No, "Station Code", "Staff No";
            column(Staff_No; "Staff No") { }
            column(Staff_Name; "Staff Name") { }
            column(Station_Code; "Station Code") { }
            column(No; No) { }
            column(Shift_Sales_Amount; "Shift Sales Amount") { }
            column(Fuel_Type; "Fuel Type") { }
            column(Pump_Code; "Pump Code") { }
            column(PrevCashReading; PrevCashReading) { }
            column(PrevLitReading; PrevLitReading) { }
            column(PrevManReading; PrevManReading) { }
            column(Mpesa_Amount; "Mpesa Amount") { }
            column(Cash_Amount; "Cash Amount") { }
            column(Pump_Out_Amount; "Pump Out Amount") { }
            column(Return_Amount; "Return Amount") { }
            column(Credit_Amount; "Credit Amount") { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }

            dataitem("Pump_Attend_Invoice_Alloc."; "Pump Attend. Invoice Alloc.")
            {
                DataItemLinkReference = "Shift Allocation Line";
                DataItemLink = "Shift No" = field("No"), "Staff No" = field("Staff No");
                column(Customer_No; "Customer No") { }
                column(Names; Names) { }
                column(Driver_Names; "Driver Names") { }
                column(Amount; Amount) { }
                column(Reg_No_; "Reg No.") { }
            }

            trigger OnAfterGetRecord()
            begin
                PrevCashReading := 0;
                PrevLitReading := 0;
                PrevManReading := 0;
                if Pumps.get("Pump Code") then begin
                    PrevCashReading := Pumps."Last Elecl. Cash Reading";
                    PrevLitReading := Pumps."Last Elecl. Litres Reading";
                    PrevManReading := pumps."Last Manual Litres Reading";
                end;
            end;
        }

    }

    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
    end;


    var
        CompInf: Record "Company Information";
        Pumps: Record Pump;
        PrevLitReading: Decimal;
        PrevCashReading: Decimal;
        PrevManReading: Decimal;

}