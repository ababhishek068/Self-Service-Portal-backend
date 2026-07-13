Table 50371 "Award Schedule"
{

    fields
    {
        field(1; No; Code[20]) { }
        field(2; "Item Description"; Text[30])
        {
            TableRelation = Item;
        }
        field(3; "Base Unit Of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure";
        }
        field(4; "Awarded Bidder"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(5; "Unit Price"; Decimal) { }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

