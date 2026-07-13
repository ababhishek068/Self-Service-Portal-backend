Table 50254 "Project Team"
{

    fields
    {
        field(1; "Project No"; Code[20])
        {
            TableRelation = Projects.No;
        }
        field(2; "Team Member"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            var
                HREmployee: Record "HR-Employee";
            begin
                HREmployee.Reset;
                HREmployee.SetRange("No.", "Team Member");
                if HREmployee.Find('-') then
                    TestField("Project No");
                "Team Name" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";
            end;
        }
        field(3; "Team Name"; Text[150]) { }
        field(4; Client; Text[50])
        {
            CalcFormula = lookup(Projects."Customer Name" where(No = field("Project No")));
            FieldClass = FlowField;
        }
        field(5; "Project Status"; Option)
        {
            CalcFormula = lookup(Projects.Status where(No = field("Project No")));
            FieldClass = FlowField;
            OptionCaption = ' ,Ongoing,Suspended,Complete,On-call';
            OptionMembers = " ",Ongoing,Suspended,Complete,"On-call";
        }
    }

    keys
    {
        key(Key1; "Project No", "Team Member")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        TestField("Project No");
    end;
}

