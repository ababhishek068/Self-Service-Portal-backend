report 50324 "Tank Inventory"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem(Tanks; Tanks)
        {
            column(Tank_Code; "Tank Code") { }
            column(Description; Description) { }
            column(Availlable_Quantity; "Availlable Quantity") { }
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