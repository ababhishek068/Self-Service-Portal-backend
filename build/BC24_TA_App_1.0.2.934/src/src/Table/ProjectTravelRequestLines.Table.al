Table 50028 "Project Travel Request Lines"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "Project Travel Requests".Code;
        }
        field(2; Project; Code[20])
        {
            TableRelation = Projects.No;
        }
        field(3; "Staff No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                HREmployee.Reset;
                HREmployee.SetRange("No.", "Staff No");
                if HREmployee.Find('-') then
                    "Staff Name" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";
            end;
        }
        field(4; "Staff Name"; Text[100]) { }
        field(5; "Project Activity"; Code[20])
        {
            TableRelation = "Project Task"."Activity Code" where("Project No" = field(Project));
        }
        field(6; "Start Date"; Date) { }
        field(7; "End Date"; Date) { }
        field(8; "Line No"; Integer)
        {
            AutoIncrement = true;
            MinValue = 1;
        }
        field(9; Amount; Decimal)
        {
            CalcFormula = sum("Travel Document Payment Lines".Amount where("Doc No" = field(Code),
                                                                            "Staff No" = field("Staff No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code", Project, "Staff No", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HREmployee: Record "HR-Employee";
}

