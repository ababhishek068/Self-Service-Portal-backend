Table 50399 "Project Personnel Cost Alloc"
{

    fields
    {
        field(1; Project; Code[50])
        {
            TableRelation = Jobs;
        }
        field(2; "Employee No"; Code[50])
        {
            TableRelation = Resource;

            trigger OnValidate()
            begin
                Res.Get("Employee No");
                "Employee Name" := Res.Name;
            end;
        }
        field(3; "Employee Name"; Text[30]) { }
        field(4; "Project Role"; Code[30])
        {
            TableRelation = "Project Roles";

            trigger OnValidate()
            begin
                Projects.Get(Project);
                "Start Date" := Projects."Starting Date";
                "End Date" := Projects."Ending Date";
            end;
        }
        field(5; "Start Date"; Date) { }
        field(6; "End Date"; Date) { }
        field(7; "% Allocation Value"; Integer) { }
        field(8; comment; Text[200]) { }
        field(9; email; Text[50])
        {
            CalcFormula = lookup(Resource.Email where("No." = field("Employee No")));
            FieldClass = FlowField;
        }
        field(10; Telephone; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Project, "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Res: Record Resource;
        Projects: Record Jobs;
}

