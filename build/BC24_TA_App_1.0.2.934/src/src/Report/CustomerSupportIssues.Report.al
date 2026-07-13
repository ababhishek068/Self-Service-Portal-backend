Report 50068 "Customer Support Issues"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer Support Issues.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Projects; Projects)
        {
            DataItemTableView = where("Customer No" = filter(<> ''));
            RequestFilterFields = "Customer No", "Project Type";
            column(ReportForNavId_1; 1) { }
            column(CustomerNo_Projects; Projects."Customer No") { }
            column(ProjectType_Projects; Projects."Project Type") { }
            column(CustomerName_Projects; Projects."Customer Name") { }
            column(ComImg; CompanyInfo.Picture) { }
            column(Open; Open) { }
            column(Pending; Pending) { }
            column(Closed; Closed) { }
            column(ReportTitle; ReportTitle) { }

            trigger OnAfterGetRecord()
            var
                ProjectTaskAllocation: Record "Project Task Allocation";
            begin
                if ReportTitle = '' then begin
                    if Projects."Project Type" = Projects."project type"::Implementation then ReportTitle := 'CUSTOMER IMPLEMENTATION SUPPORT SUMMARY REPORT';
                    if Projects."Project Type" = Projects."project type"::Support then ReportTitle := 'CUSTOMER SUPPORT SUMMARY REPORT';
                end;
                Open := 0;
                Pending := 0;
                Closed := 0;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Project No", Projects.No);
                ProjectTaskAllocation.SetFilter(Status, '%1|%2', ProjectTaskAllocation.Status::Open, ProjectTaskAllocation.Status::"On-Going");
                if ProjectTaskAllocation.Find('-') then Open := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Project No", Projects.No);
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::"Pending Confirmation");
                if ProjectTaskAllocation.Find('-') then Pending := ProjectTaskAllocation.Count;

                ProjectTaskAllocation.Reset;
                ProjectTaskAllocation.SetRange("Project No", Projects.No);
                ProjectTaskAllocation.SetRange(Status, ProjectTaskAllocation.Status::Closed);
                if ProjectTaskAllocation.Find('-') then Closed := ProjectTaskAllocation.Count;
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

    trigger OnInitReport()
    begin
        ReportTitle := '';
    end;

    var
        Open: Integer;
        Pending: Integer;
        Closed: Integer;
        CompanyInfo: Record "Company Information";
        ReportTitle: Text;
}

