Table 50023 "New Tender Items"
{

    fields
    {
        field(1; "Item No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Item No.';
            Editable = false;
            NotBlank = false;
        }
        field(2; Description; Text[100]) { }
        field(3; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(5; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
            MinValue = 0;
        }
        field(6; "Questionaire No"; Integer)
        {
            Editable = false;
        }
        field(7; "Tender No."; Code[20])
        {
            TableRelation = Tender;
        }
        field(8; "TIN No."; Code[20])
        {
            Editable = true;
            TableRelation = Bidder;
        }
        field(9; "Receipt No."; Code[20])
        {
            Editable = false;
        }
        field(14; "Minimum Quantity"; Integer)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(5400; "Unit of Measure Code"; Code[200])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
        }
        field(5401; Brand; Text[250]) { }
        field(5402; Formulation; Text[250]) { }
        field(5403; "Unit Size"; Text[250]) { }
        field(5404; "Unit Trade/ W/Sale Price"; Decimal) { }
        field(5405; Discount; Decimal)
        {
            Editable = false;
        }
        field(5406; VAT; Decimal) { }
        field(5407; "Final Tender"; Decimal)
        {
            Editable = false;
        }
        field(5408; "Recommended Unit Retail Price"; Decimal) { }
        field(5409; Supplier; Text[250]) { }
        field(5410; Manufacturer; Text[250]) { }
        field(5411; "Pack Size"; Text[250]) { }
        field(5412; Remarks; Text[250]) { }
        field(5413; "Tender Result"; Text[250]) { }
        field(5414; Country; Code[20])
        {
            TableRelation = "Country/Region".Code;
        }
        field(5415; "Sample Required"; Boolean) { }
        field(5416; "Sample Size"; Decimal) { }
        field(5417; Company; Text[250]) { }
        field(5418; "Current Price"; Decimal)
        {

            trigger OnValidate()
            begin
                Variance := "Current Price" - "Final Tender";
            end;
        }
        field(5419; Variance; Decimal) { }
        field(5420; Prefered; Integer) { }
        field(5421; "Description 2"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
        key(Key2; "Tender No.", "TIN No.", "Receipt No.", "Item No.") { }
        key(Key3; "Unit of Measure Code") { }
        key(Key4; "Minimum Quantity") { }
        key(Key5; "Direct Unit Cost") { }
        key(Key6; "TIN No.") { }
        key(Key7; "TIN No.", "Direct Unit Cost") { }
        key(Key8; "Final Tender") { }
        key(Key9; "Tender No.") { }
        key(Key10; "Final Tender", "Tender No.", "Item No.") { }
        key(Key11; "Tender No.", "Final Tender") { }
    }

    fieldgroups { }
}

