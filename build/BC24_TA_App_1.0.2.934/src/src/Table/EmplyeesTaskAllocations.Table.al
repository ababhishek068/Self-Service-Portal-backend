Table 50132 "Emplyees Task Allocations"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = "Task Allocation Setup".Code;
        }
        field(2; Client; Code[20])
        {
            TableRelation = Projects.No;
        }
        field(3; "Client Name"; Text[100])
        {
            CalcFormula = lookup(Projects."Customer Name" where(No = field(Client)));
            FieldClass = FlowField;
        }
        field(4; Task; Text[100]) { }
        field(5; Source; Option)
        {
            OptionCaption = ' ,Support Desk,Client,Implementation';
            OptionMembers = " ","Support Desk",Client,Implementation;
        }
        field(6; "Current Status"; Option)
        {
            OptionCaption = ' ,Pending,On-going,Pending Client Confirmation';
            OptionMembers = " ",Pending,"On-going","Pending Client Confirmation";
        }
        field(7; "Start Date"; Date) { }
        field(8; "Completion Date"; Date) { }
        field(9; "Staff No"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            var
                HREmployee: Record "HR-Employee";
            begin
                HREmployee.Get("Staff No");
                "Staff Name" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";
            end;
        }
        field(10; "Staff Name"; Text[100]) { }
        field(11; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(12; "Date Created"; Date) { }
        field(13; Archived; Boolean) { }
        field(14; "Date Archived"; Date) { }
        field(15; "Archived By"; Code[30])
        {
            TableRelation = User."User Name";
        }
    }

    keys
    {
        key(Key1; "Code", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

