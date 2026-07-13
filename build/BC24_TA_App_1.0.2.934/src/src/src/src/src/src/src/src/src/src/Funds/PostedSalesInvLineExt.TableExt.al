TableExtension 50021 PostedSalesInvLineExt extends "Sales Invoice Line"
{
    fields
    {

        field(50001; "Truck No"; code[20])
        {

            // TableRelation = "Fixed Asset"."No." where("FA Posting Group" = filter('MOTOR VEHICLES'));
        }
        field(50002; "Driver No"; code[20])
        {

            // TableRelation = "HR-Employee"."No.";
        }
        field(50013; "Cash Sale"; Boolean)
        {

            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Cash Sale" where("No." = field("Document No.")));
        }

        field(50003; "Actual Shipped Qty"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Actual Shipped Qty" > Quantity then
                    error('Please note that Actual Shipped Qty can not be more than Invoice Qty');
                "Shipped Qty Variance" := Quantity - "Actual Shipped Qty";
            end;
        }
        field(50004; "Shipped Qty Variance"; Decimal) { }
        field(50064; "Closed"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header".Closed where("No." = field("Document No.")));
        }
        field(50005; "Pump Code"; code[20])
        {

            TableRelation = Pump.Code;
            trigger OnValidate()
            var
                PumpRec: Record Pump;

            begin
                if PumpRec.get("Pump Code") then
                    "Location Code" := PumpRec."Tank Code";
            end;
        }

    }
}

