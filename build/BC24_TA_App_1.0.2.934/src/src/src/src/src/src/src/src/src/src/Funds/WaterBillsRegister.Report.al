report 50141 "Water Bills Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Waterbillsregister.rdlc';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Water Bill Register"; "Water Bill Register")
        {
            column(House_No; "House No") { }
            column(Meter_No; "Meter No") { }
            column(Prev__Reading; "Prev. Reading") { }
            column(Current_Reading; "Current Reading") { }
            column(Consumption_Cubic; "Consumption Cubic") { }
            column(Rate_PerCubic; "Rate PerCubic")
            {
                Caption = 'Rate Per Cubic Meter';
            }
            column(Amount; Amount) { }
            column(Bill_Arrears; "Bill Arrears") { }
            column(Total_Bill; "Total Bill") { }

            column(CompInfName; CompInf.Name) { }
            column(CompInflogo; CompInf.Picture) { }
        }
    }



    var
        CompInf: Record "Company Information";

    trigger OnPreReport()
    begin
        CompInf.get;
        CompInf.CalcFields(Picture);
    end;
}