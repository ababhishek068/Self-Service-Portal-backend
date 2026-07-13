Table 50574 "HMS Setup Injection"
{
    //  LookupPageID = UnknownPage70135123;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            NotBlank = true;
        }
        field(3; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(4; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(5; Amount; Decimal) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

