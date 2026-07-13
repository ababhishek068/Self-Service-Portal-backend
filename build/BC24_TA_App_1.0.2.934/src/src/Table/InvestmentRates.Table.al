Table 50722 "Investment Rates"
{
    DrillDownPageID = "Investment Rates";
    LookupPageID = "Investment Rates";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Rate; Decimal) { }
        field(3; Type; Option)
        {
            OptionCaption = ' ,Interest,Withholding Tax,Weighted Average,Withholding Rent';
            OptionMembers = " ",Interest,"Withholding Tax","Weighted Average","Withholding Rent";
        }
    }

    keys
    {
        key(Key1; "Code", Rate)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

