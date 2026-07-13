Table 50519 "PR Income Tax"
{
    LookupPageId="PR Income Tax Setup";

    fields
    {
        field(1; "Tier Code"; Code[10])
        {
            SQLDataType = Integer;
        }
        field(2; "Income Tax Tier"; Decimal) { }
        field(3; Rate; Decimal) { }
        field(4; "Lower Limit"; Decimal) { }
        field(5; "Upper Limit"; Decimal) { }
        field(6;Relief;Decimal){}
    }

    keys
    {
        key(Key1; "Tier Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

