Table 50378 "Project Components"
{

    fields
    {
        field(1; LineNo; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Components; Text[100]) { }
        field(4; "Project Code"; Code[10])
        {
            TableRelation = Jobs where("Grant Level" = filter("Sub-Grant"));
        }
    }

    keys
    {
        key(Key1; "Project Code", LineNo)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

