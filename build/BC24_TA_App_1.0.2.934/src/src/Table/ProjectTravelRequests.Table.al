Table 50136 "Project Travel Requests"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = false;
        }
        field(2; Project; Code[20])
        {
            TableRelation = Projects.No;

            trigger OnValidate()
            var
                Projects: Record Projects;
            begin
                Projects.Reset;
                Projects.SetRange(No, Project);
                if Projects.Find('-') then
                    Client := Projects."Customer Name";
            end;
        }
        field(3; "Project Activity"; Code[20])
        {
            TableRelation = "Project Task"."Activity Code" where("Project No" = field(Project));
        }
        field(4; "Date Requested"; Date) { }
        field(5; Status; Option)
        {
            OptionCaption = ' ,Open,Pending Processing,Processed';
            OptionMembers = " ",Open,"Pending Processing",Processed;
        }
        field(6; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(7; Client; Text[100])
        {
            CalcFormula = lookup(Projects."Customer Name" where(No = field(Project)));
            FieldClass = FlowField;
        }
        field(8; "No. Series"; Code[20]) { }
        field(9; "No of Teams"; Integer)
        {
            CalcFormula = count("Project Travel Request Lines" where(Code = field(Code)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if Code = '' then begin
           Code:= NoSeriesMgt.GetNextNo('STAFFTRAV',  0D, true);
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
}

