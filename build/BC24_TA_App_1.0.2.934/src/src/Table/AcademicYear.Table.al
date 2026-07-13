Table 50038 "Academic Year"
{
    LookupPageId = "Academic Year List";
    DrillDownPageId = "Academic Year List";
    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'Stores the code of the academic year in the database';
        }
        field(2; Description; Text[30])
        {
            Description = 'Stores the description of the academic year';
        }
        field(3; From; Date)
        {
            Description = 'Stores the start date of the academic year in the database';
        }
        field(4; "To"; Date)
        {
            Description = 'Stores the end of the academic year in the database';
        }
        field(5; Current; Boolean) { }
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

