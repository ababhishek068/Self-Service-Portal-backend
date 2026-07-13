Report 50069 "Projects Status Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Projects Status Report.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Projects; Projects)
        {
            DataItemTableView = sorting("Customer Name") order(ascending) where("Customer Name" = filter(<> ''), Status = filter(<> Suspended));
            column(ReportForNavId_1; 1) { }
            column(No_Projects; Projects.No) { }
            column(CustomerNo_Projects; Projects."Customer No") { }
            column(ProjectType_Projects; Projects."Project Type") { }
            column(StartDate_Projects; Projects."Start Date") { }
            column(EndDate_Projects; Projects."End Date") { }
            column(Status_Projects; Projects.Status) { }
            column(CustomerName_Projects; Projects."Customer Name") { }
            column(ProjectDescription_Projects; Projects."Project Description") { }
            column(ProjectStatusSummary_Projects; Projects."Project Status Summary") { }
            column(Counter; i) { }
            column(ComImg; CompanyInfo.Picture) { }
            dataitem("Project Task"; "Project Task")
            {
                DataItemLink = "Project No" = field(No);
                column(ReportForNavId_11; 11) { }
                column(ProjectNo_ProjectTask; "Project Task"."Project No") { }
                column(ActivityCode_ProjectTask; "Project Task"."Activity Code") { }
                column(StartDate_ProjectTask; "Project Task"."Start Date") { }
                column(EndDate_ProjectTask; "Project Task"."End Date") { }
                column(Status_ProjectTask; "Project Task".Status) { }
                column(Remarks_ProjectTask; "Project Task".Remarks) { }
            }

            trigger OnAfterGetRecord()
            begin
                i := i + 1;
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
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        i := 0;
    end;

    var
        i: Integer;
        CompanyInfo: Record "Company Information";
}

