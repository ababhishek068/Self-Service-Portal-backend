TableExtension 50018 SalesLineExt extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                CashTemp: Record "Cash Office User Template";
                UserSetup: Record "User Setup";
            begin
                if CashTemp.get(Database.UserID) then
                    if CashTemp."Default Location" <> '' then
                        "Location Code" := CashTemp."Default Location";
                if UserSetup.get(Database.UserId) then begin
                    if UserSetup."Global Dimension 1 Code" <> '' then
                        "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                    if UserSetup."Global Dimension 2 Code" <> '' then
                        "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                end;

            end;
        }
        field(50001; "Truck No"; code[20])
        {
            // TableRelation=fixed       

        }
        field(50002; "Driver No"; code[20])
        {

            TableRelation = "HR-Employee"."No.";
        }
        field(50003; "Qty to Invoice Forced"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Qty to Invoice Forced" > Quantity then
                    error('Invoice quantity can not be more than quantity');
                if "Qty to Invoice Forced" < 0 then
                    error('Invoice quantity can not be less than zero');

                "Line Amount" := "Qty to Invoice Forced" * "Unit Price";

            end;

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
        field(50006; "Purchase Unit of Measure"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Purch. Unit of Measure" where("No." = field("No.")));

        }

    }
}

