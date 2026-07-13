Table 50582 "HMS Observation Form Injection"
{

    fields
    {
        field(1; "Observation No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Observation Form Header"."Observation No.";
        }
        field(2; "Injection No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Injection".Code;

            trigger OnValidate()
            begin
                Injection.Reset;
                Injection.Get("Injection No.");
                "Item No." := Injection."Item No.";
            end;
        }
        field(3; "Injection Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Injection".Description where(Code = field("Injection No.")));
            FieldClass = FlowField;
        }
        field(4; "Injection Date"; Date) { }
        field(5; "Injection Time"; Time) { }
        field(6; "Injection Remarks"; Text[100]) { }
        field(7; "Item No."; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Item."No.";
        }
        field(8; Location; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(9; "Item Unit Of Measure"; Code[20])
        {
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(10; Quantity; Decimal) { }
        field(11; Posted; Boolean) { }
        field(12; "Drug Name"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Observation No.", "Injection No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Injection: Record "HMS Setup Injection";
}

