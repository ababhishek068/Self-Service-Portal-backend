Table 50059 "Lecturers Claim Rates"
{

    fields
    {
        field(1; "Programme Category"; Option)
        {
            OptionCaption = ',Certificate,Diploma,Undergraduate,Masters,Post Graduate Diploma,PHD,Professional,Pre-University,Course List';
            OptionMembers = ,Certificate,Diploma,Undergraduate,Masters,"Post Graduate Diploma",PHD,Professional,"Pre-University","Course List";
        }
        field(2; "Students NUmbers"; Integer) { }
        field(3; Rate; Decimal) { }
    }

    keys
    {
        key(Key1; "Programme Category", "Students NUmbers")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

