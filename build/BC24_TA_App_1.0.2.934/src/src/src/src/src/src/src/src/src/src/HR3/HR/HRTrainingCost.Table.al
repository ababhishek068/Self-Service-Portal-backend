Table 50621 "HR Training Cost"
{
    DrillDownPageID = "HR Training Cost";
    LookupPageID = "HR Training Cost";

    fields
    {
        field(1; "Training Id"; Code[50])
        {
            NotBlank = true;
            TableRelation = "HR Training Applications"."Application No";
        }
        field(2; "Training Cost Item"; Code[30])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("Training Cost Items"));
        }
        field(3; Cost; Decimal) { }
    }

    keys
    {
        key(Key1; "Training Id", "Training Cost Item")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

