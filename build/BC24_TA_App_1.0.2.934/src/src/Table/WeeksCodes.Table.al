Table 50138 "Weeks Codes"
{
    DrillDownPageID = "Weeks  Codes";
    LookupPageID = "Weeks  Codes";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(6; "Day"; Code[20])
        {
            TableRelation = "Day Of Week";
        }
        field(2; Description; Text[30]) { }
        field(3; "Start Date"; Date) { }
        field(4; "End Date"; Date) { }
        field(5; "Order"; Integer) { }
        field(7; "Inactive"; Boolean) { }
    }

    keys
    {
        key(Key1; "Code", Day)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

