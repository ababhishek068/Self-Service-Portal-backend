Table 50878 "Activity Employees"
{

    fields
    {
        field(1; "Activity Code"; Code[20])
        {
            TableRelation = "Company Activities".Code;
        }
        field(2; "Employee No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(3; "Full Names"; Text[100]) { }
        field(4; Remarks; Text[200]) { }
    }

    keys
    {
        key(Key1; "Activity Code", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

