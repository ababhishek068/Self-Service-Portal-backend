Table 50768 "HMS Laboratory Item Usage"
{

    fields
    {
        field(1; "Laboratory No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Laboratory Test Package Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Lab Package".Code;
        }
        field(3; "Laboratory Test Package Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Lab Package".Description where(Code = field("Laboratory Test Package Code")));
            FieldClass = FlowField;
        }
        field(4; "Laboratory Test Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Lab Package Test".Test where("Lab Package" = field("Laboratory Test Package Code"));
        }
        field(5; "Laboratory Test Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Lab Test".Description where(Code = field("Laboratory Test Code")));
            FieldClass = FlowField;
        }
        field(6; "Specimen Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HMS Setup Test Specimen".Specimen where(Test = field("Laboratory Test Code"));
        }
        field(7; "Specimen Name"; Text[30])
        {
            CalcFormula = lookup("HMS Setup Specimen".Description where(Code = field("Specimen Code")));
            FieldClass = FlowField;
        }
        field(8; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(9; "Item Name"; Text[30])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(10; "Item Quantity"; Decimal) { }
        field(11; Location; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(12; "Item Unit Of Measure"; Code[20])
        {
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(13; Posted; Boolean) { }
    }

    keys
    {
        key(Key1; "Laboratory No.", "Laboratory Test Package Code", "Laboratory Test Code", "Specimen Code", "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if Posted = true then begin Error('Record already posted') end;
    end;

    trigger OnModify()
    begin
        if Posted = true then begin Error('Record already posted') end;
    end;
}

