Report 50159 "PR Variance Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRVarianceAnalysis.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HR Employees"; "HR-Employee")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code";
            column(ReportForNavId_1; 1) { }
            column(FullName_HREmployees; "HR Employees"."Full Name") { }
            column(No_HREmployees; "HR Employees"."No.") { }
            column(GlobalDimension1Code_HREmployees; "HR Employees"."Global Dimension 1 Code") { }
            column(GlobalDimension2Code_HREmployees; "HR Employees"."Global Dimension 2 Code") { }
            column(PeriodFilter; PeriodFilter) { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoAddress; CompInfo.Address) { }
            column(CompInfoCity; CompInfo.City) { }
            column(CompInfoPicture; CompInfo.Picture) { }
            column(CompInfoEMail; CompInfo."E-Mail") { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(PeriodName; PeriodName) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(AppliedFilters; AppliedFilters) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        CompInfo: Record "Company Information";
        PeriodFilter: Date;
        PeriodName: Text[30];
        AppliedFilters: Text;
}

