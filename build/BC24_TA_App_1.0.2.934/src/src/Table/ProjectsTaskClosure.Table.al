Table 50263 "Projects Task Closure"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Task Entry No"; Integer)
        {
            TableRelation = "Project Task Allocation"."Support Entry No";
        }
        field(3; "Closure Type"; Option)
        {
            OptionCaption = ' ,Complete,Transfer,Suspended';
            OptionMembers = " ",Complete,Transfer,Suspended;
        }
        field(4; "Approval Status"; Option)
        {
            OptionCaption = ' ,Open,Pending Approval,Approved';
            OptionMembers = " ",Open,"Pending Approval",Approved;
        }
        field(5; "Request Date"; Date) { }
        field(6; "Approval Date"; Date) { }
        field(7; "Approved By"; Code[20]) { }
        field(8; "Staff No"; Code[20])
        {

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
        field(9; "Staff Remarks"; Text[200]) { }
        field(10; Status; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;

            trigger OnValidate()
            begin
                if Status = Status::Approved then "Approval Status" := "approval status"::Approved;
                if Status = Status::Rejected then "Approval Status" := "approval status"::Open;
            end;
        }
        field(11; "Client Response"; Option)
        {
            OptionCaption = ' ,Confirmed,Non Response,Declined';
            OptionMembers = " ",Confirmed,"Non Response",Declined;
        }
        field(12; "Client Remarks"; Text[200]) { }
        field(13; "Project No"; Code[20])
        {
            CalcFormula = lookup("Project Task Allocation"."Project No" where("Support Entry No" = field("Task Entry No")));
            FieldClass = FlowField;
        }
        field(14; Customer; Text[100])
        {
            CalcFormula = lookup(Projects."Customer Name" where(No = field("Project No")));
            FieldClass = FlowField;
        }
        field(15; "Staff Name"; Text[100]) { }
        field(16; "Support Issue Description"; Text[250])
        {
            CalcFormula = lookup("Project Support"."Issue Description" where("Entry No" = field("Task Entry No")));
            FieldClass = FlowField;
        }
        field(17; "Project Type"; Option)
        {
            CalcFormula = lookup(Projects."Project Type" where(No = field("Project No")));
            FieldClass = FlowField;
            OptionCaption = ' ,Implementation,Support';
            OptionMembers = " ",Implementation,Support;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete entries');
    end;
}

