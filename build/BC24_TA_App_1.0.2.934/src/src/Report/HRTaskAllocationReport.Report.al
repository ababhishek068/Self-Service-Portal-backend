Report 50067 "HR-Task Allocation Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR-Task Allocation Report.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(UnknownTable50072; "HR-Employee")
        {
            DataItemTableView = where(Status = filter(Active));
            column(ReportForNavId_1; 1) { }
            column(No_HREmployee; "No.") { }
            column(Name; Name) { }
            column(Open; Open) { }
            column(Pending; Pending) { }
            column(Closed; Closed) { }
            column(Implementation; Implementation) { }
            column(ComImg; CompanyInfo.Picture) { }
            column(Ogoing; Ogoing) { }

            trigger OnAfterGetRecord()
            var
                HREmployee: Record "HR-Employee";
                ProjectTaskAllocation: Record "Project Task Allocation";
                ProjectTeam: Record "Project Team";
            begin
                HREmployee.Get("No.");
                Name := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";

                Open := 0;
                Pending := 0;
                Closed := 0;
                Implementation := 0;
                Ogoing := 0;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::Open);
                ProjectTaskAllocation.SetRange("Consoltant Status", ProjectTaskAllocation."consoltant status"::Assigned);
                if ProjectTaskAllocation.Find('-') then Open := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::"On-Going");
                ProjectTaskAllocation.SetRange("Consoltant Status", ProjectTaskAllocation."consoltant status"::Assigned);
                if ProjectTaskAllocation.Find('-') then Ogoing := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::"Pending Confirmation");
                ProjectTaskAllocation.SetRange("Consoltant Status", ProjectTaskAllocation."consoltant status"::Assigned);
                if ProjectTaskAllocation.Find('-') then Pending := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Staff No", "No.");
                ProjectTaskAllocation.SetRange("Consoltant Status", ProjectTaskAllocation."consoltant status"::Assigned);
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::Closed);
                if ProjectTaskAllocation.Find('-') then Closed := ProjectTaskAllocation.Count;

                ProjectTeam.Reset;
                ProjectTeam.SetRange("Team Member", "No.");
                ProjectTeam.SetRange("Project Status", ProjectTeam."project status"::Ongoing);
                if ProjectTeam.Find('-') then Implementation := ProjectTeam.Count;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        Name: Text;
        Open: Integer;
        Pending: Integer;
        Closed: Integer;
        Implementation: Integer;
        CompanyInfo: Record "Company Information";
        Ogoing: Integer;
}

