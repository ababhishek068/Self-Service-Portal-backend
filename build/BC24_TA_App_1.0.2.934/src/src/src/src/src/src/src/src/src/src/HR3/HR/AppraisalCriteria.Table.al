Table 50784 "Appraisal Criteria"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Criteria; Code[20]) { }
        field(3; Description; Text[100]) { }
        field(4; "Appraisal Year"; Code[50]) { }
    }

    keys
    {
        key(Key1; "Entry No", Criteria, "Appraisal Year")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Description; Description) { }
    }
}

