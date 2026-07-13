Table 50760 "Missing Tender Items"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
            NotBlank = true;
        }
        field(3; Summary; Text[250]) { }
        field(4; "PIN No"; Code[20])
        {
            TableRelation = Bidder."PIN No";
        }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
        key(Key2; "PIN No") { }
    }

    fieldgroups { }
}

