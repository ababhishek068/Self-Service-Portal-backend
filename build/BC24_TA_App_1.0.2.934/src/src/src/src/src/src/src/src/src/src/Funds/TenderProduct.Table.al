Table 50495 "Tender Product"
{

    fields
    {
        field(1; "Tender No"; Code[20])
        {
            TableRelation = Tender."Tender ID";
        }
        field(2; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(3; "Item Category"; Code[20]) { }
        field(4; "No."; Code[20]) { }
        field(5; Description; Text[250]) { }
        field(6; Quantity; Integer) { }
        field(7; "Unit of Measure"; Code[20]) { }
        field(8; "Created By"; Code[20]) { }
        field(9; "Date Created"; Date) { }
        field(10; Brand; Code[20]) { }
        field(11; "Average Annual Consumptionn"; Decimal) { }
        field(12; "Trade Discount"; Decimal) { }
        field(13; VAT; Decimal) { }
        field(14; "Net Price"; Decimal) { }
        field(15; "Current Price"; Decimal) { }
        field(16; "Pack Size"; Text[50]) { }
        field(17; "Annual Consumption"; Decimal) { }
        field(18; Specifications; Text[250]) { }
    }

    keys
    {
        key(Key1; "Tender No", Type, "No.")
        {
            Clustered = true;
        }
        key(Key2; "Item Category") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Date Created" := Today;
        "Created By" := UserId;
    end;
}

