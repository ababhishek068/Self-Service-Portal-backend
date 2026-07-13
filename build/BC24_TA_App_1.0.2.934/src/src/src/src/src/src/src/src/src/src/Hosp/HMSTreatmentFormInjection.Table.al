Table 50585 "HMS Treatment Form Injection"
{

    fields
    {
        field(1; "Treatment No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Injection No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Injection".Code;

            trigger OnValidate()
            begin
                Injection.Reset;
                if Injection.Get("Injection No.") then begin
                    "Injection Name" := "Injection Name";
                    Item.Reset;
                    Item.Get(Injection."Item No.");
                    "Item No." := Item."No.";
                end;
            end;
        }
        field(3; "Injection Name"; Text[100])
        {
            CalcFormula = lookup("HMS Setup Injection".Description where(Code = field("Injection No.")));
            FieldClass = FlowField;
        }
        field(4; "Injection Given"; Boolean) { }
        field(5; "Injection Remarks"; Text[100]) { }
        field(6; "Injection Unit of Measure"; Code[20])
        {
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(7; "Injection Quantity"; Decimal) { }
        field(8; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(9; Location; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(10; Posted; Boolean) { }
        field(11; Duration; Text[30]) { }
    }

    keys
    {
        key(Key1; "Treatment No.", "Injection No.", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Item: Record Item;
        Injection: Record "HMS Setup Injection";
}

