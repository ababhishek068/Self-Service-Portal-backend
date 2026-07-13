report 50326 "Pump Reading Complete Report"
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
            column(Manual_Litres_Qty_Sold; "Manual Litres Qty Sold") { }
            column(Electronic_Cash_Qty_Sold; "Electronic Cash Qty Sold") { }
            column(Electronic_Litres_Qty_Sold; "Electronic Litres Qty Sold") { }
            column(Last_Elect__Cash_Reading; "Last Elect. Cash Reading") { }
            column(Last_Elect__Litres_Reading; "Last Elect. Litres Reading") { }
            column(Last_Manual_Litres_Reading; "Last Manual Litres Reading") { }

            column(Staff_No; "Staff No") { }
            column(CompInfLogo; CompInf.Picture) { }
            column(CompInfName; CompInf.Name) { }
            column(Shift_No; "Shift No") { }
            column(PMS; PMS) { }
            column(AGO; AGO) { }
            column(total; total) { }
            column(Date; Date) { }
            trigger OnAfterGetRecord()

            begin


            end;


        }

    }

    trigger OnPreReport()
    begin
        CompInf.get();
        CompInf.CalcFields(Picture);
        PMS := 0;
        AGO := 0;
        ReceiptsHeader.Reset();
        IF ReceiptsHeader.Find('-') THEN
            repeat
                ReceiptsHeader.CalcFields(Reversed);
                ReceiptsHeader.Reversed2 := ReceiptsHeader.Reversed;
                ReceiptsHeader.Modify();
            UNTIL ReceiptsHeader.Next = 0;
    end;

    trigger OnPostReport()
    begin
        if "Pump Reading Line"."Fuel Type" = 'PMS' then
            pms := pms + "Pump Reading Line".Quantity
        else
            AGO := AGO + "Pump Reading Line".Quantity;
        total := total + "Pump Reading Line".Quantity;

    end;

    var
        CompInf: Record "Company Information";
        AGO: Decimal;
        PMS: Decimal;
        total: Decimal;
        ReceiptsHeader: Record "Receipts Header";
}