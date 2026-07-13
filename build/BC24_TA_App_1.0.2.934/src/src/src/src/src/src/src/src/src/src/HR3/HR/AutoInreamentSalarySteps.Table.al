Table 50854 "Auto. Inreament Salary Steps"
{

    fields
    {
        field(1; "Employee Category"; Code[50])
        {
            NotBlank = true;
            TableRelation = "Employee Categories".Code;
        }
        field(2; "Salary Grade"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Sal Grades"."Salary Grade";
        }
        field(3; Step; Integer)
        {
            NotBlank = true;
        }
        field(4; "Basic Salary"; Decimal) { }
    }

    keys
    {
        key(Key1; "Employee Category", "Salary Grade", Step)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

