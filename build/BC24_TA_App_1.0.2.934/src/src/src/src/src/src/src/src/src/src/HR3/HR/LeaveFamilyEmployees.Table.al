Table 50638 "Leave Family Employees"
{

    fields
    {
        field(1; Family; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Employee No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
        }
        field(3; Remarks; Text[100]) { }
    }

    keys
    {
        key(Key1; Family, "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

