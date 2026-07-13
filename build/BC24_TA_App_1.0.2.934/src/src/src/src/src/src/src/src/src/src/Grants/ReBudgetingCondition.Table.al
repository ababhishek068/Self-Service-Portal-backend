Table 50379 "Re-Budgeting Condition"
{

    fields
    {
        field(1; LineNo; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Re-Budgeting Condition"; Text[100]) { }
        field(3; Date; Date) { }
        field(4; "Project Code"; Code[10]) { }
    }

    keys
    {
        key(Key1; LineNo, "Project Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

