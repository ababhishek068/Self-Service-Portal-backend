Table 50109 "Application Setup Grade"
{
    LookupPageId = "Application Setup Grade List";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'Stores the grade in the database';
        }
        field(2; Grade; Text[30])
        {
            Description = 'Stores the description of the grade in the database';
        }
        field(3; Points; Decimal)
        {
            Description = 'Stores the points for the grade';
        }
        field(4; "Category"; Option)
        {
            OptionMembers = "",KCSE,IGSE,CUE,KNQA,International,University;
        }
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

