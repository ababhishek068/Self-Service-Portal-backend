table 50160 "Pump Reading Line"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(2; "Pump Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Pump.Code;
            trigger OnValidate()
            var
                Tank: Record Tanks;
                FuelType: Record "Fuel Type";
                Pump: Record Pump;
                PumpHeader: record "Pump Reading Header";
                TankReturnLine: Record "Return to Tank Line";
            begin
                PumpHeader.get(No);
                PumpHeader.TestField("Station Code");
                "Shift No" := PumpHeader."Shift No";

                if Pump.get("Pump Code") then begin

                    Pump.TestField("Tank Code");
                    Tank.get(Pump."Tank Code");
                    Tank.TestField("Fuel Type");
                    FuelType.get(Tank."Fuel Type");

                    "Unit Price" := GetBranchPrice(Tank."Fuel Type", PumpHeader."Station Code", PumpHeader.Date);
                    if "Unit Price" = 0 then
                        "Unit Price" := FuelType."Unit Price";
                    "Fuel Type" := Tank."Fuel Type";
                    "Tank Code" := Pump."Tank Code";
                    "Prev. Electronic Cash" := Pump."Last Elecl. Cash Reading";
                    "Prev. Electronic Ltrs" := Pump."Last Elecl. Litres Reading";
                    "Prev. Manual Ltrs" := Pump."Last Manual Litres Reading";

                    // error('Shift:' + "Shift No" + ' Tank:' + Pump."Tank Code" + ' Staff No:' + "Staff No" + ' Fuel:' + Tank."Fuel Type");
                    TankReturnLine.reset;
                    TankReturnLine.setrange("Shift No", "Shift No");
                    TankReturnLine.setrange("Tank Code", Pump."Tank Code");
                    TankReturnLine.setrange("Staff No", PumpHeader."Staff No");
                    TankReturnLine.setrange("Fuel Type", Tank."Fuel Type");
                    TankReturnLine.setrange("Pump Code", "Pump Code");
                    if TankReturnLine.find('-') then begin
                        "Tank Return Quantity" := TankReturnLine.Quantity;
                        "Tank Return Amount" := TankReturnLine.Quantity * FuelType."Unit Price";
                    end;
                end;
            end;
        }

        field(4; "Electronic Cash"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                CalcFields("Last Elect. Cash Reading");
                CalcFields("Max Electronic Cash Reading");
                if "Electronic Cash" < "Last Elect. Cash Reading" then
                    "Electronic Cash Qty Sold" := (("Electronic Cash" + "Max Electronic Cash Reading") - "Last Elect. Cash Reading") / ("Unit Price" - "Unit Discount")
                else
                    "Electronic Cash Qty Sold" := ("Electronic Cash" - "Last Elect. Cash Reading") / ("Unit Price" - "Unit Discount");

                CalculateQuantity();
            end;
        }
        field(41; "Electronic Cash Qty Sold"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Electronic Litres"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalcFields("Last Elect. Litres Reading");
                CalcFields("Max Electronic Litres Reading");
                if ("Electronic Litres" < "Last Elect. Litres Reading") then
                    "Electronic Litres Qty Sold" := (("Electronic Litres" + "Max Electronic Litres Reading") - "Last Elect. Litres Reading")
                else
                    "Electronic Litres Qty Sold" := ("Electronic Litres" - "Last Elect. Litres Reading");

                if "Electronic Litres Qty Sold" < 0 then
                    "Electronic Litres Qty Sold" := ("Max Electronic Litres Reading" - "Last Elect. Litres Reading" + "Electronic Litres");

                CalculateQuantity();
            end;

        }
        field(51; "Electronic Litres Qty Sold"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Manual Litres"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CalcFields("Last Manual Litres Reading");
                CalcFields("Max Manual Litres Reading");
                if ("Manual Litres" < "Last Manual Litres Reading") then
                    "Manual Litres Qty Sold" := (("Manual Litres" + "Max Manual Litres Reading") - "Last Manual Litres Reading")
                else
                    "Manual Litres Qty Sold" := ("Manual Litres" - "Last Manual Litres Reading");
                if "Manual Litres Qty Sold" < 0 then
                    "Manual Litres Qty Sold" := ("Max Manual Litres Reading" - "Last Manual Litres Reading" + "Manual Litres");

                CalculateQuantity();
            end;
        }
        field(61; "Manual Litres Qty Sold"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Unit Discount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(15; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;

        }
        field(16; "Last Elect. Litres Reading"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Pump."Last Elecl. Litres Reading" where(Code = field("Pump Code")));

        }
        field(17; "Last Elect. Cash Reading"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Pump."Last Elecl. Cash Reading" where(Code = field("Pump Code")));

        }
        field(18; "Last Manual Litres Reading"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Pump."Last Manual Litres Reading" where(Code = field("Pump Code")));

        }
        field(19; "Max Electronic Cash Reading"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Pump."Max Electronic Cash Reading" where(Code = field("Pump Code")));

        }
        field(20; "Max Electronic Litres Reading"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Pump."Max Electronic Litres Reading" where(Code = field("Pump Code")));

        }
        field(21; "Max Manual Litres Reading"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Pump."Max Manual Litres Reading" where(Code = field("Pump Code")));

        }
        field(22; "Fuel Type"; code[20])
        {
            TableRelation = "Fuel Type";

        }
        field(23; "Tank Code"; code[20])
        {
            TableRelation = Tanks."Tank Code";

        }
        field(24; "Unit of Measure"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Base Unit of Measure" where("No." = field("Fuel Type")));

        }
        field(25; "Staff No"; code[20])
        {
            TableRelation = "Salesperson/Purchaser".code;

        }
        field(26; "Shift No"; code[20])
        {
            // FieldClass = FlowField;
            // CalcFormula = lookup("Pump Reading Header"."Shift No" where(No = field(No)));
            TableRelation = "Shift Allocation".No where("Station Code" = field("Station Code"));

        }
        field(27; "Tank Return Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(28; "Tank Return Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(32; "Date"; date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Pump Reading Header".date where(No = field(No)));
        }
        field(33; "Prev. Electronic Ltrs"; Decimal) { }
        field(34; "Prev. Manual Ltrs"; Decimal) { }
        field(35; "Prev. Electronic Cash"; Decimal) { }

    }

    keys
    {
        key(Key1; No, "Line No")
        {
            Clustered = true;
        }
    }
    procedure CalculateQuantity()
    begin
        Quantity := "Electronic Cash Qty Sold";
        if "Electronic Cash Qty Sold" < 0 then
            "Electronic Cash Qty Sold" := ("Max Electronic Cash Reading" + "Last Elect. Cash Reading") / ("Unit Price" - "Unit Discount");

        if ("Electronic Cash Qty Sold" > "Electronic Litres Qty Sold") and ("Electronic Cash Qty Sold" > "Manual Litres Qty Sold") then
            Quantity := "Electronic Cash Qty Sold";

        if ("Electronic Litres Qty Sold" > "Electronic Cash Qty Sold") and ("Electronic Litres Qty Sold" > "Manual Litres Qty Sold") then
            Quantity := "Electronic Litres Qty Sold";
        if ("Manual Litres Qty Sold" > "Electronic Litres Qty Sold") and ("Manual Litres Qty Sold" > "Electronic Cash Qty Sold") then
            Quantity := "Electronic Litres Qty Sold";

        if Quantity < 0 then error('Invalid quantity');
        if (Quantity > 0) and ("Electronic Cash" - "Last Elect. Cash Reading" > 0) then
            "Unit Price" := ("Electronic Cash" - "Last Elect. Cash Reading") / Quantity;

        Amount := ("Unit Price" - "Unit Discount") * (Quantity);

    end;

    procedure GetBranchPrice(FuelType: code[20]; BranchCode: code[20]; sDate: date): Decimal
    var
        BranchPrices: record "Fuel Branch Pricing";
    begin
        BranchPrices.reset;
        BranchPrices.setrange("Branch Code", BranchCode);
        BranchPrices.setrange(Code, FuelType);
        BranchPrices.setrange(active, true);
        // BranchPrices.setfilter("Start Date", '%1..%2', sDate,Today);
        // BranchPrices.setfilter("End Date", '<=%1', sDate);
        if BranchPrices.find('-') then
            exit(BranchPrices."Unit Price");

    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}