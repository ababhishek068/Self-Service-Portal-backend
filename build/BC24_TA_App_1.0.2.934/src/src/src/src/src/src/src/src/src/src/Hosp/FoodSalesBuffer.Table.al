Table 50662 "Food Sales Buffer"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Receipt No"; Code[20]) { }
        field(3; Menu; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin

                MenuRec.Reset;
                MenuRec.SetRange(MenuRec.Menu, Menu);
                if MenuRec.Find('-') then begin
                    Description := MenuRec.Description;
                    Quantity := 1;
                    "Unit Cost" := MenuRec."Unit Cost";
                    Amount := MenuRec."Unit Cost";
                    // IF MenuRec."Remaining Qty"<1 THEN ERROR('Please note that '+MenuRec.Description+' is out of stock in today menu');
                end;
            end;
        }
        field(4; "Unit Cost"; Decimal) { }
        field(5; Quantity; Decimal) { }
        field(6; Amount; Decimal) { }
        field(7; Description; Text[30]) { }
        field(8; Date; Date)
        {
            CalcFormula = lookup("Menu Sale Header".Date where("Receipt No" = field("Receipt No")));
            FieldClass = FlowField;
        }
        field(9; Qty; Decimal) { }
        field(10; Posted; Boolean)
        {
            CalcFormula = lookup("Menu Sale Header".Posted where("Receipt No" = field("Receipt No")));
            FieldClass = FlowField;
        }
        field(11; StudentNo; Code[30]) { }
        field(12; "Total Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Unit Cost" * Qty;
            end;
        }
    }

    keys
    {
        key(Key1; "Line No", "Receipt No")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        CalcFields(Posted);
        if Posted = true then
            Error('You cannot delete a posted receipt');
    end;

    var
        MenuRec: Record "Daily Menu";

}

