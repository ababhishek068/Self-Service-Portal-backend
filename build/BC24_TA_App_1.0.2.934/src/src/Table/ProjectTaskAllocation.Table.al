Table 50255 "Project Task Allocation"
{

    fields
    {
        field(2; "Project No"; Code[20])
        {
            TableRelation = Projects.No;
        }
        field(3; "Project Activity"; Code[20])
        {
            TableRelation = "Project Activity".Code;
        }
        field(4; "Project Module"; Code[20])
        {
            TableRelation = "Project Modules".Code;
        }
        field(5; "Start Date"; Date) { }
        field(6; "End Date"; Date) { }
        field(7; Status; Option)
        {
            OptionCaption = ' ,Open,Pending Confirmation,Closed,On-Going';
            OptionMembers = " ",Open,"Pending Confirmation",Closed,"On-Going";

            trigger OnValidate()
            var
                ProjectSupport: Record "Project Support";
            begin
                ProjectSupport.Reset;
                ProjectSupport.SetRange("Project No", "Project No");
                ProjectSupport.SetRange("Entry No", "Support Entry No");
                if ProjectSupport.Find('-') then begin
                    if Status = Status::Open then
                        ProjectSupport.Status := ProjectSupport.Status::Open;
                    if Status = Status::"Pending Confirmation" then
                        ProjectSupport.Status := ProjectSupport.Status::"Pending Client Confirmation";
                    if Status = Status::Closed then
                        ProjectSupport.Status := ProjectSupport.Status::Closed;

                    ProjectSupport.Modify;
                end;
            end;
        }
        field(8; "Staff No"; Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Status = const(Active));

            trigger OnValidate()
            var
                HREmployee: Record "HR-Employee";
            begin
                HREmployee.Reset;
                HREmployee.SetRange("No.", "Staff No");
                if HREmployee.Find('-') then
                    "Staff Name" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";
            end;
        }
        field(9; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(10; "Allocation Type"; Option)
        {
            CalcFormula = lookup(Projects."Project Type" where(No = field("Project No")));
            FieldClass = FlowField;
            OptionCaption = ' ,Implementation,Support';
            OptionMembers = " ",Implementation,Support;
        }
        field(11; "Support Entry No"; Integer) { }
        field(12; "Allocation Remarks"; Text[100]) { }
        field(13; "Solution Remarks"; Text[200]) { }
        field(14; "Solution Type"; Option)
        {
            OptionCaption = ' ,Customization,Training,Data,Advice,Not Possible,Upgrade Recommended';
            OptionMembers = " ",Customization,Training,Data,Advice,"Not Possible","Upgrade Recommended";
        }
        field(15; "Support Issue Description"; Text[250])
        {
            CalcFormula = lookup("Project Support"."Issue Description" where("Entry No" = field("Support Entry No")));
            FieldClass = FlowField;
        }
        field(16; Customer; Text[250])
        {
            CalcFormula = lookup(Projects."Customer Name" where(No = field("Project No")));
            FieldClass = FlowField;
        }
        field(17; "Staff Name"; Text[100]) { }
        field(18; "Last Closure Remarks"; Text[200]) { }
        field(19; "Consoltant Status"; Option)
        {
            OptionCaption = ' ,Assigned,Re-Assigned';
            OptionMembers = " ",Assigned,"Re-Assigned";
        }
        field(20; "Reason For Re-Allocation"; Text[250]) { }
        field(21; "Task Closure Exist"; Boolean)
        {
            CalcFormula = exist("Projects Task Closure" where("Task Entry No" = field("Support Entry No")));
            FieldClass = FlowField;
        }
        field(22; "Date Clocked"; Date) { }
        field(23; "Date Reported"; Date)
        {
            CalcFormula = lookup("Project Support"."Reported Date" where("Entry No" = field("Support Entry No"),
                                                                          "Project No" = field("Project No")));
            FieldClass = FlowField;
        }
        field(24; "Cust No"; Code[20])
        {
            CalcFormula = lookup(Projects."Customer No" where(No = field("Project No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Project No", "Project Activity", "Staff No", "Support Entry No", "Project Module")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        Status := Status::Open;
        "Date Clocked" := Today;
    end;
}

