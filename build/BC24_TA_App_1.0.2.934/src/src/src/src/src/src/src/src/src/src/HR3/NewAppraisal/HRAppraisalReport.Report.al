Report 50119 "HR Appraisal Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRAppraisalReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Appraisal Header"; "HR Appraisal Header - UP")
        {
            RequestFilterFields = "Appraisal No";
            column(ReportForNavId_1; 1) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

