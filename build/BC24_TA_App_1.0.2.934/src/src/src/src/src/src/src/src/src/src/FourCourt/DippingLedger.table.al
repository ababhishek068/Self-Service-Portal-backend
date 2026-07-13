table 50026 "Dipping Ledger"
{
    fields
    {
        field(1; "Line No."; Integer) { }
        FIELD(2; "Variance Quantity"; Decimal) { }
        field(3; "Item No."; Code[20]) { }
        field(4; "Posting Date"; Date) { }
        field(5; "Entry Type"; enum "Item Ledger Entry Type") { }
        field(6; "Source No."; Code[20]) { }
        field(7; "Document No."; Code[20]) { }
        field(8; Description; Text[100]) { }
        field(9; "Location Code"; Code[10]) { }
        field(10; "Inventory Posting Group"; Code[20]) { }
        FIELD(11; "Variance Amount"; Decimal) { }
        field(13; Quantity; Decimal) { }

        field(16; "Unit Amount"; Decimal) { }
        field(17; "Unit Cost"; Decimal) { }
        field(18; Amount; Decimal) { }

        field(23; "Salespers./Purch. Code"; Code[20]) { }
        field(34; "Shortcut Dimension 1 Code"; Code[20]) { }
        field(35; "Shortcut Dimension 2 Code"; Code[20]) { }

        field(60; "Document Date"; Date) { }

        field(79; "Document Type"; enum "Item Ledger Document Type") { }
        field(480; "Dimension Set ID"; Integer) { }
        field(5407; "Unit of Measure Code"; Code[10]) { }
        field(5704; "Item Category Code"; Code[20]) { }

        field(5842; "Dipping Time"; option)
        {
            OptionMembers = ,Morning,Evening;
        }




    }
    keys
    {
        key(Key1; "Document No.") { }
        key(Key4; "Item No.", "Posting Date") { }

    }
    var
}