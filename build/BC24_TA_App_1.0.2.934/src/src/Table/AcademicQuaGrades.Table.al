Table 50655 "Academic Qua Grades"
{

    fields
    {
        field(1; "Qualification Level"; Code[20])
        {
            //  TableRelation = "Payment Schedule Line".No;
        }
        field(2; "Grade Code"; Code[20]) { }
        field(3; Description; Text[50]) { }
    }

    keys
    {
        key(Key1; "Qualification Level", "Grade Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

