Table 50122 "Client Support Visits"
{

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Project No"; Code[20])
        {

            trigger OnValidate()
            var
                Project: Record Projects;
            begin
                Project.Reset;
                Project.SetRange(No, "Project No");
                if Project.Find('-') then
                    Client := Project."Customer Name";
            end;
        }
        field(3; Client; Text[100]) { }
        field(4; "Date Created"; Date) { }
        field(5; "Staff No"; Code[20])
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
        field(6; "Staff Name"; Text[100]) { }
        field(7; Claimed; Boolean)
        {
            Editable = false;
        }
        field(8; "Date of Visit"; Date) { }
        field(9; Status; Option)
        {
            OptionCaption = ' Open,Claimed';
            OptionMembers = " Open",Claimed;
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
}

