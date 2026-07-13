report 50325 "Pump Reading Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Pump Reading Line"; "Pump Reading Line")
        {
            RequestFilterFields = "Station Code", "Tank Code", "Pump Code", "Staff No";
            column(Tank_Code; "Tank Code") { }
            column(Pump_Code; "Pump Code") { }
            column(Station_Code; "Station Code") { }
            column(Quantity; Quantity) { }
            column(Amount; Amount) { }
            column(Unit_Price; "Unit Price") { }
            column(Unit_Discount; "Unit Discount") { }
            column(Electronic_Cash; "Electronic Cash") { }
            column(Electronic_Litres; "Electronic Litres") { }
            column(Manual_Litres; "Manual Litres") { }
            column(Staff_No; "Staff No") { }
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